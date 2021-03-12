lgtm,codescanning
* The class ParameterNode now extends LocalSourceNode, thus making methods like flowsTo available.
* Local taint tracking can now be performed using the `taintFlowsTo` method on the `LocalSourceNode` class. Conversely, the new member predicate `getALocalTaintSource` can be called on a `DataFlow::Node` to obtain a `LocalSourceNode` from which taint can be tracked locally to that data-flow node.
* The new predicate `parameterNode` can now be used to map from a `Parameter` to a data-flow node.
