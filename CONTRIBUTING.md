# Contributing

Thank you for helping improve **Swimlane Editor**.

## Prerequisites

1. A shell that runs `bash` (Linux, macOS; on Windows [Git Bash](https://git-scm.com/downloads))
2. [Python 3](https://www.python.org/) as `python3` or `python` – only for `build.sh`
3. Chrome or Edge to try the result
4. Optional, for automated checks: [Playwright for Python](https://playwright.dev/python/) (`pip install playwright && playwright install chromium`) and `pdftoppm` from Poppler

There are no npm packages and nothing to install for the app itself.

## Getting started

```bash
git clone https://github.com/fly2nbc-oss/Swimlane-Editor.git
cd Swimlane-Editor
./build.sh
```

Then open `swimlane-editor.html` in Chrome or Edge.

## How the code is laid out

| Path | Purpose |
|---|---|
| `src/app.html` | **The source.** All HTML, CSS and JavaScript in one file. Edit this. |
| `vendor/` | jsPDF 2.5.2 and svg2pdf.js 2.2.4 (MIT), inlined at build time |
| `build.sh` | Writes `swimlane-editor.html` = `src/app.html` with the vendor scripts inlined at `<!--LIBS-->` and the AI guide (`docs/AI-DIAGRAMS.md`, downloadable from the help) at `<!--AI-GUIDE-->` |
| `swimlane-editor.html` | **Build output**, the file users open. Never edit it by hand. |
| `docs/` | Spec for generating diagrams with AI, and example diagrams |
| `packaging/windows/` | `install.cmd`, `uninstall.cmd` and the icon for the Windows installer ZIP |

[`AGENTS.md`](./AGENTS.md) describes the architecture in more detail: the data model, the main parts of `src/app.html`, and the working rules.

## Rules

- The app stays **one offline file**: no CDN, no network calls, no runtime dependencies. External libraries come in only through `vendor/` and `build.sh`, with a license compatible with Apache-2.0, listed in [`THIRD_PARTY.md`](./THIRD_PARTY.md) and [`NOTICE`](./NOTICE).
- The UI is in English.
- No company names or branding in code, defaults or examples.
- Do not break the file formats: older `.drawio` and JSON files must still open.
- Every change to a diagram goes through `pushUndo()` then `changed()`, or `mutate(fn)`, so undo, autosave and the "unsaved" marker keep working.

## Checking your build

```bash
./build.sh
git diff --exit-code swimlane-editor.html   # the committed build output matches the source
```

CI runs exactly this. Always commit `src/app.html` and the rebuilt `swimlane-editor.html` together.

There is no test framework in the repository. What has proven itself is a short Playwright (Chromium) script that opens `swimlane-editor.html`, clicks and drags, exports, and checks:

- no `pageerror` in the console
- the PDF, turned into PNG with `pdftoppm` and looked at
- the `.drawio` round trip: save, open again, compare lanes, phases, nodes and edges
- `Ctrl+S` writing to the same file, with `window.showSaveFilePicker` mocked

## Continuous Integration

[`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs on pushes and pull requests to **`main`** and on `v*` tags:

- **Build** – runs `./build.sh` and fails when `swimlane-editor.html` differs from the committed one, or when `src/app.html` contains a network URL.
- **Lint workflows** – `actionlint` and `zizmor` check the workflow files.
- **Release** (`v*` tags only) – checks the tag against `APP_VERSION` and `CHANGELOG.md`, zips `packaging/windows/` with `swimlane-editor.html` into the Windows installer, attests where the files were built, and drafts a GitHub release with them.

Dependabot proposes updates of the pinned actions once a month.

## Pull requests

- Keep changes focused on one concern where possible.
- Describe **what** changed and **why** in the PR description.
- For UI changes, attach screenshots when practical.
- Rebuild `swimlane-editor.html`, and try the change in Chrome or Edge.

## Code of conduct

Participants are expected to follow our [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).

## License

By contributing, you agree that your contributions are licensed under the project’s [Apache-2.0 license](./LICENSE).
