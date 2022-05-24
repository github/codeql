---
category: minorAnalysis
---
* The `js/resource-exhaustion` query no longer treats the 3-argument version of `Buffer.from` as a sink,
  since it does not allocate a new buffer.
