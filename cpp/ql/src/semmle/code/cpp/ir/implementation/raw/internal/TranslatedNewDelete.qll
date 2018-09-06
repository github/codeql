import cpp
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedCall
private import TranslatedInitialization

/**
 * The IR translation of the allocation size argument passed to `operator new`
 * in a `new` expression.
 *
 * We have to synthesize this because not all `NewExpr` nodes have an allocator
 * call, and even the ones that do pass an `ErrorExpr` as the argument.
 */
abstract class TranslatedAllocationSize extends TranslatedExpr,
    TTranslatedAllocationSize {
  NewOrNewArrayExpr newExpr;
  
  TranslatedAllocationSize() {
    this = TTranslatedAllocationSize(newExpr) and
    expr = newExpr
  }

  override final string toString() {
    result = "Allocation size for " + newExpr.toString()
  }

  override final predicate producesExprResult() {
    none()
  }

  override final Instruction getResult() {
    result = getInstruction(AllocationSizeTag())
  }
}

TranslatedAllocationSize getTranslatedAllocationSize(NewOrNewArrayExpr newExpr) {
  result.getAST() = newExpr
}

/**
 * The IR translation of a constant allocation size.
 *
 * The allocation size for a `new` expression is always a constant. The
 * allocation size for a `new[]` expression is a constant if the array extent
 * is a compile-time constant.
 */
class TranslatedConstantAllocationSize extends TranslatedAllocationSize {
  TranslatedConstantAllocationSize() {
    not exists(newExpr.(NewArrayExpr).getExtent())
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(AllocationSizeTag())
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    tag = AllocationSizeTag() and
    opcode instanceof Opcode::Constant and
    resultType = newExpr.getAllocator().getParameter(0).getType().getUnspecifiedType() and
    isGLValue = false
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    tag = AllocationSizeTag() and
    kind instanceof GotoEdge and
    result = getParent().getChildSuccessor(this)
  }

  override final TranslatedElement getChild(int id) {
    none()
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override final string getInstructionConstantValue(InstructionTag tag) {
    tag = AllocationSizeTag() and
    result = newExpr.getAllocatedType().getSize().toString()
  }
}

/**
 * The IR translation of a non-constant allocation size.
 *
 * This class is used for the allocation size of a `new[]` expression where the
 * array extent is not known at compile time. It performs the multiplication of
 * the extent by the element size.
 */
class TranslatedNonConstantAllocationSize extends TranslatedAllocationSize {
  NewArrayExpr newArrayExpr;

  TranslatedNonConstantAllocationSize() {
    newArrayExpr = newExpr and
    exists(newArrayExpr.getExtent())
  }

  override final Instruction getFirstInstruction() {
    result = getExtent().getFirstInstruction()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    isGLValue = false and
    resultType = newExpr.getAllocator().getParameter(0).getType().getUnspecifiedType() and
    (
      // Convert the extent to `size_t`, because the AST doesn't do this already.
      tag = AllocationExtentConvertTag() and opcode instanceof Opcode::Convert or
      tag = AllocationElementSizeTag() and opcode instanceof Opcode::Constant or
      tag = AllocationSizeTag() and opcode instanceof Opcode::Mul // REVIEW: Overflow?
    )
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = AllocationExtentConvertTag() and
        result = getInstruction(AllocationElementSizeTag())
      ) or
      (
        tag = AllocationElementSizeTag() and
        result = getInstruction(AllocationSizeTag())
      ) or
      (
        tag = AllocationSizeTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getExtent()
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getExtent() and
    result = getInstruction(AllocationExtentConvertTag())
  }

  override final string getInstructionConstantValue(InstructionTag tag) {
    tag = AllocationElementSizeTag() and
    result = newArrayExpr.getAllocatedElementType().getSize().toString()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    (
      tag = AllocationSizeTag() and
      (
        operandTag instanceof LeftOperand and result = getInstruction(AllocationExtentConvertTag()) or
        operandTag instanceof RightOperand and result = getInstruction(AllocationElementSizeTag())
      )
    ) or
    (
      tag = AllocationExtentConvertTag() and
      operandTag instanceof UnaryOperand and
      result = getExtent().getResult()
    )
  }

  private TranslatedExpr getExtent() {
    result = getTranslatedExpr(newArrayExpr.getExtent().getFullyConverted())
  }
}

/**
 * The IR translation of a call to `operator new` as part of a `new` or `new[]`
 * expression.
 */
class TranslatedAllocatorCall extends TTranslatedAllocatorCall,
    TranslatedDirectCall {
  NewOrNewArrayExpr newExpr;

  TranslatedAllocatorCall() {
    this = TTranslatedAllocatorCall(newExpr) and
    expr = newExpr
  }

  override final string toString() {
    result = "Allocator call for " + newExpr.toString()
  }

  override final predicate producesExprResult() {
    none()
  }

  override Function getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and result = newExpr.getAllocator()
  }

  override final Type getCallResultType() {
    result = newExpr.getAllocator().getType().getUnspecifiedType()
  }

  override final TranslatedExpr getQualifier() {
    none()
  }

  override final predicate hasArguments() {
    // All allocator calls have at least one argument.
    any()
  }

  override final TranslatedExpr getArgument(int index) {
    // If the allocator is the default operator new(void*), there will be no
    // allocator call in the AST. Otherwise, there will be an allocator call
    // that includes all arguments to the allocator, including the size,
    // alignment (if any), and placement args. However, the size argument is
    // an error node, so we need to provide the correct size argument in any
    // case.
    if index = 0 then
      result = getTranslatedAllocationSize(newExpr)
    else if(index = 1 and newExpr.hasAlignedAllocation()) then
      result = getTranslatedExpr(newExpr.getAlignmentArgument())
    else
      result = getTranslatedExpr(newExpr.getAllocatorCall().getArgument(index))
  }
}

TranslatedAllocatorCall getTranslatedAllocatorCall(NewOrNewArrayExpr newExpr) {
  result.getAST() = newExpr
}

/**
 * The IR translation of a `new` or `new[]` expression.
 */
abstract class TranslatedNewOrNewArrayExpr extends TranslatedNonConstantExpr,
    InitializationContext {
  NewOrNewArrayExpr newExpr;

  TranslatedNewOrNewArrayExpr() {
    expr = newExpr
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getAllocatorCall() or
    id = 1 and result = getInitialization()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::Convert and
    resultType = getResultType() and
    isGLValue = false
  }

  override final Instruction getFirstInstruction() {
    result = getAllocatorCall().getFirstInstruction()
  }

  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = OnlyInstructionTag() and
    if exists(getInitialization()) then
      result = getInitialization().getFirstInstruction()
    else
      result = getParent().getChildSuccessor(this)
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getAllocatorCall() and result = getInstruction(OnlyInstructionTag()) or
    child = getInitialization() and result = getParent().getChildSuccessor(this)
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperand and
    result = getAllocatorCall().getResult()
  }
  
  override final Instruction getTargetAddress() {
    result = getInstruction(OnlyInstructionTag())
  }

  private TranslatedAllocatorCall getAllocatorCall() {
    result = getTranslatedAllocatorCall(newExpr)
  }

  abstract TranslatedInitialization getInitialization();
}

/**
 * The IR translation of a `new` expression.
 */
class TranslatedNewExpr extends TranslatedNewOrNewArrayExpr {
  TranslatedNewExpr() {
    newExpr instanceof NewExpr
  }

  override final Type getTargetType() {
    result = newExpr.getAllocatedType().getUnspecifiedType()
  }

  override final TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(newExpr.(NewExpr).getInitializer())
  }
}

/**
 * The IR translation of a `new[]` expression.
 */
class TranslatedNewArrayExpr extends TranslatedNewOrNewArrayExpr {
  TranslatedNewArrayExpr() {
    newExpr instanceof NewArrayExpr
  }

  override final Type getTargetType() {
    result = newExpr.getAllocatedType().getUnspecifiedType()
  }

  override final TranslatedInitialization getInitialization() {
    // REVIEW: Figure out how we want to model array initialization in the IR.
    none()
  }
}
