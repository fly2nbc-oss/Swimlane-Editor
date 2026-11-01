# Swimlane Editor

**Swimlane process diagrams in one HTML file – offline, no installation, saved as draw.io.**

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
[![CI](https://github.com/fly2nbc-oss/Swimlane-Editor/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/fly2nbc-oss/Swimlane-Editor/actions/workflows/ci.yml)
[![Runs in](https://img.shields.io/badge/runs%20in-Chrome%20%7C%20Edge-blue.svg)](#start)

Swimlane Editor draws who does what, in which order: roles as lanes, steps, decisions and documents, phases from left to right. It is a single HTML file that runs in the browser without a server or an internet connection. Diagrams are saved as `.drawio` files, so colleagues can open them in draw.io too, and come out as a PDF ready to print.

## What it does

- **Several diagrams at once** – new, duplicate, delete; a dot in the list marks unsaved changes.
- **Lanes and phases** – lanes for roles, phases as columns (e.g. Inquiry | Check | Delivery): add, rename, reorder, resize. Steps move along with their lane or phase.
- **Elements** – Start, Task, Decision, End, Subprocess, Wait/Event, Document, System/Data, Note.
- **Connections** – sequence flow, message flow, association, with labels; routed at right angles.
- **Arrange automatically** – puts the steps in columns by their order and keeps lanes and phases (`L`, undo with `Ctrl+Z`).
- **Native file format: draw.io** – open, edit in draw.io, open again. Compressed files saved by draw.io and pools drawn in draw.io open too.
- **PDF** – A4 landscape with logo, title, version, owner and date; fit on one page, or several pages at readable size with page breaks at phase borders and the lane names on every page.
- **More exports** – SVG, JSON backup, all diagrams as one multi-page `.drawio`.
- **Keyboard first** – undo/redo, copy/paste, multi-select, align; keys follow [Cerno](https://github.com/fly2nbc-oss/Cerno) where the meaning is the same.
- **Diagrams with AI** – an AI writes lanes, steps and connections as JSON without coordinates; the editor lays them out (see [below](#diagrams-with-ai)).

## Start

Download `swimlane-editor.html` from [Releases](https://github.com/fly2nbc-oss/Swimlane-Editor/releases), or take it from the root of this repository, and open it in Chrome or Edge. That is all: there is nothing to install, and the file works from a local folder, a network share or a USB stick.

Firefox and Safari work too, but cannot write files directly: **Save** downloads the file instead.

## Quick use

| Action | How |
|---|---|
| Add element | Drag a tile onto a lane, or double-click an empty spot in a lane |
| Add next step | Select an element, click a tile: placed to the right and connected |
| Connect | Hover an element, drag from a blue dot to another element (or to empty space for a new task) |
| Edit text | Double-click, or select and press Enter |
| Rename lane or phase | Double-click the header |
| Resize phase | Drag the right edge of the phase header |
| Resize lane / pool | Drag the bottom border of a lane, or the right border of the pool |
| Arrange automatically | Toolbar **Arrange** or key `L` (undo with `Ctrl+Z`) |
| Change routing of a line | Select the line, choose "Leaves source at" / "Enters target at" |

## The most important keys

| Key | Does |
|---|---|
| `F10` / `Tab` / `T` | Left sidebar / right sidebar (details) / toolbar on or off (also `Alt+1`, `Alt+2`, `Alt+0`) |
| `F`, `F11` | Full screen |
| `Z` | Switch between 100 % and fit to window (`Ctrl+1` 100 %, `Ctrl+0` fit, `+` / `-` zoom) |
| `6`–`9`, `0` | Colour of the selection: red, yellow, green, blue / default |
| `Page Down` / `Page Up`, `Home` / `End` | Next / previous, first / last diagram |
| `Ctrl+S`, `Ctrl+Shift+S`, `Ctrl+O` | Save, save as, open |
| `Ctrl+Z`, `Ctrl+Y` | Undo, redo |
| `Delete`, `Esc` | Delete selection, clear selection |
| `Enter`, `F2`, double-click | Edit text |
| `Ctrl+C` / `V` / `D`, `Ctrl+A` | Copy, paste, duplicate, select all |
| `L` | Arrange automatically |
| Arrow keys | Move selection (`Shift`: fine steps) |
| `H`, `?`, `F1` | Help: all keys |

## Files and storage

- **Save** (`Ctrl+S`) writes the current diagram as a `.drawio` file. The first time you choose the location; after that `Ctrl+S` writes directly into the same file (Chrome and Edge).
- **Open** (`Ctrl+O`) reads `.drawio` files and JSON backups. A `.drawio` file with several pages opens as several diagrams.
- The status next to the Open button shows the file name and whether there are unsaved changes.
- **Share** by putting the `.drawio` file into a shared folder (OneDrive, SharePoint, Teams). Colleagues open it in this editor or in draw.io.
- Changes made in draw.io come back when you open the file again. What the editor does not know (other shapes, own line bends, fonts) is simplified.
- **Logo:** *Settings › Choose logo*. It appears in the PDF header and is stored in the browser.

## Where your data is

- **In your files:** the `.drawio` file is the real document. JSON backups and PDF/SVG exports are written only when you ask for them.
- **In the browser:** a working copy of all open diagrams, the logo and the settings (`localStorage`, key `swimlane-editor.v1`), and the handles of the files you saved, so `Ctrl+S` finds them again (IndexedDB `swimlane-editor`). Clearing the browser's site data removes them; your `.drawio` files stay.

## Privacy

Swimlane Editor works entirely in your browser. It loads nothing from the internet, sends nothing anywhere and has no telemetry: the PDF libraries are built into the file, and there are no fonts, scripts or images from other servers. Files are read and written only when you open or save them.

## Diagrams with AI

Give an AI the spec [`docs/AI-DIAGRAMS.md`](docs/AI-DIAGRAMS.md) and the example [`docs/examples/leave-request-simple.json`](docs/examples/leave-request-simple.json). It writes a JSON file with lanes, steps and connections only, without coordinates. **Open** it in the editor: the layout is computed automatically. Then **Save** as `.drawio`.

## More

- Building from source and checks: [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- Changes per version: [`CHANGELOG.md`](./CHANGELOG.md)
- Reporting a security problem: [`SECURITY.md`](./SECURITY.md)
- License: Apache 2.0 ([`LICENSE`](./LICENSE)), third-party components in [`THIRD_PARTY.md`](./THIRD_PARTY.md) and [`NOTICE`](./NOTICE)

draw.io and diagrams.net are trademarks of JGraph Ltd. They are named only to describe file compatibility; this project is not affiliated with JGraph.
