import ql

/**
 * Holds if we assume `t` is a small type, and
 * variables of this type are therefore not an issue in cartesian products.
 */
predicate isSmallType(Type t) {
  t.getName() = "string" // DataFlow::Configuration and the like
  or
  exists(NewType newType | newType = t.getDeclaration() |
    forex(NewTypeBranch branch | branch = newType.getABranch() | branch.getArity() = 0)
  )
  or
  t.getName() = "boolean"
  or
  exists(NewType newType | newType = t.getDeclaration() |
    forex(NewTypeBranch branch | branch = newType.getABranch() |
      isSmallType(branch.getReturnType())
    )
  )
  or
  exists(NewTypeBranch branch | t = branch.getReturnType() |
    forall(Type param | param = branch.getParameterType(_) | isSmallType(param))
  )
  or
  isSmallType(t.getASuperType())
}
