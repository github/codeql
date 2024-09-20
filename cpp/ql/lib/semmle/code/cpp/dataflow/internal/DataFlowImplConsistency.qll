/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.DataFlow` instead.
 *
 * Provides consistency queries for checking invariants in the language-specific
 * data-flow classes and predicates.
 */

private import cpp
private import DataFlowImplSpecific
private import TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, CppOldDataFlow> {
  predicate argHasPostUpdateExclude(Private::ArgumentNode n) {
    // Is the null pointer (or something that's not really a pointer)
    exists(n.asExpr().getValue())
    or
    // Isn't a pointer or is a pointer to const
    forall(DerivedType dt | dt = n.asExpr().getActualType() |
      dt.getBaseType().isConst()
      or
      dt.getBaseType() instanceof RoutineType
    )
    // The above list of cases isn't exhaustive, but it narrows down the
    // consistency alerts enough that most of them are interesting.
  }
}

module Consistency = MakeConsistency<Location, CppOldDataFlow, CppOldTaintTracking, Input>;
