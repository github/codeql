/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id unified/swift/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import unified
private import codeql.unified.internal.typeinference.TypeInference as TypeInference

private predicate heuristicSink(DataFlow::Node node) {
  exists(Argument arg |
    node.asExpr() = arg.getValue() and
    (
      arg.getName() = "sql"
      or
      exists(CallExpr call, Parameter param |
        arg = call.getAnArgument() and
        param = TypeInference::resolveCallTarget(call).getAParameter() and
        param.getPattern().(Identifier).getValue() = "sql" and
        (
          arg.getPositionalIndex() = param.getPositionalIndex()
          or
          arg.getName() = param.getExternalName()
        )
      )
    )
  )
}

/**
 * A taint configuration for tainted data that reaches a SQL sink.
 */
module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    Models::isSink(node, "sql-injection")
    or
    heuristicSink(node)
  }

  predicate isBarrier(DataFlow::Node node) {
    // TODO: Port the numeric-type barrier from original Swift's SqlInjectionExtensions.qll.
    none()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

import SqlInjectionFlow::PathGraph

from SqlInjectionFlow::PathNode sourceNode, SqlInjectionFlow::PathNode sinkNode
where SqlInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This query depends on a $@.",
  sourceNode.getNode(), "user-provided value"
