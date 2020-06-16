/**
 * Provides classes and predicates for reasoning about definitions and uses of variables.
 */

import cpp
private import semmle.code.cpp.controlflow.StackVariableReachability
private import semmle.code.cpp.dataflow.EscapesTree

/**
 * Computed relation: A "definition-use-pair" for a particular variable.
 * Intuitively, this means that `def` is an assignment to `var`, and
 * `use` is a read of `var` at which the value assigned by `def` may
 * be read. (There can be more than one definition reaching a single
 * use, and a single definition can reach many uses.)
 */
predicate definitionUsePair(SemanticStackVariable var, Expr def, Expr use) {
  exists(Use u |
    u = use and
    def.(Def).reaches(true, var, u) and
    u.getVariable(false) = var
  )
}

/**
 * Holds if the definition `def` of some stack variable can reach `node`, which
 * is a definition or use, without crossing definitions of the same variable.
 */
predicate definitionReaches(Expr def, Expr node) { def.(Def).reaches(true, _, node.(DefOrUse)) }

private predicate hasAddressOfAccess(SemanticStackVariable var) {
  var.getAnAccess().isAddressOfAccessNonConst()
}

/**
 * A use/use pair is a pair of uses of a particular variable `var`
 * where the same value might be read (meaning that there is a
 * control-flow path from `first` to `second` without crossing
 * a definition of `var`).
 */
predicate useUsePair(SemanticStackVariable var, Expr first, Expr second) {
  (
    /*
     * If the address of `var` is used anywhere, we require that
     * a definition of `var` can reach the first use. This is to
     * rule out examples such as this:
     * ```
     * int x = 0;
     * int& y = x;
     * use(x);
     * y = 1;
     * use(x); // not a use-use pair with the use above
     * ```
     */

    hasAddressOfAccess(var) implies definitionUsePair(var, _, first)
  ) and
  // If `first` is both a def and a use, like `x` in `f(x)` when `f` takes a
  // reference parameter, it'll play the role of a use first and a def second.
  // We are not interested in uses that follow its role as a def.
  not definition(var, first) and
  exists(Use u |
    u = second and
    first.(Use).reaches(false, var, u) and
    u.getVariable(false) = var
  )
}

/**
 * Holds if `va` is a use of the parameter `p` that could
 * observe the passed-in value.
 */
predicate parameterUsePair(Parameter p, VariableAccess va) {
  not parameterIsOverwritten(_, p) and va.getTarget() = p
  or
  exists(ParameterDef pd | pd.reaches(true, p, va.(Use)))
}

/**
 * Utility class: A definition or use of a stack variable.
 */
library class DefOrUse extends ControlFlowNodeBase {
  DefOrUse() {
    // Uninstantiated templates are purely syntax, and only on instantiation
    // will they be complete with information about types, conversions, call
    // targets, etc.
    not this.(ControlFlowNode).isFromUninstantiatedTemplate(_)
  }

  /**
   * Gets the target variable of this definition or use.
   *
   * The `isDef` parameter is needed in order to ensure disjointness
   * of definitions and uses; in a variable initialization such as
   * `int x = y`, `y` is both a definition of `x`, as well as a use of
   * `y`, and `isDef` is used to distinguish the two situations.
   */
  abstract SemanticStackVariable getVariable(boolean isDef);

  pragma[noinline]
  private predicate reaches_helper(boolean isDef, SemanticStackVariable v, BasicBlock bb, int i) {
    getVariable(isDef) = v and
    bb.getNode(i) = this
  }

  /**
   * Holds if the value of `v` in this control-flow node reaches
   * `defOrUse` along some control-flow path without crossing a
   * definition of `v`.
   */
  cached
  predicate reaches(boolean isDef, SemanticStackVariable v, DefOrUse defOrUse) {
    /*
     * Implementation detail: this predicate and its private auxiliary
     * predicates are instances of the more general predicates in
     * StackVariableReachability.qll, and should be kept in sync.
     *
     * Unfortunately, caching of abstract predicates does not work well, so the
     * predicates are duplicated for now.
     */

    exists(BasicBlock bb, int i | reaches_helper(isDef, v, bb, i) |
      exists(int j |
        j > i and
        (bbDefAt(bb, j, v, defOrUse) or bbUseAt(bb, j, v, defOrUse)) and
        not exists(int k | firstBarrierAfterThis(isDef, k, v) and k < j)
      )
      or
      not firstBarrierAfterThis(isDef, _, v) and
      bbSuccessorEntryReachesDefOrUse(bb, v, defOrUse, _)
    )
  }

  private predicate firstBarrierAfterThis(boolean isDef, int j, SemanticStackVariable v) {
    exists(BasicBlock bb, int i |
      getVariable(isDef) = v and
      bb.getNode(i) = this and
      j = min(int k | bbBarrierAt(bb, k, v, _) and k > i)
    )
  }
}

/** A definition of a stack variable. */
library class Def extends DefOrUse {
  Def() { definition(_, this) }

  override SemanticStackVariable getVariable(boolean isDef) {
    definition(result, this) and isDef = true
  }
}

/** Holds if parameter `p` is potentially overwritten in the body of `f`. */
private predicate parameterIsOverwritten(Function f, Parameter p) {
  f.getAParameter() = p and
  definitionBarrier(p, _)
}

/** A definition of a parameter. */
library class ParameterDef extends DefOrUse {
  ParameterDef() {
    // Optimization: parameters that are not overwritten do not require
    // reachability analysis
    exists(Function f | parameterIsOverwritten(f, _) | this = f.getEntryPoint())
  }

  override SemanticStackVariable getVariable(boolean isDef) {
    exists(Function f | parameterIsOverwritten(f, result) | this = f.getEntryPoint()) and
    isDef = true
  }
}

/** A use of a stack variable. */
library class Use extends DefOrUse {
  Use() { useOfVar(_, this) }

  override SemanticStackVariable getVariable(boolean isDef) {
    useOfVar(result, this) and isDef = false
  }
}

private predicate bbUseAt(BasicBlock bb, int i, SemanticStackVariable v, Use use) {
  bb.getNode(i) = use and
  use.getVariable(false) = v
}

private predicate bbDefAt(BasicBlock bb, int i, SemanticStackVariable v, Def def) {
  bb.getNode(i) = def and
  def.getVariable(true) = v
}

private predicate bbBarrierAt(BasicBlock bb, int i, SemanticStackVariable v, ControlFlowNode node) {
  bb.getNode(i) = node and
  definitionBarrier(v, node)
}

/**
 * Holds if the entry node of a _successor_ of basic block `bb` can
 * reach `defOrUse` without going through a barrier for `v`.
 * `defOrUse` may either be in the successor block, or in another
 * basic block reachable from the successor.
 *
 * `skipsFirstLoopAlwaysTrueUponEntry` indicates whether the first loop
 * on the path to `defOrUse` (if any), where the condition is provably
 * true upon entry, is skipped (including the step from `bb` to the
 * successor).
 */
private predicate bbSuccessorEntryReachesDefOrUse(
  BasicBlock bb, SemanticStackVariable v, DefOrUse defOrUse,
  boolean skipsFirstLoopAlwaysTrueUponEntry
) {
  exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
    bbSuccessorEntryReachesLoopInvariant(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
      succSkipsFirstLoopAlwaysTrueUponEntry)
  |
    bbEntryReachesDefOrUseLocally(succ, v, defOrUse) and
    succSkipsFirstLoopAlwaysTrueUponEntry = false and
    not excludeReachesFunction(bb.getEnclosingFunction())
    or
    not bbBarrierAt(succ, _, v, _) and
    bbSuccessorEntryReachesDefOrUse(succ, v, defOrUse, succSkipsFirstLoopAlwaysTrueUponEntry)
  )
}

private predicate bbEntryReachesDefOrUseLocally(
  BasicBlock bb, SemanticStackVariable v, DefOrUse defOrUse
) {
  exists(int n | bbDefAt(bb, n, v, defOrUse) or bbUseAt(bb, n, v, defOrUse) |
    not exists(int m | m < n | bbBarrierAt(bb, m, v, _))
  )
}

/**
 * Holds if `barrier` is either a (potential) definition of `v` or follows an
 * access that gets the address of `v`. In both cases, the value of
 * `v` after `barrier` cannot be assumed to be the same as before.
 */
predicate definitionBarrier(SemanticStackVariable v, ControlFlowNode barrier) {
  definition(v, barrier)
  or
  exists(VariableAccess va |
    // `va = barrier` does not work, as that could generate an
    // incorrect use-use pair (a barrier must exist _between_
    // uses):
    //
    //     x = 0;
    //     int& y = x; // use1
    //     y = 1;
    //     use(x); // use2
    va.getASuccessor() = barrier and
    va.getTarget() = v and
    va.isAddressOfAccessNonConst() and
    not exists(Call c | c.passesByReferenceNonConst(_, va)) // handled in definitionByReference
  )
}

/**
 * Holds if `def` is a (potential) assignment to stack variable `v`. That is,
 * the variable may hold another value in the control-flow node(s)
 * following `def` than before.
 */
predicate definition(SemanticStackVariable v, Expr def) {
  def = v.getInitializer().getExpr()
  or
  variableAccessedAsValue(v.getAnAccess(), def.(Assignment).getLValue().getFullyConverted())
  or
  variableAccessedAsValue(v.getAnAccess(), def.(CrementOperation).getOperand().getFullyConverted())
  or
  exists(AsmStmt asmStmt |
    def = asmStmt.getAChild() and
    def = v.getAnAccess().getParent*()
  )
  or
  definitionByReference(v.getAnAccess(), def)
}

/**
 * Holds if `def` is a (definite) assignment to the stack variable `v`. `e` is
 * the assigned expression.
 */
predicate exprDefinition(SemanticStackVariable v, ControlFlowNode def, Expr e) {
  def = v.getInitializer().getExpr() and
  def = e and
  not v.getType() instanceof ReferenceType
  or
  exists(AssignExpr assign |
    def = assign and
    assign.getLValue() = v.getAnAccess() and
    e = assign.getRValue()
  )
}

pragma[noinline]
private predicate containsAssembly(Function f) { f = any(AsmStmt s).getEnclosingFunction() }

/**
 * Holds if `va` is a variable passed by reference as argument `def`, where the
 * callee potentially assigns the corresponding parameter. The
 * definitions-and-uses library models assignment by reference as if it happens
 * on evaluation of the argument, `def`.
 *
 * All library functions except `std::move` are assumed to assign
 * call-by-reference parameters, and source code functions are assumed to
 * assign call-by-reference parameters that are accessed somewhere within the
 * function. The latter is an over-approximation, but avoids having to take
 * aliasing of the parameter into account.
 */
predicate definitionByReference(VariableAccess va, Expr def) {
  exists(Call c, int i |
    c.passesByReferenceNonConst(i, va) and
    def = c.getArgument(i) and
    forall(Function f | f = c.getTarget() and f.hasEntryPoint() |
      exists(f.getParameter(i).getAnAccess())
      or
      f.isVarargs() and i >= f.getNumberOfParameters()
      or
      // If the callee contains an AsmStmt, then it is better to
      // be conservative and assume that the parameter can be
      // modified.
      containsAssembly(f)
    )
  )
  or
  // Extractor artifact when using templates; an expression call where the
  // target expression is an unknown literal. Since we cannot know what
  // these calls represent, assume they assign all their arguments
  exists(ExprCall c, Literal l |
    l = c.getExpr() and
    c.getAnArgument() = va and
    not exists(l.getValue()) and
    def = va
  )
}

private predicate accessInSizeof(VariableAccess use) { use.getParent+() instanceof SizeofOperator }

/**
 * Holds if `use` is a non-definition use of stack variable `v`. This will not
 * include accesses on the LHS of an assignment (which don't retrieve the
 * variable value), but _will_ include accesses in increment/decrement
 * operations.
 */
predicate useOfVar(SemanticStackVariable v, VariableAccess use) {
  use = v.getAnAccess() and
  not exists(AssignExpr e | e.getLValue() = use) and
  // sizeof accesses are resolved at compile-time
  not accessInSizeof(use)
}

/**
 * Same as `useOfVar(v, use)`, but with the extra condition that the
 * access `use` actually reads the value of the stack variable `v` at
 * run-time. (Non-examples include `&x` and function calls where the
 * callee does not use the relevant parameter.)
 */
predicate useOfVarActual(SemanticStackVariable v, VariableAccess use) {
  useOfVar(v, use) and
  exists(Expr e |
    variableAccessedAsValue(use, e) and
    not exists(AssignExpr assign | e = assign.getLValue().getFullyConverted())
  ) and
  // A call to a function that does not use the relevant parameter
  not exists(Call c, int i |
    c.getArgument(i) = use and
    c.getTarget().hasEntryPoint() and
    not exists(c.getTarget().getParameter(i).getAnAccess())
  )
}

/**
 * A function that should be excluded from 'reaches' analysis.
 *
 * The current implementation performs badly in some cases where a
 * function has both a huge number of def/uses and a huge number of
 * basic blocks, typically in generated code.  We exclude these
 * functions based on the former because it is cheaper to calculate.
 */
private predicate excludeReachesFunction(Function f) {
  exists(int defOrUses |
    defOrUses =
      count(Def def | def.(ControlFlowNode).getControlFlowScope() = f) +
        count(Use use | use.(ControlFlowNode).getControlFlowScope() = f) and
    defOrUses >= 13000
  )
}
