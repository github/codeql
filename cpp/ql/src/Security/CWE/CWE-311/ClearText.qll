private import cpp
private import semmle.code.cpp.dataflow.new.DataFlow

/**
 * Holds if `node` should be a barrier for the CWE-311 queries
 * because it is of a non-char integral type.
 */
predicate isBarrier(DataFlow::Node node) {
  exists(IntegralType type |
    type = node.asCertainDefinition().getUnspecifiedType() and
    not type instanceof CharType and
    not type instanceof WideCharType and
    not type instanceof Char8Type and
    not type instanceof Char16Type and
    not type instanceof Char32Type
  )
}

private Expr asExprOrIndirectExpr(DataFlow::Node node, int indirectionIndex) {
  indirectionIndex = 0 and
  result = node.asExpr()
  or
  result = node.asIndirectExpr(indirectionIndex)
}

/**
 * Holds if `source` is the relevant `DataFlow::Node` for
 * expression `e`.
 */
predicate isSource(DataFlow::Node source, Expr e) {
  exists(int indirectionIndex |
    e = asExprOrIndirectExpr(source, indirectionIndex) and
    if e.getUnspecifiedType() instanceof ReferenceType
    then indirectionIndex = 1
    else indirectionIndex = 0
  )
}
