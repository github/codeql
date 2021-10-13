private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction

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
 * Base class for any element that initializes a stack variable. Examples include local variable
 * declarations, `return` statements, and `throw` expressions.
 */
abstract class TranslatedVariableInitialization extends TranslatedElement, InitializationContext {
  final override TranslatedElement getChild(int id) { id = 0 and result = getInitialization() }

  final override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(getTargetType())
    or
    hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Uninitialized and
    resultType = getTypeForPRValue(getTargetType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    (
      tag = InitializerVariableAddressTag() and
      kind instanceof GotoEdge and
      if hasUninitializedInstruction()
      then result = getInstruction(InitializerStoreTag())
      else result = getInitialization().getFirstInstruction()
    )
    or
    hasUninitializedInstruction() and
    kind instanceof GotoEdge and
    tag = InitializerStoreTag() and
    (
      result = getInitialization().getFirstInstruction()
      or
      not exists(getInitialization()) and result = getInitializationSuccessor()
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getInitializationSuccessor()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = getInstruction(InitializerVariableAddressTag())
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag()
      or
      hasUninitializedInstruction() and tag = InitializerStoreTag()
    ) and
    result = getIRVariable()
  }

  final override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  /**
   * Get the initialization for the variable.
   */
  abstract TranslatedInitialization getInitialization();

  /**
   * Get the `IRVariable` to be initialized. This may be an `IRTempVariable`.
   */
  abstract IRVariable getIRVariable();

  /**
   * Gets the `Instruction` to be executed immediately after the initialization.
   */
  abstract Instruction getInitializationSuccessor();

  /**
   * Holds if this initialization requires an `Uninitialized` instruction to be emitted before
   * evaluating the initializer.
   */
  final predicate hasUninitializedInstruction() {
    (
      not exists(getInitialization()) or
      getInitialization() instanceof TranslatedListInitialization or
      getInitialization() instanceof TranslatedConstructorInitialization or
      getInitialization().(TranslatedStringLiteralInitialization).zeroInitRange(_, _)
    ) and
    // Variables with static or thread-local storage duration are zero-initialized at program startup.
    getIRVariable() instanceof IRAutomaticVariable
  }
}

/**
 * Represents the IR translation of any initialization, whether from an
 * initializer list or from a direct initializer.
 */
abstract class TranslatedInitialization extends TranslatedElement, TTranslatedInitialization {
  Expr expr;

  TranslatedInitialization() { this = TTranslatedInitialization(expr) }

  final override string toString() { result = "init: " + expr.toString() }

  final override Function getFunction() { result = expr.getEnclosingFunction() }

  final override Locatable getAST() { result = expr }

  /**
   * Gets the expression that is doing the initialization.
   */
  final Expr getExpr() { result = expr }

  /**
   * Gets the initialization context that describes the location being
   * initialized.
   */
  final InitializationContext getContext() { result = getParent() }

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(expr.getEnclosingFunction())
  }
}

/**
 * Represents the IR translation of an initialization from an initializer list.
 */
abstract class TranslatedListInitialization extends TranslatedInitialization, InitializationContext {
  override Instruction getFirstInstruction() {
    result = getChild(0).getFirstInstruction()
    or
    not exists(getChild(0)) and result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getChild(index) and
      if exists(getChild(index + 1))
      then result = getChild(index + 1).getFirstInstruction()
      else result = getParent().getChildSuccessor(this)
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getTargetAddress() { result = getContext().getTargetAddress() }

  override Type getTargetType() { result = getContext().getTargetType() }
}

/**
 * Represents the IR translation of an initialization of a class object from an
 * initializer list.
 */
class TranslatedClassListInitialization extends TranslatedListInitialization {
  override ClassAggregateLiteral expr;

  override TranslatedElement getChild(int id) {
    exists(TranslatedFieldInitialization fieldInit |
      result = fieldInit and
      fieldInit = getTranslatedFieldInitialization(expr, _) and
      fieldInit.getOrder() = id
    )
  }
}

/**
 * Represents the IR translation of an initialization of an array from an
 * initializer list.
 */
class TranslatedArrayListInitialization extends TranslatedListInitialization {
  override ArrayOrVectorAggregateLiteral expr;

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
 * expression.
 */
abstract class TranslatedDirectInitialization extends TranslatedInitialization {
  TranslatedDirectInitialization() { not expr instanceof AggregateLiteral }

  override TranslatedElement getChild(int id) { id = 0 and result = getInitializer() }

  override Instruction getFirstInstruction() { result = getInitializer().getFirstInstruction() }

  final TranslatedExpr getInitializer() { result = getTranslatedExpr(expr) }
}

/**
 * Represents the IR translation of an initialization from a single initializer
 * expression, where the initialization is performed via bitwise copy (as
 * opposed to a constructor).
 */
class TranslatedSimpleDirectInitialization extends TranslatedDirectInitialization {
  TranslatedSimpleDirectInitialization() {
    not expr instanceof ConstructorCall and
    not expr instanceof StringLiteral
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(getContext().getTargetType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = InitializerStoreTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitializer() and result = getInstruction(InitializerStoreTag())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getContext().getTargetAddress()
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInitializer().getResult()
    )
  }
}

/**
 * Represents the IR translation of an initialization of an array from a string
 * literal.
 */
class TranslatedStringLiteralInitialization extends TranslatedDirectInitialization {
  override StringLiteral expr;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    // Load the string literal to make it a prvalue of type `char[len]`
    tag = InitializerLoadStringTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(expr.getType())
    or
    // Store the string into the target.
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType())
    or
    exists(int startIndex, int elementCount |
      // If the initializer string isn't large enough to fill the target, then
      // we have to generate another instruction sequence to store a constant
      // zero into the remainder of the array.
      zeroInitRange(startIndex, elementCount) and
      (
        // Create a constant zero whose size is the size of the remaining
        // space in the target array.
        tag = ZeroPadStringConstantTag() and
        opcode instanceof Opcode::Constant and
        resultType = getUnknownOpaqueType(elementCount * getElementType().getSize())
        or
        // The index of the first element to be zero initialized.
        tag = ZeroPadStringElementIndexTag() and
        opcode instanceof Opcode::Constant and
        resultType = getIntType()
        or
        // Compute the address of the first element to be zero initialized.
        tag = ZeroPadStringElementAddressTag() and
        opcode instanceof Opcode::PointerAdd and
        resultType = getTypeForGLValue(getElementType())
        or
        // Store the constant zero into the remainder of the string.
        tag = ZeroPadStringStoreTag() and
        opcode instanceof Opcode::Store and
        resultType = getUnknownOpaqueType(elementCount * getElementType().getSize())
      )
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = InitializerLoadStringTag() and
      result = getInstruction(InitializerStoreTag())
      or
      if zeroInitRange(_, _)
      then (
        tag = InitializerStoreTag() and
        result = getInstruction(ZeroPadStringConstantTag())
        or
        tag = ZeroPadStringConstantTag() and
        result = getInstruction(ZeroPadStringElementIndexTag())
        or
        tag = ZeroPadStringElementIndexTag() and
        result = getInstruction(ZeroPadStringElementAddressTag())
        or
        tag = ZeroPadStringElementAddressTag() and
        result = getInstruction(ZeroPadStringStoreTag())
        or
        tag = ZeroPadStringStoreTag() and
        result = getParent().getChildSuccessor(this)
      ) else (
        tag = InitializerStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitializer() and result = getInstruction(InitializerLoadStringTag())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerLoadStringTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInitializer().getResult()
    )
    or
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getContext().getTargetAddress()
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInstruction(InitializerLoadStringTag())
    )
    or
    tag = ZeroPadStringElementAddressTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = getContext().getTargetAddress()
      or
      operandTag instanceof RightOperandTag and
      result = getInstruction(ZeroPadStringElementIndexTag())
    )
    or
    tag = ZeroPadStringStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(ZeroPadStringElementAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInstruction(ZeroPadStringConstantTag())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = ZeroPadStringElementAddressTag() and
    result = max(getElementType().getSize())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    exists(int startIndex |
      zeroInitRange(startIndex, _) and
      (
        tag = ZeroPadStringConstantTag() and
        result = "0"
        or
        tag = ZeroPadStringElementIndexTag() and
        result = startIndex.toString()
      )
    )
  }

  override predicate needsUnknownOpaqueType(int byteSize) {
    exists(int elementCount |
      zeroInitRange(_, elementCount) and
      byteSize = elementCount * getElementType().getSize()
    )
  }

  private Type getElementType() {
    result = getContext().getTargetType().getUnspecifiedType().(ArrayType).getBaseType()
  }

  /**
   * Holds if the `elementCount` array elements starting at `startIndex` must be
   * zero initialized.
   */
  predicate zeroInitRange(int startIndex, int elementCount) {
    exists(int targetCount |
      startIndex = expr.getUnspecifiedType().(ArrayType).getArraySize() and
      targetCount = getContext().getTargetType().getUnspecifiedType().(ArrayType).getArraySize() and
      elementCount = targetCount - startIndex and
      elementCount > 0
    )
  }
}

class TranslatedConstructorInitialization extends TranslatedDirectInitialization,
  StructorCallContext {
  override ConstructorCall expr;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitializer() and result = getParent().getChildSuccessor(this)
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  override Instruction getReceiver() { result = getContext().getTargetAddress() }
}

/**
 * Gets the `TranslatedFieldInitialization` for field `field` within initializer
 * list `initList`.
 */
TranslatedFieldInitialization getTranslatedFieldInitialization(
  ClassAggregateLiteral initList, Field field
) {
  result.getAST() = initList and result.getField() = field
}

TranslatedFieldInitialization getTranslatedConstructorFieldInitialization(ConstructorFieldInit init) {
  result.getAST() = init
}

/**
 * Represents the IR translation of the initialization of a field from an
 * element of an initializer list.
 */
abstract class TranslatedFieldInitialization extends TranslatedElement {
  Expr ast;
  Field field;

  final override string toString() { result = ast.toString() + "." + field.toString() }

  final override Locatable getAST() { result = ast }

  final override Function getFunction() { result = ast.getEnclosingFunction() }

  final override Instruction getFirstInstruction() { result = getInstruction(getFieldAddressTag()) }

  /**
   * Gets the zero-based index describing the order in which this field is to be
   * initialized relative to the other fields in the class.
   */
  final int getOrder() { result = field.getInitializationOrder() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = getFieldAddressTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getTypeForGLValue(field.getType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = getFieldAddressTag() and
    operandTag instanceof UnaryOperandTag and
    result = getParent().(InitializationContext).getTargetAddress()
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = getFieldAddressTag() and result = field
  }

  final InstructionTag getFieldAddressTag() { result = InitializerFieldAddressTag() }

  final Field getField() { result = field }
}

/**
 * Represents the IR translation of the initialization of a field from an
 * explicit element in an initializer list.
 */
class TranslatedExplicitFieldInitialization extends TranslatedFieldInitialization,
  InitializationContext, TTranslatedExplicitFieldInitialization {
  Expr expr;

  TranslatedExplicitFieldInitialization() {
    this = TTranslatedExplicitFieldInitialization(ast, field, expr)
  }

  override Instruction getTargetAddress() { result = getInstruction(getFieldAddressTag()) }

  override Type getTargetType() { result = field.getUnspecifiedType() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = getFieldAddressTag() and
    result = getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override TranslatedElement getChild(int id) { id = 0 and result = getInitialization() }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr)
  }
}

private string getZeroValue(Type type) {
  if type instanceof FloatingPointType then result = "0.0" else result = "0"
}

/**
 * Represents the IR translation of the initialization of a field without a
 * corresponding element in the initializer list.
 */
class TranslatedFieldValueInitialization extends TranslatedFieldInitialization,
  TTranslatedFieldValueInitialization {
  TranslatedFieldValueInitialization() { this = TTranslatedFieldValueInitialization(ast, field) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    TranslatedFieldInitialization.super.hasInstruction(opcode, tag, resultType)
    or
    tag = getFieldDefaultValueTag() and
    opcode instanceof Opcode::Constant and
    resultType = getTypeForPRValue(field.getType())
    or
    tag = getFieldDefaultValueStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(field.getUnspecifiedType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = getFieldAddressTag() and
      result = getInstruction(getFieldDefaultValueTag())
      or
      tag = getFieldDefaultValueTag() and
      result = getInstruction(getFieldDefaultValueStoreTag())
      or
      tag = getFieldDefaultValueStoreTag() and
      result = getParent().getChildSuccessor(this)
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = getFieldDefaultValueTag() and
    result = getZeroValue(field.getUnspecifiedType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedFieldInitialization.super.getInstructionRegisterOperand(tag, operandTag)
    or
    tag = getFieldDefaultValueStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(getFieldAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInstruction(getFieldDefaultValueTag())
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  override TranslatedElement getChild(int id) { none() }

  private InstructionTag getFieldDefaultValueTag() { result = InitializerFieldDefaultValueTag() }

  private InstructionTag getFieldDefaultValueStoreTag() {
    result = InitializerFieldDefaultValueStoreTag()
  }
}

/**
 * Represents the IR translation of the initialization of an array element from
 * an element of an initializer list.
 */
abstract class TranslatedElementInitialization extends TranslatedElement {
  ArrayOrVectorAggregateLiteral initList;

  final override string toString() {
    result = initList.toString() + "[" + getElementIndex().toString() + "]"
  }

  final override Locatable getAST() { result = initList }

  final override Function getFunction() { result = initList.getEnclosingFunction() }

  final override Instruction getFirstInstruction() { result = getInstruction(getElementIndexTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
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
    result = getInstruction(getElementAddressTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = getElementAddressTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = getParent().(InitializationContext).getTargetAddress()
      or
      operandTag instanceof RightOperandTag and
      result = getInstruction(getElementIndexTag())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = getElementAddressTag() and
    result = max(getElementType().getSize())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = getElementIndexTag() and
    result = getElementIndex().toString()
  }

  abstract int getElementIndex();

  final InstructionTag getElementAddressTag() { result = InitializerElementAddressTag() }

  final InstructionTag getElementIndexTag() { result = InitializerElementIndexTag() }

  final ArrayOrVectorAggregateLiteral getInitList() { result = initList }

  final Type getElementType() { result = initList.getElementType() }
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

  override Instruction getTargetAddress() { result = getInstruction(getElementAddressTag()) }

  override Type getTargetType() { result = getElementType() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessor(tag, kind)
    or
    tag = getElementAddressTag() and
    result = getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override TranslatedElement getChild(int id) { id = 0 and result = getInitialization() }

  override int getElementIndex() { result = elementIndex }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(initList.getElementExpr(elementIndex).getFullyConverted())
  }
}

/**
 * Represents the IR translation of the initialization of a range of array
 * elements without corresponding elements in the initializer list.
 */
class TranslatedElementValueInitialization extends TranslatedElementInitialization,
  TTranslatedElementValueInitialization {
  int elementIndex;
  int elementCount;

  TranslatedElementValueInitialization() {
    this = TTranslatedElementValueInitialization(initList, elementIndex, elementCount)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    TranslatedElementInitialization.super.hasInstruction(opcode, tag, resultType)
    or
    tag = getElementDefaultValueTag() and
    opcode instanceof Opcode::Constant and
    resultType = getDefaultValueType()
    or
    tag = getElementDefaultValueStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getDefaultValueType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessor(tag, kind)
    or
    kind instanceof GotoEdge and
    (
      tag = getElementAddressTag() and
      result = getInstruction(getElementDefaultValueTag())
      or
      tag = getElementDefaultValueTag() and
      result = getInstruction(getElementDefaultValueStoreTag())
      or
      tag = getElementDefaultValueStoreTag() and
      result = getParent().getChildSuccessor(this)
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    result = TranslatedElementInitialization.super.getInstructionConstantValue(tag)
    or
    tag = getElementDefaultValueTag() and
    result = getZeroValue(getElementType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedElementInitialization.super.getInstructionRegisterOperand(tag, operandTag)
    or
    tag = getElementDefaultValueStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(getElementAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInstruction(getElementDefaultValueTag())
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  override TranslatedElement getChild(int id) { none() }

  override int getElementIndex() { result = elementIndex }

  override predicate needsUnknownOpaqueType(int byteSize) {
    elementCount != 0 and byteSize = elementCount * getElementType().getSize()
  }

  private InstructionTag getElementDefaultValueTag() {
    result = InitializerElementDefaultValueTag()
  }

  private InstructionTag getElementDefaultValueStoreTag() {
    result = InitializerElementDefaultValueStoreTag()
  }

  private CppType getDefaultValueType() {
    if elementCount = 1
    then result = getTypeForPRValue(getElementType())
    else result = getUnknownOpaqueType(elementCount * getElementType().getSize())
  }
}

abstract class TranslatedStructorCallFromStructor extends TranslatedElement, StructorCallContext {
  FunctionCall call;

  final override Locatable getAST() { result = call }

  final override TranslatedElement getChild(int id) {
    id = 0 and
    result = getStructorCall()
  }

  final override Function getFunction() { result = call.getEnclosingFunction() }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = getStructorCall() and
    result = getParent().getChildSuccessor(this)
  }

  final TranslatedExpr getStructorCall() { result = getTranslatedExpr(call) }
}

/**
 * Represents the IR translation of a call to a base class constructor or
 * destructor from within a derived class constructor or destructor.
 */
abstract class TranslatedBaseStructorCall extends TranslatedStructorCallFromStructor {
  final override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::ConvertToNonVirtualBase and
    resultType = getTypeForGLValue(call.getTarget().getDeclaringType())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getStructorCall().getFirstInstruction()
  }

  final override Instruction getReceiver() { result = getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }

  final override predicate getInstructionInheritance(
    InstructionTag tag, Class baseClass, Class derivedClass
  ) {
    tag = OnlyInstructionTag() and
    baseClass = call.getTarget().getDeclaringType().getUnspecifiedType() and
    derivedClass = getFunction().getDeclaringType().getUnspecifiedType()
  }
}

/**
 * Represents a call to a delegating or base class constructor from within a constructor.
 */
abstract class TranslatedConstructorCallFromConstructor extends TranslatedStructorCallFromStructor,
  TTranslatedConstructorBaseInit {
  TranslatedConstructorCallFromConstructor() { this = TTranslatedConstructorBaseInit(call) }
}

TranslatedConstructorCallFromConstructor getTranslatedConstructorBaseInit(ConstructorBaseInit init) {
  result.getAST() = init
}

/**
 * Represents the IR translation of a delegating constructor call from within a constructor.
 */
class TranslatedConstructorDelegationInit extends TranslatedConstructorCallFromConstructor {
  override ConstructorDelegationInit call;

  final override string toString() { result = "delegation construct: " + call.toString() }

  final override Instruction getFirstInstruction() {
    result = getStructorCall().getFirstInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getReceiver() {
    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }
}

/**
 * Represents the IR translation of a call to a base class constructor from within a
 * derived class constructor
 */
class TranslatedConstructorBaseInit extends TranslatedConstructorCallFromConstructor,
  TranslatedBaseStructorCall {
  TranslatedConstructorBaseInit() { not call instanceof ConstructorDelegationInit }

  final override string toString() { result = "construct base: " + call.toString() }
}

TranslatedDestructorBaseDestruction getTranslatedDestructorBaseDestruction(
  DestructorBaseDestruction destruction
) {
  result.getAST() = destruction
}

/**
 * Represents the IR translation of a call to a base class destructor from within a
 * derived class destructor.
 */
class TranslatedDestructorBaseDestruction extends TranslatedBaseStructorCall,
  TTranslatedDestructorBaseDestruction {
  TranslatedDestructorBaseDestruction() { this = TTranslatedDestructorBaseDestruction(call) }

  final override string toString() { result = "destroy base: " + call.toString() }
}
