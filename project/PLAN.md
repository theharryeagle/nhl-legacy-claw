# NHL Legacy Claw — approved implementation plan

## Order and gates
Low-power tuning is Phase 4, immediately after steady 60 FPS. All subsequent feature phases revalidate that selected power profile. RinkSide and PS3 work are excluded. Ask before modifying Erik game/SDK source; preserve existing installations, saves and editor work. Each step records PASS/FAIL/BLOCKED, measurements and a rollback point.

## Phase 1: Prepare and build Erik
1. Verify ISO/default.xex against supported SHA256; preserve original.
2. Create isolated SSD source, build, runtime, log and test-profile directories.
3. Pin source/SDK/patch/tool versions and audit patch overlap.
4. Attempt Windows configure/build and document concrete blockers.
5. Obtain approval for necessary source changes, implement only approved changes, reproduce Release build twice.
6. Three launches, controller/menu/movie/audio checks, complete match, save/reload and clean exit.
Gate: reproducible working Windows build; completed steps remain valid if source approval blocks the remainder.

## Phase 2: Trustworthy diagnostics
7. Identify runs with versions/hashes/effective settings.
8. Record individual presented-frame timestamps; separate gameplay, replay and loading.
9. Correlate game-process/per-core CPU usage, GPU utilization/timing/memory and available clocks, temperature and measured package power.
10. Diagnostic mode records key thread waits, GPU/readback waits, shader compilation and asset loading.
11. Compare logging off/normal/diagnostic. Normal mode must add <=2% median performance cost and no reproducible stutter.
12. Save raw logs and readable repeatable 720p baseline, including available Xenia comparison.
Mark unavailable sensors explicitly, never zero. Use a shared monotonic timeline. No optimization based solely on title-bar FPS.

## Phase 3: Steady 60 FPS
Validate host render targets, correct readbacks, reduced memory uploads, redundant-transfer skipping, presentation/game speed, normal Windows scheduling versus P-core preference, audio and controls one meaningful change at a time.
Gate: three warm five-minute active-gameplay runs at verified internal 720p: average >=59 FPS, p99 frame time <=20ms, no frame >100ms, at most one >50ms per run, no <55FPS interval longer than one second. Game clock within 1% of equivalent reference. Complete match and >=30 minute soak. No major graphics/audio faults; user confirms no noticeable lag. Higher supported power profile is acceptable at this stage.

## Phase 4: Low-power tuning — moved forward
Compare supported 20W, 18W, 15W settings with consistent conditions; validate on battery. Distinguish configured limit, actual package power and whole-device draw. Freeze lowest profile passing Phase 3. If target fails, report lowest passing setting; do not silently reduce FPS. Every later feature gate rechecks performance at this profile.

## Phase 5: Safe mod loading
13. Separate stock/modern profiles and saves.
14. Version packages, dependencies, compatible builds, affected files and hashes; reject conflicts.
15. Install/remove a small asset test mod and verify restoration.
Gate: isolation, reversible loading and unchanged performance.

## Phase 6: Modern league and careers
16. Integrate Megarohas 32 NHL team/database/division changes.
17. Add 32 AHL affiliations, rights, call-ups/send-downs.
18. Add 2026–27 dates/ages and 84-game calendars.
19. Add standings/playoffs/AI/contracts/free agency/drafts; test first season/offseason.
20. Test Seattle, Vegas and an original-club Franchise separately through two seasons into year three.
21. Test original/expansion Be a Pro skaters through season two; goalie creation/gameplay/save-reload smoke tests.
Gates: each NHL club 84 games and 42 home games; 1,344 valid unique league fixtures; seven-round drafts with 224 unique scheduled picks and correct ownership. Transactions and checkpoint saves pass; no silently skipped simulations. Do not transplant old editor workarounds that release SEA/VGK players or use unsupported organizational teams.

## Phase 7: Data, history, rules, presentation
Freeze dated roster and validate identity/placement/rights/contracts/lineups. Import separate NHL regular-season/playoff history through 2025–26, preserving correct prior history. Audit and implement missing regular-season 3-on-3 OT, carried/new/expired penalties, manpower changes, whistles, goalie pulls and shootouts; verify separate playoff rules. Add logos/uniforms/ice/portraits in reversible layers.
Gate: no broken links, unintended duplicate identities or false free agents; missing history is reported not invented; career and low-power performance gates pass.

## Phase 8: Secondary launcher roster integration
Audit current C:\Coding\NHL-Legacy-Roster-Editor, preserving uncommitted work. Separate engine from UI. Add Check rosters button: explicit check, preview, selected changes, validation and rollback. Reuse compatible Puck Peak data tooling through an Xbox adapter. Trades/signings/releases/contracts/placements only, never ratings or history. Manual locks persist. No automatic check at launch; no update during gameplay; base rosters for new careers only.
Gate: zero rating changes; identity/rights/placement regression tests; unknown players held for review; repeat-update idempotence; interruption safety; hash-verified rollback.

## Phase 9: Separate ratings tuning
Reproduce Cole Caufield's reported 82 overall; trace matching, seasons, samples, MoneyPuck/EDGE mappings, workload caps, stabilization and overall calculation. No hard-coded correction. Review representative forwards/defensemen/goalies/rookies and small samples. Obtain user acceptance of calibration before enabling separate Update ratings button, previews/provenance and manual locks.
Gate: deterministic outputs, no repeated-update inflation, small-sample safeguards, in-game overall checks, no identity/contract/assignment/history changes. Initial playable release does not depend on this work.

## Phase 10: Optional graphics
Test sharpening/upscaling and higher actual internal resolution separately. Quality profile only if measured benefit justifies cost; preserve 60 FPS requirement.

## Approved Phase 1 implementation choice
User approved matching Erik's setup: SDK c94f5eb (0.10.0), Erik combined SDK patch, Clang 20.1.8, Release, x86-64-v3, Vulkan, Tracy off. Windows uses an opt-in portable source-set adaptation; Linux performance is not assumed to transfer to Windows. Build and playability gates remain pending until measured.

## Latest performance decision
User testing confirms this Erik build reaches 60 FPS; 30 FPS felt noticeably slow. Target steady 60 FPS and validate game-clock speed before accepting any lower cap. Captured 2x supersampling run mixes unmarked scenes: median present interval26.1968ms, p99 50.7241ms,132 intervals over50ms, worst329.1229ms. Do not interpret whole-run results as gameplay-only. Capture telemetry returned64 samples over300seconds, so actual cadence is about4.7seconds, not the intended1second; correct collector cadence before detailed bottleneck attribution.

## Planned in-game graphics menu
User preference: graphics settings accessible through the game's main/start menu and, where practical, its pause menu. Controller-first navigation with clear labels, readable text on the Claw, and no dependence on F1 or the Guide button. The supplied RinkSide settings photo is a reference for controls, not a requirement to reproduce its launcher.

Scope: frame-rate cap, VSync, windowed/borderless display, window size separate from internal render resolution, supersampling, supported upscaling/sharpening, texture filtering and anti-aliasing. Show only settings supported by the active renderer. Explain rendering cost, distinguish live changes from restart-required changes, persist settings, and provide restore-defaults plus a timed revert for display changes.

Implementation order: after the diagnostics and stable-performance baseline, audit integration with the game's menu and Erik's existing overlay/settings persistence. Prefer a native game-menu entry; if guest-menu integration is impractical, use a controller-accessible host menu. A separate launcher is the fallback. This work must preserve direct presentation performance; do not simply re-enable an overlay that halves presentation rate. Any new Erik source edits require user approval before implementation.

Acceptance gates: open/close reliably with the Claw controller; block gameplay inputs while navigating; restore input correctly on close; settings survive restart and reflect actual effective renderer values; invalid settings recover safely; compare menu-disabled versus menu-closed frame pacing and verify no repeatable regression against the selected baseline. Verify game speed at every offered frame cap before presenting it as a supported gameplay option.

Keep this as a later UI milestone; do not change current launch settings while benchmarking. Existing mod/league/roster phase order remains unchanged.

### Clarification: minimum graphics UI requirement
The supplied image is RinkSide's launcher settings screen. A comparable controller-friendly launcher graphics screen is the MINIMUM deliverable, not merely an optional fallback. It must expose supported frame-rate/VSync controls, display mode, window size, internal render resolution, upscaling/sharpening, texture filtering and anti-aliasing with readable descriptions and saved settings. Unsupported options must be clearly unavailable. Keep window size and render resolution distinct.
Preferred outcome remains equivalent access from the game's main/start menu and ideally pause menu. Launcher and in-game controls must share one settings model and display consistent values. Ship the launcher settings screen if in-game integration takes longer; in-game integration must not delay the minimum UI. No account, online service, or automatic updater is implied by the reference image.
