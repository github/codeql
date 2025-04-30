/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being
 *              escaped, otherwise a malicious user may be able to inject an expression that
 *              could modify the meaning of the expression, causing it to match unexpected
 *              strings.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id rust/regex-injection
 * @tags security
 *       external/cwe/cwe-020
 *       external/cwe/cwe-074
 */

private import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.security.regex.RegexInjectionExtensions

/**
 * A taint configuration for detecting regular expression injection vulnerabilities.
 */
module RegexInjectionConfig implements DataFlow::ConfigSig {
  import RegexInjection

  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(AdditionalFlowStep s).step(nodeFrom, nodeTo)
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
