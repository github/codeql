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
    // In september 2021 we changed how we do taint-propagation for method calls (mostly
    // relating to modeled frameworks/libraries). We used to do `obj -> obj.meth` and
    // `obj.meth -> obj.meth()` in two separate steps, and now do them in one
    // `obj -> obj.meth()`. To be able to compare the overall reach between these two
    // version, we don't want this query to alert us to the fact that we no longer taint
    // the node in the middle (since that is just noise).
    // see https://github.com/github/codeql/pull/6349
    //
    // We should be able to remove the following few lines of code once we don't care to
    // compare with the old (before September 2021) way of doing taint-propagation for
    // method calls.
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
