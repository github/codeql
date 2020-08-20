private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.internal.DataFlowPrivate
private import experimental.dataflow.internal.TaintTrackingPublic

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }

/**
 * Holds if the additional step from `nodeFrom` to `nodeTo` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  localAdditionalTaintStep(nodeFrom, nodeTo)
  or
  any(AdditionalTaintStep a).step(nodeFrom, nodeTo)
}

/**
 * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo` excluding
 * local data flow steps. That is, `nodeFrom` and `nodeTo` are likely to represent
 * different objects.
 */
predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  concatStep(nodeFrom, nodeTo)
  or
  subscriptStep(nodeFrom, nodeTo)
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to concatenation.
 *
 * Note that since we cannot easily distinguish interesting types (like string, list, tuple), so
 * we consider any `+` operation to propagate taint. After consulting with the JS team, this
 * should doesn't sound like it is a big problem in practice.
 */
predicate concatStep(DataFlow::CfgNode nodeFrom, DataFlow::CfgNode nodeTo) {
  exists(BinaryExprNode add | add = nodeTo.getNode() |
    add.getOp() instanceof Add and
    (
      add.getLeft() = nodeFrom.getNode()
      or
      add.getRight() = nodeFrom.getNode()
    )
  )
}

/**
 * Holds if taint can flow from `nodeFrom` to `nodeTo` with a step related to subscripting.
 */
predicate subscriptStep(DataFlow::CfgNode nodeFrom, DataFlow::CfgNode nodeTo) {
  nodeTo.getNode().(SubscriptNode).getObject() = nodeFrom.getNode()
}
