/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import TaintTrackingUtil as TaintTrackingUtil
private import DataFlowPrivate
private import ModelUtil
private import SsaImpl as SsaImpl
private import DataFlowImplCommon as DataFlowImplCommon
private import codeql.util.Unit
private import Node0ToString
private import DataFlowDispatch as DataFlowDispatch
private import DataFlowNodes
import DataFlowNodes::Public

cached
private module Cached {
  /**
   * Holds if `n` has a local flow step that goes through a back-edge.
   */
  cached
  predicate flowsToBackEdge(Node n) {
    exists(Node succ, IRBlock bb1, IRBlock bb2 |
      SsaImpl::ssaFlow(n, succ) and
      bb1 = n.getBasicBlock() and
      bb2 = succ.getBasicBlock() and
      bb2.strictlyDominates(bb1)
    )
  }

  /**
   * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step. This relation is only used for local dataflow
   * (for example `DataFlow::localFlow(source, sink)`) so it contains
   * special cases that should only apply to local dataflow.
   */
  cached
  predicate localFlowStep(Node nodeFrom, Node nodeTo) {
    // common dataflow steps
    simpleLocalFlowStep(nodeFrom, nodeTo, _)
    or
    // models-as-data summarized flow for local data flow (i.e. special case for flow
    // through calls to modeled functions, without relying on global dataflow to join
    // the dots).
    FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
  }

  private predicate indirectionOperandFlow(RawIndirectOperand nodeFrom, Node nodeTo) {
    nodeFrom != nodeTo and
    (
      // Reduce the indirection count by 1 if we're passing through a `LoadInstruction`.
      exists(int ind, LoadInstruction load |
        hasOperandAndIndex(nodeFrom, load.getSourceAddressOperand(), ind) and
        nodeHasInstruction(nodeTo, load, ind - 1)
      )
      or
      // If an operand flows to an instruction, then the indirection of
      // the operand also flows to the indirection of the instruction.
      exists(Operand operand, Instruction instr, int indirectionIndex |
        simpleInstructionLocalFlowStep(operand, instr) and
        hasOperandAndIndex(nodeFrom, operand, pragma[only_bind_into](indirectionIndex)) and
        hasInstructionAndIndex(nodeTo, instr, pragma[only_bind_into](indirectionIndex))
      )
      or
      // If there's indirect flow to an operand, then there's also indirect
      // flow to the operand after applying some pointer arithmetic.
      exists(PointerArithmeticInstruction pointerArith, int indirectionIndex |
        hasOperandAndIndex(nodeFrom, pointerArith.getAnOperand(),
          pragma[only_bind_into](indirectionIndex)) and
        hasInstructionAndIndex(nodeTo, pointerArith, pragma[only_bind_into](indirectionIndex))
      )
    )
  }

  /**
   * Holds if `operand.getDef() = instr`, but there exists a `StoreInstruction` that
   * writes to an address that is equivalent to the value computed by `instr` in
   * between `instr` and `operand`, and therefore there should not be flow from `*instr`
   * to `*operand`.
   */
  pragma[nomagic]
  private predicate isStoredToBetween(Instruction instr, Operand operand) {
    simpleOperandLocalFlowStep(pragma[only_bind_into](instr), pragma[only_bind_into](operand)) and
    exists(StoreInstruction store, IRBlock block, int storeIndex, int instrIndex, int operandIndex |
      store.getDestinationAddress() = instr and
      block.getInstruction(storeIndex) = store and
      block.getInstruction(instrIndex) = instr and
      block.getInstruction(operandIndex) = operand.getUse() and
      instrIndex < storeIndex and
      storeIndex < operandIndex
    )
  }

  private predicate indirectionInstructionFlow(
    RawIndirectInstruction nodeFrom, IndirectOperand nodeTo
  ) {
    nodeFrom != nodeTo and
    // If there's flow from an instruction to an operand, then there's also flow from the
    // indirect instruction to the indirect operand.
    exists(Operand operand, Instruction instr, int indirectionIndex |
      simpleOperandLocalFlowStep(pragma[only_bind_into](instr), pragma[only_bind_into](operand))
    |
      hasOperandAndIndex(nodeTo, operand, pragma[only_bind_into](indirectionIndex)) and
      hasInstructionAndIndex(nodeFrom, instr, pragma[only_bind_into](indirectionIndex)) and
      not isStoredToBetween(instr, operand)
    )
  }

  /**
   * INTERNAL: do not use.
   *
   * This is the local flow predicate that's used as a building block in both
   * local and global data flow. It may have less flow than the `localFlowStep`
   * predicate.
   */
  cached
  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
    (
      TaintTrackingUtil::forceCachingInSameStage() and
      // Def-use/Use-use flow
      SsaImpl::ssaFlow(nodeFrom, nodeTo)
      or
      IteratorFlow::localFlowStep(nodeFrom, nodeTo)
      or
      // Operand -> Instruction flow
      simpleInstructionLocalFlowStep(nodeFrom.asOperand(), nodeTo.asInstruction())
      or
      // Instruction -> Operand flow
      exists(Instruction iFrom, Operand opTo |
        iFrom = nodeFrom.asInstruction() and opTo = nodeTo.asOperand()
      |
        simpleOperandLocalFlowStep(iFrom, opTo) and
        // Omit when the instruction node also represents the operand.
        not iFrom = SsaImpl::getIRRepresentationOfOperand(opTo)
      )
      or
      // Indirect operand -> (indirect) instruction flow
      indirectionOperandFlow(nodeFrom, nodeTo)
      or
      // Indirect instruction -> indirect operand flow
      indirectionInstructionFlow(nodeFrom, nodeTo)
    ) and
    model = ""
    or
    // Flow through modeled functions
    modelFlow(nodeFrom, nodeTo, model)
    or
    // Reverse flow: data that flows from the definition node back into the indirection returned
    // by a function. This allows data to flow 'in' through references returned by a modeled
    // function such as `operator[]`.
    reverseFlow(nodeFrom, nodeTo) and
    model = ""
    or
    // models-as-data summarized flow
    FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
      nodeTo.(FlowSummaryNode).getSummaryNode(), true, model)
  }

  private predicate simpleInstructionLocalFlowStep(Operand opFrom, Instruction iTo) {
    // Treat all conversions as flow, even conversions between different numeric types.
    conversionFlow(opFrom, iTo, false, _)
    or
    iTo.(CopyInstruction).getSourceValueOperand() = opFrom
  }

  private predicate simpleOperandLocalFlowStep(Instruction iFrom, Operand opTo) {
    not opTo instanceof MemoryOperand and
    opTo.getDef() = iFrom
  }

  private predicate modelFlow(Node nodeFrom, Node nodeTo, string model) {
    exists(
      CallInstruction call, DataFlowFunction func, FunctionInput modelIn, FunctionOutput modelOut
    |
      call.getStaticCallTarget() = func and
      func.hasDataFlow(modelIn, modelOut) and
      model = "DataFlowFunction"
    |
      nodeFrom = callInput(call, modelIn) and
      nodeTo = callOutput(call, modelOut)
      or
      exists(int d |
        nodeFrom = callInput(call, modelIn, d) and
        nodeTo = callOutput(call, modelOut, d)
      )
    )
  }

  private predicate reverseFlow(Node nodeFrom, Node nodeTo) {
    reverseFlowOperand(nodeFrom, nodeTo)
    or
    reverseFlowInstruction(nodeFrom, nodeTo)
  }

  private predicate reverseFlowOperand(Node nodeFrom, IndirectReturnOutNode nodeTo) {
    exists(Operand address, int indirectionIndex |
      nodeHasOperand(nodeTo, address, indirectionIndex)
    |
      exists(StoreInstruction store |
        nodeHasInstruction(nodeFrom, store, indirectionIndex - 1) and
        store.getDestinationAddressOperand() = address
      )
      or
      // We also want a write coming out of an `OutNode` to flow `nodeTo`.
      // This is different from `reverseFlowInstruction` since `nodeFrom` can never
      // be an `OutNode` when it's defined by an instruction.
      SsaImpl::outNodeHasAddressAndIndex(nodeFrom, address, indirectionIndex)
    )
  }

  private predicate reverseFlowInstruction(Node nodeFrom, IndirectReturnOutNode nodeTo) {
    exists(Instruction address, int indirectionIndex |
      nodeHasInstruction(nodeTo, address, indirectionIndex)
    |
      exists(StoreInstruction store |
        nodeHasInstruction(nodeFrom, store, indirectionIndex - 1) and
        store.getDestinationAddress() = address
      )
    )
  }

  /**
   * Holds if `n` is an indirect operand of a `PointerArithmeticInstruction`, and
   * `e` is the result of loading from the `PointerArithmeticInstruction`.
   */
  private predicate isIndirectBaseOfArrayAccess(IndirectOperand n, Expr e) {
    exists(LoadInstruction load, PointerArithmeticInstruction pai |
      pai = load.getSourceAddress() and
      n.hasOperandAndIndirectionIndex(pai.getLeftOperand(), 1) and
      e = load.getConvertedResultExpression()
    )
  }

  /**
   * Gets the expression associated with node `n`, if any.
   *
   * Unlike `n.asExpr()`, this predicate will also get the
   * expression `*(x + i)` when `n` is the indirect node
   * for `x`. This ensures that an assignment in a long chain
   * of assignments in a macro expansion is properly mapped
   * to the previous assignment. For example, in:
   * ```cpp
   * *x = source();
   * use(x[0]);
   * use(x[1]);
   * ...
   * use(x[i]);
   * use(x[i+1]);
   * ...
   * use(x[N]);
   * ```
   * To see what the problem would be if `asExpr(n)` was replaced
   * with `n.asExpr()`, consider the transitive closure over
   * `localStepFromNonExpr` in `localStepsToExpr`. We start at `n2`
   * for which `n.asExpr()` exists. For example, `n2` in the above
   * example could be a `x[i]` in any of the `use(x[i])` above.
   *
   * We then step to a dataflow predecessor of `n2`. In the above
   * code fragment, thats the indirect node corresponding to `x` in
   * `x[i-1]`. Since this doesn't have a result for `Node::asExpr()`
   * we continue with the recursion until we reach `*x = source()`
   * which does have a result for `Node::asExpr()`.
   *
   * If `N` is very large this blows up.
   *
   * To fix this, we map the indirect node corresponding to `x` to
   * in `x[i - 1]` to the `x[i - 1]` expression. This ensures that
   * `x[i]` steps to the expression `x[i - 1]` without traversing the
   * entire chain.
   */
  private Expr asExprInternal(Node n) {
    isIndirectBaseOfArrayAccess(n, result)
    or
    not isIndirectBaseOfArrayAccess(n, _) and
    result = n.asExpr()
  }

  /**
   * Holds if `asExpr(n1)` doesn't have a result and `n1` flows to `n2` in a single
   * dataflow step.
   */
  private predicate localStepFromNonExpr(Node n1, Node n2) {
    not exists(asExprInternal(n1)) and
    localFlowStep(n1, n2)
  }

  /**
   * Holds if `asExpr(n1)` doesn't have a result, `asExpr(n2) = e2` and
   * `n2` is the first node reachable from `n1` such that `asExpr(n2)` exists.
   */
  pragma[nomagic]
  private predicate localStepsToExpr(Node n1, Node n2, Expr e2) {
    localStepFromNonExpr*(n1, n2) and
    e2 = asExprInternal(n2)
  }

  /**
   * Holds if `asExpr(n1) = e1` and `asExpr(n2) = e2` and `n2` is the first node
   * reachable from `n1` such that `asExpr(n2)` exists.
   */
  private predicate localExprFlowSingleExprStep(Node n1, Expr e1, Node n2, Expr e2) {
    exists(Node mid |
      localFlowStep(n1, mid) and
      localStepsToExpr(mid, n2, e2) and
      e1 = asExprInternal(n1)
    )
  }

  /**
   * Holds if `asExpr(n1) = e1` and `e1 != e2` and `n2` is the first reachable node from
   * `n1` such that `asExpr(n2) = e2`.
   */
  private predicate localExprFlowStepImpl(Node n1, Expr e1, Node n2, Expr e2) {
    exists(Node n, Expr e | localExprFlowSingleExprStep(n1, e1, n, e) |
      // If `n.asExpr()` and `n1.asExpr()` both resolve to the same node (which can
      // happen if `n2` is the node attached to a conversion of `e1`), then we recursively
      // perform another expression step.
      if e1 = e
      then localExprFlowStepImpl(n, e, n2, e2)
      else (
        // If we manage to step to a different expression we're done.
        e2 = e and
        n2 = n
      )
    )
  }

  /** Holds if data can flow from `e1` to `e2` in one local (intra-procedural) step. */
  cached
  predicate localExprFlowStep(Expr e1, Expr e2) { localExprFlowStepImpl(_, e1, _, e2) }
}

import Cached

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `i1` to `i2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localInstructionFlow(Instruction e1, Instruction e2) {
  localFlow(instructionNode(e1), instructionNode(e2))
}

/**
 * Holds if data can flow from `e1` to `e2` in one or more
 * local (intra-procedural) steps.
 */
pragma[inline]
private predicate localExprFlowPlus(Expr e1, Expr e2) = fastTC(localExprFlowStep/2)(e1, e2)

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprFlow(Expr e1, Expr e2) {
  e1 = e2
  or
  localExprFlowPlus(e1, e2)
}

/**
 * A description of the way data may be stored inside an object. Examples
 * include instance fields, the contents of a collection object, or the contents
 * of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden in subclasses

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }

  /** Gets the indirection index of this `Content`. */
  int getIndirectionIndex() { none() } // overridden in subclasses

  /**
   * INTERNAL: Do not use.
   *
   * Holds if a write to this `Content` implies that `c` is
   * also cleared.
   *
   * For example, a write to a field `f` implies that any content of
   * the form `*f` is also cleared.
   */
  predicate impliesClearOf(Content c) { none() } // overridden in subclasses
}

/**
 * Gets a string consisting of `n` star characters ("*"), where n >= 0. This is
 * used to represent indirection.
 */
bindingset[n]
string repeatStars(int n) { result = concat(int i | i in [1 .. n] | "*") }

private module ContentStars {
  /**
   * Gets the number of stars (i.e., `*`s) needed to produce the `toString`
   * output for `c`.
   */
  string contentStars(Content c) { result = repeatStars(c.getIndirectionIndex() - 1) }
}

private import ContentStars

private class TFieldContent = TNonUnionContent or TUnionContent;

/**
 * A `Content` that references a `Field`. This may be a field of a `struct`,
 * `class`, or `union`. In the case of a `union` there may be multiple fields
 * associated with the same `Content`.
 */
class FieldContent extends Content, TFieldContent {
  /** Gets a `Field` of this `Content`. */
  Field getAField() { none() }

  /**
   * Gets the field associated with this `Content`, if a unique one exists.
   *
   * For fields from template instantiations this predicate may still return
   * more than one field, but all the fields will be constructed from the same
   * template.
   */
  Field getField() { none() } // overridden in subclasses

  override int getIndirectionIndex() { none() } // overridden in subclasses

  override string toString() { none() } // overridden in subclasses

  override predicate impliesClearOf(Content c) { none() } // overridden in subclasses
}

/** A reference through a non-union instance field. */
class NonUnionFieldContent extends FieldContent, TNonUnionContent {
  private CanonicalField f;
  private int indirectionIndex;

  NonUnionFieldContent() { this = TNonUnionContent(f, indirectionIndex) }

  override string toString() { result = contentStars(this) + f.toString() }

  final override Field getField() { result = f.getAField() }

  override Field getAField() { result = this.getField() }

  /** Gets the indirection index of this `FieldContent`. */
  override int getIndirectionIndex() { result = indirectionIndex }

  override predicate impliesClearOf(Content c) {
    exists(int i |
      c = TNonUnionContent(f, i) and
      // If `this` is `f` then `c` is cleared if it's of the
      // form `*f`, `**f`, etc.
      i >= indirectionIndex
    )
  }
}

/** A reference through an instance field of a union. */
class UnionContent extends FieldContent, TUnionContent {
  private CanonicalUnion u;
  private int indirectionIndex;
  private int bytes;

  UnionContent() { this = TUnionContent(u, bytes, indirectionIndex) }

  override string toString() { result = contentStars(this) + u.toString() }

  final override Field getField() { result = unique( | | u.getACanonicalField()).getAField() }

  /** Gets a field of the underlying union of this `UnionContent`, if any. */
  override Field getAField() {
    exists(CanonicalField cf |
      cf = u.getACanonicalField() and
      result = cf.getAField() and
      getFieldSize(cf) = bytes
    )
  }

  /** Gets the underlying union of this `UnionContent`. */
  Union getUnion() { result = u.getAUnion() }

  /** Gets the indirection index of this `UnionContent`. */
  override int getIndirectionIndex() { result = indirectionIndex }

  override predicate impliesClearOf(Content c) {
    exists(int i |
      c = TUnionContent(u, _, i) and
      // If `this` is `u` then `c` is cleared if it's of the
      // form `*u`, `**u`, etc. (and we ignore `bytes` because
      // we know the entire union is overwritten because it's a
      // union).
      i >= indirectionIndex
    )
  }
}

/**
 * A `Content` that represents one of the elements of a
 * container (e.g., `std::vector`).
 */
class ElementContent extends Content, TElementContent {
  int indirectionIndex;

  ElementContent() { this = TElementContent(indirectionIndex) }

  override int getIndirectionIndex() { result = indirectionIndex }

  override predicate impliesClearOf(Content c) { none() }

  override string toString() { result = contentStars(this) + "element" }
}

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet instanceof Content {
  /**
   * Holds if this content set is the singleton `{c}`. At present, this is
   * the only kind of content set supported in C/C++.
   */
  predicate isSingleton(Content c) { this = c }

  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { result = this }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { result = this }

  /** Gets a textual representation of this content set. */
  string toString() { result = super.toString() }

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
    super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private signature class ParamSig;

private module WithParam<ParamSig P> {
  /**
   * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
   *
   * The expression `e` is expected to be a syntactic part of the guard `g`.
   * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
   * the argument `x`.
   */
  signature predicate guardChecksSig(IRGuardCondition g, Expr e, boolean branch, P param);
}

/**
 * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(IRGuardCondition g, Expr e, boolean branch);

bindingset[g]
pragma[inline_late]
private predicate controls(IRGuardCondition g, Node n, boolean edge) {
  g.controls(n.getBasicBlock(), edge)
}

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module ParameterizedBarrierGuard<ParamSig P, WithParam<P>::guardChecksSig/4 guardChecks> {
  bindingset[value, n]
  pragma[inline_late]
  private predicate convertedExprHasValueNumber(ValueNumber value, Node n) {
    exists(Expr e |
      e = value.getAnInstruction().getConvertedResultExpression() and
      n.asConvertedExpr() = e
    )
  }

  private predicate guardChecksNode(IRGuardCondition g, Node n, boolean branch, P p) {
    guardChecks(g, n.asOperand().getDef().getConvertedResultExpression(), branch, p)
  }

  /**
   * Gets an expression node that is safely guarded by the given guard check
   * when the parameter is `p`.
   *
   * For example, given the following code:
   * ```cpp
   * int x = source();
   * // ...
   * if(is_safe_int(x)) {
   *   sink(x);
   * }
   * ```
   * and the following barrier guard predicate:
   * ```ql
   * predicate myGuardChecks(IRGuardCondition g, Expr e, boolean branch) {
   *   exists(Call call |
   *     g.getUnconvertedResultExpression() = call and
   *     call.getTarget().hasName("is_safe_int") and
   *     e = call.getAnArgument() and
   *     branch = true
   *   )
   * }
   * ```
   * implementing `isBarrier` as:
   * ```ql
   * predicate isBarrier(DataFlow::Node barrier) {
   *   barrier = DataFlow::BarrierGuard<myGuardChecks/3>::getABarrierNode()
   * }
   * ```
   * will block flow from `x = source()` to `sink(x)`.
   *
   * NOTE: If an indirect expression is tracked, use `getAnIndirectBarrierNode` instead.
   */
  Node getABarrierNode(P p) {
    exists(IRGuardCondition g, ValueNumber value, boolean edge |
      convertedExprHasValueNumber(value, result) and
      guardChecks(g,
        pragma[only_bind_into](value.getAnInstruction().getConvertedResultExpression()), edge, p) and
      controls(g, result, edge)
    )
    or
    result = SsaImpl::BarrierGuard<P, guardChecksNode/4>::getABarrierNode(p)
  }

  /**
   * Gets an expression node that is safely guarded by the given guard check.
   *
   * See `getABarrierNode/1` for examples.
   */
  Node getABarrierNode() { result = getABarrierNode(_) }

  /**
   * Gets an indirect expression node that is safely guarded by the given
   * guard check with parameter `p`.
   *
   * For example, given the following code:
   * ```cpp
   * int* p;
   * // ...
   * *p = source();
   * if(is_safe_pointer(p)) {
   *   sink(*p);
   * }
   * ```
   * and the following barrier guard check:
   * ```ql
   * predicate myGuardChecks(IRGuardCondition g, Expr e, boolean branch) {
   *   exists(Call call |
   *     g.getUnconvertedResultExpression() = call and
   *     call.getTarget().hasName("is_safe_pointer") and
   *     e = call.getAnArgument() and
   *     branch = true
   *   )
   * }
   * ```
   * implementing `isBarrier` as:
   * ```ql
   * predicate isBarrier(DataFlow::Node barrier) {
   *   barrier = DataFlow::BarrierGuard<myGuardChecks/3>::getAnIndirectBarrierNode()
   * }
   * ```
   * will block flow from `x = source()` to `sink(x)`.
   *
   * NOTE: If a non-indirect expression is tracked, use `getABarrierNode` instead.
   */
  Node getAnIndirectBarrierNode(P p) { result = getAnIndirectBarrierNode(_, p) }

  /**
   * Gets an indirect expression node that is safely guarded by the given guard check.
   *
   * See `getAnIndirectBarrierNode/1` for examples.
   */
  Node getAnIndirectBarrierNode() { result = getAnIndirectBarrierNode(_) }

  bindingset[value, n]
  pragma[inline_late]
  private predicate indirectConvertedExprHasValueNumber(
    int indirectionIndex, ValueNumber value, Node n
  ) {
    exists(Expr e |
      e = value.getAnInstruction().getConvertedResultExpression() and
      n.asIndirectConvertedExpr(indirectionIndex) = e
    )
  }

  private predicate guardChecksIndirectNode(
    IRGuardCondition g, Node n, boolean branch, int indirectionIndex, P p
  ) {
    guardChecks(g, n.asIndirectOperand(indirectionIndex).getDef().getConvertedResultExpression(),
      branch, p)
  }

  /**
   * Gets an indirect expression node with indirection index `indirectionIndex` that is
   * safely guarded by the given guard check.
   *
   * For example, given the following code:
   * ```cpp
   * int* p;
   * // ...
   * *p = source();
   * if(is_safe_pointer(p)) {
   *   sink(*p);
   * }
   * ```
   * and the following barrier guard check:
   * ```ql
   * predicate myGuardChecks(IRGuardCondition g, Expr e, boolean branch) {
   *   exists(Call call |
   *     g.getUnconvertedResultExpression() = call and
   *     call.getTarget().hasName("is_safe_pointer") and
   *     e = call.getAnArgument() and
   *     branch = true
   *   )
   * }
   * ```
   * implementing `isBarrier` as:
   * ```ql
   * predicate isBarrier(DataFlow::Node barrier) {
   *   barrier = DataFlow::BarrierGuard<myGuardChecks/3>::getAnIndirectBarrierNode(1)
   * }
   * ```
   * will block flow from `x = source()` to `sink(x)`.
   *
   * NOTE: If a non-indirect expression is tracked, use `getABarrierNode` instead.
   */
  Node getAnIndirectBarrierNode(int indirectionIndex, P p) {
    exists(IRGuardCondition g, ValueNumber value, boolean edge |
      indirectConvertedExprHasValueNumber(indirectionIndex, value, result) and
      guardChecks(g,
        pragma[only_bind_into](value.getAnInstruction().getConvertedResultExpression()), edge, p) and
      controls(g, result, edge)
    )
    or
    result =
      SsaImpl::BarrierGuardWithIntParam<P, guardChecksIndirectNode/5>::getABarrierNode(indirectionIndex,
        p)
  }
}

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  private predicate guardChecks(IRGuardCondition g, Expr e, boolean branch, Unit unit) {
    guardChecks(g, e, branch) and
    exists(unit)
  }

  private module P = ParameterizedBarrierGuard<Unit, guardChecks/4>;

  predicate getABarrierNode = P::getABarrierNode/0;

  /**
   * Gets an indirect expression node with indirection index `indirectionIndex` that is
   * safely guarded by the given guard check.
   *
   * For example, given the following code:
   * ```cpp
   * int* p;
   * // ...
   * *p = source();
   * if(is_safe_pointer(p)) {
   *   sink(*p);
   * }
   * ```
   * and the following barrier guard check:
   * ```ql
   * predicate myGuardChecks(IRGuardCondition g, Expr e, boolean branch) {
   *   exists(Call call |
   *     g.getUnconvertedResultExpression() = call and
   *     call.getTarget().hasName("is_safe_pointer") and
   *     e = call.getAnArgument() and
   *     branch = true
   *   )
   * }
   * ```
   * implementing `isBarrier` as:
   * ```ql
   * predicate isBarrier(DataFlow::Node barrier) {
   *   barrier = DataFlow::BarrierGuard<myGuardChecks/3>::getAnIndirectBarrierNode(1)
   * }
   * ```
   * will block flow from `x = source()` to `sink(x)`.
   *
   * NOTE: If a non-indirect expression is tracked, use `getABarrierNode` instead.
   */
  Node getAnIndirectBarrierNode(int indirectionIndex) {
    result = P::getAnIndirectBarrierNode(indirectionIndex, _)
  }

  /**
   * Gets an indirect expression node that is safely guarded by the given guard check.
   *
   * See `getAnIndirectBarrierNode/1` for examples.
   */
  Node getAnIndirectBarrierNode() { result = getAnIndirectBarrierNode(_) }
}

private module InstrWithParam<ParamSig P> {
  /**
   * Holds if the guard `g` validates the instruction `instr` upon evaluating to `branch`.
   */
  signature predicate instructionGuardChecksSig(
    IRGuardCondition g, Instruction instr, boolean branch, P p
  );
}

/**
 * Holds if the guard `g` validates the instruction `instr` upon evaluating to `branch`.
 */
signature predicate instructionGuardChecksSig(IRGuardCondition g, Instruction instr, boolean branch);

/**
 * Provides a set of barrier nodes for a guard that validates an instruction.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module ParameterizedInstructionBarrierGuard<
  ParamSig P, InstrWithParam<P>::instructionGuardChecksSig/4 instructionGuardChecks>
{
  bindingset[value, n]
  pragma[inline_late]
  private predicate operandHasValueNumber(ValueNumber value, Node n) {
    exists(Operand use |
      use = value.getAnInstruction().getAUse() and
      n.asOperand() = use
    )
  }

  private predicate guardChecksNode(IRGuardCondition g, Node n, boolean branch, P p) {
    instructionGuardChecks(g, n.asOperand().getDef(), branch, p)
  }

  /**
   * Gets a node that is safely guarded by the given guard check with
   * parameter `p`.
   */
  Node getABarrierNode(P p) {
    exists(IRGuardCondition g, ValueNumber value, boolean edge |
      instructionGuardChecks(g, pragma[only_bind_into](value.getAnInstruction()), edge, p) and
      operandHasValueNumber(value, result) and
      controls(g, result, edge)
    )
    or
    result = SsaImpl::BarrierGuard<P, guardChecksNode/4>::getABarrierNode(p)
  }

  /** Gets a node that is safely guarded by the given guard check. */
  Node getABarrierNode() { result = getABarrierNode(_) }

  bindingset[value, n]
  pragma[inline_late]
  private predicate indirectOperandHasValueNumber(ValueNumber value, int indirectionIndex, Node n) {
    exists(Operand use |
      use = value.getAnInstruction().getAUse() and
      n.asIndirectOperand(indirectionIndex) = use
    )
  }

  private predicate guardChecksIndirectNode(
    IRGuardCondition g, Node n, boolean branch, int indirectionIndex, P p
  ) {
    instructionGuardChecks(g, n.asIndirectOperand(indirectionIndex).getDef(), branch, p)
  }

  /**
   * Gets an indirect node with indirection index `indirectionIndex` that is
   * safely guarded by the given guard check with parameter `p`.
   */
  Node getAnIndirectBarrierNode(int indirectionIndex, P p) {
    exists(IRGuardCondition g, ValueNumber value, boolean edge |
      instructionGuardChecks(g, pragma[only_bind_into](value.getAnInstruction()), edge, p) and
      indirectOperandHasValueNumber(value, indirectionIndex, result) and
      controls(g, result, edge)
    )
    or
    result =
      SsaImpl::BarrierGuardWithIntParam<P, guardChecksIndirectNode/5>::getABarrierNode(indirectionIndex,
        p)
  }

  /**
   * Gets an indirect node that is safely guarded by the given guard check
   * with parameter `p`.
   */
  Node getAnIndirectBarrierNode(P p) { result = getAnIndirectBarrierNode(_, p) }

  /** Gets an indirect node that is safely guarded by the given guard check. */
  Node getAnIndirectBarrierNode() { result = getAnIndirectBarrierNode(_) }
}

/**
 * Provides a set of barrier nodes for a guard that validates an instruction.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module InstructionBarrierGuard<instructionGuardChecksSig/3 instructionGuardChecks> {
  private predicate instructionGuardChecks(
    IRGuardCondition g, Instruction i, boolean branch, Unit unit
  ) {
    instructionGuardChecks(g, i, branch) and
    exists(unit)
  }

  private module P = ParameterizedInstructionBarrierGuard<Unit, instructionGuardChecks/4>;

  predicate getABarrierNode = P::getABarrierNode/0;

  /**
   * Gets an indirect node with indirection index `indirectionIndex` that is
   * safely guarded by the given guard check.
   */
  Node getAnIndirectBarrierNode(int indirectionIndex) {
    result = P::getAnIndirectBarrierNode(indirectionIndex, _)
  }

  /** Gets an indirect node that is safely guarded by the given guard check. */
  Node getAnIndirectBarrierNode() { result = getAnIndirectBarrierNode(_) }
}

/**
 * A unit class for adding additional call steps.
 *
 * Extend this class to add additional call steps to the data flow graph.
 *
 * For example, if the following subclass is added:
 * ```ql
 * class MyAdditionalCallTarget extends DataFlow::AdditionalCallTarget {
 *   override Function viableTarget(Call call) {
 *     call.getTarget().hasName("f") and
 *     result.hasName("g")
 *   }
 * }
 * ```
 * then flow from `source()` to `x` in `sink(x)` is reported in the following example:
 * ```cpp
 * void sink(int);
 * int source();
 * void f(int);
 *
 * void g(int x) {
 *   sink(x);
 * }
 *
 * void test() {
 *   int x = source();
 *   f(x);
 * }
 * ```
 *
 * Note: To prevent reevaluation of cached dataflow-related predicates any
 * subclass of `AdditionalCallTarget` must be imported in all dataflow queries.
 */
class AdditionalCallTarget extends Unit {
  /**
   * Gets a viable target for `call`.
   */
  abstract Declaration viableTarget(Call call);
}

/**
 * Gets a function that may be called by `call`.
 *
 * Note that `call` may be a call to a function pointer expression.
 */
Function getARuntimeTarget(Call call) {
  exists(DataFlowCall dfCall | dfCall.asCallInstruction().getUnconvertedResultExpression() = call |
    result = DataFlowDispatch::viableCallable(dfCall).asSourceCallable()
    or
    result = DataFlowImplCommon::viableCallableLambda(dfCall, _).asSourceCallable()
  )
}

/** A module that provides static single assignment (SSA) information. */
module Ssa {
  class Definition = SsaImpl::Definition;

  class ExplicitDefinition = SsaImpl::ExplicitDefinition;

  class DirectExplicitDefinition = SsaImpl::DirectExplicitDefinition;

  class IndirectExplicitDefinition = SsaImpl::IndirectExplicitDefinition;

  class PhiNode = SsaImpl::PhiNode;
}
