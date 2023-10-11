---
category: minorAnalysis
---
* Treat functions that reach the end of the function as returning in the IR.
  They used to be treated as unreachable but it is allowed in C. 