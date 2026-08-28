---
category: minorAnalysis
---
* Canonical paths for Rust trait items now use the format `<crate::Trait>::item` instead of
  `crate::Trait::item`. Custom data extension models that reference trait items must be
  updated to use the new format.
