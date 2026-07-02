---
category: minorAnalysis
---
* Type tracking of values stored in instance attributes and read from outside the class (for example `instance.attr` where the value was assigned to `self.attr` in a method) no longer relies on a dedicated instance type-tracker. This avoids a structural mutual recursion that could cause catastrophic query slowdowns on some OOP-heavy code bases. Such reads are now resolved using local flow from the constructor call, which is slightly less precise for instances that flow across a call or return before being read.
