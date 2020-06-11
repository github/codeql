import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.internal.TempVariableTag
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.IRUtilities
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclaration
private import TranslatedElement
private import TranslatedFunction
private import TranslatedInitialization
private import common.TranslatedConditionBase
private import common.TranslatedCallBase
private import common.TranslatedExprBase
private import desugar.Delegate
private import desugar.internal.TranslatedCompilerGeneratedCall
import TranslatedCall
private import experimental.ir.Util
private import experimental.ir.internal.IRCSharpLanguage as Language

/**
 * Gets the TranslatedExpr for the specified expression. If `expr` is a load,
 * the result is the TranslatedExpr for the load portion.
 */
TranslatedExpr getTranslatedExpr(Expr expr) {
  result.getExpr() = expr and
  result.producesExprResult() and
  // When a constructor call is needed, we fetch it manually.
  // This is because of how we translate object creations: the translated expression
  // and the translated constructor call are attached to the same element.
  (expr instanceof ObjectCreation implies not result instanceof TranslatedConstructorCall)
}

/**
 * The IR translation of some part of an expression.
 * A single `Expr` may consist of multiple `TranslatedExpr` objects. Every
 * `Expr` has a single `TranslatedCoreExpr`, which produces the result of the
 * expression before any implicit lvalue-to-rvalue conversion. Any expression
 * with an lvalue-to-rvalue conversion will also have a `TranslatedLoad` to
 * perform that conversion on the original result. A few expressions have
 * additional `TranslatedExpr` objects that compute intermediate values, such
 * as the `TranslatedAllocatorCall` and `TranslatedAllocationSize` within the
 * translation of a `NewExpr`.
 */
abstract class TranslatedExpr extends TranslatedExprBase {
  Expr expr;

  /**
   * Holds if this `TranslatedExpr` produces the final result of the original
   * expression from the AST.
   *
   * For example, in `y = x;`, the TranslatedLoad for the VariableAccess `x`
   * produces the result of that VariableAccess expression, but the
   * TranslatedVariableAccess for `x` does not. The TranslatedVariableAccess
   * for `y` does produce its result, however, because there is no load on `y`.
   */
  abstract predicate producesExprResult();

  /**
   * Gets the type of the result produced by this expression.
   */
  final Type getResultType() { result = expr.getType() }

  final override Language::AST getAST() { result = expr }

  final override Callable getFunction() { result = expr.getEnclosingCallable() }

  /**
   * Gets the expression from which this `TranslatedExpr` is generated.
   */
  final Expr getExpr() { result = expr }

  /**
   * Gets the `TranslatedFunction` containing this expression.
   */
  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(expr.getEnclosingCallable())
  }
}

/**
 * The IR translation of the "core"  part of an expression. This is the part of
 * the expression that produces the result value of the expression, before any
 * lvalue-to-rvalue conversion on the result. Every expression has a single
 * `TranslatedCoreExpr`.
 */
abstract class TranslatedCoreExpr extends TranslatedExpr {
  final override string toString() { result = expr.toString() }

  /**
   * All exprs produce a final value, apart from reads. They first need an access,
   * then a load.
   */
  final override predicate producesExprResult() {
    // If the expr needs a load, its translation does not produce the final value.
    not needsLoad(expr)
  }

  final CSharpType getResultCSharpType() {
    if isResultLValue() = true
    then result = getTypeForGLValue(expr.getType())
    else result = getTypeForPRValue(expr.getType())
  }

  /**
   * Returns `true` if the result of this `TranslatedExpr` is a lvalue, or
   * `false` if the result is a rvalue.
   *
   * This predicate returns a `boolean` value instead of just a being a plain
   * predicate because all of the subclass predicates that call it require a
   * `boolean` value.
   */
  final boolean isResultLValue() {
    if not this.producesExprResult() then result = true else result = false
  }
}

class TranslatedConditionValue extends TranslatedCoreExpr, ConditionContext,
  TTranslatedConditionValue {
  TranslatedConditionValue() { this = TTranslatedConditionValue(expr) }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getCondition() }

  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    (
      tag = ConditionValueTrueTempAddressTag() or
      tag = ConditionValueFalseTempAddressTag() or
      tag = ConditionValueResultTempAddressTag()
    ) and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(expr.getType())
    or
    (
      tag = ConditionValueTrueConstantTag() or
      tag = ConditionValueFalseConstantTag()
    ) and
    opcode instanceof Opcode::Constant and
    resultType = getResultCSharpType()
    or
    (
      tag = ConditionValueTrueStoreTag() or
      tag = ConditionValueFalseStoreTag()
    ) and
    opcode instanceof Opcode::Store and
    resultType = getResultCSharpType()
    or
    tag = ConditionValueResultLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getResultCSharpType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = ConditionValueTrueTempAddressTag() and
      result = this.getInstruction(ConditionValueTrueConstantTag())
      or
      tag = ConditionValueTrueConstantTag() and
      result = this.getInstruction(ConditionValueTrueStoreTag())
      or
      tag = ConditionValueTrueStoreTag() and
      result = this.getInstruction(ConditionValueResultTempAddressTag())
      or
      tag = ConditionValueFalseTempAddressTag() and
      result = this.getInstruction(ConditionValueFalseConstantTag())
      or
      tag = ConditionValueFalseConstantTag() and
      result = this.getInstruction(ConditionValueFalseStoreTag())
      or
      tag = ConditionValueFalseStoreTag() and
      result = this.getInstruction(ConditionValueResultTempAddressTag())
      or
      tag = ConditionValueResultTempAddressTag() and
      result = this.getInstruction(ConditionValueResultLoadTag())
      or
      tag = ConditionValueResultLoadTag() and
      result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ConditionValueTrueStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(ConditionValueTrueTempAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(ConditionValueTrueConstantTag())
    )
    or
    tag = ConditionValueFalseStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(ConditionValueFalseTempAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(ConditionValueFalseConstantTag())
    )
    or
    tag = ConditionValueResultLoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(ConditionValueResultTempAddressTag())
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = ConditionValueTempVar() and
    type = this.getResultCSharpType()
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = ConditionValueTrueTempAddressTag() or
      tag = ConditionValueFalseTempAddressTag() or
      tag = ConditionValueResultTempAddressTag()
    ) and
    result = this.getTempVariable(ConditionValueTempVar())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = ConditionValueTrueConstantTag() and result = "1"
    or
    tag = ConditionValueFalseConstantTag() and result = "0"
  }

  override Instruction getResult() { result = this.getInstruction(ConditionValueResultLoadTag()) }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  override Instruction getChildTrueSuccessor(ConditionBase child) {
    child = this.getCondition() and
    result = this.getInstruction(ConditionValueTrueTempAddressTag())
  }

  override Instruction getChildFalseSuccessor(ConditionBase child) {
    child = this.getCondition() and
    result = this.getInstruction(ConditionValueFalseTempAddressTag())
  }

  private TranslatedCondition getCondition() { result = getTranslatedCondition(expr) }
}

/**
 * IR translation of an implicit lvalue-to-rvalue conversion on the result of
 * an expression.
 */
class TranslatedLoad extends TranslatedExpr, TTranslatedLoad {
  TranslatedLoad() { this = TTranslatedLoad(expr) }

  override string toString() { result = "Load of " + expr.toString() }

  override Instruction getFirstInstruction() { result = this.getOperand().getFirstInstruction() }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    if producesExprResult()
    then resultType = getTypeForPRValue(expr.getType())
    else resultType = getTypeForGLValue(expr.getType())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = LoadTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(LoadTag())
  }

  override Instruction getResult() { result = this.getInstruction(LoadTag()) }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getOperand().getResult()
  }

  final override predicate producesExprResult() {
    // A load always produces the result of the expression.
    any()
  }

  private TranslatedCoreExpr getOperand() { result.getExpr() = expr }
}

abstract class TranslatedCrementOperation extends TranslatedNonConstantExpr {
  override MutatorOperation expr;

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override string getInstructionConstantValue(InstructionTag tag) {
    tag = CrementConstantTag() and
    exists(Type resultType |
      resultType = this.getResultType() and
      (
        resultType instanceof IntegralType and result = "1"
        or
        resultType instanceof FloatingPointType and result = "1.0"
        or
        resultType instanceof PointerType and result = "1"
      )
    )
  }

  private Type getConstantType() {
    exists(Type resultType |
      resultType = this.getResultType() and
      (
        resultType instanceof IntegralType and result = this.getResultType()
        or
        resultType instanceof FloatingPointType and result = this.getResultType()
        or
        resultType instanceof PointerType and result = any(IntType t)
      )
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = CrementLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(expr.getType())
    or
    tag = CrementConstantTag() and
    opcode instanceof Opcode::Constant and
    resultType = getTypeForPRValue(this.getConstantType())
    or
    tag = CrementOpTag() and
    opcode = this.getOpcode() and
    resultType = getTypeForPRValue(expr.getType())
    or
    tag = CrementStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType())
  }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CrementLoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getOperand().getResult()
    or
    tag = CrementOpTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getInstruction(CrementLoadTag())
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(CrementConstantTag())
    )
    or
    tag = CrementStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getOperand().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(CrementOpTag())
    )
  }

  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = CrementLoadTag() and
      result = this.getInstruction(CrementConstantTag())
      or
      tag = CrementConstantTag() and
      result = this.getInstruction(CrementOpTag())
      or
      tag = CrementOpTag() and
      result = this.getInstruction(CrementStoreTag())
      or
      tag = CrementStoreTag() and
      result = this.getParent().getChildSuccessor(this)
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(CrementLoadTag())
  }

  final override int getInstructionElementSize(InstructionTag tag) {
    tag = CrementOpTag() and
    (
      this.getOpcode() instanceof Opcode::PointerAdd or
      this.getOpcode() instanceof Opcode::PointerSub
    ) and
    result = Language::getTypeSize(this.getResultType().(PointerType).getReferentType())
  }

  final TranslatedExpr getOperand() { result = getTranslatedExpr(expr.getOperand()) }

  final Opcode getOpcode() {
    exists(Type resultType |
      resultType = this.getResultType() and
      (
        (
          expr instanceof IncrementOperation and
          if resultType instanceof PointerType
          then result instanceof Opcode::PointerAdd
          else result instanceof Opcode::Add
        )
        or
        (
          expr instanceof DecrementOperation and
          if resultType instanceof PointerType
          then result instanceof Opcode::PointerSub
          else result instanceof Opcode::Sub
        )
      )
    )
  }
}

class TranslatedPrefixCrementOperation extends TranslatedCrementOperation {
  TranslatedPrefixCrementOperation() {
    expr instanceof PreIncrExpr or
    expr instanceof PreDecrExpr
  }

  override Instruction getResult() { result = this.getInstruction(CrementOpTag()) }
}

class TranslatedPostfixCrementOperation extends TranslatedCrementOperation {
  TranslatedPostfixCrementOperation() {
    expr instanceof PostIncrExpr or
    expr instanceof PostDecrExpr
  }

  override Instruction getResult() { result = this.getInstruction(CrementLoadTag()) }
}

class TranslatedObjectInitializerExpr extends TranslatedNonConstantExpr, InitializationContext {
  override ObjectInitializer expr;

  override Instruction getResult() { none() }

  override Instruction getFirstInstruction() { result = this.getChild(0).getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override TranslatedElement getChild(int id) {
    result = getTranslatedExpr(expr.getMemberInitializer(id))
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getChild(index) and
      if exists(this.getChild(index + 1))
      then result = this.getChild(index + 1).getFirstInstruction()
      else result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getTargetAddress() {
    // The target address is the address of the newly allocated object,
    // which can be retrieved from the parent `TranslatedObjectCreation`.
    result = this.getParent().getInstruction(NewObjTag())
  }

  override Type getTargetType() {
    result = this.getParent().getInstruction(NewObjTag()).getResultType()
  }
}

class TranslatedCollectionInitializer extends TranslatedNonConstantExpr, InitializationContext {
  override CollectionInitializer expr;

  override Instruction getResult() { none() }

  override Instruction getFirstInstruction() { result = this.getChild(0).getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override TranslatedElement getChild(int id) {
    result = getTranslatedExpr(expr.getElementInitializer(id))
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int index |
      child = this.getChild(index) and
      (
        result = this.getChild(index + 1).getFirstInstruction()
        or
        not exists(this.getChild(index + 1)) and
        result = this.getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getTargetAddress() {
    // The target address is the address of the newly allocated object,
    // which can be retrieved from the parent `TranslatedObjectCreation`.
    result = this.getParent().getInstruction(NewObjTag())
  }

  override Type getTargetType() {
    result = this.getParent().getInstruction(NewObjTag()).getResultType()
  }
}

/**
 * The translation of an array access expression. The `ElementsAddress`
 * instruction, given the address of an array, return the address
 * of the element at index 0 of that array. To correctly treat the
 * multidimensional case, we generate the address incrementally. For example,
 * the address of a[1][1] will produce the instructions:
 *    r0_1(Int32[,])       = VariableAddress[a]  :
 *    r0_2(Int32[,])       = ElementsAddress     : r0_1
 *    r0_3(Int32)          = Constant[1]         :
 *    r0_4(Int32[,])       = PointerAdd[4]       : r0_2, r0_3
 *    r0_5(Int32[])        = ElementsAddress     : r0_4
 *    r0_6(Int32)          = Constant[1]         :
 *    r0_7(Int32[])        = PointerAdd[4]       : r0_5, r0_6
 *
 * To support this incremental address calculation,
 * the `ElementsAddress` and `PointerAdd` instructions are indexed (so that
 * we correctly find the successor of instructions).
 */
class TranslatedArrayAccess extends TranslatedNonConstantExpr {
  override ArrayAccess expr;

  override Instruction getFirstInstruction() {
    result = this.getBaseOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) {
    id = -1 and result = getBaseOperand()
    or
    result = this.getOffsetOperand(id)
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    exists(int index |
      this.inBounds(index) and
      kind instanceof GotoEdge and
      (
        // The successor of a `PointerAdd` is an `ElementsAddress` if
        // that `PointerAdd` is not the last `PointerAdd` instruction.
        tag = PointerAddTag(index) and
        result = this.getInstruction(ElementsAddressTag(index + 1))
        or
        // The successor of the last `PointerAdd` instruction is
        // the successor of the `TranslatedArrayAccess`.
        tag = PointerAddTag(getRank() - 1) and
        result = this.getParent().getChildSuccessor(this)
        or
        // The successor of an `ElementsAddress` instruction is
        // an offset expression.
        tag = ElementsAddressTag(index) and
        result = this.getOffsetOperand(index).getFirstInstruction()
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // The base address of the array is followed by the first
    // `ElementsAddress` instruction.
    child = this.getBaseOperand() and
    result = this.getInstruction(ElementsAddressTag(0))
    or
    // The successor of an offset expression is a `PointerAdd` expression.
    child = this.getOffsetOperand(child.getAST().getIndex()) and
    child.getAST().getIndex() >= 0 and
    result = this.getInstruction(PointerAddTag(child.getAST().getIndex()))
  }

  override Instruction getResult() { result = this.getInstruction(PointerAddTag(getRank() - 1)) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    exists(int index |
      inBounds(index) and
      tag = PointerAddTag(index) and
      opcode instanceof Opcode::PointerAdd and
      resultType = getTypeForPRValue(getArrayOfDim(getRank() - index, expr.getType()))
    )
    or
    exists(int index |
      inBounds(index) and
      tag = ElementsAddressTag(index) and
      opcode instanceof Opcode::ElementsAddress and
      resultType = getTypeForPRValue(getArrayOfDim(getRank() - index, expr.getType()))
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    exists(int index |
      inBounds(index) and
      tag = PointerAddTag(index) and
      (
        operandTag instanceof LeftOperandTag and
        result = this.getInstruction(ElementsAddressTag(index))
        or
        operandTag instanceof RightOperandTag and
        result = this.getOffsetOperand(index).getResult()
      )
    )
    or
    tag = ElementsAddressTag(0) and
    (
      operandTag instanceof UnaryOperandTag and
      result = this.getBaseOperand().getResult()
    )
    or
    exists(int index |
      this.inBounds(index) and
      index > 0 and
      tag = ElementsAddressTag(index) and
      (
        operandTag instanceof UnaryOperandTag and
        result = this.getInstruction(PointerAddTag(index - 1))
      )
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    exists(int index |
      inBounds(index) and
      tag = PointerAddTag(index) and
      result = Language::getTypeSize(expr.getQualifier().getType().(ArrayType).getElementType())
    )
  }

  private TranslatedExpr getBaseOperand() { result = getTranslatedExpr(expr.getQualifier()) }

  private TranslatedExpr getOffsetOperand(int index) {
    this.inBounds(index) and
    result = getTranslatedExpr(expr.getChild(index))
  }

  private predicate inBounds(int index) { index in [0 .. this.getRank() - 1] }

  private int getRank() { result = count(expr.getIndex(_)) }
}

abstract class TranslatedPointerOps extends TranslatedNonConstantExpr {
  override UnaryOperation expr;

  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getParent().getChildSuccessor(this)
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  final override Instruction getResult() { result = this.getOperand().getResult() }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  abstract TranslatedExpr getOperand();
}

class TranslatedPointerIndirectionExpr extends TranslatedPointerOps {
  override PointerIndirectionExpr expr;

  override TranslatedExpr getOperand() { result = getTranslatedExpr(expr.getOperand()) }
}

class TranslatedAddressExpr extends TranslatedPointerOps {
  override AddressOfExpr expr;

  override TranslatedExpr getOperand() { result = getTranslatedExpr(expr.getOperand()) }
}

class TranslatedThisExpr extends TranslatedNonConstantExpr {
  override ThisAccess expr;

  final override TranslatedElement getChild(int id) { none() }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::CopyValue and
    resultType = getTypeForPRValue(expr.getType())
  }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInitializeThisInstruction()
  }

  private Instruction getInitializeThisInstruction() {
    result = getTranslatedFunction(expr.getEnclosingCallable()).getInitializeThisInstruction()
  }
}

abstract class TranslatedVariableAccess extends TranslatedNonConstantExpr {
  override VariableAccess expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getQualifier() // Might not exist
  }

  final TranslatedExpr getQualifier() {
    expr instanceof QualifiableExpr and
    result = getTranslatedExpr(expr.(QualifiableExpr).getQualifier())
  }

  override Instruction getResult() {
    if this.needsExtraLoad()
    then result = this.getInstruction(LoadTag())
    else result = this.getInstruction(AddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    this.needsExtraLoad() and
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(expr.getType())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = AddressTag() and
    (
      if this.needsExtraLoad()
      then result = this.getInstruction(LoadTag())
      else result = this.getParent().getChildSuccessor(this)
    ) and
    kind instanceof GotoEdge
    or
    this.needsExtraLoad() and
    tag = LoadTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    this.needsExtraLoad() and
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(AddressTag())
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getQualifier() and result = this.getInstruction(AddressTag())
  }

  /**
   * Some variable accesses need an extra load, eg. ref parameters,
   * out parameters
   */
  final private predicate needsExtraLoad() {
    (
      expr.getTarget().(Parameter).isOutOrRef() or
      expr.getTarget().(Parameter).isIn()
    ) and
    (expr.getParent() instanceof FieldAccess implies expr.getType().isRefType())
  }
}

class TranslatedNonFieldVariableAccess extends TranslatedVariableAccess {
  TranslatedNonFieldVariableAccess() {
    not expr instanceof FieldAccess and
    // If the parent expression is a `LocalVariableDeclAndInitExpr`,
    // then translate only the variables that are initializers (on the RHS)
    // and not the LHS (the address of the LHS is generated during
    // the translation of the initialization).
    (
      expr.getParent() instanceof LocalVariableDeclAndInitExpr
      implies
      expr = expr.getParent().(LocalVariableDeclAndInitExpr).getInitializer()
    )
    or
    // Static field accesses should be modeled as `TranslatedNonFieldAccess`
    expr.(FieldAccess).getTarget().isStatic()
  }

  override Instruction getFirstInstruction() {
    if exists(this.getQualifier())
    then result = this.getQualifier().getFirstInstruction()
    else result = this.getInstruction(AddressTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedVariableAccess.super.getInstructionOperand(tag, operandTag)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    TranslatedVariableAccess.super.hasInstruction(opcode, tag, resultType)
    or
    tag = AddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(this.getResultType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getIRUserVariable(expr.getEnclosingCallable(), expr.getTarget())
  }
}

class TranslatedFieldAccess extends TranslatedVariableAccess {
  override FieldAccess expr;

  TranslatedFieldAccess() {
    // Static field accesses should be modeled as `TranslatedNonFieldAccess`
    not expr.getTarget().isStatic()
  }

  override Instruction getFirstInstruction() {
    // If there is a qualifier
    if exists(this.getQualifier())
    then result = this.getQualifier().getFirstInstruction()
    else
      // it means that the access is part of an `ObjectInitializer` expression
      // so the instructions for the qualifier have been generated previously.
      result = this.getInstruction(AddressTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedVariableAccess.super.getInstructionOperand(tag, operandTag)
    or
    tag = AddressTag() and
    operandTag instanceof UnaryOperandTag and
    // A normal field access always has a qualifier
    if exists(this.getQualifier())
    then result = this.getQualifier().getResult()
    else
      // This field access is part of an `ObjectInitializer`
      // so the translated element of the initializer
      // (which is the parent of the parent of the translated field access),
      // being an `InitializationContext`, knows the target address of this field access.
      result = this.getParent().getParent().(InitializationContext).getTargetAddress()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = AddressTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getTypeForGLValue(expr.getType())
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = AddressTag() and
    result = expr.getTarget()
  }
}

class TranslatedFunctionAccess extends TranslatedNonConstantExpr {
  override CallableAccess expr;

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = this.getInstruction(OnlyInstructionTag()) }

  override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FunctionAddress and
    resultType = getTypeForGLValue(expr.getType())
  }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getTarget()
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

/**
 * IR translation of an expression whose value is not known at compile time.
 */
abstract class TranslatedNonConstantExpr extends TranslatedCoreExpr, TTranslatedValueExpr {
  TranslatedNonConstantExpr() {
    this = TTranslatedValueExpr(expr) and
    not isIRConstant(expr)
  }
}

/**
 * IR translation of an expression with a compile-time constant value. This
 * includes not only literals, but also "integral constant expressions" (e.g.
 * `1 + 2`).
 */
abstract class TranslatedConstantExpr extends TranslatedCoreExpr, TTranslatedValueExpr {
  TranslatedConstantExpr() {
    this = TTranslatedValueExpr(expr) and
    isIRConstant(expr)
  }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  final override TranslatedElement getChild(int id) { none() }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = OnlyInstructionTag() and
    opcode = this.getOpcode() and
    resultType = getTypeForPRValue(expr.getType())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  abstract Opcode getOpcode();
}

class TranslatedArithmeticLiteral extends TranslatedConstantExpr {
  TranslatedArithmeticLiteral() { not expr instanceof StringLiteral }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getValue()
  }

  override Opcode getOpcode() { result instanceof Opcode::Constant }
}

class TranslatedStringLiteral extends TranslatedConstantExpr {
  override StringLiteral expr;

  override StringLiteral getInstructionStringLiteral(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr
  }

  override Opcode getOpcode() { result instanceof Opcode::StringConstant }
}

/**
 * IR translation of an expression that performs a single operation on its
 * operands and returns the result.
 */
abstract class TranslatedSingleInstructionExpr extends TranslatedNonConstantExpr {
  /**
   * Gets the `Opcode` of the operation to be performed.
   */
  abstract Opcode getOpcode();

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    opcode = getOpcode() and
    tag = OnlyInstructionTag() and
    resultType = getResultCSharpType()
  }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }
}

class TranslatedUnaryExpr extends TranslatedSingleInstructionExpr {
  TranslatedUnaryExpr() {
    expr instanceof LogicalNotExpr or
    expr instanceof ComplementExpr or
    expr instanceof UnaryPlusExpr or
    expr instanceof UnaryMinusExpr
  }

  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(OnlyInstructionTag())
  }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    result = this.getOperand().getResult() and
    operandTag instanceof UnaryOperandTag
  }

  final override Opcode getOpcode() {
    expr instanceof LogicalNotExpr and result instanceof Opcode::LogicalNot
    or
    expr instanceof ComplementExpr and result instanceof Opcode::BitComplement
    or
    expr instanceof UnaryPlusExpr and result instanceof Opcode::CopyValue
    or
    expr instanceof UnaryMinusExpr and result instanceof Opcode::Negate
  }

  private TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.(UnaryOperation).getOperand())
  }
}

/**
 * Represents the translation of a cast expression that generates a
 * single `Convert` instruction.
 */
class TranslatedCast extends TranslatedNonConstantExpr {
  override Cast expr;

  override Instruction getFirstInstruction() { result = this.getOperand().getFirstInstruction() }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ConvertTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(ConvertTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    (
      tag = ConvertTag() and
      opcode = this.getOpcode() and
      resultType = getTypeForPRValue(expr.getType())
    )
  }

  override Instruction getResult() { result = this.getInstruction(ConvertTag()) }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    (
      tag = ConvertTag() and
      operandTag instanceof UnaryOperandTag and
      result = this.getOperand().getResult()
    )
  }

  private TranslatedExpr getOperand() { result = getTranslatedExpr(expr.(Cast).getExpr()) }

  private Opcode getOpcode() {
    expr instanceof CastExpr and result instanceof Opcode::CheckedConvertOrThrow
    or
    expr instanceof AsExpr and result instanceof Opcode::CheckedConvertOrNull
  }
}

private Opcode binaryBitwiseOpcode(BinaryBitwiseOperation expr) {
  expr instanceof LShiftExpr and result instanceof Opcode::ShiftLeft
  or
  expr instanceof RShiftExpr and result instanceof Opcode::ShiftRight
  or
  expr instanceof BitwiseAndExpr and result instanceof Opcode::BitAnd
  or
  expr instanceof BitwiseOrExpr and result instanceof Opcode::BitOr
  or
  expr instanceof BitwiseXorExpr and result instanceof Opcode::BitXor
}

private Opcode binaryArithmeticOpcode(BinaryArithmeticOperation expr) {
  expr instanceof AddExpr and result instanceof Opcode::Add
  or
  expr instanceof SubExpr and result instanceof Opcode::Sub
  or
  expr instanceof MulExpr and result instanceof Opcode::Mul
  or
  expr instanceof DivExpr and result instanceof Opcode::Div
  or
  expr instanceof RemExpr and result instanceof Opcode::Rem
}

private Opcode comparisonOpcode(ComparisonOperation expr) {
  expr instanceof EQExpr and result instanceof Opcode::CompareEQ
  or
  expr instanceof NEExpr and result instanceof Opcode::CompareNE
  or
  expr instanceof LTExpr and result instanceof Opcode::CompareLT
  or
  expr instanceof GTExpr and result instanceof Opcode::CompareGT
  or
  expr instanceof LEExpr and result instanceof Opcode::CompareLE
  or
  expr instanceof GEExpr and result instanceof Opcode::CompareGE
}

/**
 * IR translation of a simple binary operation.
 */
class TranslatedBinaryOperation extends TranslatedSingleInstructionExpr {
  TranslatedBinaryOperation() {
    expr instanceof BinaryArithmeticOperation or
    expr instanceof BinaryBitwiseOperation or
    expr instanceof ComparisonOperation
  }

  override Instruction getFirstInstruction() {
    result = this.getLeftOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    if this.swapOperandsOnOp()
    then (
      operandTag instanceof RightOperandTag and
      result = this.getLeftOperand().getResult()
      or
      operandTag instanceof LeftOperandTag and
      result = this.getRightOperand().getResult()
    ) else (
      operandTag instanceof LeftOperandTag and
      result = this.getLeftOperand().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getRightOperand().getResult()
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getLeftOperand() and
    result = this.getRightOperand().getFirstInstruction()
    or
    child = this.getRightOperand() and
    result = this.getInstruction(OnlyInstructionTag())
  }

  override Opcode getOpcode() {
    result = binaryArithmeticOpcode(expr.(BinaryArithmeticOperation)) or
    result = binaryBitwiseOpcode(expr.(BinaryBitwiseOperation)) or
    result = comparisonOpcode(expr.(ComparisonOperation))
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    exists(Opcode opcode |
      opcode = getOpcode() and
      (
        opcode instanceof Opcode::PointerAdd or
        opcode instanceof Opcode::PointerSub or
        opcode instanceof Opcode::PointerDiff
      ) and
      result = Language::getTypeSize(this.getPointerOperand().getResultType())
    )
  }

  private TranslatedExpr getPointerOperand() {
    if swapOperandsOnOp() then result = this.getRightOperand() else result = this.getLeftOperand()
  }

  private predicate swapOperandsOnOp() {
    // Swap the operands on a pointer add 'i + p', so that the pointer operand
    // always comes first. Note that we still evaluate the operands
    // left-to-right.
    exists(AddExpr ptrAdd, Type rightType |
      ptrAdd = expr and
      rightType = ptrAdd.getRightOperand().getType() and
      rightType instanceof PointerType
    )
  }

  private TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(expr.(BinaryOperation).getLeftOperand())
  }

  private TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(expr.(BinaryOperation).getRightOperand())
  }
}

abstract class TranslatedAssignment extends TranslatedNonConstantExpr {
  override Assignment expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  final override Instruction getFirstInstruction() {
    // Evaluation is right-to-left
    result = this.getRightOperand().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    (
      this.needsConversion() and
      tag = AssignmentConvertRightTag() and
      // For now only use `Opcode::Convert` to
      // crudely represent conversions. Could
      // be useful to represent the whole chain of conversions
      opcode instanceof Opcode::Convert and
      resultType = getTypeForPRValue(expr.getLValue().getType())
    )
  }

  final override Instruction getResult() { result = this.getStoredValue() }

  abstract Instruction getStoredValue();

  final TranslatedExpr getLeftOperand() { result = getTranslatedExpr(expr.getLValue()) }

  final TranslatedExpr getRightOperand() { result = getTranslatedExpr(expr.getRValue()) }

  final predicate needsConversion() { expr.getLValue().getType() != expr.getRValue().getType() }
}

class TranslatedAssignExpr extends TranslatedAssignment {
  TranslatedAssignExpr() {
    expr instanceof AssignExpr and
    // if the lvalue is an accessor call, ignore assignment
    // since the assignment expr is desugared into a function call
    not expr.getLValue() instanceof AccessorCall
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = AssignmentStoreTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
    or
    this.needsConversion() and
    tag = AssignmentConvertRightTag() and
    result = this.getLeftOperand().getFirstInstruction() and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // Operands are evaluated right-to-left.
    (
      child = this.getRightOperand() and
      if this.needsConversion()
      then result = this.getInstruction(AssignmentConvertRightTag())
      else result = this.getLeftOperand().getFirstInstruction()
    )
    or
    child = this.getLeftOperand() and
    result = this.getInstruction(AssignmentStoreTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    TranslatedAssignment.super.hasInstruction(opcode, tag, resultType)
    or
    tag = AssignmentStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = AssignmentStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getLeftOperand().getResult()
      or
      (
        operandTag instanceof StoreValueOperandTag and
        if this.needsConversion()
        then result = this.getInstruction(AssignmentConvertRightTag())
        else result = this.getRightOperand().getResult()
      )
    )
    or
    tag = AssignmentConvertRightTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getRightOperand().getResult()
  }

  override Instruction getStoredValue() { result = this.getRightOperand().getResult() }
}

class TranslatedAssignOperation extends TranslatedAssignment {
  override AssignOperation expr;

  TranslatedAssignOperation() {
    // Assignments to events is handled differently
    not expr.getLValue() instanceof EventAccess
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = AssignOperationLoadTag() and
        if this.leftOperandNeedsConversion()
        then result = this.getInstruction(AssignOperationConvertLeftTag())
        else result = this.getInstruction(AssignOperationOpTag())
      )
      or
      tag = AssignOperationConvertLeftTag() and
      result = this.getInstruction(AssignOperationOpTag())
      or
      (
        tag = AssignOperationOpTag() and
        if this.leftOperandNeedsConversion()
        then result = this.getInstruction(AssignOperationConvertResultTag())
        else result = this.getInstruction(AssignmentStoreTag())
      )
      or
      tag = AssignOperationConvertResultTag() and
      result = this.getInstruction(AssignmentStoreTag())
      or
      tag = AssignmentStoreTag() and
      result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // Operands are evaluated right-to-left.
    child = this.getRightOperand() and
    result = this.getLeftOperand().getFirstInstruction()
    or
    child = this.getLeftOperand() and
    result = this.getInstruction(AssignOperationLoadTag())
  }

  override Instruction getStoredValue() {
    if this.leftOperandNeedsConversion()
    then result = this.getInstruction(AssignOperationConvertResultTag())
    else result = this.getInstruction(AssignOperationOpTag())
  }

  private Type getConvertedLeftOperandType() {
    if
      expr instanceof AssignLShiftExpr or
      expr instanceof AssignRShiftExpr
    then result = this.getLeftOperand().getResultType()
    else
      // The right operand has already been converted to the type of the op.
      result = this.getRightOperand().getResultType()
  }

  private predicate leftOperandNeedsConversion() {
    this.getConvertedLeftOperandType() != this.getLeftOperand().getResultType()
  }

  private Opcode getOpcode() {
    expr instanceof AssignAddExpr and
    (
      if expr.getRValue().getType() instanceof PointerType
      then result instanceof Opcode::PointerAdd
      else result instanceof Opcode::Add
    )
    or
    expr instanceof AssignSubExpr and
    (
      if expr.getRValue().getType() instanceof PointerType
      then result instanceof Opcode::PointerSub
      else result instanceof Opcode::Sub
    )
    or
    expr instanceof AssignMulExpr and result instanceof Opcode::Mul
    or
    expr instanceof AssignDivExpr and result instanceof Opcode::Div
    or
    expr instanceof AssignRemExpr and result instanceof Opcode::Rem
    or
    expr instanceof AssignAndExpr and result instanceof Opcode::BitAnd
    or
    expr instanceof AssignOrExpr and result instanceof Opcode::BitOr
    or
    expr instanceof AssignXorExpr and result instanceof Opcode::BitXor
    or
    expr instanceof AssignLShiftExpr and result instanceof Opcode::ShiftLeft
    or
    expr instanceof AssignRShiftExpr and result instanceof Opcode::ShiftRight
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = AssignOperationLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(this.getLeftOperand().getResultType())
    or
    tag = AssignOperationOpTag() and
    opcode = getOpcode() and
    resultType = getTypeForPRValue(this.getConvertedLeftOperandType())
    or
    tag = AssignmentStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType())
    or
    this.leftOperandNeedsConversion() and
    opcode instanceof Opcode::Convert and
    (
      tag = AssignOperationConvertLeftTag() and
      resultType = getTypeForPRValue(this.getConvertedLeftOperandType())
      or
      tag = AssignOperationConvertResultTag() and
      resultType = getTypeForPRValue(this.getLeftOperand().getResultType())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = AssignOperationOpTag() and
    exists(Opcode opcode |
      opcode = this.getOpcode() and
      (
        opcode instanceof Opcode::PointerAdd or
        opcode instanceof Opcode::PointerSub
      )
    ) and
    result = Language::getTypeSize(getResultType().(PointerType).getReferentType())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = AssignOperationLoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getLeftOperand().getResult()
    or
    this.leftOperandNeedsConversion() and
    tag = AssignOperationConvertLeftTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInstruction(AssignOperationLoadTag())
    or
    tag = AssignOperationOpTag() and
    (
      (
        operandTag instanceof LeftOperandTag and
        if this.leftOperandNeedsConversion()
        then result = this.getInstruction(AssignOperationConvertLeftTag())
        else result = this.getInstruction(AssignOperationLoadTag())
      )
      or
      operandTag instanceof RightOperandTag and
      result = this.getRightOperand().getResult()
    )
    or
    this.leftOperandNeedsConversion() and
    tag = AssignOperationConvertResultTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInstruction(AssignOperationOpTag())
    or
    tag = AssignmentStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getLeftOperand().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getStoredValue()
    )
  }
}

/**
 * Abstract class implemented by any `TranslatedElement` that has a child
 * expression that is a call to a constructor, in order to
 * provide a pointer to the object being constructed.
 */
abstract class ConstructorCallContext extends TranslatedElement {
  /**
   * Gets the instruction whose result value is the address of the object to be
   * constructed.
   */
  abstract Instruction getReceiver();
}

class TranslatedConditionalExpr extends TranslatedNonConstantExpr, ConditionContext {
  override ConditionalExpr expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getThen()
    or
    id = 2 and result = this.getElse()
  }

  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    not this.resultIsVoid() and
    (
      (
        not this.thenIsVoid() and tag = ConditionValueTrueTempAddressTag()
        or
        not this.elseIsVoid() and tag = ConditionValueFalseTempAddressTag()
        or
        tag = ConditionValueResultTempAddressTag()
      ) and
      opcode instanceof Opcode::VariableAddress and
      resultType = getTypeForGLValue(this.getResultType())
      or
      (
        not this.thenIsVoid() and tag = ConditionValueTrueStoreTag()
        or
        not this.elseIsVoid() and tag = ConditionValueFalseStoreTag()
      ) and
      opcode instanceof Opcode::Store and
      resultType = getTypeForPRValue(this.getResultType())
      or
      tag = ConditionValueResultLoadTag() and
      opcode instanceof Opcode::Load and
      resultType = this.getResultCSharpType()
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    not this.resultIsVoid() and
    kind instanceof GotoEdge and
    (
      not this.thenIsVoid() and
      (
        tag = ConditionValueTrueTempAddressTag() and
        result = this.getInstruction(ConditionValueTrueStoreTag())
        or
        tag = ConditionValueTrueStoreTag() and
        result = this.getInstruction(ConditionValueResultTempAddressTag())
      )
      or
      not this.elseIsVoid() and
      (
        tag = ConditionValueFalseTempAddressTag() and
        result = this.getInstruction(ConditionValueFalseStoreTag())
        or
        tag = ConditionValueFalseStoreTag() and
        result = this.getInstruction(ConditionValueResultTempAddressTag())
      )
      or
      tag = ConditionValueResultTempAddressTag() and
      result = this.getInstruction(ConditionValueResultLoadTag())
      or
      tag = ConditionValueResultLoadTag() and
      result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    not this.resultIsVoid() and
    (
      not this.thenIsVoid() and
      tag = ConditionValueTrueStoreTag() and
      (
        operandTag instanceof AddressOperandTag and
        result = this.getInstruction(ConditionValueTrueTempAddressTag())
        or
        operandTag instanceof StoreValueOperandTag and
        result = this.getThen().getResult()
      )
      or
      not this.elseIsVoid() and
      tag = ConditionValueFalseStoreTag() and
      (
        operandTag instanceof AddressOperandTag and
        result = this.getInstruction(ConditionValueFalseTempAddressTag())
        or
        operandTag instanceof StoreValueOperandTag and
        result = this.getElse().getResult()
      )
      or
      tag = ConditionValueResultLoadTag() and
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(ConditionValueResultTempAddressTag())
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    not this.resultIsVoid() and
    tag = ConditionValueTempVar() and
    type = getTypeForPRValue(this.getResultType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    not this.resultIsVoid() and
    (
      tag = ConditionValueTrueTempAddressTag() or
      tag = ConditionValueFalseTempAddressTag() or
      tag = ConditionValueResultTempAddressTag()
    ) and
    result = this.getTempVariable(ConditionValueTempVar())
  }

  override Instruction getResult() {
    not this.resultIsVoid() and
    result = this.getInstruction(ConditionValueResultLoadTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = this.getThen() and
      if this.thenIsVoid()
      then result = this.getParent().getChildSuccessor(this)
      else result = this.getInstruction(ConditionValueTrueTempAddressTag())
    )
    or
    (
      child = this.getElse() and
      if this.elseIsVoid()
      then result = this.getParent().getChildSuccessor(this)
      else result = this.getInstruction(ConditionValueFalseTempAddressTag())
    )
  }

  override Instruction getChildTrueSuccessor(ConditionBase child) {
    child = this.getCondition() and
    result = this.getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(ConditionBase child) {
    child = this.getCondition() and
    result = this.getElse().getFirstInstruction()
  }

  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(expr.getCondition())
  }

  private TranslatedExpr getThen() { result = getTranslatedExpr(expr.getThen()) }

  private TranslatedExpr getElse() { result = getTranslatedExpr(expr.getElse()) }

  private predicate thenIsVoid() {
    this.getThen().getResultType() instanceof VoidType
    or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    expr.getThen() instanceof ThrowExpr
  }

  private predicate elseIsVoid() {
    this.getElse().getResultType() instanceof VoidType
    or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    expr.getElse() instanceof ThrowExpr
  }

  private predicate resultIsVoid() { this.getResultType() instanceof VoidType }
}

/**
 * The IR translation of an `IsExpr`.
 */
// TODO: Once `TranslatedInitialization.qll` is refactored,
//       get rid of the initialization here.
// TODO: Refactor the generated instructions since it's pretty cluttered.
class TranslatedIsExpr extends TranslatedNonConstantExpr {
  override IsExpr expr;

  override Instruction getFirstInstruction() { result = this.getIsExpr().getFirstInstruction() }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getIsExpr()
    or
    id = 1 and result = this.getPatternVarDecl()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ConvertTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(GeneratedConstantTag())
    or
    this.hasVar() and
    tag = InitializerStoreTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
    or
    (
      tag = GeneratedNEQTag() and
      kind instanceof GotoEdge and
      if this.hasVar()
      then result = this.getInstruction(GeneratedBranchTag())
      else result = this.getParent().getChildSuccessor(this)
    )
    or
    // If a var is declared, we only do the initialization
    // if the `IsExpr` is evaluated to `true`.
    this.hasVar() and
    tag = GeneratedBranchTag() and
    (
      kind instanceof TrueEdge and
      result = this.getInstruction(InitializerStoreTag())
      or
      kind instanceof FalseEdge and
      result = this.getParent().getChildSuccessor(this)
    )
    or
    tag = GeneratedConstantTag() and
    kind instanceof GotoEdge and
    if this.hasVar()
    then result = this.getPatternVarDecl().getFirstInstruction()
    else result = this.getInstruction(GeneratedNEQTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getIsExpr() and
    result = this.getInstruction(ConvertTag())
    or
    this.hasVar() and
    child = this.getPatternVarDecl() and
    result = this.getInstruction(GeneratedNEQTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    this.hasVar() and
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getPattern().getType())
    or
    tag = ConvertTag() and
    opcode instanceof Opcode::CheckedConvertOrNull and
    resultType = getTypeForPRValue(expr.getPattern().getType())
    or
    tag = GeneratedNEQTag() and
    opcode instanceof Opcode::CompareNE and
    resultType = getTypeForPRValue(expr.getType())
    or
    tag = GeneratedConstantTag() and
    opcode instanceof Opcode::Constant and
    resultType = getTypeForPRValue(expr.getPattern().getType())
    or
    this.hasVar() and
    tag = GeneratedBranchTag() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = GeneratedConstantTag() and
    // Review: "0" or "null"?
    result = "0"
  }

  override Instruction getResult() { result = this.getInstruction(GeneratedNEQTag()) }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ConvertTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getIsExpr().getResult()
    or
    this.hasVar() and
    tag = InitializerStoreTag() and
    (
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(ConvertTag())
      or
      operandTag instanceof AddressOperandTag and
      result = this.getPatternVarDecl().getTargetAddress()
    )
    or
    tag = GeneratedNEQTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getInstruction(ConvertTag())
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(GeneratedConstantTag())
    )
    or
    hasVar() and
    tag = GeneratedBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getInstruction(GeneratedNEQTag())
  }

  private TranslatedExpr getIsExpr() { result = getTranslatedExpr(expr.getExpr()) }

  private predicate hasVar() { exists(this.getPatternVarDecl()) }

  private TranslatedLocalVariableDeclaration getPatternVarDecl() {
    result = getTranslatedLocalDeclaration(expr.getPattern())
  }
}

/**
 * The IR translation of a lambda expression. This initializes a temporary variable whose type is that of the lambda,
 * using the initializer list that represents the captures of the lambda.
 */
class TranslatedLambdaExpr extends TranslatedNonConstantExpr, InitializationContext {
  override LambdaExpr expr;

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getInitialization() }

  override Instruction getResult() { result = this.getInstruction(LoadTag()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = InitializerVariableAddressTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(InitializerStoreTag())
    or
    tag = InitializerStoreTag() and
    kind instanceof GotoEdge and
    (
      result = this.getInitialization().getFirstInstruction()
      or
      not this.hasInitializer() and result = this.getInstruction(LoadTag())
    )
    or
    tag = LoadTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and
    result = this.getInstruction(LoadTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(expr.getType())
    or
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Uninitialized and
    resultType = getTypeForPRValue(expr.getType())
    or
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(expr.getType())
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(InitializerVariableAddressTag())
    or
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag() or
      tag = InitializerStoreTag()
    ) and
    result = this.getTempVariable(LambdaTempVar())
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = LambdaTempVar() and
    type = getTypeForPRValue(this.getResultType())
  }

  final override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  final override Type getTargetType() { result = this.getResultType() }

  private predicate hasInitializer() { exists(this.getInitialization()) }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr.getChild(0))
  }
}

/**
 * The translation of a `DelegateCall`. Since this type of call needs
 * desugaring, we treat it as a special case. The AST node of the
 * call expression will be the parent to a compiler generated call.
 */
class TranslatedDelegateCall extends TranslatedNonConstantExpr {
  override DelegateCall expr;

  final override Instruction getFirstInstruction() {
    result = this.getInvokeCall().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getInvokeCall() }

  override Instruction getResult() { result = this.getInvokeCall().getResult() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getInvokeCall() and
    result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) { none() }

  private TranslatedCompilerGeneratedCall getInvokeCall() {
    result = DelegateElements::getInvoke(expr)
  }
}

/**
 * Represents the IR translation of creation expression. Can be the translation of an
 * `ObjectCreation` or a `DelegateCreation`.
 * The `NewObj` instruction denotes the fact that during initialization a new
 * object is allocated, which is then initialized by the constructor.
 */
abstract class TranslatedCreation extends TranslatedCoreExpr, TTranslatedCreationExpr,
  ConstructorCallContext {
  TranslatedCreation() { this = TTranslatedCreationExpr(expr) }

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getConstructorCall()
    or
    id = 1 and result = this.getInitializerExpr()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    // Instruction that allocated space for a new object,
    // and returns its address
    tag = NewObjTag() and
    opcode instanceof Opcode::NewObj and
    resultType = getTypeForPRValue(expr.getType())
    or
    this.needsLoad() and
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(expr.getType())
  }

  final override Instruction getFirstInstruction() { result = this.getInstruction(NewObjTag()) }

  override Instruction getResult() {
    if this.needsLoad()
    then result = this.getInstruction(LoadTag())
    else result = this.getInstruction(NewObjTag())
  }

  override Instruction getReceiver() { result = getInstruction(NewObjTag()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = NewObjTag() and
    result = this.getConstructorCall().getFirstInstruction()
    or
    this.needsLoad() and
    kind instanceof GotoEdge and
    tag = LoadTag() and
    result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    this.needsLoad() and
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(NewObjTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = this.getConstructorCall() and
      if exists(this.getInitializerExpr())
      then result = this.getInitializerExpr().getFirstInstruction()
      else result = getLoadOrChildSuccessor()
    )
    or
    child = this.getInitializerExpr() and
    result = getLoadOrChildSuccessor()
  }

  private Instruction getLoadOrChildSuccessor() {
    if this.needsLoad()
    then result = this.getInstruction(LoadTag())
    else result = this.getParent().getChildSuccessor(this)
  }

  abstract TranslatedElement getConstructorCall();

  abstract TranslatedExpr getInitializerExpr();

  /**
   * If the newly allocated object is a value type, then we need
   * to load the newly allocated object before storing it in the variable,
   * since `NewObj` returns an address.
   */
  abstract predicate needsLoad();
}

/**
 * Represents the IR translation of an `ObjectCreation`.
 */
class TranslatedObjectCreation extends TranslatedCreation {
  override ObjectCreation expr;

  override TranslatedExpr getInitializerExpr() { result = getTranslatedExpr(expr.getInitializer()) }

  override TranslatedConstructorCall getConstructorCall() {
    // Since calls are also expressions, we can't
    // use the predicate getTranslatedExpr (since that would
    // also return `this`).
    result.getAST() = this.getAST()
  }

  override predicate needsLoad() { expr.getObjectType().isValueType() }
}

/**
 * Represents the IR translation of a `DelegateCreation`.
 */
class TranslatedDelegateCreation extends TranslatedCreation {
  override DelegateCreation expr;

  override TranslatedExpr getInitializerExpr() { none() }

  override TranslatedElement getConstructorCall() {
    result = DelegateElements::getConstructor(expr)
  }

  override predicate needsLoad() { none() }
}

/**
 * Represents the IR translation of an assign operation where the lhs is an event access.
 */
class TranslatedEventAccess extends TranslatedNonConstantExpr {
  override AssignOperation expr;

  TranslatedEventAccess() { expr.getLValue() instanceof EventAccess }

  // We only translate the lhs, since the rhs is translated as part of the
  // accessor call.
  override TranslatedElement getChild(int id) { id = 0 and result = this.getLValue() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  final override Instruction getFirstInstruction() {
    result = this.getLValue().getFirstInstruction()
  }

  override Instruction getResult() { none() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getLValue() and
    result = this.getParent().getChildSuccessor(this)
  }

  private TranslatedExpr getLValue() { result = getTranslatedExpr(expr.getLValue()) }
}
