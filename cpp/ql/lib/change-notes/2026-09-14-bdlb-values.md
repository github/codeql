---
category: minorAnalysis
---
* Added contained-value flow models for BDE `bdlb::NullableValue` and the `bdlb::Variant` family, including copy and move operations, allocator-extended copies and moves, and single-argument arithmetic, enum, and pointer emplacement. Nullable access includes `value`, `valueOr`, `addressOr`, and `valueOrNull`; variant access includes `the`. Writes through returned references and pointers are tracked at nested indirection depths.
