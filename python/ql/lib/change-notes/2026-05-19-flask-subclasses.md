---
category: minorAnalysis
---
* `Flask::instance` will now also return instances of subclasses defined in te source tree. Previously, these were filtered out. `Flask::classRef` has been deprecated in favor of `Flask::subclassRef` since it already returned some subclasses.