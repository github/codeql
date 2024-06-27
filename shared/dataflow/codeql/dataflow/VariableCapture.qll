/**
 * Provides a module for synthesizing data-flow nodes and related step relations
 * for supporting flow through captured variables.
 */

private import codeql.util.Boolean
private import codeql.util.Unit
private import codeql.util.Location
private import codeql.ssa.Ssa as Ssa

signature module InputSig<LocationSig Location> {
  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  class BasicBlock {
    /** Gets a textual representation of this basic block. */
    string toString();

    /** Gets the enclosing callable. */
    Callable getEnclosingCallable();

    /** Gets the location of this basic block. */
    Location getLocation();
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

  /** A variable that is captured in a closure. */
  class CapturedVariable {
    /** Gets a textual representation of this variable. */
    string toString();

    /** Gets the callable that defines this variable. */
    Callable getCallable();

    /** Gets the location of this variable. */
    Location getLocation();
  }

  /** A parameter that is captured in a closure. */
  class CapturedParameter extends CapturedVariable;

  /**
   * An expression with a value. That is, we expect these expressions to be
   * represented in the data flow graph.
   */
  class Expr {
    /** Gets a textual representation of this expression. */
    string toString();

    /** Gets the location of this expression. */
    Location getLocation();

    /** Holds if the `i`th node of basic block `bb` evaluates this expression. */
    predicate hasCfgNode(BasicBlock bb, int i);
  }

  /** A write to a captured variable. */
  class VariableWrite {
    /** Gets the variable that is the target of this write. */
    CapturedVariable getVariable();

    /** Gets the location of this write. */
    Location getLocation();

    /** Holds if the `i`th node of basic block `bb` evaluates this expression. */
    predicate hasCfgNode(BasicBlock bb, int i);
  }

  /** A read of a captured variable. */
  class VariableRead extends Expr {
    /** Gets the variable that this expression reads. */
    CapturedVariable getVariable();
  }

  /**
   * An expression constructing a closure that may capture one or more
   * variables. This can for example be a lambda or a constructor call of a
   * locally defined object.
   */
  class ClosureExpr extends Expr {
    /**
     * Holds if `body` is the callable body of this closure. A lambda expression
     * only has one body, but in general a locally defined object may have
     * multiple such methods and constructors.
     */
    predicate hasBody(Callable body);

    /**
     * Holds if `f` is an expression that may hold the value of the closure and
     * may occur in a position where the value escapes or where the closure may
     * be invoked.
     *
     * For example, if a lambda is assigned to a variable, then references to
     * that variable in return or argument positions should be included.
     */
    predicate hasAliasedAccess(Expr f);
  }

  class Callable {
    /** Gets a textual representation of this callable. */
    string toString();

    /** Gets the location of this callable. */
    Location getLocation();

    /** Holds if this callable is a constructor. */
    predicate isConstructor();
  }
}

signature module OutputSig<LocationSig Location, InputSig<Location> I> {
  /**
   * A data flow node that we need to reference in the step relations for
   * captured variables.
   *
   * Note that only the `SynthesizedCaptureNode` subclass is expected to be
   * added as additional nodes in `DataFlow::Node`. The other subclasses are
   * expected to already be present and are included here in order to reference
   * them in the step relations.
   */
  class ClosureNode;

  /**
   * A synthesized data flow node representing the storage of a captured
   * variable.
   */
  class SynthesizedCaptureNode extends ClosureNode {
    /** Gets a textual representation of this node. */
    string toString();

    /** Gets the location of this node. */
    Location getLocation();

    /** Gets the enclosing callable. */
    I::Callable getEnclosingCallable();

    /** Holds if this node is a synthesized access of `v`. */
    predicate isVariableAccess(I::CapturedVariable v);

    /** Holds if this node is a synthesized instance access. */
    predicate isInstanceAccess();
  }

  /** A data flow node for an expression. */
  class ExprNode extends ClosureNode {
    /** Gets the expression corresponding to this node. */
    I::Expr getExpr();
  }

  /** A data flow node for the `PostUpdateNode` of an expression. */
  class ExprPostUpdateNode extends ClosureNode {
    /** Gets the expression corresponding to this node. */
    I::Expr getExpr();
  }

  /** A data flow node for a parameter. */
  class ParameterNode extends ClosureNode {
    /** Gets the parameter corresponding to this node. */
    I::CapturedParameter getParameter();
  }

  /** A data flow node for an instance parameter. */
  class ThisParameterNode extends ClosureNode {
    /** Gets the callable this instance parameter belongs to. */
    I::Callable getCallable();
  }

  /** A data flow node for the instance parameter argument of a constructor call. */
  class MallocNode extends ClosureNode {
    /** Gets the closure construction that is the post-update of this node. */
    I::ClosureExpr getClosureExpr();
  }

  /**
   * A node representing the incoming value about to be written at the given assignment.
   *
   * The captured-variable library will generate flows out of this node, and assume that other
   * parts of the language implementation produce the relevant data flows into this node.
   *
   * For ordinary assignments, this could be mapped to the right-hand side of the assignment.
   *
   * For more general cases, where an lvalue has no direct corresponding rvalue, this can be mapped
   * to a data-flow node that wraps the lvalue, with language-specific incoming data flows.
   */
  class VariableWriteSourceNode extends ClosureNode {
    /** Gets the variable write for which this node is the incoming value being written to the variable. */
    I::VariableWrite getVariableWrite();
  }

  /** Holds if `post` is a `PostUpdateNode` for `pre`. */
  predicate capturePostUpdateNode(SynthesizedCaptureNode post, SynthesizedCaptureNode pre);

  /** Holds if there is a local flow step from `node1` to `node2`. */
  predicate localFlowStep(ClosureNode node1, ClosureNode node2);

  /** Holds if there is a store step from `node1` to `node2`. */
  predicate storeStep(ClosureNode node1, I::CapturedVariable v, ClosureNode node2);

  /** Holds if there is a read step from `node1` to `node2`. */
  predicate readStep(ClosureNode node1, I::CapturedVariable v, ClosureNode node2);

  /** Holds if this-to-this summaries are expected for `c`. */
  predicate heuristicAllowInstanceParameterReturnInSelf(I::Callable c);

  /** Holds if captured variable `v` is cleared at `node`. */
  predicate clearsContent(ClosureNode node, I::CapturedVariable v);
}

/**
 * Constructs the type `ClosureNode` and associated step relations, which are
 * intended to be included in the data-flow node and step relations.
 */
module Flow<LocationSig Location, InputSig<Location> Input> implements OutputSig<Location, Input> {
  private import Input

  additional module ConsistencyChecks {
    final private class FinalExpr = Expr;

    private class RelevantExpr extends FinalExpr {
      RelevantExpr() {
        this instanceof VariableRead or
        this instanceof ClosureExpr or
        any(ClosureExpr ce).hasAliasedAccess(this)
      }
    }

    final private class FinalBasicBlock = BasicBlock;

    private class RelevantBasicBlock extends FinalBasicBlock {
      RelevantBasicBlock() {
        exists(RelevantExpr e | e.hasCfgNode(this, _))
        or
        exists(VariableWrite vw | vw.hasCfgNode(this, _))
      }
    }

    final private class FinalCallable = Callable;

    private class RelevantCallable extends FinalCallable {
      RelevantCallable() {
        exists(RelevantBasicBlock bb | bb.getEnclosingCallable() = this)
        or
        exists(CapturedVariable v | v.getCallable() = this)
        or
        exists(ClosureExpr ce | ce.hasBody(this))
      }
    }

    query predicate uniqueToString(string msg, int n) {
      exists(string elem |
        n = strictcount(RelevantBasicBlock bb | not exists(bb.toString())) and
        elem = "BasicBlock"
        or
        n = strictcount(CapturedVariable v | not exists(v.toString())) and elem = "CapturedVariable"
        or
        n = strictcount(RelevantExpr e | not exists(e.toString())) and elem = "Expr"
        or
        n = strictcount(RelevantCallable c | not exists(c.toString())) and
        elem = "Callable"
      |
        msg = n + " " + elem + "(s) are missing toString"
      )
      or
      exists(string elem |
        n = strictcount(RelevantBasicBlock bb | 2 <= strictcount(bb.toString())) and
        elem = "BasicBlock"
        or
        n = strictcount(CapturedVariable v | 2 <= strictcount(v.toString())) and
        elem = "CapturedVariable"
        or
        n = strictcount(RelevantExpr e | 2 <= strictcount(e.toString())) and
        elem = "Expr"
        or
        n = strictcount(RelevantCallable c | 2 <= strictcount(c.toString())) and
        elem = "Callable"
      |
        msg = n + " " + elem + "(s) have multiple toStrings"
      )
    }

    query predicate uniqueEnclosingCallable(RelevantBasicBlock bb, string msg) {
      msg = "BasicBlock has no enclosing callable" and not exists(bb.getEnclosingCallable())
      or
      msg = "BasicBlock has multiple enclosing callables" and
      2 <= strictcount(bb.getEnclosingCallable())
    }

    query predicate uniqueDominator(RelevantBasicBlock bb, string msg) {
      msg = "BasicBlock has multiple immediate dominators" and
      2 <= strictcount(getImmediateBasicBlockDominator(bb))
    }

    query predicate localDominator(RelevantBasicBlock bb, string msg) {
      msg = "BasicBlock has non-local dominator" and
      bb.getEnclosingCallable() != getImmediateBasicBlockDominator(bb).getEnclosingCallable()
    }

    query predicate localSuccessor(RelevantBasicBlock bb, string msg) {
      msg = "BasicBlock has non-local successor" and
      bb.getEnclosingCallable() != getABasicBlockSuccessor(bb).getEnclosingCallable()
    }

    query predicate uniqueDefiningScope(CapturedVariable v, string msg) {
      msg = "CapturedVariable has no defining callable" and not exists(v.getCallable())
      or
      msg = "CapturedVariable has multiple defining callables" and 2 <= strictcount(v.getCallable())
    }

    query predicate variableIsCaptured(CapturedVariable v, string msg) {
      msg = "CapturedVariable is not captured" and
      not captureAccess(v, _)
    }

    query predicate uniqueLocation(RelevantExpr e, string msg) {
      msg = "Expr has no location" and not exists(e.getLocation())
      or
      msg = "Expr has multiple locations" and 2 <= strictcount(e.getLocation())
    }

    query predicate uniqueCfgNode(RelevantExpr e, string msg) {
      msg = "Expr has no cfg node" and not e.hasCfgNode(_, _)
      or
      msg = "Expr has multiple cfg nodes" and
      2 <= strictcount(BasicBlock bb, int i | e.hasCfgNode(bb, i))
    }

    private predicate uniqueWriteTarget(VariableWrite vw, string msg) {
      msg = "VariableWrite has no target variable" and not exists(vw.getVariable())
      or
      msg = "VariableWrite has multiple target variables" and 2 <= strictcount(vw.getVariable())
    }

    query predicate uniqueWriteTarget(string msg) { uniqueWriteTarget(_, msg) }

    private predicate uniqueWriteCfgNode(VariableWrite vw, string msg) {
      msg = "VariableWrite has no cfg node" and not vw.hasCfgNode(_, _)
      or
      msg = "VariableWrite has multiple cfg nodes" and
      2 <= strictcount(BasicBlock bb, int i | vw.hasCfgNode(bb, i))
    }

    query predicate uniqueWriteCfgNode(string msg) { uniqueWriteCfgNode(_, msg) }

    query predicate uniqueReadVariable(VariableRead vr, string msg) {
      msg = "VariableRead has no source variable" and not exists(vr.getVariable())
      or
      msg = "VariableRead has multiple source variables" and 2 <= strictcount(vr.getVariable())
    }

    query predicate closureMustHaveBody(ClosureExpr ce, string msg) {
      msg = "ClosureExpr has no body" and not ce.hasBody(_)
    }

    query predicate closureAliasMustBeInSameScope(ClosureExpr ce, Expr access, string msg) {
      exists(BasicBlock bb1, BasicBlock bb2 |
        ce.hasAliasedAccess(access) and
        ce.hasCfgNode(bb1, _) and
        access.hasCfgNode(bb2, _) and
        not bb1.getEnclosingCallable() = callableGetEnclosingCallable*(bb2.getEnclosingCallable()) and
        msg =
          "ClosureExpr has an alias outside the scope of its enclosing callable - these are ignored"
      )
    }

    private predicate astClosureParent(Callable closure, Callable parent) {
      exists(ClosureExpr ce, BasicBlock bb |
        ce.hasBody(closure) and ce.hasCfgNode(bb, _) and parent = bb.getEnclosingCallable()
      )
    }

    query predicate variableAccessAstNesting(CapturedVariable v, Callable c, string msg) {
      exists(BasicBlock bb, Callable parent |
        captureRead(v, bb, _, false, _) or captureWrite(v, bb, _, false, _)
      |
        bb.getEnclosingCallable() = c and
        v.getCallable() = parent and
        not astClosureParent+(c, parent) and
        msg = "CapturedVariable access is not nested in the defining callable"
      )
    }

    query predicate uniqueCallableLocation(RelevantCallable c, string msg) {
      msg = "Callable has no location" and not exists(c.getLocation())
      or
      msg = "Callable has multiple locations" and 2 <= strictcount(c.getLocation())
    }

    query predicate consistencyOverview(string msg, int n) {
      uniqueToString(msg, n) or
      n = strictcount(BasicBlock bb | uniqueEnclosingCallable(bb, msg)) or
      n = strictcount(BasicBlock bb | uniqueDominator(bb, msg)) or
      n = strictcount(BasicBlock bb | localDominator(bb, msg)) or
      n = strictcount(BasicBlock bb | localSuccessor(bb, msg)) or
      n = strictcount(CapturedVariable v | uniqueDefiningScope(v, msg)) or
      n = strictcount(CapturedVariable v | variableIsCaptured(v, msg)) or
      n = strictcount(Expr e | uniqueLocation(e, msg)) or
      n = strictcount(Expr e | uniqueCfgNode(e, msg)) or
      n = strictcount(VariableWrite vw | uniqueWriteTarget(vw, msg)) or
      n = strictcount(VariableWrite vw | uniqueWriteCfgNode(vw, msg)) or
      n = strictcount(VariableRead vr | uniqueReadVariable(vr, msg)) or
      n = strictcount(ClosureExpr ce | closureMustHaveBody(ce, msg)) or
      n = strictcount(ClosureExpr ce, Expr access | closureAliasMustBeInSameScope(ce, access, msg)) or
      n = strictcount(CapturedVariable v, Callable c | variableAccessAstNesting(v, c, msg)) or
      n = strictcount(Callable c | uniqueCallableLocation(c, msg))
    }
  }

  /*
   * Flow through captured variables is handled by making each captured variable
   * a field on the closures that capture them.
   *
   * For each closure creation we add a store step from the captured variable to
   * the closure, and inside the closures we access the captured variables with
   * a `this.` qualifier. This allows capture flow into closures.
   *
   * It also means that we get several aliased versions of a captured variable
   * so proper care must be taken to be able to observe side-effects or flow out
   * of closures. E.g. if two closures `l1` and `l2` capture `x` then we'll have
   * three names, `x`, `l1.x`, and `l2.x`, plus any potential aliasing of the
   * closures.
   *
   * To handle this, we select a primary name for a captured variable in each of
   * its scopes, keep that name updated, and update the other names from the
   * primary name.
   *
   * In the defining scope of a captured variable, we use the local variable
   * itself as the primary storage location, and in the capturing scopes we use
   * the synthesized field. For each relevant reference to a closure object we
   * then update its field from the primary storage location, and we read the
   * field back from the post-update of the closure object reference and back
   * into the primary storage location.
   *
   * If we include references to a closure object that may lead to a call as
   * relevant, then this means that we'll be able to observe the side-effects of
   * such calls in the primary storage location.
   *
   * Details:
   * For a reference to a closure `f` that captures `x` we synthesize a read of
   * `x` at the same control-flow node. We then add a store step from `x` to `f`
   * and a read step from `postupdate(f)` to `postupdate(x)`.
   * ```
   * SsaRead(x) --store[x]--> f
   * postupdate(f) --read[x]--> postupdate(SsaRead(x))
   * ```
   * In a closure scope with a nested closure `g` that also captures `x` the
   * steps instead look like this:
   * ```
   * SsaRead(this) --read[x]--> this.x --store[x]--> g
   * postupdate(g) --read[x]--> postupdate(this.x)
   * ```
   * The final store from `postupdate(this.x)` to `postupdate(this)` is
   * introduced automatically as a reverse read by the data flow library.
   */

  /**
   * Holds if `vr` is a read of `v` in the `i`th node of `bb`.
   * `topScope` is true if the read is in the defining callable of `v`.
   */
  private predicate captureRead(
    CapturedVariable v, BasicBlock bb, int i, boolean topScope, VariableRead vr
  ) {
    vr.getVariable() = v and
    vr.hasCfgNode(bb, i) and
    if v.getCallable() != bb.getEnclosingCallable() then topScope = false else topScope = true
  }

  /**
   * Holds if `vw` is a write of `v` in the `i`th node of `bb`.
   * `topScope` is true if the write is in the defining callable of `v`.
   */
  private predicate captureWrite(
    CapturedVariable v, BasicBlock bb, int i, boolean topScope, VariableWrite vw
  ) {
    vw.getVariable() = v and
    vw.hasCfgNode(bb, i) and
    if v.getCallable() != bb.getEnclosingCallable() then topScope = false else topScope = true
  }

  /** Gets the enclosing callable of `ce`. */
  private Callable closureExprGetEnclosingCallable(ClosureExpr ce) {
    exists(BasicBlock bb | ce.hasCfgNode(bb, _) and result = bb.getEnclosingCallable())
  }

  /** Gets the enclosing callable of `inner`. */
  pragma[nomagic]
  private Callable callableGetEnclosingCallable(Callable inner) {
    exists(ClosureExpr closure |
      closure.hasBody(inner) and
      result = closureExprGetEnclosingCallable(closure)
    )
  }

  /**
   * Gets a callable that contains `ce`, or a reference to `ce` into which `ce` could be inlined without
   * bringing any variables out of scope.
   *
   * If `ce` was to be inlined into that reference, the resulting callable
   * would become the enclosing callable, and thus capture the same variables as `ce`.
   * In some sense, we model captured aliases as if this inlining has happened.
   */
  private Callable closureExprGetAReferencingCallable(ClosureExpr ce) {
    result = closureExprGetEnclosingCallable(ce)
    or
    exists(Expr expr, BasicBlock bb |
      ce.hasAliasedAccess(expr) and
      expr.hasCfgNode(bb, _) and
      result = bb.getEnclosingCallable() and
      // The reference to `ce` is allowed to occur in a more deeply nested context
      closureExprGetEnclosingCallable(ce) = callableGetEnclosingCallable*(result)
    )
  }

  /**
   * Holds if `v` is available in `c` through capture. This can either be due to
   * an explicit variable reference or through the construction of a closure
   * that has a nested capture.
   */
  private predicate captureAccess(CapturedVariable v, Callable c) {
    exists(BasicBlock bb | captureRead(v, bb, _, _, _) or captureWrite(v, bb, _, _, _) |
      c = bb.getEnclosingCallable() and
      c != v.getCallable()
    )
    or
    exists(ClosureExpr ce |
      c = closureExprGetAReferencingCallable(ce) and
      closureCaptures(ce, v) and
      c != v.getCallable()
    )
  }

  /** Holds if the closure defined by `ce` captures `v`. */
  private predicate closureCaptures(ClosureExpr ce, CapturedVariable v) {
    exists(Callable c | ce.hasBody(c) and captureAccess(v, c))
  }

  predicate heuristicAllowInstanceParameterReturnInSelf(Callable c) {
    // If multiple variables are captured, then we should allow flow from one to
    // another, which entails a this-to-this summary.
    2 <= strictcount(CapturedVariable v | captureAccess(v, c))
    or
    // Constructors that capture a variable may assign it to a field, which also
    // entails a this-to-this summary.
    captureAccess(_, c) and c.isConstructor()
  }

  /** Holds if the constructor, if any, for the closure defined by `ce` captures `v`. */
  private predicate hasConstructorCapture(ClosureExpr ce, CapturedVariable v) {
    exists(Callable c | ce.hasBody(c) and c.isConstructor() and captureAccess(v, c))
  }

  /**
   * Holds if `access` is a reference to `ce` evaluated in the `i`th node of `bb`.
   * The reference is restricted to be nested within the same callable as `ce` as a
   * precaution, even though this is expected to hold for all the given aliased
   * accesses.
   */
  private predicate localOrNestedClosureAccess(ClosureExpr ce, Expr access, BasicBlock bb, int i) {
    ce.hasAliasedAccess(access) and
    access.hasCfgNode(bb, i) and
    pragma[only_bind_out](bb.getEnclosingCallable()) =
      pragma[only_bind_out](closureExprGetAReferencingCallable(ce))
  }

  /**
   * Holds if we need an additional read of `v` in the `i`th node of `bb` in
   * order to synchronize the value stored on `closure`.
   * `topScope` is true if the read is in the defining callable of `v`.
   *
   * Side-effects of potentially calling `closure` at this point will be
   * observed in a similarly synthesized post-update node for this read of `v`.
   */
  private predicate synthRead(
    CapturedVariable v, BasicBlock bb, int i, boolean topScope, Expr closure, boolean alias
  ) {
    exists(ClosureExpr ce | closureCaptures(ce, v) |
      ce.hasCfgNode(bb, i) and ce = closure and alias = false
      or
      localOrNestedClosureAccess(ce, closure, bb, i) and alias = true
    ) and
    if v.getCallable() != bb.getEnclosingCallable() then topScope = false else topScope = true
  }

  private predicate synthRead(
    CapturedVariable v, BasicBlock bb, int i, boolean topScope, Expr closure
  ) {
    synthRead(v, bb, i, topScope, closure, _)
  }

  /**
   * Holds if there is an access of a captured variable inside a closure in the
   * `i`th node of `bb`, such that we need to synthesize a `this.` qualifier.
   */
  private predicate synthThisQualifier(BasicBlock bb, int i) {
    synthRead(_, bb, i, false, _) or
    captureRead(_, bb, i, false, _) or
    captureWrite(_, bb, i, false, _)
  }

  private newtype TCaptureContainer =
    TVariable(CapturedVariable v) or
    TThis(Callable c) { captureAccess(_, c) }

  /**
   * A storage location for a captured variable in a specific callable. This is
   * either the variable itself (in its defining scope) or an instance variable
   * `this` (in a capturing scope).
   */
  private class CaptureContainer extends TCaptureContainer {
    string toString() {
      exists(CapturedVariable v | this = TVariable(v) and result = v.toString())
      or
      result = "this" and this = TThis(_)
    }

    Location getLocation() {
      exists(CapturedVariable v | this = TVariable(v) and result = v.getLocation())
      or
      exists(Callable c | this = TThis(c) and result = c.getLocation())
    }
  }

  /** Holds if `cc` needs a definition at the entry of its callable scope. */
  private predicate entryDef(CaptureContainer cc, BasicBlock bb, int i) {
    exists(Callable c |
      entryBlock(bb) and
      pragma[only_bind_out](bb.getEnclosingCallable()) = c and
      i =
        min(int j |
            j = 1 or
            captureRead(_, bb, j, _, _) or
            captureWrite(_, bb, j, _, _) or
            synthRead(_, bb, j, _, _)
          ) - 1
    |
      cc = TThis(c)
      or
      exists(CapturedParameter p | cc = TVariable(p) and p.getCallable() = c)
    )
  }

  private module CaptureSsaInput implements Ssa::InputSig<Location> {
    final class BasicBlock = Input::BasicBlock;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = Input::getImmediateBasicBlockDominator(bb)
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) {
      result = Input::getABasicBlockSuccessor(bb)
    }

    class ExitBasicBlock extends BasicBlock {
      ExitBasicBlock() { exitBlock(this) }
    }

    class SourceVariable = CaptureContainer;

    predicate variableWrite(BasicBlock bb, int i, SourceVariable cc, boolean certain) {
      (
        exists(CapturedVariable v | cc = TVariable(v) and captureWrite(v, bb, i, true, _))
        or
        entryDef(cc, bb, i)
      ) and
      certain = true
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable cc, boolean certain) {
      (
        synthThisQualifier(bb, i) and cc = TThis(bb.getEnclosingCallable())
        or
        exists(CapturedVariable v | cc = TVariable(v) |
          captureRead(v, bb, i, true, _) or synthRead(v, bb, i, true, _)
        )
      ) and
      certain = true
    }
  }

  private module CaptureSsa = Ssa::Make<Location, CaptureSsaInput>;

  private newtype TClosureNode =
    TSynthRead(CapturedVariable v, BasicBlock bb, int i, Boolean isPost) {
      synthRead(v, bb, i, _, _)
    } or
    TSynthThisQualifier(BasicBlock bb, int i, Boolean isPost) { synthThisQualifier(bb, i) } or
    TSynthPhi(CaptureSsa::DefinitionExt phi) {
      phi instanceof CaptureSsa::PhiNode or phi instanceof CaptureSsa::PhiReadNode
    } or
    TExprNode(Expr expr, boolean isPost) {
      expr instanceof VariableRead and isPost = [false, true]
      or
      synthRead(_, _, _, _, expr) and isPost = [false, true]
    } or
    TParamNode(CapturedParameter p) or
    TThisParamNode(Callable c) { captureAccess(_, c) } or
    TMallocNode(ClosureExpr ce) { hasConstructorCapture(ce, _) } or
    TVariableWriteSourceNode(VariableWrite write)

  class ClosureNode extends TClosureNode {
    /** Gets a textual representation of this node. */
    string toString() {
      exists(CapturedVariable v | this = TSynthRead(v, _, _, _) and result = v.toString())
      or
      result = "this" and this = TSynthThisQualifier(_, _, _)
      or
      exists(CaptureSsa::DefinitionExt phi, CaptureContainer cc |
        this = TSynthPhi(phi) and
        phi.definesAt(cc, _, _, _) and
        result = "phi(" + cc.toString() + ")"
      )
      or
      exists(Expr expr, boolean isPost | this = TExprNode(expr, isPost) |
        isPost = false and result = expr.toString()
        or
        isPost = true and result = expr.toString() + " [postupdate]"
      )
      or
      exists(CapturedParameter p | this = TParamNode(p) and result = p.toString())
      or
      result = "this" and this = TThisParamNode(_)
      or
      result = "malloc" and this = TMallocNode(_)
      or
      exists(VariableWrite write |
        this = TVariableWriteSourceNode(write) and
        result = "Source of write to " + write.getVariable().toString()
      )
    }

    /** Gets the location of this node. */
    Location getLocation() {
      exists(CapturedVariable v, BasicBlock bb, int i, Expr closure |
        this = TSynthRead(v, bb, i, _) and
        synthRead(v, bb, i, _, closure) and
        result = closure.getLocation()
      )
      or
      exists(BasicBlock bb, int i | this = TSynthThisQualifier(bb, i, _) |
        synthRead(_, bb, i, false, any(Expr closure | result = closure.getLocation())) or
        captureRead(_, bb, i, false, any(VariableRead vr | result = vr.getLocation())) or
        captureWrite(_, bb, i, false, any(VariableWrite vw | result = vw.getLocation()))
      )
      or
      exists(CaptureSsa::DefinitionExt phi, BasicBlock bb |
        this = TSynthPhi(phi) and phi.definesAt(_, bb, _, _) and result = bb.getLocation()
      )
      or
      exists(Expr expr | this = TExprNode(expr, _) and result = expr.getLocation())
      or
      exists(CapturedParameter p | this = TParamNode(p) and result = p.getCallable().getLocation())
      or
      exists(Callable c | this = TThisParamNode(c) and result = c.getLocation())
      or
      exists(ClosureExpr ce | this = TMallocNode(ce) and result = ce.getLocation())
      or
      exists(VariableWrite write |
        this = TVariableWriteSourceNode(write) and result = write.getLocation()
      )
    }
  }

  private class TSynthesizedCaptureNode = TSynthRead or TSynthThisQualifier or TSynthPhi;

  class SynthesizedCaptureNode extends ClosureNode, TSynthesizedCaptureNode {
    Callable getEnclosingCallable() {
      exists(BasicBlock bb | this = TSynthRead(_, bb, _, _) and result = bb.getEnclosingCallable())
      or
      exists(BasicBlock bb |
        this = TSynthThisQualifier(bb, _, _) and result = bb.getEnclosingCallable()
      )
      or
      exists(CaptureSsa::DefinitionExt phi, BasicBlock bb |
        this = TSynthPhi(phi) and phi.definesAt(_, bb, _, _) and result = bb.getEnclosingCallable()
      )
    }

    predicate isVariableAccess(CapturedVariable v) {
      this = TSynthRead(v, _, _, _)
      or
      exists(CaptureSsa::DefinitionExt phi |
        this = TSynthPhi(phi) and phi.definesAt(TVariable(v), _, _, _)
      )
    }

    predicate isInstanceAccess() {
      this instanceof TSynthThisQualifier
      or
      exists(CaptureSsa::DefinitionExt phi |
        this = TSynthPhi(phi) and phi.definesAt(TThis(_), _, _, _)
      )
    }
  }

  class ExprNode extends ClosureNode, TExprNode {
    ExprNode() { this = TExprNode(_, false) }

    Expr getExpr() { this = TExprNode(result, _) }
  }

  class ExprPostUpdateNode extends ClosureNode, TExprNode {
    ExprPostUpdateNode() { this = TExprNode(_, true) }

    Expr getExpr() { this = TExprNode(result, _) }
  }

  class ParameterNode extends ClosureNode, TParamNode {
    CapturedParameter getParameter() { this = TParamNode(result) }
  }

  class ThisParameterNode extends ClosureNode, TThisParamNode {
    Callable getCallable() { this = TThisParamNode(result) }
  }

  class MallocNode extends ClosureNode, TMallocNode {
    ClosureExpr getClosureExpr() { this = TMallocNode(result) }
  }

  class VariableWriteSourceNode extends ClosureNode, TVariableWriteSourceNode {
    VariableWrite getVariableWrite() { this = TVariableWriteSourceNode(result) }
  }

  predicate capturePostUpdateNode(SynthesizedCaptureNode post, SynthesizedCaptureNode pre) {
    exists(CapturedVariable v, BasicBlock bb, int i |
      pre = TSynthRead(v, bb, i, false) and post = TSynthRead(v, bb, i, true)
    )
    or
    exists(BasicBlock bb, int i |
      pre = TSynthThisQualifier(bb, i, false) and post = TSynthThisQualifier(bb, i, true)
    )
  }

  private predicate step(CaptureContainer cc, BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
    CaptureSsa::adjacentDefReadExt(_, cc, bb1, i1, bb2, i2)
  }

  private predicate stepToPhi(CaptureContainer cc, BasicBlock bb, int i, TSynthPhi phi) {
    exists(CaptureSsa::DefinitionExt next |
      CaptureSsa::lastRefRedefExt(_, cc, bb, i, next) and
      phi = TSynthPhi(next)
    )
  }

  private predicate ssaAccessAt(
    ClosureNode n, CaptureContainer cc, boolean isPost, BasicBlock bb, int i
  ) {
    exists(CapturedVariable v |
      synthRead(v, bb, i, true, _) and
      n = TSynthRead(v, bb, i, isPost) and
      cc = TVariable(v)
    )
    or
    n = TSynthThisQualifier(bb, i, isPost) and cc = TThis(bb.getEnclosingCallable())
    or
    exists(CaptureSsa::DefinitionExt phi |
      n = TSynthPhi(phi) and phi.definesAt(cc, bb, i, _) and isPost = false
    )
    or
    exists(VariableRead vr, CapturedVariable v |
      captureRead(v, bb, i, true, vr) and
      n = TExprNode(vr, isPost) and
      cc = TVariable(v)
    )
    or
    exists(VariableWrite vw, CapturedVariable v |
      captureWrite(v, bb, i, true, vw) and
      n = TVariableWriteSourceNode(vw) and
      isPost = false and
      cc = TVariable(v)
    )
    or
    exists(CapturedParameter p |
      entryDef(cc, bb, i) and
      cc = TVariable(p) and
      n = TParamNode(p) and
      isPost = false
    )
    or
    exists(Callable c |
      entryDef(cc, bb, i) and
      cc = TThis(c) and
      n = TThisParamNode(c) and
      isPost = false
    )
  }

  predicate localFlowStep(ClosureNode node1, ClosureNode node2) {
    exists(CaptureContainer cc, BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      step(cc, bb1, i1, bb2, i2) and
      ssaAccessAt(node1, pragma[only_bind_into](cc), _, bb1, i1) and
      ssaAccessAt(node2, pragma[only_bind_into](cc), false, bb2, i2)
    )
    or
    exists(CaptureContainer cc, BasicBlock bb, int i |
      stepToPhi(cc, bb, i, node2) and
      ssaAccessAt(node1, cc, _, bb, i)
    )
  }

  private predicate storeStepClosure(
    ClosureNode node1, CapturedVariable v, ClosureNode node2, boolean alias
  ) {
    exists(BasicBlock bb, int i, Expr closure |
      synthRead(v, bb, i, _, closure, alias) and
      node1 = TSynthRead(v, bb, i, false)
    |
      node2 = TExprNode(closure, false)
      or
      node2 = TMallocNode(closure) and hasConstructorCapture(closure, v)
    )
  }

  predicate storeStep(ClosureNode node1, CapturedVariable v, ClosureNode node2) {
    // store v in the closure or in the malloc in case of a relevant constructor call
    storeStepClosure(node1, v, node2, _)
    or
    // write to v inside the closure body
    exists(BasicBlock bb, int i, VariableWrite vw |
      captureWrite(v, bb, i, false, vw) and
      node1 = TVariableWriteSourceNode(vw) and
      node2 = TSynthThisQualifier(bb, i, true)
    )
  }

  predicate readStep(ClosureNode node1, CapturedVariable v, ClosureNode node2) {
    // read v from the closure post-update to observe side-effects
    exists(BasicBlock bb, int i, Expr closure, boolean post |
      synthRead(v, bb, i, _, closure) and
      node1 = TExprNode(closure, post) and
      node2 = TSynthRead(v, bb, i, true)
    |
      post = true
      or
      // for a constructor call the regular ExprNode is the post-update for the MallocNode
      post = false and hasConstructorCapture(closure, v)
    )
    or
    // read v from the closure inside the closure body
    exists(BasicBlock bb, int i | node1 = TSynthThisQualifier(bb, i, false) |
      synthRead(v, bb, i, false, _) and
      node2 = TSynthRead(v, bb, i, false)
      or
      exists(VariableRead vr |
        captureRead(v, bb, i, false, vr) and
        node2 = TExprNode(vr, false)
      )
    )
  }

  predicate clearsContent(ClosureNode node, CapturedVariable v) {
    /*
     * Stores into closure aliases block flow from previous stores, both to
     * avoid overlapping data flow paths, but also to avoid false positive
     * flow.
     *
     * Example 1 (overlapping paths):
     *
     * ```rb
     * def m
     *     x = taint
     *
     *     fn = -> { # (1)
     *        sink x
     *     }
     *
     *     fn.call # (2)
     * ```
     *
     * If we don't clear `x` at `fn` (2), we will have two overlapping paths:
     *
     * ```
     * taint -> fn (2) [captured x]
     * taint -> fn (1) [captured x] -> fn (2) [captured x]
     * ```
     *
     * where the step `fn (1) [captured x] -> fn [captured x]` arises from normal
     * use-use flow for `fn`. Clearing `x` at `fn` (2) removes the second path above.
     *
     * Example 2 (false positive flow):
     *
     * ```rb
     * def m
     *     x = taint
     *
     *     fn = -> { # (1)
     *        sink x
     *     }
     *
     *     x = nil # (2)
     *
     *     fn.call # (3)
     * end
     * ```
     *
     * If we don't clear `x` at `fn` (3), we will have the following false positive
     * flow path:
     *
     * ```
     * taint -> fn (1) [captured x] -> fn (3) [captured x]
     * ```
     *
     * since normal use-use flow for `fn` does not take the overwrite at (2) into account.
     */

    storeStepClosure(_, v, node, true)
    or
    exists(BasicBlock bb, int i |
      captureWrite(v, bb, i, false, _) and
      node = TSynthThisQualifier(bb, i, false)
    )
  }
}
