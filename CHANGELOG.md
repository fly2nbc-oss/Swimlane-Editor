# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

## [0.1.0] – 2026-11-01

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
