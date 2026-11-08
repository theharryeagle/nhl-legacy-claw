# Rebuilding from the handoff

The archive is complete for source review. The SDK's CMake checks for .git metadata inside required submodules, which the ZIP omits. For a clean build, reconstruct the Git working copies from the recorded pins before running the supplied build scripts.

1. Read source-provenance.json for the exact origin and HEAD of source/erik and source/sdk.
2. Clone each origin into fresh directories and check out its recorded HEAD. Initialize the SDK submodules with git submodule update --init --recursive. Confirm their revisions against the recorded submodule list.
3. In the fresh Erik checkout apply patches/erik-live.patch with git apply --check --ignore-space-change first, then git apply --ignore-space-change. Repeat for sdk-live.patch inside the SDK checkout. The SDK diff already includes the combined Erik patch and Windows adaptations. No additional patch is needed.
4. Put the fresh checkouts under C:/Coding/NHL-Legacy-Claw/source/erik and source/sdk on a separate build machine, or update paths in the scripts to point to your new working directory. Preserve existing installations. Use the tool versions in START-HERE.md and supply the verified default.xex from your own disc. Generate C++ afresh on a relocated build to avoid stale absolute paths in dependency files. Run build-sdk.cmd and build-game.cmd from project/tools in that order.
5. Use the build outputs and launch arguments in START-HERE.md. Validate a menu, match, and save/reload in a separate profile before making optimization changes.

These instructions reconstruct the known source and patches. A clean build from the exported archive has not been run.
