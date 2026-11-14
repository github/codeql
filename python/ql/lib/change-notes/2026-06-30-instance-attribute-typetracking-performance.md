---
category: minorAnalysis
---
* Type tracking now works for values stored in instance attributes and read from outside the class (for example `instance.attr` where the value was assigned to `self.attr` in a method), provided the instance at the read is reachable by local flow from a resolved constructor call. This excludes, for example, instances returned by a function and module-level instances read inside a function.
