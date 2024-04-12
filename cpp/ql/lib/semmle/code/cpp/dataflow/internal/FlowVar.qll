/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.DataFlow` instead.
 *
 * Provides a class for handling variables in the data flow analysis.
 */

import cpp
private import semmle.code.cpp.controlflow.SSA
private import SubBasicBlocks
private import AddressFlow
private import semmle.code.cpp.models.implementations.Iterator
private import semmle.code.cpp.models.interfaces.PointerWrapper

/**
 * A conceptual variable that is assigned only once, like an SSA variable. This
 * class is used for tracking data flow through variables, where the desired
 * semantics is sometimes different from what the SSA library provides. Unlike
 * SSA, there are no _phi_ nodes; instead, each `VariableAccess` may be
 * associated with more than one `FlowVar`.
 *
 * Each instance of this class corresponds to a modification or an initial
 * value of a variable. A `FlowVar` has exactly one result for either
 * `definedByExpr` or `definedByInitialValue`. The documentation on those two
 * member predicates explains how a `FlowVar` relates to syntactic constructs of
 * the language.
 */
cached
class FlowVar extends TFlowVar {
  /**
   * Gets a `VariableAccess` that _may_ take its value from `this`. Consider
   * the following snippet.
   *
   * ```
   * int x = 0;
   * if (b) { f(x); x = 1; }
   * g(x)
   * ```
   *
   * The access to `x` in `f(x)` may take its value from the `FlowVar`
   * corresponding to `int x = 0`, while the access to `x` in `g(x)` may take
   * its value from the `FlowVar` corresponding to `int x = 0` or the `FlowVar`
   * corresponding to `x = 1`. The `x` in `x = 1` is not considered to be an
   * access.
   */
  cached
  abstract VariableAccess getAnAccess();

  /**
   * Holds if this `FlowVar` corresponds to a modification occurring when `node` is
   * evaluated, receiving a value best described by `e`. The following is an
   * exhaustive list of cases where this may happen.
   *
   * - `node` is an `Initializer` and `e` is its contained expression.
   * - `node` is an `AssignExpr`, and `e` is its right-hand side.
   * - `node` is an `AssignOperation`, and `e` is `node`.
   * - `node` is a `CrementOperation`, and `e` is `node`. The case where
   *   `node instanceof PostCrementOperation` is an exception to the rule that
   *   `this` contains the value of `e` after the evaluation of `node`.
   */
  cached
  abstract predicate definedByExpr(Expr e, ControlFlowNode node);

  /**
   * Holds if this `FlowVar` is a `PartialDefinition` whose outer defined
   * expression is `e`. For example, in `f(&x)`, the outer defined expression
   * is `&x`.
   */
  cached
  abstract predicate definedPartiallyAt(Expr e);

  /**
   * Holds if this `FlowVar` is a definition of a reference parameter `p` that
   * persists until the function returns.
   */
  cached
  abstract predicate reachesRefParameter(Parameter p);

  /**
   * Holds if this `FlowVar` corresponds to the initial value of `v`. The following
   * is an exhaustive list of cases where this may happen.
   *
   * - `v` is a parameter, and `this` contains the value of the parameter at
   *   the entry point of its function body.
   * - `v` is an uninitialized local variable, and `v` contains its (arbitrary)
   *   value before it is reassigned. If it can be statically determined that a
   *   local variable is always overwritten before it is used, there is no
   *   `FlowVar` instance for the uninitialized value of that variable.
   */
  cached
  abstract predicate definedByInitialValue(StackVariable v);

  /** Gets a textual representation of this element. */
  cached
  abstract string toString();

  /** Gets the location of this element. */
  cached
  abstract Location getLocation();
}

/**
 * Provides classes and predicates dealing with "partial definitions".
 *
 * In contrast to a normal "definition", which provides a new value for
 * something, a partial definition is an expression that may affect a
 * value, but does not necessarily replace it entirely. For example:
 * ```
 * x.y = 1; // a partial definition of the object `x`.
 * x.y.z = 1; // a partial definition of the objects `x` and `x.y`.
 * x.setY(1); // a partial definition of the object `x`.
 * setY(&x); // a partial definition of the object `x`.
 * ```
 */
private module PartialDefinitions {
  abstract class PartialDefinition extends Expr {
    ControlFlowNode node;

    /**
     * Gets the subBasicBlock where this `PartialDefinition` is defined.
     */
    ControlFlowNode getSubBasicBlockStart() { result = node }

    /**
     * Holds if this `PartialDefinition` defines variable `v` at control-flow
     * node `cfn`.
     */
    // does this work with a dispred?
    pragma[noinline]
    abstract predicate partiallyDefinesVariableAt(Variable v, ControlFlowNode cfn);

    /**
     * Holds if this partial definition may modify `inner` (or what it points
     * to) through `outer`. These expressions will never be `Conversion`s.
     *
     * For example, in `f(& (*a).x)`, there are two results:
     * - `inner` = `... .x`, `outer` = `&...`
     * - `inner` = `a`, `outer` = `*`
     */
    abstract predicate definesExpressions(Expr inner, Expr outer);

    /**
     * Gets the location of this element, adjusted to avoid unknown locations
     * on compiler-generated `ThisExpr`s.
     */
    Location getActualLocation() {
      not exists(this.getLocation()) and result = this.getParent().getLocation()
      or
      this.getLocation() instanceof UnknownLocation and
      result = this.getParent().getLocation()
      or
      result = this.getLocation() and not result instanceof UnknownLocation
    }
  }

  class IteratorPartialDefinition extends PartialDefinition {
    Variable collection;
    Expr innerDefinedExpr;

    IteratorPartialDefinition() {
      innerDefinedExpr = getInnerDefinedExpr(this, node) and
      (
        innerDefinedExpr.(Call).getQualifier() = getAnIteratorAccess(collection)
        or
        innerDefinedExpr.(Call).getQualifier() = collection.getAnAccess() and
        collection instanceof IteratorParameter
      ) and
      innerDefinedExpr.(Call).getTarget() instanceof IteratorPointerDereferenceMemberOperator
      or
      // iterators passed by value without a copy constructor
      exists(Call call |
        call = node and
        call.getAnArgument() = innerDefinedExpr and
        innerDefinedExpr = this and
        this = getAnIteratorAccess(collection) and
        not call.getTarget() instanceof IteratorPointerDereferenceMemberOperator
      )
      or
      // iterators passed by value with a copy constructor
      exists(Call call, ConstructorCall copy |
        copy.getTarget() instanceof CopyConstructor and
        call = node and
        call.getAnArgument() = copy and
        copy.getArgument(0) = getAnIteratorAccess(collection) and
        innerDefinedExpr = this and
        this = copy and
        not call.getTarget() instanceof IteratorPointerDereferenceMemberOperator
      )
    }

    override predicate definesExpressions(Expr inner, Expr outer) {
      inner = innerDefinedExpr and
      outer = this
    }

    override predicate partiallyDefinesVariableAt(Variable v, ControlFlowNode cfn) {
      v = collection and
      cfn = node
    }
  }

  private Expr getInnerDefinedExpr(Expr e, ControlFlowNode node) {
    not e instanceof Conversion and
    exists(Expr convertedInner |
      valueToUpdate(convertedInner, e.getFullyConverted(), node) and
      result = convertedInner.getUnconverted()
    )
  }

  class VariablePartialDefinition extends PartialDefinition {
    Expr innerDefinedExpr;

    VariablePartialDefinition() { innerDefinedExpr = getInnerDefinedExpr(this, node) }

    /**
     * Holds if this partial definition may modify `inner` (or what it points
     * to) through `outer`. These expressions will never be `Conversion`s.
     *
     * For example, in `f(& (*a).x)`, there are two results:
     * - `inner` = `... .x`, `outer` = `&...`
     * - `inner` = `a`, `outer` = `*`
     */
    override predicate definesExpressions(Expr inner, Expr outer) {
      inner = innerDefinedExpr and
      outer = this
    }

    override predicate partiallyDefinesVariableAt(Variable v, ControlFlowNode cfn) {
      innerDefinedExpr = v.getAnAccess() and
      cfn = node
    }
  }

  /**
   * A partial definition that's a definition via an output iterator.
   */
  class DefinitionByIterator extends IteratorPartialDefinition {
    DefinitionByIterator() { exists(Call c | this = c.getAnArgument() or this = c.getQualifier()) }
  }

  /**
   * A partial definition that's a definition by reference.
   */
  class DefinitionByReference extends VariablePartialDefinition {
    DefinitionByReference() { exists(Call c | this = c.getAnArgument() or this = c.getQualifier()) }
  }
}

import PartialDefinitions
private import FlowVar_internal

/**
 * Provides classes and predicates that ought to be private but cannot use the
 * `private` annotation because they may be referred to by unit tests.
 */
module FlowVar_internal {
  /**
   * For various reasons, not all variables handled perfectly by the SSA library.
   * Ideally, this predicate should become larger as the SSA library improves.
   * Before we can remove the `BlockVar` class completely, the SSA library needs
   * the following improvements.
   * - Considering uninitialized local variables to be definitions.
   * - Supporting fields, globals and statics like the Java SSA library does.
   * - Supporting all local variables, even if their address is taken by
   *   address-of, reference assignments, or lambdas.
   * - Understanding that assignment to a field of a local struct is a
   *   definition of the struct but not a complete overwrite. This is what the
   *   IR library uses chi nodes for.
   */
  predicate fullySupportedSsaVariable(Variable v) {
    v = any(SsaDefinition def).getAVariable() and
    // A partially-defined variable is handled using the partial definitions logic.
    not any(PartialDefinition p).partiallyDefinesVariableAt(v, _) and
    // SSA variables do not exist before their first assignment, but one
    // feature of this data flow library is to track where uninitialized data
    // ends up.
    not mayBeUsedUninitialized(v, _) and
    // If `v` may be a variable that is always overwritten in a loop that
    // always executes at least once, we give it special treatment in
    // `BlockVar`, somewhat analogous to unrolling the first iteration of the
    // loop.
    not exists(AlwaysTrueUponEntryLoop loop | loop.alwaysAssignsBeforeLeavingCondition(_, _, v)) and
    // The SSA library has a theoretically accurate treatment of reference types,
    // treating them as immutable, but for data flow it gives better results in
    // practice to make the variable synonymous with its contents.
    not v.getUnspecifiedType() instanceof ReferenceType and
    not v instanceof IteratorParameter and
    not v instanceof PointerWrapperParameter
  }

  /**
   * Holds if `sbb` is the `SubBasicBlock` where `v` receives its initial value.
   * See the documentation for `FlowVar.definedByInitialValue`.
   */
  predicate blockVarDefinedByVariable(SubBasicBlock sbb, StackVariable v) {
    sbb = v.(Parameter).getFunction().getEntryPoint()
    or
    exists(DeclStmt declStmt |
      declStmt.getDeclaration(_) = v.(LocalVariable) and
      sbb.contains(declStmt) and
      mayBeUsedUninitialized(v, _)
    )
  }

  newtype TFlowVar =
    TSsaVar(SsaDefinition def, StackVariable v) {
      fullySupportedSsaVariable(v) and
      v = def.getAVariable()
    } or
    TBlockVar(SubBasicBlock sbb, Variable v) {
      not fullySupportedSsaVariable(v) and
      not v instanceof Field and // Fields are interprocedural data flow, not local
      reachable(sbb) and
      (
        initializer(v, sbb.getANode())
        or
        assignmentLikeOperation(sbb, v, _)
        or
        exists(PartialDefinition p | p.partiallyDefinesVariableAt(v, sbb))
        or
        blockVarDefinedByVariable(sbb, v)
      )
    }

  /**
   * A variable whose analysis is backed by the SSA library.
   */
  class SsaVar extends TSsaVar, FlowVar {
    SsaDefinition def;
    StackVariable v;

    SsaVar() { this = TSsaVar(def, v) }

    override VariableAccess getAnAccess() {
      // There is no need to know about direct accesses to phi nodes because
      // the data flow library will never see those, and the `FlowVar` library
      // is only meant to be used by the data flow library.
      this.isNonPhi() and
      (
        // This base case could be included in the transitive case by changing
        // `+` to `*`, but that's slower because it goes through the `TSsaVar`
        // indirection.
        result = def.getAUse(v)
        or
        exists(SsaDefinition descendantDef |
          this.getASuccessorSsaVar+() = TSsaVar(descendantDef, _) and
          result = descendantDef.getAUse(v)
        )
      )
      or
      parameterUsedInConstructorFieldInit(v, result) and
      def.definedByParameter(v)
    }

    override predicate definedByExpr(Expr e, ControlFlowNode node) {
      e = def.getDefiningValue(v) and
      (
        if def.getDefinition() = v.getInitializer().getExpr()
        then node = v.getInitializer()
        else node = def.getDefinition()
      )
    }

    override predicate definedPartiallyAt(Expr e) { none() }

    override predicate definedByInitialValue(StackVariable param) {
      def.definedByParameter(param) and
      param = v
    }

    // `fullySupportedSsaVariable` excludes reference types
    override predicate reachesRefParameter(Parameter p) { none() }

    /**
     * Holds if this `SsaVar` corresponds to a non-phi definition. Users of this
     * library will never directly use an `SsaVar` that comes from a phi node,
     * so such values are purely for implementation use.
     */
    private predicate isNonPhi() {
      // This implementation is positively phrased in terms of these two helper
      // predicates because it performs better than phrasing it negatively in
      // terms of `def.isPhiNode`.
      this.definedByExpr(_, _)
      or
      this.definedByInitialValue(_)
    }

    /**
     * Holds if `result` might have the same value as `this` because `result` is
     * a phi node with `this` as input.
     */
    private SsaVar getASuccessorSsaVar() {
      exists(SsaDefinition succDef |
        result = TSsaVar(succDef, v) and
        def = succDef.getAPhiInput(v)
      )
    }

    override string toString() { result = def.toString(v) }

    override Location getLocation() { result = def.getLocation() }
  }

  /**
   * A variable whose analysis is backed by a simple control flow analysis that
   * does not perform as well as the SSA library but gives better results for
   * data flow purposes in some cases.
   */
  class BlockVar extends TBlockVar, FlowVar {
    SubBasicBlock sbb;
    Variable v;

    BlockVar() { this = TBlockVar(sbb, v) }

    override VariableAccess getAnAccess() {
      variableAccessInSBB(v, getAReachedBlockVarSBB(this), result) and
      result != sbb
      or
      parameterUsedInConstructorFieldInit(v, result) and
      sbb = v.(Parameter).getFunction().getEntryPoint()
    }

    override predicate reachesRefParameter(Parameter p) {
      parameterIsNonConstReference(p) and
      p = v and
      // This definition reaches the exit node of the function CFG
      getAReachedBlockVarSBB(this).getEnd() = p.getFunction()
    }

    override predicate definedByInitialValue(StackVariable lsv) {
      blockVarDefinedByVariable(sbb, lsv) and
      lsv = v
    }

    override predicate definedByExpr(Expr e, ControlFlowNode node) {
      assignmentLikeOperation(node, v, e) and
      node = sbb
      or
      // We pick the defining `ControlFlowNode` of an `Initializer` to be its
      // expression rather than the `Initializer` itself. That's because the
      // `Initializer` of a `ConditionDeclExpr` is for historical reasons not
      // part of the CFG and therefore ends up in the wrong basic block.
      initializer(v, e) and
      node = e and
      node = sbb.getANode()
    }

    override predicate definedPartiallyAt(Expr e) {
      exists(PartialDefinition p |
        p.partiallyDefinesVariableAt(v, sbb) and
        p.definesExpressions(_, e)
      )
    }

    override string toString() {
      this.definedByExpr(_, _) and
      result = "assignment to " + v
      or
      this.definedByInitialValue(_) and
      result = "initial value of " + v
      or
      exists(Expr partialDef |
        this.definedPartiallyAt(partialDef) and
        result = "partial definition at " + partialDef
      )
      or
      // impossible case
      not this.definedByExpr(_, _) and
      not this.definedByInitialValue(_) and
      not this.definedPartiallyAt(_) and
      result = "undefined " + v
    }

    override Location getLocation() { result = sbb.getStart().getLocation() }
  }

  /** Type-specialized version of `getEnclosingElement`. */
  private ControlFlowNode getCfnParent(ControlFlowNode node) { result = node.getEnclosingElement() }

  /**
   * A for-loop or while-loop whose condition is always true upon entry but not
   * always true after the first iteration.
   */
  class AlwaysTrueUponEntryLoop extends Stmt {
    AlwaysTrueUponEntryLoop() {
      this.(WhileStmt).conditionAlwaysTrueUponEntry() and
      not this.(WhileStmt).conditionAlwaysTrue()
      or
      this.(ForStmt).conditionAlwaysTrueUponEntry() and
      not this.(ForStmt).conditionAlwaysTrue()
    }

    /**
     * Holds if this loop always assigns to `v` before leaving through an edge
     * from `bbInside` in its condition to `bbOutside` outside the loop. Also,
     * `v` must be used outside the loop.
     */
    predicate alwaysAssignsBeforeLeavingCondition(
      BasicBlock bbInside, BasicBlock bbOutside, Variable v
    ) {
      v = this.getARelevantVariable() and
      this.bbInLoopCondition(bbInside) and
      not this.bbInLoop(bbOutside) and
      bbOutside = bbInside.getASuccessor() and
      not this.reachesWithoutAssignment(bbInside, v)
    }

    /**
     * Gets a variable that is assigned in this loop and read outside the loop.
     */
    Variable getARelevantVariable() {
      result = this.getAVariableAssignedInLoop() and
      exists(VariableAccess va |
        va.getTarget() = result and
        readAccess(va) and
        exists(BasicBlock bb | bb = va.getBasicBlock() | not this.bbInLoop(bb))
      )
    }

    /** Gets a variable that is assigned in this loop. */
    pragma[noinline]
    private Variable getAVariableAssignedInLoop() {
      exists(BasicBlock bbAssign |
        assignmentLikeOperation(bbAssign.getANode(), result, _) and
        this.bbInLoop(bbAssign)
      )
    }

    private predicate bbInLoopCondition(BasicBlock bb) {
      getCfnParent*(bb.getANode()) = this.(Loop).getCondition()
    }

    private predicate bbInLoop(BasicBlock bb) {
      bbDominates(this.(Loop).getStmt(), bb)
      or
      this.bbInLoopCondition(bb)
    }

    /** Holds if `sbb` is inside this loop. */
    predicate sbbInLoop(SubBasicBlock sbb) { this.bbInLoop(sbb.getBasicBlock()) }

    /**
     * Holds if `bb` is a basic block inside this loop where `v` has not been
     * overwritten at the end of `bb`.
     */
    private predicate reachesWithoutAssignment(BasicBlock bb, Variable v) {
      (
        // For the type of loop we are interested in, the body is always a
        // basic block.
        bb = this.(Loop).getStmt() and
        v = this.getARelevantVariable()
        or
        this.reachesWithoutAssignment(pragma[only_bind_out](bb.getAPredecessor()), v) and
        this.bbInLoop(bb)
      ) and
      not assignsToVar(bb, v)
    }
  }

  pragma[noinline]
  private predicate assignsToVar(BasicBlock bb, Variable v) {
    assignmentLikeOperation(bb.getANode(), v, _) and
    exists(AlwaysTrueUponEntryLoop loop | v = loop.getARelevantVariable())
  }

  /**
   * Holds if `loop` always assigns to `v` before leaving through an edge
   * from `bbInside` in its condition to `bbOutside` outside the loop. Also,
   * `v` must be used outside the loop.
   */
  predicate skipLoop(
    SubBasicBlock sbbInside, SubBasicBlock sbbOutside, Variable v, AlwaysTrueUponEntryLoop loop
  ) {
    exists(BasicBlock bbInside, BasicBlock bbOutside |
      loop.alwaysAssignsBeforeLeavingCondition(bbInside, bbOutside, v) and
      bbInside = sbbInside.getBasicBlock() and
      bbOutside = sbbOutside.getBasicBlock() and
      sbbInside.lastInBB() and
      sbbOutside.firstInBB()
    )
  }

  // The noopt is needed to avoid getting `variableLiveInSBB` joined in before
  // `getASuccessor`.
  pragma[noopt]
  private SubBasicBlock getAReachedBlockVarSBB(TBlockVar start) {
    exists(Variable v |
      start = TBlockVar(result, v) and
      variableLiveInSBB(result, v) and
      not largeVariable(v, _, _)
    )
    or
    exists(SubBasicBlock mid, SubBasicBlock sbbDef, Variable v |
      mid = getAReachedBlockVarSBB(start) and
      start = TBlockVar(sbbDef, v) and
      result = mid.getASuccessor() and
      variableLiveInSBB(result, v) and
      forall(AlwaysTrueUponEntryLoop loop | skipLoop(mid, result, v, loop) | loop.sbbInLoop(sbbDef)) and
      not assignmentLikeOperation(result, v, _)
    )
  }

  /**
   * Holds if `v` may have too many combinations of definitions and reached
   * blocks for us the feasibly compute its def-use relation.
   */
  private predicate largeVariable(Variable v, int liveBlocks, int defs) {
    liveBlocks = strictcount(SubBasicBlock sbb | variableLiveInSBB(sbb, v)) and
    defs = strictcount(SubBasicBlock sbb | exists(TBlockVar(sbb, v))) and
    // Convert to float to avoid int overflow (32-bit two's complement)
    liveBlocks.(float) * defs.(float) > 100000.0
  }

  /**
   * Holds if a value held in `v` at the start of `sbb` (or after the first
   * assignment, if that assignment is to `v`) might later be read.
   */
  private predicate variableLiveInSBB(SubBasicBlock sbb, Variable v) {
    variableAccessInSBB(v, sbb, _)
    or
    // Non-const reference parameters are live at the end of the function
    parameterIsNonConstReference(v) and
    sbb.contains(v.(Parameter).getFunction())
    or
    exists(SubBasicBlock succ | succ = sbb.getASuccessor() |
      variableLiveInSBB(succ, v) and
      not variableNotLiveBefore(succ, v)
    )
  }

  predicate parameterIsNonConstReference(Parameter p) {
    exists(ReferenceType refType |
      refType = p.getUnderlyingType() and
      (
        not refType.getBaseType().isConst()
        or
        // A field of a parameter of type `const std::shared_ptr<A>& p` can still be changed even though
        // the base type of the reference is `const`.
        refType.getBaseType().getUnspecifiedType() =
          any(PointerWrapper wrapper | not wrapper.pointsToConst())
      )
    )
    or
    p instanceof IteratorParameter
    or
    p instanceof PointerWrapperParameter
  }

  /**
   * Holds if liveness of `v` should stop propagating backwards from `sbb`.
   */
  private predicate variableNotLiveBefore(SubBasicBlock sbb, Variable v) {
    assignmentLikeOperation(sbb, v, _)
    or
    // Liveness of `v` is killed when going backwards from a block that declares it
    exists(DeclStmt ds | ds.getADeclaration().(LocalVariable) = v and sbb.contains(ds))
  }

  /** Holds if `va` is a read access to `v` in `sbb`, where `v` is modeled by `BlockVar`. */
  pragma[noinline]
  private predicate variableAccessInSBB(Variable v, SubBasicBlock sbb, VariableAccess va) {
    exists(TBlockVar(_, v)) and
    va.getTarget() = v and
    va = sbb.getANode() and
    not overwrite(va, _)
  }

  /**
   * A local variable that is uninitialized immediately after its declaration.
   */
  class UninitializedLocalVariable extends LocalVariable, StackVariable {
    UninitializedLocalVariable() { not this.hasInitializer() }
  }

  /** Holds if `va` may be an uninitialized access to `v`. */
  predicate mayBeUsedUninitialized(UninitializedLocalVariable v, VariableAccess va) {
    exists(BasicBlock bb, int vaIndex |
      va.getTarget() = v and
      readAccess(va) and
      va = bb.getNode(vaIndex) and
      notAccessedAtStartOfBB(v, bb) and
      (
        vaIndex < indexOfFirstOverwriteInBB(v, bb)
        or
        not exists(indexOfFirstOverwriteInBB(v, bb))
      )
    )
  }

  /**
   * Holds if `v` has not been accessed at the start of `bb`, for a variable
   * `v` where `allReadsDominatedByOverwrite(v)` does not hold.
   */
  predicate notAccessedAtStartOfBB(UninitializedLocalVariable v, BasicBlock bb) {
    // Start from a BB containing an uninitialized variable
    bb.getANode().(DeclStmt).getDeclaration(_) = v and
    // Only consider variables for which initialization before reading cannot
    // be proved by simpler means. This predicate is expensive in time and
    // space, whereas `allReadsDominatedByOverwrite` is cheap.
    not allReadsDominatedByOverwrite(v)
    or
    exists(BasicBlock pred |
      pred = bb.getAPredecessor() and
      notAccessedAtStartOfBB(v, pred) and
      // Stop searching when `v` is accessed.
      not pred.getANode() = v.getAnAccess()
    )
  }

  /**
   * Holds if all read accesses of `v` are dominated by an overwrite of `v`.
   */
  predicate allReadsDominatedByOverwrite(UninitializedLocalVariable v) {
    forall(VariableAccess va |
      va.getTarget() = v and
      readAccess(va)
    |
      dominatedByOverwrite(v, va)
    )
  }

  /** Holds if `va` accesses `v` and is dominated by an overwrite of `v`. */
  predicate dominatedByOverwrite(UninitializedLocalVariable v, VariableAccess va) {
    exists(BasicBlock bb, int vaIndex |
      va = bb.getNode(vaIndex) and
      va.getTarget() = v and
      vaIndex > indexOfFirstOverwriteInBB(v, bb)
      or
      va = bb.getNode(vaIndex) and
      va.getTarget() = v and
      bbStrictlyDominates(getAnOverwritingBB(v), bb)
    )
  }

  /** Gets a basic block in which `v` is overwritten. */
  BasicBlock getAnOverwritingBB(UninitializedLocalVariable v) {
    exists(indexOfFirstOverwriteInBB(v, result))
  }

  int indexOfFirstOverwriteInBB(LocalVariable v, BasicBlock bb) {
    result = min(int i | overwrite(v.getAnAccess(), bb.getNode(i)))
  }

  /**
   * Holds if the value of the variable accessed at `va` may affect the execution
   * of the program.
   */
  predicate readAccess(VariableAccess va) {
    reachable(va) and
    not overwrite(va, _) and
    not va = any(SizeofExprOperator so).getAChild+() and
    not va = any(AlignofExprOperator ao).getAChild+()
  }

  /**
   * Holds if the value of the variable accessed at `va` is completely
   * overwritten at `node`, where `va` is uniquely determined by `node`.
   */
  predicate overwrite(VariableAccess va, ControlFlowNode node) {
    va = node.(AssignExpr).getLValue()
  }

  /**
   * Holds if `v` is modified through `va` as a side effect of evaluating
   * `node`, receiving a value best described by `assignedExpr`.
   * Assignment-like operations are those that desugar to a non-overloaded `=`
   * assignment: `=`, `+=`, `++`, `--`, etc.
   *
   * This corresponds to `FlowVar::definedByExpr`, except that the case where
   * `node instanceof Initializer` is covered by `initializer` instead of this
   * predicate.
   */
  predicate assignmentLikeOperation(ControlFlowNode node, Variable v, Expr assignedExpr) {
    // Together, the two following cases cover `Assignment`
    node =
      any(AssignExpr ae |
        v.getAnAccess() = ae.getLValue() and
        assignedExpr = ae.getRValue()
      )
    or
    node =
      any(AssignOperation ao |
        v.getAnAccess() = ao.getLValue() and
        // Here and in the `PrefixCrementOperation` case, we say that the assigned
        // expression is the operation itself. For example, we say that `x += 1`
        // assigns `x += 1` to `x`. The justification is that after this operation,
        // `x` will contain the same value that `x += 1` evaluated to.
        assignedExpr = ao
      )
    or
    // This case does not add further data flow paths, except if a
    // `PrefixCrementOperation` is itself a source
    node =
      any(CrementOperation op |
        v.getAnAccess() = op.getOperand() and
        assignedExpr = op
      )
  }

  Expr getAnIteratorAccess(Variable collection) {
    exists(
      Call c, SsaDefinition def, Variable iterator, FunctionInput input, FunctionOutput output
    |
      c.getTarget().(GetIteratorFunction).getsIterator(input, output) and
      (
        (
          input.isQualifierObject() or
          input.isQualifierAddress()
        ) and
        c.getQualifier() = collection.getAnAccess()
        or
        exists(int index |
          input.isParameter(index) or
          input.isParameterDeref(index)
        |
          c.getArgument(index) = collection.getAnAccess()
        )
      ) and
      output.isReturnValue() and
      def.getAnUltimateDefiningValue(iterator) = c and
      result = def.getAUse(iterator)
    )
    or
    exists(Call crement |
      crement = result and
      [crement.getQualifier(), crement.getArgument(0)] = getAnIteratorAccess(collection) and
      crement.getTarget().getName() = ["operator++", "operator--"]
    )
  }

  class IteratorParameter extends Parameter {
    IteratorParameter() { this.getUnspecifiedType() instanceof Iterator }
  }

  class PointerWrapperParameter extends Parameter {
    PointerWrapperParameter() { this.getUnspecifiedType() instanceof PointerWrapper }
  }

  /**
   * Holds if `v` is initialized to have value `assignedExpr`.
   */
  predicate initializer(LocalVariable v, Expr assignedExpr) {
    assignedExpr = v.getInitializer().getExpr()
  }

  /**
   * Holds if `p` is a parameter to a constructor that is used in a
   * `ConstructorFieldInit` at `va`. This ignores the corner case that `p`
   * might have been overwritten to have a different value before this happens.
   */
  predicate parameterUsedInConstructorFieldInit(Parameter p, VariableAccess va) {
    exists(Constructor constructor |
      constructor.getInitializer(_).(ConstructorFieldInit).getExpr().getAChild*() = va and
      va = p.getAnAccess()
      // We don't require that `constructor` has `p` as a parameter because
      // that follows from the two other conditions and would likely just
      // confuse the join orderer.
    )
  }

  /**
   * A point in a basic block where a non-SSA variable may have a different value
   * than it did elsewhere in the same basic block. Extending this class
   * configures the `SubBasicBlocks` library as needed for the implementation of
   * this library.
   */
  class DataFlowSubBasicBlockCutNode extends SubBasicBlockCutNode {
    DataFlowSubBasicBlockCutNode() {
      exists(Variable v | not fullySupportedSsaVariable(v) |
        assignmentLikeOperation(this, v, _)
        or
        exists(PartialDefinition p | p.partiallyDefinesVariableAt(v, this))
        // It is not necessary to cut the basic blocks at `Initializer` nodes
        // because the affected variable can have no _other_ value before its
        // initializer. It is not necessary to cut basic blocks at procedure
        // entries for the sake of `Parameter`s since we are already guaranteed
        // to have a `SubBasicBlock` starting at procedure entry.
      )
    }
  }
}
/* module FlowVar_internal */
