---
category: breaking
---
* Deleted many deprecated taint-tracking configurations based on `TaintTracking::Configuration`. 
* Deleted many deprecated dataflow configurations based on `DataFlow::Configuration`. 
* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
