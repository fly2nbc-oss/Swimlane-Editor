# Diagramme mit KI erstellen

Diese Anleitung gibst du zusammen mit deiner Prozessbeschreibung an eine KI, zum Beispiel Claude. Die KI erzeugt eine JSON-Datei. Du öffnest sie im Swimlane Editor mit **Open…**. Das Tool ordnet alles automatisch an. Danach speicherst du mit **Save** als `.drawio`.

## So gehst du vor

1. Beschreibe deinen Prozess in Stichpunkten: Rollen, Schritte, Entscheidungen, Phasen.
2. Gib der KI diese Datei **und** das Beispiel `examples/urlaubsantrag-einfach.json`.
3. Bitte: „Erstelle daraus eine Datei für den Swimlane Editor nach dieser Anleitung.“
4. Speichere die Antwort als `.json`, zum Beispiel `einkauf.json`.
5. Im Editor: **Open…**, Datei wählen, prüfen, mit der Maus nachbessern, **Save**.

Tipp: Nach Änderungen ordnet **Arrange** (Taste `L`) das Diagramm neu an. `Strg+Z` macht das rückgängig.

---

## Anleitung für die KI

Erzeuge **nur gültiges JSON** in diesem Format. Keine Kommentare, keine Koordinaten. Das Tool berechnet die Positionen selbst.

```json
{
  "format": "swimlane-editor",
  "version": 1,
  "diagrams": [
    {
      "id": "kurzname-ohne-leerzeichen",
      "title": "Prozessname",
      "owner": "Verantwortliche Person oder Team",
      "description": "Ein bis zwei Sätze, erscheinen im PDF.",
      "lanes": ["Rolle 1", "Rolle 2"],
      "phases": ["Phase 1", "Phase 2"],
      "nodes": [
        { "id": "s1", "type": "start", "lane": "Rolle 1", "phase": "Phase 1", "text": "Auslöser" }
      ],
      "edges": [
        { "from": "s1", "to": "t1" }
      ]
    }
  ]
}
```

### Felder

| Feld | Pflicht | Bedeutung |
|---|---|---|
| `id` | ja | Eindeutiger Kurzname |
| `title` | ja | Prozessname |
| `owner`, `description` | nein | Erscheinen im PDF |
| `version`, `status` | nein | z. B. `"1.0"`, `"Draft"` / `"In review"` / `"Released"` |
| `lanes` | ja | Rollen oder Abteilungen, von oben nach unten. Die erste Lane ist meist der Auslöser oder Kunde. |
| `phases` | nein | Abschnitte des Prozesses von links nach rechts. 2 bis 5 Phasen. |
| `nodes` | ja | Elemente (siehe unten) |
| `edges` | ja | Verbindungen (siehe unten) |

### Elemente (`nodes`)

| Feld | Pflicht | Bedeutung |
|---|---|---|
| `id` | ja | Eindeutig, kurz, ohne Leerzeichen |
| `type` | ja | siehe Tabelle |
| `lane` | ja | Name der Lane, genau wie in `lanes` |
| `phase` | nein | Name der Phase, genau wie in `phases` |
| `text` | ja | Kurz: Aufgaben als „Verb + Objekt“, höchstens etwa 5 Wörter |
| `color` | nein | Hervorhebung: `#FBE9E7` rot, `#FFF5DD` gelb, `#E6F5EA` grün, `#EAF2FB` blau |

| `type` | Bedeutung |
|---|---|
| `start` | Start, genau einmal |
| `end` | Ende, mindestens einmal |
| `task` | Aufgabe |
| `subprocess` | Unterprozess (eigener Prozess mit Details) |
| `decision` | Entscheidung, Text als kurze Frage mit „?“ |
| `event` | Warten oder Ereignis, z. B. „3 Tage warten“, „Rechnung eingegangen“ |
| `document` | Dokument, z. B. Formular, Vertrag |
| `data` | IT-System oder Datenbank, z. B. „ERP“, „CRM“ |
| `note` | Kommentar |

### Verbindungen (`edges`)

| Feld | Pflicht | Bedeutung |
|---|---|---|
| `from`, `to` | ja | `id` der Elemente |
| `label` | bei Entscheidungen | „Ja“ / „Nein“ oder die jeweilige Antwort |
| `type` | nein | `flow` = Ablauf (Standard), `message` = Nachricht an Externe, `assoc` = gepunktete Zuordnung zu `document`, `data` oder `note` |

### Regeln

- Die **Reihenfolge** ergibt sich aus den Verbindungen. Jeder Schritt steht rechts von seinem Vorgänger.
- `document`, `data` und `note` nur mit `"type": "assoc"` an einen Schritt hängen. Sie stehen dann unter diesem Schritt.
- Jedes Element außer `start`, `document`, `data`, `note` hat mindestens eine eingehende Verbindung.
- Jedes Element außer `end`, `document`, `data`, `note` hat mindestens eine ausgehende Verbindung.
- Eine Entscheidung hat mindestens zwei ausgehende Verbindungen, alle mit `label`.
- Schleifen sind erlaubt, zum Beispiel „Nein“ zurück zu einem früheren Schritt.
- Ein Schritt steht nie in einer früheren Phase als sein Vorgänger.

### Prüfliste vor der Ausgabe

- [ ] Alle `id` sind eindeutig, alle `from` / `to` gibt es als Element
- [ ] Jede `lane` und `phase` eines Elements steht genau so in `lanes` / `phases`
- [ ] Genau ein `start`, mindestens ein `end`
- [ ] Gültiges JSON, keine Kommentare, keine abschließenden Kommas

---

## Für Fortgeschrittene: eigene Positionen

Gibt die KI bei **allen** Elementen `x`, `y` (und optional `w`, `h`) an, übernimmt das Tool die Positionen unverändert. Das Beispiel `examples/urlaubsantrag.json` zeigt das Format. Raster: Spaltenmitte `158 + Spalte × 170`, Lane-Mitte `Oberkante + Höhe / 2`, Inhalt beginnt bei x = 68.

Mit dem Feld `"col"` (0, 1, 2, …) an einem Element kann die KI auch nur die Spalte vorgeben und den Rest dem Tool überlassen.
