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

cached
private newtype TIRDataFlowNode =
  TInstructionNode(Instruction i) or
  TOperandNode(Operand op) or
  TVariableNode(Variable var) or
  TAddressNode(Instruction i) {
    AddressFlow::addressFlowInstrTC(i,
      [
        any(StoreInstruction store).getDestinationAddress(),
        any(NonConstWriteSideEffectInstruction write).getDestinationAddress()
      ])
  } or
  TPostFieldContentNodeStore(FieldAddressInstruction fai) { exists(TAddressNode(fai)) } or
  TPostFieldContentNodeRead(FieldAddressInstruction fai) {
    not AddressFlow::addressFlowInstrTC(fai, any(StoreInstruction store).getDestinationAddress())
  } or
  TConstructorFieldInitNode(FieldAddressInstruction fai) {
    fai.getObjectAddress() instanceof InitializeParameterInstruction
  } or
  TPointerOutNode(NonConstWriteSideEffectInstruction write)

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
  cached
  final Declaration getEnclosingCallable() {
    result = unique(Declaration d | d = this.getEnclosingCallableImpl() | d)
  }

  final private Declaration getEnclosingCallableImpl() {
    result = this.asInstruction().getEnclosingFunction() or
    result = this.asOperand().getUse().getEnclosingFunction() or
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = this.asVariable() or
    result = this.(AddressNode).getInstruction().getEnclosingFunction() or
    result = this.(PostFieldContentNodeStore).getInstruction().getEnclosingFunction() or
    result = this.(PostFieldContentNodeRead).getInstruction().getEnclosingFunction() or
    result = this.(ConstructorFieldInitNode).getInstruction().getEnclosingFunction() or
    result = this.(PointerOutNode).getInstruction().getEnclosingFunction()
  }

  /** Gets the function to which this node belongs, if any. */
  Function getFunction() { none() } // overridden in subclasses

  /** Gets the type of this node. */
  Type getType() { none() } // overridden in subclasses

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
   * DEPRECATED: See UninitializedNode.
   *
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  deprecated LocalVariable asUninitialized() { none() }

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() { result = getType() }

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
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

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override Type getType() { result = instr.getResultType().stripType() }

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

  override Function getFunction() { result = op.getUse().getEnclosingFunction() }

  override Type getType() { result = op.getType().stripType() }

  override Location getLocation() { result = op.getLocation() }

  override string toString() { result = this.getOperand().toString() }
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
 * INTERNAL: do not use. Translates a parameter/argument index into a negative
 * number that denotes the index of its side effect (pointer indirection).
 */
bindingset[index]
int getArgumentPosOfSideEffect(int index) {
  // -1 -> -2
  //  0 -> -3
  //  1 -> -4
  // ...
  result = -3 - index
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
  predicate isParameterOf(Function f, int pos) { none() } // overridden by subclasses
}

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ExplicitParameterNode() { exists(instr.getParameter()) }

  override predicate isParameterOf(Function f, int pos) {
    f.getParameter(pos) = instr.getParameter()
  }

  /** Gets the `Parameter` associated with this node. */
  Parameter getParameter() { result = instr.getParameter() }

  override string toString() { result = instr.getParameter().toString() }
}

/** An implicit `this` parameter. */
class ThisParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ThisParameterNode() { instr.getIRVariable() instanceof IRThisVariable }

  override predicate isParameterOf(Function f, int pos) {
    pos = -1 and instr.getEnclosingFunction() = f
  }

  override string toString() { result = "this" }
}

/** A synthetic parameter to model the pointed-to object of a pointer parameter. */
class ParameterIndirectionNode extends ParameterNode {
  override InitializeIndirectionInstruction instr;

  override predicate isParameterOf(Function f, int pos) {
    exists(int index |
      instr.getEnclosingFunction() = f and
      instr.hasIndex(index)
    |
      pos = getArgumentPosOfSideEffect(index)
    )
  }

  override string toString() { result = "*" + instr.getIRVariable().toString() }
}

/**
 * DEPRECATED: Data flow was never an accurate way to determine what
 * expressions might be uninitialized. It errs on the side of saying that
 * everything is uninitialized, and this is even worse in the IR because the IR
 * doesn't use syntactic hints to rule out variables that are definitely
 * initialized.
 *
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
deprecated class UninitializedNode extends Node {
  UninitializedNode() { none() }

  LocalVariable getLocalVariable() { none() }
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
 *
 * This class exists to match the interface used by Java. There are currently no non-abstract
 * classes that extend it. When we implement field flow, we can revisit this.
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
 * x.y.z = 1; // a partial definition of the objects `x` and `x.y`.
 * x.setY(1); // a partial definition of the object `x`.
 * setY(&x); // a partial definition of the object `x`.
 * ```
 */
abstract private class PartialDefinitionNode extends Node {
  abstract Expr getDefinedExpr();
}

private class PartialFieldDefinition extends AddressNode, PartialDefinitionNode {
  FieldAddressInstruction fai;

  PartialFieldDefinition() {
    fai = this.getInstruction() and
    AddressFlow::addressFlowInstrTC(fai,
      [
        any(StoreInstruction store).getDestinationAddress(),
        any(NonConstWriteSideEffectInstruction write).getDestinationAddress()
      ])
  }

  override Expr getDefinedExpr() {
    result = fai.getObjectAddress().getUnconvertedResultExpression()
  }
}

private class PartialArrayDefinition extends AddressNode, PartialDefinitionNode {
  LoadInstruction load;

  PartialArrayDefinition() {
    load = this.getInstruction() and
    AddressFlow::addressFlowInstrTC(load,
      [
        any(StoreInstruction store).getDestinationAddress(),
        any(NonConstWriteSideEffectInstruction write).getDestinationAddress()
      ])
  }

  override Expr getDefinedExpr() {
    result = load.getResultAddress().getUnconvertedResultExpression()
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

  override Type getType() { result = v.getType().stripType() }

  override Location getLocation() { result = v.getLocation() }

  override string toString() { result = v.toString() }
}

/**
 * INTERNAL: do not use.
 *
 * An instruction that is used for address computations. Unlike `InstructionNode`s, `AddressNode`s flows
 * "upwards" through the program (i.e., from a `LoadInstruction` to its address operand.)
 */
class AddressNode extends Node, TAddressNode, PostUpdateNode {
  Instruction instr;

  AddressNode() { this = TAddressNode(instr) }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override Type getType() { result = instr.getResultType().stripType() }

  override Location getLocation() { result = instr.getLocation() }

  override string toString() { result = "address" }

  override Node getPreUpdateNode() { result.asInstruction() = instr }
}

/**
 * INTERNAL: do not use.
 *
 * A synthesized node that is used to push an additional `ArrayContent` onto the
 * access path after pushing a `FieldContent`.
 */
class PostFieldContentNodeStore extends Node, TPostFieldContentNodeStore {
  FieldAddressInstruction fai;

  PostFieldContentNodeStore() { this = TPostFieldContentNodeStore(fai) }

  /** Gets the instruction corresponding to this node. */
  FieldAddressInstruction getInstruction() { result = fai }

  override Function getFunction() { result = fai.getEnclosingFunction() }

  override Type getType() { result = fai.getResultType().stripType() }

  override Location getLocation() { result = fai.getLocation() }

  override string toString() { result = "post field (store)" }
}

/**
 * INTERNAL: do not use.
 *
 * A synthesized node that is used to pop the `FieldContent` after the
 * `ArrayContent` has been popped off the access path.
 */
class PostFieldContentNodeRead extends Node, TPostFieldContentNodeRead {
  FieldAddressInstruction fai;

  PostFieldContentNodeRead() { this = TPostFieldContentNodeRead(fai) }

  /** Gets the instruction corresponding to this node. */
  FieldAddressInstruction getInstruction() { result = fai }

  override Function getFunction() { result = fai.getEnclosingFunction() }

  override Type getType() { result = fai.getResultType().stripType() }

  override Location getLocation() { result = fai.getLocation() }

  override string toString() { result = "post field (read)" }
}

/**
 * INTERNAL: do not use.
 *
 * If a store step happens as part of a member initialization list in a constructor, the IR takes a
 * shortcut and skips a `LoadInstruction`. So to get the right access path we take a detour to a
 * `ConstructorFieldInitNode` that will push an additional `ArrayContent`.
 */
class ConstructorFieldInitNode extends Node, TConstructorFieldInitNode {
  FieldAddressInstruction fai;

  ConstructorFieldInitNode() { this = TConstructorFieldInitNode(fai) }

  /** Gets the instruction corresponding to this node. */
  FieldAddressInstruction getInstruction() { result = fai }

  override Function getFunction() { result = fai.getEnclosingFunction() }

  override Type getType() { result = fai.getResultType().stripType() }

  override Location getLocation() { result = fai.getLocation() }

  override string toString() { result = "constructor init field" }
}

/**
 * A `NonConstWriteSideEffectInstruction` is a `WriteSideEffectInstruction` that writes to a non-const
 * pointer. Currently, the IR generates a `WriteSideEffectInstruction` for a parameter of type
 * `const T*`. It is very unlikely that the value pointed to by a pointer of type `const T*` will be
 * written to, and we thus only treat `WriteSideEffectInstruction`s that write to non-const pointers as
 * being an assignemnt to the pointed value.
 */
class NonConstWriteSideEffectInstruction extends WriteSideEffectInstruction {
  NonConstWriteSideEffectInstruction() {
    exists(Function f | f = this.getPrimaryInstruction().(CallInstruction).getStaticCallTarget() |
      if this.getIndex() = -1
      then exists(Type t | t = f.(MemberFunction).getTypeOfThis() | not t.isDeeplyConstBelow())
      else
        exists(Type t | t = f.getParameter(this.getIndex()).getType() | not t.isDeeplyConstBelow())
    )
  }
}

/**
 * A node that wraps a `WriteSideEffectInstruction`.
 */
class PointerOutNode extends Node, TPointerOutNode {
  NonConstWriteSideEffectInstruction write;

  PointerOutNode() { this = TPointerOutNode(write) }

  /** Gets the instruction corresponding to this node. */
  NonConstWriteSideEffectInstruction getInstruction() { result = write }

  override Function getFunction() { result = write.getEnclosingFunction() }

  override Type getType() { result = write.getResultType().stripType() }

  override Location getLocation() { result = write.getLocation() }

  override string toString() { result = "pointer out" }
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
 * DEPRECATED: use `definitionByReferenceNodeFromArgument` instead.
 *
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as `argument` of a call.
 */
deprecated DefinitionByReferenceNode definitionByReferenceNode(Expr e) { result.getArgument() = e }

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
predicate localFlowStep(Node nodeFrom, Node nodeTo) { simpleLocalFlowStep(nodeFrom, nodeTo) }

private predicate valueFlow(Node nodeFrom, Node nodeTo) {
  // Operand -> Instruction flow
  simpleInstructionLocalFlowStep(nodeFrom.asOperand(), nodeTo.asInstruction())
  or
  // Instruction -> Operand flow
  simpleOperandLocalFlowStep(nodeFrom.asInstruction(), nodeTo.asOperand())
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
cached
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  valueFlow(nodeFrom, nodeTo)
  or
  addressFlow(nodeFrom, nodeTo)
  or
  flowOutOfAddressNode(nodeFrom, nodeTo)
  or
  flowOutOfPointerOutNode(nodeFrom, nodeTo)
}

private predicate flowOutOfPointerOutNode(PointerOutNode nodeFrom, AddressNode nodeTo) {
  nodeTo.(AddressNode).getInstruction() = nodeFrom.getInstruction().getDestinationAddress()
}

private predicate addressFlow(AddressNode nodeFrom, AddressNode nodeTo) {
  addressFlowInstrStep(nodeTo.getInstruction(), nodeFrom.getInstruction()) and
  not storeStep(nodeFrom, _, _)
}

/**
 * Holds if the address computed by `iFrom` is used to compute the
 * address computed by `iTo`.
 */
private predicate addressFlowInstrStep(Instruction iFrom, Instruction iTo) {
  iTo.(FieldAddressInstruction).getObjectAddress() = iFrom
  or
  iTo.(CopyValueInstruction).getSourceValue() = iFrom
  or
  iTo.(LoadInstruction).getSourceAddress() = iFrom
  or
  iTo.(ConvertInstruction).getUnary() = iFrom
  or
  iTo.(PointerOffsetInstruction).getLeft() = iFrom
  or
  iTo.(CheckedConvertOrNullInstruction).getUnary() = iFrom
  or
  iTo.(InheritanceConversionInstruction).getUnary() = iFrom
}

cached
module AddressFlow {
  private predicate isRelevant(Instruction instr) {
    instr instanceof VariableInstruction
    or
    instr instanceof FieldAddressInstruction
    or
    instr instanceof CopyValueInstruction
    or
    instr instanceof LoadInstruction
    or
    instr instanceof ConvertInstruction
    or
    instr instanceof PointerOffsetInstruction
    or
    instr instanceof CheckedConvertOrNullInstruction
    or
    instr instanceof InheritanceConversionInstruction
  }

  /**
   * Holds if the address computed by `iFrom` is used to compute the
   * address computed by `iTo`.
   */
  cached
  predicate addressFlowInstrTC(Instruction iFrom, Instruction iTo) {
    iFrom = iTo and isRelevant(iFrom)
    or
    exists(Instruction i |
      addressFlowInstrStep(iFrom, i) and
      addressFlowInstrTC(i, iTo)
    )
  }
}

private predicate flowOutOfAddressNode(AddressNode nodeFrom, Node nodeTo) {
  flowOutOfAddressNodeStore(nodeFrom, nodeTo)
}

/**
 * A module that encapsulates information about definitions and uses.
 */
module DefUse {
  private predicate variableStore(IRBlock bb, int i, IRVariable v, Instruction instr, boolean redef) {
    exists(StoreInstruction store, VariableInstruction var | instr = store |
      AddressFlow::addressFlowInstrTC(var, store.getDestinationAddress()) and
      var.getIRVariable() = v and
      store.getBlock() = bb and
      bb.getInstruction(i) = store and
      if
        AddressFlow::addressFlowInstrTC(any(FieldAddressInstruction fai),
          store.getDestinationAddress())
      then redef = false
      else redef = true
    )
    or
    exists(NonConstWriteSideEffectInstruction write, VariableInstruction var | instr = write |
      AddressFlow::addressFlowInstrTC(var, write.getDestinationAddress()) and
      var.getIRVariable() = v and
      write.getBlock() = bb and
      bb.getInstruction(i) = write and
      redef = false
    )
  }

  private predicate variableRead(IRBlock bb, int i, IRVariable v, Node n) {
    exists(VariableInstruction instr |
      n.asInstruction() = instr and
      instr.getIRVariable() = v and
      instr.getBlock() = bb and
      bb.getInstruction(i) = instr
    )
  }

  private predicate ssaRef(IRBlock bb, int i, IRVariable v, boolean isWrite, boolean redef) {
    variableRead(bb, i, v, _) and isWrite = false and redef = false
    or
    variableStore(bb, i, v, _, redef) and isWrite = true
  }

  private newtype OrderedSsaRefIndex =
    MkOrderedSsaRefIndex(int i, boolean isWrite, boolean redef) { ssaRef(_, i, _, isWrite, redef) }

  private int ssaRefRank(IRBlock bb, int i, IRVariable v, boolean isWrite, boolean redef) {
    ssaRefOrd(bb, i, v, isWrite, redef) =
      rank[result](int j, OrderedSsaRefIndex res | res = ssaRefOrd(bb, j, v, _, _) | res order by j)
  }

  private OrderedSsaRefIndex ssaRefOrd(
    IRBlock bb, int i, IRVariable v, boolean isWrite, boolean redef
  ) {
    ssaRef(bb, i, v, isWrite, redef) and
    result = MkOrderedSsaRefIndex(i, isWrite, redef)
  }

  private int ssaDefRank(IRVariable v, IRBlock bb, int i, boolean redef) {
    result = ssaRefRank(bb, i, v, true, redef)
  }

  private predicate ssaDefReachesRank(IRBlock bb, int i, int rnk, IRVariable v) {
    rnk = ssaDefRank(v, bb, i, _)
    or
    ssaDefReachesRank(bb, i, rnk - 1, v) and
    rnk = ssaRefRank(bb, _, v, _, false)
  }

  private int maxSsaRefRank(IRBlock bb, IRVariable v) {
    result = ssaDefRank(v, bb, _, _) and
    not result + 1 = ssaDefRank(v, bb, _, _)
  }

  private int firstReadOrWrite(IRBlock bb, IRVariable v) {
    result = min(ssaRefRank(bb, _, v, _, _))
  }

  private predicate liveAtEntry(IRBlock bb, IRVariable v) {
    ssaRefRank(bb, _, v, false, _) = firstReadOrWrite(bb, v)
    or
    not exists(firstReadOrWrite(bb, v)) and
    liveAtExit(bb, v)
  }

  private predicate liveAtExit(IRBlock bb, IRVariable v) { liveAtEntry(bb.getASuccessor(), v) }

  private predicate ssaDefReachesEndOfBlock(IRBlock bb, IRBlock bb1, int i1, IRVariable v) {
    bb = bb1 and
    exists(int last |
      last = maxSsaRefRank(bb1, v) and
      ssaDefReachesRank(bb1, i1, last, v) and
      liveAtExit(bb1, v)
    )
    or
    ssaDefReachesEndOfBlockRec(bb, bb1, i1, v) and
    liveAtExit(bb, v) and
    not ssaRef(bb, _, v, true, true)
  }

  pragma[noinline]
  private predicate ssaDefReachesEndOfBlockRec(IRBlock bb, IRBlock bb1, int i1, IRVariable v) {
    exists(IRBlock idom |
      ssaDefReachesEndOfBlock(idom, bb1, i1, v) and idom.immediatelyDominates(bb)
    )
  }

  private predicate defOccursInBlock(IRBlock bb, int i, IRVariable v) {
    exists(ssaDefRank(v, bb, i, _))
  }

  pragma[noinline]
  private IRBlock getAMaybeLiveSuccessor(IRVariable v, IRBlock bb, IRBlock bb1, int i1) {
    result = bb.getASuccessor() and
    not defOccursInBlock(bb, _, v) and
    ssaDefReachesEndOfBlock(bb, bb1, i1, v)
  }

  private predicate varBlockReaches(IRVariable v, IRBlock bb1, int i1, IRBlock bb2) {
    defOccursInBlock(bb1, i1, v) and
    bb2 = bb1.getASuccessor()
    or
    exists(IRBlock mid | varBlockReaches(v, bb1, i1, mid) |
      bb2 = getAMaybeLiveSuccessor(v, mid, bb1, i1)
    )
  }

  private predicate defAdjacentRead(IRVariable v, IRBlock bb1, int i1, IRBlock bb2, int i2) {
    varBlockReaches(v, bb1, i1, bb2) and
    ssaRefRank(bb2, i2, v, false, _) = 1 // NOTE: Use `ssaDefReachesRank` here instead?
  }

  cached
  predicate adjacentDefRead(Instruction instr1, Node n2) {
    exists(IRBlock bb1, int i1, IRBlock bb2, int i2 |
      bb2 = bb1 and
      exists(int useRank, IRVariable v |
        useRank = ssaRefRank(bb2, i2, v, false, _) and
        variableRead(bb2, i2, v, n2) and
        ssaDefReachesRank(bb1, i1, useRank, v) and
        variableStore(bb1, i1, v, instr1, _)
      )
      or
      exists(IRVariable v |
        ssaDefRank(v, bb1, i1, _) = maxSsaRefRank(bb1, v) and
        variableStore(bb1, i1, v, instr1, _) and
        defAdjacentRead(v, bb1, i1, bb2, i2) and
        variableRead(bb2, i2, v, n2)
      )
    )
  }
}

/**
 * Holds if `nodeTo` is the next use of the address contained in `nodeFrom`. This is the predicate that
 * transfers flow out from a sequence of store steps to an `InstructionNode` or `OperandNode`.
 *
 * NOTE: Modify this to handle lambda captures (which don't have flow to a `VariableInstruction`, but
 * reuses a previous `VariableInstruction` in a `LoadInstruction` when performing the lambda capture).
 */
private predicate flowOutOfAddressNodeStore(AddressNode nodeFrom, Node nodeTo) {
  exists(Instruction instr, VariableInstruction var | var = nodeFrom.getInstruction() |
    AddressFlow::addressFlowInstrTC(var,
      [
        instr.(StoreInstruction).getDestinationAddress(),
        instr.(NonConstWriteSideEffectInstruction).getDestinationAddress()
      ]) and
    DefUse::adjacentDefRead(instr, nodeTo)
  )
  or
  exists(
    CallInstruction call, ConvertInstruction convert, int index,
    NonConstWriteSideEffectInstruction write, IRBlock block, int useIndex
  |
    nodeFrom.getInstruction() = call and
    convert.getUnary() = call and
    AddressFlow::addressFlowInstrTC(convert, write.getDestinationAddress()) and
    nodeTo.asOperand().getDef() = convert and
    // NOTE: This only handles the case where `nodeTo` and `write` are in the same block for now
    block.getInstruction(useIndex) = nodeTo.asOperand().getUse() and
    block.getInstruction(index) = write and
    useIndex > index
  )
}

pragma[noinline]
private predicate getFieldSizeOfClass(Class c, Type type, int size) {
  exists(Field f |
    f.getDeclaringType() = c and
    f.getUnderlyingType() = type and
    type.getSize() = size
  )
}

private predicate isSingleFieldClass(Type type, Operand op) {
  exists(int size, Class c |
    c = op.getType().getUnderlyingType() and
    c.getSize() = size and
    getFieldSizeOfClass(c, type, size)
  )
}

private predicate simpleOperandLocalFlowStep(Instruction iFrom, Operand opTo) {
  // Propagate flow from an instruction to its exact uses.
  opTo.getDef() = iFrom
  or
  opTo = any(ReadSideEffectInstruction read).getSideEffectOperand() and
  not iFrom.isResultConflated() and
  iFrom = opTo.getAnyDef()
  or
  // Loading a single `int` from an `int *` parameter is not an exact load since
  // the parameter may point to an entire array rather than a single `int`. The
  // following rule ensures that any flow going into the
  // `InitializeIndirectionInstruction`, even if it's for a different array
  // element, will propagate to a load of the first element.
  //
  // Since we're linking `InitializeIndirectionInstruction` and
  // `LoadInstruction` together directly, this rule will break if there's any
  // reassignment of the parameter indirection, including a conditional one that
  // leads to a phi node.
  exists(InitializeIndirectionInstruction init |
    iFrom = init and
    opTo.(LoadOperand).getAnyDef() = init and
    // Check that the types match. Otherwise we can get flow from an object to
    // its fields, which leads to field conflation when there's flow from other
    // fields to the object elsewhere.
    init.getParameter().getType().getUnspecifiedType().(DerivedType).getBaseType() =
      opTo.getType().getUnspecifiedType()
  )
  or
  // Flow from stores to structs with a single field to a load of that field.
  exists(LoadInstruction load |
    load.getSourceValueOperand() = opTo and
    opTo.getAnyDef() = iFrom and
    isSingleFieldClass(iFrom.getResultType(), opTo)
  )
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
  // A chi instruction represents a point where a new value (the _partial_
  // operand) may overwrite an old value (the _total_ operand), but the alias
  // analysis couldn't determine that it surely will overwrite every bit of it or
  // that it surely will overwrite no bit of it.
  //
  // By allowing flow through the total operand, we ensure that flow is not lost
  // due to shortcomings of the alias analysis. We may get false flow in cases
  // where the data is indeed overwritten.
  //
  // Flow through the partial operand belongs in the taint-tracking libraries
  // for now.
  iTo.getAnOperand().(ChiTotalOperand) = opFrom
  or
  // Add flow from write side-effects to non-conflated chi instructions through their
  // partial operands. From there, a `readStep` will find subsequent reads of that field.
  // Consider the following example:
  // ```
  // void setX(Point* p, int new_x) {
  //   p->x = new_x;
  // }
  // ...
  // setX(&p, taint());
  // ```
  // Here, a `WriteSideEffectInstruction` will provide a new definition for `p->x` after the call to
  // `setX`, which will be melded into `p` through a chi instruction.
  exists(ChiInstruction chi | chi = iTo |
    opFrom.getAnyDef() instanceof WriteSideEffectInstruction and
    chi.getPartialOperand() = opFrom and
    not chi.isResultConflated()
  )
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
        modelIn.isParameterDeref(index) and
        read = getSideEffectFor(call, index) and
        opFrom = read.getSideEffectOperand()
      )
      or
      exists(ReadSideEffectInstruction read |
        modelIn.isQualifierObject() and
        read = getSideEffectFor(call, -1) and
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
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `i1` to `i2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localInstructionFlow(Instruction e1, Instruction e2) {
  localFlow(instructionNode(e1), instructionNode(e2))
}

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

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
