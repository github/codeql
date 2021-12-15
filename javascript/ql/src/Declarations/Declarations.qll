/**
 * Provides predicates for finding variable references and declarations
 * in a given function or toplevel.
 */

import javascript

/**
 * Classification of variable references; all references have kind `Ref`,
 * but only declarations have kind `Decl`.
 *
 * Note that references that are not declarations are called accesses elsewhere,
 * but they are not treated specially in this context.
 */
newtype RefKind =
  Ref() or
  Decl()

/**
 * Gets a reference to `var` (if `kind` is `Ref()`) or declaration of
 * `var` (if `kind` is `Decl()`) in `sc`.
 */
VarRef refInContainer(Variable var, RefKind kind, StmtContainer sc) {
  result.getVariable() = var and
  result.getContainer() = sc and
  (kind = Decl() implies result instanceof VarDecl)
}

/**
 * Gets the textually first reference to `var` (if `kind` is `Ref()`) or
 * declaration of `var` (if `kind` is `Decl()`) in `sc`.
 */
VarRef firstRefInContainer(Variable var, RefKind kind, StmtContainer sc) {
  result =
    min(refInContainer(var, kind, sc) as ref
      order by
        ref.getLocation().getStartLine(), ref.getLocation().getStartColumn()
    )
}

/**
 * Gets a reference to `var` (if `kind` is `Ref()`) or declaration of
 * `var` (if `kind` is `Decl()`) in `tl`.
 */
VarRef refInTopLevel(Variable var, RefKind kind, TopLevel tl) {
  result.getVariable() = var and
  result.getTopLevel() = tl and
  (kind = Decl() implies result instanceof VarDecl)
}

/**
 * Gets the textually first reference to `var` (if `kind` is `Ref()`) or
 * declaration of `var` (if `kind` is `Decl()`) in `tl`.
 */
VarRef firstRefInTopLevel(Variable var, RefKind kind, TopLevel tl) {
  result =
    min(refInTopLevel(var, kind, tl) as ref
      order by
        ref.getLocation().getStartLine(), ref.getLocation().getStartColumn()
    )
}
