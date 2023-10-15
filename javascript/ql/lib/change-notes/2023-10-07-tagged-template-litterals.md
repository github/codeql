---
category: minorAnalysis
---
* Tagged template literals have been added to `DataFlow::CallNode`. This allows the analysis to find flow into functions called with a tagged template literal, 
  and the arguments to a tagged template literal are part of the API-graph in `ApiGraphs.qll`.