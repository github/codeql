private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction

/**
 * Gets the `TranslatedInitialization` for the expression `expr`.
 */
TranslatedInitialization getTranslatedInitialization(Expr expr) {
  result.getExpr() = expr
}

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

  TranslatedInitialization() {
    this = TTranslatedInitialization(expr)
  }

  override final string toString() {
    result = "init: " + expr.toString()
  }

  override final Function getFunction() {
    result = expr.getEnclosingFunction()
  }

  override final Locatable getAST() {
    result = expr
  }

  /**
   * Gets the expression that is doing the initialization.
   */
  final Expr getExpr() {
    result = expr
  }

  /**
   * Gets the initialization context that describes the location being
   * initialized.
   */
  final InitializationContext getContext() {
    result = getParent()
  }

  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(expr.getEnclosingFunction())
  }
}

/**
 * Represents the IR translation of an initialization from an initializer list.
 */
abstract class TranslatedListInitialization extends TranslatedInitialization, InitializationContext {
  override Instruction getFirstInstruction() {
    result = getChild(0).getFirstInstruction() or
    not exists(getChild(0)) and result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = getChild(index) and
      if exists(getChild(index + 1)) then
        result = getChild(index + 1).getFirstInstruction()
      else
        result = getParent().getChildSuccessor(this)
    )
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override Instruction getTargetAddress() {
    result = getContext().getTargetAddress()
  }

  override Type getTargetType() {
    result = getContext().getTargetType()
  }
}

/**
 * Represents the IR translation of an initialization of a class object from an
 * initializer list.
 */
class TranslatedClassListInitialization extends TranslatedListInitialization
{
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
  override ArrayAggregateLiteral expr;

  override TranslatedElement getChild(int id) {
    // The children are in initialization order
    result = rank[id + 1](TranslatedElementInitialization init |
      init.getInitList() = expr |
      init order by init.getElementIndex()
    )
  }
}

/**
 * Represents the IR translation of an initialization from a single initializer
 * expression.
 */
abstract class TranslatedDirectInitialization extends TranslatedInitialization {
  TranslatedDirectInitialization() {
    not expr instanceof AggregateLiteral
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitializer()
  }

  override Instruction getFirstInstruction() {
    result = getInitializer().getFirstInstruction()
  }

  final TranslatedExpr getInitializer() {
    result = getTranslatedExpr(expr)
  }
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

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getContext().getTargetType() and
    isGLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = InitializerStoreTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitializer() and result = getInstruction(InitializerStoreTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      (
        operandTag instanceof AddressOperandTag and
        result = getContext().getTargetAddress()
      ) or
      (
        operandTag instanceof StoreValueOperandTag and
        result = getInitializer().getResult()
      )
    )
  }
}

/**
 * Represents the IR translation of an initialization of an array from a string
 * literal.
 */
class TranslatedStringLiteralInitialization extends TranslatedDirectInitialization {
  override StringLiteral expr;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    (
      // Load the string literal to make it a prvalue of type `char[len]`
      tag = InitializerLoadStringTag() and
      opcode instanceof Opcode::Load and
      resultType = getInitializer().getResultType() and
      isGLValue = false
    ) or
    (
      // Store the string into the target.
      tag = InitializerStoreTag() and
      opcode instanceof Opcode::Store and
      resultType = getInitializer().getResultType() and
      isGLValue = false
    ) or
    exists(int startIndex, int elementCount |
      // If the initializer string isn't large enough to fill the target, then
      // we have to generate another instruction sequence to store a constant
      // zero into the remainder of the array.
      zeroInitRange(startIndex, elementCount) and
      (
        (
          // Create a constant zero whose size is the size of the remaining
          // space in the target array.
          tag = ZeroPadStringConstantTag() and
          opcode instanceof Opcode::Constant and
          resultType instanceof UnknownType and
          isGLValue = false
        ) or
        (
          // The index of the first element to be zero initialized.
          tag = ZeroPadStringElementIndexTag() and
          opcode instanceof Opcode::Constant and
          resultType = getIntType() and
          isGLValue = false
        ) or
        (
          // Compute the address of the first element to be zero initialized.
          tag = ZeroPadStringElementAddressTag() and
          opcode instanceof Opcode::PointerAdd and
          resultType = getElementType() and
          isGLValue = true
        ) or
        (
          // Store the constant zero into the remainder of the string.
          tag = ZeroPadStringStoreTag() and
          opcode instanceof Opcode::Store and
          resultType instanceof UnknownType and
          isGLValue = false
        )
      )
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = InitializerLoadStringTag() and
        result = getInstruction(InitializerStoreTag())
      ) or
      if zeroInitRange(_, _) then (
        (
          tag = InitializerStoreTag() and
          result = getInstruction(ZeroPadStringConstantTag())
        ) or
        (
          tag = ZeroPadStringConstantTag() and
          result = getInstruction(ZeroPadStringElementIndexTag())
        ) or
        (
          tag = ZeroPadStringElementIndexTag() and
          result = getInstruction(ZeroPadStringElementAddressTag())
        ) or
        (
          tag = ZeroPadStringElementAddressTag() and
          result = getInstruction(ZeroPadStringStoreTag())
        ) or
        (
          tag = ZeroPadStringStoreTag() and
          result = getParent().getChildSuccessor(this)
        )
      )
      else (
        tag = InitializerStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitializer() and result = getInstruction(InitializerLoadStringTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    (
      tag = InitializerLoadStringTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInitializer().getResult()
        ) or
        (
          operandTag instanceof LoadOperandTag and
          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
        )
      )
    ) or
    (
      tag = InitializerStoreTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getContext().getTargetAddress()
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getInstruction(InitializerLoadStringTag())
        )
      )
    ) or
    (
      tag = ZeroPadStringElementAddressTag() and
      (
        (
          operandTag instanceof LeftOperandTag and
          result = getContext().getTargetAddress()
        ) or
        (
          operandTag instanceof RightOperandTag and
          result = getInstruction(ZeroPadStringElementIndexTag())
        )
      )
    ) or
    (
      tag = ZeroPadStringStoreTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(ZeroPadStringElementAddressTag())
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getInstruction(ZeroPadStringConstantTag())
        )
      )
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    exists(int startIndex |
      zeroInitRange(startIndex, _) and
      (
        (
          tag = ZeroPadStringConstantTag() and
          result = "0"
        ) or
        (
          tag = ZeroPadStringElementIndexTag() and
          result = startIndex.toString()
        )
      )
    )
  }

  override int getInstructionResultSize(InstructionTag tag) {
    exists(int elementCount |
      zeroInitRange(_, elementCount) and
      (
        tag = ZeroPadStringConstantTag() or
        tag = ZeroPadStringStoreTag()
      ) and
      result = elementCount * getElementType().getSize()
    )
  }

  private Type getElementType() {
    result = getContext().getTargetType().(ArrayType).getBaseType().getUnspecifiedType()
  }

  /**
   * Holds if the `elementCount` array elements starting at `startIndex` must be
   * zero initialized.
   */
  private predicate zeroInitRange(int startIndex, int elementCount) {
    exists(int targetCount |
      startIndex = expr.getUnspecifiedType().(ArrayType).getArraySize() and
      targetCount = getContext().getTargetType().(ArrayType).getArraySize() and
      elementCount = targetCount - startIndex and
      elementCount > 0
    )
  }
}

class TranslatedConstructorInitialization extends TranslatedDirectInitialization, StructorCallContext {
  override ConstructorCall expr;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    none()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitializer() and result = getParent().getChildSuccessor(this)
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  override Instruction getReceiver() {
    result = getContext().getTargetAddress()
  }
}

/**
 * Gets the `TranslatedFieldInitialization` for field `field` within initializer
 * list `initList`.
 */
TranslatedFieldInitialization getTranslatedFieldInitialization(ClassAggregateLiteral initList, Field field) {
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

  override final string toString() {
    result = ast.toString() + "." + field.toString()
  }

  override final Locatable getAST() {
    result = ast
  }

  override final Function getFunction() {
    result = ast.getEnclosingFunction()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(getFieldAddressTag())
  }

  /**
   * Gets the zero-based index describing the order in which this field is to be
   * initialized relative to the other fields in the class.
   */
  final int getOrder() {
    result = field.getInitializationOrder()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    tag = getFieldAddressTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = field.getUnspecifiedType() and
    isGLValue = true
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = getFieldAddressTag() and
    operandTag instanceof UnaryOperandTag and
    result = getParent().(InitializationContext).getTargetAddress()
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = getFieldAddressTag() and result = field
  }

  final InstructionTag getFieldAddressTag() {
    result = InitializerFieldAddressTag(field)
  }

  final Field getField() {
    result = field
  }
}

/**
 * Represents the IR translation of the initialization of a field from an
 * explicit element in an initializer list.
 */
class TranslatedExplicitFieldInitialization extends TranslatedFieldInitialization, InitializationContext,
    TTranslatedExplicitFieldInitialization {
  Expr expr;

  TranslatedExplicitFieldInitialization() {
    this = TTranslatedExplicitFieldInitialization(ast, field, expr)
  }

  override Instruction getTargetAddress() {
    result = getInstruction(getFieldAddressTag())
  }

  override Type getTargetType() {
    result = field.getUnspecifiedType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = getFieldAddressTag() and
    result = getInitialization().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr)
  }
}

private string getZeroValue(Type type) {
  if type instanceof FloatingPointType then
    result = "0.0"
  else
    result = "0"
}

/**
 * Represents the IR translation of the initialization of a field without a
 * corresponding element in the initializer list.
 */
class TranslatedFieldValueInitialization extends TranslatedFieldInitialization, TTranslatedFieldValueInitialization {
  TranslatedFieldValueInitialization() {
    this = TTranslatedFieldValueInitialization(ast, field)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    TranslatedFieldInitialization.super.hasInstruction(opcode, tag, resultType, isGLValue) or
    (
      tag = getFieldDefaultValueTag() and
      opcode instanceof Opcode::Constant and
      resultType = field.getUnspecifiedType() and
      isGLValue = false
    ) or
    (
      tag = getFieldDefaultValueStoreTag() and
      opcode instanceof Opcode::Store and
      resultType = field.getUnspecifiedType() and
      isGLValue = false
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = getFieldAddressTag() and
        result = getInstruction(getFieldDefaultValueTag())
      ) or
      (
        tag = getFieldDefaultValueTag() and
        result = getInstruction(getFieldDefaultValueStoreTag())
      ) or
      (
        tag = getFieldDefaultValueStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = getFieldDefaultValueTag() and
    result = getZeroValue(field.getUnspecifiedType())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedFieldInitialization.super.getInstructionOperand(tag, operandTag) or
    (
      tag = getFieldDefaultValueStoreTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(getFieldAddressTag())
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getInstruction(getFieldDefaultValueTag())
        )
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  private InstructionTag getFieldDefaultValueTag() {
    result = InitializerFieldDefaultValueTag(field)
  }

  private InstructionTag getFieldDefaultValueStoreTag() {
    result = InitializerFieldDefaultValueStoreTag(field)
  }
}

/**
 * Represents the IR translation of the initialization of an array element from
 * an element of an initializer list.
 */
abstract class TranslatedElementInitialization extends TranslatedElement {
  ArrayAggregateLiteral initList;

  override final string toString() {
    result = initList.toString() + "[" + getElementIndex().toString() + "]"
  }

  override final Locatable getAST() {
    result = initList
  }

  override final Function getFunction() {
    result = initList.getEnclosingFunction()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(getElementIndexTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    (
      tag = getElementIndexTag() and
      opcode instanceof Opcode::Constant and
      resultType = getIntType() and
      isGLValue = false
    ) or
    (
      tag = getElementAddressTag() and
      opcode instanceof Opcode::PointerAdd and
      resultType = getElementType() and
      isGLValue = true
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = getElementIndexTag() and
    result = getInstruction(getElementAddressTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = getElementAddressTag() and
    (
      (
        operandTag instanceof LeftOperandTag and
        result = getParent().(InitializationContext).getTargetAddress()
      ) or
      (
        operandTag instanceof RightOperandTag and
        result = getInstruction(getElementIndexTag())
      )
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = getElementIndexTag() and
    result = getElementIndex().toString()
  }

  abstract int getElementIndex();

  final InstructionTag getElementAddressTag() {
    result = InitializerElementAddressTag()
  }

  final InstructionTag getElementIndexTag() {
    result = InitializerElementIndexTag()
  }

  final ArrayAggregateLiteral getInitList() {
    result = initList
  }

  final Type getElementType() {
    result = initList.getUnspecifiedType().(ArrayType).
      getBaseType().getUnspecifiedType()
  }
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

  override Instruction getTargetAddress() {
    result = getInstruction(getElementAddressTag())
  }

  override Type getTargetType() {
    result = getElementType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessor(tag, kind) or
    (
      tag = getElementAddressTag() and
      result = getInitialization().getFirstInstruction() and
      kind instanceof GotoEdge
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override int getElementIndex() {
    result = elementIndex
  }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(
      initList.getElementExpr(elementIndex).getFullyConverted())
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
    this = TTranslatedElementValueInitialization(initList, elementIndex,
      elementCount)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    TranslatedElementInitialization.super.hasInstruction(opcode, tag, resultType, isGLValue) or
    (
      tag = getElementDefaultValueTag() and
      opcode instanceof Opcode::Constant and
      resultType = getDefaultValueType() and
      isGLValue = false
    ) or
    (
      tag = getElementDefaultValueStoreTag() and
      opcode instanceof Opcode::Store and
      resultType = getDefaultValueType() and
      isGLValue = false
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedElementInitialization.super.getInstructionSuccessor(tag, kind) or
    (
      kind instanceof GotoEdge and
      (
        (
          tag = getElementAddressTag() and
          result = getInstruction(getElementDefaultValueTag())
        ) or
        (
          tag = getElementDefaultValueTag() and
          result = getInstruction(getElementDefaultValueStoreTag())
        ) or
        (
          tag = getElementDefaultValueStoreTag() and
          result = getParent().getChildSuccessor(this)
        )
      )
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    result = TranslatedElementInitialization.super.getInstructionConstantValue(tag) or
    (
      tag = getElementDefaultValueTag() and
      result = getZeroValue(getElementType())
    )
  }

  override int getInstructionResultSize(InstructionTag tag) {
    elementCount > 1 and
    (
      tag = getElementDefaultValueTag() or
      tag = getElementDefaultValueStoreTag()
    ) and
    result = elementCount * getElementType().getSize()
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedElementInitialization.super.getInstructionOperand(tag, operandTag) or
    (
      tag = getElementDefaultValueStoreTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(getElementAddressTag())
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getInstruction(getElementDefaultValueTag())
        )
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override int getElementIndex() {
    result = elementIndex
  }
  
  private InstructionTag getElementDefaultValueTag() {
    result = InitializerElementDefaultValueTag()
  }

  private InstructionTag getElementDefaultValueStoreTag() {
    result = InitializerElementDefaultValueStoreTag()
  }

  private Type getDefaultValueType() {
    if elementCount = 1 then
      result = getElementType()
    else
      result instanceof UnknownType
  }
}

abstract class TranslatedStructorCallFromStructor extends TranslatedElement, StructorCallContext {
  FunctionCall call;

  override final Locatable getAST() {
    result = call
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and
    result = getStructorCall()
  }

  override final Function getFunction() {
    result = call.getEnclosingFunction()
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getStructorCall() and
    result = getParent().getChildSuccessor(this)
  }

  final TranslatedExpr getStructorCall() {
    result = getTranslatedExpr(call)
  }
}

/**
 * Represents the IR translation of a call to a base class constructor or
 * destructor from within a derived class constructor or destructor.
 */
abstract class TranslatedBaseStructorCall extends TranslatedStructorCallFromStructor {
  override final Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::ConvertToBase and
    resultType = call.getTarget().getDeclaringType().getUnspecifiedType() and
    isGLValue = true
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getStructorCall().getFirstInstruction()
  }

  override final Instruction getReceiver() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }

  override final predicate getInstructionInheritance(InstructionTag tag, Class baseClass, Class derivedClass) {
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
  TranslatedConstructorCallFromConstructor() {
    this = TTranslatedConstructorBaseInit(call)
  }
}

TranslatedConstructorCallFromConstructor getTranslatedConstructorBaseInit(ConstructorBaseInit init) {
  result.getAST() = init
}

/**
 * Represents the IR translation of a delegating constructor call from within a constructor.
 */
class TranslatedConstructorDelegationInit extends TranslatedConstructorCallFromConstructor {
  override ConstructorDelegationInit call;

  override final string toString() {
    result = "delegation construct: " + call.toString()
  }

  override final Instruction getFirstInstruction() {
    result = getStructorCall().getFirstInstruction()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isGLValue) {
    none()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    none()
  }

  override final Instruction getReceiver() {
    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }
}

/**
 * Represents the IR translation of a call to a base class constructor from within a
 * derived class constructor
 */
class TranslatedConstructorBaseInit extends TranslatedConstructorCallFromConstructor, TranslatedBaseStructorCall {
  TranslatedConstructorBaseInit() {
    not call instanceof ConstructorDelegationInit
  }

  override final string toString() {
    result = "construct base: " + call.toString()
  }
}

TranslatedDestructorBaseDestruction getTranslatedDestructorBaseDestruction(DestructorBaseDestruction destruction) {
  result.getAST() = destruction
}

/**
 * Represents the IR translation of a call to a base class destructor from within a
 * derived class destructor.
 */
class TranslatedDestructorBaseDestruction extends TranslatedBaseStructorCall, TTranslatedDestructorBaseDestruction {
  TranslatedDestructorBaseDestruction() {
    this = TTranslatedDestructorBaseDestruction(call)
  }

  override final string toString() {
    result = "destroy base: " + call.toString()
  }
}
