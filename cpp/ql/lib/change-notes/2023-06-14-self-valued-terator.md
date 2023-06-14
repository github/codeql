---
category: minorAnalysis
---
* Iterators which are their own value type are now ignored by the iterator model. This should fix a rare situation where no dataflow was generated for these types.
