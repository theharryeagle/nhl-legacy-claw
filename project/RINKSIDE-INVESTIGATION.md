# RinkSide investigation

Local package evidence:
- README describes a native Xbox 360 ReXGlue port, with Rust/Slint launcher, ISO installer, accounts, networking, and community roster updates on Play.
- payload/manifest.toml identifies version 0.16.0, SDK 0.8.1, win-amd64-vk-opt; same supported default.xex SHA256 as Erik/Puckhead.
- Local runtime logs confirm Vulkan FSI and readback_resolve=some, size gate 3000000 bytes.
- Current local settings: ffx_effect=bilinear, fps_cap=-1, fxaa=0, anisotropic=5.
- Launcher binary contains --apply-roster-pack; notices reference tools/rinkside-rs/Cargo.lock and manifest references release/package_online.ps1.

Conclusion: strong evidence of the Puckhead/ReXGlue port family, with a custom online/roster launcher. Exact parent commit and Puck Peak data provenance are not established. Do not equate community rosters with confirmed Puck Peak assets.

Public Puckhead v0.6.0 release identifies Vulkan FSI, PGO + ThinLTO, x86-64-v3, FidelityFX and FFmpeg. RinkSide manifest says vk-opt; PGO for this specific binary is unverified.
Source: https://github.com/puckhead73/nhl-legacy-recomp/releases/tag/v0.6.0

Next comparison: same 720p/60 cap, same scene and power/boost state, frame-time logging; compare RinkSide FSI/some against Erik RTV/fast. Supersampling 2x in each dimension means four times the pixels (2560x1440 versus1280x720), so existing 30/60 FPS reports are not equal-load comparisons. No source changes applied during this investigation.
