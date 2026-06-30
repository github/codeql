---
category: minorAnalysis
---

- Temporarily disabled the `instanceFieldStep` disjunct of the internal `TypeTrackingInput::levelStepCall` predicate, which was introduced in 7.2.0 and caused catastrophic query slowdowns on some OOP-heavy Python codebases (e.g. `mypy` and `dask`).
