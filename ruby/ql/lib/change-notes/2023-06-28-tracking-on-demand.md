---
category: majorAnalysis
---
* The API graph library (`codeql.ruby.ApiGraphs`) has been significantly improved, with better support for inheritance,
  and data-flow nodes can now be converted to API nodes by calling `.track()` or `.backtrack()` on the node.
  API graphs allow for efficient modelling of how a given value is used by the code base, or how values produced by the code base
  are consumed by a library. See the documentation for `API::Node` for details and examples.
