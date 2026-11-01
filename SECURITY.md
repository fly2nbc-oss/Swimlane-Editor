# Security

## Supported versions

Security fixes are made for the latest release only.

| Version | Supported |
|---|---|
| latest release | ✅ |
| older releases | ❌ |

## Reporting a vulnerability

Please do **not** open a public issue for security problems. Use GitHub's [private vulnerability reporting](https://github.com/fly2nbc-oss/Swimlane-Editor/security/advisories/new) instead.

Name the browser and its version, the operating system and the steps that make it happen. If a file triggers it, please make a small one that shows the problem instead of attaching a real process diagram. A first answer comes within 14 days.

## What Swimlane Editor does

- It runs entirely in the browser and makes no network requests: no CDN, no fonts or images from other servers, no telemetry. The PDF libraries are built into the HTML file.
- It reads files only when you open them, and writes only when you save or export – through the browser's file dialog, or as a download.
- Opened `.drawio` and JSON files are treated as data: ids, colours, types and sides are checked against what the editor knows, text is escaped before it is drawn, and nothing in a file is run as code.
- It keeps a working copy of the diagrams and the settings in the browser's `localStorage`, and the handles of saved files in IndexedDB.
