#!/usr/bin/env bash
# Builds a single self-contained HTML file (works offline) from src/app.html and vendor libraries.
set -euo pipefail
cd "$(dirname "$0")"
# On Windows "python3" may be the Microsoft Store alias; fall back to "python".
PY=python3
"$PY" -c '' 2>/dev/null || PY=python
"$PY" - <<'PY'
src = open('src/app.html', encoding='utf-8', newline='').read()
libs = ''
for f in ['vendor/jspdf.umd.min.js', 'vendor/svg2pdf.umd.min.js']:
    js = open(f, encoding='utf-8', newline='').read().replace('</script', r'<\/script')
    libs += '<script>\n' + js + '\n</script>\n'
# newline='' keeps LF line endings on every platform.
open('swimlane-editor.html', 'w', encoding='utf-8', newline='').write(src.replace('<!--LIBS-->', libs, 1))
PY
echo "Built swimlane-editor.html"
