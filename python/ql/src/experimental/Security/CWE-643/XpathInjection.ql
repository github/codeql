/**
 * @name XPath query built from user-controlled sources
 * @description Building a XPath query from user-controlled sources is vulnerable to insertion of
 *              malicious Xpath code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

private import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
import XpathInjection::XpathInjection
import DataFlow::PathGraph

class XpathInjectionConfiguration extends TaintTracking::Configuration {
  XpathInjectionConfiguration() { this = "PathNotNormalizedConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}

from XpathInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "This Xpath query depends on $@.", source, "a user-provided value"
