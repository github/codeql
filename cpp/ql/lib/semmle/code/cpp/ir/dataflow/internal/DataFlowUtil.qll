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
private import DataFlowPrivate
private import ModelUtil
private import SsaInternals as Ssa

cached
private module Cached {
  /**
   * The IR dataflow graph consists of the following nodes:
   * - `InstructionNode`, which injects most instructions directly into the dataflow graph.
   * - `OperandNode`, which similarly injects most operands directly into the dataflow graph.
   * - `VariableNode`, which is used to model flow through global variables.
   * - `PostFieldUpdateNode`, which is used to model the state of a field after a value has been stored
   * into an address after a number of loads.
   * - `SsaPhiNode`, which represents phi nodes as computed by the shared SSA library.
   * - `IndirectArgumentOutNode`, which represents the value of an argument (and its indirections) after
   * it leaves a function call.
   * - `IndirectOperand`, which represents the value of `operand` after loading the address a number
   * of times.
   * `IndirectInstruction`, which represents the value of `instr` after loading the address a number
   * of times.
   */
  cached
  newtype TIRDataFlowNode =
    TInstructionNode(Instruction i) { not Ssa::ignoreInstruction(i) } or
    TOperandNode(Operand op) { not Ssa::ignoreOperand(op) } or
    TVariableNode(Variable var) or
    TPostFieldUpdateNode(FieldAddress operand, int index) {
      index =
        [0 .. Ssa::countIndirectionsForCppType(operand.getObjectAddress().getResultLanguageType()) -
            1]
    } or
    TSsaPhiNode(Ssa::PhiNode phi) or
    TIndirectArgumentOutNode(ArgumentOperand operand, int index) {
      Ssa::isModifiableByCall(operand) and
      index = [0 .. Ssa::countIndirectionsForCppType(operand.getLanguageType()) - 1]
    } or
    TIndirectOperand(Operand op, int index) { Ssa::hasIndirectOperand(op, index) } or
    TIndirectInstruction(Instruction instr, int index) { Ssa::hasIndirectInstruction(instr, index) }
}

/**
 * An operand that is defined by a `FieldAddressInstruction`.
 */
class FieldAddress extends Operand {
  FieldAddressInstruction fai;

  FieldAddress() { fai = this.getDef() }

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
 */
cached
predicate conversionFlow(Operand opFrom, Instruction instrTo, boolean isPointerArith) {
  isPointerArith = false and
  (
    instrTo.(CopyValueInstruction).getSourceValueOperand() = opFrom
    or
    instrTo.(ConvertInstruction).getUnaryOperand() = opFrom
    or
    instrTo.(CheckedConvertOrNullInstruction).getUnaryOperand() = opFrom
    or
    instrTo.(InheritanceConversionInstruction).getUnaryOperand() = opFrom
  )
  or
  isPointerArith = true and
  instrTo.(PointerArithmeticInstruction).getLeftOperand() = opFrom
}

private import Cached

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

  /** Gets the type of this node. */
  IRType getType() { none() } // overridden in subclasses

  /** Gets the instruction corresponding to this node, if any. */
  Instruction asInstruction() { result = this.(InstructionNode).getInstruction() }

  /** Gets the operands corresponding to this node, if any. */
  Operand asOperand() { result = this.(OperandNode).getOperand() }

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
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  Expr asIndirectExpr(int index) {
    exists(Operand operand | hasOperandAndIndex(this, operand, index) |
      result = operand.getDef().getUnconvertedResultExpression()
    )
  }

  Expr asIndirectExpr() { result = this.asIndirectExpr(_) }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.(ExprNode).getConvertedExpr() }

  Expr asIndirectConvertedExpr(int index) {
    exists(Operand operand | hasOperandAndIndex(this, operand, index) |
      result = operand.getDef().getConvertedResultExpression()
    )
  }

  Expr asIndirectConvertedExpr() { result = this.asIndirectConvertedExpr(_) }

  /**
   * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
   * This predicate should be used instead of `asExpr` when referring to the
   * value of a reference argument _after_ the call has returned. For example,
   * in `f(&x)`, this predicate will have `&x` as its result for the `Node`
   * that represents the new value of `x`.
   */
  Expr asDefiningArgument() { result = this.asDefiningArgument(_) }

  Expr asDefiningArgument(int index) {
    this.(DefinitionByReferenceNode).getIndex() = index and
    result = this.(DefinitionByReferenceNode).getArgument()
  }

  Expr asIndirectArgument(int index) {
    this.(SideEffectOperandNode).getIndex() = index and
    result = this.(SideEffectOperandNode).getArgument()
  }

  Expr asIndirectArgument() { result = this.asIndirectArgument(_) }

  Parameter asParameter() { result = asParameter(0) }

  /** Gets the positional parameter corresponding to this node, if any. */
  Parameter asParameter(int ind) {
    ind = 0 and
    result = this.(ExplicitParameterNode).getParameter()
    or
    this.(IndirectParameterNode).getIndex() = ind and
    result = this.(IndirectParameterNode).getParameter()
  }

  /**
   * Gets the variable corresponding to this node, if any. This can be used for
   * modeling flow in and out of global variables.
   */
  Variable asVariable() { result = this.(VariableNode).getVariable() }

  /**
   * Gets the expression that is partially defined by this node, if any.
   *
   * Partial definitions are created for field stores (`x.y = taint();` is a partial
   * definition of `x`), and for calls that may change the value of an object (so
   * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
   * a partial definition of `&x`).
   */
  Expr asPartialDefinition() { result = this.(PartialDefinitionNode).getDefinedExpr() }

  /**
   * Gets an upper bound on the type of this node.
   */
  IRType getTypeBound() { result = this.getType() }

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
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  cached
  final string toString() { result = this.toStringImpl() }

  /** INTERNAL: Do not use. */
  string toStringImpl() {
    none() // overridden by subclasses
  }
}

/**
 * An instruction, viewed as a node in a data flow graph.
 */
class InstructionNode extends Node, TInstructionNode {
  Instruction instr;

  InstructionNode() { this = TInstructionNode(instr) }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = instr.getEnclosingFunction() }

  override IRType getType() { result = instr.getResultIRType() }

  final override Location getLocationImpl() { result = instr.getLocation() }

  override string toStringImpl() {
    // This predicate is overridden in subclasses. This default implementation
    // does not use `Instruction.toString` because that's expensive to compute.
    result = this.getInstruction().getOpcode().toString()
    // result = this.getInstruction().getDumpString()
  }
}

/**
 * An operand, viewed as a node in a data flow graph.
 */
class OperandNode extends Node, TOperandNode {
  Operand op;

  OperandNode() { this = TOperandNode(op) }

  /** Gets the operand corresponding to this node. */
  Operand getOperand() { result = op }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = op.getUse().getEnclosingFunction() }

  override IRType getType() { result = op.getIRType() }

  final override Location getLocationImpl() { result = op.getLocation() }

  override string toStringImpl() { result = this.getOperand().toString() }
}

class PostFieldUpdateNode extends TPostFieldUpdateNode, PartialDefinitionNode {
  int index;
  FieldAddress fieldAddress;

  PostFieldUpdateNode() { this = TPostFieldUpdateNode(fieldAddress, index) }

  override Function getFunction() { result = fieldAddress.getUse().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override IRType getType() { result = fieldAddress.getIRType() }

  FieldAddress getFieldAddress() { result = fieldAddress }

  Field getUpdatedField() { result = fieldAddress.getField() }

  int getIndex() { result = index }

  override Node getPreUpdateNode() {
    hasOperandAndIndex(result, pragma[only_bind_into](fieldAddress).getObjectAddressOperand(),
      index + 1)
  }

  override Expr getDefinedExpr() {
    result = fieldAddress.getObjectAddress().getUnconvertedResultExpression()
  }

  override Location getLocationImpl() { result = fieldAddress.getLocation() }

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

  override IRType getType() { result instanceof IRVoidType }

  final override Location getLocationImpl() { result = phi.getBasicBlock().getLocation() }

  /** Holds if this phi node has input from the `rnk`'th write operation in block `block`. */
  final predicate hasInputAtRankInBlock(IRBlock block, int rnk) {
    this.hasInputAtRankInBlock(block, rnk, _)
  }

  /**
   * Holds if this phi node has input from the definition `input` (which is the `rnk`'th write
   * operation in block `block`).
   */
  final predicate hasInputAtRankInBlock(IRBlock block, int rnk, Ssa::Definition input) {
    Ssa::phiHasInputFromBlock(phi, input, _) and
    input.definesAt(_, block, rnk)
  }

  override string toStringImpl() { result = "Phi" }
}

class SideEffectOperandNode extends Node, IndirectOperand {
  CallInstruction call;
  int argumentIndex;

  SideEffectOperandNode() { operand = call.getArgumentOperand(argumentIndex) }

  CallInstruction getCallInstruction() { result = call }

  Operand getAddressOperand() { result = operand }

  int getArgumentIndex() { result = argumentIndex }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = call.getEnclosingFunction() }

  override IRType getType() { result instanceof IRVoidType }

  Expr getArgument() { result = call.getArgument(argumentIndex).getUnconvertedResultExpression() }
}

class IndirectParameterNode extends Node, IndirectInstruction {
  InitializeParameterInstruction init;

  IndirectParameterNode() { this.getInstruction() = init }

  InitializeParameterInstruction getInitializeParameterInstruction() { result = init }

  int getArgumentIndex() { init.hasIndex(result) }

  /** Gets the parameter whose indirection is initialized. */
  Parameter getParameter() { result = init.getParameter() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = this.getInstruction().getEnclosingFunction() }

  override IRType getType() { result instanceof IRVoidType }

  override string toStringImpl() {
    result = this.getParameter().toString() + " indirection"
    or
    not exists(this.getParameter()) and
    result = "this indirection"
  }
}

class IndirectReturnNode extends IndirectOperand {
  IndirectReturnNode() {
    this.getOperand() = any(ReturnIndirectionInstruction ret).getSourceAddressOperand()
    or
    this.getOperand() = any(ReturnValueInstruction ret).getReturnAddressOperand()
  }

  Operand getAddressOperand() { result = operand }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override IRType getType() { result instanceof IRVoidType }
}

class IndirectArgumentOutNode extends Node, TIndirectArgumentOutNode, PostUpdateNode {
  ArgumentOperand operand;
  int index;

  IndirectArgumentOutNode() { this = TIndirectArgumentOutNode(operand, index) }

  int getIndex() { result = index }

  int getArgumentIndex() {
    exists(CallInstruction call | call.getArgumentOperand(result) = operand)
  }

  Operand getAddressOperand() { result = operand }

  CallInstruction getCallInstruction() { result.getAnArgumentOperand() = operand }

  Function getStaticCallTarget() { result = this.getCallInstruction().getStaticCallTarget() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = this.getCallInstruction().getEnclosingFunction() }

  override IRType getType() { result instanceof IRVoidType }

  override Node getPreUpdateNode() { hasOperandAndIndex(result, operand, index + 1) }

  override string toStringImpl() {
    // This string should be unique enough to be helpful but common enough to
    // avoid storing too many different strings.
    result = this.getStaticCallTarget().getName() + " output argument"
    or
    not exists(this.getStaticCallTarget()) and
    result = "output argument"
  }

  override Location getLocationImpl() { result = operand.getLocation() }
}

pragma[nomagic]
predicate indirectReturnOutNodeOperand0(CallInstruction call, Operand operand, int index) {
  Ssa::hasIndirectInstruction(call, index) and
  operandForfullyConvertedCall(operand, call)
}

pragma[nomagic]
predicate indirectReturnOutNodeInstruction0(CallInstruction call, Instruction instr, int index) {
  Ssa::hasIndirectInstruction(call, index) and
  instructionForfullyConvertedCall(instr, call)
}

class IndirectReturnOutNode extends Node {
  CallInstruction call;
  int index;

  IndirectReturnOutNode() {
    exists(Operand operand |
      indirectReturnOutNodeOperand0(call, operand, index) and
      hasOperandAndIndex(this, operand, index)
    )
    or
    exists(Instruction instr |
      indirectReturnOutNodeInstruction0(call, instr, index) and
      hasInstructionAndIndex(this, instr, index)
    )
  }

  CallInstruction getCallInstruction() { result = call }

  int getIndex() { result = index }
}

class IndirectOperand extends Node, TIndirectOperand {
  Operand operand;
  int index;

  IndirectOperand() { this = TIndirectOperand(operand, index) }

  /** Gets the underlying instruction. */
  Operand getOperand() { result = operand }

  int getIndex() { result = index }

  override Function getFunction() { result = this.getOperand().getDef().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override IRType getType() { result = this.getOperand().getIRType() }

  final override Location getLocationImpl() { result = this.getOperand().getLocation() }

  override string toStringImpl() {
    result = instructionNode(this.getOperand().getDef()).toStringImpl() + " indirection"
  }
}

class IndirectInstruction extends Node, TIndirectInstruction {
  Instruction instr;
  int index;

  IndirectInstruction() { this = TIndirectInstruction(instr, index) }

  /** Gets the underlying instruction. */
  Instruction getInstruction() { result = instr }

  int getIndex() { result = index }

  override Function getFunction() { result = this.getInstruction().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override IRType getType() { result = this.getInstruction().getResultIRType() }

  final override Location getLocationImpl() { result = this.getInstruction().getLocation() }

  override string toStringImpl() {
    result = instructionNode(this.getInstruction()).toStringImpl() + " indirection"
  }
}

private predicate isFullyConvertedArgument(Expr e) {
  e = any(Call call).getAnArgument().getFullyConverted()
}

private predicate isFullyConvertedCall(Expr e) { e = any(Call call).getFullyConverted() }

private predicate convertedExprMustBeOperand(Expr e) {
  isFullyConvertedArgument(e)
  or
  isFullyConvertedCall(e)
}

predicate exprNodeShouldBeOperand(Node node, Expr e) {
  e = node.asOperand().getDef().getConvertedResultExpression() and
  convertedExprMustBeOperand(e)
}

private predicate exprNodeShouldBeIndirectOperand(IndirectOperand node, Expr e, LoadInstruction load) {
  node.getIndex() = 1 and
  e = load.getConvertedResultExpression() and
  load.getSourceAddressOperand() = node.getOperand() and
  not convertedExprMustBeOperand(e)
}

predicate exprNodeShouldBeInstruction(Node node, Expr e) {
  e = node.asInstruction().getConvertedResultExpression() and
  not exprNodeShouldBeOperand(_, e) and
  not exprNodeShouldBeIndirectOperand(_, e, _)
}

private class ExprNodeBase extends Node {
  Expr getConvertedExpr() { none() } // overridden by subclasses

  Expr getExpr() { none() } // overridden by subclasses
}

class InstructionExprNode extends ExprNodeBase, InstructionNode {
  InstructionExprNode() { exprNodeShouldBeInstruction(this, _) }

  final override Expr getConvertedExpr() { exprNodeShouldBeInstruction(this, result) }

  final override Expr getExpr() { result = this.getInstruction().getUnconvertedResultExpression() }

  final override string toStringImpl() { result = this.getConvertedExpr().toString() }
}

class OperandExprNode extends ExprNodeBase, OperandNode {
  OperandExprNode() { exprNodeShouldBeOperand(this, _) }

  final override Expr getConvertedExpr() { exprNodeShouldBeOperand(this, result) }

  final override Expr getExpr() {
    result = this.getOperand().getDef().getUnconvertedResultExpression()
  }

  final override string toStringImpl() {
    result = this.(ArgumentNode).toStringImpl()
    or
    not this instanceof ArgumentNode and
    result = this.getConvertedExpr().toString()
  }
}

class IndirectOperandExprNode extends ExprNodeBase, IndirectOperand {
  LoadInstruction load;

  IndirectOperandExprNode() { exprNodeShouldBeIndirectOperand(this, _, load) }

  final override Expr getConvertedExpr() { exprNodeShouldBeIndirectOperand(this, result, load) }

  final override Expr getExpr() { result = load.getUnconvertedResultExpression() }

  final override string toStringImpl() { result = this.getConvertedExpr().toString() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends Node instanceof ExprNodeBase {
  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr getExpr() { result = super.getExpr() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr getConvertedExpr() { result = super.getConvertedExpr() }
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
class ParameterNode extends Node {
  ParameterNode() {
    // To avoid making this class abstract, we enumerate its values here
    this.asInstruction() instanceof InitializeParameterInstruction
    or
    this instanceof IndirectParameterNode
  }

  /**
   * Holds if this node is the parameter of `f` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  predicate isParameterOf(Function f, ParameterPosition pos) { none() } // overridden by subclasses
}

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterNode extends ParameterNode, InstructionNode {
  override InitializeParameterInstruction instr;

  ExplicitParameterNode() { exists(instr.getParameter()) }

  override predicate isParameterOf(Function f, ParameterPosition pos) {
    f.getParameter(pos.(DirectPosition).getIndex()) = instr.getParameter()
  }

  /** Gets the `Parameter` associated with this node. */
  Parameter getParameter() { result = instr.getParameter() }

  override string toStringImpl() { result = instr.getParameter().toString() }
}

/** An implicit `this` parameter. */
class ThisParameterNode extends ParameterNode, InstructionNode {
  override InitializeParameterInstruction instr;

  ThisParameterNode() { instr.getIRVariable() instanceof IRThisVariable }

  override predicate isParameterOf(Function f, ParameterPosition pos) {
    pos.(DirectPosition).getIndex() = -1 and instr.getEnclosingFunction() = f
  }

  override string toStringImpl() { result = "this" }
}

pragma[noinline]
private predicate indirectPostionHasArgumentIndexAndIndex(
  IndirectionPosition pos, int argumentIndex, int index
) {
  pos.getArgumentIndex() = argumentIndex and
  pos.getIndex() = index
}

pragma[noinline]
private predicate indirectParameterNodeHasArgumentIndexAndIndex(
  IndirectParameterNode node, int argumentIndex, int index
) {
  node.getArgumentIndex() = argumentIndex and
  node.getIndex() = index
}

/** A synthetic parameter to model the pointed-to object of a pointer parameter. */
class ParameterIndirectionNode extends ParameterNode instanceof IndirectParameterNode {
  override predicate isParameterOf(Function f, ParameterPosition pos) {
    IndirectParameterNode.super.getEnclosingCallable() = f and
    exists(int argumentIndex, int index |
      indirectPostionHasArgumentIndexAndIndex(pos, argumentIndex, index) and
      indirectParameterNodeHasArgumentIndexAndIndex(this, argumentIndex, index)
    )
  }
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
  abstract Expr getDefinedExpr();
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
  /** Gets the unconverted argument corresponding to this node. */
  Expr getArgument() { result = this.getAddressOperand().getDef().getUnconvertedResultExpression() }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    result = this.getCallInstruction().getStaticCallTarget().getParameter(this.getArgumentIndex())
  }
}

/**
 * A `Node` corresponding to a variable in the program, as opposed to the
 * value of that variable at some particular point. This can be used for
 * modeling flow in and out of global variables.
 */
class VariableNode extends Node, TVariableNode {
  Variable v;

  VariableNode() { this = TVariableNode(v) }

  /** Gets the variable corresponding to this node. */
  Variable getVariable() { result = v }

  override Declaration getFunction() { none() }

  override Declaration getEnclosingCallable() {
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = v
  }

  override IRType getType() { result.getCanonicalLanguageType().hasUnspecifiedType(v.getType(), _) }

  final override Location getLocationImpl() { result = v.getLocation() }

  override string toStringImpl() { result = v.toString() }
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
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to the value of evaluating `e`. Here, `e` may
 * be a `Conversion`. For data flowing _out of_ an expression, like when an
 * argument is passed by reference, use
 * `definitionByReferenceNodeFromArgument` instead.
 */
ExprNode convertedExprNode(Expr e) { result.getConvertedExpr() = e }

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
VariableNode variableNode(Variable v) { result.getVariable() = v }

/**
 * DEPRECATED: See UninitializedNode.
 *
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
Node uninitializedNode(LocalVariable v) { none() }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep = simpleLocalFlowStep/2;

private predicate indirectionOperandFlow(IndirectOperand nodeFrom, Node nodeTo) {
  // Reduce the indirection count by 1 if we're passing through a `LoadInstruction`.
  exists(int ind, LoadInstruction load |
    hasOperandAndIndex(nodeFrom, load.getSourceAddressOperand(), ind) and
    nodeHasInstruction(nodeTo, load, ind - 1)
  )
  or
  // If an operand flows to an instruction, then the indirection of
  // the operand also flows to the indirction of the instruction.
  exists(Operand operand, Instruction instr, int index |
    simpleInstructionLocalFlowStep(operand, instr) and
    hasOperandAndIndex(nodeFrom, operand, index) and
    hasInstructionAndIndex(nodeTo, instr, index)
  )
  or
  // If there's indirect flow to an operand, then there's also indirect
  // flow to the operand after applying some pointer arithmetic.
  exists(PointerArithmeticInstruction pointerArith, int index |
    hasOperandAndIndex(nodeFrom, pointerArith.getAnOperand(), index) and
    hasInstructionAndIndex(nodeTo, pointerArith, index)
  )
}

pragma[noinline]
predicate hasOperandAndIndex(IndirectOperand indirectOperand, Operand operand, int index) {
  indirectOperand.getOperand() = operand and
  indirectOperand.getIndex() = index
}

pragma[noinline]
predicate hasInstructionAndIndex(IndirectInstruction indirectInstr, Instruction instr, int index) {
  indirectInstr.getInstruction() = instr and
  indirectInstr.getIndex() = index
}

private predicate indirectionInstructionFlow(IndirectInstruction nodeFrom, IndirectOperand nodeTo) {
  // If there's flow from an instruction to an operand, then there's also flow from the
  // indirect instruction to the indirect operand.
  exists(Operand operand, Instruction instr, int index |
    simpleOperandLocalFlowStep(pragma[only_bind_into](instr), pragma[only_bind_into](operand))
  |
    hasOperandAndIndex(nodeTo, operand, index) and
    hasInstructionAndIndex(nodeFrom, instr, index)
  )
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
cached
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Post update node -> Node flow
  Ssa::defUseFlow(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
  or
  // Def-use flow
  Ssa::defUseFlow(nodeFrom, nodeTo)
  or
  // Operand -> Instruction flow
  simpleInstructionLocalFlowStep(nodeFrom.asOperand(), nodeTo.asInstruction())
  or
  // Instruction -> Operand flow
  simpleOperandLocalFlowStep(nodeFrom.asInstruction(), nodeTo.asOperand())
  or
  // Phi node -> Node flow
  Ssa::fromPhiNode(nodeFrom, nodeTo)
  or
  // Indirect operand -> (indirect) instruction flow
  indirectionOperandFlow(nodeFrom, nodeTo)
  or
  // Indirect instruction -> indirect operand flow
  indirectionInstructionFlow(nodeFrom, nodeTo)
  or
  // Flow through modeled functions
  modelFlow(nodeFrom, nodeTo)
  or
  // Reverse flow: data that flows from the definition node back into the indirection returned
  // by a function. This allows data to flow 'in' through references returned by a modeled
  // function such as `operator[]`.
  exists(Operand address, int index |
    nodeHasOperand(nodeTo.(IndirectReturnOutNode), address, index)
  |
    exists(StoreInstruction store |
      nodeHasInstruction(nodeFrom, store, index - 1) and
      store.getDestinationAddressOperand() = address
    )
    or
    Ssa::outNodeHasAddressAndIndex(nodeFrom, address, index - 1)
  )
}

pragma[noinline]
private predicate getAddressType(LoadInstruction load, Type t) {
  exists(Instruction address |
    address = load.getSourceAddress() and
    t = address.getResultType()
  )
}

/**
 * Like the AST dataflow library, we want to conflate the address and value of a reference. This class
 * represents the `LoadInstruction` that is generated from a reference dereference.
 */
private class ReferenceDereferenceInstruction extends LoadInstruction {
  ReferenceDereferenceInstruction() {
    exists(ReferenceType ref |
      getAddressType(this, ref) and
      this.getResultType() = ref.getBaseType()
    )
  }
}

private predicate simpleInstructionLocalFlowStep(Operand opFrom, Instruction iTo) {
  // Treat all conversions as flow, even conversions between different numeric types.
  conversionFlow(opFrom, iTo, false)
  or
  iTo.(CopyInstruction).getSourceValueOperand() = opFrom
  or
  iTo.(PhiInstruction).getAnInputOperand() = opFrom
  or
  // Conflate references and values like in AST dataflow.
  iTo.(ReferenceDereferenceInstruction).getSourceAddressOperand() = opFrom
}

private predicate simpleOperandLocalFlowStep(Instruction iFrom, Operand opTo) {
  not opTo instanceof MemoryOperand and
  opTo.getDef() = iFrom
}

private predicate modelFlow(Node nodeFrom, Node nodeTo) {
  exists(
    CallInstruction call, DataFlowFunction func, FunctionInput modelIn, FunctionOutput modelOut
  |
    call.getStaticCallTarget() = func and
    func.hasDataFlow(modelIn, modelOut)
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
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

cached
private newtype TContent =
  TFieldContent(Field f, int index) {
    index = [1 .. Ssa::getMaxIndirectionsForType(f.getUnspecifiedType())] and
    // Reads and writes of union fields are tracked using `UnionContent`.
    not f.getDeclaringType() instanceof Union
  } or
  TUnionContent(Union u, int index) {
    // We key `UnionContent` by the union instead of its fields since a write to one field can be read by
    // any read of the union's fields.
    index = [1 .. max(Ssa::getMaxIndirectionsForType(u.getAField().getUnspecifiedType()))]
  } or
  TCollectionContent() or // Not used in C/C++
  TArrayContent() // Not used in C/C++.

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
}

/** A reference through a non-union instance field. */
class FieldContent extends Content, TFieldContent {
  Field f;
  int index;

  FieldContent() { this = TFieldContent(f, index) }

  override string toString() {
    index = 1 and result = f.toString()
    or
    index > 1 and result = f.toString() + " indirection"
  }

  Field getField() { result = f }

  pragma[inline]
  int getIndex() { pragma[only_bind_into](result) = pragma[only_bind_out](index) }
}

/** A reference through an instance field of a union. */
class UnionContent extends Content, TUnionContent {
  Union u;
  int index;

  UnionContent() { this = TUnionContent(u, index) }

  override string toString() {
    index = 1 and result = u.toString()
    or
    index > 1 and result = u.toString() + " indirection"
  }

  Field getAField() { result = u.getAField() }

  pragma[inline]
  int getIndex() { pragma[only_bind_into](result) = pragma[only_bind_out](index) }
}

/** A reference through an array. */
class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "[]" }
}

/** A reference through the contents of some collection-like container. */
private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "<element>" }
}

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet instanceof Content {
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

private IRBlock getBasicBlock(Node node) {
  node.asInstruction().getBlock() = result
  or
  node.asOperand().getUse().getBlock() = result
  or
  node.(SsaPhiNode).getPhiNode().getBasicBlock() = result
  or
  node.(IndirectOperand).getOperand().getUse().getBlock() = result
  or
  node.(IndirectInstruction).getInstruction().getBlock() = result
  or
  result = getBasicBlock(node.(PostUpdateNode).getPreUpdateNode())
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
  /** Gets a node that is safely guarded by the given guard check. */
  ExprNode getABarrierNode() {
    exists(IRGuardCondition g, Expr e, ValueNumber value, boolean edge |
      e = value.getAnInstruction().getConvertedResultExpression() and
      result.getConvertedExpr() = e and
      guardChecks(g, value.getAnInstruction().getConvertedResultExpression(), edge) and
      g.controls(getBasicBlock(result), edge)
    )
  }
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
module InstructionBarrierGuard<instructionGuardChecksSig/3 instructionGuardChecks> {
  /** Gets a node that is safely guarded by the given guard check. */
  ExprNode getABarrierNode() {
    exists(IRGuardCondition g, ValueNumber value, boolean edge |
      instructionGuardChecks(g, value.getAnInstruction(), edge) and
      result.asInstruction() = value.getAnInstruction() and
      g.controls(result.asInstruction().getBlock(), edge)
    )
  }
}

/**
 * DEPRECATED: Use `BarrierGuard` module instead.
 *
 * A guard that validates some instruction.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
deprecated class BarrierGuard extends IRGuardCondition {
  /** Override this predicate to hold if this guard validates `instr` upon evaluating to `b`. */
  predicate checksInstr(Instruction instr, boolean b) { none() }

  /** Override this predicate to hold if this guard validates `expr` upon evaluating to `b`. */
  predicate checks(Expr e, boolean b) { none() }

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(ValueNumber value, boolean edge |
      (
        this.checksInstr(value.getAnInstruction(), edge)
        or
        this.checks(value.getAnInstruction().getConvertedResultExpression(), edge)
      ) and
      result.asInstruction() = value.getAnInstruction() and
      this.controls(result.asInstruction().getBlock(), edge)
    )
  }
}
