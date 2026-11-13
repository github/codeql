---
category: minorAnalysis
---

- The C# extractor continues to use the NuGet CLI to restore dependencies from `packages.config` files when private NuGet registries are configured, but excludes those private registries from the CLI's sources. Other applicable feeds remain available, while private registries continue to be used by `dotnet restore`.
