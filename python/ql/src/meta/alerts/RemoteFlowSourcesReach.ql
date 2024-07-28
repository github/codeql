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

module RemoteFlowSourceReachConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof RemoteFlowSource and
    not node.getLocation().getFile() instanceof IgnoredFile
  }

  predicate isSink(DataFlow::Node node) {
    not node.getLocation().getFile() instanceof IgnoredFile
    // We could try to reduce the number of sinks in this configuration, by only
    // allowing something that is on one end of a localFlowStep, readStep or storeStep,
    // however, it's a brittle solution that requires us to remember to update this file
    // if/when adding something new to the data-flow library.
    //
    // From testing on a few projects, trying to reduce the number of nodes, we only
    // gain a reduction in the range of 40%, and while that's nice, it doesn't seem
    // worth it to me for a meta query.
  }
}

module RemoteFlowSourceReachFlow = TaintTracking::Global<RemoteFlowSourceReachConfig>;

from DataFlow::Node reachable
where RemoteFlowSourceReachFlow::flow(_, reachable)
select reachable, prettyNode(reachable)
