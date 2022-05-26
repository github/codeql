/**
 * @name Impossible interface nil check
 * @description Comparing a non-nil interface value to nil may indicate a logic error.
 * @kind problem
 * @problem.severity warning
 * @id go/impossible-interface-nil-check
 * @tags correctness
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
 * Holds if `nd` is a non-nil interface value.
 */
predicate nonNilWrapper(DataFlow::Node nd) {
  flowsToInterfaceNilCheck(nd) and
  forex(DataFlow::Node pred | pred = nd.getAPredecessor() |
    exists(Type predtp | predtp = pred.getType().getUnderlyingType() |
      not predtp instanceof InterfaceType and
      not predtp instanceof NilLiteralType and
      not predtp instanceof InvalidType
    )
    or
    nonNilWrapper(pred)
  )
}

from DataFlow::EqualityTestNode eq, DataFlow::Node nd
where
  interfaceNilCheck(eq, nd) and
  nonNilWrapper(nd)
select nd, "This value can never be nil, since it is a wrapped interface value."
