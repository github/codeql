---
category: minorAnalysis
---
* The `Deref` trait is now considered during method resolution. This means that method calls on receivers implementing the `Deref` trait will correctly resolve to methods defined on the target type. This may result in additional query results, especially for data flow queries.