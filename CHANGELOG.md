# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

## [1.6.0] – 2026-11-09

### Added

- **Documents in a row**: Arrange puts the documents and systems of a step side by side in a row below it, hanging from one shared dotted line, so lanes stay compact. Columns get wider where a row needs the space.
- **Documents as icons**: new diagram setting "Documents and systems": boxes, or small symbols with the text below, as in BPMN. Saved in JSON (`artifactStyle`) and `.drawio` files.
- **Parallel gateway**: a new element (diamond with a plus, as in BPMN) splits the flow into branches that run at the same time and joins them again. Arrange routes the branches from separate corners, and the lines need no label. It is kept in `.drawio` files, and draw.io's own BPMN parallel gateways are recognised on import.
- **Phase milestones**: a phase can have a milestone (for example "Q1: PRD Released"), shown as a small grey tag at the top right of the phase. Enter it under the phase name in the details panel, or in JSON as `{ "name": "...", "milestone": "..." }` in `phases`. It is kept in `.drawio` files, SVG and PDF.

## [1.5.0] – 2026-11-09

### Changed

- **Input and output documents**: a dotted line between a step and a document or system/data now has an open arrow, as in BPMN. From the document to the step means input, from the step to the document means output. A line to a note stays without an arrow. Diagrams so far connect step → document, so their documents now show as output; *Reverse direction* in the details panel turns one into an input. The arrow is also kept in `.drawio` files, and the AI guide explains the direction.

### Fixed

- **Document stack far below its step**: when another element lies between a step and its documents, the lines no longer branch off the shared spine through that element; they are routed like other lines.

## [1.4.3] – 2026-11-09

### Added

- **Update check**: at most once a week the editor asks GitHub for the latest release and shows a notice with a download link when there is a newer version (*Not now*, *Skip this version*). Switch it off or use *Check now* in **Settings**. Nothing from your diagrams is sent; offline or behind a blocking proxy the check stays silent.

## [1.4.2] – 2026-11-09

### Fixed

- **Several documents on one step**: Arrange and the JSON import stack them below the step as before, but only the nearest one keeps a straight line. The others branch off a shared dotted spine left of the stack instead of all running around the right side of the step.

## [1.4.1] – 2026-11-08

### Added

- **AI guide in the help**: the help (`H`) has "Download AI guide (.md)": the instructions for writing diagrams with an AI, ready to hand to the AI together with a description of the process. The guide now ends with a complete example, so this one file is enough.

### Changed

- **Help dialog** is titled "Help" instead of "Keyboard shortcuts"; the toolbar button says "Help and keyboard shortcuts (H)".

## [1.4.0] – 2026-11-08

### Added

- **Windows installer**: the release has `swimlane-editor_<version>_windows-installer.zip`. Its `install.cmd` copies the editor for the current user (no admin rights, no .exe), adds *Swimlane Editor* to the Start menu, opening in its own Edge window, and to *Settings > Apps*; `uninstall.cmd` removes it again.
- **Full size as an app window**: opened as an app window, as the Start menu entry does, the editor fills the screen once; Edge ignores the shortcut's "maximized" while it is already running.

## [1.3.2] – 2026-11-03

### Changed

- **Simpler Export menu**: no group headings; four entries: PDF on one page, PDF on several pages (the current file), "SVG image (only this diagram)" and "JSON backup (all diagrams)". The PDF exports of all files in the editor are gone.

## [1.3.1] – 2026-11-03

### Fixed

- **Release notes of 1.3.0**: "Diagrams belong to their file" said a diagram with the same id *or title* used to ask a question. Only the same id did; a diagram from another file with the same id now opens next to it. Diagrams with only the same title always opened without a question. No change in the app.

## [1.3.0] – 2026-11-03

### Added

- **Collapse a file in the list**: ▾/▸ next to a file name hides or shows its diagrams; a collapsed file shows how many diagrams it has and is highlighted when the current diagram is in it. The state is kept in the browser.
- **Full names on hover**: the tooltip of a file and of a diagram in the list shows the full name (and the diagram's version), also when the list cuts it off.

### Changed

- **Diagrams belong to their file**: a diagram with the same id as one from another file (for example the same diagram in two versions of a file) opens next to it, without a question; it gets its own id. Only when the same file is already open, one question per file: "Reload" replaces its diagrams in place (with a note when they have unsaved changes), "Open as copy" opens it again, not linked to the file. A file with the same name in another folder counts as another file when the editor knows both files.

## [1.2.1] – 2026-11-03

### Changed

- **Toolbar icons**: Open, Save, Export, Fit and Arrange show an icon next to their label; zoom in and out are magnifier icons. In a narrow window (below 1000 px) these buttons show only the icon, the tooltip keeps the name.

## [1.2.0] – 2026-11-02

### Added

- **The list is grouped by file**: the left sidebar shows each file with its diagrams as pages below it, with its state (✓ saved, ● unsaved changes or not saved yet); diagrams that are not saved to a file yet are listed below "Not saved to a file". Save writes the file of the current diagram, its tooltip says which file and how many diagrams. `Page Up` / `Page Down` follow the order of the list.
- **New page**: the new-page button below the list adds a diagram to the current file; Save writes it as another page of that file. The new-diagram button starts a diagram of its own, as before. New diagram, new page, duplicate, delete and delete all are icon buttons with tooltips.
- **Close a file**: × next to a file name removes its diagrams from the editor (after a question when it has unsaved changes); the file keeps its last saved state.
- **Delete all**: the button with two bins below the list removes every file and diagram from the editor after a question; files you saved are not touched.
- **Drop files on the canvas**: a `.drawio` or `.json` file dropped on the drawing area opens like Open….
- **Empty page with buttons**: without a diagram the drawing area offers "New diagram" and "Open file…".

### Changed

- **Toolbar**: Open, Save and Export are now at the left, next to the app name. "Save as new file…" moved from Export into a small menu next to Save. Undo, Redo, help and settings are icons; every button names its shortcut in the tooltip.
- **Export menu** groups by what is exported: "This file" (or "This diagram"), "Only this diagram" (shown when the file has several) and "All files in the editor", with shorter labels. The menus work with the arrow keys and `Esc`.

### Removed

- **Export → all diagrams as one `.drawio`**: it downloaded a copy that was not linked to the diagrams, which was easy to confuse with Save. A new diagram goes into an existing file with the new-page button.
- **Export → JSON backup of a single diagram**: the `.drawio` file already holds the diagram. The JSON backup of everything stays, and JSON files still open.
- **`Tab` moves between buttons and fields again** instead of hiding the right sidebar; `Alt+2` hides it, `Alt+0` hides all bars (before also `Shift+Tab`). Diagram list entries and element tiles can be reached with `Tab` and used with `Enter`. A clear focus ring shows where the keyboard is.
- **Delete left the toolbar**: the details panel on the right has Delete for the selected element(s) or connection, and the `Del` key works as before. Deleting a diagram is its own icon button below the list.
- **Questions** (delete diagram or lane, overwrite a foreign file, diagram already open) use the app's own dialog with clear button labels instead of the browser's OK / Cancel. Deleting a phase or an empty lane says that `Ctrl+Z` undoes it.
- **Selected connection** is easy to see: a light halo, dots at both ends and a handle on the segment you can drag.
- **Fill colors** have names in their tooltips (with the keys 6–9 and 0); "Default" is a dashed field marked A instead of a red slash.
- **Text editing in place** uses the element's font and size and stays centred on it.
- **Fit** fits again after the window or a sidebar changes size, until you zoom yourself.
- **Small windows**: below 1250 px the save status hides (the file state in the list stays), below 1100 px the sidebars get narrower and the app name hides, below 900 px the zoom percentage hides, so all toolbar buttons stay reachable.
- **Tips** in the left sidebar can be collapsed; the editor remembers it. Disabled move arrows in lane and phase rows are hidden, the × turns red only on hover.

## [1.1.0] – 2026-11-02

### Added

- **More options for several selected elements**: icon buttons align left, center, right, top, middle or bottom (to the first selected element) and distribute evenly horizontally or vertically (tooltips name them); also same width and/or height as the first, and set element type, fill color or lane for all of them at once; "Connect in this order" does what `C` does.
- **PDF of a whole file**: when a file holds several diagrams, the PDF export puts all of them into one PDF (named after the file), each with its own header; page numbers run through. **All diagrams → PDF** in the Export menu does the same for every diagram in the editor.
- **App icon**: in the browser tab and in the toolbar; also `docs/icon.svg`.
- **`C` connects the selection**: select elements with `Shift` + click in flow order and press `C`; they are connected first to second (to third …).
- **Connect by clicking**: click a blue dot, scroll if needed, then click the other element – no dragging across a long diagram. A dashed line follows the mouse; `Esc` or a click on an empty spot cancels.
- **Move connections**: drag a line to move its middle segment, e.g. when it lies on another line. "Reset line position" in the panel, a change of side, Reverse or Arrange put it back. The offset is saved in JSON and `.drawio` files (`swlBend`).
- **Files with several diagrams are saved together**: diagrams opened from one file – a draw.io file with several pages or a JSON file with several diagrams – stay linked; `Ctrl+S` writes all of them as pages of one `.drawio` file. The status bar shows the page ("page 2 of 3"). A draw.io file with several pages stays linked to its file; a JSON list asks for a `.drawio` name on its first save. Duplicate makes a separate diagram.
- **Save suggests the JSON file's name**: a diagram opened from `purchasing.json` suggests `purchasing.drawio` on its first save (before: the diagram title).
- **Lines avoid elements**: when a connection would run through an element, the automatic routing tries other positions of its middle segment and, for sides set to Auto, other sides, and takes the route through the fewest elements.
- **Overlapping lines are spread apart**: when the middle segments of several connections would lie on top of each other, they are drawn side by side.

### Fixed

- **PDF, multiple pages** keeps a diagram on one page while it is still readable there (at least 0.2 mm per pixel) and otherwise splits it with the fewest pages: left to right at phase borders and now also top to bottom at lane borders, so a tall diagram with many lanes is no longer squeezed onto one page. Lane headers and the phase row repeat on every page; the footer says where it continues.
- **Notes fit their text**: a note is as high as its text, so the bracket encloses all of it; drag the handle at the bottom right to make it wider (it gets lower). Its lane grows with it if needed. Arrange and JSON import without coordinates make a note wider when the room to its right is free (up to the phase border). The dotted line meets a wide note straight below its step.
- Deleting the last diagram leaves an empty page instead of creating a new "New process"; it stays empty after a reload. The example diagram appears only on the very first start.
- A connection that leaves an element at the top or bottom (e.g. a decision) while its target lies beside it runs out of that side first instead of turning right at the corner or back through the element.
- Branches of a decision leave from different corners: when two branches set to Auto would share a corner, the straightest keeps it and the other uses a free one (e.g. Yes from the top, No to the right).
- A moved middle segment keeps a short distance to the elements instead of running along their edge.

## [1.0.2] – 2026-11-02

### Changed

- The help no longer refers to another app; the list of keys is unchanged.

## [1.0.1] – 2026-11-02

### Changed

- **`Shift+Tab` shows or hides all bars** – both sidebars and the toolbar: while any of them is shown it hides them all, otherwise it shows them all. `Alt+0` does the same (it switched only the two sidebars before).

### Fixed

- **`Z` zooms on German and French keyboards** – the letter keys (`Z`, `T`, `L`, `F`, `H`) follow the character on the key, not its place on a US keyboard. On QWERTZ the zoom used to sit on `Y`.

### Under the hood

- **Releases can be checked** – each release carries a provenance attestation: `gh attestation verify swimlane-editor.html --repo fly2nbc-oss/Swimlane-Editor` shows it was built by this repository's CI. Published releases can no longer be changed.
- The CI also checks its own workflow files (actionlint, zizmor); Dependabot keeps the pinned actions current.
- Instructions for coding agents moved to `AGENTS.md`.

## [1.0.0] – 2026-11-01

The first public version: a swimlane editor in one HTML file that runs offline and saves as draw.io.

### Added

- **Diagrams** – several at once: new, duplicate, delete; a dot marks unsaved changes.
- **Lanes and phases** – add, rename, reorder and resize; steps move along with their lane or phase.
- **Elements** – Start, Task, Decision, End, Subprocess, Wait/Event, Document, System/Data, Note; colours red, yellow, green, blue.
- **Connections** – sequence flow, message flow and association, with labels, routed at right angles; the side where a line leaves and enters can be chosen.
- **Arrange automatically** (`L`) – steps in columns by their order, parallel branches in extra rows, documents and data below their step; lanes and phases stay.
- **draw.io as the file format** – `Ctrl+S` writes to the same file again (Chrome, Edge). Opens compressed files saved by draw.io and pools drawn in draw.io.
- **PDF** – A4 landscape with logo, title, version, owner and date; on one page or on several at readable size, with page breaks at phase borders and the lane names on every page.
- **Exports** – SVG, JSON backup, all diagrams as one multi-page `.drawio`.
- **Diagrams with AI** – a JSON file with lanes, steps and connections but no coordinates is laid out on opening; spec and examples in `docs/`.
- **Keyboard first** – undo/redo, copy/paste, multi-select, align, full screen, zoom; `H` lists every key.
