/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.DataFlow` instead.
 *
 * Provides C++-specific definitions for use in the data flow library.
 */

private import semmle.code.cpp.Location
private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module CppOldDataFlow implements InputSig<Location> {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }
}
