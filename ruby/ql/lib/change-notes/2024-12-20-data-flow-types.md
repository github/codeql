---
category: minorAnalysis
---
* Types are now being tracked in data flow, but only when the type of an object is obvious from the context. For example, `C.new` has guaranteed type `C`, while in `def add(x, y) { x + y }` we cannot assign a type to `x + y` (it could, for instance, be both `String` and `Integer`). Tracking types allows us to remove false-positive results when type incompatibility can be established.