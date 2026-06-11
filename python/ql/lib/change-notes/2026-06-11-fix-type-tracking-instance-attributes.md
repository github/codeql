---
category: minorAnalysis
---
* Python type tracking now follows values stored in instance attributes such as `self.attr` across instance methods on the same class. As a result, analysis is more likely to recognize user-defined objects that are stored on `self` and used later in other methods, which may produce additional results.
