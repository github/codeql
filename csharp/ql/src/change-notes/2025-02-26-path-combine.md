---
category: newQuery
---
* Added a new query, `csharp/path-combine`, to recommend against the `Path.Combine` method due to it silently discarding its earlier parameters if later parameters are rooted.