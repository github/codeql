/**
 * Provides classes and predicates for nullness analysis.
 *
 * Local variables that may be null are tracked to see if they might reach
 * a dereference and cause a NullPointerException. Assertions are assumed to
 * hold, so results guarded by, for example, `assert x != null;` or
 * `if (x == null) { assert false; }` are excluded.
 */
overlay[local?]
module;

import java
private import SSA
private import semmle.code.java.controlflow.Guards
private import IntegerGuards
private import NullGuards
private import semmle.code.java.Collections
private import semmle.code.java.controlflow.internal.Preconditions
private import semmle.code.java.controlflow.ControlFlowReachability

/** Gets an expression that may be `null`. */
Expr nullExpr() { result = nullExpr(_) }

/** Gets an expression that may be `null`. */
private Expr nullExpr(Expr reason) {
  result instanceof NullLiteral and reason = result
  or
  result.(ChooseExpr).getAResultExpr() = nullExpr(reason)
  or
  result.(AssignExpr).getSource() = nullExpr(reason)
  or
  result.(CastExpr).getExpr() = nullExpr(reason)
  or
  result.(ImplicitCastExpr).getExpr() = nullExpr(reason)
  or
  result instanceof SafeCastExpr and reason = result
}

/** An expression of a boxed type that is implicitly unboxed. */
private predicate unboxed(Expr e) {
  e.getType() instanceof BoxedType and
  (
    exists(ArrayAccess aa | aa.getIndexExpr() = e)
    or
    exists(ArrayCreationExpr ace | ace.getADimension() = e)
    or
    exists(LocalVariableDeclExpr decl |
      decl.getVariable().getType() instanceof PrimitiveType and decl.getInit() = e
    )
    or
    exists(AssignExpr assign |
      assign.getDest().getType() instanceof PrimitiveType and assign.getSource() = e
    )
    or
    exists(AssignOp assign | assign.getSource() = e and assign.getType() instanceof PrimitiveType)
    or
    exists(EqualityTest eq |
      eq.getAnOperand() = e and eq.getAnOperand().getType() instanceof PrimitiveType
    )
    or
    exists(BinaryExpr bin |
      bin.getAnOperand() = e and
      not bin instanceof EqualityTest and
      bin.getType() instanceof PrimitiveType
    )
    or
    exists(UnaryExpr un | un.getExpr() = e)
    or
    exists(ChooseExpr cond | cond.getType() instanceof PrimitiveType | cond.getAResultExpr() = e)
    or
    exists(ConditionNode cond | cond.getCondition() = e)
    or
    exists(Parameter p | p.getType() instanceof PrimitiveType and p.getAnArgument() = e)
    or
    exists(ReturnStmt ret |
      ret.getEnclosingCallable().getReturnType() instanceof PrimitiveType and ret.getResult() = e
    )
  )
}

/** An expression that is being dereferenced. These are the points where `NullPointerException`s can occur. */
predicate dereference(Expr e) {
  exists(EnhancedForStmt for | for.getExpr() = e)
  or
  exists(SynchronizedStmt synch | synch.getExpr() = e)
  or
  exists(SwitchStmt switch | switch.getExpr() = e and not switch.hasNullCase())
  or
  exists(SwitchExpr switch | switch.getExpr() = e and not switch.hasNullCase())
  or
  exists(FieldAccess fa, Field f | fa.getQualifier() = e and fa.getField() = f and not f.isStatic())
  or
  exists(MethodCall ma, Method m |
    ma.getQualifier() = e and ma.getMethod() = m and not m.isStatic()
  )
  or
  exists(ClassInstanceExpr cie | cie.getQualifier() = e)
  or
  exists(ArrayAccess aa | aa.getArray() = e)
  or
  exists(CastingExpr cast |
    (cast instanceof CastExpr or cast instanceof ImplicitCastExpr) and
    cast.getExpr() = e and
    e.getType() instanceof BoxedType and
    cast.getType() instanceof PrimitiveType
  )
  or
  unboxed(e)
}

/**
 * Gets the `ControlFlowNode` in which the given SSA variable is being dereferenced.
 *
 * The `VarAccess` is included for nicer error reporting.
 */
private ControlFlowNode varDereference(SsaVariable v, VarAccess va) {
  dereference(result.asExpr()) and
  result.asExpr() = sameValue(v, va)
}

/**
 * The first dereference of a variable in a given `BasicBlock`.
 */
private predicate firstVarDereferenceInBlock(BasicBlock bb, SsaVariable v, VarAccess va) {
  exists(ControlFlowNode n |
    varDereference(v, va) = n and
    n.getBasicBlock() = bb and
    n =
      min(ControlFlowNode n0, int i |
        varDereference(v, _) = n0 and bb.getNode(i) = n0
      |
        n0 order by i
      )
  )
}

/** A variable suspected of being `null`. */
private predicate varMaybeNull(SsaVariable v, ControlFlowNode node, string msg, Expr reason) {
  // A variable compared to null might be null.
  exists(Expr e |
    reason = e and
    msg = "as suggested by $@ null guard" and
    guardSuggestsVarMaybeNull(e, v) and
    node = v.getCfgNode() and
    not v instanceof SsaPhiNode and
    not clearlyNotNull(v) and
    // Comparisons in finally blocks are excluded since missing exception edges in the CFG could otherwise yield FPs.
    not exists(TryStmt try | try.getFinally() = e.getEnclosingStmt().getEnclosingStmt*()) and
    (
      e = any(ConditionalExpr c).getCondition().getAChildExpr*() or
      not exists(MethodCall ma | ma.getAnArgument().getAChildExpr*() = e)
    ) and
    // Don't use a guard as reason if there is a null assignment.
    not v.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() = nullExpr()
  )
  or
  // A parameter might be null if there is a null argument somewhere.
  exists(Parameter p, Expr arg |
    v.(SsaImplicitInit).isParameterDefinition(p) and
    node = v.getCfgNode() and
    p.getAnArgument() = arg and
    reason = arg and
    msg = "because of $@ null argument" and
    arg = nullExpr() and
    not arg.getEnclosingCallable().getEnclosingCallable*() instanceof TestMethod
  )
  or
  // If the source of a variable is null then the variable may be null.
  exists(VariableAssign def |
    v.(SsaExplicitUpdate).getDefiningExpr() = def and
    def.getSource() = nullExpr(node.asExpr()) and
    reason = def and
    msg = "because of $@ assignment"
  )
}

/** Gets an array or collection that contains at least one element. */
private Expr nonEmptyExpr() {
  // An array creation with a known positive size is trivially non-empty.
  result.(ArrayCreationExpr).getFirstDimensionSize() > 0
  or
  exists(SsaVariable v |
    // A use of an array variable is non-empty if...
    result = v.getAUse() and
    v.getSourceVariable().getType() instanceof Array
  |
    // ...its definition is non-empty...
    v.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() = nonEmptyExpr()
    or
    // ...or it is guarded by a condition proving its length to be non-zero.
    exists(ConditionBlock cond, boolean branch, FieldAccess length |
      cond.controls(result.getBasicBlock(), branch) and
      cond.getCondition() = nonZeroGuard(length, branch) and
      length.getField().hasName("length") and
      length.getQualifier() = v.getAUse()
    )
  )
  or
  exists(SsaVariable v |
    // A use of a Collection variable is non-empty if...
    result = v.getAUse() and
    v.getSourceVariable().getType() instanceof CollectionType and
    exists(ConditionBlock cond, boolean branch, Expr c |
      // ...it is guarded by a condition...
      cond.controls(result.getBasicBlock(), branch) and
      // ...and it isn't modified in the scope of the condition...
      forall(MethodCall ma, Method m |
        m = ma.getMethod() and
        ma.getQualifier() = v.getSourceVariable().getAnAccess() and
        cond.controls(ma.getBasicBlock(), branch)
      |
        m instanceof CollectionQueryMethod
      ) and
      cond.getCondition() = c
    |
      // ...and the condition proves that it is non-empty, either by using the `isEmpty` method...
      c.(MethodCall).getMethod().hasName("isEmpty") and
      branch = false and
      c.(MethodCall).getQualifier() = v.getAUse()
      or
      // ...or a check on its `size`.
      exists(MethodCall size |
        c = nonZeroGuard(size, branch) and
        size.getMethod().hasName("size") and
        size.getQualifier() = v.getAUse()
      )
    )
  )
}

/** The control flow edge that exits an enhanced for loop if the `Iterable` is empty. */
private predicate enhancedForEarlyExit(EnhancedForStmt for, ControlFlowNode n1, ControlFlowNode n2) {
  exists(Expr forExpr |
    n1.getANormalSuccessor() = n2 and
    for.getExpr() = forExpr and
    forExpr.getAChildExpr*() = n1.asExpr() and
    not forExpr.getAChildExpr*() = n2.asExpr() and
    n1.getANormalSuccessor().asExpr() = for.getVariable() and
    not n2.asExpr() = for.getVariable()
  )
}

/** A control flow edge that cannot be taken. */
private predicate impossibleEdge(BasicBlock bb1, BasicBlock bb2) {
  exists(EnhancedForStmt for |
    enhancedForEarlyExit(for, bb1.getANode(), bb2.getANode()) and
    for.getExpr() = nonEmptyExpr()
  )
}

private module NullnessConfig implements ControlFlowReachability::ConfigSig {
  predicate source(ControlFlowNode node, SsaVariable def) { varMaybeNull(def, node, _, _) }

  predicate sink(ControlFlowNode node, SsaVariable def) { varDereference(def, _) = node }

  predicate barrierValue(GuardValue gv) { gv.isNullness(false) }

  predicate barrierEdge(BasicBlock bb1, BasicBlock bb2) { impossibleEdge(bb1, bb2) }

  predicate uncertainFlow() { none() }
}

private module NullnessFlow = ControlFlowReachability::Flow<NullnessConfig>;

/**
 * Holds if the dereference of `v` at `va` might be `null`.
 */
predicate nullDeref(SsaSourceVariable v, VarAccess va, string msg, Expr reason) {
  exists(SsaVariable origin, SsaVariable ssa, ControlFlowNode src, ControlFlowNode sink |
    varMaybeNull(origin, src, msg, reason) and
    NullnessFlow::flow(src, origin, sink, ssa) and
    ssa.getSourceVariable() = v and
    varDereference(ssa, va) = sink
  )
}

/**
 * A dereference of a variable that is always `null`.
 */
predicate alwaysNullDeref(SsaSourceVariable v, VarAccess va) {
  exists(BasicBlock bb, SsaVariable ssa |
    forall(SsaVariable def | def = ssa.getAnUltimateDefinition() |
      def.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() = alwaysNullExpr()
    )
    or
    nullGuardControls(ssa, true, bb) and
    not clearlyNotNull(ssa)
  |
    // Exclude fields as they might not have an accurate ssa representation.
    not v.getVariable() instanceof Field and
    firstVarDereferenceInBlock(bb, ssa, va) and
    ssa.getSourceVariable() = v and
    not nullGuardControls(ssa, false, bb)
  )
}
