---
category: breaking
---
* The GitHub Actions control flow graph (CFG) now uses the shared CFG library.
  The CFG includes explicit before and after nodes and uses the shared entry and
  exit node representations. Existing code that relies on specific CFG nodes,
  edges, textual representations, or basic block boundaries may need to be
  updated. The legacy `Completion`, `NormalCompletion`, `SimpleCompletion`,
  `BooleanCompletion`, and `ReturnCompletion` classes have been removed because
  completions are no longer part of the Actions CFG API. Code that inspected
  completions should inspect CFG edge labels such as `DirectSuccessor`,
  `BooleanSuccessor`, and `ReturnSuccessor` instead.
