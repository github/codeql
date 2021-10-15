/**
 * Provides classes and predicates for reasoning about explicit and implicit
 * instance accesses.
 */

import java

/**
 * Holds if `cc` constructs an inner class that holds a reference to its
 * enclosing class `t` and the enclosing instance is not given explicitly as a
 * qualifier of the constructor.
 */
private predicate implicitSetEnclosingInstance(ConstructorCall cc, RefType t) {
  exists(InnerClass ic |
    ic = cc.getConstructedType().getSourceDeclaration() and
    ic.hasEnclosingInstance() and
    ic.getEnclosingType() = t and
    not cc instanceof ThisConstructorInvocationStmt and
    not exists(cc.getQualifier())
  )
}

/**
 * Holds if `cc` implicitly sets the enclosing instance of the constructed
 * inner class to `this`.
 */
private predicate implicitSetEnclosingInstanceToThis(ConstructorCall cc) {
  exists(RefType t |
    implicitSetEnclosingInstance(cc, t) and
    cc.getEnclosingCallable().getDeclaringType().getASourceSupertype*() = t
  )
}

/**
 * Gets the closest enclosing type of `ic` that is also a subtype of `t`.
 */
private RefType getEnclosing(InnerClass ic, RefType t) {
  exists(RefType enclosing | enclosing = ic.getEnclosingType() |
    if enclosing.getASourceSupertype*() = t
    then result = enclosing
    else result = getEnclosing(enclosing, t)
  )
}

/**
 * Holds if `cc` implicitly sets the enclosing instance of type `t2` of the
 * constructed inner class to `t1.this`.
 */
private predicate implicitEnclosingThisCopy(ConstructorCall cc, RefType t1, RefType t2) {
  implicitSetEnclosingInstance(cc, t2) and
  not implicitSetEnclosingInstanceToThis(cc) and
  t1 = getEnclosing(cc.getEnclosingCallable().getDeclaringType(), t2)
}

/**
 * Holds if an enclosing instance of the form `t.this` is accessed by `e`.
 */
private predicate enclosingInstanceAccess(ExprParent e, RefType t) {
  e.(InstanceAccess).isEnclosingInstanceAccess(t)
  or
  exists(MethodAccess ma |
    ma.isEnclosingMethodAccess(t) and ma = e and not exists(ma.getQualifier())
  )
  or
  exists(FieldAccess fa | fa.isEnclosingFieldAccess(t) and fa = e and not exists(fa.getQualifier()))
  or
  implicitEnclosingThisCopy(e, t, _)
}

/**
 * Holds if an enclosing instance of the form `t2.this` is accessed by `e`, and
 * this desugars into `this.enclosing.enclosing...enclosing`. The prefix of the
 * desugared access with `i` enclosing instance field accesses has type `t1`.
 */
private predicate derivedInstanceAccess(ExprParent e, int i, RefType t1, RefType t2) {
  enclosingInstanceAccess(e, t2) and
  i = 0 and
  exists(Callable c | c = e.(Expr).getEnclosingCallable() or c = e.(Stmt).getEnclosingCallable() |
    t1 = c.getDeclaringType()
  )
  or
  exists(InnerClass ic |
    derivedInstanceAccess(e, i - 1, ic, t2) and
    ic.getEnclosingType() = t1 and
    ic != t2
  )
}

cached
private newtype TInstanceAccessExt =
  TExplicitInstanceAccess(InstanceAccess ia) or
  TThisQualifier(FieldAccess fa) { fa.isOwnFieldAccess() and not exists(fa.getQualifier()) } or
  TThisArgument(Call c) {
    c instanceof ThisConstructorInvocationStmt
    or
    c instanceof SuperConstructorInvocationStmt
    or
    c.(MethodAccess).isOwnMethodAccess() and not exists(c.getQualifier())
  } or
  TThisEnclosingInstanceCapture(ConstructorCall cc) { implicitSetEnclosingInstanceToThis(cc) } or
  TEnclosingInstanceAccess(ExprParent e, RefType t) {
    enclosingInstanceAccess(e, t) and not e instanceof InstanceAccess
  } or
  TInstanceAccessQualifier(ExprParent e, int i, RefType t1, RefType t2) {
    derivedInstanceAccess(e, i, t1, t2) and t1 != t2
  }

/**
 * A generalization of `InstanceAccess` that includes implicit accesses.
 *
 * The accesses can be divided into 6 kinds:
 * - Explicit: Represented by an `InstanceAccess`.
 * - Implicit field qualifier: The implicit access associated with an
 *   unqualified `FieldAccess` to a non-static field.
 * - Implicit method qualifier: The implicit access associated with an
 *   unqualified `MethodAccess` to a non-static method.
 * - Implicit this constructor argument: The implicit argument of the value of
 *   `this` to a constructor call of the form `this()` or `super()`.
 * - Implicit enclosing instance capture: The implicit capture of the value of
 *   the directly enclosing instance of a constructed inner class. This is
 *   associated with an unqualified constructor call.
 * - Implicit enclosing instance qualifier: The instance access that occurs as
 *   the implicit qualifier of a desugared enclosing instance access.
 *
 * Of these 6 kinds, the fourth (implicit this constructor argument) is always
 * an `OwnInstanceAccess`, whereas the other 5 can be either `OwnInstanceAccess`
 * or `EnclosingInstanceAccess`.
 */
class InstanceAccessExt extends TInstanceAccessExt {
  private string ppBase() {
    exists(EnclosingInstanceAccess enc | enc = this |
      result = enc.getQualifier().toString() + "(" + enc.getType() + ")enclosing"
    )
    or
    isOwnInstanceAccess() and result = "this"
  }

  private string ppKind() {
    isExplicit(_) and result = " <" + getAssociatedExprOrStmt().toString() + ">"
    or
    isImplicitFieldQualifier(_) and result = " <.field>"
    or
    isImplicitMethodQualifier(_) and result = " <.method>"
    or
    isImplicitThisConstructorArgument(_) and result = " <constr(this)>"
    or
    isImplicitEnclosingInstanceCapture(_) and result = " <.new>"
    or
    isImplicitEnclosingInstanceQualifier(_) and result = "."
  }

  /** Gets a textual representation of this element. */
  string toString() { result = ppBase() + ppKind() }

  /** Gets the source location for this element. */
  Location getLocation() { result = getAssociatedExprOrStmt().getLocation() }

  private ExprParent getAssociatedExprOrStmt() {
    this = TExplicitInstanceAccess(result) or
    this = TThisQualifier(result) or
    this = TThisArgument(result) or
    this = TThisEnclosingInstanceCapture(result) or
    this = TEnclosingInstanceAccess(result, _) or
    this = TInstanceAccessQualifier(result, _, _, _)
  }

  /** Gets the callable in which this instance access occurs. */
  Callable getEnclosingCallable() {
    result = getAssociatedExprOrStmt().(Expr).getEnclosingCallable() or
    result = getAssociatedExprOrStmt().(Stmt).getEnclosingCallable()
  }

  /** Holds if this is the explicit instance access `ia`. */
  predicate isExplicit(InstanceAccess ia) { this = TExplicitInstanceAccess(ia) }

  /** Holds if this is the implicit qualifier of `fa`. */
  predicate isImplicitFieldQualifier(FieldAccess fa) {
    this = TThisQualifier(fa) or
    this = TEnclosingInstanceAccess(fa, _)
  }

  /** Holds if this is the implicit qualifier of `ma`. */
  predicate isImplicitMethodQualifier(MethodAccess ma) {
    this = TThisArgument(ma) or
    this = TEnclosingInstanceAccess(ma, _)
  }

  /**
   * Holds if this is the implicit `this` argument of `cc`, which is either a
   * `ThisConstructorInvocationStmt` or a `SuperConstructorInvocationStmt`.
   */
  predicate isImplicitThisConstructorArgument(ConstructorCall cc) { this = TThisArgument(cc) }

  /** Holds if this is the implicit qualifier of `cc`. */
  predicate isImplicitEnclosingInstanceCapture(ConstructorCall cc) {
    this = TThisEnclosingInstanceCapture(cc) or
    this = TEnclosingInstanceAccess(cc, _)
  }

  /**
   * Holds if this is the implicit qualifier of the desugared enclosing
   * instance access `enc`.
   */
  predicate isImplicitEnclosingInstanceQualifier(EnclosingInstanceAccess enc) {
    enc.getQualifier() = this
  }

  /** Holds if this is an access to an object's own instance. */
  predicate isOwnInstanceAccess() { not isEnclosingInstanceAccess(_) }

  /** Holds if this is an access to an enclosing instance. */
  predicate isEnclosingInstanceAccess(RefType t) {
    exists(InstanceAccess ia |
      this = TExplicitInstanceAccess(ia) and ia.isEnclosingInstanceAccess(t)
    )
    or
    this = TEnclosingInstanceAccess(_, t)
    or
    exists(int i | this = TInstanceAccessQualifier(_, i, t, _) and i > 0)
  }

  /** Gets the type of this instance access. */
  RefType getType() {
    isEnclosingInstanceAccess(result)
    or
    isOwnInstanceAccess() and result = getEnclosingCallable().getDeclaringType()
  }

  /** Gets the control flow node associated with this instance access. */
  ControlFlowNode getCfgNode() {
    exists(ExprParent e | e = getAssociatedExprOrStmt() |
      e instanceof Call and result = e
      or
      e instanceof InstanceAccess and result = e
      or
      exists(FieldAccess fa | fa = e |
        if fa instanceof RValue then fa = result else result.(AssignExpr).getDest() = fa
      )
    )
  }
}

/**
 * An access to an object's own instance.
 */
class OwnInstanceAccess extends InstanceAccessExt {
  OwnInstanceAccess() { isOwnInstanceAccess() }
}

/**
 * An access to an enclosing instance.
 */
class EnclosingInstanceAccess extends InstanceAccessExt {
  EnclosingInstanceAccess() { isEnclosingInstanceAccess(_) }

  /** Gets the implicit qualifier of this in the desugared representation. */
  InstanceAccessExt getQualifier() {
    exists(ExprParent e, int i | result = TInstanceAccessQualifier(e, i, _, _) |
      this = TInstanceAccessQualifier(e, i + 1, _, _)
      or
      exists(RefType t | derivedInstanceAccess(e, i + 1, t, t) |
        this = TEnclosingInstanceAccess(e, t) or
        this = TExplicitInstanceAccess(e)
      )
    )
  }
}
