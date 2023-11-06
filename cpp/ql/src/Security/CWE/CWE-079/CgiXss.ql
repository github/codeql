/**
 * @name CGI script vulnerable to cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id cpp/cgi-xss
 * @tags security
 *       external/cwe/cwe-079
 */

import cpp
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.IR
import Flow::PathGraph

/** A call that prints its arguments to `stdout`. */
class PrintStdoutCall extends FunctionCall {
  PrintStdoutCall() { this.getTarget().hasGlobalOrStdName(["puts", "printf"]) }
}

/** A read of the QUERY_STRING environment variable */
class QueryString extends EnvironmentRead {
  QueryString() { this.getEnvironmentVariable() = "QUERY_STRING" }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asIndirectExpr() instanceof QueryString }

  predicate isSink(DataFlow::Node node) {
    exists(PrintStdoutCall call | call.getAnArgument() = [node.asIndirectExpr(), node.asExpr()])
  }

  predicate isBarrier(DataFlow::Node node) {
    isSink(node) and node.asExpr().getUnspecifiedType() instanceof ArithmeticType
    or
    node.asInstruction().(StoreInstruction).getResultType() instanceof ArithmeticType
  }
}

module Flow = TaintTracking::Global<Config>;

from QueryString query, Flow::PathNode sourceNode, Flow::PathNode sinkNode
where
  Flow::flowPath(sourceNode, sinkNode) and
  query = sourceNode.getNode().asIndirectExpr()
select sinkNode.getNode(), sourceNode, sinkNode, "Cross-site scripting vulnerability due to $@.",
  query, "this query data"
