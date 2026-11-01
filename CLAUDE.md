# Swimlane Editor: notes for AI-assisted development

Single-page swimlane process editor. Vanilla JavaScript, no framework, no npm dependencies at runtime.

## Files

| Path | Purpose |
|---|---|
| `src/app.html` | **The source.** All HTML, CSS and JS in one file. Edit this. |
| `vendor/` | jsPDF 2.5.2 and svg2pdf.js 2.2.4 (MIT), inlined at build time |
| `build.sh` | Creates `swimlane-editor.html` = `src/app.html` with the vendor scripts inlined at `<!--LIBS-->` |
| `swimlane-editor.html` | **Build output**, the file users open. Do not edit by hand. |
| `docs/AI-DIAGRAMS.md` | Spec for generating diagrams with AI (JSON format and layout rules) |
| `docs/examples/` | Example diagrams (JSON): with coordinates and without (auto layout) |
| `LICENSE`, `NOTICE`, `THIRD_PARTY.md` | Apache-2.0 for this project, notices for bundled MIT libraries |
| `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md` | Public docs, same layout as the other fly2nbc-oss tools (Cerno) |
| `.github/` | CI (`ci.yml`: build + check that `swimlane-editor.html` is up to date; `v*` tag drafts a release) and issue templates |

After every change: run `./build.sh` (Git Bash on Windows; it finds `python3` or `python` and writes LF), then open `swimlane-editor.html` in Chrome or Edge. Commit `src/app.html` and `swimlane-editor.html` together: CI fails when they differ.

Releases: add a `## [x.y.z] – date` section to `CHANGELOG.md` (Keep a Changelog), then tag `vx.y.z` only when the owner says so; CI drafts the release with the HTML file.

## Rules

- UI language: English. Keep the app a single offline file: no CDN, no network calls.
- Load external libraries only via `vendor/` + `build.sh`.
- License: Apache-2.0, Copyright fly2nbc-oss. New third-party code only with a compatible license, listed in `THIRD_PARTY.md` and `NOTICE`.
- No company names or branding in code, defaults or examples.
- Do not break the file formats (see below). Old `.drawio` and JSON files must still open.
- Every edit to the diagram goes through `pushUndo()` then `changed()`, or `mutate(fn)`. This keeps undo, autosave and the "unsaved" marker working.

## Data model (one diagram)

```js
{ id, title, owner, version, status, description, created, updated, width,
  lanes:  [{ id, name, height }],            // top to bottom
  phases: [{ id, name, width }],             // left to right, optional
  nodes:  [{ id, type, x, y, w, h, text, color? }],
  edges:  [{ id, from, to, label, type, fromSide, toSide }],
  fileName?, fileDirty?, foreign? }          // runtime state, not exported
```

- Coordinates: pool starts at (0,0). Header columns: `POOL_HDR` 32 + `LANE_HDR` 36, content starts at `CX` = 68. Phase header row sits above the pool at y = -28 (`PHASE_HDR`).
- A node belongs to the lane that contains its center y. Lane and phase moves keep nodes relative (`laneRelative` / `phaseRelative`).
- Node types: `TYPES`. Edge types: `flow`, `message`, `assoc`. Sides: `auto`, `right`, `left`, `top`, `bottom`.

## Main parts of src/app.html (search for the `/* ===` comments)

- **store**: `localStorage` key `swimlane-editor.v1` = working copy of all diagrams plus settings (logo, company, sidebar state).
- **geometry**: lanes, phases, `route()` = orthogonal edge routing, `autoSides()`.
- **rendering**: `diagramMarkup(d, {interactive})` builds SVG as a string. Used for the canvas, SVG export and PDF, so canvas and export always match.
- **canvas interaction**: pointer events with drag modes (`move`, `resize`, `connect`, `lane`, `phase`, `poolw`, `box`). Own double-click detection because the SVG is re-rendered between clicks.
- **right panel**: `renderPanel()` per selection (edge, single node, multi, diagram).
- **keyboard**: shortcuts follow Cerno (github.com/fly2nbc-oss/Cerno) where the meaning matches. List: `SHORTCUTS` (also drives the help dialog, key `H`).
- **draw.io**: `drawioDiagram()` writes `<object>` cells with `swl*` custom properties (`swl`, `swlType`, `swlId`, …) so files round-trip. `parseDrawio()` / `modelToDiagram()` read them back, including compressed files and pools drawn in draw.io.
- **files**: File System Access API (`showSaveFilePicker`); handles stored in IndexedDB (`swimlane-editor` / `handles`) so Ctrl+S writes to the same file. Fallback: download.
- **automatic layout**: `autoLayout(d, hints)`: breaks loops by DFS, columns by longest path over the flow edges, phases kept in order, extra rows in a lane for parallel branches, artifacts (document/data/note via `assoc`) below their step, then line-side hints for decisions and loops. Used by the Arrange button (`L`) and on JSON import when nodes have no `x`/`y` (hints: `lane`, `phase`, `col` by name, id or index).
- **PDF**: `exportPDF(d, multi)`; `pdfFrame()` draws header and footer; multi-page splits at phase borders or gaps (`pageSegments()`), header column repeated via clip paths.

## Testing

No test framework in the repo. Proven approach: Playwright (Chromium) scripts that open `swimlane-editor.html`, click and drag, export, and check:
- no `pageerror`
- PDF via `pdftoppm` to PNG and look at it
- `.drawio` round trip: save, re-open, compare lanes/phases/nodes/edges
- mock `window.showSaveFilePicker` to test Ctrl+S
