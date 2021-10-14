/**
 * Class that deals with variable initializations.
 * Separated from `TranslatedExpr` for clarity.
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.internal.CSharpType
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction
private import experimental.ir.Util
private import IRInternal
private import desugar.Delegate

/**
 * Gets the `TranslatedInitialization` for the expression `expr`.
 */
TranslatedInitialization getTranslatedInitialization(Expr expr) { result.getExpr() = expr }

/**
 * Base class for any `TranslatedElement` that has an initialization as a child.
 * Provides the child with the address and type of the location to be
 * initialized.
 */
abstract class InitializationContext extends TranslatedElement {
  /**
   * Gets the instruction that produces the address of the location to be
   * initialized.
   */
  abstract Instruction getTargetAddress();

  /**
   * Gets the type of the location to be initialized.
   */
  abstract Type getTargetType();
}

/**
 * Represents the IR translation of any initialization, whether from an
 * initializer list or from a direct initializer.
 */
abstract class TranslatedInitialization extends TranslatedElement, TTranslatedInitialization {
  Expr expr;

  TranslatedInitialization() { this = TTranslatedInitialization(expr) }

  final override string toString() { result = "init: " + expr.toString() }

  final override Callable getFunction() { result = expr.getEnclosingCallable() }

  final override Language::AST getAST() { result = expr }

  /**
   * Gets the expression that is doing the initialization.
   */
  final Expr getExpr() { result = expr }

  /**
   * Gets the initialization context that describes the location being
   * initialized.
   */
  final InitializationContext getContext() { result = this.getParent() }

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(expr.getEnclosingCallable())
  }
}

/**
 * Represents the IR translation of an initialization from an initializer list.
 */
abstract class TranslatedListInitialization extends TranslatedInitialization, InitializationContext {
  override Instruction getFirstInstruction() {
    result = this.getChild(0).getFirstInstruction()
    or
    not exists(this.getChild(0)) and result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getChild(index) and
      if exists(this.getChild(index + 1))
      then result = this.getChild(index + 1).getFirstInstruction()
      else result = this.getParent().getChildSuccessor(this)
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getTargetAddress() { result = this.getContext().getTargetAddress() }

  override Type getTargetType() { result = this.getContext().getTargetType() }
}

/**
 * Represents the IR translation of an initialization of an array from an
 * initializer list.
 */
class TranslatedArrayListInitialization extends TranslatedListInitialization {
  override ArrayInitializer expr;

  override TranslatedElement getChild(int id) {
    // The children are in initialization order
    result =
      rank[id + 1](TranslatedElementInitialization init |
        init.getInitList() = expr
      |
        init order by init.getElementIndex()
      )
  }
}

/**
 * Represents the IR translation of an initialization from a single initializer
 * expression, where the initialization is performed via bitwise copy.
 */
class TranslatedDirectInitialization extends TranslatedInitialization {
  TranslatedDirectInitialization() {
    not expr instanceof ArrayInitializer and
    not expr instanceof ObjectInitializer and
    not expr instanceof CollectionInitializer
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitializer() }

  override Instruction getFirstInstruction() {
    result = this.getInitializer().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(this.getContext().getTargetType())
    or
    needsConversion() and
    tag = AssignmentConvertRightTag() and
    // For now only use `Opcode::Convert` to
    // crudely represent conversions. Could
    // be useful to represent the whole chain of conversions
    opcode instanceof Opcode::Convert and
    resultType = getTypeForPRValue(this.getContext().getTargetType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = InitializerStoreTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
    or
    needsConversion() and
    tag = AssignmentConvertRightTag() and
    result = getInstruction(InitializerStoreTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getInitializer() and
    if this.needsConversion()
    then result = this.getInstruction(AssignmentConvertRightTag())
    else result = this.getInstruction(InitializerStoreTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getParent().(InitializationContext).getTargetAddress()
      or
      (
        operandTag instanceof AddressOperandTag and
        result = this.getContext().getTargetAddress()
        or
        operandTag instanceof StoreValueOperandTag and
        result = this.getInitializer().getResult()
      )
    )
    or
    tag = AssignmentConvertRightTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInitializer().getResult()
    or
    tag = AssignmentConvertRightTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInstruction(NewObjTag())
  }

  TranslatedExpr getInitializer() { result = getTranslatedExpr(expr) }

  private predicate needsConversion() { expr.getType() != this.getContext().getTargetType() }
}

/**
 * Represents the IR translation of the initialization of an array element from
 * an element of an initializer list.
 */
abstract class TranslatedElementInitialization extends TranslatedElement {
  ArrayInitializer initList;

  final override string toString() {
    result = initList.toString() + "[" + getElementIndex().toString() + "]"
  }

  final override Language::AST getAST() { result = initList }

  final override Callable getFunction() { result = initList.getEnclosingCallable() }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(getElementIndexTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = getElementIndexTag() and
    opcode instanceof Opcode::Constant and
    resultType = getIntType()
    or
    tag = getElementAddressTag() and
    opcode instanceof Opcode::PointerAdd and
    resultType = getTypeForGLValue(getElementType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = getElementIndexTag() and
    result = this.getInstruction(getElementAddressTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = getElementAddressTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getParent().(InitializationContext).getTargetAddress()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(getElementIndexTag())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = getElementAddressTag() and
    result = Language::getTypeSize(getElementType())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = getElementIndexTag() and
    result = getElementIndex().toString()
  }

  abstract int getElementIndex();

  final InstructionTag getElementAddressTag() {
    result = InitializerElementAddressTag(getElementIndex())
  }

  final InstructionTag getElementIndexTag() {
    result = InitializerElementIndexTag(getElementIndex())
  }

  final ArrayInitializer getInitList() { result = initList }

  final Type getElementType() { result = initList.getAnElement().getType() }
}

/**
 * Represents the IR translation of the initialization of an array element from
 * an explicit element in an initializer list.
 */
class TranslatedExplicitElementInitialization extends TranslatedElementInitialization,
  TTranslatedExplicitElementInitialization, InitializationContext {
  int elementIndex;

  TranslatedExplicitElementInitialization() {
    this = TTranslatedExplicitElementInitialization(initList, elementIndex)
  }

  override Instruction getTargetAddress() { result = this.getInstruction(getElementAddressTag()) }

  override Type getTargetType() { result = getElementType() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessor(tag, kind)
    or
    tag = getElementAddressTag() and
    result = this.getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getInitialization() and result = this.getParent().getChildSuccessor(this)
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override int getElementIndex() { result = elementIndex }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(initList.getElement(elementIndex))
  }
}

// TODO: Possibly refactor into something simpler
abstract class TranslatedConstructorCallFromConstructor extends TranslatedElement,
  ConstructorCallContext {
  Call call;

  final override Language::AST getAST() { result = call }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getConstructorCall()
  }

  final override Callable getFunction() { result = call.getEnclosingCallable() }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getConstructorCall() and
    result = this.getParent().getChildSuccessor(this)
  }

  final TranslatedExpr getConstructorCall() { result = getTranslatedExpr(call) }
}

TranslatedConstructorInitializer getTranslatedConstructorInitializer(ConstructorInitializer ci) {
  result.getAST() = ci
}

/**
 * Represents the IR translation of a call from a constructor to a base class
 * constructor or another constructor in same class .
 */
// Review: do we need the conversion instructions in C#?
class TranslatedConstructorInitializer extends TranslatedConstructorCallFromConstructor,
  TTranslatedConstructorInitializer {
  TranslatedConstructorInitializer() { this = TTranslatedConstructorInitializer(call) }

  override string toString() { result = "constructor init: " + call.toString() }

  override Instruction getFirstInstruction() {
    if needsConversion()
    then result = this.getInstruction(OnlyInstructionTag())
    else result = this.getConstructorCall().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    this.needsConversion() and
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::Convert and
    resultType = getTypeForGLValue(call.getTarget().getDeclaringType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = this.getConstructorCall().getFirstInstruction()
  }

  override Instruction getReceiver() {
    if this.needsConversion()
    then result = this.getInstruction(OnlyInstructionTag())
    else result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }

  predicate needsConversion() {
    call.getTarget().getDeclaringType() != this.getFunction().getDeclaringType()
  }

  override predicate getInstructionInheritance(
    InstructionTag tag, Class baseClass, Class derivedClass
  ) {
    tag = OnlyInstructionTag() and
    baseClass = call.getTarget().getDeclaringType() and
    derivedClass = this.getFunction().getDeclaringType()
  }
}
