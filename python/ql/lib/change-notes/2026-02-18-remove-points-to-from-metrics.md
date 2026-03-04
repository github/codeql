---
category: breaking
---

- The `Metrics` library no longer contains code that depends on the points-to analysis. The removed functionality has instead been moved to the `LegacyPointsTo` module, to classes like `ModuleMetricsWithPointsTo` etc. If you depend on any of these classes, you must now remember to import `LegacyPointsTo`, and use the appropriate types in order to use the points-to-based functionality.
