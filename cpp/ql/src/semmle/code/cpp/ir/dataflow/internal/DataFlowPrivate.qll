private import cpp
private import DataFlowUtil
private import semmle.code.cpp.ir.IR
private import DataFlowDispatch
private import semmle.code.cpp.models.interfaces.DataFlow

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
class ReturnNode extends InstructionNode {
  Instruction primary;

  ReturnNode() {
    exists(ReturnValueInstruction ret | instr = ret.getReturnValue() and primary = ret)
    or
    exists(ReturnIndirectionInstruction rii |
      instr = rii.getSideEffectOperand().getAnyDef() and primary = rii
    )
  }

  /** Gets the kind of this returned value. */
  abstract ReturnKind getKind();
}

class ReturnValueNode extends ReturnNode {
  override ReturnValueInstruction primary;

  override ReturnKind getKind() { result = TNormalReturnKind() }
}

class ReturnIndirectionNode extends ReturnNode {
  override ReturnIndirectionInstruction primary;

  override ReturnKind getKind() {
    exists(int index |
      primary.hasIndex(index) and
      result = TIndirectReturnKind(index)
    )
  }
}

/** A data flow node that represents the output of a call. */
class OutNode extends InstructionNode {
  OutNode() {
    instr instanceof CallInstruction or
    instr instanceof WriteSideEffectInstruction
  }

  /** Gets the underlying call. */
  abstract DataFlowCall getCall();

  abstract ReturnKind getReturnKind();
}

private class CallOutNode extends OutNode {
  override CallInstruction instr;

  override DataFlowCall getCall() { result = instr }

  override ReturnKind getReturnKind() { result instanceof NormalReturnKind }
}

private class SideEffectOutNode extends OutNode {
  override WriteSideEffectInstruction instr;

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
  TFieldContent(Class c, int startBit, int endBit) { exists(getAField(c, startBit, endBit)) } or
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
  Class c;
  int startBit;
  int endBit;

  FieldContent() { this = TFieldContent(c, startBit, endBit) }

  // Ensure that there's just 1 result for `toString`.
  override string toString() { result = min(Field f | f = getAField() | f.toString()) }

  predicate hasOffset(Class cl, int start, int end) { cl = c and start = startBit and end = endBit }

  Field getAField() { result = getAField(c, startBit, endBit) }

  pragma[noinline]
  Field getADirectField() {
    c = result.getDeclaringType() and
    this.getAField() = result and
    this.hasOffset(c, _, _)
  }
}

private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }
}

private class ArrayContent extends Content, TArrayContent {
  ArrayContent() { this = TArrayContent() }

  override string toString() { result = "array content" }
}

/**
 * A store step from the value of a `StoreInstruction` to the "innermost" field of the destination.
 * This predicate only holds when there is no `ChiInsturction` that merges the result of the
 * `StoreInstruction` into a larger memory.
 */
private predicate instrToFieldNodeStoreStepNoChi(
  Node node1, FieldContent f, PartialDefinitionNode node2
) {
  exists(StoreInstruction store, PartialFieldDefinition pd |
    pd = node2.getPartialDefinition() and
    not exists(ChiInstruction chi | chi.getPartial() = store) and
    pd.getPreUpdateNode() = getFieldNodeForFieldInstruction(store.getDestinationAddress()) and
    store.getSourceValueOperand() = node1.asOperand() and
    f.getADirectField() = pd.getPreUpdateNode().getField()
  )
}

/**
 * A store step from a `StoreInstruction` to the "innermost" field
 * of the destination. This predicate only holds when there exists a `ChiInstruction` that merges the
 * result of the `StoreInstruction` into a larger memory.
 */
private predicate instrToFieldNodeStoreStepChi(
  Node node1, FieldContent f, PartialDefinitionNode node2
) {
  exists(
    ChiPartialOperand operand, StoreInstruction store, ChiInstruction chi, PartialFieldDefinition pd
  |
    pd = node2.getPartialDefinition() and
    not chi.isResultConflated() and
    node1.asOperand() = operand and
    chi.getPartialOperand() = operand and
    store = operand.getDef() and
    pd.getPreUpdateNode() = getFieldNodeForFieldInstruction(store.getDestinationAddress()) and
    f.getADirectField() = pd.getPreUpdateNode().getField()
  )
}

private predicate callableWithoutDefinitionStoreStep(
  Node node1, FieldContent f, PartialDefinitionNode node2
) {
  exists(
    WriteSideEffectInstruction write, ChiInstruction chi, PartialFieldDefinition pd,
    Function callable, CallInstruction call
  |
    chi.getPartial() = write and
    not chi.isResultConflated() and
    pd = node2.getPartialDefinition() and
    pd.getPreUpdateNode() = getFieldNodeForFieldInstruction(write.getDestinationAddress()) and
    f.getADirectField() = pd.getPreUpdateNode().getField() and
    call = write.getPrimaryInstruction() and
    callable = call.getStaticCallTarget() and
    not callable.hasDefinition()
  |
    exists(OutParameterDeref out | out.getIndex() = write.getIndex() |
      callable.(DataFlowFunction).hasDataFlow(_, out) and
      node1.asInstruction() = write
    )
    or
    // Ideally we shouldn't need to do a store step from a read side effect, but if we don't have a
    // model for the callee there might not be flow to the write side effect (since the callee has no
    // definition). This case ensures that we propagate dataflow when a field is passed into a
    // function that has a write side effect, even though the write side effect doesn't have incoming
    // flow.
    not callable instanceof DataFlowFunction and
    exists(ReadSideEffectInstruction read | call = read.getPrimaryInstruction() |
      node1.asInstruction() = read.getSideEffectOperand().getAnyDef()
    )
  )
}

/**
 * A store step from a `StoreInstruction` to the `ChiInstruction` generated from assigning
 * to a pointer or array indirection
 */
private predicate arrayStoreStepChi(Node node1, ArrayContent a, PartialDefinitionNode node2) {
  a = TArrayContent() and
  exists(
    ChiPartialOperand operand, ChiInstruction chi, StoreInstruction store, PartialDefinition pd
  |
    pd = node2.getPartialDefinition() and
    chi.getPartialOperand() = operand and
    store = operand.getDef() and
    node1.asOperand() = operand and
    // This `ChiInstruction` will always have a non-conflated result because both `ArrayStoreNode`
    // and `PointerStoreNode` require it in their characteristic predicates.
    pd.getPreUpdateNode().asOperand() = chi.getTotalOperand()
  |
    // `x[i] = taint()`
    // This matches the characteristic predicate in `ArrayStoreNode`.
    store.getDestinationAddress() instanceof PointerAddInstruction
    or
    // `*p = taint()`
    // This matches the characteristic predicate in `PointerStoreNode`.
    store.getDestinationAddress().(CopyValueInstruction).getUnary() instanceof LoadInstruction
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  instrToFieldNodeStoreStepNoChi(node1, f, node2) or
  instrToFieldNodeStoreStepChi(node1, f, node2) or
  arrayStoreStepChi(node1, f, node2) or
  callableWithoutDefinitionStoreStep(node1, f, node2)
}

private class ArrayToPointerConvertInstruction extends ConvertInstruction {
  ArrayToPointerConvertInstruction() {
    this.getUnary().getResultType() instanceof ArrayType and
    this.getResultType() instanceof PointerType
  }
}

/**
 * These two predicates look like copy-paste from the two predicates with the same name in DataFlowUtil,
 * but crucially they only skip past `CopyValueInstruction`s. This is because we use a special case of
 * a `ConvertInstruction` to detect some read steps from arrays that undergoes array-to-pointer
 * conversion.
 */
private Instruction skipOneCopyValueInstructionRec(CopyValueInstruction copy) {
  copy.getUnary() = result and not result instanceof CopyValueInstruction
  or
  result = skipOneCopyValueInstructionRec(copy.getUnary())
}

private Instruction skipCopyValueInstructions(Operand op) {
  not result instanceof CopyValueInstruction and result = op.getDef()
  or
  result = skipOneCopyValueInstructionRec(op.getDef())
}

private class InexactLoadOperand extends LoadOperand {
  InexactLoadOperand() { this.isDefinitionInexact() }
}

/** Get the result type of `i`, if it is a `PointerType`. */
private PointerType getPointerType(Instruction i) {
  // We are done if the type is a pointer type that is not a glvalue
  i.getResultLanguageType().hasType(result, false)
  or
  // Some instructions produce a glvalue. Recurse past those to get the actual `PointerType`.
  result = getPointerType(i.(PointerOffsetInstruction).getLeft())
}

pragma[noinline]
private predicate deconstructLoad(
  LoadInstruction load, InexactLoadOperand loadOperand, Instruction addressInstr
) {
  load.getSourceAddress() = addressInstr and
  load.getSourceValueOperand() = loadOperand
}

private predicate arrayReadStep(Node node1, ArrayContent a, Node node2) {
  a = TArrayContent() and
  // Explicit dereferences such as `*p` or `p[i]` where `p` is a pointer or array.
  exists(InexactLoadOperand loadOperand, LoadInstruction load, Instruction address |
    deconstructLoad(load, loadOperand, address) and
    node1.asInstruction() = loadOperand.getAnyDef() and
    not node1.asInstruction().isResultConflated() and
    loadOperand = node2.asOperand() and
    // Ensure that the load is actually loading from an array or a pointer.
    getPointerType(address).getBaseType() = load.getResultType()
  )
}

/** Step from the value loaded by a `LoadInstruction` to the "outermost" loaded field. */
private predicate instrToFieldNodeReadStep(FieldNode node1, FieldContent f, Node node2) {
  (
    node1.getNextNode() = node2
    or
    not exists(node1.getNextNode()) and
    (
      exists(LoadInstruction load |
        node2.asInstruction() = load and
        node1 = getFieldNodeForFieldInstruction(load.getSourceAddress())
      )
      or
      exists(ReadSideEffectInstruction read |
        node2.asOperand() = read.getSideEffectOperand() and
        node1 = getFieldNodeForFieldInstruction(read.getArgumentDef())
      )
    )
  ) and
  f.getADirectField() = node1.getField()
}

bindingset[result, i]
private int unbindInt(int i) { i <= result and i >= result }

pragma[noinline]
private FieldNode getFieldNodeFromLoadOperand(LoadOperand loadOperand) {
  result = getFieldNodeForFieldInstruction(loadOperand.getAddressOperand().getDef())
}

/**
 * Sometimes there's no explicit field dereference. In such cases we use the IR alias analysis to
 * determine the offset being, and deduce the field from this information.
 */
private predicate aliasedReadStep(Node node1, FieldContent f, Node node2) {
  exists(LoadOperand operand, Class c, int startBit, int endBit |
    // Ensure that we don't already catch this store step using a `FieldNode`.
    not instrToFieldNodeReadStep(getFieldNodeFromLoadOperand(operand), f, _) and
    node1.asInstruction() = operand.getAnyDef() and
    node2.asOperand() = operand and
    not node1.asInstruction().isResultConflated() and
    c = operand.getAnyDef().getResultType() and
    f.hasOffset(c, startBit, endBit) and
    operand.getUsedInterval(unbindInt(startBit), unbindInt(endBit))
  )
}

/** Get the result type of an `Instruction` i, if it is a `ReferenceType`. */
private ReferenceType getReferenceType(Instruction i) {
  i.getResultLanguageType().hasType(result, false)
}

pragma[noinline]
Type getResultTypeOfSourceValue(CopyValueInstruction copy) {
  result = copy.getSourceValue().getResultType()
}

/**
 * In cases such as:
 * ```cpp
 * void f(int* pa) {
 *   *pa = source();
 * }
 * ...
 * int x;
 * f(&x);
 * use(x);
 * ```
 * the store to `*pa` in `f` will push `ArrayContent` onto the access path. The `innerRead` predicate
 * pops the `ArrayContent` off the access path when a value-to-pointer or value-to-reference conversion
 * happens on the argument that is ends up as the target of such a store.
 */
private predicate innerReadSteap(Node node1, Content a, Node node2) {
  a = TArrayContent() and
  exists(WriteSideEffectInstruction write, CallInstruction call, CopyValueInstruction copyValue |
    write.getPrimaryInstruction() = call and
    node1.asInstruction() = write and
    (
      not exists(ChiInstruction chi | chi.getPartial() = write)
      or
      exists(ChiInstruction chi | chi.getPartial() = write and not chi.isResultConflated())
    ) and
    node2.asInstruction() = write and
    copyValue = call.getArgument(write.getIndex()) and
    [getPointerType(copyValue).getBaseType(), getReferenceType(copyValue).getBaseType()] =
      getResultTypeOfSourceValue(copyValue)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  aliasedReadStep(node1, f, node2) or
  arrayReadStep(node1, f, node2) or
  instrToFieldNodeReadStep(node1, f, node2) or
  innerReadSteap(node1, f, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, Content c) {
  none() // stub implementation
}

/** Gets the type of `n` used for type pruning. */
IRType getNodeType(Node n) {
  suppressUnusedNode(n) and
  result instanceof IRVoidType // stub implementation
}

/** Gets a string representation of a type returned by `getNodeType`. */
string ppReprType(IRType t) { none() } // stub implementation

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(IRType t1, IRType t2) {
  any() // stub implementation
}

private predicate suppressUnusedNode(Node n) { any() }

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends InstructionNode {
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

class DataFlowType = IRType;

/** A function call relevant for data flow. */
class DataFlowCall extends CallInstruction {
  Function getEnclosingCallable() { result = this.getEnclosingFunction() }
}

predicate isUnreachableInCall(Node n, DataFlowCall call) { none() } // stub implementation

int accessPathLimit() { result = 5 }

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
predicate nodeIsHidden(Node n) { n instanceof OperandNode }
