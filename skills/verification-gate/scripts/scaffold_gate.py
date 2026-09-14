#!/usr/bin/env python3
"""verification-gate - scaffolder.

Creates the verification folder next to an artifact you are about to ship:

    <artifact-dir>/_VERIFICATION/
      claim_manifest.csv        (header only - you fill one row per checkable assertion)
      verification_report.md    (per-claim blocks + human sign-off table)
      saved_sources/            (save + hash every cited source here)

Non-interactive; prints a JSON summary to stdout. Refuses to overwrite without --force.

Usage:
    python scaffold_gate.py --artifact <path-to-draft> [--out <dir>] [--force]
"""
from __future__ import annotations

import argparse
import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

ASSETS = Path(__file__).resolve().parent.parent / "assets"


def _log(msg: str) -> None:
    print(f"[verification-gate] {msg}", file=sys.stderr, flush=True)


def main() -> int:
    ap = argparse.ArgumentParser(description="Scaffold a _VERIFICATION folder for an artifact")
    ap.add_argument("--artifact", type=Path, required=True, help="path to the draft being verified")
    ap.add_argument("--out", type=Path, help="verification dir (default: <artifact-dir>/_VERIFICATION)")
    ap.add_argument("--force", action="store_true", help="overwrite existing manifest/report")
    args = ap.parse_args()

    artifact = args.artifact
    out = args.out or (artifact.parent / "_VERIFICATION")
    out.mkdir(parents=True, exist_ok=True)
    (out / "saved_sources").mkdir(exist_ok=True)

    manifest = out / "claim_manifest.csv"
    report = out / "verification_report.md"
    created, skipped = [], []

    # manifest (copy header template)
    if manifest.exists() and not args.force:
        skipped.append(str(manifest))
    else:
        tpl = ASSETS / "claim_manifest.template.csv"
        if tpl.is_file():
            shutil.copyfile(tpl, manifest)
        else:  # fallback header if assets missing
            manifest.write_text(
                "claim_id,claim_type,claim_text,source_url,local_source_path,sha256,status,notes\n",
                encoding="utf-8",
            )
        created.append(str(manifest))

    # report (fill template placeholders)
    if report.exists() and not args.force:
        skipped.append(str(report))
    else:
        tpl = ASSETS / "verification_report.template.md"
        stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        if tpl.is_file():
            body = tpl.read_text(encoding="utf-8")
            body = body.replace("{{ARTIFACT}}", str(artifact)).replace("{{DATE}}", stamp)
        else:
            body = f"# Verification report\n\nArtifact: {artifact}\nDate: {stamp}\n"
        report.write_text(body, encoding="utf-8")
        created.append(str(report))

    summary = {
        "verification_dir": str(out),
        "artifact": str(artifact),
        "created": created,
        "skipped_existing": skipped,
        "next": [
            "Add one claim_manifest.csv row per checkable assertion (quote/number/fact/citation/claim).",
            "Save + hash each source into saved_sources/ and record local_source_path + sha256.",
            "Run the three checks; write per-claim blocks + status in verification_report.md.",
            "Human sign-off every row (PASS/REWRITE/REMOVE/UNVERIFIED).",
            "python gate_runner.py --dir '%s' --verify-hashes" % out,
        ],
    }
    print(json.dumps(summary, indent=2))
    _log(f"scaffolded {out} ({len(created)} created, {len(skipped)} skipped)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
