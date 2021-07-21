/**
 * @name Remote flow sources reach
 * @description Nodes that can be reached with taint tracking from sources of
 *   remote user input.
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/alerts/remote-flow-sources-reach
 * @tags meta
 * @precision very-low
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import meta.MetaMetrics
private import semmle.python.dataflow.new.internal.PrintNode

class RemoteFlowSourceReach extends TaintTracking::Configuration {
  RemoteFlowSourceReach() { this = "RemoteFlowSourceReach" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof RemoteFlowSource and
    not node.getLocation().getFile() instanceof IgnoredFile
  }

  override predicate isSink(DataFlow::Node node) {
    not node.getLocation().getFile() instanceof IgnoredFile and
    (
      node instanceof RemoteFlowSource
      or
      this.isAdditionalFlowStep(_, node)
    ) and
    // we used to do `obj -> obj.meth` and `obj.meth -> obj.meth()` in two separate
    // steps, and now do them in one `obj -> obj.meth()`. So we're going to ignore the
    // fact that we no longer taint the node in the middle.
    not exists(DataFlow::MethodCallNode c |
      node = c.getFunction() and
      this.isAdditionalFlowStep(c.getObject(), node) and
      this.isAdditionalFlowStep(node, c)
    )
  }
}

from RemoteFlowSourceReach cfg, DataFlow::Node reachable
where cfg.hasFlow(_, reachable)
select reachable, prettyNode(reachable)
