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
  TranslatedElement getChildInternal(int id) { id = 0 and result = this.getInitialization() }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(InitializerVariableAddressTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInitialization().getALastInstruction()
    or
    not exists(this.getInitialization()) and result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(this.getTargetType())
    or
    this.hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Uninitialized and
    resultType = getTypeForPRValue(this.getTargetType())
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    (
      tag = InitializerVariableAddressTag() and
      if this.hasUninitializedInstruction()
      then kind instanceof GotoEdge and result = this.getInstruction(InitializerStoreTag())
      else result = this.getInitialization().getFirstInstruction(kind)
    )
    or
    this.hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    (
      result = this.getInitialization().getFirstInstruction(kind)
      or
      not exists(this.getInitialization()) and
      result = this.getInitializationSuccessor(kind)
    )
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and
    result = this.getInitializationSuccessor(kind)
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    this.hasUninitializedInstruction() and
    tag = InitializerStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag()
      or
      this.hasUninitializedInstruction() and tag = InitializerStoreTag()
    ) and
    result = this.getIRVariable()
  }

  final override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
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
   * The successor edge kind is specified by `kind`.
   */
  abstract Instruction getInitializationSuccessor(EdgeKind kind);

  /**
   * Holds if this initialization requires an `Uninitialized` instruction to be emitted before
   * evaluating the initializer.
   */
  final predicate hasUninitializedInstruction() {
    (
      not exists(this.getInitialization()) or
      this.getInitialization() instanceof TranslatedListInitialization or
      this.getInitialization() instanceof TranslatedConstructorInitialization or
      this.getInitialization().(TranslatedStringLiteralInitialization).zeroInitRange(_, _)
    ) and
    // Variables with static or thread-local storage duration are zero-initialized at program startup.
    this.getIRVariable() instanceof IRAutomaticVariable
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

  final override Declaration getFunction() {
    result = getEnclosingFunction(expr) or
    result = getEnclosingVariable(expr).(GlobalOrNamespaceVariable) or
    result = getEnclosingVariable(expr).(StaticInitializedStaticLocalVariable)
  }

  final override Locatable getAst() { result = expr }

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
    result = getTranslatedFunction(this.getFunction())
  }
}

/**
 * Represents the IR translation of an initialization from an initializer list.
 */
abstract class TranslatedListInitialization extends TranslatedInitialization, InitializationContext {
  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getChild(0).getFirstInstruction(kind)
    or
    not exists(this.getChild(0)) and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getChild(max(int i | exists(this.getChild(i)))).getALastInstruction()
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    exists(int index |
      child = this.getChild(index) and
      if exists(this.getChild(index + 1))
      then result = this.getChild(index + 1).getFirstInstruction(kind)
      else result = this.getParent().getChildSuccessor(this, kind)
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    none()
  }

  override Instruction getTargetAddress() { result = this.getContext().getTargetAddress() }

  override Type getTargetType() { result = this.getContext().getTargetType() }
}

/**
 * Represents the IR translation of an initialization of a class object from an
 * initializer list.
 */
class TranslatedClassListInitialization extends TranslatedListInitialization {
  override ClassAggregateLiteral expr;

  override TranslatedElement getChild(int id) {
    result =
      rank[id + 1](TranslatedFieldInitialization fieldInit, int ord |
        fieldInit = getTranslatedFieldInitialization(expr, _) and
        fieldInit.getOrder() = ord
      |
        fieldInit order by ord, fieldInit.getPosition()
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
        init order by init.getElementIndex(), init.getPosition()
      )
  }
}

/**
 * Represents the IR translation of an initialization from a single initializer
 * expression.
 */
abstract class TranslatedDirectInitialization extends TranslatedInitialization {
  TranslatedDirectInitialization() { not expr instanceof AggregateLiteral }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitializer() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInitializer().getFirstInstruction(kind)
  }

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

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(InitializerStoreTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(this.getContext().getTargetType())
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = InitializerStoreTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitializer() and
    result = this.getInstruction(InitializerStoreTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getContext().getTargetAddress()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInitializer().getResult()
    )
  }
}

/**
 * Represents the IR translation of an initialization of an array from a string
 * literal.
 */
class TranslatedStringLiteralInitialization extends TranslatedDirectInitialization {
  override StringLiteral expr;

  override Instruction getALastInstructionInternal() {
    if this.zeroInitRange(_, _)
    then result = this.getInstruction(ZeroPadStringStoreTag())
    else result = this.getInstruction(InitializerStoreTag())
  }

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
    exists(int elementCount |
      // If the initializer string isn't large enough to fill the target, then
      // we have to generate another instruction sequence to store a constant
      // zero into the remainder of the array.
      this.zeroInitRange(_, elementCount) and
      (
        // Create a constant zero whose size is the size of the remaining
        // space in the target array.
        tag = ZeroPadStringConstantTag() and
        opcode instanceof Opcode::Constant and
        resultType = getUnknownOpaqueType(elementCount * this.getElementType().getSize())
        or
        // The index of the first element to be zero initialized.
        tag = ZeroPadStringElementIndexTag() and
        opcode instanceof Opcode::Constant and
        resultType = getIntType()
        or
        // Compute the address of the first element to be zero initialized.
        tag = ZeroPadStringElementAddressTag() and
        opcode instanceof Opcode::PointerAdd and
        resultType = getTypeForGLValue(this.getElementType())
        or
        // Store the constant zero into the remainder of the string.
        tag = ZeroPadStringStoreTag() and
        opcode instanceof Opcode::Store and
        resultType = getUnknownOpaqueType(elementCount * this.getElementType().getSize())
      )
    )
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = InitializerLoadStringTag() and
    result = this.getInstruction(InitializerStoreTag())
    or
    if this.zeroInitRange(_, _)
    then (
      kind instanceof GotoEdge and
      (
        tag = InitializerStoreTag() and
        result = this.getInstruction(ZeroPadStringConstantTag())
        or
        tag = ZeroPadStringConstantTag() and
        result = this.getInstruction(ZeroPadStringElementIndexTag())
        or
        tag = ZeroPadStringElementIndexTag() and
        result = this.getInstruction(ZeroPadStringElementAddressTag())
        or
        tag = ZeroPadStringElementAddressTag() and
        result = this.getInstruction(ZeroPadStringStoreTag())
      )
      or
      tag = ZeroPadStringStoreTag() and
      result = this.getParent().getChildSuccessor(this, kind)
    ) else (
      tag = InitializerStoreTag() and
      result = this.getParent().getChildSuccessor(this, kind)
    )
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitializer() and
    result = this.getInstruction(InitializerLoadStringTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerLoadStringTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInitializer().getResult()
    )
    or
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getContext().getTargetAddress()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(InitializerLoadStringTag())
    )
    or
    tag = ZeroPadStringElementAddressTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getContext().getTargetAddress()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(ZeroPadStringElementIndexTag())
    )
    or
    tag = ZeroPadStringStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(ZeroPadStringElementAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(ZeroPadStringConstantTag())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = ZeroPadStringElementAddressTag() and
    result = max(this.getElementType().getSize())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    exists(int startIndex |
      this.zeroInitRange(startIndex, _) and
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
      this.zeroInitRange(_, elementCount) and
      byteSize = elementCount * this.getElementType().getSize()
    )
  }

  private Type getElementType() {
    result = this.getContext().getTargetType().getUnspecifiedType().(ArrayType).getBaseType()
  }

  /**
   * Holds if the `elementCount` array elements starting at `startIndex` must be
   * zero initialized.
   */
  predicate zeroInitRange(int startIndex, int elementCount) {
    exists(int targetCount |
      startIndex = expr.getUnspecifiedType().(ArrayType).getArraySize() and
      targetCount =
        this.getContext().getTargetType().getUnspecifiedType().(ArrayType).getArraySize() and
      elementCount = targetCount - startIndex and
      elementCount > 0
    )
  }
}

class TranslatedConstructorInitialization extends TranslatedDirectInitialization,
  StructorCallContext
{
  override ConstructorCall expr;

  override Instruction getALastInstructionInternal() {
    result = this.getInitializer().getALastInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitializer() and result = this.getParent().getChildSuccessor(this, kind)
  }

  override TranslatedElement getLastChild() { result = this.getInitializer() }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  override Instruction getReceiver() { result = this.getContext().getTargetAddress() }
}

/**
 * Gets the `TranslatedFieldInitialization` for field `field` within initializer
 * list `initList`.
 */
TranslatedFieldInitialization getTranslatedFieldInitialization(
  ClassAggregateLiteral initList, Field field
) {
  result.getAst() = initList and result.getField() = field
}

TranslatedFieldInitialization getTranslatedConstructorFieldInitialization(ConstructorFieldInit init) {
  result.getAst() = init
}

/**
 * Represents the IR translation of the initialization of a field from an
 * element of an initializer list.
 */
abstract class TranslatedFieldInitialization extends TranslatedElement {
  Expr ast;
  Field field;

  final override string toString() { result = ast.toString() + "." + field.toString() }

  final override Locatable getAst() { result = ast }

  final override Declaration getFunction() {
    result = getEnclosingFunction(ast) or
    result = getEnclosingVariable(ast).(GlobalOrNamespaceVariable) or
    result = getEnclosingVariable(ast).(StaticInitializedStaticLocalVariable)
  }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(this.getFieldAddressTag()) and
    kind instanceof GotoEdge
  }

  /**
   * Gets the zero-based index describing the order in which this field is to be
   * initialized relative to the other fields in the class.
   */
  final int getOrder() { result = field.getInitializationOrder() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = this.getFieldAddressTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getTypeForGLValue(field.getType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = this.getFieldAddressTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getParent().(InitializationContext).getTargetAddress()
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = this.getFieldAddressTag() and result = field
  }

  final InstructionTag getFieldAddressTag() { result = InitializerFieldAddressTag() }

  final Field getField() { result = field }

  /** Gets the position in the initializer list, or `-1` if the initialization is implicit. */
  int getPosition() { result = -1 }
}

/**
 * Represents the IR translation of the initialization of a field from an
 * explicit element in an initializer list.
 */
class TranslatedExplicitFieldInitialization extends TranslatedFieldInitialization,
  InitializationContext, TTranslatedExplicitFieldInitialization
{
  Expr expr;
  int position;

  TranslatedExplicitFieldInitialization() {
    this = TTranslatedExplicitFieldInitialization(ast, field, expr, position)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInitialization().getALastInstruction()
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(this.getFieldAddressTag())
  }

  override Type getTargetType() { result = field.getUnspecifiedType() }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = this.getFieldAddressTag() and
    result = this.getInitialization().getFirstInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and result = this.getParent().getChildSuccessor(this, kind)
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override TranslatedElement getLastChild() { result = this.getInitialization() }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr)
  }

  override int getPosition() { result = position }
}

private string getZeroValue(Type type) {
  if type instanceof FloatingPointType then result = "0.0" else result = "0"
}

/**
 * Represents the IR translation of the initialization of a field without a
 * corresponding element in the initializer list.
 */
class TranslatedFieldValueInitialization extends TranslatedFieldInitialization,
  TTranslatedFieldValueInitialization
{
  TranslatedFieldValueInitialization() { this = TTranslatedFieldValueInitialization(ast, field) }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(this.getFieldDefaultValueStoreTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    TranslatedFieldInitialization.super.hasInstruction(opcode, tag, resultType)
    or
    tag = this.getFieldDefaultValueTag() and
    opcode instanceof Opcode::Constant and
    resultType = getTypeForPRValue(field.getType())
    or
    tag = this.getFieldDefaultValueStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(field.getUnspecifiedType())
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = this.getFieldAddressTag() and
      result = this.getInstruction(this.getFieldDefaultValueTag())
      or
      tag = this.getFieldDefaultValueTag() and
      result = this.getInstruction(this.getFieldDefaultValueStoreTag())
    )
    or
    tag = this.getFieldDefaultValueStoreTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = this.getFieldDefaultValueTag() and
    result = getZeroValue(field.getUnspecifiedType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedFieldInitialization.super.getInstructionRegisterOperand(tag, operandTag)
    or
    tag = this.getFieldDefaultValueStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(this.getFieldAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(this.getFieldDefaultValueTag())
    )
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) { none() }

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
    result = initList.toString() + "[" + this.getElementIndex().toString() + "]"
  }

  final override Locatable getAst() { result = initList }

  final override Declaration getFunction() {
    result = getEnclosingFunction(initList)
    or
    result = getEnclosingVariable(initList).(GlobalOrNamespaceVariable)
    or
    result = getEnclosingVariable(initList).(StaticInitializedStaticLocalVariable)
  }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(this.getElementIndexTag()) and
    kind instanceof GotoEdge
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = this.getElementIndexTag() and
    opcode instanceof Opcode::Constant and
    resultType = getIntType()
    or
    tag = this.getElementAddressTag() and
    opcode instanceof Opcode::PointerAdd and
    resultType = getTypeForGLValue(this.getElementType())
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = this.getElementIndexTag() and
    result = this.getInstruction(this.getElementAddressTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = this.getElementAddressTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getParent().(InitializationContext).getTargetAddress()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(this.getElementIndexTag())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = this.getElementAddressTag() and
    result = max(this.getElementType().getSize())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = this.getElementIndexTag() and
    result = this.getElementIndex().toString()
  }

  abstract int getElementIndex();

  int getPosition() { result = -1 }

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
  TTranslatedExplicitElementInitialization, InitializationContext
{
  int elementIndex;
  int position;

  TranslatedExplicitElementInitialization() {
    this = TTranslatedExplicitElementInitialization(initList, elementIndex, position)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInitialization().getALastInstruction()
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(this.getElementAddressTag())
  }

  override Type getTargetType() { result = this.getElementType() }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessorInternal(tag, kind)
    or
    tag = this.getElementAddressTag() and
    result = this.getInitialization().getFirstInstruction(kind)
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getInitialization() and result = this.getParent().getChildSuccessor(this, kind)
  }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override int getElementIndex() { result = elementIndex }

  override int getPosition() { result = position }

  TranslatedInitialization getInitialization() {
    result =
      getTranslatedInitialization(initList
            .getElementExpr(elementIndex, position)
            .getFullyConverted())
  }
}

/**
 * Represents the IR translation of the initialization of a range of array
 * elements without corresponding elements in the initializer list.
 */
class TranslatedElementValueInitialization extends TranslatedElementInitialization,
  TTranslatedElementValueInitialization
{
  int elementIndex;
  int elementCount;

  TranslatedElementValueInitialization() {
    this = TTranslatedElementValueInitialization(initList, elementIndex, elementCount)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(this.getElementDefaultValueStoreTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    TranslatedElementInitialization.super.hasInstruction(opcode, tag, resultType)
    or
    tag = this.getElementDefaultValueTag() and
    opcode instanceof Opcode::Constant and
    resultType = this.getDefaultValueType()
    or
    tag = this.getElementDefaultValueStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = this.getDefaultValueType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessorInternal(tag, kind)
    or
    kind instanceof GotoEdge and
    (
      tag = this.getElementAddressTag() and
      result = this.getInstruction(this.getElementDefaultValueTag())
      or
      tag = this.getElementDefaultValueTag() and
      result = this.getInstruction(this.getElementDefaultValueStoreTag())
    )
    or
    tag = this.getElementDefaultValueStoreTag() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    result = TranslatedElementInitialization.super.getInstructionConstantValue(tag)
    or
    tag = this.getElementDefaultValueTag() and
    result = getZeroValue(this.getElementType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedElementInitialization.super.getInstructionRegisterOperand(tag, operandTag)
    or
    tag = this.getElementDefaultValueStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(this.getElementAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(this.getElementDefaultValueTag())
    )
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) { none() }

  override TranslatedElement getChild(int id) { none() }

  override int getElementIndex() { result = elementIndex }

  override predicate needsUnknownOpaqueType(int byteSize) {
    elementCount != 0 and byteSize = elementCount * this.getElementType().getSize()
  }

  private InstructionTag getElementDefaultValueTag() {
    result = InitializerElementDefaultValueTag()
  }

  private InstructionTag getElementDefaultValueStoreTag() {
    result = InitializerElementDefaultValueStoreTag()
  }

  private CppType getDefaultValueType() {
    if elementCount = 1
    then result = getTypeForPRValue(this.getElementType())
    else result = getUnknownOpaqueType(elementCount * this.getElementType().getSize())
  }
}

abstract class TranslatedStructorCallFromStructor extends TranslatedElement, StructorCallContext {
  FunctionCall call;

  final override Locatable getAst() { result = call }

  final override TranslatedElement getChild(int id) {
    id = 0 and
    result = this.getStructorCall()
  }

  final override Function getFunction() { result = getEnclosingFunction(call) }

  final override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getStructorCall() and
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override TranslatedElement getLastChild() { result = this.getStructorCall() }

  final TranslatedExpr getStructorCall() { result = getTranslatedExpr(call) }
}

/**
 * Represents the IR translation of a call to a base class constructor or
 * destructor from within a derived class constructor or destructor.
 */
abstract class TranslatedBaseStructorCall extends TranslatedStructorCallFromStructor {
  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getStructorCall().getALastInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::ConvertToNonVirtualBase and
    resultType = getTypeForGLValue(call.getTarget().getDeclaringType())
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getStructorCall().getFirstInstruction(kind)
  }

  final override Instruction getReceiver() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedFunction(this.getFunction()).getInitializeThisInstruction()
  }

  final override predicate getInstructionInheritance(
    InstructionTag tag, Class baseClass, Class derivedClass
  ) {
    tag = OnlyInstructionTag() and
    baseClass = call.getTarget().getDeclaringType().getUnspecifiedType() and
    derivedClass = this.getFunction().getDeclaringType().getUnspecifiedType()
  }
}

/**
 * Represents a call to a delegating or base class constructor from within a constructor.
 */
abstract class TranslatedConstructorCallFromConstructor extends TranslatedStructorCallFromStructor,
  TTranslatedConstructorBaseInit
{
  TranslatedConstructorCallFromConstructor() { this = TTranslatedConstructorBaseInit(call) }
}

TranslatedConstructorCallFromConstructor getTranslatedConstructorBaseInit(ConstructorBaseInit init) {
  result.getAst() = init
}

/**
 * Represents the IR translation of a delegating constructor call from within a constructor.
 */
class TranslatedConstructorDelegationInit extends TranslatedConstructorCallFromConstructor {
  override ConstructorDelegationInit call;

  final override string toString() { result = "delegation construct: " + call.toString() }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getStructorCall().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getStructorCall().getALastInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    none()
  }

  final override Instruction getReceiver() {
    result = getTranslatedFunction(this.getFunction()).getInitializeThisInstruction()
  }
}

/**
 * Represents the IR translation of a call to a base class constructor from within a
 * derived class constructor
 */
class TranslatedConstructorBaseInit extends TranslatedConstructorCallFromConstructor,
  TranslatedBaseStructorCall
{
  TranslatedConstructorBaseInit() { not call instanceof ConstructorDelegationInit }

  final override string toString() { result = "construct base: " + call.toString() }
}

TranslatedDestructorBaseDestruction getTranslatedDestructorBaseDestruction(
  DestructorBaseDestruction destruction
) {
  result.getAst() = destruction
}

/**
 * Represents the IR translation of a call to a base class destructor from within a
 * derived class destructor.
 */
class TranslatedDestructorBaseDestruction extends TranslatedBaseStructorCall,
  TTranslatedDestructorBaseDestruction
{
  TranslatedDestructorBaseDestruction() { this = TTranslatedDestructorBaseDestruction(call) }

  final override string toString() { result = "destroy base: " + call.toString() }
}

/**
 * A constructor base init call where no base constructor has been generated.
 *
 * Workaround for an extractor issue.
 */
class TranslatedConstructorBareInit extends TranslatedElement, TTranslatedConstructorBareInit {
  ConstructorInit init;

  TranslatedConstructorBareInit() { this = TTranslatedConstructorBareInit(init) }

  override Locatable getAst() { result = init }

  final override string toString() { result = "construct base (no constructor)" }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getParent().getChildSuccessor(this, kind)
  }

  override Instruction getALastInstructionInternal() { none() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override TranslatedElement getChild(int id) { none() }

  override Declaration getFunction() { result = this.getParent().getFunction() }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) { none() }
}

TranslatedConstructorBareInit getTranslatedConstructorBareInit(ConstructorInit init) {
  result.getAst() = init
}
