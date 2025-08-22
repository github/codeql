private import javascript
private import DataFlowNode

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

  /** Gets an explicit access to `this` represented by this value. */
  ThisExpr getAThisExpr() { result.getBindingContainer() = this.asThisContainer() }

  /** Gets an implicit or explicit use of the `this` represented by this value. */
  ThisUse getAThisUse() { result.getBindingContainer() = this.asThisContainer() }

  /** Gets an expression that accesses this variable or `this`. */
  ControlFlowNode getAUse() {
    result = this.asLocalVariable().getAnAccess()
    or
    result = this.getAThisUse()
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

/**
 * An explicit or implicit use of `this`.
 *
 * Implicit uses include `super()` calls and instance field initializers (which includes TypeScript parameter fields).
 */
abstract class ThisUse instanceof ControlFlowNode {
  /** Gets the container binding the `this` being accessed */
  abstract StmtContainer getBindingContainer();

  /** Get the container in which `this` is being accessed. */
  abstract StmtContainer getUseContainer();

  /** Gets a string representation of this element. */
  string toString() { result = super.toString() }

  /** Gets the location of this use of `this`. */
  DbLocation getLocation() { result = super.getLocation() }
}

private predicate implicitThisUse(ControlFlowNode node, StmtContainer thisBinder) {
  thisBinder = node.(SuperExpr).getBinder()
  or
  exists(FieldDefinition field |
    not field.isStatic() and
    node = field and
    thisBinder = field.getDeclaringClass().getConstructor().getBody()
  )
}

class ImplicitThisUse extends ThisUse {
  ImplicitThisUse() { implicitThisUse(this, _) }

  override StmtContainer getBindingContainer() { implicitThisUse(this, result) }

  override StmtContainer getUseContainer() {
    // The following differs from FieldDefinition.getContainer() which returns the container enclosing
    // the class, not the class constructor.
    // TODO: consider changing this in FieldDefinition.getContainer()
    result = this.(FieldDefinition).getDeclaringClass().getConstructor().getBody()
    or
    result = this.(SuperExpr).getContainer()
  }
}

private class ExplicitThisUse extends ThisUse instanceof ThisExpr {
  override StmtContainer getBindingContainer() { result = ThisExpr.super.getBindingContainer() }

  override StmtContainer getUseContainer() { result = ThisExpr.super.getContainer() }
}
