/**
 * Provides classes for working with static single assignment form (SSA).
 *
 * We compute SSA form based on the intra-procedural CFG, without
 * any call graph information. This means that we have to make worst-case
 * assumptions about the possible effects of function calls and `yield`:
 *
 *  - For a variable `x` declared in a function `f`, if `x` has assignments
 *    in a function other than `f`, then any function call and `yield`
 *    expression is assumed to write `x`.
 *  - If `x` is not written outside `f`, then function calls can never
 *    affect `x`, while `yield` expressions in functions other than `f`
 *    still may affect it.
 *
 * This is modeled as follows.
 *
 * Within each function `g` that accesses a variable `x` declared in an
 * enclosing function `f`, we introduce a pseudo-assignment to `x` called
 * a _capture_ of `x` at the beginning of `g` that (conceptually) captures
 * the current value of `x`.
 *
 * Additionally, we introduce _re-captures_ for `x` in the following
 * places:
 *
 *   - At any function call and `yield`, if `x` is assigned outside `f`.
 *   - At any `yield` outside `f`, if `x` is not assigned outside `f`.
 *
 * Re-captures are introduced only where needed, that is, where there
 * is a live use of `x` after the re-capture.
 *
 * To see why re-captures need to be placed at `yield` expressions,
 * consider the following function:
 *
 * ```
 * function k() {
 *   var x = 0;
 *
 *   function* iter() {
 *     console.log(x);
 *     yield;
 *     console.log(x);
 *   }
 *
 *   var gen = iter();
 *   gen.next();
 *   ++x;
 *   gen.next();
 * }
 * ```
 *
 * Here, `iter` has a capture for `x` at its beginning, and a re-capture
 * at the `yield` to reflect the fact that `x` is incremented between the
 * two `console.log` calls.
 *
 * In the above example, `x` is only assigned inside its declaring function
 * `k`, so function calls and `yield` expressions inside `k` cannot affect it.
 *
 * Consider another example:
 *
 * ```
 * function* k() {
 *   var x = 0;
 *   console.log(x);
 *   yield () => ++x;
 *   console.log(x);
 * }
 * var gen = k();
 * gen.next().value();
 * gen.next();
 * ```
 *
 * Here, `x` is assigned outside its declaring function `k`, so the `yield`
 * expression in `k` induces a re-capture of `x` to reflect the fact that `x`
 * is incremented between the two `console.log` calls.
 */

import javascript
private import semmle.javascript.dataflow.Refinements
private import semmle.javascript.internal.CachedStages

/**
 * A variable that can be SSA converted, that is, a local variable.
 */
class SsaSourceVariable extends LocalVariable { }

cached
private module Internal {
  /**
   * A data type representing SSA definitions.
   *
   * We distinguish five kinds of SSA definitions:
   *
   *   1. Explicit definitions wrapping a `VarDef` node in the CFG.
   *   2. Implicit initializations of locals (including `arguments`) at
   *      the start of a function, which do not correspond directly to
   *      CFG nodes.
   *   3. Pseudo-definitions for captured variables at the beginning of
   *      the capturing function as well as after `yield` expressions
   *      and calls.
   *   4. Phi nodes.
   *   5. Refinement nodes at points in the CFG where additional information
   *      about a variable becomes available, which may constrain the set of
   *      its potential values.
   *
   * SSA definitions are only introduced where necessary. In particular,
   * unreachable code has no SSA definitions associated with it, and neither
   * have dead assignments (that is, assignments whose value is never read).
   */
  cached
  newtype TSsaDefinition =
    TExplicitDef(ReachableBasicBlock bb, int i, VarDef d, SsaSourceVariable v) {
      bb.defAt(i, v, d) and
      (
        liveAfterDef(bb, i, v) or
        v.isCaptured()
      )
    } or
    TImplicitInit(EntryBasicBlock bb, SsaSourceVariable v) {
      bb.getContainer() = v.getDeclaringContainer().getFunctionBoundary() and
      (liveAtEntry(bb, v) or v.isCaptured())
    } or
    TCapture(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
      mayCapture(bb, i, v) and liveAfterDef(bb, i, v)
    } or
    TPhi(ReachableJoinBlock bb, SsaSourceVariable v) {
      liveAtEntry(bb, v) and
      inDefDominanceFrontier(bb, v)
    } or
    TRefinement(ReachableBasicBlock bb, int i, GuardControlFlowNode guard, SsaSourceVariable v) {
      bb.getNode(i) = guard and
      guard.getTest().(Refinement).getRefinedVar() = v and
      liveAtEntry(bb, v)
    }

  /**
   * Holds if `bb` is in the dominance frontier of a block containing a definition of `v`.
   */
  pragma[noinline]
  private predicate inDefDominanceFrontier(ReachableJoinBlock bb, SsaSourceVariable v) {
    exists(ReachableBasicBlock defbb, SsaDefinition def |
      def.definesAt(defbb, _, v) and
      bb.inDominanceFrontierOf(defbb)
    )
  }

  /**
   * Holds if `v` is a captured variable which is declared in `declContainer` and read in
   * `useContainer`.
   */
  private predicate readsCapturedVar(
    StmtContainer useContainer, SsaSourceVariable v, StmtContainer declContainer
  ) {
    declContainer = v.getDeclaringContainer() and
    useContainer = any(VarUse u | u.getVariable() = v).getContainer() and
    v.isCaptured()
  }

  /**
   * Holds if the `i`th node of `bb` in container `sc` is entry node `nd`.
   */
  private predicate entryNode(
    StmtContainer sc, ReachableBasicBlock bb, int i, ControlFlowEntryNode nd
  ) {
    sc = bb.getContainer() and bb.getNode(i) = nd
  }

  /**
   * Holds if the `i`th node of `bb` in container `sc` is yield expression `nd`.
   */
  private predicate yieldNode(StmtContainer sc, ReachableBasicBlock bb, int i, YieldExpr nd) {
    sc = bb.getContainer() and bb.getNode(i) = nd
  }

  /**
   * Holds if the `i`th node of `bb` in container `sc` is invocation expression `nd`.
   */
  private predicate invokeNode(StmtContainer sc, ReachableBasicBlock bb, int i, InvokeExpr nd) {
    sc = bb.getContainer() and bb.getNode(i) = nd
  }

  /**
   * Holds if the `i`th node of basic block `bb` may induce a pseudo-definition for
   * modeling updates to captured variable `v`. Whether the definition is actually
   * introduced depends on whether `v` is live at this point in the program.
   */
  private predicate mayCapture(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(ControlFlowNode nd, StmtContainer capturingContainer, StmtContainer declContainer |
      // capture initial value of variable declared in enclosing scope
      readsCapturedVar(capturingContainer, v, declContainer) and
      capturingContainer != declContainer and
      entryNode(capturingContainer, bb, i, nd)
      or
      // re-capture value of variable after `yield` if it is declared in enclosing scope
      // or assigned non-locally
      readsCapturedVar(capturingContainer, v, declContainer) and
      (capturingContainer != declContainer or assignedThroughClosure(v)) and
      yieldNode(capturingContainer, bb, i, nd)
      or
      // re-capture value of variable after a call if it is assigned non-locally
      readsCapturedVar(capturingContainer, v, declContainer) and
      assignedThroughClosure(v) and
      invokeNode(capturingContainer, bb, i, nd)
    )
  }

  /**
   * A classification of variable references into reads and writes.
   */
  cached
  newtype RefKind =
    Read() or
    Write()

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v`, either a read
   * (when `tp` is `Read()`) or a direct or indirect write (when `tp` is `Write()`).
   */
  private predicate ref(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind tp) {
    bb.useAt(i, v, _) and tp = Read()
    or
    (mayCapture(bb, i, v) or bb.defAt(i, v, _)) and
    tp = Write()
  }

  /**
   * Gets the (1-based) rank of the reference to `v` at the `i`th node of basic block `bb`,
   * which has the given reference kind `tp`.
   */
  private int refRank(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind tp) {
    i = rank[result](int j | ref(bb, j, v, _)) and
    ref(bb, i, v, tp)
  }

  /**
   * Gets the maximum rank among all references to `v` in basic block `bb`.
   */
  private int maxRefRank(ReachableBasicBlock bb, SsaSourceVariable v) {
    result = max(refRank(bb, _, v, _))
  }

  /**
   * Holds if variable `v` is live after the `i`th node of basic block `bb`, where
   * `i` is the index of a node that may assign or capture `v`.
   *
   * For the purposes of this predicate, `yield` expressions and function invocations
   * are considered as writes of captured variables.
   */
  private predicate liveAfterDef(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(int r | r = refRank(bb, i, v, Write()) |
      // the next reference to `v` inside `bb` is a read
      r + 1 = refRank(bb, _, v, Read())
      or
      // this is the last reference to `v` inside `bb`, but `v` is live at entry
      // to a successor basic block of `bb`
      r = maxRefRank(bb, v) and
      liveAtSuccEntry(bb, v)
    )
  }

  /**
   * Holds if variable `v` is live at the beginning of basic block `bb`.
   *
   * For the purposes of this predicate, `yield` expressions and function invocations
   * are considered as writes of captured variables.
   */
  private predicate liveAtEntry(ReachableBasicBlock bb, SsaSourceVariable v) {
    // the first reference to `v` inside `bb` is a read
    refRank(bb, _, v, Read()) = 1
    or
    // there is no reference to `v` inside `bb`, but `v` is live at entry
    // to a successor basic block of `bb`
    not exists(refRank(bb, _, v, _)) and
    liveAtSuccEntry(bb, v)
  }

  /**
   * Holds if `v` is live at the beginning of any successor of basic block `bb`.
   */
  private predicate liveAtSuccEntry(ReachableBasicBlock bb, SsaSourceVariable v) {
    liveAtEntry(bb.getASuccessor(), v)
  }

  /**
   * Holds if `v` is assigned outside its declaring function.
   */
  private predicate assignedThroughClosure(SsaSourceVariable v) {
    v.getAnAccess().(LValue).getContainer() != v.getDeclaringContainer()
  }

  /**
   * Holds if the `i`th node of `bb` is a use or an SSA definition of variable `v`, with
   * `k` indicating whether it is the former or the latter.
   */
  private predicate ssaRef(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind k) {
    bb.useAt(i, v, _) and k = Read()
    or
    any(SsaDefinition def).definesAt(bb, i, v) and k = Write()
  }

  /**
   * Gets the (1-based) rank of the `i`th node of `bb` among all SSA definitions
   * and uses of `v` in `bb`, with `k` indicating whether it is a definition or a use.
   *
   * For example, if `bb` is a basic block with a phi node for `v` (considered
   * to be at index -1), uses `v` at node 2 and defines it at node 5, we have:
   *
   * ```
   * ssaRefRank(bb, -1, v, Write()) = 1    // phi node
   * ssaRefRank(bb,  2, v, Read())  = 2    // use at node 2
   * ssaRefRank(bb,  5, v, Write()) = 3    // definition at node 5
   * ```
   */
  private int ssaRefRank(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind k) {
    i = rank[result](int j | ssaRef(bb, j, v, _)) and
    ssaRef(bb, i, v, k)
  }

  /**
   * Gets the minimum rank of a read in `bb` such that all references to `v` between that
   * read and the read at index `i` are reads (and not writes).
   */
  private int rewindReads(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(int r | r = ssaRefRank(bb, i, v, Read()) |
      exists(int j, RefKind k | r - 1 = ssaRefRank(bb, j, v, k) |
        k = Read() and result = rewindReads(bb, j, v)
        or
        k = Write() and result = r
      )
      or
      r = 1 and result = r
    )
  }

  /**
   * Gets the SSA definition of `v` in `bb` that reaches the read of `v` at node `i`, if any.
   */
  private SsaDefinition getLocalDefinition(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(int r | r = rewindReads(bb, i, v) |
      exists(int j | result.definesAt(bb, j, v) and ssaRefRank(bb, j, v, _) = r - 1)
    )
  }

  /**
   * Gets an SSA definition of `v` that reaches the end of the immediate dominator of `bb`.
   */
  pragma[noinline]
  private SsaDefinition getDefReachingEndOfImmediateDominator(
    ReachableBasicBlock bb, SsaSourceVariable v
  ) {
    result = getDefReachingEndOf(bb.getImmediateDominator(), v)
  }

  /**
   * Gets an SSA definition of `v` that reaches the end of basic block `bb`.
   */
  cached
  SsaDefinition getDefReachingEndOf(ReachableBasicBlock bb, SsaSourceVariable v) {
    Stages::DataFlowStage::ref() and
    exists(int lastRef | lastRef = max(int i | ssaRef(bb, i, v, _)) |
      result = getLocalDefinition(bb, lastRef, v)
      or
      result.definesAt(bb, lastRef, v) and
      liveAtSuccEntry(bb, v)
    )
    or
    /*
     * In SSA form, the (unique) reaching definition of a use is the closest
     * definition that dominates the use. If two definitions dominate a node
     * then one must dominate the other, so we can find the reaching definition
     * by following the idominance relation backwards.
     */

    result = getDefReachingEndOfImmediateDominator(bb, v) and
    not exists(SsaDefinition ssa | ssa.definesAt(bb, _, v)) and
    liveAtSuccEntry(bb, v)
  }

  /**
   * Gets the unique SSA definition of `v` whose value reaches the `i`th node of `bb`,
   * which is a use of `v`.
   */
  cached
  SsaDefinition getDefinition(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    result = getLocalDefinition(bb, i, v)
    or
    rewindReads(bb, i, v) = 1 and result = getDefReachingEndOf(bb.getImmediateDominator(), v)
  }
}

private import Internal

/**
 * An SSA variable.
 */
class SsaVariable extends TSsaDefinition {
  /** Gets the source variable corresponding to this SSA variable. */
  SsaSourceVariable getSourceVariable() { result = this.(SsaDefinition).getSourceVariable() }

  /** Gets the (unique) definition of this SSA variable. */
  SsaDefinition getDefinition() { result = this }

  /** Gets a use in basic block `bb` that refers to this SSA variable. */
  VarUse getAUseIn(ReachableBasicBlock bb) {
    exists(int i, SsaSourceVariable v | v = this.getSourceVariable() |
      bb.useAt(i, v, result) and this = getDefinition(bb, i, v)
    )
  }

  /** Gets a use that refers to this SSA variable. */
  VarUse getAUse() { result = this.getAUseIn(_) }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getDefinition().prettyPrintRef() }

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
    this.getDefinition().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An SSA definition.
 */
class SsaDefinition extends TSsaDefinition {
  /** Gets the SSA variable defined by this definition. */
  SsaVariable getVariable() { result = this }

  /** Gets the source variable defined by this definition. */
  abstract SsaSourceVariable getSourceVariable();

  /**
   * Gets the basic block to which this definition belongs.
   *
   * Currently, all SSA definitions belong to a basic block, but the representation of
   * implicit definitions might change in the future, making this no longer true.
   */
  abstract ReachableBasicBlock getBasicBlock();

  /**
   * INTERNAL: Use `getBasicBlock()` and `getSourceVariable()` instead.
   *
   * Holds if this is a definition of source variable `v` at index `idx` in basic block `bb`.
   *
   * Phi nodes are considered to be at index `-1`, all other definitions at the index of
   * the control flow node they correspond to.
   */
  abstract predicate definesAt(ReachableBasicBlock bb, int idx, SsaSourceVariable v);

  /**
   * Gets a variable definition node whose value may end up contributing
   * to the SSA variable defined by this definition.
   */
  abstract VarDef getAContributingVarDef();

  /**
   * INTERNAL: Use `toString()` instead.
   *
   * Gets a pretty-printed representation of this SSA definition.
   */
  abstract string prettyPrintDef();

  /**
   * INTERNAL: Do not use.
   *
   * Gets a pretty-printed representation of a reference to this SSA definition.
   */
  abstract string prettyPrintRef();

  /** Gets a textual representation of this element. */
  string toString() { result = this.prettyPrintDef() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  abstract predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  );

  /** Gets the location of this element. */
  final Location getLocation() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      this.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      result.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }

  /** Gets the function or toplevel to which this definition belongs. */
  StmtContainer getContainer() { result = this.getBasicBlock().getContainer() }
}

/**
 * An SSA definition that corresponds to an explicit assignment or other variable definition.
 */
class SsaExplicitDefinition extends SsaDefinition, TExplicitDef {
  override predicate definesAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    this = TExplicitDef(bb, i, _, v)
  }

  /** This SSA definition corresponds to the definition of `v` at `def`. */
  predicate defines(VarDef def, SsaSourceVariable v) { this = TExplicitDef(_, _, def, v) }

  /** Gets the variable definition wrapped by this SSA definition. */
  VarDef getDef() { this = TExplicitDef(_, _, result, _) }

  /** Gets the basic block to which this definition belongs. */
  override ReachableBasicBlock getBasicBlock() { this.definesAt(result, _, _) }

  override SsaSourceVariable getSourceVariable() { this = TExplicitDef(_, _, _, result) }

  override VarDef getAContributingVarDef() { result = this.getDef() }

  override string prettyPrintRef() {
    exists(int l, int c | this.hasLocationInfo(_, l, c, _, _) | result = "def@" + l + ":" + c)
  }

  override string prettyPrintDef() { result = this.getDef().toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(Location loc |
      pragma[only_bind_into](loc) = pragma[only_bind_into](this.getDef()).getLocation() and
      loc.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }

  /**
   * Gets the data flow node representing the incoming value assigned at this definition,
   * if any.
   */
  DataFlow::Node getRhsNode() {
    result = DataFlow::ssaDefinitionNode(this).getImmediatePredecessor()
  }
}

/**
 * An SSA definition that does not correspond to an explicit variable definition.
 */
abstract class SsaImplicitDefinition extends SsaDefinition {
  /**
   * INTERNAL: Do not use.
   *
   * Gets the definition kind to include in `prettyPrintRef`.
   */
  abstract string getKind();

  override string prettyPrintRef() {
    exists(int l, int c | this.hasLocationInfo(_, l, c, _, _) |
      result = this.getKind() + "@" + l + ":" + c
    )
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    endline = startline and
    endcolumn = startcolumn and
    exists(Location loc |
      pragma[only_bind_into](loc) = pragma[only_bind_into](this.getBasicBlock()).getLocation() and
      loc.hasLocationInfo(filepath, startline, startcolumn, _, _)
    )
  }
}

/**
 * An SSA definition representing the implicit initialization of a variable
 * at the beginning of its scope.
 */
class SsaImplicitInit extends SsaImplicitDefinition, TImplicitInit {
  override predicate definesAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    bb = this.getBasicBlock() and v = this.getSourceVariable() and i = 0
  }

  override ReachableBasicBlock getBasicBlock() { this = TImplicitInit(result, _) }

  override SsaSourceVariable getSourceVariable() { this = TImplicitInit(_, result) }

  override string getKind() { result = "implicitInit" }

  override VarDef getAContributingVarDef() { none() }

  override string prettyPrintDef() {
    result = "implicit initialization of " + this.getSourceVariable()
  }
}

/**
 * An SSA definition representing the capturing of an SSA-convertible variable
 * in the closure of a nested function.
 *
 * Capturing definitions appear at the beginning of such functions, as well as
 * at any `yield` expressions or calls that may affect the value of the variable.
 */
class SsaVariableCapture extends SsaImplicitDefinition, TCapture {
  override predicate definesAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    this = TCapture(bb, i, v)
  }

  override ReachableBasicBlock getBasicBlock() { this.definesAt(result, _, _) }

  override SsaSourceVariable getSourceVariable() { this.definesAt(_, _, result) }

  override VarDef getAContributingVarDef() { result.getAVariable() = this.getSourceVariable() }

  override string getKind() { result = "capture" }

  override string prettyPrintDef() { result = "capture variable " + this.getSourceVariable() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(ReachableBasicBlock bb, int i | this.definesAt(bb, i, _) |
      bb.getNode(i)
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }
}

/**
 * An SSA definition that has no actual semantics, but simply serves to
 * merge or filter data flow.
 *
 * Phi nodes are the canonical example.
 */
abstract class SsaPseudoDefinition extends SsaImplicitDefinition {
  /**
   * Gets an input of this pseudo-definition.
   */
  cached
  abstract SsaVariable getAnInput();

  override VarDef getAContributingVarDef() {
    result = this.getAnInput().getDefinition().getAContributingVarDef()
  }

  /**
   * Gets a textual representation of the inputs of this pseudo-definition
   * in lexicographical order.
   */
  string ppInputs() { result = concat(this.getAnInput().getDefinition().prettyPrintRef(), ", ") }
}

/**
 * An SSA phi node, that is, a pseudo-definition for a variable at a point
 * in the flow graph where otherwise two or more definitions for the variable
 * would be visible.
 */
class SsaPhiNode extends SsaPseudoDefinition, TPhi {
  /**
   * Gets the input to this phi node coming from the given predecessor block.
   */
  cached
  SsaVariable getInputFromBlock(BasicBlock bb) {
    bb = this.getBasicBlock().getAPredecessor() and
    result = getDefReachingEndOf(bb, this.getSourceVariable())
  }

  override SsaVariable getAnInput() { result = this.getInputFromBlock(_) }

  override predicate definesAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    bb = this.getBasicBlock() and v = this.getSourceVariable() and i = -1
  }

  override ReachableBasicBlock getBasicBlock() { this = TPhi(result, _) }

  override SsaSourceVariable getSourceVariable() { this = TPhi(_, result) }

  override string getKind() { result = "phi" }

  override string prettyPrintDef() {
    result = this.getSourceVariable() + " = phi(" + this.ppInputs() + ")"
  }

  /**
   * If all inputs to this phi node are (transitive) refinements of the same variable,
   * gets that variable.
   */
  SsaVariable getRephinedVariable() {
    forex(SsaVariable input | input = this.getAnInput() | result = getRefinedVariable(input))
  }
}

/**
 * Gets the input to the given refinement node or rephinement node.
 */
private SsaVariable getRefinedVariable(SsaVariable v) {
  result = getRefinedVariable(v.(SsaRefinementNode).getAnInput())
  or
  result = getRefinedVariable(v.(SsaPhiNode).getRephinedVariable())
  or
  not v instanceof SsaRefinementNode and
  not v instanceof SsaPhiNode and
  result = v
}

/**
 * A refinement node, that is, a pseudo-definition for a variable at a point
 * in the flow graph where additional information about this variable becomes
 * available that may restrict its possible set of values.
 */
class SsaRefinementNode extends SsaPseudoDefinition, TRefinement {
  /**
   * Gets the guard that induces this refinement.
   */
  GuardControlFlowNode getGuard() { this = TRefinement(_, _, result, _) }

  /**
   * Gets the refinement associated with this definition.
   */
  Refinement getRefinement() { result = this.getGuard().getTest() }

  override SsaVariable getAnInput() {
    exists(SsaSourceVariable v, BasicBlock bb |
      v = this.getSourceVariable() and bb = this.getBasicBlock()
    |
      if exists(SsaPhiNode phi | phi.definesAt(bb, _, v))
      then result.(SsaPhiNode).definesAt(bb, _, v)
      else result = getDefReachingEndOf(bb.getAPredecessor(), v)
    )
  }

  override predicate definesAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    this = TRefinement(bb, i, _, v)
  }

  override ReachableBasicBlock getBasicBlock() { this = TRefinement(result, _, _, _) }

  override SsaSourceVariable getSourceVariable() { this = TRefinement(_, _, _, result) }

  override string getKind() { result = "refine[" + this.getGuard() + "]" }

  override string prettyPrintDef() {
    result =
      this.getSourceVariable() + " = refine[" + this.getGuard() + "](" + this.ppInputs() + ")"
  }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getGuard()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

module Ssa {
  /** Gets the SSA definition corresponding to the implicit initialization of `v`. */
  SsaImplicitInit implicitInit(SsaSourceVariable v) { result.getSourceVariable() = v }

  /** Gets the SSA definition corresponding to `d`. */
  SsaExplicitDefinition definition(VarDef d) { result.getDef() = d }

  /** Gets the SSA variable corresponding to `d`. */
  SsaVariable variable(VarDef d) { result.getDefinition() = definition(d) }
}
