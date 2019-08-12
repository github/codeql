/**
 * Class that deals with variable initializations.
 * Separated from `TranslatedExpr` for clarity. 
 */

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

  override final Language::AST getAST() {
    result = expr
  }

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
    result = getTranslatedFunction(expr.getEnclosingCallable())
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

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getTargetAddress() { result = getContext().getTargetAddress() }

  override Type getTargetType() { result = getContext().getTargetType() }
}

///**
// * Represents the IR translation of an initialization of an object from an
// * initializer list.
// */
//class TranslatedObjectInitializerInitialization extends TranslatedListInitialization {
//  override ObjectInitializer expr;
//
//  override TranslatedElement getChild(int id) {
//    exists(AssignExpr assign |
//      result = getTranslatedExpr(assign) and
//      expr.getAChild() = assign and
//      assign.getIndex() = id
//    )
//  }
//}

/**
 * Represents the IR translation of an initialization of an array from an
 * initializer list.
 */
class TranslatedArrayListInitialization extends TranslatedListInitialization {
  override ArrayInitializer expr;

  override TranslatedElement getChild(int id) {
    // The children are in initialization order
    result = rank[id + 1](TranslatedElementInitialization init |
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
    // TODO: Make sure this is complete and correct
    not expr instanceof ArrayInitializer and
    not expr instanceof ObjectInitializer and
    not expr instanceof CollectionInitializer and
    not expr instanceof ObjectCreation and
    not expr instanceof StringLiteral
  }

  override TranslatedElement getChild(int id) { id = 0 and result = getInitializer() }

  override Instruction getFirstInstruction() { result = getInitializer().getFirstInstruction() }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
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
      operandTag instanceof AddressOperandTag and
      result = getContext().getTargetAddress()
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInitializer().getResult()
    )
  }
  
  TranslatedExpr getInitializer() { result = getTranslatedExpr(expr) }
}

/**
 * Represents the IR translation of an initialization from a constructor.
 * The `NewObj` instruction denotes the fact that during initialization a new
 * object of type `expr.getType()` is allocated, which is then initialized by the
 * constructor.
 */
class TranslatedObjectInitialization extends TranslatedInitialization,
  StructorCallContext {
  override ObjectCreation expr;

  override TranslatedElement getChild(int id) {
    id = 0 and result = getConstructorCall() or
    id = 1 and result = getInitializerExpr()
  }
  
  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue) {
      (
        // Instruction that allocated space for a new object,
        // and returns its address
        tag = NewObjTag() and
        opcode instanceof Opcode::NewObj and 
        resultType = expr.getType() and
        isLValue = false
      )
      or
      (
        // Store op used to assign the variable that 
        // is initialized the address of the newly allocated
        // object
        tag = InitializerStoreTag() and
        opcode instanceof Opcode::Store and
        resultType = expr.getType() and
        isLValue = false
      )
      or
      (
        needsConversion() and
        tag = AssignmentConvertRightTag() and
        // For now only use `Opcode::Convert` to
        // crudely represent conversions. Could
        // be useful to represent the whole chain of conversions
        opcode instanceof Opcode::Convert and
        resultType = getContext().getTargetType() and
        isLValue = false
      )
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(NewObjTag())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = NewObjTag() and
        result = getConstructorCall().getFirstInstruction()
      )
      or
      (
        tag = InitializerStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
      or
      (
        tag = AssignmentConvertRightTag() and
        result = getInstruction(InitializerStoreTag())
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getConstructorCall() and
      if (exists(getInitializerExpr())) then
        result = getInitializerExpr().getFirstInstruction()
      else
        if needsConversion() then
          result = getInstruction(AssignmentConvertRightTag())
        else
          result = getInstruction(InitializerStoreTag())
    ) or
    (
      child = getInitializerExpr() and
      if (needsConversion()) then
        result = getInstruction(AssignmentConvertRightTag())
      else
        result = getInstruction(InitializerStoreTag())
    )
  }
  
  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    (
      tag = InitializerStoreTag() and
      (
        ( 
          operandTag instanceof AddressOperandTag and
          result = getParent().(InitializationContext).getTargetAddress()
        ) or
        ( 
          operandTag instanceof StoreValueOperandTag and
          if (needsConversion()) then
            result = getInstruction(AssignmentConvertRightTag())
          else
            result = getInstruction(NewObjTag())
        )
      )
    ) or
    (
      tag = AssignmentConvertRightTag() and
      operandTag instanceof UnaryOperandTag and
      result = getInstruction(NewObjTag())
    )
  }
  
  TranslatedExpr getConstructorCall() {
    result = getTranslatedExpr(expr)
  }
  
  TranslatedExpr getInitializerExpr() {
    result = getTranslatedExpr(expr.getInitializer())
  }
  
  override Instruction getReceiver() { 
    // The newly allocated object will be the target of the constructor call
    result = getInstruction(NewObjTag())
  }
  
  private predicate needsConversion() {
     expr.getType() != getContext().getTargetType()
  }
}

private string getZeroValue(Type type) {
  if type instanceof FloatingPointType then result = "0.0" else result = "0"
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

  override final Language::AST getAST() {
    result = initList
  }

  final override Callable getFunction() { result = initList.getEnclosingCallable() }

  final override Instruction getFirstInstruction() { result = getInstruction(getElementIndexTag()) }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    tag = getElementIndexTag() and
    opcode instanceof Opcode::Constant and
    resultType = getIntType() and
    isLValue = false
    or
    tag = getElementAddressTag() and
    opcode instanceof Opcode::PointerAdd and
    resultType = getElementType() and
    isLValue = true
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = getElementIndexTag() and
    result = getInstruction(getElementAddressTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = getElementAddressTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = getParent().(InitializationContext).getTargetAddress()
      or
      operandTag instanceof RightOperandTag and
      result = getInstruction(getElementIndexTag())
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
    result = getTranslatedInitialization(initList.getElement(elementIndex))
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

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    TranslatedElementInitialization.super.hasInstruction(opcode, tag, resultType, isLValue)
    or
    tag = getElementDefaultValueTag() and
    opcode instanceof Opcode::Constant and
    resultType = getDefaultValueType() and
    isLValue = false
    or
    tag = getElementDefaultValueStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getDefaultValueType() and
    isLValue = false
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
    result = TranslatedElementInitialization.super.getInstructionOperand(tag, operandTag)
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

  private InstructionTag getElementDefaultValueTag() {
    result = InitializerElementDefaultValueTag(elementIndex)
  }

  private InstructionTag getElementDefaultValueStoreTag() {
    result = InitializerElementDefaultValueStoreTag(elementIndex)
  }

  private Type getDefaultValueType() {
    if elementCount = 1 then result = getElementType() else result instanceof UnknownType
  }
}

// TODO: Possibly refactor into something simpler
abstract class TranslatedConstructorCallFromConstructor extends TranslatedElement, StructorCallContext {
  Call call;

  override final Language::AST getAST() {
    result = call
  }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = getStructorCall()
  }

  final override Callable getFunction() { result = call.getEnclosingCallable() }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = getStructorCall() and
    result = getParent().getChildSuccessor(this)
  }

  final TranslatedExpr getStructorCall() { result = getTranslatedExpr(call) }
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
  TranslatedConstructorInitializer() {
     this = TTranslatedConstructorInitializer(call)
  }
  
  override string toString() {
    result = "constuructor init: " + call.toString()
  }
  
  override Instruction getFirstInstruction() { 
    if (needsConversion()) then
      result = getInstruction(OnlyInstructionTag()) 
    else
      result = getStructorCall().getFirstInstruction()
  }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    needsConversion() and 
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::Convert and
    resultType = call.getTarget().getDeclaringType() and
    isLValue = true
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getStructorCall().getFirstInstruction()
  }

  override Instruction getReceiver() { 
    if (needsConversion()) then
      result = getInstruction(OnlyInstructionTag()) 
    else
      result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedFunction(getFunction()).getInitializeThisInstruction()
  }

  predicate needsConversion() {
     call.getTarget().getDeclaringType() != getFunction().getDeclaringType()
  }
  
  override predicate getInstructionInheritance(
    InstructionTag tag, Class baseClass, Class derivedClass
  ) {
    tag = OnlyInstructionTag() and
    baseClass = call.getTarget().getDeclaringType() and
    derivedClass = getFunction().getDeclaringType()
  }
}
