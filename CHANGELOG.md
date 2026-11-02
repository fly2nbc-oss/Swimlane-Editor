# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

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
