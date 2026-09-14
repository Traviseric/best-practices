#!/usr/bin/env python3
"""verification-gate - deterministic gatekeeper.

This is a GATEKEEPER, not a verifier. It cannot read your sources or judge whether a
claim is true. It enforces that the verification PROCESS is complete before an artifact
ships: a claim manifest + report exist, every row is PASS, every cited source file is
actually saved, and (optionally) every recorded SHA-256 matches the saved file.

A green run on a dishonest report is still a failure - substance is enforced by the
three checks + human sign-off + blind cross-check (see the SKILL.md references). This
script only guarantees nobody skipped the process or shipped on a non-PASS row.

Manifest: <dir>/claim_manifest.csv with header:
    claim_id,claim_type,claim_text,source_url,local_source_path,sha256,status,notes
Report:   <dir>/verification_report.md must exist and be non-trivial.

Statuses (see references/02-honesty-and-status-language.md): only PASS ships; any of
REWRITE / REMOVE / UNVERIFIED / BLOCKED / PENDING (or blank/unknown) blocks.

Usage:
    python gate_runner.py --dir <artifact-dir>/_VERIFICATION [--verify-hashes]
    python gate_runner.py --self-test

Exit codes: 0 = gate PASS, 1 = gate BLOCKED, 2 = structural ERROR (missing files).
Prints a JSON verdict to stdout; diagnostics to stderr.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import sys
import tempfile
from pathlib import Path

REQUIRED_COLUMNS = [
    "claim_id", "claim_type", "claim_text", "source_url",
    "local_source_path", "sha256", "status", "notes",
]
PASS = "PASS"
# Everything that is NOT a clean PASS blocks the release.
BLOCKING_STATUSES = {"REWRITE", "REMOVE", "UNVERIFIED", "BLOCKED", "PENDING", ""}


def _log(msg: str) -> None:
    print(f"[verification-gate] {msg}", file=sys.stderr, flush=True)


def _sha256(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def evaluate(vdir: Path, verify_hashes: bool = False) -> dict:
    """Pure evaluation of a _VERIFICATION dir. Returns a verdict dict."""
    result: dict = {
        "dir": str(vdir),
        "gate": "ERROR",
        "total_rows": 0,
        "pass_rows": 0,
        "blocked": [],
        "errors": [],
    }
    manifest = vdir / "claim_manifest.csv"
    report = vdir / "verification_report.md"

    if not vdir.is_dir():
        result["errors"].append(f"verification dir not found: {vdir}")
        return result
    if not manifest.is_file():
        result["errors"].append("claim_manifest.csv missing")
    if not report.is_file():
        result["errors"].append("verification_report.md missing")
    elif report.stat().st_size < 20:
        result["errors"].append("verification_report.md is empty/trivial")
    if result["errors"]:
        return result

    with open(manifest, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        missing_cols = [c for c in REQUIRED_COLUMNS if c not in (reader.fieldnames or [])]
        if missing_cols:
            result["errors"].append(f"manifest missing columns: {missing_cols}")
            return result
        rows = list(reader)

    result["total_rows"] = len(rows)
    if not rows:
        result["errors"].append("claim_manifest.csv has no claim rows (nothing verified)")
        return result

    for i, row in enumerate(rows, 1):
        cid = (row.get("claim_id") or f"row{i}").strip()
        status = (row.get("status") or "").strip().upper()
        src = (row.get("local_source_path") or "").strip()
        sha = (row.get("sha256") or "").strip().lower()
        reasons = []

        if status != PASS:
            reasons.append(f"status={status or 'BLANK'} (not PASS)")
        if not src:
            reasons.append("no local_source_path (leads != proof)")
        else:
            src_path = (vdir / src) if not Path(src).is_absolute() else Path(src)
            if not src_path.is_file():
                reasons.append(f"source file not found: {src}")
            elif verify_hashes and sha:
                actual = _sha256(src_path)
                if actual != sha:
                    reasons.append(f"sha256 mismatch (recorded {sha[:12]}..., file {actual[:12]}...)")
        if not sha:
            reasons.append("no sha256 recorded")

        if reasons:
            result["blocked"].append({"claim_id": cid, "status": status or "BLANK", "reasons": reasons})
        else:
            result["pass_rows"] += 1

    result["gate"] = "PASS" if not result["blocked"] else "BLOCKED"
    return result


def _exit_code(verdict: dict) -> int:
    if verdict["gate"] == "PASS":
        return 0
    if verdict["gate"] == "BLOCKED":
        return 1
    return 2


def _self_test() -> int:
    """Build passing + failing fixtures and assert the gate behaves correctly."""
    ok = True
    with tempfile.TemporaryDirectory() as td:
        base = Path(td)
        # --- Fixture A: one PASS row with a real saved+hashed source -> expect PASS
        a = base / "A" / "_VERIFICATION"
        (a / "saved_sources").mkdir(parents=True)
        src = a / "saved_sources" / "src1.txt"
        src.write_text("The award amount was $44,000.00 on 2026-06-24.", encoding="utf-8")
        sha = _sha256(src)
        (a / "verification_report.md").write_text(
            "# Verification report\n\nclaim-1: quote located verbatim; source supports; current.\n",
            encoding="utf-8",
        )
        with open(a / "claim_manifest.csv", "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow(REQUIRED_COLUMNS)
            w.writerow(["claim-1", "number", "$44,000.00", "https://x", "saved_sources/src1.txt", sha, "PASS", ""])
        va = evaluate(a, verify_hashes=True)
        if va["gate"] != "PASS":
            _log(f"SELF-TEST FAIL: clean fixture should PASS, got {va['gate']} {va.get('blocked')}")
            ok = False

        # --- Fixture B: adds an UNVERIFIED row + a PASS row missing its source -> expect BLOCKED (2 rows)
        b = base / "B" / "_VERIFICATION"
        (b / "saved_sources").mkdir(parents=True)
        src2 = b / "saved_sources" / "src2.txt"
        src2.write_text("real text", encoding="utf-8")
        (b / "verification_report.md").write_text("# Verification report\n\nblocks expected.\n", encoding="utf-8")
        with open(b / "claim_manifest.csv", "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow(REQUIRED_COLUMNS)
            w.writerow(["claim-1", "quote", "ok", "u", "saved_sources/src2.txt", _sha256(src2), "PASS", ""])
            w.writerow(["claim-2", "fact", "guessed", "u", "", "", "UNVERIFIED", "no source"])
            w.writerow(["claim-3", "quote", "sourced?", "u", "saved_sources/missing.txt", "abc", "PASS", ""])
        vb = evaluate(b, verify_hashes=True)
        blocked_ids = {x["claim_id"] for x in vb["blocked"]}
        if vb["gate"] != "BLOCKED" or blocked_ids != {"claim-2", "claim-3"}:
            _log(f"SELF-TEST FAIL: expected BLOCKED on claim-2,claim-3; got {vb['gate']} {blocked_ids}")
            ok = False

        # --- Fixture C: hash mismatch caught only with --verify-hashes
        c = base / "C" / "_VERIFICATION"
        (c / "saved_sources").mkdir(parents=True)
        src3 = c / "saved_sources" / "src3.txt"
        src3.write_text("content", encoding="utf-8")
        (c / "verification_report.md").write_text("# report\n\nhash test.\n", encoding="utf-8")
        with open(c / "claim_manifest.csv", "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow(REQUIRED_COLUMNS)
            w.writerow(["claim-1", "fact", "x", "u", "saved_sources/src3.txt", "deadbeef", "PASS", ""])
        if evaluate(c, verify_hashes=False)["gate"] != "PASS":
            _log("SELF-TEST FAIL: wrong hash should pass WITHOUT --verify-hashes")
            ok = False
        if evaluate(c, verify_hashes=True)["gate"] != "BLOCKED":
            _log("SELF-TEST FAIL: wrong hash should BLOCK WITH --verify-hashes")
            ok = False

    print(json.dumps({"self_test": "ok" if ok else "FAILED"}, indent=2))
    return 0 if ok else 1


def main() -> int:
    ap = argparse.ArgumentParser(description="verification-gate deterministic gatekeeper")
    ap.add_argument("--dir", type=Path, help="the _VERIFICATION folder to gate")
    ap.add_argument("--verify-hashes", action="store_true", help="recompute + compare each source SHA-256")
    ap.add_argument("--self-test", action="store_true", help="run built-in fixtures and exit")
    args = ap.parse_args()

    if args.self_test:
        return _self_test()
    if not args.dir:
        ap.error("--dir is required (or use --self-test)")

    verdict = evaluate(args.dir, verify_hashes=args.verify_hashes)
    print(json.dumps(verdict, indent=2))
    if verdict["gate"] == "PASS":
        _log(f"GATE PASS - {verdict['pass_rows']}/{verdict['total_rows']} rows verified")
    elif verdict["gate"] == "BLOCKED":
        _log(f"GATE BLOCKED - {len(verdict['blocked'])} row(s) not shippable; DO NOT release")
    else:
        _log(f"GATE ERROR - {verdict['errors']}")
    return _exit_code(verdict)


if __name__ == "__main__":
    raise SystemExit(main())
