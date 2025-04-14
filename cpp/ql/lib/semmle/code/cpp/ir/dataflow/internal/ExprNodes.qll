/**
 * Provides the classes `ExprNode` and `IndirectExprNode` for converting between `Expr` and `Node`.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowPrivate
private import semmle.code.cpp.ir.implementation.raw.internal.TranslatedExpr
private import semmle.code.cpp.ir.implementation.raw.internal.InstructionTag

cached
private module Cached {
  private Operand getAnInitializeDynamicAllocationInstructionAddress() {
    result = any(InitializeDynamicAllocationInstruction init).getAllocationAddressOperand()
  }

  /**
   * Gets the expression that should be returned as the result expression from `instr`.
   *
   * Note that this predicate may return multiple results in cases where a conversion belongs to a
   * different AST element than its operand.
   */
  private Expr getConvertedResultExpression(Instruction instr, int n) {
    // Only fully converted instructions have a result for `asConvertedExpr`
    not conversionFlow(unique(Operand op |
        // The address operand of a `InitializeDynamicAllocationInstruction` is
        // special: we need to handle it during dataflow (since it's
        // effectively a store to an indirection), but it doesn't appear in
        // source syntax, so dataflow node <-> expression conversion shouldn't
        // care about it.
        op = getAUse(instr) and not op = getAnInitializeDynamicAllocationInstructionAddress()
      |
        op
      ), _, false, false) and
    result = getConvertedResultExpressionImpl(instr) and
    n = 0
    or
    // If the conversion also has a result then we return multiple results
    exists(Operand operand | conversionFlow(operand, instr, false, false) |
      n = 1 and
      result = getConvertedResultExpressionImpl(operand.getDef())
      or
      result = getConvertedResultExpression(operand.getDef(), n - 1)
    )
  }

  private Expr getConvertedResultExpressionImpl0(Instruction instr) {
    // IR construction inserts an additional cast to a `size_t` on the extent
    // of a `new[]` expression. The resulting `ConvertInstruction` doesn't have
    // a result for `getConvertedResultExpression`. We remap this here so that
    // this `ConvertInstruction` maps to the result of the expression that
    // represents the extent.
    exists(TranslatedNonConstantAllocationSize tas |
      result = tas.getExtent().getExpr() and
      instr = tas.getInstruction(AllocationExtentConvertTag())
    )
    or
    // There's no instruction that returns `ParenthesisExpr`, but some queries
    // expect this
    exists(TranslatedTransparentConversion ttc |
      result = ttc.getExpr().(ParenthesisExpr) and
      instr = ttc.getResult()
    )
    or
    // Certain expressions generate `CopyValueInstruction`s only when they
    // are needed. Examples of this include crement operations and compound
    // assignment operations. For example:
    // ```cpp
    // int x = ...
    // int y = x++;
    // ```
    // this generate IR like:
    // ```
    // r1(glval<int>) = VariableAddress[x] :
    // r2(int)        = Constant[0]        :
    // m3(int)        = Store[x]           : &:r1, r2
    // r4(glval<int>) = VariableAddress[y] :
    // r5(glval<int>) = VariableAddress[x] :
    // r6(int)        = Load[x]            : &:r5, m3
    // r7(int)        = Constant[1]        :
    // r8(int)        = Add                : r6, r7
    // m9(int)        = Store[x]           : &:r5, r8
    // r11(int)       = CopyValue         : r6
    // m12(int)       = Store[y]          : &:r4, r11
    // ```
    // When the `CopyValueInstruction` is not generated there is no instruction
    // whose `getConvertedResultExpression` maps back to the expression. When
    // such an instruction doesn't exist it means that the old value is not
    // needed, and in that case the only value that will propagate forward in
    // the program is the value that's been updated. So in those cases we just
    // use the result of `node.asDefinition()` as the result of `node.asExpr()`.
    exists(TranslatedCoreExpr tco |
      tco.getInstruction(_) = instr and
      tco.producesExprResult() and
      result = asDefinitionImpl0(instr)
    )
  }

  private Expr getConvertedResultExpressionImpl(Instruction instr) {
    result = getConvertedResultExpressionImpl0(instr)
    or
    not exists(getConvertedResultExpressionImpl0(instr)) and
    result = instr.getConvertedResultExpression()
  }

  /**
   * Gets the result for `node.asDefinition()` (when `node` is the instruction
   * node that wraps `store`) in the cases where `store.getAst()` should not be
   * used to define the result of `node.asDefinition()`.
   */
  private Expr asDefinitionImpl0(StoreInstruction store) {
    // For an expression such as `i += 2` we pretend that the generated
    // `StoreInstruction` contains the result of the expression even though
    // this isn't totally aligned with the C/C++ standard.
    exists(TranslatedAssignOperation tao |
      store = tao.getInstruction(AssignmentStoreTag()) and
      result = tao.getExpr()
    )
    or
    // Similarly for `i++` and `++i` we pretend that the generated
    // `StoreInstruction` is contains the result of the expression even though
    // this isn't totally aligned with the C/C++ standard.
    exists(TranslatedCrementOperation tco |
      store = tco.getInstruction(CrementStoreTag()) and
      result = tco.getExpr()
    )
  }

  /**
   * Holds if the expression returned by `store.getAst()` should not be
   * returned as the result of `node.asDefinition()` when `node` is the
   * instruction node that wraps `store`.
   */
  private predicate excludeAsDefinitionResult(StoreInstruction store) {
    // Exclude the store to the temporary generated by a ternary expression.
    exists(TranslatedConditionalExpr tce |
      store = tce.getInstruction(ConditionValueFalseStoreTag())
      or
      store = tce.getInstruction(ConditionValueTrueStoreTag())
    )
  }

  /**
   * Gets the expression that represents the result of `StoreInstruction` for
   * dataflow purposes.
   *
   * For example, consider the following example
   * ```cpp
   * int x = 42;     // 1
   * x = 34;         // 2
   * ++x;            // 3
   * x++;            // 4
   * x += 1;         // 5
   * int y = x += 2; // 6
   * ```
   * For (1) the result is `42`.
   * For (2) the result is `x = 34`.
   * For (3) the result is `++x`.
   * For (4) the result is `x++`.
   * For (5) the result is `x += 1`.
   * For (6) there are two results:
   *   - For the `StoreInstruction` generated by `x += 2` the result
   *     is `x += 2`
   *   - For the `StoreInstruction` generated by `int y = ...` the result
   *     is also `x += 2`
   */
  cached
  Expr asDefinitionImpl(StoreInstruction store) {
    not exists(asDefinitionImpl0(store)) and
    not excludeAsDefinitionResult(store) and
    result = store.getAst().(Expr).getUnconverted()
    or
    result = asDefinitionImpl0(store)
  }

  /** Holds if `node` is an `OperandNode` that should map `node.asExpr()` to `e`. */
  private predicate exprNodeShouldBeOperand(OperandNode node, Expr e, int n) {
    not exprNodeShouldBeIndirectOperand(_, e, n) and
    exists(Instruction def |
      unique( | | getAUse(def)) = node.getOperand() and
      e = getConvertedResultExpression(def, n)
    )
  }

  /** Holds if `node` should be an `IndirectOperand` that maps `node.asIndirectExpr()` to `e`. */
  private predicate indirectExprNodeShouldBeIndirectOperand(
    IndirectOperand node, Expr e, int n, int indirectionIndex
  ) {
    exists(Instruction def |
      node.hasOperandAndIndirectionIndex(unique( | | getAUse(def)), indirectionIndex) and
      e = getConvertedResultExpression(def, n)
    )
  }

  /** Holds if `operand`'s definition is a `VariableAddressInstruction` whose variable is a temporary */
  private predicate isIRTempVariable(Operand operand) {
    operand.getDef().(VariableAddressInstruction).getIRVariable() instanceof IRTempVariable
  }

  /**
   * Holds if `node` is an indirect operand whose operand is an argument, and
   * the `n`'th expression associated with the operand is `e`.
   */
  private predicate isIndirectOperandOfArgument(
    IndirectOperand node, ArgumentOperand operand, Expr e, int n
  ) {
    node.hasOperandAndIndirectionIndex(operand, 1) and
    e = getConvertedResultExpression(operand.getDef(), n)
  }

  /**
   * Holds if `opFrom` is an operand to a conversion, and `opTo` is the unique
   * use of the conversion.
   */
  private predicate isConversionStep(Operand opFrom, Operand opTo) {
    exists(Instruction mid |
      conversionFlow(opFrom, mid, false, false) and
      opTo = unique( | | getAUse(mid))
    )
  }

  /**
   * Holds if an operand that satisfies `isIRTempVariable` flows to `op`
   * through a (possibly empty) sequence of conversions.
   */
  private predicate irTempOperandConversionFlows(Operand op) {
    isIRTempVariable(op)
    or
    exists(Operand mid |
      irTempOperandConversionFlows(mid) and
      isConversionStep(mid, op)
    )
  }

  /** Holds if `node` should be an `IndirectOperand` that maps `node.asExpr()` to `e`. */
  private predicate exprNodeShouldBeIndirectOperand(IndirectOperand node, Expr e, int n) {
    exists(ArgumentOperand operand |
      // When an argument (qualifier or positional) is a prvalue and the
      // parameter (qualifier or positional) is a (const) reference, IR
      // construction introduces a temporary `IRVariable`. The `VariableAddress`
      // instruction has the argument as its `getConvertedResultExpression`
      // result. However, the instruction actually represents the _address_ of
      // the argument. So to fix this mismatch, we have the indirection of the
      // `VariableAddressInstruction` map to the expression.
      isIndirectOperandOfArgument(node, operand, e, n) and
      irTempOperandConversionFlows(operand)
    )
  }

  private predicate exprNodeShouldBeIndirectOutNode(IndirectArgumentOutNode node, Expr e, int n) {
    exists(CallInstruction call |
      call.getStaticCallTarget() instanceof Constructor and
      e = getConvertedResultExpression(call, n) and
      call.getThisArgumentOperand() = node.getAddressOperand()
    )
  }

  /** Holds if `node` should be an instruction node that maps `node.asExpr()` to `e`. */
  private predicate exprNodeShouldBeInstruction(Node node, Expr e, int n) {
    not exprNodeShouldBeOperand(_, e, n) and
    not exprNodeShouldBeIndirectOutNode(_, e, n) and
    not exprNodeShouldBeIndirectOperand(_, e, n) and
    e = getConvertedResultExpression(node.asInstruction(), n)
  }

  /** Holds if `node` should be an `IndirectInstruction` that maps `node.asIndirectExpr()` to `e`. */
  private predicate indirectExprNodeShouldBeIndirectInstruction(
    IndirectInstruction node, Expr e, int n, int indirectionIndex
  ) {
    not indirectExprNodeShouldBeIndirectOperand(_, e, n, indirectionIndex) and
    exists(Instruction instr |
      node.hasInstructionAndIndirectionIndex(instr, indirectionIndex) and
      e = getConvertedResultExpression(instr, n)
    )
  }

  abstract private class ExprNodeBase extends Node {
    /**
     * Gets the expression corresponding to this node, if any. The returned
     * expression may be a `Conversion`.
     */
    abstract Expr getConvertedExpr(int n);

    /** Gets the non-conversion expression corresponding to this node, if any. */
    final Expr getExpr(int n) { result = this.getConvertedExpr(n).getUnconverted() }
  }

  /**
   * Holds if there exists a dataflow node whose `asExpr(n)` should evaluate
   * to `e`.
   */
  private predicate exprNodeShouldBe(Expr e, int n) {
    exprNodeShouldBeInstruction(_, e, n) or
    exprNodeShouldBeOperand(_, e, n) or
    exprNodeShouldBeIndirectOutNode(_, e, n) or
    exprNodeShouldBeIndirectOperand(_, e, n)
  }

  private class InstructionExprNode extends ExprNodeBase, InstructionNode {
    InstructionExprNode() {
      exists(Expr e, int n |
        exprNodeShouldBeInstruction(this, e, n) and
        not exists(Expr conv |
          exprNodeShouldBe(conv, n + 1) and
          conv.getUnconverted() = e.getUnconverted()
        )
      )
    }

    final override Expr getConvertedExpr(int n) { exprNodeShouldBeInstruction(this, result, n) }
  }

  private class OperandExprNode extends ExprNodeBase, OperandNode {
    OperandExprNode() {
      exists(Expr e, int n |
        exprNodeShouldBeOperand(this, e, n) and
        not exists(Expr conv |
          exprNodeShouldBe(conv, n + 1) and
          conv.getUnconverted() = e.getUnconverted()
        )
      )
    }

    final override Expr getConvertedExpr(int n) { exprNodeShouldBeOperand(this, result, n) }
  }

  abstract private class IndirectExprNodeBase extends Node {
    /**
     * Gets the expression corresponding to this node, if any. The returned
     * expression may be a `Conversion`.
     */
    abstract Expr getConvertedExpr(int n, int indirectionIndex);

    /** Gets the non-conversion expression corresponding to this node, if any. */
    final Expr getExpr(int n, int indirectionIndex) {
      result = this.getConvertedExpr(n, indirectionIndex).getUnconverted()
    }
  }

  /** A signature for converting an indirect node to an expression. */
  private signature module IndirectNodeToIndirectExprSig {
    /** The indirect node class to be converted to an expression */
    class IndirectNode;

    /**
     * Holds if the indirect expression at indirection index `indirectionIndex`
     * of `node` is `e`. The integer `n` specifies how many conversions has been
     * applied to `node`.
     */
    predicate indirectNodeHasIndirectExpr(IndirectNode node, Expr e, int n, int indirectionIndex);
  }

  /**
   * A module that implements the logic for deciding whether an indirect node
   * should be an `IndirectExprNode`.
   */
  private module IndirectNodeToIndirectExpr<IndirectNodeToIndirectExprSig Sig> {
    import Sig

    /**
     * This predicate shifts the indirection index by one when `conv` is a
     * `ReferenceDereferenceExpr`.
     *
     * This is necessary because `ReferenceDereferenceExpr` is a conversion
     * in the AST, but appears as a `LoadInstruction` in the IR.
     */
    bindingset[e, indirectionIndex]
    private predicate adjustForReference(
      Expr e, int indirectionIndex, Expr conv, int adjustedIndirectionIndex
    ) {
      conv.(ReferenceDereferenceExpr).getExpr() = e and
      adjustedIndirectionIndex = indirectionIndex - 1
      or
      not conv instanceof ReferenceDereferenceExpr and
      conv = e and
      adjustedIndirectionIndex = indirectionIndex
    }

    /** Holds if `node` should be an `IndirectExprNode`. */
    predicate charpred(IndirectNode node) {
      exists(Expr e, int n, int indirectionIndex |
        indirectNodeHasIndirectExpr(node, e, n, indirectionIndex) and
        not exists(Expr conv, int adjustedIndirectionIndex |
          adjustForReference(e, indirectionIndex, conv, adjustedIndirectionIndex) and
          indirectExprNodeShouldBe(conv, n + 1, adjustedIndirectionIndex)
        )
      )
    }
  }

  private predicate indirectExprNodeShouldBe(Expr e, int n, int indirectionIndex) {
    indirectExprNodeShouldBeIndirectOperand(_, e, n, indirectionIndex) or
    indirectExprNodeShouldBeIndirectInstruction(_, e, n, indirectionIndex)
  }

  private module IndirectOperandIndirectExprNodeImpl implements IndirectNodeToIndirectExprSig {
    class IndirectNode = IndirectOperand;

    predicate indirectNodeHasIndirectExpr = indirectExprNodeShouldBeIndirectOperand/4;
  }

  module IndirectOperandToIndirectExpr =
    IndirectNodeToIndirectExpr<IndirectOperandIndirectExprNodeImpl>;

  private class IndirectOperandIndirectExprNode extends IndirectExprNodeBase instanceof IndirectOperand
  {
    IndirectOperandIndirectExprNode() { IndirectOperandToIndirectExpr::charpred(this) }

    final override Expr getConvertedExpr(int n, int index) {
      IndirectOperandToIndirectExpr::indirectNodeHasIndirectExpr(this, result, n, index)
    }
  }

  private module IndirectInstructionIndirectExprNodeImpl implements IndirectNodeToIndirectExprSig {
    class IndirectNode = IndirectInstruction;

    predicate indirectNodeHasIndirectExpr = indirectExprNodeShouldBeIndirectInstruction/4;
  }

  module IndirectInstructionToIndirectExpr =
    IndirectNodeToIndirectExpr<IndirectInstructionIndirectExprNodeImpl>;

  private class IndirectInstructionIndirectExprNode extends IndirectExprNodeBase instanceof IndirectInstruction
  {
    IndirectInstructionIndirectExprNode() { IndirectInstructionToIndirectExpr::charpred(this) }

    final override Expr getConvertedExpr(int n, int index) {
      IndirectInstructionToIndirectExpr::indirectNodeHasIndirectExpr(this, result, n, index)
    }
  }

  private class IndirectArgumentOutExprNode extends ExprNodeBase, IndirectArgumentOutNode {
    IndirectArgumentOutExprNode() { exprNodeShouldBeIndirectOutNode(this, _, _) }

    final override Expr getConvertedExpr(int n) { exprNodeShouldBeIndirectOutNode(this, result, n) }
  }

  private class IndirectOperandExprNode extends ExprNodeBase instanceof IndirectOperand {
    IndirectOperandExprNode() { exprNodeShouldBeIndirectOperand(this, _, _) }

    final override Expr getConvertedExpr(int n) { exprNodeShouldBeIndirectOperand(this, result, n) }
  }

  /**
   * An expression, viewed as a node in a data flow graph.
   */
  cached
  class ExprNode extends Node instanceof ExprNodeBase {
    /**
     * INTERNAL: Do not use.
     */
    cached
    Expr getExpr(int n) { result = super.getExpr(n) }

    /**
     * Gets the non-conversion expression corresponding to this node, if any. If
     * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
     * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
     * expression.
     */
    cached
    final Expr getExpr() { result = this.getExpr(_) }

    /**
     * INTERNAL: Do not use.
     */
    cached
    Expr getConvertedExpr(int n) { result = super.getConvertedExpr(n) }

    /**
     * Gets the expression corresponding to this node, if any. The returned
     * expression may be a `Conversion`.
     */
    cached
    final Expr getConvertedExpr() { result = this.getConvertedExpr(_) }
  }

  /**
   * An indirect expression, viewed as a node in a data flow graph.
   */
  cached
  class IndirectExprNode extends Node instanceof IndirectExprNodeBase {
    /**
     * Gets the non-conversion expression corresponding to this node, if any. If
     * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
     * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
     * expression.
     */
    cached
    final Expr getExpr(int indirectionIndex) { result = this.getExpr(_, indirectionIndex) }

    /**
     * INTERNAL: Do not use.
     */
    cached
    Expr getExpr(int n, int indirectionIndex) { result = super.getExpr(n, indirectionIndex) }

    /**
     * INTERNAL: Do not use.
     */
    cached
    Expr getConvertedExpr(int n, int indirectionIndex) {
      result = super.getConvertedExpr(n, indirectionIndex)
    }

    /**
     * Gets the expression corresponding to this node, if any. The returned
     * expression may be a `Conversion`.
     */
    cached
    Expr getConvertedExpr(int indirectionIndex) {
      result = this.getConvertedExpr(_, indirectionIndex)
    }
  }
}

import Cached
