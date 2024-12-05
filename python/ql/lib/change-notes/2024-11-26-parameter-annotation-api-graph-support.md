---
category: feature
---

- Added support for parameter annotations in API graphs. This means that in a function definition such as `def foo(x: Bar): ...`, you can now use the `getInstanceFromAnnotation()` method to step from `Bar` to `x`. In addition to this, the `getAnInstance` method now also includes instances arising from parameter annotations.
