/**
 * @kind path-problem
 */

import ruby
import codeql.ruby.DataFlow
import DataFlow::PathGraph

class Conf extends DataFlow::Configuration {
  Conf() { this = "Conf" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().getExpr().(StringLiteral).getConstantValue().isString("taint")
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getMethodName() = "sink" and
      mc.getAnArgument() = sink.asExpr().getExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
