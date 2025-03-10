/**
 * @name Regular expression injection
 * @description
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

private import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.Concepts
private import codeql.rust.security.regex.RegexInjectionExtensions

/**
 * A taint configuration for detecting regular expression injection vulnerabilities.
 */
module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof RegexInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(RegexInjectionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a regular expression sink.
 */
module RegexInjectionFlow = TaintTracking::Global<RegexInjectionConfig>;

private import RegexInjectionFlow::PathGraph

from RegexInjectionFlow::PathNode sourceNode, RegexInjectionFlow::PathNode sinkNode
where RegexInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This regular expression is constructed from a $@.", sourceNode.getNode(), "user-provided value"
