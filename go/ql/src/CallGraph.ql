/**
 * @name Call graph
 * @description Generates the call graph for the program.
 * @kind graph
 * @id go/call-graph
 */

import go
import semmle.go.dataflow.DataFlow

query predicate edges(CallExpr call, Function f, string key, string value) {
  call.getTarget() = f and
  key = "semmle.label" and
  value = f.getQualifiedName()
}
