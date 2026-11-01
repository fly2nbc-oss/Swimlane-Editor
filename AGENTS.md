# Instructions for coding agents

Swimlane Editor is a single-page swimlane process editor: vanilla JavaScript in one HTML file, no framework, no npm dependencies at runtime. Human contributors find the build and check steps in `CONTRIBUTING.md`.

## Standards

This project follows the latest versions of two documents in the parent folder
(outside this repository): `repo_standard_v*.md` (setup, docs, CI, release) and
`ui_design_system_v*.md` (UI, where the project has one). Read them before changing
those areas; where this file says something different, this file wins.

## Rules

- UI and docs in English. The app stays a single offline file: no CDN, no network calls (CI checks `src/app.html` for URLs).
- External libraries only via `vendor/` + `build.sh`, with a license compatible with Apache-2.0, listed in `THIRD_PARTY.md` and `NOTICE`.
- No company names or branding in code, defaults or examples.
- Do not break the file formats: old `.drawio` and JSON files must still open.
- Opened files are untrusted: every diagram passes `harden()` (ids, colours, types, sides) on import and on load; text goes through `esc()` before it reaches HTML.
- Every edit to the diagram goes through `pushUndo()` then `changed()`, or `mutate(fn)`, so undo, autosave and the "unsaved" marker keep working.

## Commands

```bash
./build.sh                                   # src/app.html + vendor/ -> swimlane-editor.html
git diff --exit-code swimlane-editor.html    # what CI checks: build output matches the source
```

Then open `swimlane-editor.html` in Chrome or Edge. Commit `src/app.html` and `swimlane-editor.html` together.

## Files

| Path | Purpose |
|---|---|
| `src/app.html` | **The source.** All HTML, CSS and JS. Edit this. |
| `vendor/` | jsPDF 2.5.2 and svg2pdf.js 2.2.4 (MIT), inlined at `<!--LIBS-->` |
| `swimlane-editor.html` | **Build output**, the file users open. Never edit by hand. |
| `docs/AI-DIAGRAMS.md`, `docs/examples/` | JSON spec for AI-generated diagrams; examples with and without coordinates |
| `screenshots/` | README screenshot, made from `docs/examples/leave-request-simple.json` |
| `.github/` | CI, Dependabot, issue forms |

## Data model (one diagram)

```js
{ id, title, owner, version, status, description, created, updated, width,
  lanes:  [{ id, name, height }],            // top to bottom
  phases: [{ id, name, width }],             // left to right, optional
  nodes:  [{ id, type, x, y, w, h, text, color? }],
  edges:  [{ id, from, to, label, type, fromSide, toSide }],
  fileName?, fileDirty?, foreign? }          // runtime state, not exported
```

- Coordinates: pool starts at (0,0). Header columns `POOL_HDR` 32 + `LANE_HDR` 36, content starts at `CX` = 68. Phase header row above the pool at y = -28 (`PHASE_HDR`).
- A node belongs to the lane that contains its center y. Lane and phase moves keep nodes relative (`laneRelative` / `phaseRelative`).
- Node types: `TYPES`. Edge types: `flow`, `message`, `assoc`. Sides: `auto`, `right`, `left`, `top`, `bottom`.

## Main parts of src/app.html (search for the `/* ===` comments)

- **store**: `localStorage` key `swimlane-editor.v1` = working copy of all diagrams plus settings (logo, company, sidebar state).
- **geometry**: lanes, phases, `route()` = orthogonal edge routing, `autoSides()`.
- **rendering**: `diagramMarkup(d, {interactive})` builds SVG as a string, used for canvas, SVG export and PDF alike.
- **canvas interaction**: pointer events with drag modes (`move`, `resize`, `connect`, `lane`, `phase`, `poolw`, `box`); own double-click detection because the SVG is re-rendered between clicks.
- **right panel**: `renderPanel()` per selection (edge, single node, multi, diagram).
- **keyboard**: keys follow Cerno where the meaning matches. `SHORTCUTS` also drives the help dialog (`H`).
- **draw.io**: `drawioDiagram()` writes `<object>` cells with `swl*` properties so files round-trip; `parseDrawio()` / `modelToDiagram()` read them back, including compressed files and pools drawn in draw.io.
- **files**: File System Access API; handles in IndexedDB (`swimlane-editor` / `handles`) so Ctrl+S writes to the same file. Fallback: download.
- **import**: `validate()` normalises JSON and draw.io diagrams, then `harden()`.
- **automatic layout**: `autoLayout(d, hints)`: loops broken by DFS, columns by longest path over flow edges, phases kept in order, extra rows for parallel branches, artifacts below their step. Used by Arrange (`L`) and on JSON import without `x`/`y` (hints `lane`, `phase`, `col`).
- **PDF**: `exportPDF(d, multi)`; `pdfFrame()` draws header and footer; multi-page splits at phase borders or gaps (`pageSegments()`).

## Tests

No test framework in the repo. Playwright (Python, `channel="msedge"` uses the installed Edge) scripts that open `swimlane-editor.html` and check:
- no `pageerror`
- `.drawio` round trip: save (mock `window.showSaveFilePicker`), open again, compare lanes, phases, nodes, edges
- crafted files (ids or colours with `"><img onerror=…>`) run no script
- PDF via `pdftoppm` to PNG, looked at

## Release

1. Set `APP_VERSION` in `src/app.html` (help dialog, PDF properties), add `## [x.y.z] – date` to `CHANGELOG.md`, rebuild, commit, push, wait for green CI.
2. Tag `vx.y.z` only when the owner says so. CI checks tag = `APP_VERSION` and the changelog section, attests the files and drafts the release.
3. Check the draft, then `gh release edit vx.y.z --draft=false --latest`. Releases are immutable once published.

## Gotchas

- `build.sh` on Windows: Git Bash; it falls back from `python3` (often the Store alias) to `python` and writes LF.
- Pushing changes to `.github/workflows/` needs a token with the `workflow` scope (`gh auth refresh -s workflow`; push with `gh` as credential helper).
