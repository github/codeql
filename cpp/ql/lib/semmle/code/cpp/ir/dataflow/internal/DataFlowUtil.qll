/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import DataFlowPrivate
private import ModelUtil
private import SsaInternals as Ssa
private import DataFlowImplCommon as DataFlowImplCommon
private import codeql.util.Unit
private import Node0ToString
import ExprNodes

/**
 * The IR dataflow graph consists of the following nodes:
 * - `Node0`, which injects most instructions and operands directly into the
 *    dataflow graph.
 * - `VariableNode`, which is used to model flow through global variables.
 * - `PostUpdateNodeImpl`, which is used to model the state of an object after
 *    an update after a number of loads.
 * - `SsaPhiNode`, which represents phi nodes as computed by the shared SSA
 *    library.
 * - `RawIndirectOperand`, which represents the value of `operand` after
 *    loading the address a number of times.
 * - `RawIndirectInstruction`, which represents the value of `instr` after
 *    loading the address a number of times.
 */
cached
private newtype TIRDataFlowNode =
  TNode0(Node0Impl node) { DataFlowImplCommon::forceCachingInSameStage() } or
  TGlobalLikeVariableNode(GlobalLikeVariable var, int indirectionIndex) {
    indirectionIndex =
      [getMinIndirectionsForType(var.getUnspecifiedType()) .. Ssa::getMaxIndirectionsForType(var.getUnspecifiedType())]
  } or
  TPostUpdateNodeImpl(Operand operand, int indirectionIndex) {
    operand = any(FieldAddress fa).getObjectAddressOperand() and
    indirectionIndex = [0 .. Ssa::countIndirectionsForCppType(Ssa::getLanguageType(operand))]
    or
    Ssa::isModifiableByCall(operand, indirectionIndex)
  } or
  TSsaPhiInputNode(Ssa::PhiNode phi, IRBlock input) { phi.hasInputFromBlock(_, _, _, _, input) } or
  TSsaPhiNode(Ssa::PhiNode phi) or
  TSsaIteratorNode(IteratorFlow::IteratorFlowNode n) or
  TRawIndirectOperand0(Node0Impl node, int indirectionIndex) {
    Ssa::hasRawIndirectOperand(node.asOperand(), indirectionIndex)
  } or
  TRawIndirectInstruction0(Node0Impl node, int indirectionIndex) {
    not exists(node.asOperand()) and
    Ssa::hasRawIndirectInstruction(node.asInstruction(), indirectionIndex)
  } or
  TFinalParameterNode(Parameter p, int indirectionIndex) {
    exists(Ssa::FinalParameterUse use |
      use.getParameter() = p and
      use.getIndirectionIndex() = indirectionIndex
    )
  } or
  TFinalGlobalValue(Ssa::GlobalUse globalUse) or
  TInitialGlobalValue(Ssa::GlobalDef globalUse) or
  TBodyLessParameterNodeImpl(Parameter p, int indirectionIndex) {
    // Rule out parameters of catch blocks.
    not exists(p.getCatchBlock()) and
    // We subtract one because `getMaxIndirectionsForType` returns the maximum
    // indirection for a glvalue of a given type, and this doesn't apply to
    // parameters.
    indirectionIndex = [0 .. Ssa::getMaxIndirectionsForType(p.getUnspecifiedType()) - 1] and
    not any(InitializeParameterInstruction init).getParameter() = p
  } or
  TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn)

/**
 * An operand that is defined by a `FieldAddressInstruction`.
 */
class FieldAddress extends Operand {
  FieldAddressInstruction fai;

  FieldAddress() { fai = this.getDef() and not Ssa::ignoreOperand(this) }

  /** Gets the field associated with this instruction. */
  Field getField() { result = fai.getField() }

  /** Gets the instruction whose result provides the address of the object containing the field. */
  Instruction getObjectAddress() { result = fai.getObjectAddress() }

  /** Gets the operand that provides the address of the object containing the field. */
  Operand getObjectAddressOperand() { result = fai.getObjectAddressOperand() }
}

/**
 * Holds if `opFrom` is an operand whose value flows to the result of `instrTo`.
 *
 * `isPointerArith` is `true` if `instrTo` is a `PointerArithmeticInstruction` and `opFrom`
 * is the left operand.
 *
 * `additional` is `true` if the conversion is supplied by an implementation of the
 * `Indirection` class. It is sometimes useful to exclude such conversions.
 */
predicate conversionFlow(
  Operand opFrom, Instruction instrTo, boolean isPointerArith, boolean additional
) {
  isPointerArith = false and
  (
    additional = false and
    (
      instrTo.(CopyValueInstruction).getSourceValueOperand() = opFrom
      or
      instrTo.(ConvertInstruction).getUnaryOperand() = opFrom
      or
      instrTo.(CheckedConvertOrNullInstruction).getUnaryOperand() = opFrom
      or
      instrTo.(InheritanceConversionInstruction).getUnaryOperand() = opFrom
      or
      exists(BuiltInInstruction builtIn |
        builtIn = instrTo and
        // __builtin_bit_cast
        builtIn.getBuiltInOperation() instanceof BuiltInBitCast and
        opFrom = builtIn.getAnOperand()
      )
    )
    or
    additional = true and
    Ssa::isAdditionalConversionFlow(opFrom, instrTo)
  )
  or
  isPointerArith = true and
  additional = false and
  instrTo.(PointerArithmeticInstruction).getLeftOperand() = opFrom
}

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
 */
class Node extends TIRDataFlowNode {
  /**
   * INTERNAL: Do not use.
   */
  Declaration getEnclosingCallable() { none() } // overridden in subclasses

  /** Gets the function to which this node belongs, if any. */
  Declaration getFunction() { none() } // overridden in subclasses

  /** Holds if this node represents a glvalue. */
  predicate isGLValue() { none() }

  /**
   * Gets the type of this node.
   *
   * If `isGLValue()` holds, then the type of this node
   * should be thought of as "pointer to `getType()`".
   */
  DataFlowType getType() { none() } // overridden in subclasses

  /** Gets the instruction corresponding to this node, if any. */
  Instruction asInstruction() { result = this.(InstructionNode).getInstruction() }

  /** Gets the operands corresponding to this node, if any. */
  Operand asOperand() { result = this.(OperandNode).getOperand() }

  /**
   * Gets the operand that is indirectly tracked by this node behind `index`
   * number of indirections.
   */
  Operand asIndirectOperand(int index) { hasOperandAndIndex(this, result, index) }

  /**
   * Holds if this node is at index `i` in basic block `block`.
   *
   * Note: Phi nodes are considered to be at index `-1`.
   */
  final predicate hasIndexInBlock(IRBlock block, int i) {
    this.asInstruction() = block.getInstruction(i)
    or
    this.asOperand().getUse() = block.getInstruction(i)
    or
    this.(SsaPhiNode).getPhiNode().getBasicBlock() = block and i = -1
    or
    this.(SsaPhiInputNode).getBlock() = block and
    i = block.getInstructionCount()
    or
    this.(RawIndirectOperand).getOperand().getUse() = block.getInstruction(i)
    or
    this.(RawIndirectInstruction).getInstruction() = block.getInstruction(i)
    or
    this.(PostUpdateNode).getPreUpdateNode().hasIndexInBlock(block, i)
  }

  /** Gets the basic block of this node, if any. */
  final IRBlock getBasicBlock() { this.hasIndexInBlock(result, _) }

  /**
   * Gets the non-conversion expression corresponding to this node, if any.
   * This predicate only has a result on nodes that represent the value of
   * evaluating the expression. For data flowing _out of_ an expression, like
   * when an argument is passed by reference, use `asDefiningArgument` instead
   * of `asExpr`.
   *
   * If this node strictly (in the sense of `asConvertedExpr`) corresponds to
   * a `Conversion`, then the result is the underlying non-`Conversion` base
   * expression.
   */
  Expr asExpr() { result = this.asExpr(_) }

  /**
   * INTERNAL: Do not use.
   */
  Expr asExpr(int n) { result = this.(ExprNode).getExpr(n) }

  /**
   * INTERNAL: Do not use.
   */
  Expr asIndirectExpr(int n, int index) { result = this.(IndirectExprNode).getExpr(n, index) }

  /**
   * Gets the non-conversion expression that's indirectly tracked by this node
   * under `index` number of indirections.
   */
  Expr asIndirectExpr(int index) { result = this.asIndirectExpr(_, index) }

  /**
   * Gets the non-conversion expression that's indirectly tracked by this node
   * behind a number of indirections.
   */
  Expr asIndirectExpr() { result = this.asIndirectExpr(_) }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.asConvertedExpr(_) }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr(int n) { result = this.(ExprNode).getConvertedExpr(n) }

  /**
   * INTERNAL: Do not use.
   */
  Expr asIndirectConvertedExpr(int n, int index) {
    result = this.(IndirectExprNode).getConvertedExpr(n, index)
  }

  /**
   * Gets the expression that's indirectly tracked by this node
   * behind `index` number of indirections.
   */
  Expr asIndirectConvertedExpr(int index) { result = this.asIndirectConvertedExpr(_, index) }

  /**
   * Gets the expression that's indirectly tracked by this node behind a
   * number of indirections.
   */
  Expr asIndirectConvertedExpr() { result = this.asIndirectConvertedExpr(_) }

  /**
   * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
   * This predicate should be used instead of `asExpr` when referring to the
   * value of a reference argument _after_ the call has returned. For example,
   * in `f(&x)`, this predicate will have `&x` as its result for the `Node`
   * that represents the new value of `x`.
   */
  Expr asDefiningArgument() { result = this.asDefiningArgument(_) }

  /**
   * Gets the definition associated with this node, if any.
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
   * - For (1) the result is `42`.
   * - For (2) the result is `x = 34`.
   * - For (3) the result is `++x`.
   * - For (4) the result is `x++`.
   * - For (5) the result is `x += 1`.
   * - For (6) there are two results:
   *   - For the definition generated by `x += 2` the result is `x += 2`
   *   - For the definition generated by `int y = ...` the result is
   *     also `x += 2`.
   *
   * For assignments, `node.asDefinition()` and `node.asExpr()` will both exist
   * for the same dataflow node. However, for expression such as `x++` that
   * both write to `x` and read the current value of `x`, `node.asDefinition()`
   * will give the node corresponding to the value after the increment, and
   * `node.asExpr()` will give the node corresponding to the value before the
   * increment. For an example of this, consider the following:
   *
   * ```cpp
   * sink(x++);
   * ```
   * in the above program, there will not be flow from a node `n` such that
   * `n.asDefinition() instanceof IncrementOperation` to the argument of `sink`
   * since the value passed to `sink` is the value before to the increment.
   * However, there will be dataflow from a node `n` such that
   * `n.asExpr() instanceof IncrementOperation` since the result of evaluating
   * the expression `x++` is passed to `sink`.
   */
  Expr asDefinition() {
    exists(StoreInstruction store |
      store = this.asInstruction() and
      result = asDefinitionImpl(store)
    )
  }

  /**
   * Gets the indirect definition at a given indirection corresponding to this
   * node, if any.
   *
   * See the comments on `Node.asDefinition` for examples.
   */
  Expr asIndirectDefinition(int indirectionIndex) {
    exists(StoreInstruction store |
      this.(IndirectInstruction).hasInstructionAndIndirectionIndex(store, indirectionIndex) and
      result = asDefinitionImpl(store)
    )
  }

  /**
   * Gets the indirect definition at some indirection corresponding to this
   * node, if any.
   */
  Expr asIndirectDefinition() { result = this.asIndirectDefinition(_) }

  /**
   * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
   *
   * Unlike `Node::asDefiningArgument/0`, this predicate gets the node representing
   * the value of the `index`'th indirection after leaving a function. For example,
   * in:
   * ```cpp
   * void f(int**);
   * ...
   * int** x = ...;
   * f(x);
   * ```
   * The node `n` such that `n.asDefiningArgument(1)` is the argument `x` will
   * contain the value of `*x` after `f` has returned, and the node `n` such that
   * `n.asDefiningArgument(2)` is the argument `x` will contain the value of `**x`
   * after the `f` has returned.
   */
  Expr asDefiningArgument(int index) {
    this.(DefinitionByReferenceNode).getIndirectionIndex() = index and
    result = this.(DefinitionByReferenceNode).getArgument()
  }

  /**
   * Gets the the argument going into a function for a node that represents
   * the indirect value of the argument after `index` loads. For example, in:
   * ```cpp
   * void f(int**);
   * ...
   * int** x = ...;
   * f(x);
   * ```
   * The node `n` such that `n.asIndirectArgument(1)` represents the value of
   * `*x` going into `f`, and the node `n` such that `n.asIndirectArgument(2)`
   * represents the value of `**x` going into `f`.
   */
  Expr asIndirectArgument(int index) {
    this.(SideEffectOperandNode).hasAddressOperandAndIndirectionIndex(_, index) and
    result = this.(SideEffectOperandNode).getArgument()
  }

  /**
   * Gets the the argument going into a function for a node that represents
   * the indirect value of the argument after any non-zero number of loads.
   */
  Expr asIndirectArgument() { result = this.asIndirectArgument(_) }

  /** Gets the positional parameter corresponding to this node, if any. */
  Parameter asParameter() {
    exists(int indirectionIndex | result = this.asParameter(indirectionIndex) |
      if result.getUnspecifiedType() instanceof ReferenceType
      then indirectionIndex = 1
      else indirectionIndex = 0
    )
  }

  /**
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  LocalVariable asUninitialized() { result = this.(UninitializedNode).getLocalVariable() }

  /**
   * Gets the positional parameter corresponding to the node that represents
   * the value of the parameter after `index` number of loads, if any. For
   * example, in:
   * ```cpp
   * void f(int** x) { ... }
   * ```
   * - The node `n` such that `n.asParameter(0)` is the parameter `x` represents
   * the value of `x`.
   * - The node `n` such that `n.asParameter(1)` is the parameter `x` represents
   * the value of `*x`.
   * - The node `n` such that `n.asParameter(2)` is the parameter `x` represents
   * the value of `**x`.
   */
  Parameter asParameter(int index) {
    index = 0 and
    result = this.(ExplicitParameterNode).getParameter()
    or
    this.(IndirectParameterNode).getIndirectionIndex() = index and
    result = this.(IndirectParameterNode).getParameter()
  }

  /**
   * Gets the variable corresponding to this node, if any. This can be used for
   * modeling flow in and out of global variables.
   */
  Variable asVariable() {
    this = TGlobalLikeVariableNode(result, getMinIndirectionsForType(result.getUnspecifiedType()))
  }

  /**
   * Gets the `indirectionIndex`'th indirection of this node's underlying variable, if any.
   *
   * This can be used for modeling flow in and out of global variables.
   */
  Variable asIndirectVariable(int indirectionIndex) {
    indirectionIndex > getMinIndirectionsForType(result.getUnspecifiedType()) and
    this = TGlobalLikeVariableNode(result, indirectionIndex)
  }

  /** Gets an indirection of this node's underlying variable, if any. */
  Variable asIndirectVariable() { result = this.asIndirectVariable(_) }

  /**
   * Gets the expression that is partially defined by this node, if any.
   *
   * Partial definitions are created for field stores (`x.y = taint();` is a partial
   * definition of `x`), and for calls that may change the value of an object (so
   * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
   * a partial definition of `&x`).
   */
  Expr asPartialDefinition() {
    exists(PartialDefinitionNode pdn | this = pdn |
      pdn.getIndirectionIndex() > 0 and
      result = pdn.getDefinedExpr()
    )
  }

  /**
   * Gets an upper bound on the type of this node.
   */
  DataFlowType getTypeBound() { result = this.getType() }

  /** Gets the location of this element. */
  cached
  final Location getLocation() { result = this.getLocationImpl() }

  /** INTERNAL: Do not use. */
  Location getLocationImpl() {
    none() // overridden by subclasses
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  cached
  final string toString() {
    result = toExprString(this)
    or
    not exists(toExprString(this)) and
    result = this.toStringImpl()
  }

  /** INTERNAL: Do not use. */
  string toStringImpl() {
    none() // overridden by subclasses
  }
}

/**
 * A class that lifts pre-SSA dataflow nodes to regular dataflow nodes.
 */
private class Node0 extends Node, TNode0 {
  Node0Impl node;

  Node0() { this = TNode0(node) }

  override Declaration getEnclosingCallable() { result = node.getEnclosingCallable() }

  override Declaration getFunction() { result = node.getFunction() }

  override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }

  override DataFlowType getType() { result = node.getType() }

  override predicate isGLValue() { node.isGLValue() }
}

/**
 * An instruction, viewed as a node in a data flow graph.
 */
class InstructionNode extends Node0 {
  override InstructionNode0 node;
  Instruction instr;

  InstructionNode() { instr = node.getInstruction() }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }
}

/**
 * An operand, viewed as a node in a data flow graph.
 */
class OperandNode extends Node, Node0 {
  override OperandNode0 node;
  Operand op;

  OperandNode() { op = node.getOperand() }

  /** Gets the operand corresponding to this node. */
  Operand getOperand() { result = op }
}

/**
 * INTERNAL: Do not use.
 *
 * Returns `t`, but stripped of the outermost pointer, reference, etc.
 *
 * For example, `stripPointers(int*&)` is `int*` and `stripPointers(int*)` is `int`.
 */
Type stripPointer(Type t) {
  result = any(Ssa::Indirection ind | ind.getType() = t).getBaseType()
  or
  result = t.(PointerToMemberType).getBaseType()
  or
  result = t.(FunctionPointerIshType).getBaseType()
}

/**
 * INTERNAL: Do not use.
 */
class PostUpdateNodeImpl extends PartialDefinitionNode, TPostUpdateNodeImpl {
  int indirectionIndex;
  Operand operand;

  PostUpdateNodeImpl() { this = TPostUpdateNodeImpl(operand, indirectionIndex) }

  override Declaration getFunction() { result = operand.getUse().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  /** Gets the operand associated with this node. */
  Operand getOperand() { result = operand }

  /** Gets the indirection index associated with this node. */
  override int getIndirectionIndex() { result = indirectionIndex }

  override Location getLocationImpl() { result = operand.getLocation() }

  final override Node getPreUpdateNode() {
    indirectionIndex > 0 and
    hasOperandAndIndex(result, operand, indirectionIndex)
    or
    indirectionIndex = 0 and
    result.asOperand() = operand
  }

  final override Expr getDefinedExpr() {
    result = operand.getDef().getUnconvertedResultExpression()
  }
}

/**
 * INTERNAL: do not use.
 *
 * The node representing the value of a field after it has been updated.
 */
class PostFieldUpdateNode extends PostUpdateNodeImpl {
  FieldAddress fieldAddress;

  PostFieldUpdateNode() { operand = fieldAddress.getObjectAddressOperand() }

  FieldAddress getFieldAddress() { result = fieldAddress }

  Field getUpdatedField() { result = this.getFieldAddress().getField() }

  override string toStringImpl() { result = this.getPreUpdateNode() + " [post update]" }
}

/**
 * INTERNAL: do not use.
 *
 * A phi node produced by the shared SSA library, viewed as a node in a data flow graph.
 */
class SsaPhiNode extends Node, TSsaPhiNode {
  Ssa::PhiNode phi;

  SsaPhiNode() { this = TSsaPhiNode(phi) }

  /** Gets the phi node associated with this node. */
  Ssa::PhiNode getPhiNode() { result = phi }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = phi.getBasicBlock().getEnclosingFunction() }

  override DataFlowType getType() {
    exists(Ssa::SourceVariable sv |
      this.getPhiNode().definesAt(sv, _, _, _) and
      result = sv.getType()
    )
  }

  override predicate isGLValue() { phi.getSourceVariable().isGLValue() }

  final override Location getLocationImpl() { result = phi.getBasicBlock().getLocation() }

  override string toStringImpl() { result = phi.toString() }

  /**
   * Gets a node that is used as input to this phi node.
   * `fromBackEdge` is true if data flows along a back-edge,
   * and `false` otherwise.
   */
  cached
  final Node getAnInput(boolean fromBackEdge) {
    result.(SsaPhiInputNode).getPhiNode() = phi and
    exists(IRBlock bPhi, IRBlock bResult |
      bPhi = phi.getBasicBlock() and bResult = result.getBasicBlock()
    |
      if bPhi.dominates(bResult) then fromBackEdge = true else fromBackEdge = false
    )
  }

  /** Gets a node that is used as input to this phi node. */
  final Node getAnInput() { result = this.getAnInput(_) }

  /** Gets the source variable underlying this phi node. */
  Ssa::SourceVariable getSourceVariable() { result = phi.getSourceVariable() }

  /**
   * Holds if this phi node is a phi-read node.
   *
   * Phi-read nodes are like normal phi nodes, but they are inserted based
   * on reads instead of writes.
   */
  predicate isPhiRead() { phi.isPhiRead() }
}

/**
 * INTERNAL: Do not use.
 *
 * A node that is used as an input to a phi node.
 *
 * This class exists to allow more powerful barrier guards. Consider this
 * example:
 *
 * ```cpp
 * int x = source();
 * if(!safe(x)) {
 *   x = clear();
 * }
 * // phi node for x here
 * sink(x);
 * ```
 *
 * At the phi node for `x` it is neither the case that `x` is dominated by
 * `safe(x)`, or is the case that the phi is dominated by a clearing of `x`.
 *
 * By inserting a "phi input" node as the last entry in the basic block that
 * defines the inputs to the phi we can conclude that each of those inputs are
 * safe to pass to `sink`.
 */
class SsaPhiInputNode extends Node, TSsaPhiInputNode {
  Ssa::PhiNode phi;
  IRBlock block;

  SsaPhiInputNode() { this = TSsaPhiInputNode(phi, block) }

  /** Gets the phi node associated with this node. */
  Ssa::PhiNode getPhiNode() { result = phi }

  /** Gets the basic block in which this input originates. */
  IRBlock getBlock() { result = block }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = phi.getBasicBlock().getEnclosingFunction() }

  override DataFlowType getType() { result = this.getSourceVariable().getType() }

  override predicate isGLValue() { phi.getSourceVariable().isGLValue() }

  final override Location getLocationImpl() { result = block.getLastInstruction().getLocation() }

  override string toStringImpl() { result = "Phi input" }

  /** Gets the source variable underlying this phi node. */
  Ssa::SourceVariable getSourceVariable() { result = phi.getSourceVariable() }
}

/**
 * INTERNAL: do not use.
 *
 * Dataflow nodes necessary for iterator flow
 */
class SsaIteratorNode extends Node, TSsaIteratorNode {
  IteratorFlow::IteratorFlowNode node;

  SsaIteratorNode() { this = TSsaIteratorNode(node) }

  /** Gets the phi node associated with this node. */
  IteratorFlow::IteratorFlowNode getIteratorFlowNode() { result = node }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = node.getFunction() }

  override DataFlowType getType() { result = node.getType() }

  final override Location getLocationImpl() { result = node.getLocation() }

  override string toStringImpl() { result = node.toString() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing a value after leaving a function.
 */
class SideEffectOperandNode extends Node instanceof IndirectOperand {
  CallInstruction call;
  int argumentIndex;

  SideEffectOperandNode() {
    IndirectOperand.super.hasOperandAndIndirectionIndex(call.getArgumentOperand(argumentIndex), _)
  }

  CallInstruction getCallInstruction() { result = call }

  /** Gets the underlying operand and the underlying indirection index. */
  predicate hasAddressOperandAndIndirectionIndex(Operand operand, int indirectionIndex) {
    IndirectOperand.super.hasOperandAndIndirectionIndex(operand, indirectionIndex)
  }

  int getArgumentIndex() { result = argumentIndex }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = call.getEnclosingFunction() }

  Expr getArgument() { result = call.getArgument(argumentIndex).getUnconvertedResultExpression() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the value of a global variable just before returning
 * from a function body.
 */
class FinalGlobalValue extends Node, TFinalGlobalValue {
  Ssa::GlobalUse globalUse;

  FinalGlobalValue() { this = TFinalGlobalValue(globalUse) }

  /** Gets the underlying SSA use. */
  Ssa::GlobalUse getGlobalUse() { result = globalUse }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = globalUse.getIRFunction().getFunction() }

  override DataFlowType getType() {
    exists(int indirectionIndex |
      indirectionIndex = globalUse.getIndirectionIndex() and
      result = getTypeImpl(globalUse.getUnderlyingType(), indirectionIndex - 1)
    )
  }

  final override Location getLocationImpl() { result = globalUse.getLocation() }

  override string toStringImpl() { result = globalUse.toString() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the value of a global variable just after entering
 * a function body.
 */
class InitialGlobalValue extends Node, TInitialGlobalValue {
  Ssa::GlobalDef globalDef;

  InitialGlobalValue() { this = TInitialGlobalValue(globalDef) }

  /** Gets the underlying SSA definition. */
  Ssa::GlobalDef getGlobalDef() { result = globalDef }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = globalDef.getIRFunction().getFunction() }

  final override predicate isGLValue() { globalDef.getIndirectionIndex() = 0 }

  override DataFlowType getType() {
    exists(DataFlowType type |
      type = globalDef.getUnderlyingType() and
      if this.isGLValue()
      then result = type
      else result = getTypeImpl(type, globalDef.getIndirectionIndex() - 1)
    )
  }

  final override Location getLocationImpl() { result = globalDef.getLocation() }

  override string toStringImpl() { result = globalDef.toString() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing a parameter for a function with no body.
 */
class BodyLessParameterNodeImpl extends Node, TBodyLessParameterNodeImpl {
  Parameter p;
  int indirectionIndex;

  BodyLessParameterNodeImpl() { this = TBodyLessParameterNodeImpl(p, indirectionIndex) }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = p.getFunction() }

  /** Gets the indirection index of this node. */
  int getIndirectionIndex() { result = indirectionIndex }

  override DataFlowType getType() {
    result = getTypeImpl(p.getUnderlyingType(), this.getIndirectionIndex())
  }

  final override Location getLocationImpl() {
    result = unique( | | p.getLocation())
    or
    count(p.getLocation()) != 1 and
    result instanceof UnknownDefaultLocation
  }

  final override string toStringImpl() {
    exists(string prefix | prefix = stars(this) | result = prefix + p.toString())
  }
}

/**
 * A data-flow node used to model flow summaries. That is, a dataflow node
 * that is synthesized to represent a parameter, return value, or other part
 * of a models-as-data modeled function.
 */
class FlowSummaryNode extends Node, TFlowSummaryNode {
  /**
   * Gets the models-as-data `SummaryNode` associated with this dataflow
   * `FlowSummaryNode`.
   */
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  /**
   * Gets the summarized callable that this node belongs to.
   */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  /**
   * Gets the enclosing callable. For a `FlowSummaryNode` this is always the
   * summarized function this node is part of.
   */
  override Declaration getEnclosingCallable() { result = this.getSummarizedCallable() }

  override Location getLocationImpl() { result = this.getSummarizedCallable().getLocation() }

  override string toStringImpl() { result = this.getSummaryNode().toString() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the indirection of a value that is
 * about to be returned from a function.
 */
class IndirectReturnNode extends Node {
  IndirectReturnNode() {
    this instanceof FinalParameterNode
    or
    this.(IndirectOperand)
        .hasOperandAndIndirectionIndex(any(ReturnValueInstruction ret).getReturnAddressOperand(), _)
  }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  /**
   * Holds if this node represents the value that is returned to the caller
   * through a `return` statement.
   */
  predicate isNormalReturn() { this instanceof IndirectOperand }

  /**
   * Holds if this node represents the value that is returned to the caller
   * by writing to the `argumentIndex`'th argument of the call.
   */
  predicate isParameterReturn(int argumentIndex) {
    this.(FinalParameterNode).getArgumentIndex() = argumentIndex
  }

  /** Gets the indirection index of this indirect return node. */
  int getIndirectionIndex() {
    result = this.(FinalParameterNode).getIndirectionIndex()
    or
    this.(IndirectOperand).hasOperandAndIndirectionIndex(_, result)
  }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the indirection of a value after it
 * has been returned from a function.
 */
class IndirectArgumentOutNode extends PostUpdateNodeImpl {
  override ArgumentOperand operand;

  int getArgumentIndex() {
    exists(CallInstruction call | call.getArgumentOperand(result) = operand)
  }

  Operand getAddressOperand() { result = operand }

  CallInstruction getCallInstruction() { result.getAnArgumentOperand() = operand }

  /**
   * Gets the `Function` that the call targets, if this is statically known.
   */
  Function getStaticCallTarget() { result = this.getCallInstruction().getStaticCallTarget() }

  override string toStringImpl() {
    exists(string prefix | if indirectionIndex > 0 then prefix = "" else prefix = "pointer to " |
      // This string should be unique enough to be helpful but common enough to
      // avoid storing too many different strings.
      result = prefix + this.getStaticCallTarget().getName() + " output argument"
      or
      not exists(this.getStaticCallTarget()) and
      result = prefix + "output argument"
    )
  }
}

/**
 * Holds if `node` is an indirect operand with columns `(operand, indirectionIndex)`, and
 * `operand` represents a use of the fully converted value of `call`.
 */
private predicate hasOperand(Node node, CallInstruction call, int indirectionIndex, Operand operand) {
  operandForFullyConvertedCall(operand, call) and
  hasOperandAndIndex(node, operand, indirectionIndex)
}

/**
 * Holds if `node` is an indirect instruction with columns `(instr, indirectionIndex)`, and
 * `instr` represents a use of the fully converted value of `call`.
 *
 * Note that `hasOperand(node, _, _, _)` implies `not hasInstruction(node, _, _, _)`.
 */
private predicate hasInstruction(
  Node node, CallInstruction call, int indirectionIndex, Instruction instr
) {
  instructionForFullyConvertedCall(instr, call) and
  hasInstructionAndIndex(node, instr, indirectionIndex)
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the indirect value of a function call (i.e., a value hidden
 * behind a number of indirections).
 */
class IndirectReturnOutNode extends Node {
  CallInstruction call;
  int indirectionIndex;

  IndirectReturnOutNode() {
    // Annoyingly, we need to pick the fully converted value as the output of the function to
    // make flow through in the shared dataflow library work correctly.
    hasOperand(this, call, indirectionIndex, _)
    or
    hasInstruction(this, call, indirectionIndex, _)
  }

  CallInstruction getCallInstruction() { result = call }

  int getIndirectionIndex() { result = indirectionIndex }

  /** Gets the operand associated with this node, if any. */
  Operand getOperand() { hasOperand(this, call, indirectionIndex, result) }

  /** Gets the instruction associated with this node, if any. */
  Instruction getInstruction() { hasInstruction(this, call, indirectionIndex, result) }
}

/**
 * An `IndirectReturnOutNode` which is used as a destination of a store operation.
 * When it's used for a store operation it's useful to have this be a `PostUpdateNode` for
 * the shared dataflow library's flow-through mechanism to detect flow in cases such as:
 * ```cpp
 * struct MyInt {
 *   int i;
 *   int& getRef() { return i; }
 * };
 * ...
 * MyInt mi;
 * mi.getRef() = source(); // this is detected as a store to `i` via flow-through.
 * sink(mi.i);
 * ```
 */
private class PostIndirectReturnOutNode extends IndirectReturnOutNode, PostUpdateNode {
  PostIndirectReturnOutNode() {
    any(StoreInstruction store).getDestinationAddressOperand() = this.getOperand()
  }

  override Node getPreUpdateNode() { result = this }
}

/**
 * INTERNAL: Do not use.
 *
 * Returns `t`, but stripped of the outer-most `indirectionIndex` number of indirections.
 */
private Type getTypeImpl0(Type t, int indirectionIndex) {
  indirectionIndex = 0 and
  result = t
  or
  indirectionIndex > 0 and
  exists(Type stripped |
    stripped = stripPointer(t.stripTopLevelSpecifiers()) and
    // We need to avoid the case where `stripPointer(t) = t` (which can happen
    // on iterators that specify a `value_type` that is the iterator itself).
    // Such a type would create an infinite loop otherwise. For these cases we
    // simply don't produce a result for `getTypeImpl`.
    // To be on the safe side, we check whether the _unspecified_ type has
    // changed since this also prevents an infinite loop when `stripped` and
    // `t` only differ by const'ness or volatile'ness.
    stripped.getUnspecifiedType() != t.getUnspecifiedType() and
    result = getTypeImpl0(stripped, indirectionIndex - 1)
  )
}

/**
 * INTERNAL: Do not use.
 *
 * Returns `t`, but stripped of the outer-most `indirectionIndex` number of indirections.
 *
 * If `indirectionIndex` cannot be stripped off `t`, an `UnknownType` is returned.
 */
bindingset[t, indirectionIndex]
pragma[inline_late]
Type getTypeImpl(Type t, int indirectionIndex) {
  result = getTypeImpl0(t, indirectionIndex)
  or
  // If we cannot produce the right type we return an error type.
  // This can sometimes happen when we don't know the real
  // type of a void pointer.
  not exists(getTypeImpl0(t, indirectionIndex)) and
  result instanceof UnknownType
}

private module RawIndirectNodes {
  /**
   * INTERNAL: Do not use.
   *
   * A node that represents the indirect value of an operand in the IR
   * after `index` number of loads.
   */
  private class RawIndirectOperand0 extends Node, TRawIndirectOperand0 {
    Node0Impl node;
    int indirectionIndex;

    RawIndirectOperand0() { this = TRawIndirectOperand0(node, indirectionIndex) }

    /** Gets the underlying instruction. */
    Operand getOperand() { result = node.asOperand() }

    /** Gets the underlying indirection index. */
    int getIndirectionIndex() { result = indirectionIndex }

    override Declaration getFunction() {
      result = this.getOperand().getDef().getEnclosingFunction()
    }

    override Declaration getEnclosingCallable() { result = this.getFunction() }

    override predicate isGLValue() { this.getOperand().isGLValue() }

    override DataFlowType getType() {
      exists(int sub, DataFlowType type, boolean isGLValue |
        type = getOperandType(this.getOperand(), isGLValue) and
        if isGLValue = true then sub = 1 else sub = 0
      |
        result = getTypeImpl(type.getUnderlyingType(), indirectionIndex - sub)
      )
    }

    final override Location getLocationImpl() {
      if exists(this.getOperand().getLocation())
      then result = this.getOperand().getLocation()
      else result instanceof UnknownDefaultLocation
    }

    override string toStringImpl() {
      result = stars(this) + operandNode(this.getOperand()).toStringImpl()
    }
  }

  /**
   * INTERNAL: Do not use.
   *
   * A node that represents the indirect value of an instruction in the IR
   * after `index` number of loads.
   */
  private class RawIndirectInstruction0 extends Node, TRawIndirectInstruction0 {
    Node0Impl node;
    int indirectionIndex;

    RawIndirectInstruction0() { this = TRawIndirectInstruction0(node, indirectionIndex) }

    /** Gets the underlying instruction. */
    Instruction getInstruction() { result = node.asInstruction() }

    /** Gets the underlying indirection index. */
    int getIndirectionIndex() { result = indirectionIndex }

    override Declaration getFunction() { result = this.getInstruction().getEnclosingFunction() }

    override Declaration getEnclosingCallable() { result = this.getFunction() }

    override predicate isGLValue() { this.getInstruction().isGLValue() }

    override DataFlowType getType() {
      exists(int sub, DataFlowType type, boolean isGLValue |
        type = getInstructionType(this.getInstruction(), isGLValue) and
        if isGLValue = true then sub = 1 else sub = 0
      |
        result = getTypeImpl(type.getUnderlyingType(), indirectionIndex - sub)
      )
    }

    final override Location getLocationImpl() {
      if exists(this.getInstruction().getLocation())
      then result = this.getInstruction().getLocation()
      else result instanceof UnknownDefaultLocation
    }

    override string toStringImpl() {
      result = stars(this) + instructionNode(this.getInstruction()).toStringImpl()
    }
  }

  /**
   * INTERNAL: Do not use.
   *
   * A node that represents the indirect value of an operand in the IR
   * after a number of loads.
   */
  class RawIndirectOperand extends Node {
    int indirectionIndex;
    Operand operand;

    RawIndirectOperand() {
      exists(Node0Impl node | operand = node.asOperand() |
        this = TRawIndirectOperand0(node, indirectionIndex)
        or
        this = TRawIndirectInstruction0(node, indirectionIndex)
      )
    }

    /** Gets the operand associated with this node. */
    Operand getOperand() { result = operand }

    /** Gets the underlying indirection index. */
    int getIndirectionIndex() { result = indirectionIndex }
  }

  /**
   * INTERNAL: Do not use.
   *
   * A node that represents the indirect value of an instruction in the IR
   * after a number of loads.
   */
  class RawIndirectInstruction extends Node {
    int indirectionIndex;
    Instruction instr;

    RawIndirectInstruction() {
      exists(Node0Impl node | instr = node.asInstruction() |
        this = TRawIndirectOperand0(node, indirectionIndex)
        or
        this = TRawIndirectInstruction0(node, indirectionIndex)
      )
    }

    /** Gets the instruction associated with this node. */
    Instruction getInstruction() { result = instr }

    /** Gets the underlying indirection index. */
    int getIndirectionIndex() { result = indirectionIndex }
  }
}

import RawIndirectNodes

/**
 * INTERNAL: do not use.
 *
 * A node representing the value of an update parameter
 * just before reaching the end of a function.
 */
class FinalParameterNode extends Node, TFinalParameterNode {
  Parameter p;
  int indirectionIndex;

  FinalParameterNode() { this = TFinalParameterNode(p, indirectionIndex) }

  /** Gets the parameter associated with this final use. */
  Parameter getParameter() { result = p }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }

  /** Gets the argument index associated with this final use. */
  final int getArgumentIndex() { result = p.getIndex() }

  override Declaration getFunction() { result = p.getFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override DataFlowType getType() { result = getTypeImpl(p.getUnderlyingType(), indirectionIndex) }

  final override Location getLocationImpl() {
    // Parameters can have multiple locations. When there's a unique location we use
    // that one, but if multiple locations exist we default to an unknown location.
    result = unique( | | p.getLocation())
    or
    not exists(unique( | | p.getLocation())) and
    result instanceof UnknownDefaultLocation
  }

  override string toStringImpl() { result = stars(this) + p.toString() }
}

/**
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
class UninitializedNode extends Node {
  LocalVariable v;

  UninitializedNode() {
    exists(Ssa::Def def, Ssa::SourceVariable sv |
      def.getIndirectionIndex() = 0 and
      def.getValue().asInstruction() instanceof UninitializedInstruction and
      Ssa::defToNode(this, def, sv, _, _, _) and
      v = sv.getBaseVariable().(Ssa::BaseIRVariable).getIRVariable().getAst()
    )
  }

  /** Gets the uninitialized local variable corresponding to this node. */
  LocalVariable getLocalVariable() { result = v }
}

abstract private class AbstractParameterNode extends Node {
  /**
   * Holds if this node is the parameter of `f` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  abstract predicate isParameterOf(DataFlowCallable f, ParameterPosition pos);

  /** Gets the `Parameter` associated with this node, if it exists. */
  Parameter getParameter() { none() } // overridden by subclasses
}

abstract private class AbstractIndirectParameterNode extends AbstractParameterNode {
  /** Gets the indirection index of this parameter node. */
  abstract int getIndirectionIndex();
}

/**
 * INTERNAL: do not use.
 *
 * A node representing an indirection of a parameter.
 */
final class IndirectParameterNode = AbstractIndirectParameterNode;

pragma[noinline]
private predicate indirectParameterNodeHasArgumentIndexAndIndex(
  IndirectInstructionParameterNode node, int argumentIndex, int indirectionIndex
) {
  node.hasInstructionAndIndirectionIndex(_, indirectionIndex) and
  node.getArgumentIndex() = argumentIndex
}

pragma[noinline]
private predicate indirectPositionHasArgumentIndexAndIndex(
  IndirectionPosition pos, int argumentIndex, int indirectionIndex
) {
  pos.getArgumentIndex() = argumentIndex and
  pos.getIndirectionIndex() = indirectionIndex
}

private class IndirectInstructionParameterNode extends AbstractIndirectParameterNode instanceof IndirectInstruction
{
  InitializeParameterInstruction init;

  IndirectInstructionParameterNode() {
    IndirectInstruction.super.hasInstructionAndIndirectionIndex(init, _)
  }

  int getArgumentIndex() { init.hasIndex(result) }

  override string toStringImpl() {
    exists(string prefix | prefix = stars(this) |
      result = prefix + this.getParameter().toString()
      or
      not exists(this.getParameter()) and
      result = prefix + "this"
    )
  }

  /** Gets the parameter whose indirection is initialized. */
  override Parameter getParameter() { result = init.getParameter() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = init.getEnclosingFunction() }

  override predicate isParameterOf(DataFlowCallable f, ParameterPosition pos) {
    this.getEnclosingCallable() = f.getUnderlyingCallable() and
    exists(int argumentIndex, int indirectionIndex |
      indirectPositionHasArgumentIndexAndIndex(pos, argumentIndex, indirectionIndex) and
      indirectParameterNodeHasArgumentIndexAndIndex(this, argumentIndex, indirectionIndex)
    )
  }

  /** Gets the underlying operand and the underlying indirection index. */
  predicate hasInstructionAndIndirectionIndex(Instruction instr, int index) {
    IndirectInstruction.super.hasInstructionAndIndirectionIndex(instr, index)
  }

  final override int getIndirectionIndex() { this.hasInstructionAndIndirectionIndex(init, result) }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph. This includes both explicit parameters such as `x` in `f(x)`
 * and implicit parameters such as `this` in `x.f()`.
 *
 * To match a specific kind of parameter, consider using one of the subclasses
 * `ExplicitParameterNode`, `ThisParameterNode`, or
 * `ParameterIndirectionNode`.
 */
final class ParameterNode = AbstractParameterNode;

abstract private class AbstractDirectParameterNode extends AbstractParameterNode { }

/** An explicit positional parameter, including `this`, but not `...`. */
final class DirectParameterNode = AbstractDirectParameterNode;

/**
 * INTERNAL: Do not use.
 *
 * A non-indirect parameter node that is represented as an `Instruction`.
 */
abstract class InstructionDirectParameterNode extends InstructionNode, AbstractDirectParameterNode {
  final override InitializeParameterInstruction instr;

  /**
   * INTERNAL: Do not use.
   *
   * Gets the `IRVariable` that this parameter references.
   */
  final IRVariable getIRVariable() { result = instr.getIRVariable() }
}

abstract private class AbstractExplicitParameterNode extends AbstractDirectParameterNode { }

final class ExplicitParameterNode = AbstractExplicitParameterNode;

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterInstructionNode extends AbstractExplicitParameterNode,
  InstructionDirectParameterNode
{
  ExplicitParameterInstructionNode() { exists(instr.getParameter()) }

  override predicate isParameterOf(DataFlowCallable f, ParameterPosition pos) {
    f.getUnderlyingCallable().(Function).getParameter(pos.(DirectPosition).getIndex()) =
      instr.getParameter()
  }

  override string toStringImpl() { result = instr.getParameter().toString() }

  override Parameter getParameter() { result = instr.getParameter() }
}

/** An implicit `this` parameter. */
class ThisParameterInstructionNode extends AbstractExplicitParameterNode,
  InstructionDirectParameterNode
{
  ThisParameterInstructionNode() { instr.getIRVariable() instanceof IRThisVariable }

  override predicate isParameterOf(DataFlowCallable f, ParameterPosition pos) {
    pos.(DirectPosition).getIndex() = -1 and
    instr.getEnclosingFunction() = f.getUnderlyingCallable()
  }

  override string toStringImpl() { result = "this" }
}

/**
 * A parameter node that is part of a summary.
 */
class SummaryParameterNode extends AbstractParameterNode, FlowSummaryNode {
  SummaryParameterNode() {
    FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), _)
  }

  private ParameterPosition getPosition() {
    FlowSummaryImpl::Private::summaryParameterNode(this.getSummaryNode(), result)
  }

  override predicate isParameterOf(DataFlowCallable c, ParameterPosition p) {
    c.getUnderlyingCallable() = this.getSummarizedCallable() and
    p = this.getPosition()
  }
}

private class DirectBodyLessParameterNode extends AbstractExplicitParameterNode,
  BodyLessParameterNodeImpl
{
  DirectBodyLessParameterNode() { indirectionIndex = 0 }

  override predicate isParameterOf(DataFlowCallable f, ParameterPosition pos) {
    exists(Function func |
      this.getFunction() = func and
      f.asSourceCallable() = func and
      func.getParameter(pos.(DirectPosition).getIndex()) = p
    )
  }

  override Parameter getParameter() { result = p }
}

private class IndirectBodyLessParameterNode extends AbstractIndirectParameterNode,
  BodyLessParameterNodeImpl
{
  IndirectBodyLessParameterNode() { not this instanceof DirectBodyLessParameterNode }

  override predicate isParameterOf(DataFlowCallable f, ParameterPosition pos) {
    exists(Function func, int argumentPosition |
      this.getFunction() = func and
      f.asSourceCallable() = func and
      indirectPositionHasArgumentIndexAndIndex(pos, argumentPosition, indirectionIndex) and
      func.getParameter(argumentPosition) = p
    )
  }

  override int getIndirectionIndex() {
    result = BodyLessParameterNodeImpl.super.getIndirectionIndex()
  }

  override Parameter getParameter() { result = p }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update with the exception of `ClassInstanceExpr`,
 * which represents the value after the constructor has run.
 */
abstract class PostUpdateNode extends Node {
  /**
   * Gets the node before the state update.
   */
  abstract Node getPreUpdateNode();

  final override DataFlowType getType() { result = this.getPreUpdateNode().getType() }
}

/**
 * The base class for nodes that perform "partial definitions".
 *
 * In contrast to a normal "definition", which provides a new value for
 * something, a partial definition is an expression that may affect a
 * value, but does not necessarily replace it entirely. For example:
 * ```
 * x.y = 1; // a partial definition of the object `x`.
 * x.y.z = 1; // a partial definition of the object `x.y` and `x`.
 * x.setY(1); // a partial definition of the object `x`.
 * setY(&x); // a partial definition of the object `x`.
 * ```
 */
abstract private class PartialDefinitionNode extends PostUpdateNode {
  /** Gets the indirection index of this node. */
  abstract int getIndirectionIndex();

  /** Gets the expression that is partially defined by this node. */
  abstract Expr getDefinedExpr();
}

/**
 * A `PostUpdateNode` that is part of a flow summary. These are synthesized,
 * for example, when a models-as-data summary models a write to a field since
 * the write needs to target a `PostUpdateNode`.
 */
class SummaryPostUpdateNode extends FlowSummaryNode, PostUpdateNode {
  SummaryPostUpdateNode() {
    FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(), _)
  }

  override Node getPreUpdateNode() {
    FlowSummaryImpl::Private::summaryPostUpdateNode(this.getSummaryNode(),
      result.(FlowSummaryNode).getSummaryNode())
  }
}

/**
 * A node that represents the value of a variable after a function call that
 * may have changed the variable because it's passed by reference.
 *
 * A typical example would be a call `f(&x)`. Firstly, there will be flow into
 * `x` from previous definitions of `x`. Secondly, there will be a
 * `DefinitionByReferenceNode` to represent the value of `x` after the call has
 * returned. This node will have its `getArgument()` equal to `&x` and its
 * `getVariableAccess()` equal to `x`.
 */
class DefinitionByReferenceNode extends IndirectArgumentOutNode {
  DefinitionByReferenceNode() { this.getIndirectionIndex() > 0 }

  /** Gets the unconverted argument corresponding to this node. */
  Expr getArgument() { result = this.getAddressOperand().getDef().getUnconvertedResultExpression() }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    result = this.getCallInstruction().getStaticCallTarget().getParameter(this.getArgumentIndex())
  }
}

/**
 * A `Node` corresponding to a global (or `static` local) variable in the
 * program, as opposed to the value of that variable at some particular point.
 * This is used to model flow through global variables (and `static` local
 * variables).
 *
 * There is no `VariableNode` for non-`static` local variables.
 */
class VariableNode extends Node, TGlobalLikeVariableNode {
  Variable v;
  int indirectionIndex;

  VariableNode() { this = TGlobalLikeVariableNode(v, indirectionIndex) }

  /** Gets the variable corresponding to this node. */
  Variable getVariable() { result = v }

  /** Gets the indirection index of this node. */
  int getIndirectionIndex() { result = indirectionIndex }

  override Declaration getFunction() { none() }

  override Declaration getEnclosingCallable() {
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = v
  }

  override DataFlowType getType() {
    result = getTypeImpl(v.getUnderlyingType(), indirectionIndex - 1)
  }

  final override Location getLocationImpl() {
    // Certain variables (such as parameters) can have multiple locations.
    // When there's a unique location we use that one, but if multiple locations
    // exist we default to an unknown location.
    result = unique( | | v.getLocation())
    or
    not exists(unique( | | v.getLocation())) and
    result instanceof UnknownDefaultLocation
  }

  override string toStringImpl() { result = stars(this) + v.toString() }
}

/**
 * Gets the node corresponding to `instr`.
 */
InstructionNode instructionNode(Instruction instr) { result.getInstruction() = instr }

/**
 * Gets the node corresponding to `operand`.
 */
OperandNode operandNode(Operand operand) { result.getOperand() = operand }

/**
 * Gets the `Node` corresponding to the value of evaluating `e` or any of its
 * conversions. There is no result if `e` is a `Conversion`. For data flowing
 * _out of_ an expression, like when an argument is passed by reference, use
 * `definitionByReferenceNodeFromArgument` instead.
 */
ExprNode exprNode(Expr e) { result.getExpr(_) = e }

/**
 * Gets the `Node` corresponding to the value of evaluating `e`. Here, `e` may
 * be a `Conversion`. For data flowing _out of_ an expression, like when an
 * argument is passed by reference, use
 * `definitionByReferenceNodeFromArgument` instead.
 */
ExprNode convertedExprNode(Expr e) { result.getConvertedExpr(_) = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ExplicitParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as unconverted `argument` of a call.
 */
DefinitionByReferenceNode definitionByReferenceNodeFromArgument(Expr argument) {
  result.getArgument() = argument
}

/** Gets the `VariableNode` corresponding to the variable `v`. */
VariableNode variableNode(Variable v) {
  result.getVariable() = v and result.getIndirectionIndex() = 1
}

/**
 * DEPRECATED: See UninitializedNode.
 *
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
Node uninitializedNode(LocalVariable v) { none() }

predicate hasOperandAndIndex(IndirectOperand indirectOperand, Operand operand, int indirectionIndex) {
  indirectOperand.hasOperandAndIndirectionIndex(operand, indirectionIndex)
}

predicate hasInstructionAndIndex(
  IndirectInstruction indirectInstr, Instruction instr, int indirectionIndex
) {
  indirectInstr.hasInstructionAndIndirectionIndex(instr, indirectionIndex)
}

cached
private module Cached {
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
      // Post update node -> Node flow
      Ssa::postUpdateFlow(nodeFrom, nodeTo)
      or
      // Def-use/Use-use flow
      Ssa::ssaFlow(nodeFrom, nodeTo)
      or
      // Phi input -> Phi
      nodeFrom.(SsaPhiInputNode).getPhiNode() = nodeTo.(SsaPhiNode).getPhiNode()
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
        not iFrom = Ssa::getIRRepresentationOfOperand(opTo)
      )
      or
      // Phi node -> Node flow
      Ssa::fromPhiNode(nodeFrom, nodeTo)
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
      Ssa::outNodeHasAddressAndIndex(nodeFrom, address, indirectionIndex)
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
 * INTERNAL: Do not use.
 *
 * Ideally this module would be private, but the `asExprInternal` predicate is
 * needed in `DefaultTaintTrackingImpl`. Once `DefaultTaintTrackingImpl` is gone
 * we can make this module private.
 */
cached
module ExprFlowCached {
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
  cached
  Expr asExprInternal(Node n) {
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

import ExprFlowCached

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

bindingset[f]
pragma[inline_late]
private int getFieldSize(Field f) { result = f.getType().getSize() }

/**
 * Gets a field in the union `u` whose size
 * is `bytes` number of bytes.
 */
private Field getAFieldWithSize(Union u, int bytes) {
  result = u.getAField() and
  bytes = getFieldSize(result)
}

cached
private newtype TContent =
  TFieldContent(Field f, int indirectionIndex) {
    // the indirection index for field content starts at 1 (because `TFieldContent` is thought of as
    // the address of the field, `FieldAddress` in the IR).
    indirectionIndex = [1 .. Ssa::getMaxIndirectionsForType(f.getUnspecifiedType())] and
    // Reads and writes of union fields are tracked using `UnionContent`.
    not f.getDeclaringType() instanceof Union
  } or
  TUnionContent(Union u, int bytes, int indirectionIndex) {
    exists(Field f |
      f = u.getAField() and
      bytes = getFieldSize(f) and
      // We key `UnionContent` by the union instead of its fields since a write to one
      // field can be read by any read of the union's fields. Again, the indirection index
      // is 1-based (because 0 is considered the address).
      indirectionIndex =
        [1 .. max(Ssa::getMaxIndirectionsForType(getAFieldWithSize(u, bytes).getUnspecifiedType()))]
    )
  }

/**
 * A description of the way data may be stored inside an object. Examples
 * include instance fields, the contents of a collection object, or the contents
 * of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }

  /** Gets the indirection index of this `Content`. */
  abstract int getIndirectionIndex();

  /**
   * INTERNAL: Do not use.
   *
   * Holds if a write to this `Content` implies that `c` is
   * also cleared.
   *
   * For example, a write to a field `f` implies that any content of
   * the form `*f` is also cleared.
   */
  abstract predicate impliesClearOf(Content c);
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

/** A reference through a non-union instance field. */
class FieldContent extends Content, TFieldContent {
  private Field f;
  private int indirectionIndex;

  FieldContent() { this = TFieldContent(f, indirectionIndex) }

  override string toString() { result = contentStars(this) + f.toString() }

  Field getField() { result = f }

  /** Gets the indirection index of this `FieldContent`. */
  pragma[inline]
  override int getIndirectionIndex() {
    pragma[only_bind_into](result) = pragma[only_bind_out](indirectionIndex)
  }

  override predicate impliesClearOf(Content c) {
    exists(FieldContent fc |
      fc = c and
      fc.getField() = f and
      // If `this` is `f` then `c` is cleared if it's of the
      // form `*f`, `**f`, etc.
      fc.getIndirectionIndex() >= indirectionIndex
    )
  }
}

/** A reference through an instance field of a union. */
class UnionContent extends Content, TUnionContent {
  private Union u;
  private int indirectionIndex;
  private int bytes;

  UnionContent() { this = TUnionContent(u, bytes, indirectionIndex) }

  override string toString() { result = contentStars(this) + u.toString() }

  /** Gets a field of the underlying union of this `UnionContent`, if any. */
  Field getAField() { result = u.getAField() and getFieldSize(result) = bytes }

  /** Gets the underlying union of this `UnionContent`. */
  Union getUnion() { result = u }

  /** Gets the indirection index of this `UnionContent`. */
  pragma[inline]
  override int getIndirectionIndex() {
    pragma[only_bind_into](result) = pragma[only_bind_out](indirectionIndex)
  }

  override predicate impliesClearOf(Content c) {
    exists(UnionContent uc |
      uc = c and
      uc.getUnion() = u and
      // If `this` is `u` then `c` is cleared if it's of the
      // form `*u`, `**u`, etc. (and we ignore `bytes` because
      // we know the entire union is overwritten because it's a
      // union).
      uc.getIndirectionIndex() >= indirectionIndex
    )
  }
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
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    super.hasLocationInfo(path, sl, sc, el, ec)
  }
}

pragma[nomagic]
private predicate guardControlsPhiInput(
  IRGuardCondition g, boolean branch, Ssa::Definition def, IRBlock input, Ssa::PhiNode phi
) {
  phi.hasInputFromBlock(def, _, _, _, input) and
  (
    g.controls(input, branch)
    or
    exists(EdgeKind kind |
      g.getBlock() = input and
      kind = getConditionalEdge(branch) and
      input.getSuccessor(kind) = phi.getBasicBlock()
    )
  )
}

/**
 * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(IRGuardCondition g, Expr e, boolean branch);

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  /**
   * Gets an expression node that is safely guarded by the given guard check.
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
  Node getABarrierNode() {
    exists(IRGuardCondition g, Expr e, ValueNumber value, boolean edge |
      e = value.getAnInstruction().getConvertedResultExpression() and
      result.asConvertedExpr() = e and
      guardChecks(g, value.getAnInstruction().getConvertedResultExpression(), edge) and
      g.controls(result.getBasicBlock(), edge)
    )
    or
    exists(
      IRGuardCondition g, boolean branch, Ssa::DefinitionExt def, IRBlock input, Ssa::PhiNode phi
    |
      guardChecks(g, def.getARead().asOperand().getDef().getConvertedResultExpression(), branch) and
      guardControlsPhiInput(g, branch, def, input, phi) and
      result = TSsaPhiInputNode(phi, input)
    )
  }

  /**
   * Gets an indirect expression node that is safely guarded by the given guard check.
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
  Node getAnIndirectBarrierNode() { result = getAnIndirectBarrierNode(_) }

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
    exists(IRGuardCondition g, Expr e, ValueNumber value, boolean edge |
      e = value.getAnInstruction().getConvertedResultExpression() and
      result.asIndirectConvertedExpr(indirectionIndex) = e and
      guardChecks(g, value.getAnInstruction().getConvertedResultExpression(), edge) and
      g.controls(result.getBasicBlock(), edge)
    )
    or
    exists(
      IRGuardCondition g, boolean branch, Ssa::DefinitionExt def, IRBlock input, Ssa::PhiNode phi
    |
      guardChecks(g,
        def.getARead().asIndirectOperand(indirectionIndex).getDef().getConvertedResultExpression(),
        branch) and
      guardControlsPhiInput(g, branch, def, input, phi) and
      result = TSsaPhiInputNode(phi, input)
    )
  }
}

/**
 * Holds if the guard `g` validates the instruction `instr` upon evaluating to `branch`.
 */
signature predicate instructionGuardChecksSig(IRGuardCondition g, Instruction instr, boolean branch);

private EdgeKind getConditionalEdge(boolean branch) {
  branch = true and
  result instanceof TrueEdge
  or
  branch = false and
  result instanceof FalseEdge
}

/**
 * Provides a set of barrier nodes for a guard that validates an instruction.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module InstructionBarrierGuard<instructionGuardChecksSig/3 instructionGuardChecks> {
  /** Gets a node that is safely guarded by the given guard check. */
  Node getABarrierNode() {
    exists(IRGuardCondition g, ValueNumber value, boolean edge, Operand use |
      instructionGuardChecks(g, value.getAnInstruction(), edge) and
      use = value.getAnInstruction().getAUse() and
      result.asOperand() = use and
      g.controls(result.getBasicBlock(), edge)
    )
    or
    exists(
      IRGuardCondition g, boolean branch, Ssa::DefinitionExt def, IRBlock input, Ssa::PhiNode phi
    |
      instructionGuardChecks(g, def.getARead().asOperand().getDef(), branch) and
      guardControlsPhiInput(g, branch, def, input, phi) and
      result = TSsaPhiInputNode(phi, input)
    )
  }
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
