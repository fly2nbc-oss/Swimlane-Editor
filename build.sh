#!/usr/bin/env bash
# Builds a single self-contained HTML file (works offline) from src/app.html and vendor libraries.
set -euo pipefail
cd "$(dirname "$0")"
# On Windows "python3" may be the Microsoft Store alias; fall back to "python".
PY=python3
"$PY" -c '' 2>/dev/null || PY=python
"$PY" - <<'PY'
import json, re, sys
src = open('src/app.html', encoding='utf-8', newline='').read()
libs = ''
for f in ['vendor/jspdf.umd.min.js', 'vendor/svg2pdf.umd.min.js']:
    js = open(f, encoding='utf-8', newline='').read().replace('</script', r'<\/script')
    libs += '<script>\n' + js + '\n</script>\n'

# The AI guide is offered for download in the help dialog. Its complete example must be
# the example file, so the guide and docs/examples never drift apart.
guide = open('docs/AI-DIAGRAMS.md', encoding='utf-8', newline='').read()
m = re.search(r'### Complete example\n.*?```json\n(.*?)\n```', guide, re.S)
example = json.load(open('docs/examples/leave-request-simple.json', encoding='utf-8'))
if not m or json.loads(m.group(1)) != example:
    sys.exit('docs/AI-DIAGRAMS.md: the JSON under "### Complete example" must equal docs/examples/leave-request-simple.json')
if '</script' in guide.lower():
    sys.exit('docs/AI-DIAGRAMS.md must not contain "</script"')
guide_tag = '<script type="text/markdown" id="aiGuide">\n' + guide + '</script>'

for marker in ['<!--LIBS-->', '<!--AI-GUIDE-->']:
    if src.count(marker) != 1:
        sys.exit(f'src/app.html must contain {marker} exactly once')
out = src.replace('<!--LIBS-->', libs, 1).replace('<!--AI-GUIDE-->', guide_tag, 1)
# newline='' keeps LF line endings on every platform.
open('swimlane-editor.html', 'w', encoding='utf-8', newline='').write(out)
PY
echo "Built swimlane-editor.html"
