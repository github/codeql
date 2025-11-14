/**
 * Provides classes and predicates for SSA representation (Static Single Assignment form).
 *
 * An SSA variable consists of the pair of a `SsaSourceVariable` and a
 * `ControlFlowNode` at which it is defined. Each SSA variable is defined
 * either by a phi node, an implicit initial value (for parameters and fields),
 * an explicit update, or an implicit update (for fields).
 * An implicit update occurs either at a `Call` that might modify a field, or
 * at another update that can update the qualifier of a field.
 */
overlay[local?]
module;

import java
private import internal.SsaImpl
import internal.SsaImpl::Ssa as Ssa
import Ssa

/**
 * A fully qualified variable in the context of a `Callable` in which it is
 * accessed.
 *
 * This is either a local variable or a fully qualified field, `q.f1.f2....fn`,
 * where the base qualifier `q` is either `this`, a local variable, or a type
 * in case `f1` is static.
 */
class SsaSourceVariable extends TSsaSourceVariable {
  /** Gets the variable corresponding to this `SsaSourceVariable`. */
  Variable getVariable() {
    this = TLocalVar(_, result) or
    this = TPlainField(_, result) or
    this = TEnclosingField(_, result, _) or
    this = TQualifiedField(_, _, result)
  }

  /**
   * Gets an access of this `SsaSourceVariable`. This access is within
   * `this.getEnclosingCallable()`. Note that `LocalScopeVariable`s that are
   * accessed from nested callables are therefore associated with several
   * `SsaSourceVariable`s.
   */
  cached
  VarAccess getAnAccess() {
    exists(LocalScopeVariable v, Callable c |
      this = TLocalVar(c, v) and result = v.getAnAccess() and result.getEnclosingCallable() = c
    )
    or
    exists(Field f, Callable c | fieldAccessInCallable(result, f, c) |
      (result.(FieldAccess).isOwnFieldAccess() or f.isStatic()) and
      this = TPlainField(c, f)
      or
      exists(RefType t |
        this = TEnclosingField(c, f, t) and result.(FieldAccess).isEnclosingFieldAccess(t)
      )
      or
      exists(SsaSourceVariable q |
        result.getQualifier() = q.getAnAccess() and this = TQualifiedField(c, q, f)
      )
    )
  }

  /** Gets the `Callable` in which this `SsaSourceVariable` is defined. */
  Callable getEnclosingCallable() {
    this = TLocalVar(result, _) or
    this = TPlainField(result, _) or
    this = TEnclosingField(result, _, _) or
    this = TQualifiedField(result, _, _)
  }

  /** Gets a textual representation of this `SsaSourceVariable`. */
  string toString() {
    exists(LocalScopeVariable v, Callable c | this = TLocalVar(c, v) |
      if c = v.getCallable()
      then result = v.getName()
      else result = c.getName() + "(..)." + v.getName()
    )
    or
    result = this.(SsaSourceField).ppQualifier() + "." + this.getVariable().toString()
  }

  /**
   * Gets the first access to `this` in terms of source code location. This is
   * used as the representative location for named fields that otherwise would
   * not have a specific source code location.
   */
  private VarAccess getFirstAccess() {
    result =
      min(this.getAnAccess() as a
        order by
          a.getLocation().getStartLine(), a.getLocation().getStartColumn()
      )
  }

  /** Gets the source location for this element. */
  Location getLocation() {
    exists(LocalScopeVariable v | this = TLocalVar(_, v) and result = v.getLocation())
    or
    this instanceof SsaSourceField and result = this.getFirstAccess().getLocation()
  }

  /** Gets the type of this variable. */
  Type getType() { result = this.getVariable().getType() }

  /** Gets the qualifier, if any. */
  SsaSourceVariable getQualifier() { this = TQualifiedField(_, result, _) }

  /** Gets an SSA variable that has this variable as its underlying source variable. */
  SsaDefinition getAnSsaVariable() { result.getSourceVariable() = this }
}

/**
 * A fully qualified field in the context of a `Callable` in which it is
 * accessed.
 */
class SsaSourceField extends SsaSourceVariable {
  SsaSourceField() {
    this = TPlainField(_, _) or this = TEnclosingField(_, _, _) or this = TQualifiedField(_, _, _)
  }

  /** Gets the field corresponding to this named field. */
  Field getField() { result = this.getVariable() }

  /** Gets a string representation of the qualifier. */
  string ppQualifier() {
    exists(Field f | this = TPlainField(_, f) |
      if f.isStatic() then result = f.getDeclaringType().getQualifiedName() else result = "this"
    )
    or
    exists(RefType t | this = TEnclosingField(_, _, t) | result = t.toString() + ".this")
    or
    exists(SsaSourceVariable q | this = TQualifiedField(_, q, _) | result = q.toString())
  }

  /** Holds if the field itself or any of the fields part of the qualifier are volatile. */
  predicate isVolatile() {
    this.getField().isVolatile() or
    this.getQualifier().(SsaSourceField).isVolatile()
  }
}

/** An SSA definition in a closure that captures a variable. */
class SsaCapturedDefinition extends SsaImplicitEntryDefinition {
  SsaCapturedDefinition() { captures(this, _) }

  override string toString() { result = "SSA capture def(" + this.getSourceVariable() + ")" }

  /** Holds if this definition captures the value of `capturedvar`. */
  predicate captures(SsaDefinition capturedvar) { captures(this, capturedvar) }

  /**
   * Gets a definition that ultimately defines the captured variable and is not itself a phi node.
   */
  SsaDefinition getAnUltimateCapturedDefinition() {
    exists(SsaDefinition capturedvar |
      captures(this, capturedvar) and result = capturedvar.getAnUltimateDefinition()
    )
  }
}

/**
 * An SSA definition representing the potential definition of a variable
 * via a call.
 */
class SsaImplicitCallDefinition extends SsaImplicitWrite {
  SsaImplicitCallDefinition() { isNonLocal(this) and not hasQualifierUpdate(this) }

  override string toString() { result = "SSA call def(" + this.getSourceVariable() + ")" }

  /**
   * Gets a reachable `FieldWrite` that might represent this ssa update, if any.
   */
  overlay[global]
  FieldWrite getANonLocalUpdate() { result = getANonLocalUpdate(this) }
}

/** An SSA definition due to an update of the qualifier. */
class SsaImplicitQualifierDefinition extends SsaImplicitWrite {
  SsaImplicitQualifierDefinition() { hasQualifierUpdate(this) }

  override string toString() { result = "SSA qualifier def(" + this.getSourceVariable() + ")" }
}

/**
 * Gets an access of the SSA source variable underlying this SSA variable
 * that can be reached from this SSA variable without passing through any
 * other uses, but potentially through phi nodes and uncertain implicit
 * updates.
 */
VarRead ssaGetAFirstUse(SsaDefinition def) { firstUse(def, result) }

/**
 * DEPRECATED: use `SsaDefinition` instead.
 *
 * An SSA variable.
 */
deprecated class SsaVariable extends Definition {
  /** Gets the SSA source variable underlying this SSA variable. */
  SsaSourceVariable getSourceVariable() { result = super.getSourceVariable() }

  /**
   * DEPRECATED: Use `getControlFlowNode()` instead.
   *
   * Gets the `ControlFlowNode` at which this SSA variable is defined.
   */
  pragma[nomagic]
  deprecated ControlFlowNode getCfgNode() {
    exists(BasicBlock bb, int i |
      this.definesAt(_, bb, i) and
      // phi nodes are inserted at position `-1`
      result = bb.getNode(0.maximum(i))
    )
  }

  /** Gets a textual representation of this SSA variable. */
  string toString() { none() }

  /** Gets the source location for this element. */
  Location getLocation() { result = this.getCfgNode().getLocation() }

  /** Gets the `BasicBlock` in which this SSA variable is defined. */
  BasicBlock getBasicBlock() { result = super.getBasicBlock() }

  /**
   * DEPRECATED: Use `getARead()` instead.
   *
   * Gets an access of this SSA variable.
   */
  deprecated VarRead getAUse() { result = getAUse(this) }

  /**
   * DEPRECATED: Use `ssaGetAFirstUse(SsaDefinition)` instead.
   *
   * Gets an access of the SSA source variable underlying this SSA variable
   * that can be reached from this SSA variable without passing through any
   * other uses, but potentially through phi nodes and uncertain implicit
   * updates.
   *
   * Subsequent uses can be found by following the steps defined by
   * `adjacentUseUse`.
   */
  deprecated VarRead getAFirstUse() { firstUse(this, result) }

  /** Holds if this SSA variable is live at the end of `b`. */
  predicate isLiveAtEndOfBlock(BasicBlock b) { ssaDefReachesEndOfBlock(b, this) }

  /**
   * DEPRECATED.
   *
   * Gets an SSA variable whose value can flow to this one in one step. This
   * includes inputs to phi nodes, the prior definition of uncertain updates,
   * and the captured ssa variable for a closure variable.
   */
  deprecated SsaVariable getAPhiInputOrPriorDef() {
    result = this.(SsaPhiNode).getAPhiInput() or
    result = this.(SsaUncertainImplicitUpdate).getPriorDef() or
    this.(SsaImplicitInit).captures(result)
  }

  /**
   * DEPRECATED: Use `SsaCapturedDefinition::getAnUltimateCapturedDefinition()`
   * and/or `SsaDefinition::getAnUltimateDefinition()` instead.
   *
   * Gets a definition that ultimately defines this variable and is not itself a phi node.
   */
  deprecated SsaVariable getAnUltimateDefinition() {
    result = this.getAPhiInputOrPriorDef*() and not result instanceof SsaPhiNode
  }
}

/**
 * DEPRECATED: use `SsaWriteDefinition` instead.
 *
 * An SSA variable that either explicitly or implicitly updates the variable.
 */
deprecated class SsaUpdate extends SsaVariable instanceof WriteDefinition {
  SsaUpdate() { not this instanceof SsaImplicitInit }
}

/**
 * DEPRECATED: Use `SsaExplicitWrite` instead.
 *
 * An SSA variable that is defined by a `VariableUpdate`.
 */
deprecated class SsaExplicitUpdate extends SsaUpdate {
  private VariableUpdate upd;

  SsaExplicitUpdate() { ssaExplicitUpdate(this, upd) }

  override string toString() { result = "SSA def(" + this.getSourceVariable() + ")" }

  /** Gets the `VariableUpdate` defining the SSA variable. */
  VariableUpdate getDefiningExpr() { result = upd }
}

/**
 * DEPRECATED: Use `SsaImplicitWrite` instead.
 *
 * An SSA variable that represents any sort of implicit update. This can be a
 * `Call` that might reach a non-local update of the field, an explicit or
 * implicit update of the qualifier of the field, or the implicit update that
 * occurs just prior to a `FieldRead` of an untracked field.
 */
deprecated class SsaImplicitUpdate extends SsaUpdate {
  SsaImplicitUpdate() { not this instanceof SsaExplicitUpdate }

  override string toString() {
    result = "SSA impl upd[" + this.getKind() + "](" + this.getSourceVariable() + ")"
  }

  private predicate hasExplicitQualifierUpdate() {
    exists(SsaUpdate qdef, BasicBlock bb, int i |
      qdef.definesAt(this.getSourceVariable().getQualifier(), bb, i) and
      this.definesAt(_, bb, i) and
      not qdef instanceof SsaUncertainImplicitUpdate
    )
  }

  private predicate hasImplicitQualifierUpdate() {
    exists(SsaUncertainImplicitUpdate qdef, BasicBlock bb, int i |
      qdef.definesAt(this.getSourceVariable().getQualifier(), bb, i) and
      this.definesAt(_, bb, i)
    )
  }

  private string getKind() {
    this.hasExplicitQualifierUpdate() and
    result = "explicit qualifier" // -> SSA qualifier def
    or
    if this.hasImplicitQualifierUpdate()
    then
      if isNonLocal(this)
      then result = "nonlocal + nonlocal qualifier" // -> SSA qualifier def
      else result = "nonlocal qualifier" // -> SSA qualifier def
    else (
      isNonLocal(this) and result = "nonlocal" // -> SSA call def
    )
  }

  /**
   * DEPRECATED: Use `SsaImplicitCallDefinition.getANonLocalUpdate()` instead.
   *
   * Gets a reachable `FieldWrite` that might represent this ssa update, if any.
   */
  overlay[global]
  deprecated FieldWrite getANonLocalUpdate() { result = getANonLocalUpdate(this) }

  /**
   * DEPRECATED: Use `SsaImplicitQualifierDefinition` instead.
   *
   * Holds if this ssa variable might change the value to something unknown.
   *
   * Examples include updates that might change the value of the qualifier, or
   * reads from untracked variables, for example those where the field or one
   * of its qualifiers is volatile.
   */
  deprecated predicate assignsUnknownValue() {
    this.hasExplicitQualifierUpdate()
    or
    this.hasImplicitQualifierUpdate()
  }
}

private predicate hasQualifierUpdate(SsaImplicitWrite def) {
  exists(SsaWriteDefinition qdef, BasicBlock bb, int i |
    qdef.definesAt(def.getSourceVariable().getQualifier(), bb, i) and
    def.definesAt(_, bb, i) and
    not qdef instanceof SsaImplicitEntryDefinition
  )
}

/**
 * Gets a reachable `FieldWrite` that might represent this ssa update, if any.
 */
overlay[global]
private FieldWrite getANonLocalUpdate(SsaImplicitWrite calldef) {
  exists(SsaSourceField f, Callable setter |
    relevantFieldUpdate(setter, f.getField(), result) and
    defUpdatesNamedField(calldef, f, setter)
  )
}

overlay[global]
private predicate isNonLocalImpl(SsaImplicitWrite calldef) { exists(getANonLocalUpdate(calldef)) }

private predicate isNonLocal(SsaImplicitWrite calldef) = forceLocal(isNonLocalImpl/1)(calldef)

/**
 * DEPRECATED: Use `SsaUncertainWrite` instead.
 *
 * An SSA variable that represents an uncertain implicit update of the value.
 * This is a `Call` that might reach a non-local update of the field or one of
 * its qualifiers.
 */
deprecated class SsaUncertainImplicitUpdate extends SsaImplicitUpdate {
  SsaUncertainImplicitUpdate() { ssaUncertainImplicitUpdate(this) }

  /**
   * DEPRECATED: Use `getPriorDefinition()` instead.
   *
   * Gets the immediately preceding definition. Since this update is uncertain
   * the value from the preceding definition might still be valid.
   */
  deprecated SsaVariable getPriorDef() { ssaDefReachesUncertainDef(result, this) }
}

/**
 * DEPRECATED: Use `SsaParameterInit`, `SsaImplicitEntryDefinition`, or `SsaCapturedDefinition` instead.
 *
 * An SSA variable that is defined by its initial value in the callable. This
 * includes initial values of parameters, fields, and closure variables.
 */
deprecated class SsaImplicitInit extends SsaVariable instanceof WriteDefinition {
  SsaImplicitInit() { ssaImplicitInit(this) }

  override string toString() { result = "SSA init(" + this.getSourceVariable() + ")" }

  /** Holds if this is a closure variable that captures the value of `capturedvar`. */
  predicate captures(SsaVariable capturedvar) { captures(this, capturedvar) }

  /**
   * DEPRECATED: Use `SsaParameterInit::getParameter()` instead.
   *
   * Holds if the SSA variable is a parameter defined by its initial value in the callable.
   */
  deprecated predicate isParameterDefinition(Parameter p) {
    this.getSourceVariable() = TLocalVar(p.getCallable(), p) and
    p.getCallable().getBody().getControlFlowNode() = this.getCfgNode()
  }
}

/**
 * DEPRECATED: Use `SsaPhiDefinition` instead.
 *
 * An SSA phi node.
 */
deprecated class SsaPhiNode extends SsaVariable instanceof PhiNode {
  override string toString() { result = "SSA phi(" + this.getSourceVariable() + ")" }

  /**
   * DEPRECATED: Use `getAnInput()` instead.
   *
   * Gets an input to the phi node defining the SSA variable.
   */
  deprecated SsaVariable getAPhiInput() { this.hasInputFromBlock(result, _) }

  /** Gets an input to the phi node defining the SSA variable. */
  SsaVariable getAnInput() { this.hasInputFromBlock(result, _) }

  /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
  predicate hasInputFromBlock(SsaVariable inp, BasicBlock bb) {
    phiHasInputFromBlock(this, inp, bb)
  }
}

private class RefTypeCastingExpr extends CastingExpr {
  RefTypeCastingExpr() {
    this.getType() instanceof RefType and
    not this instanceof SafeCastExpr
  }
}

/**
 * Gets an expression that has the same value as the given SSA variable.
 *
 * The `VarAccess` represents the access to `v` that `result` has the same value as.
 */
Expr sameValue(SsaDefinition v, VarAccess va) {
  result = v.getARead() and result = va
  or
  result.(AssignExpr).getDest() = va and result = v.(SsaExplicitWrite).getDefiningExpr()
  or
  result.(AssignExpr).getSource() = sameValue(v, va)
  or
  result.(RefTypeCastingExpr).getExpr() = sameValue(v, va)
}

import SsaPublic
