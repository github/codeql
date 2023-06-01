---
category: majorAnalysis
---
* The extractor has been changed to run after the traced compiler call. This allows inspecting compiler generated files, such as the output of source generators. With this change, `.cshtml` files and their generated `.cshtml.g.cs` counterparts are extracted on dotnet 6 and above.
