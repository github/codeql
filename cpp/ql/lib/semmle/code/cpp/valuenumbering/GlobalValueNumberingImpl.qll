/**
 * Provides an implementation of Global Value Numbering.
 * See https://en.wikipedia.org/wiki/Global_value_numbering
 *
 * The predicate `globalValueNumber` converts an expression into a `GVN`,
 * which is an abstract type representing the value of the expression. If
 * two expressions have the same `GVN` then they compute the same value.
 * For example:
 *
 * ```
 * void f(int x, int y) {
 *   g(x+y, x+y);
 * }
 * ```
 *
 * In this example, both arguments in the call to `g` compute the same value,
 * so both arguments have the same `GVN`. In other words, we can find
 * this call with the following query:
 *
 * ```
 * from FunctionCall call, GVN v
 * where v = globalValueNumber(call.getArgument(0))
 *   and v = globalValueNumber(call.getArgument(1))
 * select call
 * ```
 *
 * The analysis is conservative, so two expressions might have different
 * `GVN`s even though the actually always compute the same value. The most
 * common reason for this is that the analysis cannot prove that there
 * are no side-effects that might cause the computed value to change.
 */

/*
 * Note to developers: the correctness of this module depends on the
 * definitions of GVN, globalValueNumber, and analyzableExpr being kept in
 * sync with each other. If you change this module then make sure that the
 * change is symmetric across all three.
 */

import cpp
private import semmle.code.cpp.controlflow.SSA

/**
 * Holds if the result is a control flow node that might change the
 * value of any global variable. This is used in the implementation
 * of `GVN_OtherVariable`, because we need to be quite conservative when
 * we assign a value number to a global variable. For example:
 *
 * ```
 * x = g+1;
 * dosomething();
 * y = g+1;
 * ```
 *
 * It is not safe to assign the same value number to both instances
 * of `g+1` in this example, because the call to `dosomething` might
 * change the value of `g`.
 */
private ControlFlowNode nodeWithPossibleSideEffect() {
  result instanceof Call
  or
  // If the lhs of an assignment is not analyzable by SSA, then
  // we need to treat the assignment as having a possible side-effect.
  result instanceof Assignment and not result instanceof SsaDefinition
  or
  result instanceof CrementOperation and not result instanceof SsaDefinition
  or
  exists(LocalVariable v |
    result = v.getInitializer().getExpr() and not result instanceof SsaDefinition
  )
  or
  result instanceof AsmStmt
}

/**
 * Gets the entry node of the control flow graph of which `node` is a
 * member.
 */
cached
private ControlFlowNode getControlFlowEntry(ControlFlowNode node) {
  result = node.getControlFlowScope().getEntryPoint() and
  result.getASuccessor*() = node
}

/**
 * Holds if there is a control flow edge from `src` to `dst` or
 * if `dst` is an expression with a possible side-effect. The idea
 * is to treat side effects as entry points in the control flow
 * graph so that we can use the dominator tree to find the most recent
 * side-effect.
 */
private predicate sideEffectCfg(ControlFlowNode src, ControlFlowNode dst) {
  src.getASuccessor() = dst
  or
  // Add an edge from the entry point to any node that might have a side
  // effect.
  dst = nodeWithPossibleSideEffect() and
  src = getControlFlowEntry(dst)
}

/**
 * Holds if `dominator` is the immediate dominator of `node` in
 * the side-effect CFG.
 */
private predicate iDomEffect(ControlFlowNode dominator, ControlFlowNode node) =
  idominance(functionEntry/1, sideEffectCfg/2)(_, dominator, node)

/**
 * Gets the most recent side effect. To be more precise, `result` is a
 * dominator of `node` and no side-effects can occur between `result` and
 * `node`.
 *
 * `sideEffectCFG` has an edge from the function entry to every node with a
 * side-effect. This means that every node with a side-effect has the
 * function entry as its immediate dominator. So if node `x` dominates node
 * `y` then there can be no side effects between `x` and `y` unless `x` is
 * the function entry. So the optimal choice for `result` has the function
 * entry as its immediate dominator.
 *
 * Example:
 *
 * ```
 * 000:  int f(int a, int b, int *p) {
 * 001:    int r = 0;
 * 002:    if (a) {
 * 003:      if (b) {
 * 004:        sideEffect1();
 * 005:      }
 * 006:    } else {
 * 007:      sideEffect2();
 * 008:    }
 * 009:    if (a) {
 * 010:      r++; // Not a side-effect, because r is an SSA variable.
 * 011:    }
 * 012:    if (b) {
 * 013:      r++; // Not a side-effect, because r is an SSA variable.
 * 014:    }
 * 015:    return *p;
 * 016:  }
 * ```
 *
 * Suppose we want to find the most recent side-effect for the dereference
 * of `p` on line 015. The `sideEffectCFG` has an edge from the function
 * entry (line 000) to the side effects at lines 004 and 007. Therefore,
 * the immediate dominator tree looks like this:
 *
 * 000 - 001 - 002 - 003
 *     - 004
 *     - 007
 *     - 009 - 010
 *           - 012 - 013
 *                 - 015
 *
 * The immediate dominator path to line 015 is 000 - 009 - 012 - 015.
 * Therefore, the most recent side effect for line 015 is line 009.
 */
cached
private ControlFlowNode mostRecentSideEffect(ControlFlowNode node) {
  exists(ControlFlowNode entry |
    functionEntry(entry) and
    iDomEffect(entry, result) and
    iDomEffect*(result, node)
  )
}

/** Used to represent the "global value number" of an expression. */
cached
private newtype GVNBase =
  GVN_IntConst(int val, Type t) { mk_IntConst(val, t, _) } or
  GVN_FloatConst(float val, Type t) { mk_FloatConst(val, t, _) } or
  // If the local variable does not have a defining value, then
  // we use the SsaDefinition as its global value number.
  GVN_UndefinedStackVariable(StackVariable x, SsaDefinition def) {
    mk_UndefinedStackVariable(x, def, _)
  } or
  // Variables with no SSA information. As a crude (but safe)
  // approximation, we use `mostRecentSideEffect` to compute a definition
  // location for the variable. This ensures that two instances of the same
  // global variable will only get the same value number if they are
  // guaranteed to have the same value.
  GVN_OtherVariable(Variable x, ControlFlowNode dominator) { mk_OtherVariable(x, dominator, _) } or
  GVN_FieldAccess(GVN s, Field f) {
    mk_DotFieldAccess(s, f, _) or
    mk_PointerFieldAccess_with_deref(s, f, _) or
    mk_ImplicitThisFieldAccess_with_deref(s, f, _)
  } or
  // Dereference a pointer. The value might have changed since the last
  // time the pointer was dereferenced, so we need to include a definition
  // location. As a crude (but safe) approximation, we use
  // `mostRecentSideEffect` to compute a definition location.
  GVN_Deref(GVN p, ControlFlowNode dominator) {
    mk_Deref(p, dominator, _) or
    mk_PointerFieldAccess(p, _, dominator, _) or
    mk_ImplicitThisFieldAccess_with_qualifier(p, _, dominator, _)
  } or
  GVN_ThisExpr(Function fcn) {
    mk_ThisExpr(fcn, _) or
    mk_ImplicitThisFieldAccess(fcn, _, _, _)
  } or
  GVN_Conversion(Type t, GVN child) { mk_Conversion(t, child, _) } or
  GVN_BinaryOp(GVN lhs, GVN rhs, string opname) { mk_BinaryOp(lhs, rhs, opname, _) } or
  GVN_UnaryOp(GVN child, string opname) { mk_UnaryOp(child, opname, _) } or
  GVN_ArrayAccess(GVN x, GVN i, ControlFlowNode dominator) { mk_ArrayAccess(x, i, dominator, _) } or
  // Any expression that is not handled by the cases above is
  // given a unique number based on the expression itself.
  GVN_Unanalyzable(Expr e) { not analyzableExpr(e) }

/**
 * A Global Value Number. A GVN is an abstract representation of the value
 * computed by an expression. The relationship between `Expr` and `GVN` is
 * many-to-one: every `Expr` has exactly one `GVN`, but multiple
 * expressions can have the same `GVN`. If two expressions have the same
 * `GVN`, it means that they compute the same value at run time. The `GVN`
 * is an opaque value, so you cannot deduce what the run-time value of an
 * expression will be from its `GVN`. The only use for the `GVN` of an
 * expression is to find other expressions that compute the same value.
 * Use the predicate `globalValueNumber` to get the `GVN` for an `Expr`.
 *
 * Note: `GVN` has `toString` and `getLocation` methods, so that it can be
 * displayed in a results list. These work by picking an arbitrary
 * expression with this `GVN` and using its `toString` and `getLocation`
 * methods.
 */
class GVN extends GVNBase {
  GVN() { this instanceof GVNBase }

  /** Gets an expression that has this GVN. */
  Expr getAnExpr() { this = globalValueNumber(result) }

  /** Gets the kind of the GVN. This can be useful for debugging. */
  string getKind() {
    if this instanceof GVN_IntConst
    then result = "IntConst"
    else
      if this instanceof GVN_FloatConst
      then result = "FloatConst"
      else
        if this instanceof GVN_UndefinedStackVariable
        then result = "UndefinedStackVariable"
        else
          if this instanceof GVN_OtherVariable
          then result = "OtherVariable"
          else
            if this instanceof GVN_FieldAccess
            then result = "FieldAccess"
            else
              if this instanceof GVN_Deref
              then result = "Deref"
              else
                if this instanceof GVN_ThisExpr
                then result = "ThisExpr"
                else
                  if this instanceof GVN_Conversion
                  then result = "Conversion"
                  else
                    if this instanceof GVN_BinaryOp
                    then result = "BinaryOp"
                    else
                      if this instanceof GVN_UnaryOp
                      then result = "UnaryOp"
                      else
                        if this instanceof GVN_ArrayAccess
                        then result = "ArrayAccess"
                        else
                          if this instanceof GVN_Unanalyzable
                          then result = "Unanalyzable"
                          else result = "error"
  }

  /**
   * Gets an example of an expression with this GVN.
   * This is useful for things like implementing toString().
   */
  private Expr exampleExpr() {
    // Pick the expression with the minimum source location string. This is
    // just an arbitrary way to pick an expression with this `GVN`.
    result = min(Expr e | this = globalValueNumber(e) | e order by e.getLocation().toString())
  }

  /** Gets a textual representation of this element. */
  string toString() { result = exampleExpr().toString() }

  /** Gets the primary location of this element. */
  Location getLocation() { result = exampleExpr().getLocation() }
}

private predicate analyzableIntConst(Expr e) {
  strictcount(e.getValue().toInt()) = 1 and
  strictcount(e.getUnspecifiedType()) = 1
}

private predicate mk_IntConst(int val, Type t, Expr e) {
  analyzableIntConst(e) and
  val = e.getValue().toInt() and
  t = e.getUnspecifiedType()
}

private predicate analyzableFloatConst(Expr e) {
  strictcount(e.getValue().toFloat()) = 1 and
  strictcount(e.getUnspecifiedType()) = 1 and
  not analyzableIntConst(e)
}

private predicate mk_FloatConst(float val, Type t, Expr e) {
  analyzableFloatConst(e) and
  val = e.getValue().toFloat() and
  t = e.getUnspecifiedType()
}

private predicate analyzableStackVariable(VariableAccess access) {
  strictcount(SsaDefinition def | def.getAUse(_) = access | def) = 1 and
  strictcount(SsaDefinition def, Variable v | def.getAUse(v) = access | v) = 1 and
  count(SsaDefinition def, Variable v |
    def.getAUse(v) = access
  |
    def.getDefiningValue(v).getFullyConverted()
  ) <= 1 and
  not analyzableConst(access)
}

// Note: this predicate only has a result if the access has no
// defining value. If there is a defining value, then there is no
// need to generate a fresh `GVN` for the access because `globalValueNumber`
// will follow the chain and use the GVN of the defining value.
private predicate mk_UndefinedStackVariable(
  StackVariable x, SsaDefinition def, VariableAccess access
) {
  analyzableStackVariable(access) and
  access = def.getAUse(x) and
  not exists(def.getDefiningValue(x))
}

private predicate analyzableDotFieldAccess(DotFieldAccess access) {
  strictcount(access.getTarget()) = 1 and
  strictcount(access.getQualifier().getFullyConverted()) = 1 and
  not analyzableConst(access)
}

private predicate mk_DotFieldAccess(GVN qualifier, Field target, DotFieldAccess access) {
  analyzableDotFieldAccess(access) and
  target = access.getTarget() and
  qualifier = globalValueNumber(access.getQualifier().getFullyConverted())
}

private predicate analyzablePointerFieldAccess(PointerFieldAccess access) {
  strictcount(mostRecentSideEffect(access)) = 1 and
  strictcount(access.getTarget()) = 1 and
  strictcount(access.getQualifier().getFullyConverted()) = 1 and
  not analyzableConst(access)
}

private predicate mk_PointerFieldAccess(
  GVN qualifier, Field target, ControlFlowNode dominator, PointerFieldAccess access
) {
  analyzablePointerFieldAccess(access) and
  dominator = mostRecentSideEffect(access) and
  target = access.getTarget() and
  qualifier = globalValueNumber(access.getQualifier().getFullyConverted())
}

/**
 * `obj->field` is equivalent to `(*obj).field`, so we need to wrap an
 * extra `GVN_Deref` around the qualifier.
 */
private predicate mk_PointerFieldAccess_with_deref(
  GVN new_qualifier, Field target, PointerFieldAccess access
) {
  exists(GVN qualifier, ControlFlowNode dominator |
    mk_PointerFieldAccess(qualifier, target, dominator, access) and
    new_qualifier = GVN_Deref(qualifier, dominator)
  )
}

private predicate analyzableImplicitThisFieldAccess(ImplicitThisFieldAccess access) {
  strictcount(mostRecentSideEffect(access)) = 1 and
  strictcount(access.getTarget()) = 1 and
  strictcount(access.getEnclosingFunction()) = 1 and
  not analyzableConst(access)
}

private predicate mk_ImplicitThisFieldAccess(
  Function fcn, Field target, ControlFlowNode dominator, ImplicitThisFieldAccess access
) {
  analyzableImplicitThisFieldAccess(access) and
  dominator = mostRecentSideEffect(access) and
  target = access.getTarget() and
  fcn = access.getEnclosingFunction()
}

private predicate mk_ImplicitThisFieldAccess_with_qualifier(
  GVN qualifier, Field target, ControlFlowNode dominator, ImplicitThisFieldAccess access
) {
  exists(Function fcn |
    mk_ImplicitThisFieldAccess(fcn, target, dominator, access) and
    qualifier = GVN_ThisExpr(fcn)
  )
}

private predicate mk_ImplicitThisFieldAccess_with_deref(
  GVN new_qualifier, Field target, ImplicitThisFieldAccess access
) {
  exists(GVN qualifier, ControlFlowNode dominator |
    mk_ImplicitThisFieldAccess_with_qualifier(qualifier, target, dominator, access) and
    new_qualifier = GVN_Deref(qualifier, dominator)
  )
}

/**
 * Holds if `access` is an access of a variable that does
 * not have SSA information. (For example, because the variable
 * is global.)
 */
private predicate analyzableOtherVariable(VariableAccess access) {
  not access instanceof FieldAccess and
  not exists(SsaDefinition def | access = def.getAUse(_)) and
  strictcount(access.getTarget()) = 1 and
  strictcount(mostRecentSideEffect(access)) = 1 and
  not analyzableConst(access)
}

private predicate mk_OtherVariable(Variable x, ControlFlowNode dominator, VariableAccess access) {
  analyzableOtherVariable(access) and
  x = access.getTarget() and
  dominator = mostRecentSideEffect(access)
}

private predicate analyzableConversion(Conversion conv) {
  strictcount(conv.getUnspecifiedType()) = 1 and
  strictcount(conv.getExpr()) = 1 and
  not analyzableConst(conv)
}

private predicate mk_Conversion(Type t, GVN child, Conversion conv) {
  analyzableConversion(conv) and
  t = conv.getUnspecifiedType() and
  child = globalValueNumber(conv.getExpr())
}

private predicate analyzableBinaryOp(BinaryOperation op) {
  op.isPure() and
  strictcount(op.getLeftOperand().getFullyConverted()) = 1 and
  strictcount(op.getRightOperand().getFullyConverted()) = 1 and
  strictcount(op.getOperator()) = 1 and
  not analyzableConst(op)
}

private predicate mk_BinaryOp(GVN lhs, GVN rhs, string opname, BinaryOperation op) {
  analyzableBinaryOp(op) and
  lhs = globalValueNumber(op.getLeftOperand().getFullyConverted()) and
  rhs = globalValueNumber(op.getRightOperand().getFullyConverted()) and
  opname = op.getOperator()
}

private predicate analyzableUnaryOp(UnaryOperation op) {
  not op instanceof PointerDereferenceExpr and
  op.isPure() and
  strictcount(op.getOperand().getFullyConverted()) = 1 and
  strictcount(op.getOperator()) = 1 and
  not analyzableConst(op)
}

private predicate mk_UnaryOp(GVN child, string opname, UnaryOperation op) {
  analyzableUnaryOp(op) and
  child = globalValueNumber(op.getOperand().getFullyConverted()) and
  opname = op.getOperator()
}

private predicate analyzableThisExpr(ThisExpr thisExpr) {
  strictcount(thisExpr.getEnclosingFunction()) = 1 and
  not analyzableConst(thisExpr)
}

private predicate mk_ThisExpr(Function fcn, ThisExpr thisExpr) {
  analyzableThisExpr(thisExpr) and
  fcn = thisExpr.getEnclosingFunction()
}

private predicate analyzableArrayAccess(ArrayExpr ae) {
  strictcount(ae.getArrayBase().getFullyConverted()) = 1 and
  strictcount(ae.getArrayOffset().getFullyConverted()) = 1 and
  strictcount(mostRecentSideEffect(ae)) = 1 and
  not analyzableConst(ae)
}

private predicate mk_ArrayAccess(GVN base, GVN offset, ControlFlowNode dominator, ArrayExpr ae) {
  analyzableArrayAccess(ae) and
  base = globalValueNumber(ae.getArrayBase().getFullyConverted()) and
  offset = globalValueNumber(ae.getArrayOffset().getFullyConverted()) and
  dominator = mostRecentSideEffect(ae)
}

private predicate analyzablePointerDereferenceExpr(PointerDereferenceExpr deref) {
  strictcount(deref.getOperand().getFullyConverted()) = 1 and
  strictcount(mostRecentSideEffect(deref)) = 1 and
  not analyzableConst(deref)
}

private predicate mk_Deref(GVN p, ControlFlowNode dominator, PointerDereferenceExpr deref) {
  analyzablePointerDereferenceExpr(deref) and
  p = globalValueNumber(deref.getOperand().getFullyConverted()) and
  dominator = mostRecentSideEffect(deref)
}

/** Gets the global value number of expression `e`. */
cached
GVN globalValueNumber(Expr e) {
  exists(int val, Type t |
    mk_IntConst(val, t, e) and
    result = GVN_IntConst(val, t)
  )
  or
  exists(float val, Type t |
    mk_FloatConst(val, t, e) and
    result = GVN_FloatConst(val, t)
  )
  or
  // Local variable with a defining value.
  exists(StackVariable x, SsaDefinition def |
    analyzableStackVariable(e) and
    e = def.getAUse(x) and
    result = globalValueNumber(def.getDefiningValue(x).getFullyConverted())
  )
  or
  // Local variable without a defining value.
  exists(StackVariable x, SsaDefinition def |
    mk_UndefinedStackVariable(x, def, e) and
    result = GVN_UndefinedStackVariable(x, def)
  )
  or
  // Variable with no SSA information.
  exists(Variable x, ControlFlowNode dominator |
    mk_OtherVariable(x, dominator, e) and
    result = GVN_OtherVariable(x, dominator)
  )
  or
  exists(GVN qualifier, Field target |
    mk_DotFieldAccess(qualifier, target, e) and
    result = GVN_FieldAccess(qualifier, target)
  )
  or
  exists(GVN qualifier, Field target |
    mk_PointerFieldAccess_with_deref(qualifier, target, e) and
    result = GVN_FieldAccess(qualifier, target)
  )
  or
  exists(GVN qualifier, Field target |
    mk_ImplicitThisFieldAccess_with_deref(qualifier, target, e) and
    result = GVN_FieldAccess(qualifier, target)
  )
  or
  exists(Function fcn |
    mk_ThisExpr(fcn, e) and
    result = GVN_ThisExpr(fcn)
  )
  or
  exists(Type t, GVN child |
    mk_Conversion(t, child, e) and
    result = GVN_Conversion(t, child)
  )
  or
  exists(GVN lhs, GVN rhs, string opname |
    mk_BinaryOp(lhs, rhs, opname, e) and
    result = GVN_BinaryOp(lhs, rhs, opname)
  )
  or
  exists(GVN child, string opname |
    mk_UnaryOp(child, opname, e) and
    result = GVN_UnaryOp(child, opname)
  )
  or
  exists(GVN x, GVN i, ControlFlowNode dominator |
    mk_ArrayAccess(x, i, dominator, e) and
    result = GVN_ArrayAccess(x, i, dominator)
  )
  or
  exists(GVN p, ControlFlowNode dominator |
    mk_Deref(p, dominator, e) and
    result = GVN_Deref(p, dominator)
  )
  or
  not analyzableExpr(e) and result = GVN_Unanalyzable(e)
}

private predicate analyzableConst(Expr e) {
  analyzableIntConst(e) or
  analyzableFloatConst(e)
}

/**
 * Holds if the expression is explicitly handled by `globalValueNumber`.
 * Unanalyzable expressions still need to be given a global value number,
 * but it will be a unique number that is not shared with any other
 * expression.
 */
private predicate analyzableExpr(Expr e) {
  analyzableConst(e) or
  analyzableStackVariable(e) or
  analyzableDotFieldAccess(e) or
  analyzablePointerFieldAccess(e) or
  analyzableImplicitThisFieldAccess(e) or
  analyzableOtherVariable(e) or
  analyzableConversion(e) or
  analyzableBinaryOp(e) or
  analyzableUnaryOp(e) or
  analyzableThisExpr(e) or
  analyzableArrayAccess(e) or
  analyzablePointerDereferenceExpr(e)
}
