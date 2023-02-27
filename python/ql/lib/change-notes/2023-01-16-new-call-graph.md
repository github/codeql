---
category: majorAnalysis
---
* We use a new analysis for the call-graph (determining which function is called). This can lead to changed results. In most cases this is much more accurate than the old call-graph that was based on points-to, but we do lose a few valid edges in the call-graph, especially around methods that are not defined inside its' class.
