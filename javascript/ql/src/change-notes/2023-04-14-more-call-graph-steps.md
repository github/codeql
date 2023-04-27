---
category: minorAnalysis
---
* Improved the call graph to better handle the case where a function is stored on
  a plain object and subsequently copied to a new host object via an `extend` call.
