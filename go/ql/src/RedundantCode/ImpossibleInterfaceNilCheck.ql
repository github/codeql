/**
 * @name Impossible interface nil check
 * @description Comparing a non-nil interface value to nil may indicate a logic error.
 * @kind problem
 * @problem.severity warning
 * @id go/impossible-interface-nil-check
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-570
 * @precision high
 */

import go

/**
 * Holds if `eq` compares interface value `nd` to `nil`.
 */
predicate interfaceNilCheck(DataFlow::EqualityTestNode eq, DataFlow::Node nd) {
  nd = eq.getAnOperand() and
  nd.getType().getUnderlyingType() instanceof InterfaceType and
  eq.getAnOperand().getType() instanceof NilLiteralType
}

/**
 * Holds if the result of `nd` may flow to an interface `nil` check.
 */
predicate flowsToInterfaceNilCheck(DataFlow::Node nd) {
  interfaceNilCheck(_, nd) or
  flowsToInterfaceNilCheck(nd.getASuccessor())
}

/**
 * Holds if wrapping `nd` in an interface produces a non-nil interface value.
 */
private predicate isNonNilWrapperSource(DataFlow::Node nd) {
  exists(Type tp | tp = nd.getType().getUnderlyingType() |
    not tp instanceof InterfaceType and
    not tp instanceof NilLiteralType and
    not tp instanceof InvalidType
  )
}

private DataFlow::Node getWrapperPredecessor(DataFlow::Node nd) {
  result = nd.getAPredecessor() and not result instanceof DataFlow::PostUpdateNode
}

/**
 * Holds if local flow into `nd` may originate from a nil or unknown interface
 * value.
 */
private predicate hasPossiblyNilSource(DataFlow::Node nd) {
  flowsToInterfaceNilCheck(nd) and
  not isNonNilWrapperSource(nd) and
  (
    not exists(getWrapperPredecessor(nd))
    or
    // Uncertain writes may receive replacement values through non-local capture flow.
    nd.(DataFlow::SsaNode).getDefinition() instanceof SsaUncertainWrite
    or
    hasPossiblyNilSource(getWrapperPredecessor(nd))
  )
}

/**
 * Holds if `nd` is a non-nil interface value.
 *
 * A concrete origin and no possibly nil origins establish this even through
 * SSA cycles.
 */
predicate nonNilWrapper(DataFlow::Node nd) {
  flowsToInterfaceNilCheck(nd) and
  not hasPossiblyNilSource(nd) and
  exists(DataFlow::Node source |
    source = getWrapperPredecessor*(nd) and isNonNilWrapperSource(source)
  )
}

from DataFlow::EqualityTestNode eq, DataFlow::Node nd
where
  interfaceNilCheck(eq, nd) and
  nonNilWrapper(nd)
select nd, "This value can never be nil, since it is a wrapped interface value."
