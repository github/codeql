---
category: minorAnalysis
---
* Python type tracking now follows values stored in instance attributes such as `self.attr` across instance methods, including across a class hierarchy (for example, a value stored on `self.attr` in a base class and read in a subclass, or vice versa). As a result, analysis is more likely to recognize user-defined objects that are stored on `self` and used later in other methods, which may produce additional results.
