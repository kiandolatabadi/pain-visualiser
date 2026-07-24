# CLAUDE.md — working notes for AI assistants in this repo

## What Algora is

A **single-file, offline-first PWA** for **language-free pain communication between a
patient and a clinician**. The patient paints where/how it hurts on a 3D body map;
the clinician reads it. It is a **communication aid, not a diagnostic tool**
(see `INTENDED_USE.md`). All the app lives in **`algora.html`** (HTML + CSS + two
`<script>` blocks). Three.js is vendored under `vendor/`; body models are the two
`.glb` files. Data is stored **locally** (IndexedDB via the `DB` object; some
localStorage). No backend, no network at runtime.

## 👉 Roadmap: build these next

**[NEXT_STEPS.md](NEXT_STEPS.md) contains four APPROVED, committed features to build.**
When the user says "continue", "next step", or "build the next feature", open
NEXT_STEPS.md, take the highest-priority unstarted item, and implement it. Treat those
items as decided work — not suggestions to re-open. Keep each item's **Status** and
acceptance checklist up to date as you go.

## Hard constraints (do not violate)

- **No backend / no external API / no CDN / no runtime network.** Everything client-side.
  Inline new CSS/JS into `algora.html`; vendor any library under `vendor/`.
- **Privacy:** patient data stays local. No telemetry, no uploads.
- **Non-diagnostic wording** in all UI.
- Must keep working **offline** and installable as a PWA.

## Code map (`algora.html`)

- **Non-module `<script>`** — the 15 pain-type card previews: `FX`/`RhyFX` classes and
  subclasses, the `REG` registry, card build loop, `allFx`, and the preview animation
  loop (visibility-gated, 30fps-capped).
- **`<script type="module">`** — the Three.js body map: scene/camera/renderer,
  `OrbitControls`, model load (`setupModel`/`switchGender`), painting
  (`paintAt` → `paintCircle` → `rebuildDisplay`/`bakeStroke`), sessions (`captureSession`
  /`restoreSession`, `DB`), view mode, and compare mode.
- **Rendering is on-demand:** call **`invalidate()`** (module scope) after ANY change to
  the scene, camera, or a paint texture, or the 3D view won't redraw. Camera motion via
  OrbitControls is already covered by its `change` event.

## Painting model (important for correctness)

- Each paintable mesh has: `cv`/`ctx` (committed base), `cvS`/`ctxS` (current stroke —
  a **coverage mask**, stamped at full opacity so overlaps within one stroke union
  rather than compound), `cvD`/`ctxD` (display), and a `CanvasTexture` `tex`.
- **Intensity** is applied once as a global alpha when compositing the stroke
  (`rebuildDisplay`/`bakeStroke`), so it is a hard opacity ceiling per stroke.
- **Depth** (skin/sub/muscular/visceral) is shown by the hatch/stipple overlay
  (`buildHatchOverlay`/`applyPattern`), NOT by fill opacity.

## Release / ship discipline

- **The user tests on the GitHub Pages deployment, NOT local files.** So a change isn't
  testable until it's pushed. **Always commit AND push** after making changes (bump the
  version first, below) — don't wait for a separate "please commit" once work is done and
  syntax-checked. (Still confirm direction before large/destructive work.)
- Bump **both** the in-app version (`#app-version` in `algora.html`) **and**
  `CACHE_NAME` in `sw.js` for every user-facing change (the service worker won't serve
  new code otherwise), then **git-tag** the version (e.g. `v1.2`) and push the tag.
- Commit messages end with the project's `Co-Authored-By` trailer.

## Reversibility — record every release so it can be rolled back

Each release is a **tagged, self-contained restore point.** Keep the **Change log**
below current: for every version, note what changed and the exact revert target, so any
release can be undone fast.

- Undo the latest release, keep history: `git revert <sha>` (or the range).
- Hard-reset to a previous good version: `git reset --hard <prev-tag>` then force-push
  (only if the user okays rewriting the pushed branch).
- Inspect what a release changed: `git show <tag>` / `git diff <prev-tag> <tag>`.

## Verify before pushing

The 3D/canvas/DOM behaviour **can't be exercised headlessly here.** Before every push:
`node --check` the two extracted `<script>` blocks for syntax, confirm CSS brace balance,
and reason through the logic. The user does the visual/browser test on GitHub Pages after
the push and reports back — so flag any intentionally visible change in the commit + your
reply so they know what to look at.

## Change log (newest first)

- **v1.3** — follow-up on the v1.2 fixes. (1) **Cross-stroke paint buildup fixed**:
  strokes now commit via `stampStroke()` — a REPLACE within the covered region (punch to
  skin, then paint at intensity), used for both live preview (`rebuildDisplay`) and commit
  (`bakeStroke`). Intensity is now an absolute ceiling across separate strokes too, not
  just within one. Trade-off: overlapping a different pain type is last-wins, not blended.
  (2) **Exit button**: hide the `#app-version` build tag in view/compare modes (it was
  rendering on top of the button), enlarge the button, add a reduced-motion-aware attention
  pulse. Documented the "brush size varies by polygon (UV density)" bug in `NEXT_STEPS.md`.
  _Revert target: `v1.2`._
- **v1.2** — bug fixes. (1) View/compare **exit buttons** restyled to a prominent solid
  red ✕ button (`#cmp-exit`/`#view-exit`). (2) **Paint intensity bug**: the stroke layer
  (`cvS`) is now a full-opacity coverage mask so overlaps within one stroke union instead
  of compounding — intensity is a hard ceiling (`paintCircle` rewritten; dead `DEPTH_CFG`
  removed). Visible change: dabs are flat solid coverage, not a soft airbrush. Also added
  `NEXT_STEPS.md` + this file. _Revert target: `v1.1.1`._
- **v1.1.1** — card previews capped to ~30fps (`PREVIEW_FPS`); `prefers-reduced-motion`
  settles then freezes previews. _Revert target: `v1.1`._
- **v1.1** — on-demand 3D rendering (idle renders 0 frames); off-screen / hidden-tab /
  faded card previews stop animating. _Revert target: `v1.0`._
