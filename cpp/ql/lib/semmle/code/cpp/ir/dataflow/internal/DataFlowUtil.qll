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
private import SsaInternals as Ssa

cached
private module Cached {
  /**
   * The IR dataflow graph consists of the following nodes:
   * - `InstructionNode`, which represents an `Instruction` in the graph.
   * - `OperandNode`, which represents an `Operand` in the graph.
   * - `VariableNode`, which is used to model global variables.
   * - Two kinds of `StoreNode`s:
   *   1. `StoreNodeInstr`, which represents the value of an address computed by an `Instruction` that
   *      has been updated by a write operation.
   *   2. `StoreNodeOperand`, which represents the value of an address in an `ArgumentOperand` after a
   *      function call that may have changed the value.
   * - `ReadNode`, which represents the result of reading a field of an object.
   * - `SsaPhiNode`, which represents phi nodes as computed by the shared SSA library.
   *
   * The following section describes how flow is generally transferred between these nodes:
   * - Flow between `InstructionNode`s and `OperandNode`s follow the def-use information as computed by
   *   the IR. Because the IR compute must-alias information for memory operands, we only follow def-use
   *   flow for register operands.
   * - Flow can enter a `StoreNode` in two ways (both done in `StoreNode.flowInto`):
   *   1. Flow is transferred from a `StoreValueOperand` to a `StoreNodeInstr`. Flow will then proceed
   *      along the chain of addresses computed by `StoreNodeInstr.getInner` to identify field writes
   *      and call `storeStep` accordingly (i.e., for an expression like `a.b.c = x`, we visit `c`, then
   *      `b`, then `a`).
   *   2. Flow is transfered from a `WriteSideEffectInstruction` to a `StoreNodeOperand` after flow
   *      returns to a caller. Flow will then proceed to the defining instruction of the operand (because
   *      the `StoreNodeInstr` computed by `StoreNodeOperand.getInner()` is the `StoreNode` containing
   *      the defining instruction), and then along the chain computed by `StoreNodeInstr.getInner` like
   *      above.
   *   In both cases, flow leaves a `StoreNode` once the entire chain has been traversed, and the shared
   *   SSA library is used to find the next use of the variable at the end of the chain.
   * - Flow can enter a `ReadNode` through an `OperandNode` that represents an address of some variable.
   *   Flow will then proceed along the chain of addresses computed by `ReadNode.getOuter` (i.e., for an
   *   expression like `use(a.b.c)` we visit `a`, then `b`, then `c`) and call `readStep` accordingly.
   *   Once the entire chain has been traversed, flow is transferred to the load instruction that reads
   *   the final address of the chain.
   * - Flow can enter a `SsaPhiNode` from an `InstructionNode`, a `StoreNode` or another `SsaPhiNode`
   *   (in `toPhiNode`), depending on which node provided the previous definition of the underlying
   *   variable. Flow leaves a `SsaPhiNode` (in `fromPhiNode`) by using the shared SSA library to
   *   determine the next use of the variable.
   */
  cached
  newtype TIRDataFlowNode =
    TInstructionNode(Instruction i) or
    TOperandNode(Operand op) or
    TVariableNode(Variable var) or
    TStoreNodeInstr(Instruction i) { Ssa::explicitWrite(_, _, i) } or
    TStoreNodeOperand(ArgumentOperand op) { Ssa::explicitWrite(_, _, op.getDef()) } or
    TReadNode(Instruction i) { needsPostReadNode(i) } or
    TSsaPhiNode(Ssa::PhiNode phi)

  cached
  predicate localFlowStepCached(Node nodeFrom, Node nodeTo) {
    simpleLocalFlowStep(nodeFrom, nodeTo)
  }

  private predicate needsPostReadNode(Instruction iFrom) {
    // If the instruction generates an address that flows to a load.
    Ssa::addressFlowTC(iFrom, Ssa::getSourceAddress(_)) and
    (
      // And it is either a field address
      iFrom instanceof FieldAddressInstruction
      or
      // Or it is instruction that either uses or is used for an address that needs a post read node.
      exists(Instruction mid | needsPostReadNode(mid) |
        Ssa::addressFlow(mid, iFrom) or Ssa::addressFlow(iFrom, mid)
      )
    )
  }
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
  Function getFunction() { none() } // overridden in subclasses

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

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.(ExprNode).getConvertedExpr() }

  /**
   * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
   * This predicate should be used instead of `asExpr` when referring to the
   * value of a reference argument _after_ the call has returned. For example,
   * in `f(&x)`, this predicate will have `&x` as its result for the `Node`
   * that represents the new value of `x`.
   */
  Expr asDefiningArgument() { result = this.(DefinitionByReferenceNode).getArgument() }

  /** Gets the positional parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

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
  Location getLocation() { none() } // overridden by subclasses

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
  string toString() { none() } // overridden by subclasses
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

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override IRType getType() { result = instr.getResultIRType() }

  override Location getLocation() { result = instr.getLocation() }

  override string toString() {
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

  override Function getFunction() { result = op.getUse().getEnclosingFunction() }

  override IRType getType() { result = op.getIRType() }

  override Location getLocation() { result = op.getLocation() }

  override string toString() { result = this.getOperand().toString() }
}

/**
 * INTERNAL: do not use.
 *
 * A `StoreNode` is a node that has been (or is about to be) the
 * source or target of a `storeStep`.
 */
abstract private class StoreNode extends Node {
  /** Holds if this node should receive flow from `addr`. */
  abstract predicate flowInto(Instruction addr);

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  /** Holds if this `StoreNode` is the root of the address computation used by a store operation. */
  predicate isTerminal() {
    not exists(this.getInner()) and
    not storeStep(this, _, _)
  }

  /** Gets the store operation that uses the address computed by this `StoreNode`. */
  abstract Instruction getStoreInstruction();

  /** Holds if the store operation associated with this `StoreNode` overwrites the entire variable. */
  final predicate isCertain() { Ssa::explicitWrite(true, this.getStoreInstruction(), _) }

  /**
   * Gets the `StoreNode` that computes the address used by this `StoreNode`.
   */
  abstract StoreNode getInner();

  /** The inverse of `StoreNode.getInner`. */
  final StoreNode getOuter() { result.getInner() = this }
}

class StoreNodeInstr extends StoreNode, TStoreNodeInstr {
  Instruction instr;

  StoreNodeInstr() { this = TStoreNodeInstr(instr) }

  override predicate flowInto(Instruction addr) { this.getInstruction() = addr }

  /** Gets the underlying instruction. */
  Instruction getInstruction() { result = instr }

  override Function getFunction() { result = this.getInstruction().getEnclosingFunction() }

  override IRType getType() { result = this.getInstruction().getResultIRType() }

  override Location getLocation() { result = this.getInstruction().getLocation() }

  override string toString() {
    result = instructionNode(this.getInstruction()).toString() + " [store]"
  }

  override Instruction getStoreInstruction() {
    Ssa::explicitWrite(_, result, this.getInstruction())
  }

  override StoreNodeInstr getInner() {
    Ssa::addressFlow(result.getInstruction(), this.getInstruction())
  }
}

/**
 * To avoid having `PostUpdateNode`s with multiple pre-update nodes (which can cause performance
 * problems) we attach the `PostUpdateNode` that represent output arguments to an operand instead of
 * an instruction.
 *
 * To see why we need this, consider the expression `b->set(new C())`. The IR of this expression looks
 * like (simplified):
 * ```
 * r1(glval<unknown>) = FunctionAddress[set]            :
 * r2(glval<unknown>) = FunctionAddress[operator new]   :
 * r3(unsigned long)  = Constant[8]                     :
 * r4(void *)         = Call[operator new]              : func:r2, 0:r3
 * r5(C *)            = Convert                         : r4
 * r6(glval<unknown>) = FunctionAddress[C]              :
 * v1(void)           = Call[C]                         : func:r6, this:r5
 * v2(void)           = Call[set]                       : func:r1, this:r0, 0:r5
 * ```
 *
 * Notice that both the call to `C` and the call to `set` will have an argument that is the
 * result of calling `operator new` (i.e., `r4`). If we only have `PostUpdateNode`s that are
 * instructions, both `PostUpdateNode`s would have `r4` as their pre-update node.
 *
 * We avoid this issue by having a `PostUpdateNode` for each argument, and let the pre-update node of
 * each `PostUpdateNode` be the argument _operand_, instead of the defining instruction.
 */
class StoreNodeOperand extends StoreNode, TStoreNodeOperand {
  ArgumentOperand operand;

  StoreNodeOperand() { this = TStoreNodeOperand(operand) }

  override predicate flowInto(Instruction addr) { this.getOperand().getDef() = addr }

  /** Gets the underlying operand. */
  Operand getOperand() { result = operand }

  override Function getFunction() { result = operand.getDef().getEnclosingFunction() }

  override IRType getType() { result = operand.getIRType() }

  override Location getLocation() { result = operand.getLocation() }

  override string toString() { result = operandNode(this.getOperand()).toString() + " [store]" }

  override WriteSideEffectInstruction getStoreInstruction() {
    Ssa::explicitWrite(_, result, operand.getDef())
  }

  /**
   * The result of `StoreNodeOperand.getInner` is the `StoreNodeInstr` representation the instruction
   * that defines this operand. This means the graph of `getInner` looks like this:
   * ```
   * I---I---I
   *  \   \   \
   *   O   O   O
   * ```
   * where each `StoreNodeOperand` "hooks" into the chain computed by `StoreNodeInstr.getInner`.
   * This means that the chain of `getInner` calls on the argument `&o.f` on an expression
   * like `func(&o.f)` is:
   * ```
   * r4---r3---r2
   *  \
   *   0:r4
   * ```
   * where the IR for `func(&o.f)` looks like (simplified):
   * ```
   * r1(glval<unknown>) = FunctionAddress[func]        :
   * r2(glval<O>)       = VariableAddress[o]           :
   * r3(glval<int>)     = FieldAddress[f]              : r2
   * r4(int *)          = CopyValue                    : r3
   * v1(void)           = Call[func]                   : func:r1, 0:r4
   * ```
   */
  override StoreNodeInstr getInner() { operand.getDef() = result.getInstruction() }
}

/**
 * INTERNAL: do not use.
 *
 * A `ReadNode` is a node that has been (or is about to be) the
 * source or target of a `readStep`.
 */
class ReadNode extends Node, TReadNode {
  Instruction i;

  ReadNode() { this = TReadNode(i) }

  /** Gets the underlying instruction. */
  Instruction getInstruction() { result = i }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = this.getInstruction().getEnclosingFunction() }

  override IRType getType() { result = this.getInstruction().getResultIRType() }

  override Location getLocation() { result = this.getInstruction().getLocation() }

  override string toString() {
    result = instructionNode(this.getInstruction()).toString() + " [read]"
  }

  /** Gets a load instruction that uses the address computed by this read node. */
  final Instruction getALoadInstruction() {
    Ssa::addressFlowTC(this.getInstruction(), Ssa::getSourceAddress(result))
  }

  /**
   * Gets a read node with an underlying instruction that is used by this
   * underlying instruction to compute an address of a load instruction.
   */
  final ReadNode getInner() { Ssa::addressFlow(result.getInstruction(), this.getInstruction()) }

  /** The inverse of `ReadNode.getInner`. */
  final ReadNode getOuter() { result.getInner() = this }

  /** Holds if this read node computes a value that will not be used for any future read nodes. */
  final predicate isTerminal() {
    not exists(this.getOuter()) and
    not readStep(this, _, _)
  }

  /** Holds if this read node computes a value that has not yet been used for any read operations. */
  final predicate isInitial() {
    not exists(this.getInner()) and
    not readStep(_, _, this)
  }
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

  override Function getFunction() { result = phi.getBasicBlock().getEnclosingFunction() }

  override IRType getType() { result instanceof IRVoidType }

  override Location getLocation() { result = phi.getBasicBlock().getLocation() }

  /** Holds if this phi node has input from the `rnk`'th write operation in block `block`. */
  final predicate hasInputAtRankInBlock(IRBlock block, int rnk) {
    this.hasInputAtRankInBlock(block, rnk, _)
  }

  /**
   * Holds if this phi node has input from the definition `input` (which is the `rnk`'th write
   * operation in block `block`).
   */
  cached
  final predicate hasInputAtRankInBlock(IRBlock block, int rnk, Ssa::Definition input) {
    Ssa::phiHasInputFromBlock(phi, input, _) and input.definesAt(_, block, rnk)
  }

  override string toString() { result = "Phi" }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends InstructionNode {
  ExprNode() { exists(instr.getConvertedResultExpression()) }

  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr getExpr() { result = instr.getUnconvertedResultExpression() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr getConvertedExpr() { result = instr.getConvertedResultExpression() }

  override string toString() { result = this.asConvertedExpr().toString() }
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
class ParameterNode extends InstructionNode {
  ParameterNode() {
    // To avoid making this class abstract, we enumerate its values here
    instr instanceof InitializeParameterInstruction
    or
    instr instanceof InitializeIndirectionInstruction
  }

  /**
   * Holds if this node is the parameter of `f` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  predicate isParameterOf(Function f, ParameterPosition pos) { none() } // overridden by subclasses
}

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ExplicitParameterNode() { exists(instr.getParameter()) }

  override predicate isParameterOf(Function f, ParameterPosition pos) {
    f.getParameter(pos.(DirectPosition).getIndex()) = instr.getParameter()
  }

  /** Gets the `Parameter` associated with this node. */
  Parameter getParameter() { result = instr.getParameter() }

  override string toString() { result = instr.getParameter().toString() }
}

/** An implicit `this` parameter. */
class ThisParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ThisParameterNode() { instr.getIRVariable() instanceof IRThisVariable }

  override predicate isParameterOf(Function f, ParameterPosition pos) {
    pos.(DirectPosition).getIndex() = -1 and instr.getEnclosingFunction() = f
  }

  override string toString() { result = "this" }
}

/** A synthetic parameter to model the pointed-to object of a pointer parameter. */
class ParameterIndirectionNode extends ParameterNode {
  override InitializeIndirectionInstruction instr;

  override predicate isParameterOf(Function f, ParameterPosition pos) {
    exists(int index |
      instr.getEnclosingFunction() = f and
      instr.hasIndex(index)
    |
      pos.(IndirectionPosition).getIndex() = index
    )
  }

  override string toString() { result = "*" + instr.getIRVariable().toString() }
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

  override string toString() { result = this.getPreUpdateNode() + " [post update]" }
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

private class FieldPartialDefinitionNode extends PartialDefinitionNode, StoreNodeInstr {
  FieldPartialDefinitionNode() {
    this.getInstruction() = any(FieldAddressInstruction fai).getObjectAddress()
  }

  override Node getPreUpdateNode() { result.asInstruction() = this.getInstruction() }

  override Expr getDefinedExpr() { result = this.getInstruction().getUnconvertedResultExpression() }

  override string toString() { result = PartialDefinitionNode.super.toString() }
}

private class NonPartialDefinitionPostUpdate extends PostUpdateNode, StoreNodeInstr {
  NonPartialDefinitionPostUpdate() { not this instanceof PartialDefinitionNode }

  override Node getPreUpdateNode() { result.asInstruction() = this.getInstruction() }

  override string toString() { result = PostUpdateNode.super.toString() }
}

private class ArgumentPostUpdateNode extends PartialDefinitionNode, StoreNodeOperand {
  override ArgumentNode getPreUpdateNode() { result.asOperand() = operand }

  override Expr getDefinedExpr() {
    result = this.getOperand().getDef().getUnconvertedResultExpression()
  }

  override string toString() { result = PartialDefinitionNode.super.toString() }
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
class DefinitionByReferenceNode extends InstructionNode {
  override WriteSideEffectInstruction instr;

  /** Gets the unconverted argument corresponding to this node. */
  Expr getArgument() {
    result =
      instr
          .getPrimaryInstruction()
          .(CallInstruction)
          .getArgument(instr.getIndex())
          .getUnconvertedResultExpression()
  }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    exists(CallInstruction ci | result = ci.getStaticCallTarget().getParameter(instr.getIndex()))
  }

  override string toString() {
    // This string should be unique enough to be helpful but common enough to
    // avoid storing too many different strings.
    result =
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget().getName() +
        " output argument"
    or
    not exists(instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget()) and
    result = "output argument"
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

  override Function getFunction() { none() }

  override Declaration getEnclosingCallable() {
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = v
  }

  override IRType getType() { result.getCanonicalLanguageType().hasUnspecifiedType(v.getType(), _) }

  override Location getLocation() { result = v.getLocation() }

  override string toString() { result = v.toString() }
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
predicate localFlowStep = localFlowStepCached/2;

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Operand -> Instruction flow
  simpleInstructionLocalFlowStep(nodeFrom.asOperand(), nodeTo.asInstruction())
  or
  // Instruction -> Operand flow
  simpleOperandLocalFlowStep(nodeFrom.asInstruction(), nodeTo.asOperand())
  or
  // Flow into, through, and out of store nodes
  StoreNodeFlow::flowInto(nodeFrom.asInstruction(), nodeTo)
  or
  StoreNodeFlow::flowThrough(nodeFrom, nodeTo)
  or
  StoreNodeFlow::flowOutOf(nodeFrom, nodeTo)
  or
  // Flow into, through, and out of read nodes
  ReadNodeFlow::flowInto(nodeFrom, nodeTo)
  or
  ReadNodeFlow::flowThrough(nodeFrom, nodeTo)
  or
  ReadNodeFlow::flowOutOf(nodeFrom, nodeTo)
  or
  // Adjacent-def-use and adjacent-use-use flow
  adjacentDefUseFlow(nodeFrom, nodeTo)
}

private predicate adjacentDefUseFlow(Node nodeFrom, Node nodeTo) {
  // Flow that isn't already covered by field flow out of store/read nodes.
  not nodeFrom.asInstruction() = any(StoreNode pun).getStoreInstruction() and
  not nodeFrom.asInstruction() = any(ReadNode pun).getALoadInstruction() and
  (
    //Def-use flow
    Ssa::ssaFlow(nodeFrom, nodeTo)
    or
    // Use-use flow through stores.
    exists(Instruction loadAddress, Node store |
      loadAddress = Ssa::getSourceAddressFromNode(nodeFrom) and
      Ssa::explicitWrite(_, store.asInstruction(), loadAddress) and
      Ssa::ssaFlow(store, nodeTo)
    )
  )
}

/**
 * INTERNAL: Do not use.
 */
module ReadNodeFlow {
  /** Holds if the read node `nodeTo` should receive flow from `nodeFrom`. */
  predicate flowInto(Node nodeFrom, ReadNode nodeTo) {
    nodeTo.isInitial() and
    (
      // If we entered through an address operand.
      nodeFrom.asOperand().getDef() = nodeTo.getInstruction()
      or
      // If we entered flow through a memory-producing instruction.
      // This can happen if we have flow to an `InitializeParameterIndirection` through
      // a `ReadSideEffectInstruction`.
      exists(Instruction load, Instruction def |
        def = nodeFrom.asInstruction() and
        def = Ssa::getSourceValueOperand(load).getAnyDef() and
        not def = any(StoreNode store).getStoreInstruction() and
        pragma[only_bind_into](nodeTo).getALoadInstruction() = load
      )
    )
  }

  /**
   * Holds if the read node `nodeTo` should receive flow from the read node `nodeFrom`.
   *
   * This happens when `readFrom` is _not_ the source of a `readStep`, and `nodeTo` is
   * the `ReadNode` that represents an address that directly depends on `nodeFrom`.
   */
  predicate flowThrough(ReadNode nodeFrom, ReadNode nodeTo) {
    not readStep(nodeFrom, _, _) and
    nodeFrom.getOuter() = nodeTo
  }

  /**
   * Holds if flow should leave the read node `nFrom` and enter the node `nodeTo`.
   * This happens either because there is use-use flow from one of the variables used in
   * the read operation, or because we have traversed all the field dereferences in the
   * read operation.
   */
  predicate flowOutOf(ReadNode nFrom, Node nodeTo) {
    // Use-use flow to another use of the same variable instruction
    Ssa::ssaFlow(nFrom, nodeTo)
    or
    not exists(nFrom.getInner()) and
    exists(Node store |
      Ssa::explicitWrite(_, store.asInstruction(), nFrom.getInstruction()) and
      Ssa::ssaFlow(store, nodeTo)
    )
    or
    // Flow out of read nodes and into memory instructions if we cannot move any further through
    // read nodes.
    nFrom.isTerminal() and
    (
      exists(Instruction load |
        load = nodeTo.asInstruction() and
        Ssa::getSourceAddress(load) = nFrom.getInstruction()
      )
      or
      exists(CallInstruction call, int i |
        call.getArgument(i) = nodeTo.asInstruction() and
        call.getArgument(i) = nFrom.getInstruction()
      )
    )
  }
}

/**
 * INTERNAL: Do not use.
 */
module StoreNodeFlow {
  /** Holds if the store node `nodeTo` should receive flow from `nodeFrom`. */
  predicate flowInto(Instruction instrFrom, StoreNode nodeTo) {
    nodeTo.flowInto(Ssa::getDestinationAddress(instrFrom))
  }

  /**
   * Holds if the store node `nodeTo` should receive flow from `nodeFom`.
   *
   * This happens when `nodeFrom` is _not_ the source of a `storeStep`, and `nodeFrom` is
   * the `Storenode` that represents an address that directly depends on `nodeTo`.
   */
  predicate flowThrough(StoreNode nodeFrom, StoreNode nodeTo) {
    // Flow through a post update node that doesn't need a store step.
    not storeStep(nodeFrom, _, _) and
    nodeTo.getOuter() = nodeFrom
  }

  /**
   * Holds if flow should leave the store node `nodeFrom` and enter the node `nodeTo`.
   * This happens because we have traversed an entire chain of field dereferences
   * after a store operation.
   */
  predicate flowOutOf(StoreNodeInstr nFrom, Node nodeTo) {
    nFrom.isTerminal() and
    Ssa::ssaFlow(nFrom, nodeTo)
  }
}

private predicate simpleOperandLocalFlowStep(Instruction iFrom, Operand opTo) {
  // Propagate flow from an instruction to its exact uses.
  // We do this for all instruction/operand pairs, except when the operand is the
  // side effect operand of a ReturnIndirectionInstruction, or the load operand of a LoadInstruction.
  // This is because we get these flows through the shared SSA library already, and including this
  // flow here will create multiple dataflow paths which creates a blowup in stage 3 of dataflow.
  (
    not any(ReturnIndirectionInstruction ret).getSideEffectOperand() = opTo and
    not any(LoadInstruction load).getSourceValueOperand() = opTo and
    not any(ReturnValueInstruction ret).getReturnValueOperand() = opTo
  ) and
  opTo.getDef() = iFrom
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
  iTo.(CopyInstruction).getSourceValueOperand() = opFrom
  or
  iTo.(PhiInstruction).getAnInputOperand() = opFrom
  or
  // Treat all conversions as flow, even conversions between different numeric types.
  iTo.(ConvertInstruction).getUnaryOperand() = opFrom
  or
  iTo.(CheckedConvertOrNullInstruction).getUnaryOperand() = opFrom
  or
  iTo.(InheritanceConversionInstruction).getUnaryOperand() = opFrom
  or
  // Conflate references and values like in AST dataflow.
  iTo.(ReferenceDereferenceInstruction).getSourceAddressOperand() = opFrom
  or
  // Flow through modeled functions
  modelFlow(opFrom, iTo)
}

private predicate modelFlow(Operand opFrom, Instruction iTo) {
  exists(
    CallInstruction call, DataFlowFunction func, FunctionInput modelIn, FunctionOutput modelOut
  |
    call.getStaticCallTarget() = func and
    func.hasDataFlow(modelIn, modelOut)
  |
    (
      modelOut.isReturnValue() and
      iTo = call
      or
      // TODO: Add write side effects for return values
      modelOut.isReturnValueDeref() and
      iTo = call
      or
      exists(int index, WriteSideEffectInstruction outNode |
        modelOut.isParameterDerefOrQualifierObject(index) and
        iTo = outNode and
        outNode = getSideEffectFor(call, index)
      )
    ) and
    (
      exists(int index |
        modelIn.isParameterOrQualifierAddress(index) and
        opFrom = call.getArgumentOperand(index)
      )
      or
      exists(int index, ReadSideEffectInstruction read |
        modelIn.isParameterDerefOrQualifierObject(index) and
        read = getSideEffectFor(call, index) and
        opFrom = read.getSideEffectOperand()
      )
    )
  )
}

/**
 * Holds if the result is a side effect for instruction `call` on argument
 * index `argument`. This helper predicate makes it easy to join on both of
 * these columns at once, avoiding pathological join orders in case the
 * argument index should get joined first.
 */
pragma[noinline]
SideEffectInstruction getSideEffectFor(CallInstruction call, int argument) {
  call = result.getPrimaryInstruction() and
  argument = result.(IndexedInstruction).getIndex()
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

private newtype TContent =
  TFieldContent(Field f) {
    // As reads and writes to union fields can create flow even though the reads and writes
    // target different fields, we don't want a read (write) to create a read (write) step.
    not f.getDeclaringType() instanceof Union
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

/** A reference through an instance field. */
class FieldContent extends Content, TFieldContent {
  Field f;

  FieldContent() { this = TFieldContent(f) }

  override string toString() { result = f.toString() }

  Field getField() { result = f }
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

/**
 * A guard that validates some instruction.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends IRGuardCondition {
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
