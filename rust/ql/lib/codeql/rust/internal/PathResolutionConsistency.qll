/**
 * Provides classes for recognizing path resolution inconsistencies.
 */

private import rust
private import PathResolution

/** Holds if `p` may resolve to multiple items including `i`. */
query predicate multiplePathResolutions(Path p, ItemNode i) {
  p.fromSource() and
  i = resolvePath(p) and
  // known limitation for `$crate`
  not p.getQualifier*().(RelevantPath).isUnqualified("$crate") and
  // `use foo::bar` may use both a type `bar` and a value `bar`
  not p =
    any(UseTree use |
      not use.isGlob() and
      not use.hasUseTreeList()
    ).getPath() and
  // avoid overlap with `multipleCallTargets` below
  not p = any(CallExpr ce).getFunction().(PathExpr).getPath() and
  strictcount(resolvePath(p)) > 1
}

/** Holds if `call` has multiple static call targets including `target`. */
query predicate multipleCallTargets(CallExprBase call, Callable target) {
  target = call.getStaticTarget() and
  strictcount(call.getStaticTarget()) > 1
}

/** Holds if `fe` resolves to multiple record fields including `field`. */
query predicate multipleStructFields(FieldExpr fe, StructField field) {
  field = fe.getStructField() and
  strictcount(fe.getStructField()) > 1
}

/** Holds if `fe` resolves to multiple tuple fields including `field`. */
query predicate multipleTupleFields(FieldExpr fe, TupleField field) {
  field = fe.getTupleField() and
  strictcount(fe.getTupleField()) > 1
}

/** Holds if `p` may resolve to multiple items including `i`. */
query predicate multipleCanonicalPaths(ItemNode i, Crate c, string path) {
  path = i.getCanonicalPath(c) and
  strictcount(i.getCanonicalPath(c)) > 1
}

/**
 * Gets counts of path resolution inconsistencies of each type.
 */
int getPathResolutionInconsistencyCounts(string type) {
  type = "Multiple path resolutions" and
  result = count(Path p | multiplePathResolutions(p, _) | p)
  or
  type = "Multiple static call targets" and
  result = count(CallExprBase call | multipleCallTargets(call, _) | call)
  or
  type = "Multiple record fields" and
  result = count(FieldExpr fe | multipleStructFields(fe, _) | fe)
  or
  type = "Multiple tuple fields" and
  result = count(FieldExpr fe | multipleTupleFields(fe, _) | fe)
  or
  type = "Multiple canonical paths" and
  result = count(ItemNode i | multipleCanonicalPaths(i, _, _) | i)
}
