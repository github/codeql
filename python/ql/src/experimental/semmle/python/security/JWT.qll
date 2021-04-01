import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow

predicate isEmptyOrNone(DataFlow::Node arg) { isEmpty(arg) or isNone(arg) }

predicate isEmpty(DataFlow::Node arg) { arg.asExpr().(Str_).getS() = "" }

predicate isNone(DataFlow::Node arg) {
  exists(NameConstant noneName | noneName.getId() = "None" and arg.asExpr() = noneName)
}
