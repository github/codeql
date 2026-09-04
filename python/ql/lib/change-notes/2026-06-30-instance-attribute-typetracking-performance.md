---
category: minorAnalysis
---
* Type tracking now works for values stored in instance attributes and read from outside the class (for example `instance.attr` where the value was assigned to `self.attr` in a method). For performance reasons it may not identify all instances that flow across a call or return before being read.
