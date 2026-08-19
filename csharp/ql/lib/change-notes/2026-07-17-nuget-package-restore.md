---
category: majorAnalysis
---
* Simplified and streamlined the use of NuGet sources when downloading dependencies. In fallback scenarios and specialized package downloads, NuGet sources are now passed directly to `dotnet restore` via the CLI. Furthermore, no `nuget.config` files are created for fallback scenarios, and private registries are used when attempting to download missing packages that were not restored as part of the normal `dotnet restore` process.
