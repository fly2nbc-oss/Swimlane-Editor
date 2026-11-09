# Creating diagrams with AI

Give this guide to an AI, for example Claude, together with a description of your process. Swimlane Editor offers it for download in its help (`H`). The AI writes a JSON file. You open it in Swimlane Editor with **Open…**, and the editor lays everything out. Then you **Save** it as `.drawio`.

## How to do it

1. Describe your process in short notes: roles, steps, decisions, phases.
2. Give the AI this file. It ends with a complete example.
3. Ask: "Turn this into a file for Swimlane Editor, following this guide."
4. Save the answer as `.json`, for example `purchasing.json`.
5. In the editor: **Open…**, choose the file, check it, adjust with the mouse, **Save**.

Tip: after changes, **Arrange** (key `L`) lays the diagram out again. `Ctrl+Z` takes it back.

Several processes at once, for example a main process and its subprocesses: ask for several entries in `diagrams`. They open as pages of one file, and **Save** writes them together into one `.drawio` file.

---

## Instructions for the AI

Output **only valid JSON** in this format. No comments, no coordinates: the editor computes the positions itself.

```json
{
  "format": "swimlane-editor",
  "version": 1,
  "diagrams": [
    {
      "id": "short-name-without-spaces",
      "title": "Process name",
      "owner": "Responsible person or team",
      "description": "One or two sentences, shown in the PDF.",
      "lanes": ["Role 1", "Role 2"],
      "phases": ["Phase 1", "Phase 2"],
      "nodes": [
        { "id": "s1", "type": "start", "lane": "Role 1", "phase": "Phase 1", "text": "Trigger" }
      ],
      "edges": [
        { "from": "s1", "to": "t1" }
      ]
    }
  ]
}
```

### Fields

| Field | Required | Meaning |
|---|---|---|
| `id` | yes | Unique short name: letters, digits, `-`, `_`, `.`, `:` |
| `title` | yes | Process name |
| `owner`, `description` | no | Shown in the PDF |
| `version`, `status` | no | e.g. `"1.0"`, `"Draft"` / `"In review"` / `"Released"` |
| `lanes` | yes | Roles or departments, top to bottom. The first lane is usually the trigger or the customer. |
| `phases` | no | Stages of the process, left to right. 2 to 5 phases. |
| `artifactStyle` | no | `"icon"` draws documents and systems/data as small symbols with the text below (BPMN style); leave it out for boxes with the text inside |
| `nodes` | yes | Elements (see below) |
| `edges` | yes | Connections (see below) |

### Elements (`nodes`)

| Field | Required | Meaning |
|---|---|---|
| `id` | yes | Unique, short: letters, digits, `-`, `_`, `.`, `:` |
| `type` | yes | Only a value from the table below. An element with any other type is left out, together with its connections. |
| `lane` | yes | Name of the lane, exactly as in `lanes` |
| `phase` | no | Name of the phase, exactly as in `phases` |
| `text` | yes | Short: tasks as "verb + object", about 5 words at most |
| `color` | no | Highlight: `#FBE9E7` red, `#FFF5DD` yellow, `#E6F5EA` green, `#EAF2FB` blue; also `#F1E8FA` purple, `#F2F4F6` grey, `#FFFFFF` white |

| `type` | Meaning |
|---|---|
| `start` | Start, exactly once |
| `end` | End, at least once |
| `task` | Task |
| `subprocess` | Subprocess (a process of its own, with details elsewhere) |
| `decision` | Decision; text as a short question ending in "?" |
| `event` | Wait or event, e.g. "Wait 3 days", "Invoice received" |
| `document` | Document, e.g. form, contract |
| `data` | IT system or database, e.g. "ERP", "CRM" |
| `note` | Comment |

### Connections (`edges`)

| Field | Required | Meaning |
|---|---|---|
| `from`, `to` | yes | `id` of the elements |
| `label` | for decisions | "Yes" / "No" or the answer in question |
| `type` | no | `flow` = sequence (default), `message` = message to an outside party, `assoc` = dotted link to a `document`, `data` or `note` |

### Rules

- The **order** follows from the connections. Every step stands to the right of the one before it.
- Attach `document`, `data` and `note` to a step only with `"type": "assoc"`. They are then placed below that step.
- The direction of an `assoc` to a `document` or `data` matters, the line gets an arrow: from the document to the step is an **input** (the step uses it), from the step to the document an **output** (the step creates or changes it). A `note` has no direction.
- Every element except `start`, `document`, `data` and `note` has at least one incoming connection.
- Every element except `end`, `document`, `data` and `note` has at least one outgoing connection.
- A decision has at least two outgoing connections, all with a `label`.
- Loops are allowed, for example "No" back to an earlier step.
- A step never sits in an earlier phase than the step before it.

### Checklist before the output

- [ ] Every `id` is unique, and every `from` / `to` exists as an element
- [ ] Every `lane` and `phase` of an element is spelled exactly as in `lanes` / `phases`
- [ ] Every `type` is one from the table
- [ ] Exactly one `start`, at least one `end`
- [ ] Valid JSON: no comments, no trailing commas

### Complete example

A leave request with three roles, three phases, a decision with a loop back and a form attached to a step:

```json
{
  "format": "swimlane-editor",
  "version": 1,
  "diagrams": [
    {
      "id": "leave-request",
      "title": "Leave request",
      "owner": "HR",
      "description": "From the request to the entry in the HR system.",
      "lanes": ["Employee", "Team lead", "HR department"],
      "phases": ["Request", "Review", "Completion"],
      "nodes": [
        { "id": "start",   "type": "start",    "lane": "Employee",      "phase": "Request",    "text": "Time off needed" },
        { "id": "submit",  "type": "task",     "lane": "Employee",      "phase": "Request",    "text": "Submit request" },
        { "id": "form",    "type": "document", "lane": "Employee",                             "text": "Leave request form" },
        { "id": "review",  "type": "task",     "lane": "Team lead",     "phase": "Review",     "text": "Review request" },
        { "id": "ok",      "type": "decision", "lane": "Team lead",     "phase": "Review",     "text": "Approved?" },
        { "id": "adjust",  "type": "task",     "lane": "Employee",      "phase": "Review",     "text": "Adjust request" },
        { "id": "record",  "type": "task",     "lane": "HR department", "phase": "Completion", "text": "Record leave in HR system" },
        { "id": "end",     "type": "end",      "lane": "Employee",      "phase": "Completion", "text": "Leave confirmed" }
      ],
      "edges": [
        { "from": "start",  "to": "submit" },
        { "from": "submit", "to": "review" },
        { "from": "submit", "to": "form",   "type": "assoc" },
        { "from": "review", "to": "ok" },
        { "from": "ok",     "to": "record", "label": "Yes" },
        { "from": "ok",     "to": "adjust", "label": "No" },
        { "from": "adjust", "to": "review" },
        { "from": "record", "to": "end" }
      ]
    }
  ]
}
```

---

## Advanced: own positions

If the AI gives `x`, `y` (and optionally `w`, `h`) for **all** elements, the editor keeps those positions as they are. If even one element has no `x` or `y`, the editor lays out the whole diagram itself. The example `docs/examples/leave-request.json` in the Swimlane Editor repository shows the format.

`x` and `y` are the **top left corner** of the element, not its centre. Grid: column centre `158 + column × 170`, lane centre `top + height / 2`, so `x = column centre − w / 2` and `y = lane centre − h / 2`. Example: a start element (`w` 36) in column 0 has `x` = 158 − 18 = 140. Content starts at x = 68.

With the field `"col"` (0, 1, 2, …) on an element, the AI can set just the column and leave the rest to the editor.
