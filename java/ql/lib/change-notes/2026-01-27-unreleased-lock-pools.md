---
category: minorAnalysis
---
* The query `java/unreleased-lock` no longer applies to lock types with names ending in "Pool", as these typically manage a collection of resources and the `lock` and `unlock` methods typically only lock one resource at a time. This may lead to a reduction in false positives.
