---
category: minorAnalysis
---

- The call graph resolution no longer considers methods marked using [`@typing.overload`](https://typing.python.org/en/latest/spec/overload.html#overloads) as valid targets. This ensures that only the method that contains the actual implementation gets resolved as a target.
