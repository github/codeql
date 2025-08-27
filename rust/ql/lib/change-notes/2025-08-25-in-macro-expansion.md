---
category: minorAnalysis
---
* Attribute macros are now taken into account when identifying macro-expanded code. This affects the queries `rust/unused-variable` and `rust/unused-value`, which exclude results in macro-expanded code.