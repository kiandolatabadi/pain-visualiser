# Intended Purpose & Regulatory Positioning

**Product:** Pain Visualiser
**Manufacturer / author:** Kian Dolatabadi
**Document status:** Manufacturer self-assessment — v1.0. This is the author's stated
position and rationale; it is **not** a determination by a competent authority or
notified body, and it should be confirmed with a medical-device regulatory
consultant before any clinical deployment or commercial placement on the market.
**Assumed jurisdiction:** European Union (Regulation (EU) 2017/745, "MDR").

---

## 1. Purpose of this document

To state, clearly and in advance, **what Pain Visualiser is intended to do**, who is
meant to use it, and why — on the basis of that intended purpose — the author's
position is that it is a **non-diagnostic communication aid** and does **not**
qualify as medical device software (MDSW) under the MDR. Regulatory qualification
turns on *intended purpose and claims*, so this document also fixes the claims the
product may and may not make.

---

## 2. Product description

Pain Visualiser is a browser-based tool in which:

- a patient selects, from a fixed set of animations, the one that best matches how
  their pain *feels*, and paints it onto a 3D body map to show **where** and **how
  intensely** it is felt;
- the resulting picture is **stored locally** on the device, can be **re-opened**,
  and two records can be **displayed side by side** to see change over time;
- a clinician can **view** what the patient expressed.

The animations are grouped and named using established pain vocabulary (e.g. from
the SF-MPQ-2 / painDETECT / DN4 instruments). Those references are the **design
rationale for choosing and naming the animations** — they are not a claim that the
software screens for, or identifies, any condition.

---

## 3. Intended purpose (formal statement)

> Pain Visualiser is a **language-independent communication aid** that lets a person
> express the **character, location, and intensity of their own pain**, and lets a
> healthcare professional **view, record, and compare** that self-report over time.
>
> It is intended to **support communication** between patient and clinician. It is
> **not** intended to diagnose, screen for, monitor, predict, prognose, or treat any
> disease or condition, and it does **not** generate any diagnostic or therapeutic
> recommendation.

---

## 4. Intended users and use environment

- **Patients / members of the public**, of any age or language, expressing their own
  pain.
- **Healthcare professionals**, using the patient's self-report as one input
  alongside — never in place of — their own clinical assessment.
- Any setting where a browser is available (consultation room, bedside, home).

---

## 5. What the software does NOT do (explicit exclusions)

- It performs **no interpretation** of the patient's input. It does not analyse the
  self-report to compute a diagnosis, a risk score, a probability, a classification,
  or any other new medical information.
- The descriptor shown with each animation is a **suggested name for that animation
  — a shared vocabulary label — not a clinical finding or diagnosis.** The patient
  chooses the animation that matches their sensation; the label describes the
  animation, not the patient's condition.
- It does **not** recommend, rank, or trigger any clinical action.
- It does **not** replace history-taking, examination, validated instruments, or
  clinical judgement. The clinician remains fully responsible for interpretation and
  for every clinical decision.
- It is **not** a validated measurement instrument; intensity (0–10) and the painted
  extent are **self-reported expressions**, not calibrated measurements.

---

## 6. Regulatory positioning — why this is not MDSW

Under MDR Article 2(1), software is a medical device only if the manufacturer
assigns it a **medical purpose** (diagnosis, prevention, monitoring, prediction,
prognosis, treatment, or alleviation of disease). Guidance **MDCG 2019-11** further
holds that software qualifies as MDSW only where it has such a purpose **and**
performs an action on data *beyond* storage, archival, **communication**, display,
or simple search.

The author's position, on the intended purpose above:

1. **No medical purpose is assigned.** The stated purpose is communication of a
   patient's own self-report — not diagnosis, screening, or treatment.
2. **The action on data is limited to capture, storage, display and communication.**
   The software records what the patient expresses and shows it back; it does not
   create new medical information by calculation or interpretation.
3. **The one interpretive-looking element — animation ↔ descriptor — is not machine
   interpretation.** The mapping is a fixed vocabulary chosen by the *patient*; the
   descriptor is a label for the animation, presented explicitly as a suggested
   name, not a diagnosis. The clinician interprets.
4. **Close analogy to non-device tools.** This is functionally equivalent to a paper
   pain body-chart or a paper patient-reported-outcome list of pain adjectives (e.g.
   the McGill questionnaire on paper), used to capture and display self-report. Such
   instruments, used purely to record/communicate what the patient reports, are not
   medical devices; digitising the capture and display does not, by itself, change
   that.

On this basis the author's position is that Pain Visualiser is a **general
communication aid outside the scope of the MDR**. Qualification is fact-specific and
the burden of justification rests on the manufacturer; this position must be
**confirmed by a regulatory expert** and re-assessed if the intended purpose or
claims change.

---

## 7. Guardrails that keep this positioning valid

This positioning holds **only while all of the following remain true**. Breaking any
one of them may create a medical purpose and pull the product into MDSW/MDR scope:

- **No diagnostic, screening, or triage claims** anywhere — product, README, UI,
  marketing, or verbal pitch. Never state or imply that the tool "identifies",
  "screens for", "detects", or "assesses" neuropathic pain or any condition.
- The descriptor is always presented as a **suggested name for the animation**, never
  as a determination about the patient.
- **No algorithm** is added that scores, classifies, interprets, or recommends based
  on the patient's input.
- No claim of clinical accuracy, sensitivity/specificity, or measurement validity.
- The product continues to state that it is **not a medical device** and does not
  replace clinical assessment (see `LICENSE`, `TERMS.md`).

> Recommended: keep the README's scientific section framed as *design rationale for
> the descriptor set*, and avoid the words "screening" / "identifies" / "diagnostic"
> in any user-facing or promotional text.

---

## 8. Still applies even though it is not a medical device

- **Data protection (GDPR).** Any health data a clinician records is personal health
  data. The tool keeps all data **locally on the device** and transmits nothing, but
  the clinician remains a data controller with information, security, and retention
  obligations, and — in France — CNIL expectations for health data.
- **Research ethics.** Any formal study involving people (feasibility, correlation
  with validated scales, etc.) is likely subject to the **loi Jardé** and requires
  review by a **CPP (Comité de Protection des Personnes)**, plus a GDPR basis for the
  research data. Investigational use is a legitimate route to gather validation
  evidence.
- **Professional responsibility.** A clinician using the tool does so under their own
  professional judgement and liability.

---

## 9. Limitations and disclaimer

Pain Visualiser is an **experimental communication aid**. It is **not a medical
device**, is not clinically validated, and must not be used as the basis for any
diagnosis or treatment decision. It is provided for **evaluation and research** under
the terms of `LICENSE` and `TERMS.md`.

---

*Prepared by the author as an internal positioning statement. Confirm with a
medical-device regulatory consultant and, for studies, with a research-methodology /
ethics advisor before clinical or commercial use.*
