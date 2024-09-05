---
category: breaking
---
* Deleted many deprecated taint-tracking configurations based on `TaintTracking::Configuration`. 
* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
