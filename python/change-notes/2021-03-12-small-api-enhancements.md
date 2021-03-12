lgtm,codescanning
* Make `ParameterNode` extend `LocalSourceNode`, thus making members like `flowsTo` available.
* Add member predicate `taintFlowsTo` to `LocalSourceNode` facilitating smoother syntax for local taint tracking.
* Add member `getALocalTaintSource` to `DataFlow::Node` facilitating smoother syntax for local taint tracking.
* Add predicate `parameterNode` to map from a `Parameter` to a data-flow node.
