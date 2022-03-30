private import cpp
private import semmle.code.cpp.ir.implementation.IRType
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.IRUtilities
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclarationEntry
private import TranslatedElement
private import TranslatedFunction
private import TranslatedInitialization
private import TranslatedFunction
private import TranslatedStmt
import TranslatedCall

/**
 * Gets the TranslatedExpr for the specified expression. If `expr` is a load or synthesized
 * temporary object, the result is the TranslatedExpr for the load or synthetic temporary object
 * portion.
 */
TranslatedExpr getTranslatedExpr(Expr expr) {
  result.getExpr() = expr and
  result.producesExprResult()
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
abstract class TranslatedExpr extends TranslatedElement {
  Expr expr;

  /**
   * Gets the instruction that produces the result of the expression.
   */
  abstract Instruction getResult();

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

  final CppType getResultType() {
    if this.isResultGLValue()
    then result = getTypeForGLValue(expr.getType())
    else result = getTypeForPRValue(expr.getType())
  }

  /**
   * Holds if the result of this `TranslatedExpr` is a glvalue.
   */
  predicate isResultGLValue() {
    // This implementation is overridden in `TranslatedCoreExpr` to mark them as
    // glvalues if they have loads on them. It's also overridden in
    // `TranslatedLoad` to always mark loads as glvalues since a
    // `TranslatedLoad` may have been created as a result of
    // `needsLoadForParentExpr`. It's not overridden in `TranslatedResultCopy`
    // since result copies never have loads.
    expr.isGLValueCategory()
  }

  final override Locatable getAst() { result = expr }

  /** DEPRECATED: Alias for getAst */
  deprecated override Locatable getAST() { result = this.getAst() }

  final override Function getFunction() { result = expr.getEnclosingFunction() }

  /**
   * Gets the expression from which this `TranslatedExpr` is generated.
   */
  final Expr getExpr() { result = expr }

  /**
   * Gets the `TranslatedFunction` containing this expression.
   */
  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(expr.getEnclosingFunction())
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
   * Holds if the result of this `TranslatedExpr` is a glvalue.
   */
  override predicate isResultGLValue() {
    super.isResultGLValue()
    or
    // If this TranslatedExpr doesn't produce the result, then it must represent
    // a glvalue that is then loaded by a TranslatedLoad.
    hasTranslatedLoad(expr)
    or
    // The expression should be treated as a glvalue because its operand was forced to be a glvalue,
    // such as for the qualifier of a member access.
    isPRValueConversionOnGLValue(expr)
  }

  final override predicate producesExprResult() {
    // If there's no load or temp object, then this is the only TranslatedExpr for this
    // expression.
    not hasTranslatedLoad(expr) and
    not hasTranslatedSyntheticTemporaryObject(expr) and
    // If there's a result copy, then this expression's result is the copy.
    not exprNeedsCopyIfNotLoaded(expr)
  }
}

class TranslatedConditionValue extends TranslatedCoreExpr, ConditionContext,
  TTranslatedConditionValue {
  TranslatedConditionValue() { this = TTranslatedConditionValue(expr) }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getCondition() }

  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
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
    resultType = this.getResultType()
    or
    (
      tag = ConditionValueTrueStoreTag() or
      tag = ConditionValueFalseStoreTag()
    ) and
    opcode instanceof Opcode::Store and
    resultType = this.getResultType()
    or
    tag = ConditionValueResultLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = this.getResultType()
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

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
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
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(ConditionValueResultTempAddressTag())
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = ConditionValueTempVar() and
    type = getTypeForPRValue(expr.getType())
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

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = this.getCondition() and
    result = this.getInstruction(ConditionValueTrueTempAddressTag())
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = this.getCondition() and
    result = this.getInstruction(ConditionValueFalseTempAddressTag())
  }

  private TranslatedCondition getCondition() { result = getTranslatedCondition(expr) }
}

/**
 * The IR translation of a node synthesized to adjust the value category of its operand.
 * One of:
 * - `TranslatedLoad` - Convert from glvalue to prvalue by loading from the location.
 * - `TranslatedSyntheticTemporaryObject` - Convert from prvalue to glvalue by storing to a
 *   temporary variable.
 */
abstract class TranslatedValueCategoryAdjustment extends TranslatedExpr {
  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override predicate producesExprResult() {
    // A temp object always produces the result of the expression.
    any()
  }

  final TranslatedCoreExpr getOperand() { result.getExpr() = expr }
}

/**
 * IR translation of an implicit lvalue-to-rvalue conversion on the result of
 * an expression.
 */
class TranslatedLoad extends TranslatedValueCategoryAdjustment, TTranslatedLoad {
  TranslatedLoad() { this = TTranslatedLoad(expr) }

  override string toString() { result = "Load of " + expr.toString() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = this.getResultType()
  }

  override predicate isResultGLValue() { none() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = LoadTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(LoadTag())
  }

  override Instruction getResult() { result = this.getInstruction(LoadTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = LoadTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getOperand().getResult()
    )
  }
}

/**
 * The IR translation of a temporary object synthesized by the IR to hold a class prvalue on which
 * a member access is going to be performed. This differs from `TranslatedTemporaryObjectExpr` in
 * that instances of `TranslatedSyntheticTemporaryObject` are synthesized during IR construction,
 * whereas `TranslatedTemporaryObjectExpr` instances are created from `TemporaryObjectExpr` nodes
 * from the AST.
 */
class TranslatedSyntheticTemporaryObject extends TranslatedValueCategoryAdjustment,
  TTranslatedSyntheticTemporaryObject {
  TranslatedSyntheticTemporaryObject() { this = TTranslatedSyntheticTemporaryObject(expr) }

  override string toString() { result = "Temporary materialization of " + expr.toString() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(expr.getType())
    or
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType())
  }

  override predicate isResultGLValue() { any() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = InitializerVariableAddressTag() and
    result = this.getInstruction(InitializerStoreTag()) and
    kind instanceof GotoEdge
    or
    tag = InitializerStoreTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(InitializerVariableAddressTag())
  }

  override Instruction getResult() { result = this.getInstruction(InitializerVariableAddressTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(InitializerVariableAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getOperand().getResult()
    )
  }

  final override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = TempObjectTempVar() and
    type = getTypeForPRValue(expr.getType())
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRTempVariable(expr, TempObjectTempVar())
  }
}

/**
 * IR translation of an expression that simply returns its result. We generate an otherwise useless
 * `CopyValue` instruction for these expressions so that there is at least one instruction
 * associated with the expression.
 */
class TranslatedResultCopy extends TranslatedExpr, TTranslatedResultCopy {
  TranslatedResultCopy() { this = TTranslatedResultCopy(expr) }

  override string toString() { result = "Result of " + expr.toString() }

  override Instruction getFirstInstruction() { result = this.getOperand().getFirstInstruction() }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = ResultCopyTag() and
    opcode instanceof Opcode::CopyValue and
    resultType = this.getOperand().getResultType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ResultCopyTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(ResultCopyTag())
  }

  override Instruction getResult() { result = this.getInstruction(ResultCopyTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ResultCopyTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getOperand().getResult()
  }

  final override predicate producesExprResult() { any() }

  private TranslatedCoreExpr getOperand() { result.getExpr() = expr }
}

class TranslatedCommaExpr extends TranslatedNonConstantExpr {
  override CommaExpr expr;

  override Instruction getFirstInstruction() {
    result = this.getLeftOperand().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  override Instruction getResult() { result = this.getRightOperand().getResult() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getLeftOperand() and
    result = this.getRightOperand().getFirstInstruction()
    or
    child = this.getRightOperand() and result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  private TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(expr.getLeftOperand().getFullyConverted())
  }

  private TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(expr.getRightOperand().getFullyConverted())
  }
}

private int getElementSize(Type type) {
  result = max(type.getUnspecifiedType().(PointerType).getBaseType().getSize())
}

abstract class TranslatedCrementOperation extends TranslatedNonConstantExpr {
  override CrementOperation expr;

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getLoadedOperand() }

  final override string getInstructionConstantValue(InstructionTag tag) {
    tag = CrementConstantTag() and
    exists(Type resultType |
      resultType = expr.getUnspecifiedType() and
      (
        resultType instanceof IntegralOrEnumType and result = "1"
        or
        resultType instanceof FloatingPointType and result = "1.0"
        or
        resultType instanceof PointerType and result = "1"
      )
    )
  }

  private CppType getConstantType() {
    exists(Type resultType |
      resultType = expr.getUnspecifiedType() and
      (
        resultType instanceof ArithmeticType and
        result = getTypeForPRValue(expr.getType())
        or
        resultType instanceof PointerType and result = getIntType()
      )
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = CrementConstantTag() and
    opcode instanceof Opcode::Constant and
    resultType = this.getConstantType()
    or
    tag = CrementOpTag() and
    opcode = this.getOpcode() and
    resultType = getTypeForPRValue(expr.getType())
    or
    tag = CrementStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CrementOpTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getLoadedOperand().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(CrementConstantTag())
    )
    or
    tag = CrementStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getUnloadedOperand().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(CrementOpTag())
    )
  }

  final override Instruction getFirstInstruction() {
    result = this.getLoadedOperand().getFirstInstruction()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
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
    child = this.getLoadedOperand() and result = this.getInstruction(CrementConstantTag())
  }

  final override int getInstructionElementSize(InstructionTag tag) {
    tag = CrementOpTag() and
    (
      this.getOpcode() instanceof Opcode::PointerAdd or
      this.getOpcode() instanceof Opcode::PointerSub
    ) and
    result = getElementSize(expr.getType())
  }

  /**
   * Gets the `TranslatedLoad` on the `e` in this `e++`, which is the element
   * that holds the value to be cremented. It's guaranteed that there's a load
   * on `e` because of the `needsLoadForParentExpr` predicate.
   */
  final TranslatedLoad getLoadedOperand() {
    result = getTranslatedExpr(expr.getOperand().getFullyConverted())
  }

  /**
   * Gets the address to which the result of this crement will be stored.
   */
  final TranslatedExpr getUnloadedOperand() { result = this.getLoadedOperand().getOperand() }

  final Opcode getOpcode() {
    exists(Type resultType |
      resultType = expr.getUnspecifiedType() and
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
  override PrefixCrementOperation expr;

  override Instruction getResult() {
    if expr.isPRValueCategory()
    then
      // If this is C, then the result of a prefix crement is a prvalue for the
      // new value assigned to the operand. If this is C++, then the result is
      // an lvalue, but that lvalue is being loaded as part of this expression.
      // EDG doesn't mark this as a load.
      result = this.getInstruction(CrementOpTag())
    else
      // This is C++, where the result is an lvalue for the operand, and that
      // lvalue is not being loaded as part of this expression.
      result = this.getUnloadedOperand().getResult()
  }
}

class TranslatedPostfixCrementOperation extends TranslatedCrementOperation {
  override PostfixCrementOperation expr;

  override Instruction getResult() { result = this.getLoadedOperand().getResult() }
}

/**
 * IR translation of an array access expression (e.g. `a[i]`). The array being accessed will either
 * be a prvalue of pointer type (possibly due to an implicit array-to-pointer conversion), or a
 * glvalue of a GNU vector type.
 */
class TranslatedArrayExpr extends TranslatedNonConstantExpr {
  override ArrayExpr expr;

  final override Instruction getFirstInstruction() {
    result = this.getBaseOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getBaseOperand()
    or
    id = 1 and result = this.getOffsetOperand()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getBaseOperand() and
    result = this.getOffsetOperand().getFirstInstruction()
    or
    child = this.getOffsetOperand() and
    result = this.getInstruction(OnlyInstructionTag())
  }

  override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::PointerAdd and
    resultType = getTypeForGLValue(expr.getType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getBaseOperand().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getOffsetOperand().getResult()
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = max(expr.getUnspecifiedType().getSize())
  }

  private TranslatedExpr getBaseOperand() {
    result = getTranslatedExpr(expr.getArrayBase().getFullyConverted())
  }

  private TranslatedExpr getOffsetOperand() {
    result = getTranslatedExpr(expr.getArrayOffset().getFullyConverted())
  }
}

abstract class TranslatedTransparentExpr extends TranslatedNonConstantExpr {
  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getParent().getChildSuccessor(this)
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getResult() { result = this.getOperand().getResult() }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  abstract TranslatedExpr getOperand();
}

class TranslatedTransparentUnaryOperation extends TranslatedTransparentExpr {
  override UnaryOperation expr;

  TranslatedTransparentUnaryOperation() {
    (
      // *p is the same as p until the result is loaded.
      expr instanceof PointerDereferenceExpr or
      // &x is the same as x. &x isn't loadable, but is included
      // here to avoid having two nearly identical classes.
      expr instanceof AddressOfExpr or
      expr instanceof BuiltInOperationBuiltInAddressOf
    )
  }

  override TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.getOperand().getFullyConverted())
  }
}

class TranslatedTransparentConversion extends TranslatedTransparentExpr {
  override Conversion expr;

  TranslatedTransparentConversion() {
    (
      expr instanceof ParenthesisExpr or
      expr instanceof ReferenceDereferenceExpr or
      expr instanceof ReferenceToExpr
    )
  }

  override TranslatedExpr getOperand() { result = getTranslatedExpr(expr.getExpr()) }
}

class TranslatedThisExpr extends TranslatedNonConstantExpr {
  override ThisExpr expr;

  final override TranslatedElement getChild(int id) { none() }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = ThisAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(any(UnknownType t))
    or
    tag = ThisLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = this.getResultType()
  }

  final override Instruction getResult() { result = this.getInstruction(ThisLoadTag()) }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(ThisAddressTag())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = ThisAddressTag() and
    result = this.getInstruction(ThisLoadTag())
    or
    kind instanceof GotoEdge and
    tag = ThisLoadTag() and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ThisLoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(ThisAddressTag())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = ThisAddressTag() and
    result = this.getEnclosingFunction().getThisVariable()
  }
}

abstract class TranslatedVariableAccess extends TranslatedNonConstantExpr {
  override VariableAccess expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getQualifier() // Might not exist
  }

  final TranslatedExpr getQualifier() {
    result = getTranslatedExpr(expr.getQualifier().getFullyConverted())
  }

  override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getQualifier() and result = this.getInstruction(OnlyInstructionTag())
  }
}

class TranslatedNonFieldVariableAccess extends TranslatedVariableAccess {
  TranslatedNonFieldVariableAccess() {
    not expr instanceof FieldAccess and not isNonReferenceStructuredBinding(expr.getTarget())
  }

  override Instruction getFirstInstruction() {
    if exists(this.getQualifier())
    then result = this.getQualifier().getFirstInstruction()
    else result = this.getInstruction(OnlyInstructionTag())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(expr.getType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getIRUserVariable(expr.getEnclosingFunction(), expr.getTarget())
  }
}

class TranslatedFieldAccess extends TranslatedVariableAccess {
  override FieldAccess expr;

  override Instruction getFirstInstruction() { result = this.getQualifier().getFirstInstruction() }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getQualifier().getResult()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getTypeForGLValue(expr.getType())
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getTarget()
  }
}

/**
 * The IR translation of a variable access of a structured binding, where the type
 * of the structured binding is not of a reference type, e.g., `x0` and `x1`
 * in `auto [x0, x1] = xs` where `xs` is an array. Although the type of the
 * structured binding is a non-reference type, the structured binding behaves
 * like a reference. Hence, the translation requires a `VariableAddress` followed
 * by a `Load` instead of only a `VariableAddress` as produced by
 * `TranslatedVariableAccess`.
 */
class TranslatedStructuredBindingVariableAccess extends TranslatedNonConstantExpr {
  override VariableAccess expr;

  TranslatedStructuredBindingVariableAccess() { isNonReferenceStructuredBinding(expr.getTarget()) }

  override Instruction getFirstInstruction() {
    // Structured bindings cannot be qualified.
    result = this.getInstruction(StructuredBindingAccessTag())
  }

  override TranslatedElement getChild(int id) {
    // Structured bindings cannot be qualified.
    none()
  }

  override Instruction getResult() { result = this.getInstruction(LoadTag()) }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = StructuredBindingAccessTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(LoadTag())
    or
    tag = LoadTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = StructuredBindingAccessTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(this.getLValueReferenceType())
    or
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(this.getLValueReferenceType())
  }

  private LValueReferenceType getLValueReferenceType() {
    // The extractor ensures `result` exists when `isNonReferenceStructuredBinding(expr.getTarget())` holds.
    result.getBaseType() = expr.getUnspecifiedType()
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = LoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(StructuredBindingAccessTag())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = StructuredBindingAccessTag() and
    result = getIRUserVariable(expr.getEnclosingFunction(), expr.getTarget())
  }
}

class TranslatedFunctionAccess extends TranslatedNonConstantExpr {
  override FunctionAccess expr;

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = this.getInstruction(OnlyInstructionTag()) }

  override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FunctionAddress and
    resultType = this.getResultType()
  }

  override Function getInstructionFunction(InstructionTag tag) {
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

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode = this.getOpcode() and
    resultType = this.getResultType()
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

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    opcode = this.getOpcode() and
    tag = OnlyInstructionTag() and
    resultType = this.getResultType()
  }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }
}

class TranslatedUnaryExpr extends TranslatedSingleInstructionExpr {
  TranslatedUnaryExpr() {
    expr instanceof NotExpr or
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

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    result = this.getOperand().getResult() and
    operandTag instanceof UnaryOperandTag
  }

  final override Opcode getOpcode() {
    expr instanceof NotExpr and result instanceof Opcode::LogicalNot
    or
    expr instanceof ComplementExpr and result instanceof Opcode::BitComplement
    or
    expr instanceof UnaryPlusExpr and result instanceof Opcode::CopyValue
    or
    expr instanceof UnaryMinusExpr and result instanceof Opcode::Negate
  }

  private TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.(UnaryOperation).getOperand().getFullyConverted())
  }
}

abstract class TranslatedConversion extends TranslatedNonConstantExpr {
  override Conversion expr;

  override Instruction getFirstInstruction() { result = this.getOperand().getFirstInstruction() }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final TranslatedExpr getOperand() { result = getTranslatedExpr(expr.getExpr()) }
}

/**
 * Represents the translation of a conversion expression that generates a
 * single instruction.
 */
abstract class TranslatedSingleInstructionConversion extends TranslatedConversion {
  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode = this.getOpcode() and
    resultType = this.getResultType()
  }

  override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getOperand().getResult()
  }

  /**
   * Gets the opcode of the generated instruction.
   */
  abstract Opcode getOpcode();
}

/**
 * Represents the translation of a conversion expression that generates a
 * `Convert` instruction.
 */
class TranslatedSimpleConversion extends TranslatedSingleInstructionConversion {
  TranslatedSimpleConversion() {
    expr instanceof ArithmeticConversion or
    expr instanceof PointerConversion or
    expr instanceof PointerToMemberConversion or
    expr instanceof PointerToIntegralConversion or
    expr instanceof IntegralToPointerConversion or
    expr instanceof GlvalueConversion or
    expr instanceof ArrayToPointerConversion or
    expr instanceof PrvalueAdjustmentConversion or
    expr instanceof VoidConversion
  }

  override Opcode getOpcode() { result instanceof Opcode::Convert }
}

/**
 * Represents the translation of a dynamic_cast expression.
 */
class TranslatedDynamicCast extends TranslatedSingleInstructionConversion {
  TranslatedDynamicCast() { expr instanceof DynamicCast }

  override Opcode getOpcode() {
    exists(Type resultType |
      resultType = expr.getUnspecifiedType() and
      if resultType instanceof PointerType
      then
        if resultType.(PointerType).getBaseType() instanceof VoidType
        then result instanceof Opcode::CompleteObjectAddress
        else result instanceof Opcode::CheckedConvertOrNull
      else result instanceof Opcode::CheckedConvertOrThrow
    )
  }
}

/**
 * Represents the translation of a `BaseClassConversion` or `DerivedClassConversion`
 * expression.
 */
class TranslatedInheritanceConversion extends TranslatedSingleInstructionConversion {
  override InheritanceConversion expr;

  override predicate getInstructionInheritance(
    InstructionTag tag, Class baseClass, Class derivedClass
  ) {
    tag = OnlyInstructionTag() and
    baseClass = expr.getBaseClass() and
    derivedClass = expr.getDerivedClass()
  }

  override Opcode getOpcode() {
    if expr instanceof BaseClassConversion
    then
      if expr.(BaseClassConversion).isVirtual()
      then result instanceof Opcode::ConvertToVirtualBase
      else result instanceof Opcode::ConvertToNonVirtualBase
    else result instanceof Opcode::ConvertToDerived
  }
}

/**
 * Represents the translation of a `BoolConversion` expression, which generates
 * a comparison with zero.
 */
class TranslatedBoolConversion extends TranslatedConversion {
  override BoolConversion expr;

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = BoolConversionConstantTag() and
      result = this.getInstruction(BoolConversionCompareTag())
      or
      tag = BoolConversionCompareTag() and
      result = this.getParent().getChildSuccessor(this)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getOperand() and result = this.getInstruction(BoolConversionConstantTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = BoolConversionConstantTag() and
    opcode instanceof Opcode::Constant and
    resultType = this.getOperand().getResultType()
    or
    tag = BoolConversionCompareTag() and
    opcode instanceof Opcode::CompareNE and
    resultType = getBoolType()
  }

  override Instruction getResult() { result = this.getInstruction(BoolConversionCompareTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = BoolConversionCompareTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getOperand().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(BoolConversionConstantTag())
    )
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = BoolConversionConstantTag() and
    result = "0"
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
  (
    expr instanceof AddExpr
    or
    expr instanceof ImaginaryRealAddExpr
    or
    expr instanceof RealImaginaryAddExpr
  ) and
  result instanceof Opcode::Add
  or
  (
    expr instanceof SubExpr
    or
    expr instanceof ImaginaryRealSubExpr
    or
    expr instanceof RealImaginarySubExpr
  ) and
  result instanceof Opcode::Sub
  or
  (
    expr instanceof MulExpr
    or
    expr instanceof ImaginaryMulExpr
  ) and
  result instanceof Opcode::Mul
  or
  (
    expr instanceof DivExpr or
    expr instanceof ImaginaryDivExpr
  ) and
  result instanceof Opcode::Div
  or
  expr instanceof RemExpr and result instanceof Opcode::Rem
  or
  expr instanceof PointerAddExpr and result instanceof Opcode::PointerAdd
  or
  expr instanceof PointerSubExpr and result instanceof Opcode::PointerSub
  or
  expr instanceof PointerDiffExpr and result instanceof Opcode::PointerDiff
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

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
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
    result = binaryArithmeticOpcode(expr) or
    result = binaryBitwiseOpcode(expr) or
    result = comparisonOpcode(expr)
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    exists(Opcode opcode |
      opcode = this.getOpcode() and
      (
        opcode instanceof Opcode::PointerAdd or
        opcode instanceof Opcode::PointerSub or
        opcode instanceof Opcode::PointerDiff
      ) and
      result = getElementSize(this.getPointerOperand().getExpr().getType())
    )
  }

  private TranslatedExpr getPointerOperand() {
    if this.swapOperandsOnOp()
    then result = this.getRightOperand()
    else result = this.getLeftOperand()
  }

  private predicate swapOperandsOnOp() {
    // Swap the operands on a pointer add 'i + p', so that the pointer operand
    // always comes first. Note that we still evaluate the operands
    // left-to-right.
    exists(PointerAddExpr ptrAdd, Type rightType |
      ptrAdd = expr and
      rightType = ptrAdd.getRightOperand().getUnspecifiedType() and
      rightType instanceof PointerType
    )
  }

  private TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(expr.(BinaryOperation).getLeftOperand().getFullyConverted())
  }

  private TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(expr.(BinaryOperation).getRightOperand().getFullyConverted())
  }
}

class TranslatedAssignExpr extends TranslatedNonConstantExpr {
  override AssignExpr expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  final override Instruction getFirstInstruction() {
    // Evaluation is right-to-left
    result = this.getRightOperand().getFirstInstruction()
  }

  final override Instruction getResult() {
    if expr.isPRValueCategory()
    then
      // If this is C, then the result of an assignment is a prvalue for the new
      // value assigned to the left operand. If this is C++, then the result is
      // an lvalue, but that lvalue is being loaded as part of this expression.
      // EDG doesn't mark this as a load.
      result = this.getRightOperand().getResult()
    else
      // This is C++, where the result is an lvalue for the left operand,
      // and that lvalue is not being loaded as part of this expression.
      result = this.getLeftOperand().getResult()
  }

  abstract Instruction getStoredValue();

  final TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(expr.getLValue().getFullyConverted())
  }

  final TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(expr.getRValue().getFullyConverted())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = AssignmentStoreTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // Operands are evaluated right-to-left.
    child = this.getRightOperand() and
    result = this.getLeftOperand().getFirstInstruction()
    or
    child = this.getLeftOperand() and
    result = this.getInstruction(AssignmentStoreTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = AssignmentStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType()) // Always a prvalue
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = AssignmentStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getLeftOperand().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getRightOperand().getResult()
    )
  }
}

class TranslatedAssignOperation extends TranslatedNonConstantExpr {
  override AssignOperation expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLoadedLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  final override Instruction getFirstInstruction() {
    // Evaluation is right-to-left
    result = this.getRightOperand().getFirstInstruction()
  }

  final override Instruction getResult() {
    if expr.isPRValueCategory()
    then
      // If this is C, then the result of an assignment is a prvalue for the new
      // value assigned to the left operand. If this is C++, then the result is
      // an lvalue, but that lvalue is being loaded as part of this expression.
      // EDG doesn't mark this as a load.
      result = this.getStoredValue()
    else
      // This is C++, where the result is an lvalue for the left operand,
      // and that lvalue is not being loaded as part of this expression.
      result = this.getUnloadedLeftOperand().getResult()
  }

  final TranslatedExpr getUnloadedLeftOperand() {
    result = this.getLoadedLeftOperand().getOperand()
  }

  /**
   * Gets the `TranslatedLoad` on the `e` in this `e += ...` which is the
   * element that holds the value to be cremented. It's guaranteed that there's
   * a load on `e` because of the `needsLoadForParentExpr` predicate.
   */
  final TranslatedLoad getLoadedLeftOperand() {
    result = getTranslatedExpr(expr.getLValue().getFullyConverted())
  }

  /**
   * Gets the address to which the result of this operation will be stored.
   */
  final TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(expr.getRValue().getFullyConverted())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
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
    result = this.getLoadedLeftOperand().getFirstInstruction()
    or
    child = this.getLoadedLeftOperand() and
    if this.leftOperandNeedsConversion()
    then result = this.getInstruction(AssignOperationConvertLeftTag())
    else result = this.getInstruction(AssignOperationOpTag())
  }

  private Instruction getStoredValue() {
    if this.leftOperandNeedsConversion()
    then result = this.getInstruction(AssignOperationConvertResultTag())
    else result = this.getInstruction(AssignOperationOpTag())
  }

  private Type getConvertedLeftOperandType() {
    if
      expr instanceof AssignLShiftExpr or
      expr instanceof AssignRShiftExpr or
      expr instanceof AssignPointerAddExpr or
      expr instanceof AssignPointerSubExpr
    then
      // No need to convert for a shift. Technically, the left side should
      // undergo integral promotion, and then the result would be converted back
      // to the destination type. There's not much point to this, though,
      // because the result will be the same for any well-defined program
      // anyway. If we really want to model this case perfectly, we'll need the
      // extractor to tell us what the promoted type of the left operand would
      // be.
      result = this.getLoadedLeftOperand().getExpr().getType()
    else
      // The right operand has already been converted to the type of the op.
      result = this.getRightOperand().getExpr().getType()
  }

  private predicate leftOperandNeedsConversion() {
    this.getConvertedLeftOperandType().getUnspecifiedType() !=
      this.getLoadedLeftOperand().getExpr().getUnspecifiedType()
  }

  private Opcode getOpcode() {
    expr instanceof AssignAddExpr and result instanceof Opcode::Add
    or
    expr instanceof AssignSubExpr and result instanceof Opcode::Sub
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
    or
    expr instanceof AssignPointerAddExpr and result instanceof Opcode::PointerAdd
    or
    expr instanceof AssignPointerSubExpr and result instanceof Opcode::PointerSub
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = AssignOperationOpTag() and
    opcode = this.getOpcode() and
    resultType = getTypeForPRValue(this.getConvertedLeftOperandType())
    or
    tag = AssignmentStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(expr.getType()) // Always a prvalue
    or
    this.leftOperandNeedsConversion() and
    opcode instanceof Opcode::Convert and
    (
      tag = AssignOperationConvertLeftTag() and
      resultType = getTypeForPRValue(this.getConvertedLeftOperandType())
      or
      tag = AssignOperationConvertResultTag() and
      resultType = getTypeForPRValue(this.getLoadedLeftOperand().getExpr().getType())
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = AssignOperationOpTag() and
    exists(Opcode opcode |
      opcode = this.getOpcode() and
      (opcode instanceof Opcode::PointerAdd or opcode instanceof Opcode::PointerSub)
    ) and
    result = getElementSize(expr.getType())
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    this.leftOperandNeedsConversion() and
    tag = AssignOperationConvertLeftTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getLoadedLeftOperand().getResult()
    or
    tag = AssignOperationOpTag() and
    (
      (
        operandTag instanceof LeftOperandTag and
        if this.leftOperandNeedsConversion()
        then result = this.getInstruction(AssignOperationConvertLeftTag())
        else result = this.getLoadedLeftOperand().getResult()
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
      result = this.getUnloadedLeftOperand().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getStoredValue()
    )
  }
}

/**
 * The IR translation of the allocation size argument passed to `operator new`
 * in a `new` expression.
 *
 * We have to synthesize this because not all `NewExpr` nodes have an allocator
 * call, and even the ones that do pass an `ErrorExpr` as the argument.
 */
abstract class TranslatedAllocationSize extends TranslatedExpr, TTranslatedAllocationSize {
  override NewOrNewArrayExpr expr;

  TranslatedAllocationSize() { this = TTranslatedAllocationSize(expr) }

  final override string toString() { result = "Allocation size for " + expr.toString() }

  final override predicate producesExprResult() { none() }

  final override Instruction getResult() { result = this.getInstruction(AllocationSizeTag()) }
}

TranslatedAllocationSize getTranslatedAllocationSize(NewOrNewArrayExpr newExpr) {
  result.getAst() = newExpr
}

/**
 * The IR translation of a constant allocation size.
 *
 * The allocation size for a `new` expression is always a constant. The
 * allocation size for a `new[]` expression is a constant if the array extent
 * is a compile-time constant.
 */
class TranslatedConstantAllocationSize extends TranslatedAllocationSize {
  TranslatedConstantAllocationSize() { not exists(expr.(NewArrayExpr).getExtent()) }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(AllocationSizeTag())
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = AllocationSizeTag() and
    opcode instanceof Opcode::Constant and
    resultType = getTypeForPRValue(expr.getAllocator().getParameter(0).getType())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = AllocationSizeTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  final override TranslatedElement getChild(int id) { none() }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override string getInstructionConstantValue(InstructionTag tag) {
    tag = AllocationSizeTag() and
    result = expr.getAllocatedType().getSize().toString()
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
  override NewArrayExpr expr;

  TranslatedNonConstantAllocationSize() { exists(expr.getExtent()) }

  final override Instruction getFirstInstruction() {
    result = this.getExtent().getFirstInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    resultType = getTypeForPRValue(expr.getAllocator().getParameter(0).getType()) and
    (
      // Convert the extent to `size_t`, because the AST doesn't do this already.
      tag = AllocationExtentConvertTag() and opcode instanceof Opcode::Convert
      or
      tag = AllocationElementSizeTag() and opcode instanceof Opcode::Constant
      or
      tag = AllocationSizeTag() and opcode instanceof Opcode::Mul // REVIEW: Overflow?
    )
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = AllocationExtentConvertTag() and
      result = this.getInstruction(AllocationElementSizeTag())
      or
      tag = AllocationElementSizeTag() and
      result = this.getInstruction(AllocationSizeTag())
      or
      tag = AllocationSizeTag() and
      result = this.getParent().getChildSuccessor(this)
    )
  }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getExtent() }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getExtent() and
    result = this.getInstruction(AllocationExtentConvertTag())
  }

  final override string getInstructionConstantValue(InstructionTag tag) {
    tag = AllocationElementSizeTag() and
    result = expr.getAllocatedElementType().getSize().toString()
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = AllocationSizeTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getInstruction(AllocationExtentConvertTag())
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(AllocationElementSizeTag())
    )
    or
    tag = AllocationExtentConvertTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getExtent().getResult()
  }

  private TranslatedExpr getExtent() {
    result = getTranslatedExpr(expr.getExtent().getFullyConverted())
  }
}

/**
 * The IR translation of a call to `operator new` as part of a `new` or `new[]`
 * expression.
 */
class TranslatedAllocatorCall extends TTranslatedAllocatorCall, TranslatedDirectCall {
  override NewOrNewArrayExpr expr;

  TranslatedAllocatorCall() { this = TTranslatedAllocatorCall(expr) }

  final override string toString() { result = "Allocator call for " + expr.toString() }

  final override predicate producesExprResult() { none() }

  override Function getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and result = expr.getAllocator()
  }

  final override Type getCallResultType() { result = expr.getAllocator().getType() }

  final override TranslatedExpr getQualifier() { none() }

  final override predicate hasArguments() {
    // All allocator calls have at least one argument.
    any()
  }

  final override int getNumberOfArguments() {
    result = expr.getAllocatorCall().getNumberOfArguments()
    or
    // Make sure there's a result even when there is no allocator, as otherwise
    // TranslatedCall::getChild() will not return the side effects for this call.
    not exists(expr.getAllocatorCall()) and
    result = 0
  }

  final override TranslatedExpr getArgument(int index) {
    // If the allocator is the default operator new(void*), there will be no
    // allocator call in the AST. Otherwise, there will be an allocator call
    // that includes all arguments to the allocator, including the size,
    // alignment (if any), and placement args. However, the size argument is
    // an error node, so we need to provide the correct size argument in any
    // case.
    if index = 0
    then result = getTranslatedAllocationSize(expr)
    else
      if index = 1 and expr.hasAlignedAllocation()
      then result = getTranslatedExpr(expr.getAlignmentArgument())
      else
        result = getTranslatedExpr(expr.getAllocatorCall().getArgument(index).getFullyConverted())
  }
}

TranslatedAllocatorCall getTranslatedAllocatorCall(NewOrNewArrayExpr newExpr) {
  result.getAst() = newExpr
}

/**
 * Abstract class implemented by any `TranslatedElement` that has a child
 * expression that is a call to a constructor or destructor, in order to
 * provide a pointer to the object being constructed or destroyed.
 */
abstract class StructorCallContext extends TranslatedElement {
  /**
   * Gets the instruction whose result value is the address of the object to be
   * constructed or destroyed.
   */
  abstract Instruction getReceiver();
}

/**
 * Represents the IR translation of the destruction of a field from within
 * the destructor of the field's declaring class.
 */
class TranslatedDestructorFieldDestruction extends TranslatedNonConstantExpr, StructorCallContext {
  override DestructorFieldDestruction expr;

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getDestructorCall() }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getTypeForGLValue(expr.getTarget().getType())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = this.getDestructorCall().getFirstInstruction()
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getDestructorCall() and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getResult() { none() }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedFunction(expr.getEnclosingFunction()).getInitializeThisInstruction()
  }

  final override Field getInstructionField(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getTarget()
  }

  final override Instruction getReceiver() { result = this.getInstruction(OnlyInstructionTag()) }

  private TranslatedExpr getDestructorCall() { result = getTranslatedExpr(expr.getExpr()) }
}

/**
 * The IR translation of the `?:` operator. This class has the portions of the implementation that
 * are shared between the standard three-operand form (`a ? b : c`) and the GCC-extension
 * two-operand form (`a ?: c`).
 */
abstract class TranslatedConditionalExpr extends TranslatedNonConstantExpr {
  override ConditionalExpr expr;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    // Note that the ternary flavor needs no explicit `ConditionalBranch` instruction here, because
    // the condition is a `TranslatedCondition`, which will simply connect the successor edges of
    // the condition directly to the appropriate then/else block via
    // `getChild[True|False]Successor()`.
    // The binary flavor will override this predicate to add the `ConditionalBranch`.
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
      (
        if expr.isGLValueCategory()
        then resultType = getTypeForGLValue(any(UnknownType t)) // glvalue to a glvalue
        else resultType = getTypeForGLValue(expr.getType()) // glvalue to the result type
      )
      or
      (
        not this.thenIsVoid() and tag = ConditionValueTrueStoreTag()
        or
        not this.elseIsVoid() and tag = ConditionValueFalseStoreTag()
      ) and
      opcode instanceof Opcode::Store and
      resultType = this.getResultType()
      or
      tag = ConditionValueResultLoadTag() and
      opcode instanceof Opcode::Load and
      resultType = this.getResultType()
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

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
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
      (
        operandTag instanceof AddressOperandTag and
        result = this.getInstruction(ConditionValueResultTempAddressTag())
      )
    )
  }

  final override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    not this.resultIsVoid() and
    tag = ConditionValueTempVar() and
    type = this.getResultType()
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    not this.resultIsVoid() and
    (
      tag = ConditionValueTrueTempAddressTag() or
      tag = ConditionValueFalseTempAddressTag() or
      tag = ConditionValueResultTempAddressTag()
    ) and
    result = this.getTempVariable(ConditionValueTempVar())
  }

  final override Instruction getResult() {
    not this.resultIsVoid() and
    result = this.getInstruction(ConditionValueResultLoadTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getElse() and
    if this.elseIsVoid()
    then result = this.getParent().getChildSuccessor(this)
    else result = this.getInstruction(ConditionValueFalseTempAddressTag())
  }

  /**
   * Gets the `TranslatedExpr` for the "then" result. Note that nothing in the base implementation
   * of this class assumes that `getThen()` is disjoint from `getCondition()`.
   */
  abstract TranslatedExpr getThen();

  /**
   * Gets the `TranslatedExpr` for the "else" result.
   */
  final TranslatedExpr getElse() { result = getTranslatedExpr(expr.getElse().getFullyConverted()) }

  final predicate thenIsVoid() {
    this.getThen().getResultType().getIRType() instanceof IRVoidType
    or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    expr.getThen() instanceof ThrowExpr
  }

  private predicate elseIsVoid() {
    this.getElse().getResultType().getIRType() instanceof IRVoidType
    or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    expr.getElse() instanceof ThrowExpr
  }

  private predicate resultIsVoid() { this.getResultType().getIRType() instanceof IRVoidType }
}

/**
 * The IR translation of the ternary conditional operator (`a ? b : c`).
 * For this version, we expand the condition as a `TranslatedCondition`, rather than a
 * `TranslatedExpr`, to simplify the control flow in the presence of short-ciruit logical operators.
 */
class TranslatedTernaryConditionalExpr extends TranslatedConditionalExpr, ConditionContext {
  TranslatedTernaryConditionalExpr() { not expr.isTwoOperand() }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getThen()
    or
    id = 2 and result = this.getElse()
  }

  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    result = TranslatedConditionalExpr.super.getChildSuccessor(child)
    or
    (
      child = this.getThen() and
      if this.thenIsVoid()
      then result = this.getParent().getChildSuccessor(this)
      else result = this.getInstruction(ConditionValueTrueTempAddressTag())
    )
  }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = this.getCondition() and
    result = this.getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = this.getCondition() and
    result = this.getElse().getFirstInstruction()
  }

  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(expr.getCondition().getFullyConverted())
  }

  final override TranslatedExpr getThen() {
    result = getTranslatedExpr(expr.getThen().getFullyConverted())
  }
}

/**
 * The IR translation of a two-operand conditional operator (`a ?: b`). This is a GCC language
 * extension.
 * This version of the conditional expression returns its first operand (the condition) if that
 * condition is non-zero. Since we'll be reusing the value of the condition, we'll compute that
 * value directly before branching, even if that value was a short-circuit logical expression.
 */
class TranslatedBinaryConditionalExpr extends TranslatedConditionalExpr {
  TranslatedBinaryConditionalExpr() { expr.isTwoOperand() }

  final override TranslatedElement getChild(int id) {
    // We only truly have two children, because our "condition" and "then" are the same as far as
    // the extractor is concerned.
    id = 0 and result = this.getCondition()
    or
    id = 1 and result = this.getElse()
  }

  override Instruction getFirstInstruction() { result = this.getCondition().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    super.hasInstruction(opcode, tag, resultType)
    or
    // For the binary variant, we create our own conditional branch.
    tag = ValueConditionConditionalBranchTag() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = super.getInstructionSuccessor(tag, kind)
    or
    tag = ValueConditionConditionalBranchTag() and
    (
      kind instanceof TrueEdge and
      result = this.getInstruction(ConditionValueTrueTempAddressTag())
      or
      kind instanceof FalseEdge and
      result = this.getElse().getFirstInstruction()
    )
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    result = super.getInstructionRegisterOperand(tag, operandTag)
    or
    tag = ValueConditionConditionalBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getCondition().getResult()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    result = super.getChildSuccessor(child)
    or
    child = this.getCondition() and
    result = this.getInstruction(ValueConditionConditionalBranchTag())
  }

  private TranslatedExpr getCondition() {
    result = getTranslatedExpr(expr.getCondition().getFullyConverted())
  }

  final override TranslatedExpr getThen() {
    // The extractor returns the exact same expression for `ConditionalExpr::getCondition()` and
    // `ConditionalExpr::getThen()`, even though the condition may have been converted to `bool`,
    // and the "then" may have been converted to the result type. We'll strip the top-level implicit
    // conversions from this, to skip any conversion to `bool`. We don't have enough information to
    // know how to convert the result to the destination type, especially in the class pointer case,
    // so we'll still sometimes wind up with one operand as the wrong type. This is better than
    // always converting the "then" operand to `bool`, which is almost always the wrong type.
    result = getTranslatedExpr(expr.getThen().getExplicitlyConverted())
  }
}

/**
 * IR translation of the materialization of a temporary object.
 *
 * This translation allocates a temporary variable, and initializes it treating `expr.getExpr()` as
 * its initializer.
 */
class TranslatedTemporaryObjectExpr extends TranslatedNonConstantExpr,
  TranslatedVariableInitialization {
  override TemporaryObjectExpr expr;

  final override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = TempObjectTempVar() and
    type = getTypeForPRValue(expr.getType())
  }

  override Type getTargetType() { result = expr.getType() }

  final override TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr.getExpr())
  }

  final override IRVariable getIRVariable() {
    result = getIRTempVariable(expr, TempObjectTempVar())
  }

  final override Instruction getInitializationSuccessor() {
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getResult() { result = this.getTargetAddress() }
}

/**
 * IR translation of a `throw` expression.
 */
abstract class TranslatedThrowExpr extends TranslatedNonConstantExpr {
  override ThrowExpr expr;

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = ThrowTag() and
    opcode = this.getThrowOpcode() and
    resultType = getVoidType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ThrowTag() and
    kind instanceof ExceptionEdge and
    result = this.getParent().getExceptionSuccessorInstruction()
  }

  override Instruction getResult() { none() }

  abstract Opcode getThrowOpcode();
}

/**
 * IR translation of a `throw` expression with an argument
 * (e.g. `throw std::bad_alloc()`).
 */
class TranslatedThrowValueExpr extends TranslatedThrowExpr, TranslatedVariableInitialization {
  TranslatedThrowValueExpr() { not expr instanceof ReThrowExpr }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    TranslatedThrowExpr.super.hasInstruction(opcode, tag, resultType)
    or
    TranslatedVariableInitialization.super.hasInstruction(opcode, tag, resultType)
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedThrowExpr.super.getInstructionSuccessor(tag, kind)
    or
    result = TranslatedVariableInitialization.super.getInstructionSuccessor(tag, kind)
  }

  final override Instruction getInitializationSuccessor() {
    result = this.getInstruction(ThrowTag())
  }

  final override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = ThrowTempVar() and
    type = getTypeForPRValue(this.getExceptionType())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    result = TranslatedVariableInitialization.super.getInstructionRegisterOperand(tag, operandTag)
    or
    tag = ThrowTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(InitializerVariableAddressTag())
    )
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
    tag = ThrowTag() and
    operandTag instanceof LoadOperandTag and
    result = getTypeForPRValue(this.getExceptionType())
  }

  override Type getTargetType() { result = this.getExceptionType() }

  final override TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr.getExpr().getFullyConverted())
  }

  final override IRVariable getIRVariable() { result = getIRTempVariable(expr, ThrowTempVar()) }

  final override Opcode getThrowOpcode() { result instanceof Opcode::ThrowValue }

  private Type getExceptionType() { result = expr.getType() }
}

/**
 * IR translation of a `throw` expression with no argument (e.g. `throw;`).
 */
class TranslatedReThrowExpr extends TranslatedThrowExpr {
  override ReThrowExpr expr;

  override TranslatedElement getChild(int id) { none() }

  override Instruction getFirstInstruction() { result = this.getInstruction(ThrowTag()) }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override Opcode getThrowOpcode() { result instanceof Opcode::ReThrow }
}

/**
 * The IR translation of a built-in operation (i.e. anything that extends
 * `BuiltInOperation`).
 */
class TranslatedBuiltInOperation extends TranslatedNonConstantExpr {
  override BuiltInOperation expr;

  TranslatedBuiltInOperation() {
    // The following expressions are handled specially.
    not expr instanceof BuiltInOperationBuiltInAddressOf and
    not expr instanceof BuiltInVarArgsStart and
    not expr instanceof BuiltInVarArg and
    not expr instanceof BuiltInVarArgsEnd and
    not expr instanceof BuiltInVarArgCopy
  }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getFirstInstruction() {
    if exists(this.getChild(0))
    then result = this.getChild(0).getFirstInstruction()
    else result = this.getInstruction(OnlyInstructionTag())
  }

  final override TranslatedElement getChild(int id) {
    result = getTranslatedExpr(expr.getChild(id).getFullyConverted())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = this.getChild(id) and
      (
        result = this.getChild(id + 1).getFirstInstruction()
        or
        not exists(this.getChild(id + 1)) and result = this.getInstruction(OnlyInstructionTag())
      )
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode = this.getOpcode() and
    resultType = this.getResultType()
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    exists(int index |
      operandTag = positionalArgumentOperand(index) and
      result = this.getChild(index).(TranslatedExpr).getResult()
    )
  }

  Opcode getOpcode() { result instanceof Opcode::BuiltIn }

  final override BuiltInOperation getInstructionBuiltInOperation(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr
  }
}

/**
 * Holds if the expression `expr` is one of the `va_list` operands to a `va_*` macro.
 */
private predicate isVAListExpr(Expr expr) {
  exists(VarArgsExpr parent, Expr originalExpr |
    (
      originalExpr = parent.(BuiltInVarArgsStart).getVAList()
      or
      originalExpr = parent.(BuiltInVarArgsEnd).getVAList()
      or
      originalExpr = parent.(BuiltInVarArg).getVAList()
      or
      originalExpr = parent.(BuiltInVarArgCopy).getSourceVAList()
      or
      originalExpr = parent.(BuiltInVarArgCopy).getDestinationVAList()
    ) and
    expr = originalExpr.getFullyConverted()
  )
}

/**
 * Gets the type of the `va_list` being accessed by `expr`, where `expr` is a `va_list` operand of a
 * `va_*` macro.
 *
 * In the Unix ABI, `va_list` is declared as `typedef struct __va_list_tag va_list[1];`. When used
 * as the type of a local variable, this gets an implicit array-to-pointer conversion, so that the
 * actual argument to the `va_*` macro is a prvalue of type `__va_list_tag*`. When used as the type
 * of a function parameter, the parameter's type decays to `__va_list_tag*`, so that the argument
 * to the `va_*` macro is still a prvalue of type `__va_list_tag*`, with no implicit conversion
 * necessary. In either case, we treat `__va_list_tag` as the representative type of the `va_list`.
 *
 * In the Windows ABI, `va_list` is declared as a pointer type (usually `char*`). Whether used as
 * the type of a local variable or of a parameter, this means that the argument to the `va_*` macro
 * is always an _lvalue_ of type `char*`. We treat `char*` as the representative type of the
 * `va_list`.
 */
private Type getVAListType(Expr expr) {
  isVAListExpr(expr) and
  if expr.isPRValueCategory()
  then
    // In the Unix ABI, this will be a prvalue of type `__va_list_tag*`. We want the `__va_list_tag`
    // type.
    result = expr.getType().getUnderlyingType().(PointerType).getBaseType()
  else
    // In the Windows ABI, this will be an lvalue of some pointer type. We want that pointer type.
    result = expr.getType()
}

/**
 * The IR translation of a `BuiltInVarArgsStart` expression.
 */
class TranslatedVarArgsStart extends TranslatedNonConstantExpr {
  override BuiltInVarArgsStart expr;

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = VarArgsStartEllipsisAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getEllipsisVariableGLValueType()
    or
    tag = VarArgsStartTag() and
    opcode instanceof Opcode::VarArgsStart and
    resultType = getTypeForPRValue(getVAListType(expr.getVAList().getFullyConverted()))
    or
    tag = VarArgsVAListStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(getVAListType(expr.getVAList().getFullyConverted()))
  }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(VarArgsStartEllipsisAddressTag())
  }

  final override Instruction getResult() { none() }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getVAList() }

  private TranslatedExpr getVAList() {
    result = getTranslatedExpr(expr.getVAList().getFullyConverted())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = VarArgsStartEllipsisAddressTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(VarArgsStartTag())
    or
    tag = VarArgsStartTag() and
    kind instanceof GotoEdge and
    result = this.getVAList().getFirstInstruction()
    or
    tag = VarArgsVAListStoreTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getVAList() and
    result = this.getInstruction(VarArgsVAListStoreTag())
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = VarArgsStartEllipsisAddressTag() and
    result = this.getEnclosingFunction().getEllipsisVariable()
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = VarArgsStartTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInstruction(VarArgsStartEllipsisAddressTag())
    or
    tag = VarArgsVAListStoreTag() and
    (
      operandTag instanceof AddressOperandTag and result = this.getVAList().getResult()
      or
      operandTag instanceof StoreValueOperandTag and result = this.getInstruction(VarArgsStartTag())
    )
  }
}

/**
 * The IR translation of a `BuiltInVarArg` expression.
 */
class TranslatedVarArg extends TranslatedNonConstantExpr {
  override BuiltInVarArg expr;

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = VarArgsVAListLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(getVAListType(expr.getVAList().getFullyConverted()))
    or
    tag = VarArgsArgAddressTag() and
    opcode instanceof Opcode::VarArg and
    resultType = this.getResultType()
    or
    tag = VarArgsMoveNextTag() and
    opcode instanceof Opcode::NextVarArg and
    resultType = getTypeForPRValue(getVAListType(expr.getVAList().getFullyConverted()))
    or
    tag = VarArgsVAListStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(getVAListType(expr.getVAList().getFullyConverted()))
  }

  final override Instruction getFirstInstruction() {
    result = this.getVAList().getFirstInstruction()
  }

  final override Instruction getResult() { result = this.getInstruction(VarArgsArgAddressTag()) }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getVAList() }

  private TranslatedExpr getVAList() {
    result = getTranslatedExpr(expr.getVAList().getFullyConverted())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = VarArgsVAListLoadTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(VarArgsArgAddressTag())
    or
    tag = VarArgsArgAddressTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(VarArgsMoveNextTag())
    or
    tag = VarArgsMoveNextTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(VarArgsVAListStoreTag())
    or
    tag = VarArgsVAListStoreTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getVAList() and
    result = this.getInstruction(VarArgsVAListLoadTag())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = VarArgsVAListLoadTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getVAList().getResult()
    )
    or
    tag = VarArgsArgAddressTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInstruction(VarArgsVAListLoadTag())
    or
    tag = VarArgsMoveNextTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getInstruction(VarArgsVAListLoadTag())
    or
    tag = VarArgsVAListStoreTag() and
    (
      operandTag instanceof AddressOperandTag and result = this.getVAList().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(VarArgsMoveNextTag())
    )
  }
}

/**
 * The IR translation of a `BuiltInVarArgsEnd` expression.
 */
class TranslatedVarArgsEnd extends TranslatedNonConstantExpr {
  override BuiltInVarArgsEnd expr;

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::VarArgsEnd and
    resultType = getVoidType()
  }

  final override Instruction getFirstInstruction() {
    result = this.getVAList().getFirstInstruction()
  }

  final override Instruction getResult() { none() }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getVAList() }

  private TranslatedExpr getVAList() {
    result = getTranslatedExpr(expr.getVAList().getFullyConverted())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getVAList() and
    result = this.getInstruction(OnlyInstructionTag())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getVAList().getResult()
  }
}

/**
 * The IR translation of a `BuiltInVarArgCopy` expression.
 */
class TranslatedVarArgCopy extends TranslatedNonConstantExpr {
  override BuiltInVarArgCopy expr;

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = VarArgsVAListLoadTag() and
    opcode instanceof Opcode::Load and
    resultType = getTypeForPRValue(getVAListType(expr.getSourceVAList().getFullyConverted()))
    or
    tag = VarArgsVAListStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getTypeForPRValue(getVAListType(expr.getDestinationVAList().getFullyConverted()))
  }

  final override Instruction getFirstInstruction() {
    result = this.getSourceVAList().getFirstInstruction()
  }

  final override Instruction getResult() { result = this.getInstruction(VarArgsVAListStoreTag()) }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getDestinationVAList()
    or
    id = 1 and result = this.getSourceVAList()
  }

  private TranslatedExpr getDestinationVAList() {
    result = getTranslatedExpr(expr.getDestinationVAList().getFullyConverted())
  }

  private TranslatedExpr getSourceVAList() {
    result = getTranslatedExpr(expr.getSourceVAList().getFullyConverted())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = VarArgsVAListLoadTag() and
    kind instanceof GotoEdge and
    result = this.getDestinationVAList().getFirstInstruction()
    or
    tag = VarArgsVAListStoreTag() and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getSourceVAList() and
    result = this.getInstruction(VarArgsVAListLoadTag())
    or
    child = this.getDestinationVAList() and
    result = this.getInstruction(VarArgsVAListStoreTag())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = VarArgsVAListLoadTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getSourceVAList().getResult()
    )
    or
    tag = VarArgsVAListStoreTag() and
    (
      operandTag instanceof AddressOperandTag and result = this.getDestinationVAList().getResult()
      or
      operandTag instanceof StoreValueOperandTag and
      result = this.getInstruction(VarArgsVAListLoadTag())
    )
  }
}

/**
 * The IR translation of a `new` or `new[]` expression.
 */
abstract class TranslatedNewOrNewArrayExpr extends TranslatedNonConstantExpr, InitializationContext {
  override NewOrNewArrayExpr expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getAllocatorCall()
    or
    id = 1 and result = this.getInitialization()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::Convert and
    resultType = this.getResultType()
  }

  final override Instruction getFirstInstruction() {
    result = this.getAllocatorCall().getFirstInstruction()
  }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = OnlyInstructionTag() and
    if exists(this.getInitialization())
    then result = this.getInitialization().getFirstInstruction()
    else result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getAllocatorCall() and result = this.getInstruction(OnlyInstructionTag())
    or
    child = this.getInitialization() and result = this.getParent().getChildSuccessor(this)
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = this.getAllocatorCall().getResult()
  }

  final override Instruction getTargetAddress() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  private TranslatedAllocatorCall getAllocatorCall() { result = getTranslatedAllocatorCall(expr) }

  abstract TranslatedInitialization getInitialization();
}

/**
 * The IR translation of a `new` expression.
 */
class TranslatedNewExpr extends TranslatedNewOrNewArrayExpr {
  override NewExpr expr;

  final override Type getTargetType() { result = expr.getAllocatedType().getUnspecifiedType() }

  final override TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr.getInitializer())
  }
}

/**
 * The IR translation of a `new[]` expression.
 */
class TranslatedNewArrayExpr extends TranslatedNewOrNewArrayExpr {
  override NewArrayExpr expr;

  final override Type getTargetType() { result = expr.getAllocatedType().getUnspecifiedType() }

  final override TranslatedInitialization getInitialization() {
    // REVIEW: Figure out how we want to model array initialization in the IR.
    none()
  }
}

/**
 * A placeholder for the translation of a `delete[]` expression.
 *
 * Proper translation is not yet implemented, but this stub implementation
 * ensures that code following a `delete[]` is not unreachable.
 */
class TranslatedDeleteArrayExprPlaceHolder extends TranslatedSingleInstructionExpr {
  override DeleteArrayExpr expr;

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

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  final override Opcode getOpcode() { result instanceof Opcode::NoOp }

  private TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.getExpr().getFullyConverted())
  }
}

/**
 * A placeholder for the translation of a `delete` expression.
 *
 * Proper translation is not yet implemented, but this stub implementation
 * ensures that code following a `delete` is not unreachable.
 */
class TranslatedDeleteExprPlaceHolder extends TranslatedSingleInstructionExpr {
  override DeleteExpr expr;

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

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  final override Opcode getOpcode() { result instanceof Opcode::NoOp }

  private TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.getExpr().getFullyConverted())
  }
}

/**
 * The IR translation of a `ConditionDeclExpr`, which represents the value of the declared variable
 * after conversion to `bool` in code such as:
 * ```
 * if (int* p = &x) {
 * }
 * ```
 */
class TranslatedConditionDeclExpr extends TranslatedNonConstantExpr {
  override ConditionDeclExpr expr;

  final override Instruction getFirstInstruction() { result = this.getDecl().getFirstInstruction() }

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getDecl()
    or
    id = 1 and result = this.getConditionExpr()
  }

  override Instruction getResult() { result = this.getConditionExpr().getResult() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getDecl() and
    result = this.getConditionExpr().getFirstInstruction()
    or
    child = this.getConditionExpr() and result = this.getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  private TranslatedConditionDecl getDecl() { result = getTranslatedConditionDecl(expr) }

  private TranslatedExpr getConditionExpr() {
    result = getTranslatedExpr(expr.getVariableAccess().getFullyConverted())
  }
}

/**
 * The IR translation of a lambda expression. This initializes a temporary variable whose type is that of the lambda,
 * using the initializer list that represents the captures of the lambda.
 */
class TranslatedLambdaExpr extends TranslatedNonConstantExpr, InitializationContext {
  override LambdaExpression expr;

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
    child = this.getInitialization() and
    result = this.getInstruction(LoadTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
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

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(InitializerVariableAddressTag())
    or
    tag = LoadTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = this.getInstruction(InitializerVariableAddressTag())
    )
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag() or
      tag = InitializerStoreTag()
    ) and
    result = this.getTempVariable(LambdaTempVar())
  }

  override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = LambdaTempVar() and
    type = getTypeForPRValue(expr.getType())
  }

  final override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  final override Type getTargetType() { result = expr.getType() }

  private predicate hasInitializer() { exists(this.getInitialization()) }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr.getChild(0).getFullyConverted())
  }
}

/**
 * The IR translation of `StmtExpr` (the GNU statement expression extension to C/C++), such as
 * ``` ({ doSomething(); a + b; })```
 */
class TranslatedStmtExpr extends TranslatedNonConstantExpr {
  override StmtExpr expr;

  final override Instruction getFirstInstruction() { result = this.getStmt().getFirstInstruction() }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getStmt() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag instanceof OnlyInstructionTag and
    kind instanceof GotoEdge and
    result = this.getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getStmt() and
    result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    opcode instanceof Opcode::CopyValue and
    tag instanceof OnlyInstructionTag and
    resultType = this.getResultType()
  }

  override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag instanceof OnlyInstructionTag and
    operandTag instanceof UnaryOperandTag and
    result = getTranslatedExpr(expr.getResultExpr().getFullyConverted()).getResult()
  }

  TranslatedStmt getStmt() { result = getTranslatedStmt(expr.getStmt()) }
}

class TranslatedErrorExpr extends TranslatedSingleInstructionExpr {
  override ErrorExpr expr;

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  final override TranslatedElement getChild(int id) { none() }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    none()
  }

  final override Opcode getOpcode() { result instanceof Opcode::Error }
}

/**
 * Holds if the translation of `expr` will not directly generate any
 * `Instruction` for use as result. For such instructions we can synthesize a
 * `CopyValue` instruction to ensure that there is a 1-to-1 mapping between
 * expressions and result-bearing instructions.
 */
// This should ideally be a dispatch predicate on TranslatedNonConstantExpr,
// but it doesn't look monotonic to QL.
predicate exprNeedsCopyIfNotLoaded(Expr expr) {
  (
    expr instanceof AssignExpr
    or
    expr instanceof AssignOperation and
    not expr.isPRValueCategory() // is C++
    or
    expr instanceof PrefixCrementOperation and
    not expr.isPRValueCategory() // is C++
    or
    // Because the load is on the `e` in `e++`.
    expr instanceof PostfixCrementOperation
    or
    expr instanceof PointerDereferenceExpr
    or
    expr instanceof AddressOfExpr
    or
    expr instanceof BuiltInOperationBuiltInAddressOf
    or
    // No case for ParenthesisExpr to avoid getting too many instructions
    expr instanceof ReferenceDereferenceExpr
    or
    expr instanceof ReferenceToExpr
    or
    expr instanceof CommaExpr
    or
    expr instanceof ConditionDeclExpr
    // TODO: simplify TranslatedStmtExpr too
  ) and
  not exprImmediatelyDiscarded(expr)
}

/**
 * Holds if `expr` is immediately discarded. Such expressions do not need a
 * `CopyValue` because it's unlikely that anyone is interested in their value.
 */
private predicate exprImmediatelyDiscarded(Expr expr) {
  exists(ExprStmt s |
    s = expr.getParent() and
    not exists(StmtExpr se | s = se.getStmt().(BlockStmt).getLastStmt())
  )
  or
  exists(CommaExpr c | c.getLeftOperand() = expr)
  or
  exists(ForStmt for | for.getUpdate() = expr)
}

/**
 * The IR translation of an `__assume` expression. We currently translate these as `NoOp`. In the
 * future, we will probably want to do something better. At a minimum, we can model `__assume(0)` as
 * `Unreached`.
 */
class TranslatedAssumeExpr extends TranslatedSingleInstructionExpr {
  override AssumeExpr expr;

  final override Opcode getOpcode() { result instanceof Opcode::NoOp }

  final override Instruction getFirstInstruction() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  final override TranslatedElement getChild(int id) { none() }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = this.getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }
}
