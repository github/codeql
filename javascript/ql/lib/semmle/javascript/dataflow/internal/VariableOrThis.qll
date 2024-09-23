private import javascript

cached
private newtype TLocalVariableOrThis =
  TLocalVariable(LocalVariable var) or
  TThis(StmtContainer container) { not container instanceof ArrowFunctionExpr }

/** A local variable or `this` in a particular container. */
class LocalVariableOrThis extends TLocalVariableOrThis {
  /** Gets the local variable represented by this newtype, if any. */
  LocalVariable asLocalVariable() { this = TLocalVariable(result) }

  /** If this represents `this`, gets the enclosing container */
  StmtContainer asThisContainer() { this = TThis(result) }

  /** Gets the name of the variable or the string `"this"`. */
  string toString() { result = this.getName() }

  /** Gets the name of the variable or the string `"this"`. */
  string getName() {
    result = this.asLocalVariable().getName()
    or
    this instanceof TThis and result = "this"
  }

  /** Gets the location of a declaration of this variable, or the declaring container if this is `this`. */
  DbLocation getLocation() {
    result = this.asLocalVariable().getLocation()
    or
    result = this.asThisContainer().getLocation()
  }

  /** Holds if this is a captured variable or captured `this`. */
  predicate isCaptured() {
    this.asLocalVariable().isCaptured()
    or
    hasCapturedThis(this.asThisContainer())
  }

  /** Gets the container declaring this variable or is the enclosing container for `this`. */
  StmtContainer getDeclaringContainer() {
    result = this.asLocalVariable().getDeclaringContainer()
    or
    result = this.asThisContainer()
  }

  /** Gets an access to `this` represented by this value. */
  ThisExpr getAThisAccess() { result.getBindingContainer() = this.asThisContainer() }

  /** Gets an access to variable or `this`. */
  Expr getAnAccess() {
    result = this.asLocalVariable().getAnAccess()
    or
    result = this.getAThisAccess()
  }
}

bindingset[c1, c2]
pragma[inline_late]
private predicate sameContainer(StmtContainer c1, StmtContainer c2) { c1 = c2 }

pragma[nomagic]
private predicate hasCapturedThis(StmtContainer c) {
  exists(ThisExpr expr |
    expr.getBindingContainer() = c and
    not sameContainer(c, expr.getContainer())
  )
}

module LocalVariableOrThis {
  /** Gets the representation of the given local variable. */
  LocalVariableOrThis variable(LocalVariable v) { result.asLocalVariable() = v }

  /** Gets the representation of `this` in the given container. */
  LocalVariableOrThis thisInContainer(StmtContainer c) { result = TThis(c) }
}
