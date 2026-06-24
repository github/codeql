---
category: majorAnalysis
---
* Simplified and streamlined the use of NuGet sources when downloading dependencies via `[mono] nuget.exe` in `build-mode: none`: NuGet sources are now supplied via the `-Source` flag instead of moving or creating `nuget.config` files in the checked-out repository, private registries are used if configured, and only reachable feeds are used when NuGet feed checking is enabled (the default).
