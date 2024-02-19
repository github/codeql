---
category: breaking
---
* The `edges` predicate contained in `PathGraph` now contains two additional columns for propagating model provenance information. This is primarily an internal change without any impact on any APIs, except for specialised queries making use of `MergePathGraph` in conjunction with custom `PathGraph` implementations. Such queries will need to be updated to reference the two new columns. This is expected to be very rare, as `MergePathGraph` is an advanced feature, but it is a breaking change for any such affected queries.
