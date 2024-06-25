---
category: minorAnalysis
---
* A bug has been fixed in the heuristic identification of uncertain control
  flow, which is used to filter data flow in order to improve performance and
  reduce false positives. This fix means that slightly more code is identified
  and hence pruned from data flow.
