# Creating diagrams with AI

Give this guide to an AI, for example Claude, together with a description of your process. The AI writes a JSON file. You open it in Swimlane Editor with **Open…**, and the editor lays everything out. Then you **Save** it as `.drawio`.

## How to do it

1. Describe your process in short notes: roles, steps, decisions, phases.
2. Give the AI this file **and** the example `examples/leave-request-simple.json`.
3. Ask: "Turn this into a file for Swimlane Editor, following this guide."
4. Save the answer as `.json`, for example `purchasing.json`.
5. In the editor: **Open…**, choose the file, check it, adjust with the mouse, **Save**.

Tip: after changes, **Arrange** (key `L`) lays the diagram out again. `Ctrl+Z` takes it back.

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
| `nodes` | yes | Elements (see below) |
| `edges` | yes | Connections (see below) |

### Elements (`nodes`)

| Field | Required | Meaning |
|---|---|---|
| `id` | yes | Unique, short: letters, digits, `-`, `_`, `.`, `:` |
| `type` | yes | See the table below |
| `lane` | yes | Name of the lane, exactly as in `lanes` |
| `phase` | no | Name of the phase, exactly as in `phases` |
| `text` | yes | Short: tasks as "verb + object", about 5 words at most |
| `color` | no | Highlight: `#FBE9E7` red, `#FFF5DD` yellow, `#E6F5EA` green, `#EAF2FB` blue |

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
- Every element except `start`, `document`, `data` and `note` has at least one incoming connection.
- Every element except `end`, `document`, `data` and `note` has at least one outgoing connection.
- A decision has at least two outgoing connections, all with a `label`.
- Loops are allowed, for example "No" back to an earlier step.
- A step never sits in an earlier phase than the step before it.

### Checklist before the output

- [ ] Every `id` is unique, and every `from` / `to` exists as an element
- [ ] Every `lane` and `phase` of an element is spelled exactly as in `lanes` / `phases`
- [ ] Exactly one `start`, at least one `end`
- [ ] Valid JSON: no comments, no trailing commas

---

## Advanced: own positions

If the AI gives `x`, `y` (and optionally `w`, `h`) for **all** elements, the editor keeps those positions as they are. The example `examples/leave-request.json` shows the format. Grid: column centre `158 + column × 170`, lane centre `top + height / 2`; content starts at x = 68.

With the field `"col"` (0, 1, 2, …) on an element, the AI can set just the column and leave the rest to the editor.
