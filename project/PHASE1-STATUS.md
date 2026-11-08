# Phase 1 progress

- PASS: plan reordered; low-power testing is Phase 4.
- PASS: 171 extracted SSD files independently SHA256 verified; source ISO preserved.
- PASS: Erik 831f49b7d6c0fcf43b3633f4958b38cb5c4cd66d and SDK c94f5ebdcb3c9d1a460ca48e04f9758448f8d518 pinned.
- PASS: user approved matching Erik setup; combined SDK patch applied once.
- PASS: LLVM 20.1.8 installed and compiler identification verified by CMake.
- PASS: SDK submodules checked out at all exact pinned revisions; inventory in manifests/sdk-submodules.txt.
- IN PROGRESS: SDK compilation after successful configure. Windows symlink compatibility fix points libmspack at its real source directory.
- IN PROGRESS: opt-in Windows SDK 0.10 Vulkan game build adaptation; compilation not verified yet.
- PASS: SDK code generator compiled with Clang 20.1.8.
- PASS: native game code generation completed in 857.4 seconds (728 generated files, approximately 400 MB).
- PENDING: game build/rebuild and artifact hashes.
- PENDING: launch/controller/audio/movie/match/save-reload checks.

Build recipe: tools/build-sdk.cmd. Logs: logs/sdk-submodules.log and logs/sdk-build.log.
No performance results exist yet. Do not advance to Phase 2 until Phase 1 passes.

## Windows build findings
- CMake configured the game successfully.
- First compile reached the SDK graphics stage; Erik's thread CPU timer used Linux CLOCK_THREAD_CPUTIME_ID. Windows GetThreadTimes adaptation is implemented, awaiting resumed compile. Unavailable timing is explicitly logged.
- Windows Vulkan DLL exports are enabled because the title subclasses its backend.
- An SDK-triggered second codegen pass is running; a single build resume is queued after the original Ninja process exits.
- No playable executable or gameplay benchmark has been verified yet.
## Latest verified result
- PASS: Windows Release game executable linked successfully (game-compile-4.log).
- PASS: executable and runtime DLLs installed at C:\Emulation\NHL-Legacy-Claw; hashes recorded.
- PASS: first launch reached rendered English language-selection screen.
- IN PROGRESS: repeat build (incremental; not a clean reproducibility build).
- PENDING: controller/audio/movie checks, complete match, save/reload and three launches. Phase 1 remains open until these pass.
- User reported the prior match completed; relaunched with Erik baseline environment and the same isolated profile. Audio/control details and save/reload remain to verify.
- Benchmark configuration updated at user request: supersampling=1 (native720p), vsync remains0. Previous2x settings backed up. Capture collector uses cached performance counters with approximately1second cadence; full game capture cadence still needs verification.
