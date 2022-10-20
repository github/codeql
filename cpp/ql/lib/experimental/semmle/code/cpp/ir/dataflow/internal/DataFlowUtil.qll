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
   * - `IndirectInstruction`, which represents the value of `instr` after loading the address a number
   * of times.
   */
  cached
  newtype TIRDataFlowNode =
    TInstructionNode(Instruction i) { not Ssa::ignoreInstruction(i) } or
    TOperandNode(Operand op) { not Ssa::ignoreOperand(op) } or
    TVariableNode(Variable var) or
    TPostFieldUpdateNode(FieldAddress operand, int indirectionIndex) {
      indirectionIndex =
        [1 .. Ssa::countIndirectionsForCppType(operand.getObjectAddress().getResultLanguageType())]
    } or
    TSsaPhiNode(Ssa::PhiNode phi) or
    TIndirectArgumentOutNode(ArgumentOperand operand, int indirectionIndex) {
      Ssa::isModifiableByCall(operand) and
      indirectionIndex = [1 .. Ssa::countIndirectionsForCppType(operand.getLanguageType())]
    } or
    TIndirectOperand(Operand op, int indirectionIndex) {
      Ssa::hasIndirectOperand(op, indirectionIndex)
    } or
    TIndirectInstruction(Instruction instr, int indirectionIndex) {
      Ssa::hasIndirectInstruction(instr, indirectionIndex)
    }
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
  DataFlowType getType() { none() } // overridden in subclasses

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

  /**
   * Gets the non-conversion expression that's indirectly tracked by this node
   * under `index` number of indirections.
   */
  Expr asIndirectExpr(int index) {
    exists(Operand operand | hasOperandAndIndex(this, operand, index) |
      result = operand.getDef().getUnconvertedResultExpression()
    )
  }

  /**
   * Gets the non-conversion expression that's indirectly tracked by this node
   * behind a number of indirections.
   */
  Expr asIndirectExpr() { result = this.asIndirectExpr(_) }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.(ExprNode).getConvertedExpr() }

  /**
   * Gets the expression that's indirectly tracked by this node
   * behind `index` number of indirections.
   */
  Expr asIndirectConvertedExpr(int index) {
    exists(Operand operand | hasOperandAndIndex(this, operand, index) |
      result = operand.getDef().getConvertedResultExpression()
    )
  }

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
    // Subtract one because `DefinitionByReferenceNode` is defined to be in
    // the range `[0 ... n - 1]` for some `n` instead of `[1 ... n]`.
    this.(DefinitionByReferenceNode).getIndirectionIndex() = index - 1 and
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
    this.(SideEffectOperandNode).getIndirectionIndex() = index and
    result = this.(SideEffectOperandNode).getArgument()
  }

  /**
   * Gets the the argument going into a function for a node that represents
   * the indirect value of the argument after any non-zero number of loads.
   */
  Expr asIndirectArgument() { result = this.asIndirectArgument(_) }

  /** Gets the positional parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.asParameter(0) }

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
   * The node `n` such that `n.asParameter(2)` is the parameter `x` represents
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

  override DataFlowType getType() { result = instr.getResultType() }

  final override Location getLocationImpl() { result = instr.getLocation() }

  override string toStringImpl() {
    // This predicate is overridden in subclasses. This default implementation
    // does not use `Instruction.toString` because that's expensive to compute.
    result = this.getInstruction().getOpcode().toString()
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

  override DataFlowType getType() { result = op.getType() }

  final override Location getLocationImpl() { result = op.getLocation() }

  override string toStringImpl() { result = this.getOperand().toString() }
}

/**
 * Returns `t`, but stripped of the `n` outermost pointers, references, etc.
 *
 * For example, `stripPointers(int*&, 2)` is `int` and `stripPointers(int*, 0)` is `int*`.
 */
private Type stripPointers(Type t, int n) {
  result = t and n = 0
  or
  result = stripPointers(t.(PointerType).getBaseType(), n - 1)
  or
  result = stripPointers(t.(ArrayType).getBaseType(), n - 1)
  or
  result = stripPointers(t.(ReferenceType).getBaseType(), n - 1)
  or
  result = stripPointers(t.(PointerToMemberType).getBaseType(), n - 1)
  or
  result = stripPointers(t.(FunctionPointerIshType).getBaseType(), n - 1)
}

/**
 * INTERNAL: do not use.
 *
 * The node representing the value of a field after it has been updated.
 */
class PostFieldUpdateNode extends TPostFieldUpdateNode, PartialDefinitionNode {
  int indirectionIndex;
  FieldAddress fieldAddress;

  PostFieldUpdateNode() { this = TPostFieldUpdateNode(fieldAddress, indirectionIndex) }

  override Function getFunction() { result = fieldAddress.getUse().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  FieldAddress getFieldAddress() { result = fieldAddress }

  Field getUpdatedField() { result = fieldAddress.getField() }

  int getIndirectionIndex() { result = indirectionIndex }

  override Node getPreUpdateNode() {
    hasOperandAndIndex(result, pragma[only_bind_into](fieldAddress).getObjectAddressOperand(),
      indirectionIndex)
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

  override DataFlowType getType() { result = this.getAnInput().getType() }

  final override Location getLocationImpl() { result = phi.getBasicBlock().getLocation() }

  override string toStringImpl() { result = "Phi" }

  /**
   * Gets a node that is used as input to this phi node.
   * `fromBackEdge` is true if data flows along a back-edge,
   * and `false` otherwise.
   */
  final Node getAnInput(boolean fromBackEdge) {
    localFlowStep(result, this) and
    if phi.getBasicBlock().dominates(getBasicBlock(result))
    then fromBackEdge = true
    else fromBackEdge = false
  }

  /** Gets a node that is used as input to this phi node. */
  final Node getAnInput() { result = this.getAnInput(_) }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing a value after leaving a function.
 */
class SideEffectOperandNode extends Node, IndirectOperand {
  CallInstruction call;
  int argumentIndex;

  SideEffectOperandNode() { operand = call.getArgumentOperand(argumentIndex) }

  CallInstruction getCallInstruction() { result = call }

  Operand getAddressOperand() { result = operand }

  int getArgumentIndex() { result = argumentIndex }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = call.getEnclosingFunction() }

  Expr getArgument() { result = call.getArgument(argumentIndex).getUnconvertedResultExpression() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing an indirection of a parameter.
 */
class IndirectParameterNode extends Node, IndirectInstruction {
  InitializeParameterInstruction init;

  IndirectParameterNode() { this.getInstruction() = init }

  int getArgumentIndex() { init.hasIndex(result) }

  /** Gets the parameter whose indirection is initialized. */
  Parameter getParameter() { result = init.getParameter() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = this.getInstruction().getEnclosingFunction() }

  override string toStringImpl() {
    result = this.getParameter().toString() + " indirection"
    or
    not exists(this.getParameter()) and
    result = "this indirection"
  }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the indirection of a value that is
 * about to be returned from a function.
 */
class IndirectReturnNode extends IndirectOperand {
  IndirectReturnNode() {
    this.getOperand() = any(ReturnIndirectionInstruction ret).getSourceAddressOperand()
    or
    this.getOperand() = any(ReturnValueInstruction ret).getReturnAddressOperand()
  }

  Operand getAddressOperand() { result = operand }

  override Declaration getEnclosingCallable() { result = this.getFunction() }
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the indirection of a value after it
 * has been returned from a function.
 */
class IndirectArgumentOutNode extends Node, TIndirectArgumentOutNode, PostUpdateNode {
  ArgumentOperand operand;
  int indirectionIndex;

  IndirectArgumentOutNode() { this = TIndirectArgumentOutNode(operand, indirectionIndex) }

  int getIndirectionIndex() { result = indirectionIndex }

  int getArgumentIndex() {
    exists(CallInstruction call | call.getArgumentOperand(result) = operand)
  }

  Operand getAddressOperand() { result = operand }

  CallInstruction getCallInstruction() { result.getAnArgumentOperand() = operand }

  Function getStaticCallTarget() { result = this.getCallInstruction().getStaticCallTarget() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = this.getCallInstruction().getEnclosingFunction() }

  override Node getPreUpdateNode() { hasOperandAndIndex(result, operand, indirectionIndex) }

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
predicate indirectReturnOutNodeOperand0(CallInstruction call, Operand operand, int indirectionIndex) {
  Ssa::hasIndirectInstruction(call, indirectionIndex) and
  operandForfullyConvertedCall(operand, call)
}

pragma[nomagic]
predicate indirectReturnOutNodeInstruction0(
  CallInstruction call, Instruction instr, int indirectionIndex
) {
  Ssa::hasIndirectInstruction(call, indirectionIndex) and
  instructionForfullyConvertedCall(instr, call)
}

/**
 * INTERNAL: do not use.
 *
 * A node representing the value of a function call.
 */
class IndirectReturnOutNode extends Node {
  CallInstruction call;
  int indirectionIndex;

  IndirectReturnOutNode() {
    // Annoyingly, we need to pick the fully converted value as the output of the function to
    // make flow through in the shared dataflow library work correctly.
    exists(Operand operand |
      indirectReturnOutNodeOperand0(call, operand, indirectionIndex) and
      hasOperandAndIndex(this, operand, indirectionIndex)
    )
    or
    exists(Instruction instr |
      indirectReturnOutNodeInstruction0(call, instr, indirectionIndex) and
      hasInstructionAndIndex(this, instr, indirectionIndex)
    )
  }

  CallInstruction getCallInstruction() { result = call }

  int getIndirectionIndex() { result = indirectionIndex }
}

private PointerType getGLValueType(Type t, int indirectionIndex) {
  result.getBaseType() = stripPointers(t, indirectionIndex - 1)
}

bindingset[isGLValue]
private DataFlowType getTypeImpl(Type t, int indirectionIndex, boolean isGLValue) {
  if isGLValue = true
  then
    result = getGLValueType(t, indirectionIndex)
    or
    // Ideally, the above case would cover all glvalue cases. However, consider the case where
    // the database consists only of:
    // ```
    // void test() {
    //   int* x;
    //   x = nullptr;
    // }
    // ```
    // and we want to compute the type of `*x` in the assignment `x = nullptr`. Here, `x` is an lvalue
    // of type int* (which morally is an int**). So when we call `getTypeImpl` it will be with the
    // parameters:
    // - t = int*
    // - indirectionIndex = 1 (when we want to model the dataflow node corresponding to *x)
    // - isGLValue = true
    // In this case, `getTypeImpl(t, indirectionIndex, isGLValue)` should give back `int**`. In this
    // case, however, `int**` does not exist in the database. So instead we return int* (which is
    // wrong, but at least we have a type).
    not exists(getGLValueType(t, indirectionIndex)) and
    result = stripPointers(t, indirectionIndex - 1)
  else result = stripPointers(t, indirectionIndex)
}

/**
 * INTERNAL: Do not use.
 *
 * A node that represents the indirect value of an operand in the IR
 * after `index` number of loads.
 */
class IndirectOperand extends Node, TIndirectOperand {
  Operand operand;
  int indirectionIndex;

  IndirectOperand() { this = TIndirectOperand(operand, indirectionIndex) }

  /** Gets the underlying instruction. */
  Operand getOperand() { result = operand }

  int getIndirectionIndex() { result = indirectionIndex }

  override Function getFunction() { result = this.getOperand().getDef().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override DataFlowType getType() {
    exists(boolean isGLValue | if operand.isGLValue() then isGLValue = true else isGLValue = false |
      result = getTypeImpl(operand.getType().getUnspecifiedType(), indirectionIndex, isGLValue)
    )
  }

  final override Location getLocationImpl() { result = this.getOperand().getLocation() }

  override string toStringImpl() {
    result = instructionNode(this.getOperand().getDef()).toStringImpl() + " indirection"
  }
}

/**
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
class UninitializedNode extends Node {
  LocalVariable v;

  UninitializedNode() {
    exists(Ssa::Def def |
      def.getDefiningInstruction() instanceof UninitializedInstruction and
      Ssa::nodeToDefOrUse(this, def) and
      v = def.getSourceVariable().getBaseVariable().(Ssa::BaseIRVariable).getIRVariable().getAst()
    )
  }

  /** Gets the uninitialized local variable corresponding to this node. */
  LocalVariable getLocalVariable() { result = v }
}

/**
 * INTERNAL: Do not use.
 *
 * A node that represents the indirect value of an instruction in the IR
 * after `index` number of loads.
 */
class IndirectInstruction extends Node, TIndirectInstruction {
  Instruction instr;
  int indirectionIndex;

  IndirectInstruction() { this = TIndirectInstruction(instr, indirectionIndex) }

  /** Gets the underlying instruction. */
  Instruction getInstruction() { result = instr }

  int getIndirectionIndex() { result = indirectionIndex }

  override Function getFunction() { result = this.getInstruction().getEnclosingFunction() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override DataFlowType getType() {
    exists(boolean isGLValue | if instr.isGLValue() then isGLValue = true else isGLValue = false |
      result = getTypeImpl(instr.getResultType().getUnspecifiedType(), indirectionIndex, isGLValue)
    )
  }

  final override Location getLocationImpl() { result = this.getInstruction().getLocation() }

  override string toStringImpl() {
    result = instructionNode(this.getInstruction()).toStringImpl() + " indirection"
  }
}

private predicate isFullyConvertedArgument(Expr e) {
  e = any(Call call).getAnArgument().getFullyConverted()
}

private predicate isFullyConvertedCall(Expr e) { e = any(Call call).getFullyConverted() }

/** Holds if `Node::asExpr` should map an some operand node to `e`. */
private predicate convertedExprMustBeOperand(Expr e) {
  isFullyConvertedArgument(e)
  or
  isFullyConvertedCall(e)
}

/** Holds if `node` is an `OperandNode` that should map `node.asExpr()` to `e`. */
predicate exprNodeShouldBeOperand(Node node, Expr e) {
  e = node.asOperand().getDef().getConvertedResultExpression() and
  convertedExprMustBeOperand(e)
}

/**
 * Holds if `load` is a `LoadInstruction` that is the result of evaluating `e`
 * and `node` is an `IndirectOperandNode` that should map `node.asExpr()` to `e`.
 *
 * We map `e` to `node.asExpr()` when `node` semantically represents the
 * same value as `load`. A subsequent flow step will flow `node` to
 * the `LoadInstruction`.
 */
private predicate exprNodeShouldBeIndirectOperand(IndirectOperand node, Expr e, LoadInstruction load) {
  node.getIndirectionIndex() = 1 and
  e = load.getConvertedResultExpression() and
  load.getSourceAddressOperand() = node.getOperand() and
  not convertedExprMustBeOperand(e)
}

/** Holds if `node` should be an instruction node that maps `node.asExpr()` to `e`. */
predicate exprNodeShouldBeInstruction(Node node, Expr e) {
  e = node.asInstruction().getConvertedResultExpression() and
  not exprNodeShouldBeOperand(_, e) and
  not exprNodeShouldBeIndirectOperand(_, e, _)
}

private class ExprNodeBase extends Node {
  Expr getConvertedExpr() { none() } // overridden by subclasses

  Expr getExpr() { none() } // overridden by subclasses
}

private class InstructionExprNode extends ExprNodeBase, InstructionNode {
  InstructionExprNode() { exprNodeShouldBeInstruction(this, _) }

  final override Expr getConvertedExpr() { exprNodeShouldBeInstruction(this, result) }

  final override Expr getExpr() { result = this.getInstruction().getUnconvertedResultExpression() }

  final override string toStringImpl() { result = this.getConvertedExpr().toString() }
}

private class OperandExprNode extends ExprNodeBase, OperandNode {
  OperandExprNode() { exprNodeShouldBeOperand(this, _) }

  final override Expr getConvertedExpr() { exprNodeShouldBeOperand(this, result) }

  final override Expr getExpr() {
    result = this.getOperand().getDef().getUnconvertedResultExpression()
  }

  final override string toStringImpl() {
    // Avoid generating multiple `toString` results for `ArgumentNode`s
    // since they have a better `toString`.
    result = this.(ArgumentNode).toStringImpl()
    or
    not this instanceof ArgumentNode and
    result = this.getConvertedExpr().toString()
  }
}

private class IndirectOperandExprNode extends ExprNodeBase, IndirectOperand {
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
  IndirectionPosition pos, int argumentIndex, int indirectionIndex
) {
  pos.getArgumentIndex() = argumentIndex and
  pos.getIndirectionIndex() = indirectionIndex
}

pragma[noinline]
private predicate indirectParameterNodeHasArgumentIndexAndIndex(
  IndirectParameterNode node, int argumentIndex, int indirectionIndex
) {
  node.getArgumentIndex() = argumentIndex and
  node.getIndirectionIndex() = indirectionIndex
}

/** A synthetic parameter to model the pointed-to object of a pointer parameter. */
class ParameterIndirectionNode extends ParameterNode instanceof IndirectParameterNode {
  override predicate isParameterOf(Function f, ParameterPosition pos) {
    IndirectParameterNode.super.getEnclosingCallable() = f and
    exists(int argumentIndex, int indirectionIndex |
      indirectPostionHasArgumentIndexAndIndex(pos, argumentIndex, indirectionIndex) and
      indirectParameterNodeHasArgumentIndexAndIndex(this, argumentIndex, indirectionIndex)
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

  override DataFlowType getType() { result = v.getType() }

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
  exists(Operand operand, Instruction instr, int indirectionIndex |
    simpleInstructionLocalFlowStep(operand, instr) and
    hasOperandAndIndex(nodeFrom, operand, indirectionIndex) and
    hasInstructionAndIndex(nodeTo, instr, indirectionIndex)
  )
  or
  // If there's indirect flow to an operand, then there's also indirect
  // flow to the operand after applying some pointer arithmetic.
  exists(PointerArithmeticInstruction pointerArith, int indirectionIndex |
    hasOperandAndIndex(nodeFrom, pointerArith.getAnOperand(), indirectionIndex) and
    hasInstructionAndIndex(nodeTo, pointerArith, indirectionIndex)
  )
}

pragma[noinline]
predicate hasOperandAndIndex(IndirectOperand indirectOperand, Operand operand, int indirectionIndex) {
  indirectOperand.getOperand() = operand and
  indirectOperand.getIndirectionIndex() = indirectionIndex
}

pragma[noinline]
predicate hasInstructionAndIndex(
  IndirectInstruction indirectInstr, Instruction instr, int indirectionIndex
) {
  indirectInstr.getInstruction() = instr and
  indirectInstr.getIndirectionIndex() = indirectionIndex
}

private predicate indirectionInstructionFlow(IndirectInstruction nodeFrom, IndirectOperand nodeTo) {
  // If there's flow from an instruction to an operand, then there's also flow from the
  // indirect instruction to the indirect operand.
  exists(Operand operand, Instruction instr, int indirectionIndex |
    simpleOperandLocalFlowStep(pragma[only_bind_into](instr), pragma[only_bind_into](operand))
  |
    hasOperandAndIndex(nodeTo, operand, indirectionIndex) and
    hasInstructionAndIndex(nodeFrom, instr, indirectionIndex)
  )
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Post update node -> Node flow
  Ssa::ssaFlow(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
  or
  // Def-use/Use-use flow
  Ssa::ssaFlow(nodeFrom, nodeTo)
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
  exists(Operand address, int indirectionIndex |
    nodeHasOperand(nodeTo.(IndirectReturnOutNode), address, indirectionIndex)
  |
    exists(StoreInstruction store |
      nodeHasInstruction(nodeFrom, store, indirectionIndex - 1) and
      store.getDestinationAddressOperand() = address
    )
    or
    Ssa::outNodeHasAddressAndIndex(nodeFrom, address, indirectionIndex)
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
  TFieldContent(Field f, int indirectionIndex) {
    indirectionIndex = [1 .. Ssa::getMaxIndirectionsForType(f.getUnspecifiedType())] and
    // Reads and writes of union fields are tracked using `UnionContent`.
    not f.getDeclaringType() instanceof Union
  } or
  TUnionContent(Union u, int indirectionIndex) {
    // We key `UnionContent` by the union instead of its fields since a write to one
    // field can be read by any read of the union's fields.
    indirectionIndex =
      [1 .. max(Ssa::getMaxIndirectionsForType(u.getAField().getUnspecifiedType()))]
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
  int indirectionIndex;

  FieldContent() { this = TFieldContent(f, indirectionIndex) }

  override string toString() {
    indirectionIndex = 1 and result = f.toString()
    or
    indirectionIndex > 1 and result = f.toString() + " indirection"
  }

  Field getField() { result = f }

  pragma[inline]
  int getIndirectionIndex() {
    pragma[only_bind_into](result) = pragma[only_bind_out](indirectionIndex)
  }
}

/** A reference through an instance field of a union. */
class UnionContent extends Content, TUnionContent {
  Union u;
  int indirectionIndex;

  UnionContent() { this = TUnionContent(u, indirectionIndex) }

  override string toString() {
    indirectionIndex = 1 and result = u.toString()
    or
    indirectionIndex > 1 and result = u.toString() + " indirection"
  }

  Field getAField() { result = u.getAField() }

  pragma[inline]
  int getIndirectionIndex() {
    pragma[only_bind_into](result) = pragma[only_bind_out](indirectionIndex)
  }
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
