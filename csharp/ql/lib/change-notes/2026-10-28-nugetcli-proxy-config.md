---
category: minorAnalysis
---

- When private NuGet registries are configured, the extractor only attempts to restore dependencies listed in `packages.config` files using `dotnet restore` instead of the NuGet CLI so that the private registry configuration is respected.
