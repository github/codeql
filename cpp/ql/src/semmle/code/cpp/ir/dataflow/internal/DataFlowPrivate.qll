private import cpp
private import DataFlowUtil
private import semmle.code.cpp.ir.IR
private import DataFlowDispatch

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Instance arguments (`this` pointer) and read side effects
 * on parameters are also included.
 */
abstract class ArgumentNode extends OperandNode {
  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  abstract predicate argumentOf(DataFlowCall call, int pos);

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

/**
 * A data flow node that occurs as the argument to a call, or an
 * implicit `this` pointer argument.
 */
private class PrimaryArgumentNode extends ArgumentNode {
  override ArgumentOperand op;

  PrimaryArgumentNode() { exists(CallInstruction call | op = call.getAnArgumentOperand()) }

  override predicate argumentOf(DataFlowCall call, int pos) { op = call.getArgumentOperand(pos) }

  override string toString() {
    result = "Argument " + op.(PositionalArgumentOperand).getIndex()
    or
    op instanceof ThisArgumentOperand and result = "This argument"
  }
}

/**
 * A data flow node representing the read side effect of a call on a
 * specific parameter.
 */
private class SideEffectArgumentNode extends ArgumentNode {
  override SideEffectOperand op;
  ReadSideEffectInstruction read;

  SideEffectArgumentNode() { op = read.getSideEffectOperand() }

  override predicate argumentOf(DataFlowCall call, int pos) {
    read.getPrimaryInstruction() = call and
    pos = getArgumentPosOfSideEffect(read.getIndex())
  }

  override string toString() { result = "Argument " + read.getIndex() + " indirection" }
}

private newtype TReturnKind =
  TNormalReturnKind() or
  TIndirectReturnKind(ParameterIndex index)

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For C++, this is simply a function return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  abstract string toString();
}

private class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

private class IndirectReturnKind extends ReturnKind, TIndirectReturnKind {
  ParameterIndex index;

  IndirectReturnKind() { this = TIndirectReturnKind(index) }

  override string toString() { result = "outparam[" + index.toString() + "]" }
}

/** A data flow node that occurs as the result of a `ReturnStmt`. */
class ReturnNode extends Node {
  Instruction primary;

  ReturnNode() {
    exists(ReturnValueInstruction ret |
      this.asInstruction() = ret.getReturnValue() and primary = ret
    )
    or
    exists(ReturnIndirectionInstruction ret | this.asInstruction() = ret and primary = ret)
  }

  /** Gets the kind of this returned value. */
  abstract ReturnKind getKind();
}

class ReturnValueNode extends ReturnNode, InstructionNode {
  override ReturnValueInstruction primary;

  override ReturnKind getKind() { result = TNormalReturnKind() }
}

class ReturnIndirectionNode extends ReturnNode, InstructionNode {
  override ReturnIndirectionInstruction primary;

  override ReturnKind getKind() {
    exists(int index |
      primary.hasIndex(index) and
      result = TIndirectReturnKind(index)
    )
  }
}

/** A data flow node that represents the output of a call. */
class OutNode extends Node {
  OutNode() {
    this.asInstruction() instanceof CallInstruction or
    this instanceof PointerOutNode
  }

  /** Gets the underlying call. */
  abstract DataFlowCall getCall();

  abstract ReturnKind getReturnKind();
}

private class CallOutNode extends OutNode, InstructionNode {
  override CallInstruction instr;

  override DataFlowCall getCall() { result = instr }

  override ReturnKind getReturnKind() { result instanceof NormalReturnKind }
}

private class SideEffectOutNode extends OutNode, PointerOutNode {
  WriteSideEffectInstruction instr;

  SideEffectOutNode() { instr = this.getInstruction() }

  override DataFlowCall getCall() { result = instr.getPrimaryInstruction() }

  override ReturnKind getReturnKind() { result = TIndirectReturnKind(instr.getIndex()) }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  // There should be only one `OutNode` for a given `(call, kind)` pair. Showing the optimizer that
  // this is true helps it make better decisions downstream, especially in virtual dispatch.
  result =
    unique(OutNode outNode |
      outNode.getCall() = call and
      outNode.getReturnKind() = kind
    )
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) { none() }

/**
 * Gets a field corresponding to the bit range `[startBit..endBit)` of class `c`, if any.
 */
private Field getAField(Class c, int startBit, int endBit) {
  result.getDeclaringType() = c and
  startBit = 8 * result.getByteOffset() and
  endBit = 8 * result.getType().getSize() + startBit
  or
  exists(Field f, Class cInner |
    f = c.getAField() and
    cInner = f.getUnderlyingType() and
    result = getAField(cInner, startBit - 8 * f.getByteOffset(), endBit - 8 * f.getByteOffset())
  )
}

private newtype TContent =
  TFieldContent(Field f) or
  TCollectionContent() or
  TArrayContent()

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, or the contents of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

private class FieldContent extends Content, TFieldContent {
  Field f;

  FieldContent() { this = TFieldContent(f) }

  // Ensure that there's just 1 result for `toString`.
  override string toString() { result = f.toString() }

  Field getAField() { result = f }
}

private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }
}

private class ArrayContent extends Content, TArrayContent {
  ArrayContent() { this = TArrayContent() }

  override string toString() { result = "array content" }
}

/**
 * A store step from an `AddressNode` to another `AddressNode` (but possibly via
 * a `PostFieldContentNode`).
 */
private predicate addressStoreStep(AddressNode node1, Content f, Node node2) {
  exists(FieldAddressInstruction fai |
    node1.getInstruction() = fai and
    node2.(PostFieldContentNodeStore).getInstruction() = fai and
    f.(FieldContent).getAField() = fai.getField()
  )
  or
  exists(LoadInstruction load |
    node1.getInstruction() = load and
    node2.(AddressNode).getInstruction() = load.getSourceAddress() and
    f instanceof ArrayContent
  )
}

/**
 * A store step from a non-`AddressNode` to an `AddressNode`. This starts the process of
 * pushing content onto the access path.
 */
private predicate storeStepToAddress(Node node1, Content f, AddressNode node2) {
  exists(StoreInstruction store |
    node1.asOperand() = store.getSourceValueOperand() and
    node2.getInstruction() = store.getDestinationAddress() and
    f instanceof ArrayContent
  )
  or
  exists(NonConstWriteSideEffectInstruction write |
    node1.asInstruction() = write and
    node2.getInstruction() = write.getDestinationAddress() and
    f instanceof ArrayContent
  )
}

/**
 * Push an `ArrayContent` onto the access path after a field has been pushed.
 * If the store step happens as part of a member initialization list in a constructor the IR takes a
 * shortcut and skips a `LoadInstruction`. So to get the right access path we take a detour to a
 * `ConstructorFieldInitNode` that will push an additional `ArrayContent`.
 */
private predicate postFieldContentStoreStep(PostFieldContentNodeStore node1, Content f, Node node2) {
  exists(FieldAddressInstruction fai |
    node1.getInstruction() = fai and
    f instanceof ArrayContent and
    (
      if fai.getObjectAddress() instanceof InitializeParameterInstruction
      then node2.(ConstructorFieldInitNode).getInstruction() = fai
      else node2.(AddressNode).getInstruction() = fai.getObjectAddress()
    )
  )
}

/** Push an additional `ArrayContent` after a member initialization in a constructor. */
predicate constructorFieldInitStoreStep(ConstructorFieldInitNode node1, Content f, Node node2) {
  exists(FieldAddressInstruction fai |
    f instanceof ArrayContent and
    node1.getInstruction() = fai and
    node2.(AddressNode).getInstruction() = fai.getObjectAddress()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, Node node2) {
  addressStoreStep(node1, f, node2)
  or
  storeStepToAddress(node1, f, node2)
  or
  postFieldContentStoreStep(node1, f, node2)
  or
  constructorFieldInitStoreStep(node1, f, node2)
}

/** Pop a `FieldContent` off the access path after the corresponding `ArrayContent` has been popped. */
private predicate postFieldContentNodeReadStep(PostFieldContentNodeRead node1, Content f, Node node2) {
  exists(FieldAddressInstruction fai |
    node1.getInstruction() = fai and
    node2.asInstruction() = fai and
    f.(FieldContent).getAField() = fai.getField()
  )
}

/**
 * Since we don't have dataflow through `PointerOffsetInstruction`s we can't rely on
 * `simpleLocalFlowStep` to transfer flow from the base address `a` to the `LoadInstruction` on `a[i]`.
 */
private Operand skipPointerOffsets(Operand operand) {
  exists(PointerOffsetInstruction offset |
    offset = operand.getDef() and
    result = skipPointerOffsets(offset.getLeftOperand())
  )
  or
  not operand.getDef() instanceof PointerOffsetInstruction and
  result = operand
}

/** Pop an `ArrayContent` off the access path as the first step of reading a field. */
private predicate fieldContentReadStep(Node node1, Content f, PostFieldContentNodeRead node2) {
  exists(FieldAddressInstruction fai |
    f instanceof ArrayContent and
    node1.asOperand() = skipPointerOffsets(fai.getObjectAddressOperand()) and
    node2.getInstruction() = fai
  )
}

/**
 * Pop an `ArrayContent` when we reach a `LoadInstruction` or `SideEffectInstruction`.
 * There is one special case to this: When there is no next use of the address contained in `node1` we
 * transfer control to the special `PointerReturnNode`.
 */
predicate arrayContentReadStep(Node node1, Content f, Node node2) {
  exists(LoadInstruction load |
    node1.asOperand() = skipPointerOffsets(load.getSourceAddressOperand()) and
    node2.asInstruction() = load and
    f instanceof ArrayContent
  )
  or
  exists(ReadSideEffectInstruction read |
    node1.asOperand() = skipPointerOffsets(read.getArgumentOperand()) and
    node2.asOperand() = read.getSideEffectOperand() and
    f instanceof ArrayContent
  )
  or
  exists(Instruction instr, VariableInstruction var | var = node1.(AddressNode).getInstruction() |
    (
      AddressFlow::addressFlowInstrTC(var, instr.(StoreInstruction).getDestinationAddress()) or
      AddressFlow::addressFlowInstrTC(var,
        instr.(NonConstWriteSideEffectInstruction).getDestinationAddress())
    ) and
    DefUse::adjacentDefRead(instr, node2.(ReturnIndirectionNode)) and
    f instanceof ArrayContent
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  fieldContentReadStep(node1, f, node2)
  or
  postFieldContentNodeReadStep(node1, f, node2)
  or
  arrayContentReadStep(node1, f, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, Content c) {
  none() // stub implementation
}

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) { result = n.getType() }

/** Gets a string representation of a type returned by `getNodeType`. */
string ppReprType(DataFlowType t) { result = t.toString() }

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

private predicate suppressUnusedNode(Node n) { any() }

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() } // stub implementation
}

/**
 * A function that may contain code or a variable that may contain itself. When
 * flow crosses from one _enclosing callable_ to another, the interprocedural
 * data-flow library discards call contexts and inserts a node in the big-step
 * relation used for human-readable path explanations.
 */
class DataFlowCallable = Declaration;

class DataFlowExpr = Expr;

class DataFlowType = Type;

/** A function call relevant for data flow. */
class DataFlowCall extends CallInstruction {
  Function getEnclosingCallable() { result = this.getEnclosingFunction() }
}

predicate isUnreachableInCall(Node n, DataFlowCall call) { none() } // stub implementation

int accessPathLimit() { result = 7 }

/** The unit type. */
private newtype TUnit = TMkUnit()

/** The trivial type with a single element. */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
}

/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) {
  // The rules for whether an IR argument gets a post-update node are too
  // complex to model here.
  any()
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof OperandNode or
  n instanceof PostFieldContentNodeStore or
  n instanceof PostFieldContentNodeRead or
  n instanceof ConstructorFieldInitNode
}
