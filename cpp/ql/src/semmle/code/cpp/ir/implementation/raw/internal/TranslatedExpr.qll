import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedElement
private import TranslatedFunction
private import TranslatedInitialization

/**
 * Gets the TranslatedExpr for the specified expression. If `expr` is a load,
 * the result is the TranslatedExpr for the load portion.
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

  /**
   * Gets the type of the result produced by this expression.
   */
  final Type getResultType() {
    result = expr.getType().getUnspecifiedType()
  }

  override final Locatable getAST() {
    result = expr
  }

  override final Function getFunction() {
    result = expr.getEnclosingFunction()
  }

  /**
   * Gets the expression from which this `TranslatedExpr` is generated.
   */
  final Expr getExpr() {
    result = expr
  }

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
  override final string toString() {
    result = expr.toString()
  }

  override final predicate producesExprResult() {
    // If there's no load, then this is the only TranslatedExpr for this
    // expression.
    not expr.hasLValueToRValueConversion() or
    // If we're supposed to ignore the load on this expression, then this
    // is the only TranslatedExpr.
    ignoreLoad(expr)
  }

  /**
   * Returns `true` if the result of this `TranslatedExpr` is a glvalue, or
   * `false` if the result is a prvalue.
   *
   * This predicate returns a `boolean` value instead of just a being a plain
   * predicate because all of the subclass predicates that call it require a
   * `boolean` value.
   */
  final boolean isResultGLValue() {
    if(
      expr.isGLValueCategory() or
      // If this TranslatedExpr doesn't produce the result, then it must represent
      // a glvalue that is then loaded by a TranslatedLoad.
      not producesExprResult()
    ) then
      result = true
    else
      result = false
  }
}

class TranslatedConditionValue extends TranslatedCoreExpr, ConditionContext,
  TTranslatedConditionValue {
  TranslatedConditionValue() {
    this = TTranslatedConditionValue(expr)
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition()
  }

  override Instruction getFirstInstruction() {
    result = getCondition().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    (
      (
        tag = ConditionValueTrueTempAddressTag() or
        tag = ConditionValueFalseTempAddressTag() or
        tag = ConditionValueResultTempAddressTag()
      ) and
      opcode instanceof Opcode::VariableAddress and
      resultType = getResultType() and
      isGLValue = true
    ) or
    (
      (
        tag = ConditionValueTrueConstantTag() or
        tag = ConditionValueFalseConstantTag()
      ) and
      opcode instanceof Opcode::Constant and
      resultType = getResultType() and
      isGLValue = isResultGLValue()
    ) or
    (
      (
        tag = ConditionValueTrueStoreTag() or
        tag = ConditionValueFalseStoreTag()
      ) and
      opcode instanceof Opcode::Store and
      resultType = getResultType() and
      isGLValue = isResultGLValue()
    ) or
    (
      tag = ConditionValueResultLoadTag() and
      opcode instanceof Opcode::Load and
      resultType = getResultType() and
      isGLValue = isResultGLValue()
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = ConditionValueTrueTempAddressTag() and
        result = getInstruction(ConditionValueTrueConstantTag())
      ) or
      (
        tag = ConditionValueTrueConstantTag() and
        result = getInstruction(ConditionValueTrueStoreTag())
      ) or
      (
        tag = ConditionValueTrueStoreTag() and
        result = getInstruction(ConditionValueResultTempAddressTag())
      ) or
      (
        tag = ConditionValueFalseTempAddressTag() and
        result = getInstruction(ConditionValueFalseConstantTag())
      ) or
      (
        tag = ConditionValueFalseConstantTag() and
        result = getInstruction(ConditionValueFalseStoreTag())
      ) or
      (
        tag = ConditionValueFalseStoreTag() and
        result = getInstruction(ConditionValueResultTempAddressTag())
      ) or
      (
        tag = ConditionValueResultTempAddressTag() and
        result = getInstruction(ConditionValueResultLoadTag())
      ) or
      (
        tag = ConditionValueResultLoadTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    (
      tag = ConditionValueTrueStoreTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getInstruction(ConditionValueTrueTempAddressTag())
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getInstruction(ConditionValueTrueConstantTag())
        )
      )
    ) or
    (
      tag = ConditionValueFalseStoreTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getInstruction(ConditionValueFalseTempAddressTag())
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getInstruction(ConditionValueFalseConstantTag())
        )
      )
    ) or
    (
      tag = ConditionValueResultLoadTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getInstruction(ConditionValueResultTempAddressTag())
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
        )
      )
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, Type type) {
    tag = ConditionValueTempVar() and
    type = getResultType()
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = ConditionValueTrueTempAddressTag() or
      tag = ConditionValueFalseTempAddressTag() or
      tag = ConditionValueResultTempAddressTag()
    ) and
    result = getTempVariable(ConditionValueTempVar())
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = ConditionValueTrueConstantTag() and result = "1" or
    tag = ConditionValueFalseConstantTag() and result = "0"
  }

  override Instruction getResult() {
    result = getInstruction(ConditionValueResultLoadTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and
    result = getInstruction(ConditionValueTrueTempAddressTag())
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and
    result = getInstruction(ConditionValueFalseTempAddressTag())
  }
  
  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(expr)
  }
}

/**
 * IR translation of an implicit lvalue-to-rvalue conversion on the result of
 * an expression.
 */
class TranslatedLoad extends TranslatedExpr, TTranslatedLoad {
  TranslatedLoad() {
    this = TTranslatedLoad(expr)
  }

  override string toString() {
    result = "Load of " + expr.toString()
  }

  override Instruction getFirstInstruction() {
    result = getOperand().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getOperand()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = expr.getType().getUnspecifiedType() and
    if expr.isGLValueCategory() then
      isGLValue = true
    else
      isGLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = LoadTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getInstruction(LoadTag())
  }

  override Instruction getResult() {
    result = getInstruction(LoadTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = LoadTag() and
    (
      (
        operandTag instanceof AddressOperand and
        result = getOperand().getResult()
      ) or
      (
        operandTag instanceof CopySourceOperand and
        result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
      )
    )
  }

  override final predicate producesExprResult() {
    // A load always produces the result of the expression.
    any()
  }

  private TranslatedCoreExpr getOperand() {
    result.getExpr() = expr
  }
}

class TranslatedCommaExpr extends TranslatedNonConstantExpr {
  CommaExpr comma;

  TranslatedCommaExpr() {
    comma = expr
  }

  override Instruction getFirstInstruction() {
    result = getLeftOperand().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getLeftOperand() or
    id = 1 and result = getRightOperand()
  }

  override Instruction getResult() {
    result = getRightOperand().getResult()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getLeftOperand() and
      result = getRightOperand().getFirstInstruction()
    ) or
    child = getRightOperand() and result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    none()
  }

  private TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(comma.getLeftOperand().getFullyConverted())
  }

  private TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(comma.getRightOperand().getFullyConverted())
  }
}

abstract class TranslatedCrementOperation extends TranslatedNonConstantExpr {
  CrementOperation op;

  TranslatedCrementOperation() {
    op = expr
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getOperand()
  }

  override final string getInstructionConstantValue(InstructionTag tag) {
    tag = CrementConstantTag() and
    exists(Type resultType |
      resultType = getResultType() and
      (
        resultType instanceof IntegralType and result = "1" or
        resultType instanceof FloatingPointType and result = "1.0" or
        resultType instanceof PointerType and result = "1"
      )
    )
  }

  private Type getConstantType() {
    exists(Type resultType |
      resultType = getResultType() and
      (
        resultType instanceof ArithmeticType and result = resultType or
        resultType instanceof PointerType and result = getIntType()
      )
    )
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    isGLValue = false and
    (
      (
        tag = CrementLoadTag() and
        opcode instanceof Opcode::Load and
        resultType = getResultType()
      ) or
      (
        tag = CrementConstantTag() and
        opcode instanceof Opcode::Constant and
        resultType = getConstantType()
      ) or
      (
        tag = CrementOpTag() and
        opcode = getOpcode() and
        resultType = getResultType()
      ) or
      (
        tag = CrementStoreTag() and
        opcode instanceof Opcode::Store and
        resultType = getResultType()
      )
    )
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    (
      tag = CrementLoadTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getOperand().getResult()
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
        )
      )
    ) or
    (
      tag = CrementOpTag() and
      (
        (
          operandTag instanceof LeftOperand and
          result = getInstruction(CrementLoadTag())
        ) or
        (
          operandTag instanceof RightOperand and
          result = getInstruction(CrementConstantTag())
        )
      )
    ) or
    (
      tag = CrementStoreTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getOperand().getResult()
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getInstruction(CrementOpTag())
        )
      )
    )
  }

  override final Instruction getFirstInstruction() {
    result = getOperand().getFirstInstruction()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = CrementLoadTag() and
        result = getInstruction(CrementConstantTag())
      ) or
      (
        tag = CrementConstantTag() and
        result = getInstruction(CrementOpTag())
      ) or
      (
        tag = CrementOpTag() and
        result = getInstruction(CrementStoreTag())
      ) or
      (
        tag = CrementStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getInstruction(CrementLoadTag())
  }

  override final int getInstructionElementSize(InstructionTag tag) {
    tag = CrementOpTag() and
    (
      getOpcode() instanceof Opcode::PointerAdd or
      getOpcode() instanceof Opcode::PointerSub
    ) and
    result = max(getResultType().(PointerType).getBaseType().getSize())
  }

  final TranslatedExpr getOperand() {
    result = getTranslatedExpr(op.getOperand().getFullyConverted())
  }

  final Opcode getOpcode() {
    exists(Type resultType |
      resultType = getResultType() and
      (
        (
          op instanceof IncrementOperation and
          if resultType instanceof PointerType then
            result instanceof Opcode::PointerAdd
          else
            result instanceof Opcode::Add
        ) or
        (
          op instanceof DecrementOperation and
          if resultType instanceof PointerType then
            result instanceof Opcode::PointerSub
          else
            result instanceof Opcode::Sub
        )
      )
    )
  }
}

class TranslatedPrefixCrementOperation extends TranslatedCrementOperation {
  TranslatedPrefixCrementOperation() {
    op instanceof PrefixCrementOperation
  }

  override Instruction getResult() {
    if expr.isPRValueCategory() then (
      // If this is C, then the result of a prefix crement is a prvalue for the
      // new value assigned to the operand. If this is C++, then the result is
      // an lvalue, but that lvalue is being loaded as part of this expression.
      // EDG doesn't mark this as a load.
      result = getInstruction(CrementOpTag())
    )
    else (
      // This is C++, where the result is an lvalue for the operand, and that
      // lvalue is not being loaded as part of this expression.
      result = getOperand().getResult()
    )
  }
}

class TranslatedPostfixCrementOperation extends TranslatedCrementOperation {
  TranslatedPostfixCrementOperation() {
    op instanceof PostfixCrementOperation
  }

  override Instruction getResult() {
    // The result is a prvalue copy of the original value
    result = getInstruction(CrementLoadTag())
  }
}

class TranslatedArrayExpr extends TranslatedNonConstantExpr {
  ArrayExpr arrayExpr;

  TranslatedArrayExpr() {
    arrayExpr = expr
  }

  override Instruction getFirstInstruction() {
    result = getBaseOperand().getFirstInstruction()
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getBaseOperand() or
    id = 1 and result = getOffsetOperand()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getBaseOperand() and
      result = getOffsetOperand().getFirstInstruction()
    ) or
    (
      child = getOffsetOperand() and
      result = getInstruction(OnlyInstructionTag())
    )
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::PointerAdd and
    resultType = getBaseOperand().getResultType() and
    isGLValue = false
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    (
      (
        operandTag instanceof LeftOperand and
        result = getBaseOperand().getResult()
      ) or
      (
        operandTag instanceof RightOperand and
        result = getOffsetOperand().getResult()
      )
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = max(getBaseOperand().getResultType().(PointerType).getBaseType().getSize())
  }

  private TranslatedExpr getBaseOperand() {
    result = getTranslatedExpr(arrayExpr.getArrayBase().getFullyConverted())
  }

  private TranslatedExpr getOffsetOperand() {
    result = getTranslatedExpr(arrayExpr.getArrayOffset().getFullyConverted())
  }
}

abstract class TranslatedTransparentExpr extends TranslatedNonConstantExpr {
  override final Instruction getFirstInstruction() {
    result = getOperand().getFirstInstruction()
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getOperand()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    none()
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getParent().getChildSuccessor(this)
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    none()
  }

  override final Instruction getResult() {
    result = getOperand().getResult()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    none()
  }

  abstract TranslatedExpr getOperand();
}

class TranslatedTransparentUnaryOperation extends TranslatedTransparentExpr {
  UnaryOperation op;

  TranslatedTransparentUnaryOperation() {
    op = expr and
    (
      // *p is the same as p until the result is loaded.
      expr instanceof PointerDereferenceExpr or
      // &x is the same as x. &x isn't loadable, but is included
      // here to avoid having two nearly identical classes.
      expr instanceof AddressOfExpr
    )
  }

  override TranslatedExpr getOperand() {
    result = getTranslatedExpr(op.getOperand().getFullyConverted())
  }
}

class TranslatedTransparentConversion extends TranslatedTransparentExpr {
  Conversion conv;

  TranslatedTransparentConversion() {
    conv = expr and
    (
      conv instanceof ParenthesisExpr or
      conv instanceof ReferenceDereferenceExpr or
      conv instanceof ReferenceToExpr
    )
  }

  override TranslatedExpr getOperand() {
    result = getTranslatedExpr(conv.getExpr())
  }
}

/**
 * IR translation of an expression whose value is not known at compile time.
 */
abstract class TranslatedNonConstantExpr extends TranslatedCoreExpr {
  TranslatedNonConstantExpr() {
    this = TTranslatedValueExpr(expr) and
    not expr.isConstant()
  }
}

/**
 * IR translation of an expression with a compile-time constant value. This
 * includes not only literals, but also "integral constant expressions" (e.g.
 * `1 + 2`).
 */
abstract class TranslatedConstantExpr extends TranslatedCoreExpr {
  TranslatedConstantExpr() {
    this = TTranslatedValueExpr(expr) and
    expr.isConstant()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final TranslatedElement getChild(int id) {
    none()
  }

  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    none()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode = getOpcode() and
    resultType = getResultType() and
    if(expr.isGLValueCategory() or expr.hasLValueToRValueConversion()) then
      isGLValue = true
    else
      isGLValue = false
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  abstract Opcode getOpcode();
}

class TranslatedArithmeticLiteral extends TranslatedConstantExpr {
  TranslatedArithmeticLiteral() {
    not expr instanceof StringLiteral
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getValue()
  }

  override Opcode getOpcode() {
    result instanceof Opcode::Constant
  }
}

class TranslatedStringLiteral extends TranslatedConstantExpr {
  StringLiteral stringLiteral;

  TranslatedStringLiteral() {
    stringLiteral = expr
  }

  override StringLiteral getInstructionStringLiteral(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = stringLiteral
  }

  override Opcode getOpcode() {
    result instanceof Opcode::StringConstant
  }
}

/**
 * IR translation of an expression that performs a single operation on its
 * operands and returns the result.
 */
abstract class TranslatedSingleInstructionExpr extends
    TranslatedNonConstantExpr {
  /**
   * Gets the `Opcode` of the operation to be performed.
   */
  abstract Opcode getOpcode();

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    opcode = getOpcode() and
    tag = OnlyInstructionTag() and
    resultType = getResultType() and
    isGLValue = isResultGLValue()
  }

  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }
}

class TranslatedUnaryExpr extends TranslatedSingleInstructionExpr {
  TranslatedUnaryExpr() {
    expr instanceof NotExpr or
    expr instanceof ComplementExpr or
    expr instanceof UnaryPlusExpr or
    expr instanceof UnaryMinusExpr
  }

  override final Instruction getFirstInstruction() {
    result = getOperand().getFirstInstruction()
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getOperand()
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    result = getOperand().getResult() and
    if getOpcode() instanceof Opcode::CopyValue then
      operandTag instanceof CopySourceOperand
    else
      operandTag instanceof UnaryOperand
  }

  override final Opcode getOpcode() {
    expr instanceof NotExpr and result instanceof Opcode::LogicalNot or
    expr instanceof ComplementExpr and result instanceof Opcode::BitComplement or
    expr instanceof UnaryPlusExpr and result instanceof Opcode::CopyValue or
    expr instanceof UnaryMinusExpr and result instanceof Opcode::Negate
  }

  private TranslatedExpr getOperand() {
    result = getTranslatedExpr(
      expr.(UnaryOperation).getOperand().getFullyConverted()
    )
  }
}

private Opcode binaryBitwiseOpcode(BinaryBitwiseOperation expr) {
  expr instanceof LShiftExpr and result instanceof Opcode::ShiftLeft or
  expr instanceof RShiftExpr and result instanceof Opcode::ShiftRight or
  expr instanceof BitwiseAndExpr and result instanceof Opcode::BitAnd or
  expr instanceof BitwiseOrExpr and result instanceof Opcode::BitOr or
  expr instanceof BitwiseXorExpr and result instanceof Opcode::BitXor
}

private Opcode binaryArithmeticOpcode(BinaryArithmeticOperation expr) {
  expr instanceof AddExpr and result instanceof Opcode::Add or
  expr instanceof SubExpr and result instanceof Opcode::Sub or
  expr instanceof MulExpr and result instanceof Opcode::Mul or
  expr instanceof DivExpr and result instanceof Opcode::Div or
  expr instanceof RemExpr and result instanceof Opcode::Rem or
  expr instanceof PointerAddExpr and result instanceof Opcode::PointerAdd or
  expr instanceof PointerSubExpr and result instanceof Opcode::PointerSub or
  expr instanceof PointerDiffExpr and result instanceof Opcode::PointerDiff
}

private Opcode comparisonOpcode(ComparisonOperation expr) {
  expr instanceof EQExpr and result instanceof Opcode::CompareEQ or
  expr instanceof NEExpr and result instanceof Opcode::CompareNE or
  expr instanceof LTExpr and result instanceof Opcode::CompareLT or
  expr instanceof GTExpr and result instanceof Opcode::CompareGT or
  expr instanceof LEExpr and result instanceof Opcode::CompareLE or
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
    result = getLeftOperand().getFirstInstruction()
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getLeftOperand() or
    id = 1 and result = getRightOperand()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    if swapOperandsOnOp() then (
      (
        operandTag instanceof RightOperand and
        result = getLeftOperand().getResult()
      ) or
      (
        operandTag instanceof LeftOperand and
        result = getRightOperand().getResult()
      )
    )
    else (
      (
        operandTag instanceof LeftOperand and
        result = getLeftOperand().getResult()
      ) or
      (
        operandTag instanceof RightOperand and
        result = getRightOperand().getResult()
      )
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }
  
  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getLeftOperand() and
      result = getRightOperand().getFirstInstruction()
    ) or
    (
      child = getRightOperand() and
      result = getInstruction(OnlyInstructionTag())
    )
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
        opcode instanceof Opcode::PointerAdd or opcode instanceof Opcode::PointerSub or opcode instanceof Opcode::PointerDiff
      ) and
      result = max(getPointerOperand().getResultType().(PointerType).getBaseType().getSize())
    )
  }

  private TranslatedExpr getPointerOperand() {
    if swapOperandsOnOp() then
      result = getRightOperand()
    else
      result = getLeftOperand()
  }

  private predicate swapOperandsOnOp() {
    // Swap the operands on a pointer add 'i + p', so that the pointer operand
    // always comes first. Note that we still evaluate the operands
    // left-to-right.
    exists(PointerAddExpr ptrAdd, Type rightType |
      ptrAdd = expr and
      rightType = ptrAdd.getRightOperand().getType().getUnspecifiedType() and
      rightType instanceof PointerType
    )
  }

  private TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(
      expr.(BinaryOperation).getLeftOperand().getFullyConverted()
    )
  }

  private TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(
      expr.(BinaryOperation).getRightOperand().getFullyConverted()
    )
  }
}

abstract class TranslatedAssignment extends TranslatedNonConstantExpr {
  Assignment assign;

  TranslatedAssignment() {
    expr = assign
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getLeftOperand() or
    id = 1 and result = getRightOperand()
  }

  override final Instruction getFirstInstruction() {
    // Evaluation is right-to-left
    result = getRightOperand().getFirstInstruction()
  }

  override final Instruction getResult() {
    if expr.isPRValueCategory() then (
      // If this is C, then the result of an assignment is a prvalue for the new
      // value assigned to the left operand. If this is C++, then the result is
      // an lvalue, but that lvalue is being loaded as part of this expression.
      // EDG doesn't mark this as a load.
      result = getStoredValue()
    )
    else (
      // This is C++, where the result is an lvalue for the left operand,
      // and that lvalue is not being loaded as part of this expression.
      result = getLeftOperand().getResult()
    )
  }

  abstract Instruction getStoredValue();

  final TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(
      assign.getLValue().getFullyConverted()
    )
  }

  final TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(
      assign.getRValue().getFullyConverted()
    )
  }
}

class TranslatedAssignExpr extends TranslatedAssignment {
  TranslatedAssignExpr() {
    assign instanceof AssignExpr
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = AssignmentStoreTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // Operands are evaluated right-to-left.
    (
      child = getRightOperand() and
      result = getLeftOperand().getFirstInstruction()
    ) or
    (
      child = getLeftOperand() and
      result = getInstruction(AssignmentStoreTag())
    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = AssignmentStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getResultType() and
    isGLValue = false
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = AssignmentStoreTag() and
    (
      (
        operandTag instanceof AddressOperand and
        result = getLeftOperand().getResult()
      ) or
      (
        operandTag instanceof CopySourceOperand and
        result = getRightOperand().getResult()
      )
    )
  }

  override Instruction getStoredValue() {
    result = getRightOperand().getResult()
  }
}

class TranslatedAssignOperation extends TranslatedAssignment {
  AssignOperation assignOp;

  TranslatedAssignOperation() {
    expr = assignOp
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = AssignOperationLoadTag() and
        if leftOperandNeedsConversion() then
          result = getInstruction(AssignOperationConvertLeftTag())
        else
          result = getInstruction(AssignOperationOpTag())
      ) or
      (
        tag = AssignOperationConvertLeftTag() and
        result = getInstruction(AssignOperationOpTag())
      ) or
      (
        tag = AssignOperationOpTag() and
        if leftOperandNeedsConversion() then
          result = getInstruction(AssignOperationConvertResultTag())
        else
          result = getInstruction(AssignmentStoreTag())
      ) or
      (
        tag = AssignOperationConvertResultTag() and
        result = getInstruction(AssignmentStoreTag())
      ) or
      (
        tag = AssignmentStoreTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    // Operands are evaluated right-to-left.
    (
      child = getRightOperand() and
      result = getLeftOperand().getFirstInstruction()
    ) or
    (
      child = getLeftOperand() and
      result = getInstruction(AssignOperationLoadTag())
    )
  }

  override Instruction getStoredValue() {
    if leftOperandNeedsConversion() then
      result = getInstruction(AssignOperationConvertResultTag())
    else
      result = getInstruction(AssignOperationOpTag())
  }

  private Type getConvertedLeftOperandType() {
    if(assignOp instanceof AssignLShiftExpr or
      assignOp instanceof AssignRShiftExpr or
      assignOp instanceof AssignPointerAddExpr or
      assignOp instanceof AssignPointerSubExpr) then (
      // No need to convert for a shift. Technically, the left side should
      // undergo integral promotion, and then the result would be converted back
      // to the destination type. There's not much point to this, though,
      // because the result will be the same for any well-defined program
      // anyway. If we really want to model this case perfectly, we'll need the
      // extractor to tell us what the promoted type of the left operand would
      // be.
      result = getLeftOperand().getResultType()
    ) else (
      // The right operand has already been converted to the type of the op.
      result = getRightOperand().getResultType()
    )
  }

  private predicate leftOperandNeedsConversion() {
    getConvertedLeftOperandType() != getLeftOperand().getResultType()
  }

  private Opcode getOpcode() {
    assignOp instanceof AssignAddExpr and result instanceof Opcode::Add or
    assignOp instanceof AssignSubExpr and result instanceof Opcode::Sub or
    assignOp instanceof AssignMulExpr and result instanceof Opcode::Mul or
    assignOp instanceof AssignDivExpr and result instanceof Opcode::Div or
    assignOp instanceof AssignRemExpr and result instanceof Opcode::Rem or
    assignOp instanceof AssignAndExpr and result instanceof Opcode::BitAnd or
    assignOp instanceof AssignOrExpr and result instanceof Opcode::BitOr or
    assignOp instanceof AssignXorExpr and result instanceof Opcode::BitXor or
    assignOp instanceof AssignLShiftExpr and result instanceof Opcode::ShiftLeft or
    assignOp instanceof AssignRShiftExpr and result instanceof Opcode::ShiftRight or
    assignOp instanceof AssignPointerAddExpr and result instanceof Opcode::PointerAdd or
    assignOp instanceof AssignPointerSubExpr and result instanceof Opcode::PointerSub
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    isGLValue = false and
    (
      (
        tag = AssignOperationLoadTag() and
        opcode instanceof Opcode::Load and
        resultType = getLeftOperand().getResultType()
      ) or
      (
        tag = AssignOperationOpTag() and
        opcode = getOpcode() and
        resultType = getConvertedLeftOperandType()
      ) or
      (
        tag = AssignmentStoreTag() and
        opcode instanceof Opcode::Store and
        resultType = getResultType()
      ) or
      (
        leftOperandNeedsConversion() and
        opcode instanceof Opcode::Convert and
        (
          (
            tag = AssignOperationConvertLeftTag() and
            resultType = getConvertedLeftOperandType()
          ) or
          (
            tag = AssignOperationConvertResultTag() and
            resultType = getLeftOperand().getResultType()
          )
        )
      )
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = AssignOperationOpTag() and
    exists(Opcode opcode |
      opcode = getOpcode() and
      (opcode instanceof Opcode::PointerAdd or opcode instanceof Opcode::PointerSub)
    ) and
    result = max(getResultType().(PointerType).getBaseType().getSize())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    (
      tag = AssignOperationLoadTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getLeftOperand().getResult()
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
        )
      )
    ) or
    (
      leftOperandNeedsConversion() and
      tag = AssignOperationConvertLeftTag() and
      operandTag instanceof UnaryOperand and
      result = getInstruction(AssignOperationLoadTag())
    ) or
    (
      tag = AssignOperationOpTag() and
      (
        (
          operandTag instanceof LeftOperand and
          if leftOperandNeedsConversion() then
            result = getInstruction(AssignOperationConvertLeftTag())
          else
            result = getInstruction(AssignOperationLoadTag())
        ) or
        (
          operandTag instanceof RightOperand and
          result = getRightOperand().getResult()
        )
      )
    ) or
    (
      leftOperandNeedsConversion() and
      tag = AssignOperationConvertResultTag() and
      operandTag instanceof UnaryOperand and
      result = getInstruction(AssignOperationOpTag())
    ) or
    (
      tag = AssignmentStoreTag() and
      (
        (
          operandTag instanceof AddressOperand and
          result = getLeftOperand().getResult()
        ) or
        (
          operandTag instanceof CopySourceOperand and
          result = getStoredValue()
        )
      )
    )
  }
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
class TranslatedDestructorFieldDestruction extends TranslatedNonConstantExpr,
    StructorCallContext {
  DestructorFieldDestruction destruction;

  TranslatedDestructorFieldDestruction() {
    destruction = expr
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getDestructorCall()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = destruction.getTarget().getType().getUnspecifiedType() and
    isGLValue = true
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getDestructorCall().getFirstInstruction()
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getDestructorCall() and
    result = getParent().getChildSuccessor(this)
  }

  override final Instruction getResult() {
    none()
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperand and
    result = getTranslatedFunction(destruction.getEnclosingFunction()).getInitializeThisInstruction()
  }

  override final Field getInstructionField(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = destruction.getTarget()
  }

  override final Instruction getReceiver() {
    result = getInstruction(OnlyInstructionTag())
  }

  private TranslatedExpr getDestructorCall() {
    result = getTranslatedExpr(destruction.getExpr())
  }
}

class TranslatedConditionalExpr extends TranslatedNonConstantExpr,
  ConditionContext {
  ConditionalExpr condExpr;

  TranslatedConditionalExpr() {
    condExpr = expr
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getCondition() or
    id = 1 and result = getThen() or
    id = 2 and result = getElse()
  }

  override Instruction getFirstInstruction() {
    result = getCondition().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isGLValue) {
    not resultIsVoid() and
    (
      (
        (
          (not thenIsVoid() and (tag = ConditionValueTrueTempAddressTag())) or
          (not elseIsVoid() and (tag = ConditionValueFalseTempAddressTag())) or
          tag = ConditionValueResultTempAddressTag()
        ) and
        opcode instanceof Opcode::VariableAddress and
        resultType = getResultType() and
        isGLValue = true
      ) or
      (
        (
          (not thenIsVoid() and (tag = ConditionValueTrueStoreTag())) or
          (not elseIsVoid() and (tag = ConditionValueFalseStoreTag()))
        ) and
        opcode instanceof Opcode::Store and
        resultType = getResultType() and
        isGLValue = false
      ) or
      (
        tag = ConditionValueResultLoadTag() and
        opcode instanceof Opcode::Load and
        resultType = getResultType() and
        isGLValue = isResultGLValue()
      )
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    not resultIsVoid() and
    kind instanceof GotoEdge and
    (
      (
        not thenIsVoid() and
        (
          (
            tag = ConditionValueTrueTempAddressTag() and
            result = getInstruction(ConditionValueTrueStoreTag())
          ) or
          (
            tag = ConditionValueTrueStoreTag() and
            result = getInstruction(ConditionValueResultTempAddressTag())
          )
        )
      ) or
      (
        not elseIsVoid() and
        (
          (
            tag = ConditionValueFalseTempAddressTag() and
            result = getInstruction(ConditionValueFalseStoreTag())
          ) or
          (
            tag = ConditionValueFalseStoreTag() and
            result = getInstruction(ConditionValueResultTempAddressTag())
          )
        )
      ) or
      (
        tag = ConditionValueResultTempAddressTag() and
        result = getInstruction(ConditionValueResultLoadTag())
      ) or
      (
        tag = ConditionValueResultLoadTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    not resultIsVoid() and
    (
      (
        not thenIsVoid() and
        tag = ConditionValueTrueStoreTag() and
        (
          (
            operandTag instanceof AddressOperand and
            result = getInstruction(ConditionValueTrueTempAddressTag())
          ) or
          (
            operandTag instanceof CopySourceOperand and
            result = getThen().getResult()
          )
        )
      ) or
      (
        not elseIsVoid() and
        tag = ConditionValueFalseStoreTag() and
        (
          (
            operandTag instanceof AddressOperand and
            result = getInstruction(ConditionValueFalseTempAddressTag())
          ) or
          (
            operandTag instanceof CopySourceOperand and
            result = getElse().getResult()
          )
        )
      ) or
      (
        tag = ConditionValueResultLoadTag() and
        (
          (
            operandTag instanceof AddressOperand and
            result = getInstruction(ConditionValueResultTempAddressTag())
          ) or
          (
            operandTag instanceof CopySourceOperand and
            result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
          )
        )
      )
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, Type type) {
    not resultIsVoid() and
    tag = ConditionValueTempVar() and
    type = getResultType()
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    not resultIsVoid() and
    (
      tag = ConditionValueTrueTempAddressTag() or
      tag = ConditionValueFalseTempAddressTag() or
      tag = ConditionValueResultTempAddressTag()
    ) and
    result = getTempVariable(ConditionValueTempVar())
  }

  override Instruction getResult() {
    not resultIsVoid() and
    result = getInstruction(ConditionValueResultLoadTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getThen() and
      if thenIsVoid() then
        result = getParent().getChildSuccessor(this)
      else
        result = getInstruction(ConditionValueTrueTempAddressTag())
    ) or
    (
      child = getElse() and
      if elseIsVoid() then
        result = getParent().getChildSuccessor(this)
      else
        result = getInstruction(ConditionValueFalseTempAddressTag())
    )
  }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getCondition() and
    result = getThen().getFirstInstruction()
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = getCondition() and
    result = getElse().getFirstInstruction()
  }
  
  private TranslatedCondition getCondition() {
    result = getTranslatedCondition(condExpr.getCondition().getFullyConverted())
  }

  private TranslatedExpr getThen() {
    result = getTranslatedExpr(condExpr.getThen().getFullyConverted())
  }

  private TranslatedExpr getElse() {
    result = getTranslatedExpr(condExpr.getElse().getFullyConverted())
  }

  private predicate thenIsVoid() {
    getThen().getResultType() instanceof VoidType or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    condExpr.getThen() instanceof ThrowExpr
  }

  private predicate elseIsVoid() {
    getElse().getResultType() instanceof VoidType or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    condExpr.getElse() instanceof ThrowExpr
  }

  private predicate resultIsVoid() {
    getResultType() instanceof VoidType
  }
}

/**
 * IR translation of a `throw` expression.
 */
abstract class TranslatedThrowExpr extends TranslatedNonConstantExpr {
  ThrowExpr throw;

  TranslatedThrowExpr() {
    throw = expr
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    tag = ThrowTag() and
    opcode = getThrowOpcode() and
    resultType instanceof VoidType and
    isGLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    tag = ThrowTag() and
    kind instanceof ExceptionEdge and
    result = getParent().getExceptionSuccessorInstruction()
  }

  override Instruction getResult() {
    none()
  }

  abstract Opcode getThrowOpcode();
}

/**
 * IR translation of a `throw` expression with an argument
 * (e.g. `throw std::bad_alloc()`).
 */
class TranslatedThrowValueExpr extends TranslatedThrowExpr,
    InitializationContext {
  TranslatedThrowValueExpr() {
    not throw instanceof ReThrowExpr
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    TranslatedThrowExpr.super.hasInstruction(opcode, tag, resultType, isGLValue) or
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getExceptionType() and
    isGLValue = true
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    result = TranslatedThrowExpr.super.getInstructionSuccessor(tag, kind) or
    (
      tag = InitializerVariableAddressTag() and
      result = getInitialization().getFirstInstruction() and
      kind instanceof GotoEdge
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and
    result = getInstruction(ThrowTag())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRTempVariable(throw, ThrowTempVar())
  }

  override final predicate hasTempVariable(TempVariableTag tag, Type type) {
    tag = ThrowTempVar() and
    type = getExceptionType()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = ThrowTag() and
    (
      (
        operandTag instanceof AddressOperand and
        result = getInstruction(InitializerVariableAddressTag())
      ) or
      (
        operandTag instanceof ExceptionOperand and
        result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
      )
    )
  }

  override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = getExceptionType()
  }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(
      throw.getExpr().getFullyConverted())
  }

  override final Opcode getThrowOpcode() {
    result instanceof Opcode::ThrowValue
  }

  private Type getExceptionType() {
    result = throw.getType().getUnspecifiedType()
  }
}

/**
 * IR translation of a `throw` expression with no argument (e.g. `throw;`).
 */
class TranslatedReThrowExpr extends TranslatedThrowExpr {
  TranslatedReThrowExpr() {
    throw instanceof ReThrowExpr
  }

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(ThrowTag())
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override final Opcode getThrowOpcode() {
    result instanceof Opcode::ReThrow
  }
}

/**
 * The IR translation of a built-in operation (i.e. anything that extends
 * `BuiltInOperation`).
 */
abstract class TranslatedBuiltInOperation extends TranslatedNonConstantExpr {
  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getFirstInstruction() {
    if exists(getChild(0)) then 
      result = getChild(0).getFirstInstruction()
    else
      result = getInstruction(OnlyInstructionTag())
  }

  override final TranslatedElement getChild(int id) {
    result = getTranslatedExpr(expr.getChild(id).getFullyConverted())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge and
    result = getParent().getChildSuccessor(this)
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = getChild(id) and
      (
        result = getChild(id + 1).getFirstInstruction() or
        not exists(getChild(id + 1)) and result = getInstruction(OnlyInstructionTag())
      )
    )
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    tag = OnlyInstructionTag() and
    opcode = getOpcode() and
    resultType = getResultType() and
    isGLValue = isResultGLValue()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    exists(int index |
      operandTag = positionalArgumentOperand(index) and
      result = getChild(index).(TranslatedExpr).getResult()
    )
  }

  abstract Opcode getOpcode();
}

/**
 * The IR translation of a `BuiltInVarArgsStart` expression.
 */
class TranslatedVarArgsStart extends TranslatedBuiltInOperation {
  TranslatedVarArgsStart() {
    expr instanceof BuiltInVarArgsStart
  }

  override final Opcode getOpcode() {
    result instanceof Opcode::VarArgsStart
  }
}

/**
 * The IR translation of a `BuiltInVarArgsEnd` expression.
 */
class TranslatedVarArgsEnd extends TranslatedBuiltInOperation {
  TranslatedVarArgsEnd() {
    expr instanceof BuiltInVarArgsEnd
  }

  override final Opcode getOpcode() {
    result instanceof Opcode::VarArgsEnd
  }
}

/**
 * The IR translation of a `BuiltInVarArg` expression.
 */
class TranslatedVarArg extends TranslatedBuiltInOperation {
  TranslatedVarArg() {
    expr instanceof BuiltInVarArg
  }

  override final Opcode getOpcode() {
    result instanceof Opcode::VarArg
  }
}

/**
 * The IR translation of a `BuiltInVarArgCopy` expression.
 */
class TranslatedVarArgCopy extends TranslatedBuiltInOperation {
  TranslatedVarArgCopy() {
    expr instanceof BuiltInVarArgCopy
  }

  override final Opcode getOpcode() {
    result instanceof Opcode::VarArgCopy
  }
}
