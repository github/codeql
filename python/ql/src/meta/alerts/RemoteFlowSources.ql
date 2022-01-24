/**
 * @name Remote flow sources
 * @description Sources of remote user input.
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/alerts/remote-flow-sources
 * @tags meta
 * @precision very-low
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import meta.MetaMetrics

from RemoteFlowSource source
where not source.getLocation().getFile() instanceof IgnoredFile
select source, "RemoteFlowSource: " + source.getSourceType()
