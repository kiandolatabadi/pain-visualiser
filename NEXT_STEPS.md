# Algora — Next Steps (approved roadmap)

> **For any AI assistant / future Claude working in this repo:** the four features
> below are **approved and committed to be built** — they are not open questions or
> suggestions to re-litigate. When asked to "work on the next step", "continue", or
> "build the next feature", pick the highest-priority unstarted item here, confirm
> the specifics with the user if anything is genuinely ambiguous, and implement it.
> Update each item's **Status** as you go, and tick the acceptance checklist.

## Hard constraints (apply to every item)

- **No backend, no external API, no network at runtime.** Algora is a single-file,
  offline-first PWA (`algora.html`) served statically. Everything must run client-side.
  (An LLM-powered enhancement may be added *later, optionally*, but nothing here may
  depend on it.)
- **Privacy:** all patient data stays local (IndexedDB / localStorage). Never add
  telemetry, uploads, or third-party calls.
- **Non-diagnostic positioning:** this is a *communication* aid between patient and
  clinician (see `INTENDED_USE.md` / `README.md`). Wording in any new UI must not
  claim to diagnose or interpret.
- **Self-contained:** inline any new CSS/JS into `algora.html`; vendor any library
  under `vendor/` (no CDNs). Keep it working offline.
- **Ship discipline:** bump the in-app version (`#app-version`) **and** `CACHE_NAME`
  in `sw.js` together, then git-tag the release (see [CLAUDE.md](CLAUDE.md)).
- **Verify:** these touch canvas/WebGL/DOM that can't be exercised headlessly here —
  after building, ask the user to test in the browser before tagging a release.

---

## 1. Local plain-language pain summary (copy-paste)  — PRIORITY 1

**Status:** not started

**Goal.** Generate a deterministic, human-readable text description of the current
(or a saved) session that the user can copy-paste into a clinical note — *without*
any LLM or backend. This is the offline realisation of the "describe the pain in
words" idea.

**Why.** The clinician-facing value of the body map is the story it tells; a
copy-pasteable text version makes that portable into any EHR/notes field.

**Where.** `algora.html`:
- `summarizePaint()` already aggregates per pain type: `label`, intensity `min`/`max`,
  `depths`, `count` (sorted by frequency). This is the data source for v1.
- Per-stroke data (`packStrokes()` / `paintLog`) carries `partName` + `uvx/uvy` +
  `painId` + `depth` + `intensity` — the raw material for *location* in v2.

**Approach.**
- **v1 (no location):** a pure formatter over `summarizePaint()`. Template per type:
  `"{Type}, {intensityWord} ({min}–{max}/10), {depthWord}."` Join into a short
  paragraph or bullet list. Reuse existing `depthLabel()` and the intensity wording;
  fully localised via `window.I18N`.
- **v2 (with body region):** add a static `partName → human region` map (e.g.
  `arm_L → "left arm"`), optionally refined by UV quadrant (upper/lower, medial/lateral)
  so output reads `"...on the right lower back."` Group the summary by region × type.
- Surface via a **"Copy summary"** button (near export / session UI) using
  `navigator.clipboard.writeText()`; show a brief "copied" confirmation.

**Acceptance.**
- [ ] v1 button copies a correct, localised text summary of the live session.
- [ ] Works from a restored/saved session too (uses stored summary or rebuilds from strokes).
- [ ] No network calls; works offline.
- [ ] v2 adds body-region phrasing via the part→region map.

---

## 2. Printable one-page clinician report  — PRIORITY 2

**Status:** not started

**Goal.** A clean, one-page printable/PDF report: body-map snapshot(s) + the #1 text
summary + the pain-type legend + patient label + date.

**Why.** The concrete "hand it to the doctor" artifact; natural companion to #1.

**Where.** `algora.html`. Body snapshot: the WebGL canvas can be captured with
`renderer.domElement.toDataURL()` (render the wanted view first). Legend + summary
already exist in the DOM (`showSessionLegend`, `summarizePaint`).

**Approach.**
- Prefer **`@media print`** + `window.print()` — no library needed. Build a hidden
  print-only container populated on demand (snapshot image, summary text, legend,
  label/date), and a print stylesheet that hides everything else.
- For a captured 3D image, render at a good fixed viewpoint (e.g. front) into an
  offscreen/known camera pose before `toDataURL()`; consider front+back.
- If true PDF is later wanted, vendor a small lib under `vendor/` — but `window.print()`
  → "Save as PDF" covers it with zero deps first.

**Acceptance.**
- [ ] "Print / Export report" produces a one-page layout with map + summary + legend + label/date.
- [ ] Prints cleanly (no app chrome) and "Save as PDF" works from the print dialog.
- [ ] Offline, no external resources.

---

## 3. Multi-session timeline / trends  — PRIORITY 3

**Status:** not started

**Goal.** A longitudinal view over a patient's saved, dated sessions: how intensity
and affected regions evolve over time.

**Why.** Sessions are already saved with dates; 2-way compare exists. A trend view
adds real clinical value across many sessions.

**Where.** `algora.html` + `DB` (IndexedDB patient store). Sessions carry `date`,
`label`, `summary`, `strokes`, `gender`.

**Approach.**
- Add a timeline/trend panel: e.g. intensity-over-time per pain type (from each
  session's `summary`), and a "most recurring regions" readout (needs the part→region
  map from #1 v2 — build that first or share it).
- Client-side charting only. If a chart library helps, vendor it under `vendor/`;
  otherwise hand-draw on a `<canvas>`/SVG. Follow the `dataviz` skill for palette/
  legibility, and keep it theme-aware (light/dark) like the rest of the app.

**Acceptance.**
- [ ] A panel lists a patient's sessions chronologically with an intensity trend.
- [ ] Recurring painful regions/types are summarised across sessions.
- [ ] Reads only local data; works offline; light + dark themes.

---

## 4. Undo / redo for painting  — PRIORITY 4 (quick win, slot in anytime)

**Status:** not started

**Goal.** Undo/redo for paint strokes on the body map.

**Why.** Genuinely missing today; high-frequency quality-of-life win. Purely local.

**Where.** `algora.html` painting pipeline: strokes are committed by `bakeStroke()`
into each mesh's base canvas (`cv`/`ctx`), with `paintLog` tracking stroke tuples,
and `rebuildDisplay()` compositing the live stroke.

**Approach.**
- Maintain an undo stack of committed states. Cheapest correct approach: snapshot the
  per-part base canvas (or the compact `paintLog` up to that point) at each
  `bakeStroke()` boundary; undo restores the previous snapshot + trims `paintLog`;
  redo re-applies. Cap stack depth to bound memory (textures are 512²).
- Wire to buttons + keyboard (`Ctrl/Cmd+Z`, `Ctrl/Cmd+Shift+Z`). Call `invalidate()`
  after each so the 3D view redraws (on-demand render loop).
- Reset the stacks on clear / gender switch / session load.

**Acceptance.**
- [ ] Undo reverts the last stroke; redo re-applies it; both update the 3D body.
- [ ] Keyboard shortcuts work; stacks reset correctly on clear/switch/load.
- [ ] Bounded memory (capped history depth).

---

## Known bugs (fix when convenient)

### Brush paints different real-world sizes on different body parts

**Status:** open (user-reported, low priority). **Symptom:** with the same brush
setting, the painted blob covers a larger/smaller area of the body depending on which
mesh/polygon you paint on.

**Cause.** The brush radius `br` is in **texture pixels** (constant), but each mesh is
UV-unwrapped at a **different texel-to-world density**, so a fixed texel radius maps to
different physical sizes per part.

**Exact fix.** Normalise the brush by per-part UV density:
- In `setupModel`, for each mesh compute a density factor from the geometry — e.g.
  `sqrt(sum(worldTriArea) / sum(uvTriArea))` over its triangles (positions + uv
  attributes) — and store it on `userData` (e.g. `uvDensity`). Normalise so the mean
  part = 1 (or pick a reference part).
- In `paintAt`, scale the radius: `br = baseBr * part.uvDensity` (still clamped). Keep
  `strokeBr`/`brushUV` in sync so pattern scale and the saved stroke log match.
- Note: this corrects **between-part** differences; within-part UV stretch remains, but
  that's the dominant visible issue. Verify in-browser (can't be tested headlessly).

## Also-noted (not in the committed four, but worth doing)

- **Compress the body GLBs** (Draco/meshopt) — biggest remaining startup/memory win.
  `male_body.glb` is ~1.5 MB uncompressed. Requires re-export + vendoring the decoder.
- **Lazy-load the second body model** — deferred: `switchGender`, `restoreSession`,
  and `buildCompareScene` all assume both models are loaded; needs an async refactor
  (await the model before switching/restoring/cloning) + a loading state. Test live.

_See [CLAUDE.md](CLAUDE.md) for repo conventions and the performance work already shipped (v1.1 / v1.1.1)._
