# Phase 1 acceptance record

Build identity: Erik 831f49b7d6c0fcf43b3633f4958b38cb5c4cd66d; SDK c94f5ebdcb3c9d1a460ca48e04f9758448f8d518 plus Erik combined patch and recorded Windows adaptations.
Runtime: C:\Emulation\NHL-Legacy-Claw
Test saves: profiles\baseline (isolated from existing games).

All items below are PENDING until observed. A successful build alone does not pass Phase 1.

1. Release executable and DLLs produced; hashes recorded.
2. Repeat build exits successfully; distinguish an incremental check from a fresh reproducibility build.
3. Launch 1: correct GPU selected, intro movie renders, menu visible, no fatal log errors.
4. Launch 2: controller navigation works; user confirms sound and input.
5. Launch 3: settings/save persist; clean exit and restart.
6. Complete one match with correct clock progression and no major graphics/audio faults.
7. Save a test career, close, reopen and reload the same checkpoint.
8. User acceptance recorded separately from automated observations.

Record for every run: executable/DLL hashes, launch time, profile, effective resolution/settings, controller, driver, logs, observed faults, exit status.

Do not claim steady 60 FPS or 15–20 W from this stage. Those require Phase 2 instrumentation and Phase 3/4 measurement gates.
