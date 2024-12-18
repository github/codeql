/**
 * Patches all DataFlow::CallCfgNode adding a getTarget predicate to a new
 * subclass of CallCfgNode
 */

import python
private import semmle.python.dataflow.new.internal.TypeTrackingImpl
private import semmle.python.ApiGraphs

class CallCfgNodeWithTarget extends DataFlow::Node instanceof DataFlow::CallCfgNode {
  DataFlow::Node getTarget() { TypeTrackingInput::returnStep(result, this) }
}
