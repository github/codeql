import cpp

/**
 * Gets a `Field` that is nested within the given `Struct`.
 *
 * This identifies `Field`s which are located in the same memory
 */
private Field getANestedField(Struct s) {
  result = s.getAField()
  or
  exists(NestedStruct ns |
    s = ns.getDeclaringType() and
    result = getANestedField(ns)
  )
}

/**
 * Unwraps a series of field accesses to determine the inner-most qualifier.
 */
private Expr getUltimateQualifier(FieldAccess fa) {
  exists(Expr qualifier | qualifier = fa.getQualifier() |
    result = getUltimateQualifier(qualifier)
    or
    not qualifier instanceof FieldAccess and result = qualifier
  )
}

/**
 * Accesses to nested fields.
 */
class NestedFieldAccess extends FieldAccess {
  Expr ultimateQualifier;

  NestedFieldAccess() {
    ultimateQualifier = getUltimateQualifier(this) and
    getTarget() = getANestedField(ultimateQualifier.getType().stripType())
  }

  /** Gets the ultimate qualifier of this nested field access. */
  Expr getUltimateQualifier() { result = ultimateQualifier }
}
