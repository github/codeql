private import codeql.util.Boolean
private import codeql.util.Unit
private import codeql.ssa.Ssa as Ssa

signature module InputSig {
  class Location;

  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  class BasicBlock {
    /** Gets a textual representation of this basic block. */
    string toString();

    /** Gets the enclosing callable. */
    Callable getEnclosingCallable();
  }

  /**
   * Gets the basic block that immediately dominates basic block `bb`, if any.
   *
   * That is, all paths reaching `bb` from some entry point basic block must go
   * through the result.
   *
   * Example:
   *
   * ```csharp
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The basic block starting on line 2 is an immediate dominator of
   * the basic block on line 4 (all paths from the entry point of `M`
   * to `return s.Length;` must go through the null check.
   */
  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb);

  /** Gets an immediate successor of basic block `bb`, if any. */
  BasicBlock getABasicBlockSuccessor(BasicBlock bb);

  /** Holds if `bb` is a control-flow entry point. */
  default predicate entryBlock(BasicBlock bb) { not exists(getImmediateBasicBlockDominator(bb)) }

  /** Holds if `bb` is a control-flow exit point. */
  default predicate exitBlock(BasicBlock bb) { not exists(getABasicBlockSuccessor(bb)) }

  /** A variable that is captured in a nested closure. */
  class CapturedVariable {
    /** Gets a textual representation of this variable. */
    string toString();

    /** Gets the callable that defines this variable. */
    Callable getCallable();
  }

  /** A parameter that is captured in a nested closure. */
  class CapturedParameter extends CapturedVariable;

  /**
   * Holds if the `i`th node of basic block `bb` is a write to captured variable
   * `v`. This must include the initial assignment from the parameter in case
   * the captured variable is a parameter.
   */
  predicate variableWrite(BasicBlock bb, int i, CapturedVariable v, Location loc);

  /** Holds if the `i`th node of basic block `bb` reads captured variable `v`. */
  predicate variableRead(BasicBlock bb, int i, CapturedVariable v, Location loc);

  class Callable {
    /** Gets a textual representation of this callable. */
    string toString();

    /** Gets the location of this callable. */
    Location getLocation();
  }

  class Call {
    /** Gets a textual representation of this call. */
    string toString();

    /** Gets the location of this call. */
    Location getLocation();

    /** Gets the enclosing callable. */
    Callable getEnclosingCallable();

    /**
     * Holds if the `i`th node of basic block `bb` makes this call. Does not
     * hold if the call occurs in a CFG-less callable.
     */
    predicate hasCfgNode(BasicBlock bb, int i);
  }

  /**
   * Gets a potential virtual dispatch call target. This may overapproximate the
   * final call graph.
   *
   * If this is empty, it is assumed that all calls might reach a callable that
   * accesses a captured variable, so slightly more `ClosureNode`s will be
   * generated.
   */
  default Callable getACallTarget(Call call) { none() }
}

signature module OutputSig<InputSig I> {
  /**
   * A synthesized data flow node representing a closure object that tracks
   * captured variables.
   */
  class ClosureNode {
    /** Gets a textual representation of this node. */
    string toString();

    /** Gets the location of this node. */
    I::Location getLocation();

    /** Gets the enclosing callable. */
    I::Callable getEnclosingCallable();

    /** Holds if this node is a parameter node. */
    predicate isParameter(I::Callable callable);

    /** Holds if this node is an argument node. */
    predicate isArgument(I::Call call);
  }

  /** Holds if `post` is a `PostUpdateNode` for `pre`. */
  predicate closurePostUpdateNode(ClosureNode post, ClosureNode pre);

  /** Holds if there is a local flow step from `node1` to `node2`. */
  predicate localFlowStep(ClosureNode node1, ClosureNode node2);

  /**
   * Holds if there is a store step from the `variableWrite(bb, i, v, _)` with
   * content `v` to `node`.
   */
  predicate storeStep(I::BasicBlock bb, int i, I::CapturedVariable v, ClosureNode node);

  /**
   * Holds if there is a read step from `node` to the `variableRead(bb, i, v, _)`
   * with content `v`.
   */
  predicate readStep(ClosureNode node, I::BasicBlock bb, int i, I::CapturedVariable v);

  /**
   * Holds if there is a store step from the `ParameterNode` for `p` with
   * content `p` to `node`.
   */
  predicate parameterStoreStep(I::CapturedParameter p, ClosureNode node);

  /**
   * Holds if there is a read step from `node` to the post-update of the
   * `ParameterNode` for `p` with content `p`.
   */
  predicate parameterReadStep(ClosureNode node, I::CapturedParameter p);
}

module Flow<InputSig Input> implements OutputSig<Input> {
  private import Input

  private predicate callEdge(Callable c1, Callable c2) {
    exists(Call call | c1 = call.getEnclosingCallable() and c2 = getACallTarget(call))
  }

  private predicate noCallGraph() { not exists(Call call, Callable c | c = getACallTarget(call)) }

  private predicate readOrWrite(BasicBlock bb, int i) {
    variableRead(bb, i, _, _) or variableWrite(bb, i, _, _)
  }

  private predicate readsOrWritesCapturedVar(Callable c) {
    exists(BasicBlock bb | readOrWrite(bb, _) and c = bb.getEnclosingCallable())
    or
    // Captured parameters have implicit reads and writes to connect the
    // parameter value to the captured value stored on the heap.
    exists(CapturedParameter p | p.getCallable() = c)
  }

  /**
   * Holds if `c` either reads or writes a captured variable, or may
   * transitively call another callable that reads or writes a captured
   * variable.
   */
  private predicate capturedVarsAreLive(Callable c) {
    readsOrWritesCapturedVar(c)
    or
    exists(Callable mid | capturedVarsAreLive(mid) and callEdge(c, mid))
    or
    exists(Call call |
      noCallGraph() and
      call.getEnclosingCallable() = c
    )
  }

  private predicate liveEntryBlock(BasicBlock bb) {
    capturedVarsAreLive(bb.getEnclosingCallable()) and
    entryBlock(bb)
  }

  /*
   * We introduce a variable `heap` and treat all captured variables as fields
   * on it. We then thread `heap` through the call graph so it is available
   * everywhere we need to access a captured variable.
   * We need parameter definitions `THeapVarParam` and argument accesses
   * `THeapVarArg` to thread it through the call graph, and we need qualifier
   * accesses `THeapVarCaptureQualifier` for each access to a captured variable.
   * We also need post-update nodes for all of the accesses to handle
   * side-effects.
   */

  /**
   * Holds if `call` should get a `heap` argument. This holds if `call` might
   * target a callee that needs access to the `heap` state.
   */
  private predicate hasHeapArg(Call call) {
    capturedVarsAreLive(call.getEnclosingCallable()) and capturedVarsAreLive(getACallTarget(call))
    or
    noCallGraph()
  }

  /**
   * Holds if `heap` is read in the `i`th node of `bb` as either the qualifier
   * of an access to a captured variable or as an argument to a call that needs
   * the `heap` state.
   */
  private predicate heapRead(BasicBlock bb, int i) {
    readOrWrite(bb, i)
    or
    exists(Call call | hasHeapArg(call) and call.hasCfgNode(bb, i))
  }

  /**
   * Holds if the initial store of a captured parameter into the `heap` should
   * occur in the `i`th node of `bb`.
   */
  private predicate parameterHeapStore(BasicBlock bb, int i, CapturedParameter p) {
    entryBlock(bb) and
    bb.getEnclosingCallable() = p.getCallable() and
    i = -1 + min(int j | j = 2 or heapRead(bb, j))
  }

  /**
   * Holds if a final read of the value of a captured parameter as it exists in
   * the `heap` should occur in the `i`th node of `bb` in order to update the
   * parameter, such that side-effects on the parameter are visible to the
   * caller.
   */
  private predicate parameterHeapRead(BasicBlock bb, int i, CapturedParameter p) {
    exitBlock(bb) and
    bb.getEnclosingCallable() = p.getCallable() and
    i = 1 + max(int j | j = 0 or heapRead(bb, j))
  }

  private predicate hasHeapQualifier(BasicBlock bb, int i) {
    readOrWrite(bb, i) or parameterHeapStore(bb, i, _) or parameterHeapRead(bb, i, _)
  }

  /**
   * Holds if the `i`th node of `bb` occurs before any read or write of a
   * captured variable, and that captured captured variables are live in the
   * callable containing `bb`.
   * This will be used as the position for the definition of the heap parameter.
   */
  private predicate entryDef(BasicBlock bb, int i) {
    liveEntryBlock(bb) and
    i = -1 + min(int j | j = 1 or hasHeapQualifier(bb, j))
  }

  private module HeapVariableSsaInput implements Ssa::InputSig {
    class BasicBlock instanceof Input::BasicBlock {
      string toString() { result = super.toString() }
    }

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = Input::getImmediateBasicBlockDominator(bb)
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) {
      result = Input::getABasicBlockSuccessor(bb)
    }

    class ExitBasicBlock extends BasicBlock {
      ExitBasicBlock() { not exists(getABasicBlockSuccessor(this)) }
    }

    // We need one heap variable per callable.
    class SourceVariable = Callable;

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      entryDef(bb, i) and v = bb.(Input::BasicBlock).getEnclosingCallable() and certain = true
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      (
        hasHeapQualifier(bb, i)
        or
        exists(Call call |
          hasHeapArg(call) and
          call.hasCfgNode(bb, i)
        )
      ) and
      v = bb.(Input::BasicBlock).getEnclosingCallable() and
      certain = true
    }
  }

  private module HeapVariableSsa = Ssa::Make<HeapVariableSsaInput>;

  private newtype TClosureNode =
    THeapVarParam(Callable c) { capturedVarsAreLive(c) } or
    THeapVarArg(Call call, Boolean isPost) { hasHeapArg(call) } or
    THeapVarCaptureQualifier(BasicBlock bb, int i, Boolean isPost) { hasHeapQualifier(bb, i) } or
    THeapVarPhi(HeapVariableSsa::PhiReadNode phi)

  class ClosureNode extends TClosureNode {
    string toString() {
      result = "parameter heap" and this = THeapVarParam(_)
      or
      result = "heap argument" and this = THeapVarArg(_, false)
      or
      result = "heap argument [post update]" and this = THeapVarArg(_, true)
      or
      result = "heap" and this = THeapVarCaptureQualifier(_, _, false)
      or
      result = "heap [post update]" and this = THeapVarCaptureQualifier(_, _, true)
      or
      result = "heap phi" and this = THeapVarPhi(_)
    }

    Location getLocation() {
      exists(Callable c | this = THeapVarParam(c) and result = c.getLocation())
      or
      exists(Call call | this = THeapVarArg(call, _) and result = call.getLocation())
      or
      exists(BasicBlock bb, int i | this = THeapVarCaptureQualifier(bb, i, _) |
        variableRead(bb, i, _, result)
        or
        variableWrite(bb, i, _, result)
        or
        not readOrWrite(bb, i) and result = bb.getEnclosingCallable().getLocation()
      )
    }

    Callable getEnclosingCallable() {
      this = THeapVarParam(result)
      or
      exists(Call call | this = THeapVarArg(call, _) and result = call.getEnclosingCallable())
      or
      exists(BasicBlock bb |
        this = THeapVarCaptureQualifier(bb, _, _) and result = bb.getEnclosingCallable()
      )
      or
      exists(HeapVariableSsa::PhiReadNode phi |
        this = THeapVarPhi(phi) and result = phi.getBasicBlock().(BasicBlock).getEnclosingCallable()
      )
    }

    predicate isParameter(Callable c) { this = THeapVarParam(c) }

    predicate isArgument(Call call) { this = THeapVarArg(call, false) }
  }

  predicate closurePostUpdateNode(ClosureNode post, ClosureNode pre) {
    exists(Call call | pre = THeapVarArg(call, false) and post = THeapVarArg(call, true))
    or
    exists(BasicBlock bb, int i |
      pre = THeapVarCaptureQualifier(bb, i, false) and post = THeapVarCaptureQualifier(bb, i, true)
    )
  }

  private predicate step(BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
    HeapVariableSsa::adjacentDefReadExt(_, _, bb1, i1, bb2, i2)
    or
    exists(HeapVariableSsa::DefinitionExt next |
      HeapVariableSsa::lastRefRedefExt(_, _, bb1, i1, next) and
      next.definesAt(_, bb2, i2, _)
    )
  }

  private predicate closureNodeAt(ClosureNode n, boolean isPost, BasicBlock bb, int i) {
    exists(Callable c |
      n = THeapVarParam(c) and
      entryDef(bb, i) and
      bb.getEnclosingCallable() = c and
      isPost = false
    )
    or
    exists(Call call | n = THeapVarArg(call, isPost) and call.hasCfgNode(bb, i))
    or
    n = THeapVarCaptureQualifier(bb, i, isPost)
    or
    exists(HeapVariableSsa::PhiReadNode phi |
      n = THeapVarPhi(phi) and phi.definesAt(_, bb, i, _) and isPost = false
    )
  }

  predicate localFlowStep(ClosureNode node1, ClosureNode node2) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      step(bb1, i1, bb2, i2) and
      closureNodeAt(node1, _, bb1, i1) and
      closureNodeAt(node2, false, bb2, i2)
    )
    or
    exists(Callable c, Call call |
      // For a CFG-less callable (e.g. a MaD callable), we add an edge from the
      // parameter to each use.
      node1 = THeapVarParam(c) and
      not closureNodeAt(node1, _, _, _) and
      node2 = THeapVarArg(call, false) and
      call.getEnclosingCallable() = c
    )
  }

  predicate storeStep(BasicBlock bb, int i, CapturedVariable v, ClosureNode node) {
    variableWrite(bb, i, v, _) and node = THeapVarCaptureQualifier(bb, i, true)
  }

  predicate readStep(ClosureNode node, BasicBlock bb, int i, CapturedVariable v) {
    variableRead(bb, i, v, _) and node = THeapVarCaptureQualifier(bb, i, false)
  }

  predicate parameterStoreStep(CapturedParameter p, ClosureNode node) {
    exists(BasicBlock bb, int i |
      parameterHeapStore(bb, i, p) and
      node = THeapVarCaptureQualifier(bb, i, true)
    )
  }

  predicate parameterReadStep(ClosureNode node, CapturedParameter p) {
    exists(BasicBlock bb, int i |
      parameterHeapRead(bb, i, p) and
      node = THeapVarCaptureQualifier(bb, i, false)
    )
  }
}
