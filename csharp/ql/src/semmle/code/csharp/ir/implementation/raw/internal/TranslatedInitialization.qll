import csharp
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction
private import semmle.code.csharp.ir.Util
private import IRInternal

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

  override final Callable getFunction() {
    result = expr.getEnclosingCallable()
  }

  override final Language::AST getAST() {
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
    result = getTranslatedFunction(expr.getEnclosingCallable())
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
    Type resultType, boolean isLValue) {
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
  override ObjectInitializer expr;

  override TranslatedElement getChild(int id) {
    exists(TranslatedFieldInitialization fieldInit |
      result = fieldInit and
      fieldInit = getTranslatedFieldInitialization(expr, _) and
      fieldInit.getOrder() = id and
      id = 200
    )
  }
}

/**
 * Represents the IR translation of an initialization of an array from an
 * initializer list.
 */
class TranslatedArrayListInitialization extends TranslatedListInitialization {
  override ArrayInitializer expr;

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
    // TODO: Make sure this is complete and correct
    not expr instanceof ArrayInitializer and
    not expr instanceof ObjectInitializer and
    not expr instanceof CollectionInitializer
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
    not expr instanceof ObjectCreation and
    not expr instanceof StringLiteral
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getContext().getTargetType() and
    isLValue = false
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

class TranslatedObjectCreationInitialization extends TranslatedDirectInitialization, StructorCallContext {
  override ObjectCreation expr;
  
  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    (
     tag = InitializerStoreTag() and
     opcode instanceof Opcode::Store and
     resultType = getContext().getTargetType() and
     isLValue = false
    )
    or
    (
     tag = NewObjTag() and
     opcode instanceof Opcode::NewObj and 
     resultType = expr.getType() and
     isLValue = false
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    (
     tag = NewObjTag() and
     kind instanceof GotoEdge and
     result = getInitializer().getFirstInstruction()
    )
    or
    (
     tag = InitializerStoreTag() and
     result = getParent().getChildSuccessor(this) and
     kind instanceof GotoEdge
    )
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(NewObjTag())   
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
        result = getInstruction(NewObjTag())
      )
    )
  }

  override Instruction getReceiver() {
    result = getInstruction(NewObjTag())
  }
}

/**
 * Gets the `TranslatedFieldInitialization` for field `field` within initializer
 * list `initList`.
 */
TranslatedFieldInitialization getTranslatedFieldInitialization(ObjectInitializer initList, Field field) {
  result.getAST() = initList and result.getField() = field
}

TranslatedFieldInitialization getTranslatedConstructorFieldInitialization(MemberInitializer init) {
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

  override final Language::AST getAST() {
    result = ast
  }

  override final Callable getFunction() {
    result = ast.getEnclosingCallable()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(getFieldAddressTag())
  }

  /**
   * Gets the zero-based index describing the order in which this field is to be
   * initialized relative to the other fields in the class.
   */
  // TODO: Fix getOrder here
  final int getOrder() {
  	result = 0
//    exists(Class cls, int memberIndex | 
//      this = cls.getCanonicalMember(memberIndex) and
//      memberIndex = rank[result + 1](int index |
//        cls.getCanonicalMember(index).(Field).isInitializable()
//      )
//    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    tag = getFieldAddressTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = field.getType() and
    isLValue = true
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
    result = field.getType()
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

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    TranslatedFieldInitialization.super.hasInstruction(opcode, tag, resultType, isLValue) or
    (
      tag = getFieldDefaultValueTag() and
      opcode instanceof Opcode::Constant and
      resultType = field.getType() and
      isLValue = false
    ) or
    (
      tag = getFieldDefaultValueStoreTag() and
      opcode instanceof Opcode::Store and
      resultType = field.getType() and
      isLValue = false
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
    result = getZeroValue(field.getType())
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
  ArrayInitializer initList;

  override final string toString() {
    result = initList.toString() + "[" + getElementIndex().toString() + "]"
  }

  override final Language::AST getAST() {
    result = initList
  }

  override final Callable getFunction() {
    result = initList.getEnclosingCallable()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(getElementIndexTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    (
      tag = getElementIndexTag() and
      opcode instanceof Opcode::Constant and
      resultType = getIntType() and
      isLValue = false
    ) or
    (
      tag = getElementAddressTag() and
      opcode instanceof Opcode::IndexedElementAddress and
      resultType = getElementType() and
      isLValue = true
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
    result = InitializerElementAddressTag(getElementIndex())
  }

  final InstructionTag getElementIndexTag() {
    result = InitializerElementIndexTag(getElementIndex())
  }

  final ArrayInitializer getInitList() {
    result = initList
  }

  final Type getElementType() {
    result = initList.getAnElement().getType()
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
      initList.getElement(elementIndex))
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

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    TranslatedElementInitialization.super.hasInstruction(opcode, tag, resultType, isLValue) or
    (
      tag = getElementDefaultValueTag() and
      opcode instanceof Opcode::Constant and
      resultType = getDefaultValueType() and
      isLValue = false
    ) or
    (
      tag = getElementDefaultValueStoreTag() and
      opcode instanceof Opcode::Store and
      resultType = getDefaultValueType() and
      isLValue = false
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
    // TODO: Memory model C#
    result = 8 //elementCount * getElementType().getSize()
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
    result = InitializerElementDefaultValueTag(elementIndex)
  }

  private InstructionTag getElementDefaultValueStoreTag() {
    result = InitializerElementDefaultValueStoreTag(elementIndex)
  }

  private Type getDefaultValueType() {
    if elementCount = 1 then
      result = getElementType()
    else
      result instanceof UnknownType
  }
}

abstract class TranslatedStructorCallFromStructor extends TranslatedElement, StructorCallContext {
  Call call;

  override final Language::AST getAST() {
    result = call
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and
    result = getStructorCall()
  }

  override final Callable getFunction() {
    result = call.getEnclosingCallable()
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

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::ConvertToBase and
    resultType = call.getTarget().getDeclaringType() and
    isLValue = true
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
    baseClass = call.getTarget().getDeclaringType() and
    derivedClass = getFunction().getDeclaringType()
  }
}

/**
 * Represents a call to a delegating or base class constructor from within a constructor.
 */
//abstract class TranslatedConstructorCallFromConstructor extends TranslatedStructorCallFromStructor,
//    TTranslatedConstructorBaseInit {
//  TranslatedConstructorCallFromConstructor() {
//    this = TTranslatedConstructorBaseInit(call)
//  }
//}
//
//TranslatedConstructorCallFromConstructor getTranslatedConstructorBaseInit(ConstructorBaseInit init) {
//  result.getAST() = init
//}
//
///**
// * Represents the IR translation of a delegating constructor call from within a constructor.
// */
//class TranslatedConstructorDelegationInit extends TranslatedConstructorCallFromConstructor {
//  override ConstructorDelegationInit call;
//
//  override final string toString() {
//    result = "delegation construct: " + call.toString()
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getStructorCall().getFirstInstruction()
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
//    none()
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
//    none()
//  }
//
//  override final Instruction getReceiver() {
//    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
//  }
//}
//
///**
// * Represents the IR translation of a call to a base class constructor from within a
// * derived class constructor
// */
//class TranslatedConstructorBaseInit extends TranslatedConstructorCallFromConstructor, TranslatedBaseStructorCall {
//  TranslatedConstructorBaseInit() {
//    not call instanceof ConstructorDelegationInit
//  }
//
//  override final string toString() {
//    result = "construct base: " + call.toString()
//  }
//}
//
//TranslatedDestructorBaseDestruction getTranslatedDestructorBaseDestruction(DestructorBaseDestruction destruction) {
//  result.getAST() = destruction
//}
//
///**
// * Represents the IR translation of a call to a base class destructor from within a
// * derived class destructor.
// */
//class TranslatedDestructorBaseDestruction extends TranslatedBaseStructorCall, TTranslatedDestructorBaseDestruction {
//  TranslatedDestructorBaseDestruction() {
//    this = TTranslatedDestructorBaseDestruction(call)
//  }
//
//  override final string toString() {
//    result = "destroy base: " + call.toString()
//  }
//}
