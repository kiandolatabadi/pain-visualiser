# Pain Visualiser

A language-free, interactive tool for pain communication between patient and clinician.
The core premise: if an animation IS the pain, no translation is needed.

**[Live demo →](https://kiandolatabadi.github.io/pain-visualiser/)**

---

## The Problem

Describing pain requires a precise shared vocabulary. Clinical consultations fail when:
- Patient and clinician do not share a first language
- The patient lacks the vocabulary (age, literacy, cognitive state)
- Cultural differences shape what is "normal" to report
- The patient has never heard words like "neuropathic" or "dysesthesia"

Existing tools (VAS scale, numeric 0–10, Wong-Baker faces) capture intensity but not **quality**.
The McGill Pain Questionnaire captures quality but requires high literacy and is text-only.

---

## The Concept

Each pain type is represented as an interactive animation.
The animation *behaves* the way the pain feels — the patient recognises it instinctively.
No words required. No translation layer. Universal.

Pain is painted onto a 3D body map (not pinned), enabling:
- Precise location (dermatome-level)
- Intensity gradient across a region
- Multi-session overlay for temporal comparison, side by side

---

## What's implemented

- **16 touch-responsive pain-type animations**, grouped by clinical pattern (rhythmic, continuous,
  intermittent, sensory/non-painful) — see [Descriptor Set](#descriptor-set--design-rationale) below
- **3D body map** (male and female models) that the patient paints directly, with brush intensity/depth
- **Patient records**: create a patient, save a painted session, reopen it later
- **Session comparison**: load two sessions from the same patient side by side on a split view, each
  rendered in its own independent 3D view (not a shared canvas) for reliable cross-browser rendering
- **Backup / restore**: export the full patient database to a JSON file, import it back on any device
- **Settings panel**: light/dark theme and language (English/French)
- **Fully responsive, touch-first UI**: works on phone, tablet, and desktop — pinch-to-zoom, a
  collapsible pain-type picker, and safe-area-aware layout for notched phones
- **Installable, offline-capable app** (PWA): add-to-home-screen on desktop and iOS, works with no
  network connection once loaded

All patient data is stored locally in the browser (IndexedDB) — nothing is sent to a server, there is
no backend, and no two devices share data automatically. Use the export/import buttons in the
Patients panel to move or back up data.

---

## Tech stack

- Vanilla JS, no build step, no framework
- [Three.js](https://threejs.org) (r0.157, vendored locally in `vendor/`) for the 3D body map and
  painting/raycasting
- IndexedDB for local, offline patient/session storage
- A service worker (`sw.js`) + `manifest.json` for PWA installability and offline caching

---

## Running it locally

Double-click **`Launch Pain Visualiser.command`** — it starts a local static server and opens the app
in Chrome. (A local server is required because the browser blocks loading local `.glb` files directly
over `file://`.)

To stop it, close the Terminal window it opens.

---

## Scientific Foundation

### Primary Classification: SF-MPQ-2 (Dworkin et al., 2009)
The Short-Form McGill Pain Questionnaire version 2 is the current gold standard for
validated pain quality assessment. It groups 22 descriptors into 4 subscales:

| Subscale | Descriptors |
|---|---|
| Continuous | throbbing, cramping, gnawing, aching, heavy, tender |
| Intermittent | shooting, stabbing, sharp, splitting, electric-shock, piercing |
| Neuropathic | hot-burning, cold-freezing, light-touch pain, itching, tingling, numbness |
| Affective | tiring-exhausting, sickening, fearful, punishing-cruel |

Source: Dworkin RH et al. Pain. 2009 Apr;144(1-2):35-42. PMID 19356853

### Neuropathic Screening: painDETECT (Freynhagen et al., 2006)
7 sensory items that distinguish neuropathic from nociceptive pain:
burning, tingling/prickling, light touch, electric shock, cold/heat, numbness, slight pressure.
Validated against QST (quantitative sensory testing).

### Neuropathic Screening: DN4 (Bouhassira et al., 2005)
Burning, painful cold, electric shocks, tingling, pins and needles, numbness, itching.
Plus 3 clinical signs (allodynia, hypoesthesia to touch, hypoesthesia to pinprick).

### IASP Official Terminology (2020 revised definition)
Key sensory terms used in this tool:
- **Allodynia**: pain from a stimulus that does not normally cause pain (e.g., light touch)
- **Hyperalgesia**: exaggerated pain response to a normally painful stimulus
- **Paresthesia**: abnormal sensation, spontaneous or evoked, not necessarily unpleasant
- **Dysesthesia**: unpleasant abnormal sensation (burning, electric)
- **Hypoesthesia**: reduced sensitivity to stimulation
- **Hyperpathia**: explosive delayed pain response to repetitive stimuli
- **Anesthesia dolorosa**: pain in a region that is otherwise numb
- **Numbness**: used here in its patient-reported sense (reduced/absent sensation)

Source: iasp-pain.org/resources/terminology/

### Precedent: Painimation (University of Pittsburgh, 2018)
Paper: "Abstract Animations for the Communication and Assessment of Pain in Adults:
Cross-Sectional Feasibility Study." JMIR 2018. PMC6098242.

Key findings:
- N=170 chronic pain patients in a pain clinic
- 80.2% agreed or strongly agreed they would use animations to communicate with providers
- Animation choices correlated with MPQ and painDETECT adjectives
- The "electrifying" animation correlated specifically with neuropathic pain
- Not limited by age, literacy, or language — validates the core premise of this tool

### Painimation — Competition or Support?
**Conclusion: Relevant competitor, but differentiated.**

Painimation (now "My Painimation" by Expressive Painimation Co.) is:
- Available on iOS App Store (commercial product)
- A clinical eCOA (electronic clinical outcomes assessment) platform
- Developed for integration into clinical workflows / EHR
- Proprietary and requires licensing

Our tool differs in:
- Web-based: runs in any browser, no install, works on hospital tablets
- Open and free: no paywall, no EHR dependency
- More comprehensive sensory taxonomy (including non-pain sensations: numbness, allodynia, paresthesia)
- Animations that RESPOND TO TOUCH in ways that mirror the pain's nature
  (burning fire follows your finger; pressure rings compress as you hold; cramping twists as you hold)
- Rhythm meter for rhythmic pains (BPM visualization)
- Body map painting (not pinning) for dermatome-precise multi-session overlay
- No accounts, no data collection, no backend

The Painimation paper validates the entire concept. The commercial product validates the market.
We should study their animation choices but not copy them — our interaction model is different.

---

## Descriptor Set & Design Rationale

### GROUP A — RHYTHMIC
*Pains with a cycle. Has a rhythm meter (ECG-style strip showing beat pattern).*
*Hold the card to speed up the rhythm. Shows approximate rate.*

| Descriptor | Clinical basis | Visual metaphor | Interaction |
|---|---|---|---|
| Throbbing | SF-MPQ-2 continuous; vascular/pulsatile pain | Heartbeat rings expanding from center | Hold to accelerate pulse |
| Cramping | SF-MPQ-2 continuous; muscle/visceral | Spokes contracting inward then releasing | Hold to tighten contraction |
| Gnawing | SF-MPQ-2 continuous; persistent dull erosion | Slow grinding particles at center | Hold to intensify erosion |

### GROUP B — CONTINUOUS
*Pain that is always present. Idle animation is always vivid. Cursor/touch modifies it.*

| Descriptor | Clinical basis | Visual metaphor | Interaction |
|---|---|---|---|
| Burning | SF-MPQ-2 neuropathic; painDETECT; DN4 | Fire particles rising from skin | Drag to spread fire |
| Cold / Freezing | SF-MPQ-2 neuropathic; DN4 "painful cold" | Ice crystals growing across surface | Touch to spread frost |
| Aching | SF-MPQ-2 continuous; most common chronic pain | Slow heavy undulating waves | Cursor makes weighted depression |
| Heavy | SF-MPQ-2 continuous; musculoskeletal | Particles falling under constant gravity | Touch adds weight/drag |

### GROUP C — INTERMITTENT
*Pain that arrives suddenly. Calm between episodes. Click/tap triggers the event.*

| Descriptor | Clinical basis | Visual metaphor | Interaction |
|---|---|---|---|
| Stabbing | SF-MPQ-2 intermittent; universal | Sharp radiating spikes burst on impact | Click/tap to trigger |
| Electric Shock | SF-MPQ-2 intermittent; painDETECT; DN4 | Full-canvas ZAP with branching lightning | Click/tap to trigger |
| Sharp / Piercing | SF-MPQ-2 intermittent | Clean surgical slash through canvas | Click-drag to cut |
| Shooting | SF-MPQ-2 intermittent; sciatica, neuralgia | Signal propagates along a nerve path | Click origin to fire |

**Note on Shooting**: In clinical terms, shooting pain travels ALONG a nerve pathway
(sciatica radiating down the leg; trigeminal neuralgia along the face). It is NOT the same
as electric shock (which is sudden, explosive). Previous version had this wrong — shooting
was animated as a static burst. Now corrected: click to set origin, a signal travels
directionally along a branching nerve-like path.

### GROUP D — SENSORY / NON-PAINFUL
*Abnormal sensations that may or may not be painful. Covers the range from paresthesia to allodynia.*

| Descriptor | Clinical basis | Visual metaphor | Interaction |
|---|---|---|---|
| Tingling / Pins & Needles | SF-MPQ-2 neuropathic; painDETECT; DN4 | Dense electric sparkle field | Move cursor to densify |
| Numbness | SF-MPQ-2 neuropathic; painDETECT; DN4 | Signal dropout — canvas fades to grey static | Touch spreads numbness |
| Itching | SF-MPQ-2 neuropathic; DN4 | Surface-crawling particles, compulsive drift | Touch concentrates itch |
| Allodynia | IASP terminology; DN4 clinical sign | Gentle touch → immediate pain cascade | Any touch triggers response |

---

## Key Design Decisions

### Why no language at all (not even translated labels)?
The original brief called for bilingual labels. This was revised because:
- Labels create an anchor that biases interpretation ("oh this says burning so it must be that")
- The animation should be self-evident — if it requires a label to be understood, it failed
- Labels can be added as an optional accessibility/confirmation layer later
- A Chinese-speaking elderly patient and a French-speaking child should pick the same card

### Why paint instead of pin on the body map?
- Pinning = one point per pain type. Reality: pain covers zones, gradients, patterns.
- Painting = the patient can show extent, intensity gradient (press harder = more intense)
- Multi-session overlay: day 1 red layer, day 3 blue layer — change is immediately visible
- Dermatome tracing: a clinician can recognize C5 distribution from how a patient paints

### Why a rhythm meter?
- "How often?" is clinically as important as "what kind?"
- A throbbing at 30bpm vs 120bpm describes very different conditions
- The rhythm meter externalizes what is otherwise invisible
- A patient can match the rhythm of the animation to their experience by holding/tapping

### Why touch-responsive animations?
- Increases identification accuracy: "I recognize the burning because when I touch it, it spreads"
- The gesture mirrors the sensation — this creates a body-felt recognition, not just visual
- Clinically: the manner of interaction itself can be diagnostic
  (a patient who presses hard on the throbbing card is showing something different
  from one who barely touches it)

---

## What's NOT in scope (yet)

- LLM integration for auto-summary generation
- EHR / EMR export
- Dermatome overlay map (named nerve regions)
- Cross-device sync (data is local to each browser/device — see [What's implemented](#whats-implemented))
- Affective descriptors (tiring, fearful, sickening) — these require a different design approach
- Pediatric version (simplified icons, different interaction model)
- Sound / haptic feedback

---

## Files

- `pain-visualiser.html` — the entire app: pain-type animation cards, 3D body map, patient/session
  storage and UI, comparison mode
- `index.html` — redirects the bare site root to `pain-visualiser.html`
- `vendor/three/` — Three.js + GLTFLoader/OrbitControls, vendored locally so the app runs fully offline
- `male_body.glb`, `low_poly_female_body__teeth__tongue_lp.glb` — 3D body models (see Credits)
- `manifest.json`, `sw.js`, `icons/` — PWA install + offline support
- `Launch Pain Visualiser.command` — double-click launcher for local use on macOS
- `README.md` — this file

---

## Credits

The 3D body models are used under [CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/), which
requires attribution:

- **Male Body** by [Alexander Antipov](https://sketchfab.com/Dessen) —
  [source](https://sketchfab.com/3d-models/male-body-15a422001834483c9750ce6117d59cc1)
- **Low poly female body | Teeth + tongue lp** by [mezuna](https://sketchfab.com/mezuna) —
  [source](https://sketchfab.com/3d-models/low-poly-female-body-teeth-tongue-lp-16201ebf4bca4395b3fe1931cc30c801)

---

## References

1. Dworkin RH et al. "Development and initial validation of an expanded and revised version of the SF-MPQ-2." Pain. 2009. PMID 19356853
2. Freynhagen R et al. "painDETECT: a new screening questionnaire to identify neuropathic components in patients with back pain." Current Medical Research and Opinion. 2006.
3. Bouhassira D et al. "Comparison of pain syndromes associated with nervous or somatic lesions and development of a new neuropathic pain diagnostic questionnaire (DN4)." Pain. 2005. PMID 15733628
4. Jonassaint CR et al. "Abstract Animations for the Communication and Assessment of Pain in Adults: Cross-Sectional Feasibility Study." JMIR. 2018. PMC6098242
5. IASP Terminology. iasp-pain.org/resources/terminology/ (2020 revised definition of pain)
6. Melzack R. "The McGill Pain Questionnaire: Major properties and scoring methods." Pain. 1975. PMID 1235985
7. Melzack R. "The short-form McGill pain questionnaire." Pain. 1987. PMID 3670870
8. Haanpää M & Treede RD. "Diagnosis and Classification of Neuropathic Pain." IASP Pain Clinical Updates. 2010.
