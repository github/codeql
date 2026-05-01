---
category: majorAnalysis
---
* When resolving dependencies in `build-mode: none`, `dotnet restore` now explicitly receives reachable NuGet feeds configured in `nuget.config` when feed responsiveness checking is enabled (the default), and any private registries directly, improving reliability when default feeds are unavailable or restricted.
