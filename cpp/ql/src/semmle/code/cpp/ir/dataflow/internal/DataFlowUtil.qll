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
  TAddressNodeStore(Instruction i) { inStoreChain(i, _) } or
  TAddressNodeRead(Instruction i) {
    exists(Instruction read | usedForRead(read) |
      addressFlowInstrRTC(i, read)
      or
      addressFlowInstrRTC(read, i)
    ) and
    // We can't filter out addresses that flow to `WriteSideEffects` since the instruction that
    // represents the address of a `WriteSideEffect` is also used for the `ReadSideEffect`.
    // But at least we can filter out the instructions that are only used for stores.
    not inStoreChain(i, any(StoreInstruction store))
  }

predicate inStoreChain(Instruction i, Instruction store) {
  exists(Instruction storeStepSource | usedForStore(storeStepSource) |
    addressFlowInstrWithLoads(i, storeStepSource) and
    addressFlowInstrWithLoads(storeStepSource, getDestinationAddress(store))
    or
    addressFlowInstrWithLoads(storeStepSource, i) and
    addressFlowInstrWithLoads(i, getDestinationAddress(store))
  )
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
  cached
  final Declaration getEnclosingCallable() { result = this.getEnclosingCallableImpl() }

  final private Declaration getEnclosingCallableImpl() {
    result = this.asInstruction().getEnclosingFunction() or
    result = this.asOperand().getUse().getEnclosingFunction() or
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = this.asVariable() or
    result = this.(AddressNodeStore).getInstruction().getEnclosingFunction() or
    result = this.(AddressNodeRead).getInstruction().getEnclosingFunction()
  }

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
   * DEPRECATED: See UninitializedNode.
   *
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  deprecated LocalVariable asUninitialized() { none() }

  /**
   * Gets an upper bound on the type of this node.
   */
  IRType getTypeBound() { result = getType() }

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

  override Function getFunction() { result = op.getUse().getEnclosingFunction() }

  override IRType getType() { result = op.getIRType() }

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

private class PartialFieldDefinition extends AddressNodeStore, PartialDefinitionNode {
  FieldAddressInstruction fai;

  PartialFieldDefinition() { fai = this.getInstruction() }

  override Expr getDefinedExpr() {
    result = fai.getObjectAddress().getUnconvertedResultExpression()
  }
}

private class PartialArrayDefinition extends AddressNodeStore, PartialDefinitionNode {
  LoadInstruction load;

  PartialArrayDefinition() { load = this.getInstruction() }

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

  override IRType getType() { result.getCanonicalLanguageType().hasUnspecifiedType(v.getType(), _) }

  override Location getLocation() { result = v.getLocation() }

  override string toString() { result = v.toString() }
}

/**
 * INTERNAL: do not use.
 *
 * An instruction that is used for address computations. Unlike `InstructionNode`s, `AddressNodeStore`s
 * flows "upwards" through the program (i.e., from a `LoadInstruction` to its address operand.)
 */
class AddressNodeStore extends Node, TAddressNodeStore {
  Instruction instr;

  AddressNodeStore() { this = TAddressNodeStore(instr) }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override IRType getType() { result = instr.getResultIRType() }

  override Location getLocation() { result = instr.getLocation() }

  override string toString() { result = "store address" }
}

class AddressNodeRead extends Node, TAddressNodeRead {
  Instruction instr;

  AddressNodeRead() { this = TAddressNodeRead(instr) }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override IRType getType() { result = instr.getResultIRType() }

  override Location getLocation() { result = instr.getLocation() }

  override string toString() { result = "read address" }
}

private class AddressNodeTargetedByStoreStep extends AddressNodeStore, PostUpdateNode {
  AddressNodeTargetedByStoreStep() { storeStep(_, _, this) }

  override Node getPreUpdateNode() { result.asInstruction() = instr }
}

/**
 * Holds if the address computed by `iFrom` is used to compute the
 * address computed by `iTo`.
 *
 * NOTE: Unlike `addressFlowInstrRTC` this predicate traverses `LoadInstruction`s.
 */
private predicate addressFlowInstrWithLoads(Instruction start, Instruction end) {
  addressFlowInstrRTC(start, end)
  or
  exists(LoadInstruction load, Instruction mid |
    start = load.getSourceAddress() and
    addressFlowInstrRTC(load, mid) and
    addressFlowInstrWithLoads(mid, end)
  )
}

/**
 * Gets the instruction that computes the destination address of a `StoreInstruction` or a
 * `WriteSideEffectInstruction`.
 */
Instruction getDestinationAddress(Instruction i) {
  result =
    [
      i.(StoreInstruction).getDestinationAddress(),
      i.(WriteSideEffectInstruction).getDestinationAddress()
    ]
}

/**
 * Gets the instruction that computes the source address of a `LoadInstruction` or a
 * `ReadSideEffectInstruction`.
 */
Instruction getSourceAddress(Instruction i) {
  result = [i.(LoadInstruction).getSourceAddress(), i.(ReadSideEffectInstruction).getArgumentDef()]
}

/**
 * Gets the instruction that computes the source value of a `LoadInstruction` or a
 * `ReadSideEffectInstruction`.
 *
 * This predicate holds even if the source operand only inexactly totally with the defining instruction.
 */
Instruction getSourceValue(Instruction i) {
  result =
    [
      i.(LoadInstruction).getSourceValueOperand().getAnyDef(),
      i.(ReadSideEffectInstruction).getSideEffectOperand().getAnyDef()
    ]
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

pragma[inline]
private predicate isInitialAddress(Instruction i) { not AddressFlow::addressFlowInstrStep(_, i) }

/**
 * Holds if `nodeFrom` is an instruction that contains a value which is partially read by a
 * `LoadInstruction` or a `ReadSideEffectInstruction`. Since the value is partially read it will need
 * the dataflow library's field flow mechanism to track the address that was used.
 */
private predicate preReadStep(Node nodeFrom, AddressNodeRead nodeTo) {
  // We begin a sequence of read steps by transferring flow from the memory operand of a
  // `LoadInstruction` or a `ReadSideEffectInstruction`.
  exists(Instruction instr |
    isInitialAddress(nodeTo.getInstruction()) and
    addressFlowInstrRTC(nodeTo.getInstruction(), getSourceAddress(instr)) and
    getSourceValue(instr) = nodeFrom.asInstruction()
  )
  or
  // Or we begin another sequence of read steps after exiting another `AddressNodeRead` because we hit
  // a `LoadInstruction`.
  exists(LoadInstruction load |
    nodeFrom.asInstruction() = load and
    nodeTo.getInstruction() = load
  )
}

/**
 * Holds if `nodeFrom` is an instruction or operand that contains a value which will be stored into an
 * addresses that should be handled by the dataflow library's field flow mechanism, and `nodeTo` is the
 * address node that initiates a sequence of `storeSteps`.
 */
private predicate preStoreStep(Node nodeFrom, AddressNodeStore nodeTo) {
  // Only stores that actually has a `ChiInstruction` are interesting for field flow, as otherwise future
  // loads will most likely be exactly overlapping with the result of the `StoreInstruction`, and thus
  // not need field flow support.
  exists(StoreInstruction store, ChiInstruction chi |
    chi.getPartial() = store and
    nodeFrom.asOperand() = store.getSourceValueOperand() and
    nodeTo.getInstruction() = store.getDestinationAddress()
  )
  or
  exists(WriteSideEffectInstruction write |
    nodeFrom.asInstruction() = write and
    nodeTo.getInstruction() = write.getDestinationAddress()
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
  // Flow between instructions and operands
  valueFlow(nodeFrom, nodeTo)
  or
  // Flow that targets address nodes
  preStoreStep(nodeFrom, nodeTo)
  or
  preReadStep(nodeFrom, nodeTo)
  or
  // Flow that targets instructions and operands
  postStoreStep(nodeFrom, nodeTo)
  or
  postReadStep(nodeFrom, nodeTo)
  or
  // Flow through address nodes
  addressFlowStore(nodeFrom, nodeTo)
  or
  addressFlowRead(nodeFrom, nodeTo)
}

private predicate addressFlowStore(AddressNodeStore nodeFrom, AddressNodeStore nodeTo) {
  (
    AddressFlow::addressFlowInstrStep(nodeTo.getInstruction(), nodeFrom.getInstruction()) or
    nodeFrom.getInstruction().(LoadInstruction).getSourceAddress() = nodeTo.getInstruction()
  ) and
  not storeStep(nodeFrom, _, _)
}

private predicate addressFlowRead(AddressNodeRead nodeFrom, AddressNodeRead nodeTo) {
  AddressFlow::addressFlowInstrStep(nodeFrom.getInstruction(), nodeTo.getInstruction()) and
  not readStep(nodeFrom, _, _)
}

cached
module AddressFlow {
  /**
   * Holds if the address computed by `iFrom` is used to compute the
   * address computed by `iTo`.
   */
  cached
  predicate addressFlowInstrStep(Instruction iFrom, Instruction iTo) {
    iTo.(FieldAddressInstruction).getObjectAddress() = iFrom
    or
    iTo.(CopyValueInstruction).getSourceValue() = iFrom
    or
    iTo.(ConvertInstruction).getUnary() = iFrom
    or
    iTo.(PointerArithmeticInstruction).getLeft() = iFrom
    or
    iTo.(CheckedConvertOrNullInstruction).getUnary() = iFrom
    or
    iTo.(InheritanceConversionInstruction).getUnary() = iFrom
  }

  /**
   * Holds if there is a transitive sequence of `addressFlowInstrStep` steps from `iFrom` to `iTo`.
   *
   * This is written explicitly with a `fastTC` for performance reasons.
   */
  cached
  predicate addressFlowInstrTC(Instruction iFrom, Instruction iTo) =
    fastTC(addressFlowInstrStep/2)(iFrom, iTo)
}

/**
 * Holds if the address computed by `iFrom` is used to compute the
 * address computed by `iTo`.
 */
pragma[inline]
predicate addressFlowInstrRTC(Instruction iFrom, Instruction iTo) {
  iFrom = iTo
  or
  AddressFlow::addressFlowInstrTC(iFrom, iTo)
}

/**
 * Holds if `iFrom` is the initial address of an address computation and the value computed
 * by `iFrom` flows to `iTo`.
 */
private predicate initialAddressFlowInstrRTC(Instruction iFrom, Instruction iTo) {
  isInitialAddress(iFrom) and
  addressFlowInstrRTC(iFrom, iTo)
}

/**
 * A module that hides implementation details for the control-flow analysis needed
 * for `isSuccessorInstruction`.
 */
private module IRBlockFlow {
  /**
   * Holds if:
   * - `source` and `sink` are either a `LoadInstruction` or a `ReadSideEffectInstruction`.
   * - `source` is the beginning of an address computation that is used as part of a `storeStep` or
   *    `readStep`, and `sink` is the beginning of an address computation that is used as part of a
   *    `readStep`.
   * - `source` and `sink` read from the same instruction (i.e., the definition of their memory operand
   * is identical).
   */
  private predicate sourceSinkPairCand(Instruction source, Instruction sink, Instruction value) {
    source != sink and
    initialAddressFlowInstrRTC([
        any(AddressNodeStore address).getInstruction(),
        any(AddressNodeRead address).getInstruction()
      ], getSourceAddress(source)) and
    getSourceValue(source) = value and
    getSourceValue(sink) = value and
    initialAddressFlowInstrRTC(any(AddressNodeRead address).getInstruction(), getSourceAddress(sink))
  }

  private predicate isSourceInstr(Instruction value, Instruction source) {
    sourceSinkPairCand(source, _, value)
  }

  private predicate isSource(Instruction value, IRBlock source) {
    isSourceInstr(value, source.getAnInstruction())
  }

  private predicate isSink(Instruction value, IRBlock sink) {
    sourceSinkPairCand(value, _, sink.getAnInstruction())
  }

  private predicate getASuccessor(Instruction value, IRBlock b, IRBlock succ) {
    flowsFromSource(value, b) and
    not isSink(value, b) and
    b.getASuccessor() = succ
  }

  private IRBlock getAPredecessor(IRBlock b) { result.getASuccessor() = b }

  private predicate flowsFromSource(Instruction value, IRBlock b) {
    isSource(value, b) or
    flowsFromSource(value, getAPredecessor(b))
  }

  /** Holds if `isSink(sink)` and `b` flows to `sink` in one or more steps. */
  private predicate flows(Instruction value, IRBlock b, IRBlock sink) {
    flowsFromSource(value, b) and
    b.getASuccessor() = sink and
    isSink(value, sink)
    or
    exists(IRBlock succ | getASuccessor(value, b, succ) and flows(value, succ, sink))
  }

  private predicate flowsToSink(Instruction value, IRBlock b, IRBlock sink) {
    isSource(value, b) and
    flows(value, b, sink)
  }

  /**
   * Holds if `instr2` is a possible (transitive) successor of `instr1` in the control-flow graph.
   *
   * This predicate is `inline` because it's infeasible to compute it in isolation.
   */
  bindingset[value]
  pragma[inline]
  predicate isSuccessorInstruction(Instruction value, Instruction instr1, Instruction instr2) {
    exists(IRBlock block1, IRBlock block2 |
      block1 = instr1.getBlock() and
      block2 = instr2.getBlock() and
      if block1 = block2
      then
        exists(int index1, int index2 |
          block1.getInstruction(index1) = instr1 and
          block2.getInstruction(index2) = instr2 and
          not exists(int mid |
            index1 < mid and
            mid < index2 and
            isSourceInstr(block1.getInstruction(mid), value)
          ) and
          index1 < index2
        )
      else flowsToSink(value, block1, pragma[only_bind_out](block2))
    )
  }
}

/**
 * Holds if `nodeTo` should receive flow after leaving the `AddressNodeStore` node `nodeFrom`.
 * This occurs in two different situations:
 *   - `nodeTo` is the outermost `AddressNodeRead` node in an address computation that (at some point in
 *     the chain) reads from a memory operand which was used during the traversal of addresses that
 *     `nodeFrom` is part of. This happens in an example such as
 *     ```cpp
 *     a.b->c = source();
 *     B* b = a.b;
 *     sink(b->c);
 *     ```
 *     Here, the `LoadInstruction` on `a.b` reads from `&a.b` which was accessed during the store to the
 *     address of `a.b->c`. So in this case it holds that `postStoreStep(nodeFrom, nodeTo)` where
 *     `nodeFrom` is the `AddressNodeStore` node corresponding to `&a` on line 1, and `nodeTo` is the
 *     `AddressNodeRead` node corresponding to `&a` on line 2.
 *
 *   - The entire chain of addresses that `nodeFrom` is part of has been traversed and `nodeTo` is an
 *     `InstructionNode` node that represents the result of the store operation.
 *     This happens in an example such as `a.b.c = source();` where `nodeFrom` is `AddressNodeStore` node
 *     corresponding to `&a`, and `nodeTo` is the `ChiInstruction` that follows the `StoreInstruction`.
 */
private predicate postStoreStep(AddressNodeStore nodeFrom, Node nodeTo) {
  partialDefFlow(nodeFrom.getInstruction(), nodeTo)
  or
  // Flow out of an address node (to a chi instruction) after traversing the entire address chain.
  exists(Instruction instr, ChiInstruction chi |
    // We cannot take any further steps using store steps or steps through address nodes.
    isInitialAddress(nodeFrom.getInstruction()) and
    not storeStep(nodeFrom, _, _) and
    addressFlowInstrRTC(nodeFrom.getInstruction(), getDestinationAddress(instr))
  |
    chi = nodeTo.asInstruction() and
    not chi.isResultConflated() and
    chi.getPartial() = instr
  )
}

private predicate partialDefFlow(Instruction iFrom, Node nodeTo) {
  exists(Instruction load1, Instruction load2, Instruction value |
    // `nodeFrom` is the start of one chain of addresses
    initialAddressFlowInstrRTC(iFrom, getSourceAddress(load1)) and
    // and `nodeTo` is the start of another chain of addresses
    initialAddressFlowInstrRTC(nodeTo.(AddressNodeRead).getInstruction(), getSourceAddress(load2)) and
    // ... that end up reading from the same memory operand
    getSourceValue(load1) = value and
    getSourceValue(load2) = value and
    // ... and `load2` is a (transitive) successor in the control-flow graph.
    IRBlockFlow::isSuccessorInstruction(value, load1, load2)
  )
}

/**
 * Holds if `nodeTo` should receive flow after traversing a chain of addresses used to perform a sequence
 * of `readStep`s. `nodeTo` is either the `LoadInstruction` (or the side effect operand of a
 * `ReadSideEffectInstruction`) whose address chain has been traversed.
 */
private predicate postReadStep(AddressNodeRead nodeFrom, Node nodeTo) {
  partialDefFlow(nodeFrom.getInstruction(), nodeTo)
  or
  not readStep(nodeFrom, _, _) and
  (
    exists(LoadInstruction load | nodeTo.asInstruction() = load |
      load.getSourceAddress() = nodeFrom.getInstruction()
    )
    or
    exists(ReadSideEffectInstruction read | nodeTo.asOperand() = read.getSideEffectOperand() |
      read.getArgumentDef() = nodeFrom.getInstruction()
    )
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
  exists(LoadInstruction load, int end |
    load.getSourceValueOperand() = opTo and
    opTo.getAnyDef() = iFrom and
    load.getSourceValueOperand().getUsedInterval(0, end) and
    end = 8 * iFrom.getResultType().getSize()
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
    not chi.isResultConflated() and
    // In a call such as `set_value(&x->val);` we don't want the memory representing `x` to receive
    // dataflow by a simple step. Instead, this is handled by field flow. If we add a simple step here
    // we can get field-to-object flow.
    not chi.isPartialUpdate()
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
