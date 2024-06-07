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
 * func f(x int, y int) {
 *   g(x+y, x+y);
 * }
 * ```
 *
 * In this example, both arguments in the call to `g` compute the same value,
 * so both arguments have the same `GVN`. In other words, we can find
 * this call with the following query:
 *
 * ```
 * from CallExpr call, GVN v
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

import go

/**
 * Holds if the result is a control flow node that might change the
 * value of any package variable. This is used in the implementation
 * of `MkOtherVariable`, because we need to be quite conservative when
 * we assign a value number to a package variable. For example:
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
private ControlFlow::Node nodeWithPossibleSideEffect() {
  exists(DataFlow::CallNode call |
    call.getCall().mayHaveOwnSideEffects() and
    not isPureFn(call.getTarget()) and
    result = call.asInstruction()
  )
  or
  // If the lhs of an assignment is not analyzable by SSA, then
  // we need to treat the assignment as having a possible side-effect.
  result instanceof Write and
  not exists(SsaExplicitDefinition ssa | result = ssa.getInstruction())
}

private predicate isPureFn(Function f) {
  f.(BuiltinFunction).isPure()
  or
  isPureStmt(f.(DeclaredFunction).getBody())
}

private predicate isPureStmt(Stmt s) {
  exists(BlockStmt blk | blk = s | forall(Stmt ch | ch = blk.getAStmt() | isPureStmt(ch)))
  or
  isPureExpr(s.(ReturnStmt).getExpr())
}

private predicate isPureExpr(Expr e) {
  e instanceof BasicLit
  or
  exists(FuncDef f | f = e.getEnclosingFunction() |
    e = f.getAParameter().getAReference()
    or
    e = f.(MethodDecl).getReceiver().getAReference()
  )
  or
  isPureExpr(e.(SelectorExpr).getBase())
  or
  exists(CallExpr ce | e = ce |
    isPureFn(ce.getTarget()) and
    forall(Expr arg | arg = ce.getAnArgument() | isPureExpr(arg))
  )
}

/**
 * Gets the entry node of the control flow graph of which `node` is a
 * member.
 */
private ControlFlow::Node getControlFlowEntry(ControlFlow::Node node) {
  result = node.getRoot().getEntryNode()
}

private predicate entryNode(ControlFlow::Node node) { node.isEntryNode() }

/**
 * Holds if there is a control flow edge from `src` to `dst` or
 * if `dst` is an expression with a possible side-effect. The idea
 * is to treat side effects as entry points in the control flow
 * graph so that we can use the dominator tree to find the most recent
 * side-effect.
 */
private predicate sideEffectCfg(ControlFlow::Node src, ControlFlow::Node dst) {
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
private predicate iDomEffect(ControlFlow::Node dominator, ControlFlow::Node node) =
  idominance(entryNode/1, sideEffectCfg/2)(_, dominator, node)

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
private ControlFlow::Node mostRecentSideEffect(ControlFlow::Node node) {
  exists(ControlFlow::Node entry |
    entryNode(entry) and
    iDomEffect(entry, result) and
    iDomEffect*(result, node)
  )
}

/** Used to represent the "global value number" of an expression. */
cached
private newtype GvnBase =
  MkNumericConst(string val) { mkNumericConst(_, val) } or
  MkStringConst(string val) { mkStringConst(_, val) } or
  MkBoolConst(boolean val) { mkBoolConst(_, val) } or
  MkIndirectSsa(SsaDefinition def) { not ssaInit(def, _) } or
  MkFunc(Function fn) { mkFunc(_, fn) } or
  // Variables with no SSA information. As a crude (but safe)
  // approximation, we use `mostRecentSideEffect` to compute a definition
  // location for the variable. This ensures that two instances of the same
  // global variable will only get the same value number if they are
  // guaranteed to have the same value.
  MkOtherVariable(ValueEntity x, ControlFlow::Node dominator) { mkOtherVariable(_, x, dominator) } or
  MkMethodAccess(GVN base, Function m) { mkMethodAccess(_, base, m) } or
  MkFieldRead(GVN base, Field f, ControlFlow::Node dominator) { mkFieldRead(_, base, f, dominator) } or
  MkPureCall(Function f, GVN callee, GvnList args) { mkPureCall(_, f, callee, args) } or
  MkIndex(GVN base, GVN index, ControlFlow::Node dominator) { mkIndex(_, base, index, dominator) } or
  // Dereference a pointer. The value might have changed since the last
  // time the pointer was dereferenced, so we need to include a definition
  // location. As a crude (but safe) approximation, we use
  // `mostRecentSideEffect` to compute a definition location.
  MkDeref(GVN base, ControlFlow::Node dominator) { mkDeref(_, base, dominator) } or
  MkBinaryOp(GVN lhs, GVN rhs, string op) { mkBinaryOp(_, lhs, rhs, op) } or
  MkUnaryOp(GVN child, string op) { mkUnaryOp(_, child, op) } or
  // Any expression that is not handled by the cases above is
  // given a unique number based on the expression itself.
  MkUnanalyzable(DataFlow::Node e) { not analyzableExpr(e) }

private newtype GvnList =
  MkNil() or
  MkCons(GVN head, GvnList tail) { globalValueNumbers(_, _, head, tail) }

private GvnList globalValueNumbers(DataFlow::CallNode ce, int start) {
  analyzableCall(ce, _) and
  start = ce.getNumArgument() and
  result = MkNil()
  or
  exists(GVN head, GvnList tail |
    globalValueNumbers(ce, start, head, tail) and
    result = MkCons(head, tail)
  )
}

private predicate globalValueNumbers(DataFlow::CallNode ce, int start, GVN head, GvnList tail) {
  analyzableCall(ce, _) and
  head = globalValueNumber(ce.getArgument(start)) and
  tail = globalValueNumbers(ce, start + 1)
}

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
class GVN extends GvnBase {
  GVN() { this instanceof GvnBase }

  /** Gets a data-flow node that has this GVN. */
  DataFlow::Node getANode() { this = globalValueNumber(result) }

  /** Gets the kind of the GVN. This can be useful for debugging. */
  string getKind() {
    this instanceof MkNumericConst and result = "NumericConst"
    or
    this instanceof MkStringConst and result = "StringConst"
    or
    this instanceof MkBoolConst and result = "BoolConst"
    or
    this instanceof MkIndirectSsa and result = "IndirectSsa"
    or
    this instanceof MkFunc and result = "Func"
    or
    this instanceof MkOtherVariable and result = "OtherVariable"
    or
    this instanceof MkMethodAccess and result = "MethodAccess"
    or
    this instanceof MkFieldRead and result = "FieldRead"
    or
    this instanceof MkPureCall and result = "PureCall"
    or
    this instanceof MkIndex and result = "Index"
    or
    this instanceof MkDeref and result = "Deref"
    or
    this instanceof MkBinaryOp and result = "BinaryOp"
    or
    this instanceof MkUnaryOp and result = "UnaryOp"
    or
    this instanceof MkUnanalyzable and result = "Unanalyzable"
  }

  /**
   * Gets an example of a data-flow node with this GVN.
   * This is useful for things like implementing toString().
   */
  private DataFlow::Node exampleNode() {
    // Pick the expression with the minimum source location. This is
    // just an arbitrary way to pick an expression with this `GVN`.
    result =
      min(DataFlow::Node e, string f, int l, int c, string k |
        e = this.getANode() and e.hasLocationInfo(f, l, c, _, _) and k = e.getNodeKind()
      |
        e order by f, l, c, k
      )
  }

  /** Gets a textual representation of this element. */
  string toString() { result = this.exampleNode().toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.exampleNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private predicate mkNumericConst(DataFlow::Node nd, string val) {
  nd.getType().getUnderlyingType() instanceof NumericType and
  val = nd.getExactValue() and
  nd.isPlatformIndependentConstant()
}

private predicate mkStringConst(DataFlow::Node nd, string val) {
  val = nd.getStringValue() and
  nd.isPlatformIndependentConstant()
}

private predicate mkBoolConst(DataFlow::Node nd, boolean val) {
  val = nd.getBoolValue() and
  nd.isPlatformIndependentConstant()
}

private predicate mkFunc(DataFlow::Node nd, Function f) {
  nd = f.getARead() and
  not f instanceof Method
}

private predicate analyzableConst(DataFlow::Node e) {
  mkNumericConst(e, _) or mkStringConst(e, _) or mkBoolConst(e, _) or mkFunc(e, _)
}

private predicate analyzableMethodAccess(Read access, DataFlow::Node receiver, Method m) {
  exists(IR::ReadInstruction r | r = access.asInstruction() |
    r.readsMethod(receiver.asInstruction(), m) and
    not r.isConst()
  )
}

private predicate mkMethodAccess(DataFlow::Node access, GVN qualifier, Method m) {
  exists(DataFlow::Node base |
    analyzableMethodAccess(access, base, m) and
    qualifier = globalValueNumber(base)
  )
}

private predicate analyzableFieldRead(Read fread, DataFlow::Node base, Field f) {
  exists(IR::ReadInstruction r | r = fread.asInstruction() |
    r.readsField(base.asInstruction(), f) and
    strictcount(mostRecentSideEffect(r)) = 1 and
    not r.isConst()
  )
}

private predicate mkFieldRead(
  DataFlow::Node fread, GVN qualifier, Field v, ControlFlow::Node dominator
) {
  exists(DataFlow::Node base |
    analyzableFieldRead(fread, base, v) and
    qualifier = globalValueNumber(base) and
    dominator = mostRecentSideEffect(fread.asInstruction())
  )
}

private predicate analyzableCall(DataFlow::CallNode ce, Function f) {
  f = ce.getTarget() and
  isPureFn(f) and
  not ce.isConst()
}

private predicate mkPureCall(DataFlow::CallNode ce, Function f, GVN callee, GvnList args) {
  analyzableCall(ce, f) and
  callee = globalValueNumber(ce.getCalleeNode()) and
  args = globalValueNumbers(ce, 0)
}

/**
 * Holds if `v` is a variable whose value changes are not, or at least not fully, captured by SSA.
 *
 * This is the case for package variables (for which no SSA information exists), but also for
 * variables of non-primitive type (for which deep mutations are not captured by SSA).
 */
private predicate incompleteSsa(ValueEntity v) {
  not v instanceof Field and
  (
    not v instanceof SsaSourceVariable
    or
    v.(SsaSourceVariable).mayHaveIndirectReferences()
    or
    exists(Type tp | tp = v.(DeclaredVariable).getType().getUnderlyingType() |
      not tp instanceof BasicType
    )
  )
}

/**
 * Holds if `access` is an access to a variable `target` for which SSA information is incomplete.
 */
private predicate analyzableOtherVariable(DataFlow::Node access, ValueEntity target) {
  access.asInstruction().reads(target) and
  incompleteSsa(target) and
  strictcount(mostRecentSideEffect(access.asInstruction())) = 1 and
  not access.isConst() and
  not target instanceof Function
}

private predicate mkOtherVariable(DataFlow::Node access, ValueEntity x, ControlFlow::Node dominator) {
  analyzableOtherVariable(access, x) and
  dominator = mostRecentSideEffect(access.asInstruction())
}

private predicate analyzableBinaryOp(
  DataFlow::BinaryOperationNode op, string opname, DataFlow::Node lhs, DataFlow::Node rhs
) {
  opname = op.getOperator() and
  not op.mayHaveSideEffects() and
  lhs = op.getLeftOperand() and
  rhs = op.getRightOperand() and
  not op.isConst()
}

private predicate mkBinaryOp(DataFlow::Node op, GVN lhs, GVN rhs, string opname) {
  exists(DataFlow::Node l, DataFlow::Node r |
    analyzableBinaryOp(op, opname, l, r) and
    lhs = globalValueNumber(l) and
    rhs = globalValueNumber(r)
  )
}

private predicate analyzableUnaryOp(DataFlow::UnaryOperationNode op) {
  not op.mayHaveSideEffects() and
  not op.isConst()
}

private predicate mkUnaryOp(DataFlow::UnaryOperationNode op, GVN child, string opname) {
  analyzableUnaryOp(op) and
  child = globalValueNumber(op.getOperand()) and
  opname = op.getOperator()
}

private predicate analyzableIndexExpr(DataFlow::ElementReadNode ae) {
  strictcount(mostRecentSideEffect(ae.asInstruction())) = 1 and
  not ae.isConst()
}

private predicate mkIndex(
  DataFlow::ElementReadNode ae, GVN base, GVN offset, ControlFlow::Node dominator
) {
  analyzableIndexExpr(ae) and
  base = globalValueNumber(ae.getBase()) and
  offset = globalValueNumber(ae.getIndex()) and
  dominator = mostRecentSideEffect(ae.asInstruction())
}

private predicate analyzablePointerDereferenceExpr(DataFlow::PointerDereferenceNode deref) {
  strictcount(mostRecentSideEffect(deref.asInstruction())) = 1 and
  not deref.isConst()
}

private predicate mkDeref(DataFlow::PointerDereferenceNode deref, GVN p, ControlFlow::Node dominator) {
  analyzablePointerDereferenceExpr(deref) and
  p = globalValueNumber(deref.getOperand()) and
  dominator = mostRecentSideEffect(deref.asInstruction())
}

private predicate ssaInit(SsaExplicitDefinition ssa, DataFlow::Node rhs) {
  ssa.getRhs() = rhs.asInstruction()
}

/** Gets the global value number of data-flow node `nd`. */
cached
GVN globalValueNumber(DataFlow::Node nd) {
  exists(string val |
    mkNumericConst(nd, val) and
    result = MkNumericConst(val)
  )
  or
  exists(string val |
    mkStringConst(nd, val) and
    result = MkStringConst(val)
  )
  or
  exists(boolean val |
    mkBoolConst(nd, val) and
    result = MkBoolConst(val)
  )
  or
  exists(Function f |
    mkFunc(nd, f) and
    result = MkFunc(f)
  )
  or
  exists(ValueEntity x, ControlFlow::Node dominator |
    mkOtherVariable(nd, x, dominator) and
    result = MkOtherVariable(x, dominator)
  )
  or
  exists(GVN qualifier, Function target |
    mkMethodAccess(nd, qualifier, target) and
    result = MkMethodAccess(qualifier, target)
  )
  or
  exists(GVN qualifier, Entity target, ControlFlow::Node dominator |
    mkFieldRead(nd, qualifier, target, dominator) and
    result = MkFieldRead(qualifier, target, dominator)
  )
  or
  exists(Function f, GVN callee, GvnList args |
    mkPureCall(nd, f, callee, args) and
    result = MkPureCall(f, callee, args)
  )
  or
  exists(GVN lhs, GVN rhs, string opname |
    mkBinaryOp(nd, lhs, rhs, opname) and
    result = MkBinaryOp(lhs, rhs, opname)
  )
  or
  exists(GVN child, string opname |
    mkUnaryOp(nd, child, opname) and
    result = MkUnaryOp(child, opname)
  )
  or
  exists(GVN x, GVN i, ControlFlow::Node dominator |
    mkIndex(nd, x, i, dominator) and
    result = MkIndex(x, i, dominator)
  )
  or
  exists(GVN p, ControlFlow::Node dominator |
    mkDeref(nd, p, dominator) and
    result = MkDeref(p, dominator)
  )
  or
  not analyzableExpr(nd) and
  result = MkUnanalyzable(nd)
  or
  exists(DataFlow::SsaNode ssa |
    nd = ssa.getAUse() and
    not incompleteSsa(ssa.getSourceVariable()) and
    result = globalValueNumber(ssa)
  )
  or
  exists(SsaDefinition ssa | ssa = nd.(DataFlow::SsaNode).getDefinition() |
    // Local variable with a defining value.
    exists(DataFlow::Node init |
      ssaInit(ssa, init) and
      result = globalValueNumber(init)
    )
    or
    // Local variable without a defining value.
    not ssaInit(ssa, _) and
    result = MkIndirectSsa(ssa)
  )
}

/**
 * Holds if the expression is explicitly handled by `globalValueNumber`.
 * Unanalyzable expressions still need to be given a global value number,
 * but it will be a unique number that is not shared with any other
 * expression.
 */
private predicate analyzableExpr(DataFlow::Node e) {
  analyzableConst(e) or
  any(DataFlow::SsaNode ssa).getAUse() = e or
  e instanceof DataFlow::SsaNode or
  analyzableOtherVariable(e, _) or
  analyzableMethodAccess(e, _, _) or
  analyzableFieldRead(e, _, _) or
  analyzableCall(e, _) or
  analyzableBinaryOp(e, _, _, _) or
  analyzableUnaryOp(e) or
  analyzableIndexExpr(e) or
  analyzablePointerDereferenceExpr(e)
}
