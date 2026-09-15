import glob
import os
import sys

import yaml

bad = 0
for f in sorted(glob.glob('skills/*/SKILL.md')):
    f = f.replace(os.sep, '/')
    lines = open(f, encoding='utf-8-sig').read().splitlines()
    if not lines or lines[0].strip() != '---':
        print('NO-FRONTMATTER', f)
        bad += 1
        continue
    end = next(i for i, l in enumerate(lines[1:], 1) if l.strip() == '---')
    try:
        d = yaml.safe_load('\n'.join(lines[1:end]))
    except Exception as e:
        print('YAML-FAIL', f, str(e)[:70])
        bad += 1
        continue
    folder = f.split('/')[1]
    name_ok = d.get('name') == folder
    desc = d.get('description', '')
    print('%-6s %-44s name=%-6s desc=%d' % ('OK' if name_ok and len(desc) < 1024 else 'CHECK',
                                            f, 'ok' if name_ok else 'MISMATCH', len(desc)))
    if not name_ok or len(desc) >= 1024:
        bad += 1

print('failures:', bad)
sys.exit(1 if bad else 0)
