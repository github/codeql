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

