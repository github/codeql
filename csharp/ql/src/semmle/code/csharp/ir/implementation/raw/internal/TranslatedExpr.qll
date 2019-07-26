import csharp
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import semmle.code.csharp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedDeclarationEntry
private import TranslatedElement
private import TranslatedFunction
private import TranslatedInitialization
private import TranslatedFunction
private import TranslatedStmt
import TranslatedCall
private import semmle.code.csharp.ir.Util
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

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
    result = expr.getType()
  }

  override final Language::AST getAST() {
    result = expr
  }

  override final Callable getFunction() {
    result = expr.getEnclosingCallable()
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
  override final string toString() {
    result = expr.toString()
  }

  /**
   * All exprs produce a final value, apart from reads. They first need an access,
   * then a load.
   */
  override final predicate producesExprResult() {
  	// TODO: When the compatibility layer is in place, 
  	//       create a special class for the following cases
    not (expr instanceof AssignableRead) or
    expr.getParent() instanceof ArrayAccess
  }

  /**
   * Returns `true` if the result of this `TranslatedExpr` is a glvalue, or
   * `false` if the result is a prvalue.
   *
   * This predicate returns a `boolean` value instead of just a being a plain
   * predicate because all of the subclass predicates that call it require a
   * `boolean` value.
   */
  final boolean isResultLValue() {
    if(not producesExprResult()) then
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
    Type resultType, boolean isLValue) {
    (
      (
        tag = ConditionValueTrueTempAddressTag() or
        tag = ConditionValueFalseTempAddressTag() or
        tag = ConditionValueResultTempAddressTag()
      ) and
      opcode instanceof Opcode::VariableAddress and
      resultType = getResultType() and
      isLValue = true
    ) or
    (
      (
        tag = ConditionValueTrueConstantTag() or
        tag = ConditionValueFalseConstantTag()
      ) and
      opcode instanceof Opcode::Constant and
      resultType = getResultType() and
      isLValue = isResultLValue()
    ) or
    (
      (
        tag = ConditionValueTrueStoreTag() or
        tag = ConditionValueFalseStoreTag()
      ) and
      opcode instanceof Opcode::Store and
      resultType = getResultType() and
      isLValue = isResultLValue()
    ) or
    (
      tag = ConditionValueResultLoadTag() and
      opcode instanceof Opcode::Load and
      resultType = getResultType() and
      isLValue = isResultLValue()
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
          operandTag instanceof AddressOperandTag and
          result = getInstruction(ConditionValueTrueTempAddressTag())
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getInstruction(ConditionValueTrueConstantTag())
        )
      )
    ) or
    (
      tag = ConditionValueFalseStoreTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(ConditionValueFalseTempAddressTag())
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getInstruction(ConditionValueFalseConstantTag())
        )
      )
    ) or
    (
      tag = ConditionValueResultLoadTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(ConditionValueResultTempAddressTag())
        ) or
        (
          operandTag instanceof LoadOperandTag and
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
      Type resultType, boolean isLValue) {
    tag = LoadTag() and
    opcode instanceof Opcode::Load and
    resultType = expr.getType() and
    if not producesExprResult() then
      isLValue = true
    else
      isLValue = false
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
        operandTag instanceof AddressOperandTag and
        result = getOperand().getResult()
      ) or
      (
        operandTag instanceof LoadOperandTag and
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

//class TranslatedCommaExpr extends TranslatedNonConstantExpr {
//  override CommaExpr expr;
//
//  override Instruction getFirstInstruction() {
//    result = getLeftOperand().getFirstInstruction()
//  }
//
//  override TranslatedElement getChild(int id) {
//    id = 0 and result = getLeftOperand() or
//    id = 1 and result = getRightOperand()
//  }
//
//  override Instruction getResult() {
//    result = getRightOperand().getResult()
//  }
//
//  override Instruction getInstructionSuccessor(InstructionTag tag,
//    EdgeKind kind) {
//    none()
//  }
//
//  override Instruction getChildSuccessor(TranslatedElement child) {
//    (
//      child = getLeftOperand() and
//      result = getRightOperand().getFirstInstruction()
//    ) or
//    child = getRightOperand() and result = getParent().getChildSuccessor(this)
//  }
//
//  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
//    Type resultType, boolean ) {
//    none()
//  }
//
//  override Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    none()
//  }
//
//  private TranslatedExpr getLeftOperand() {
//    result = getTranslatedExpr(expr.getLeftOperand().getFullyConverted())
//  }
//
//  private TranslatedExpr getRightOperand() {
//    result = getTranslatedExpr(expr.getRightOperand().getFullyConverted())
//  }
//}

//abstract class TranslatedCrementOperation extends TranslatedNonConstantExpr {
//  override CrementOperation expr;
//
//  override final TranslatedElement getChild(int id) {
//    id = 0 and result = getOperand()
//  }
//
//  override final string getInstructionConstantValue(InstructionTag tag) {
//    tag = CrementConstantTag() and
//    exists(Type resultType |
//      resultType = getResultType() and
//      (
//        resultType instanceof IntegralType and result = "1" or
//        resultType instanceof FloatingPointType and result = "1.0" or
//        resultType instanceof PointerType and result = "1"
//      )
//    )
//  }
//
//  private Type getConstantType() {
//    exists(Type resultType |
//      resultType = getResultType() and
//      (
//        resultType instanceof ArithmeticType and result = resultType or
//        resultType instanceof PointerType and result = getIntType()
//      )
//    )
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//    Type resultType, boolean ) {
//     = false and
//    (
//      (
//        tag = CrementLoadTag() and
//        opcode instanceof Opcode::Load and
//        resultType = getResultType()
//      ) or
//      (
//        tag = CrementConstantTag() and
//        opcode instanceof Opcode::Constant and
//        resultType = getConstantType()
//      ) or
//      (
//        tag = CrementOpTag() and
//        opcode = getOpcode() and
//        resultType = getResultType()
//      ) or
//      (
//        tag = CrementStoreTag() and
//        opcode instanceof Opcode::Store and
//        resultType = getResultType()
//      )
//    )
//  }
//
//  override final Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    (
//      tag = CrementLoadTag() and
//      (
//        (
//          operandTag instanceof AddressOperandTag and
//          result = getOperand().getResult()
//        ) or
//        (
//          operandTag instanceof LoadOperandTag and
//          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
//        )
//      )
//    ) or
//    (
//      tag = CrementOpTag() and
//      (
//        (
//          operandTag instanceof LeftOperandTag and
//          result = getInstruction(CrementLoadTag())
//        ) or
//        (
//          operandTag instanceof RightOperandTag and
//          result = getInstruction(CrementConstantTag())
//        )
//      )
//    ) or
//    (
//      tag = CrementStoreTag() and
//      (
//        (
//          operandTag instanceof AddressOperandTag and
//          result = getOperand().getResult()
//        ) or
//        (
//          operandTag instanceof StoreValueOperandTag and
//          result = getInstruction(CrementOpTag())
//        )
//      )
//    )
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getOperand().getFirstInstruction()
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//    EdgeKind kind) {
//    kind instanceof GotoEdge and
//    (
//      (
//        tag = CrementLoadTag() and
//        result = getInstruction(CrementConstantTag())
//      ) or
//      (
//        tag = CrementConstantTag() and
//        result = getInstruction(CrementOpTag())
//      ) or
//      (
//        tag = CrementOpTag() and
//        result = getInstruction(CrementStoreTag())
//      ) or
//      (
//        tag = CrementStoreTag() and
//        result = getParent().getChildSuccessor(this)
//      )
//    )
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    child = getOperand() and result = getInstruction(CrementLoadTag())
//  }
//
//  override final int getInstructionElementSize(InstructionTag tag) {
//    tag = CrementOpTag() and
//    (
//      getOpcode() instanceof Opcode::PointerAdd or
//      getOpcode() instanceof Opcode::PointerSub
//    ) and
//    result = max(getResultType().(PointerType).getBaseType().getSize())
//  }
//
//  final TranslatedExpr getOperand() {
//    result = getTranslatedExpr(expr.getOperand().getFullyConverted())
//  }
//
//  final Opcode getOpcode() {
//    exists(Type resultType |
//      resultType = getResultType() and
//      (
//        (
//          expr instanceof IncrementOperation and
//          if resultType instanceof PointerType then
//            result instanceof Opcode::PointerAdd
//          else
//            result instanceof Opcode::Add
//        ) or
//        (
//          expr instanceof DecrementOperation and
//          if resultType instanceof PointerType then
//            result instanceof Opcode::PointerSub
//          else
//            result instanceof Opcode::Sub
//        )
//      )
//    )
//  }
//}
//
//class TranslatedPrefixCrementOperation extends TranslatedCrementOperation {
//  override PrefixCrementOperation expr;
//
//  override Instruction getResult() {
//    if expr.isPRValueCategory() then (
//      // If this is C, then the result of a prefix crement is a prvalue for the
//      // new value assigned to the operand. If this is C++, then the result is
//      // an lvalue, but that lvalue is being loaded as part of this expression.
//      // EDG doesn't mark this as a load.
//      result = getInstruction(CrementOpTag())
//    )
//    else (
//      // This is C++, where the result is an lvalue for the operand, and that
//      // lvalue is not being loaded as part of this expression.
//      result = getOperand().getResult()
//    )
//  }
//}
//
//class TranslatedPostfixCrementOperation extends TranslatedCrementOperation {
//  override PostfixCrementOperation expr;
//
//  override Instruction getResult() {
//    // The result is a prvalue copy of the original value
//    result = getInstruction(CrementLoadTag())
//  }
//}

class TranslatedArrayExpr extends TranslatedNonConstantExpr {
  override ArrayAccess expr;

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
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::IndexedElementAddress and
    resultType = getResultType() and
    isLValue = true
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    (
      (
        operandTag instanceof LeftOperandTag and
        result = getBaseOperand().getResult()
      ) or
      (
        operandTag instanceof RightOperandTag and
        result = getOffsetOperand().getResult()
      )
    )
  }

  override int getInstructionElementSize(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = 8 //max(getBaseOperand().getResultType().(PointerType).getReferentType().getSize())
  }

  private TranslatedExpr getBaseOperand() {
  	exists (Element el |
  	        expr = el.getParent() and 
  	        el instanceof VariableAccess and
  	        result = getTranslatedExpr(el))
  }

  private TranslatedExpr getOffsetOperand() {
    result = getTranslatedExpr(expr.getChild(0))
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
    Type resultType, boolean isLValue) {
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

//class TranslatedTransparentUnaryOperation extends TranslatedTransparentExpr {
//  override UnaryOperation expr;
//
//  TranslatedTransparentUnaryOperation() {
//    (
//      // *p is the same as p until the result is loaded.
//      expr instanceof PointerDereferenceExpr or
//      // &x is the same as x. &x isn't loadable, but is included
//      // here to avoid having two nearly identical classes.
//      expr instanceof AddressOfExpr
//    )
//  }
//
//  override TranslatedExpr getOperand() {
//    result = getTranslatedExpr(expr.getOperand().getFullyConverted())
//  }
//}

//class TranslatedTransparentConversion extends TranslatedTransparentExpr {
//  override Conversion expr;
//
//  TranslatedTransparentConversion() {
//    (
//      expr instanceof ParenthesizedExpr or
//      expr instanceof ReferenceDereferenceExpr or
//      expr instanceof ReferenceToExpr
//    )
//  }
//
//  override TranslatedExpr getOperand() {
//    result = getTranslatedExpr(expr.getExpr())
//  }
//}

class TranslatedThisExpr extends TranslatedNonConstantExpr {
  override ThisAccess expr;

  override final TranslatedElement getChild(int id) {
    none()
  }

  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::CopyValue and
    resultType = expr.getType() and
    isLValue = false
  }

  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this)
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }

  override final Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getInitializeThisInstruction()
  }

  private Instruction getInitializeThisInstruction() {
    result = getTranslatedFunction(expr.getEnclosingCallable()).getInitializeThisInstruction()
  }
}

abstract class TranslatedVariableAccess extends TranslatedNonConstantExpr {
  override VariableAccess expr;

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getQualifier()  // Might not exist
  }

  final TranslatedExpr getQualifier() {
    result = getTranslatedExpr(expr.getChild(-1))
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override final Instruction getChildSuccessor(TranslatedElement child) {
    child = getQualifier() and result = getInstruction(OnlyInstructionTag())
  }
}

class TranslatedNonFieldVariableAccess extends TranslatedVariableAccess {
  TranslatedNonFieldVariableAccess() {
  	// TODO: Make sure those are enough and correct
    not expr instanceof FieldAccess and
    // Init should take care of this access (check with cpp)
    (not expr.getParent() instanceof LocalVariableDeclAndInitExpr)
  }

  override Instruction getFirstInstruction() {
    if exists(getQualifier()) then
      result = getQualifier().getFirstInstruction()
    else
      result = getInstruction(OnlyInstructionTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    none()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getResultType() and
    isLValue = true
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getIRUserVariable(expr.getEnclosingCallable(), 
      expr.getTarget())
  }
}

class TranslatedFieldAccess extends TranslatedVariableAccess {
  override FieldAccess expr;

  override Instruction getFirstInstruction() {
    result = getQualifier().getFirstInstruction()
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getQualifier().getResult()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FieldAddress and
    resultType = getResultType() and
    isLValue = true
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getTarget()
  }
}

class TranslatedFunctionAccess extends TranslatedNonConstantExpr {
  override CallableAccess expr;

  override TranslatedElement getChild(int id) {
    none()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(OnlyInstructionTag())
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override final Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode instanceof Opcode::FunctionAddress and
    resultType = expr.getType() and
    isLValue = true
  }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr.getTarget()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    none()
  }
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
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode = getOpcode() and
    resultType = getResultType() and
    // TODO: Fix lvalue stuff here
//    if(expr.Category() or expr.hasLValueToRValueConversion()) then
//      isLValue = true
//    else
//      isLValue = false
    isLValue = false
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
  override StringLiteral expr;

  override StringLiteral getInstructionStringLiteral(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = expr
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
    Type resultType, boolean isLValue) {
    opcode = getOpcode() and
    tag = OnlyInstructionTag() and
    resultType = getResultType() and
    isLValue = isResultLValue()
  }

  override final Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }
}

class TranslatedUnaryExpr extends TranslatedSingleInstructionExpr {
  TranslatedUnaryExpr() {
    expr instanceof LogicalNotExpr or
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
    operandTag instanceof UnaryOperandTag
  }

  override final Opcode getOpcode() {
    expr instanceof LogicalNotExpr and result instanceof Opcode::LogicalNot or
    expr instanceof ComplementExpr and result instanceof Opcode::BitComplement or
    expr instanceof UnaryPlusExpr and result instanceof Opcode::CopyValue or
    expr instanceof UnaryMinusExpr and result instanceof Opcode::Negate
  }

  private TranslatedExpr getOperand() {
    result = getTranslatedExpr(
      expr.(UnaryOperation).getOperand()
    )
  }
}

abstract class TranslatedConversion extends TranslatedNonConstantExpr {
  override Cast expr;

  override Instruction getFirstInstruction() {
    result = getOperand().getFirstInstruction()
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getOperand()
  }

  final TranslatedExpr getOperand() {
    result = getTranslatedExpr(expr.(Cast).getExpr())
  }
}

/**
 * Represents the translation of a conversion expression that generates a
 * single instruction.
 */
abstract class TranslatedSingleInstructionConversion extends TranslatedConversion {
  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getOperand() and result = getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    tag = OnlyInstructionTag() and
    opcode = getOpcode() and
    resultType = getResultType() and
    isLValue = isResultLValue()
  }

  override Instruction getResult() {
    result = getInstruction(OnlyInstructionTag())
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag instanceof UnaryOperandTag and
    result = getOperand().getResult()
  }

  /**
   * Gets the opcode of the generated instruction.
   */
  abstract Opcode getOpcode();
}

// TODO: Deal with conversions
///**
// * Represents the translation of a conversion expression that generates a
// * `Convert` instruction.
// */
//class TranslatedSimpleConversion extends TranslatedSingleInstructionConversion {
//  TranslatedSimpleConversion() {
//    expr instanceof ArithmeticConversion or
//    expr instanceof PointerConversion or
//    expr instanceof PointerToMemberConversion or
//    expr instanceof PointerToIntegralConversion or
//    expr instanceof IntegralToPointerConversion or
//    expr instanceof GlvalueConversion or
//    expr instanceof ArrayToPointerConversion or
//    expr instanceof PrvalueAdjustmentConversion or
//    expr instanceof VoidConversion
//  }
//
//  override Opcode getOpcode() {
//    result instanceof Opcode::Convert
//  }
//}

// TODO: Deal with conversions
///**
// * Represents the translation of a `BaseClassConversion` or `DerivedClassConversion`
// * expression.
// */
//class TranslatedInheritanceConversion extends TranslatedSingleInstructionConversion {
//  override InheritanceConversion expr;
//
//
//  override predicate getInstructionInheritance(InstructionTag tag, Class baseClass,
//    Class derivedClass) {
//    tag = OnlyInstructionTag() and
//    baseClass = expr.getBaseClass() and
//    derivedClass = expr.getDerivedClass()
//  }
//
//  override Opcode getOpcode() {
//    if expr instanceof BaseClassConversion then (
//      if expr.(BaseClassConversion).isVirtual() then
//        result instanceof Opcode::ConvertToVirtualBase
//      else
//        result instanceof Opcode::ConvertToBase
//    )
//    else
//      result instanceof Opcode::ConvertToDerived
//  }
//}
//
///**
// * Represents the translation of a `BoolConversion` expression, which generates
// * a comparison with zero.
// */
//class TranslatedBoolConversion extends TranslatedConversion {
//  override BoolConversion expr;
//
//  override Instruction getInstructionSuccessor(InstructionTag tag,
//    EdgeKind kind) {
//    kind instanceof GotoEdge and
//    (
//      (
//        tag = BoolConversionConstantTag() and
//        result = getInstruction(BoolConversionCompareTag())
//      ) or
//      (
//        tag = BoolConversionCompareTag() and
//        result = getParent().getChildSuccessor(this)
//      )
//    )
//  }
//
//  override Instruction getChildSuccessor(TranslatedElement child) {
//    child = getOperand() and result = getInstruction(BoolConversionConstantTag())
//  }
//
//  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
//    Type resultType, boolean ) {
//     = false and
//    (
//      (
//        tag = BoolConversionConstantTag() and
//        opcode instanceof Opcode::Constant and
//        resultType = getOperand().getResultType()
//      ) or
//      (
//        tag = BoolConversionCompareTag() and
//        opcode instanceof Opcode::CompareNE and
//        resultType instanceof BoolType
//      )
//    )
//  }
//
//  override Instruction getResult() {
//    result = getInstruction(BoolConversionCompareTag())
//  }
//
//  override Instruction getInstructionOperand(InstructionTag tag,
//    OperandTag operandTag) {
//    tag = BoolConversionCompareTag() and
//    (
//      (
//        operandTag instanceof LeftOperandTag and
//        result = getOperand().getResult()
//      ) or
//      (
//        operandTag instanceof RightOperandTag and
//        result = getInstruction(BoolConversionConstantTag())
//      )
//    )
//  }
//
//  override string getInstructionConstantValue(InstructionTag tag) {
//    tag = BoolConversionConstantTag() and
//    result = "0"
//  }
//}

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
  expr instanceof RemExpr and result instanceof Opcode::Rem
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
        operandTag instanceof RightOperandTag and
        result = getLeftOperand().getResult()
      ) or
      (
        operandTag instanceof LeftOperandTag and
        result = getRightOperand().getResult()
      )
    )
    else (
      (
        operandTag instanceof LeftOperandTag and
        result = getLeftOperand().getResult()
      ) or
      (
        operandTag instanceof RightOperandTag and
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
      result = 8 //max(getPointerOperand().getResultType().(PointerType).getReferentType().getSize()) TODO: SIZE AGAIN
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
    exists(AddExpr ptrAdd, Type rightType |
      ptrAdd = expr and
      rightType = ptrAdd.getRightOperand().getType() and
      rightType instanceof PointerType
    )
  }

  private TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(
      expr.(BinaryOperation).getLeftOperand()
    )
  }

  private TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(
      expr.(BinaryOperation).getRightOperand()
    )
  }
}

abstract class TranslatedAssignment extends TranslatedNonConstantExpr {
  override Assignment expr;

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getLeftOperand() or
    id = 1 and result = getRightOperand()
  }

  override final Instruction getFirstInstruction() {
    // Evaluation is right-to-left
    result = getRightOperand().getFirstInstruction()
  }

  override final Instruction getResult() {
    //if expr.isPRValueCategory() then (
      // If this is C, then the result of an assignment is a prvalue for the new
      // value assigned to the left operand. If this is C++, then the result is
      // an lvalue, but that lvalue is being loaded as part of this expression.
      // EDG doesn't mark this as a load.
      result = getStoredValue()
    //)
    //else (
      // This is C++, where the result is an lvalue for the left operand,
      // and that lvalue is not being loaded as part of this expression.
      //result = getLeftOperand().getResult()
    //)
  }

  abstract Instruction getStoredValue();

  final TranslatedExpr getLeftOperand() {
    result = getTranslatedExpr(
      expr.getLValue()
    )
  }

  final TranslatedExpr getRightOperand() {
    result = getTranslatedExpr(
      expr.getRValue()
    )
  }
}

class TranslatedAssignExpr extends TranslatedAssignment {
  TranslatedAssignExpr() {
    expr instanceof AssignExpr
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
    Type resultType, boolean isLValue) {
    tag = AssignmentStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getResultType() and
    isLValue = false
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    tag = AssignmentStoreTag() and
    (
      (
        operandTag instanceof AddressOperandTag and
        result = getLeftOperand().getResult()
      ) or
      (
        operandTag instanceof StoreValueOperandTag and
        result = getRightOperand().getResult()
      )
    )
  }

  override Instruction getStoredValue() {
    result = getRightOperand().getResult()
  }
}

class TranslatedAssignOperation extends TranslatedAssignment {
  override AssignOperation expr;

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
    if(expr instanceof AssignLShiftExpr or
      expr instanceof AssignRShiftExpr) then (
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
    expr instanceof AssignAddExpr and result instanceof Opcode::Add or
    expr instanceof AssignSubExpr and result instanceof Opcode::Sub or
    expr instanceof AssignMulExpr and result instanceof Opcode::Mul or
    expr instanceof AssignDivExpr and result instanceof Opcode::Div or
    expr instanceof AssignRemExpr and result instanceof Opcode::Rem or
    expr instanceof AssignAndExpr and result instanceof Opcode::BitAnd or
    expr instanceof AssignOrExpr and result instanceof Opcode::BitOr or
    expr instanceof AssignXorExpr and result instanceof Opcode::BitXor or
    expr instanceof AssignLShiftExpr and result instanceof Opcode::ShiftLeft or
    expr instanceof AssignRShiftExpr and result instanceof Opcode::ShiftRight // or
    // TODO: THE CASES ABOVE DEAL WITH POINTERS
//    expr instanceof AssignPointerAddExpr and result instanceof Opcode::PointerAdd or
//    expr instanceof AssignPointerSubExpr and result instanceof Opcode::PointerSub
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
    isLValue = false and
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
      // TODO: ADD AND SUB FOR POITNER ARITH (WAS POINTERADD AND POINTERSUB)
      (opcode instanceof Opcode::Add or opcode instanceof Opcode::Sub)
    ) and
    result = 8 //max(getResultType().(PointerType).getReferentType().getSize()) TODO: DEAL WITH SIZE
  }

  override Instruction getInstructionOperand(InstructionTag tag,
    OperandTag operandTag) {
    (
      tag = AssignOperationLoadTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getLeftOperand().getResult()
        ) or
        (
          operandTag instanceof LoadOperandTag and
          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
        )
      )
    ) or
    (
      leftOperandNeedsConversion() and
      tag = AssignOperationConvertLeftTag() and
      operandTag instanceof UnaryOperandTag and
      result = getInstruction(AssignOperationLoadTag())
    ) or
    (
      tag = AssignOperationOpTag() and
      (
        (
          operandTag instanceof LeftOperandTag and
          if leftOperandNeedsConversion() then
            result = getInstruction(AssignOperationConvertLeftTag())
          else
            result = getInstruction(AssignOperationLoadTag())
        ) or
        (
          operandTag instanceof RightOperandTag and
          result = getRightOperand().getResult()
        )
      )
    ) or
    (
      leftOperandNeedsConversion() and
      tag = AssignOperationConvertResultTag() and
      operandTag instanceof UnaryOperandTag and
      result = getInstruction(AssignOperationOpTag())
    ) or
    (
      tag = AssignmentStoreTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getLeftOperand().getResult()
        ) or
        (
          operandTag instanceof StoreValueOperandTag and
          result = getStoredValue()
        )
      )
    )
  }
}

// TODO: Fix allocations
///**
// * The IR translation of the allocation size argument passed to `operator new`
// * in a `new` expression.
// *
// * We have to synthesize this because not all `NewExpr` nodes have an allocator
// * call, and even the ones that do pass an `ErrorExpr` as the argument.
// */
//abstract class TranslatedAllocationSize extends TranslatedExpr,
//    TTranslatedAllocationSize {
//  override NewOrNewArrayExpr expr;
//  
//  TranslatedAllocationSize() {
//    this = TTranslatedAllocationSize(expr)
//  }
//
//  override final string toString() {
//    result = "Allocation size for " + expr.toString()
//  }
//
//  override final predicate producesExprResult() {
//    none()
//  }
//
//  override final Instruction getResult() {
//    result = getInstruction(AllocationSizeTag())
//  }
//}
//
//TranslatedAllocationSize getTranslatedAllocationSize(NewOrNewArrayExpr newExpr) {
//  result.getAST() = newExpr
//}

///**
// * The IR translation of a constant allocation size.
// *
// * The allocation size for a `new` expression is always a constant. The
// * allocation size for a `new[]` expression is a constant if the array extent
// * is a compile-time constant.
// */
//class TranslatedConstantAllocationSize extends TranslatedAllocationSize {
//  TranslatedConstantAllocationSize() {
//    not exists(expr.(NewArrayExpr).getExtent())
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getInstruction(AllocationSizeTag())
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//      Type resultType, boolean ) {
//    tag = AllocationSizeTag() and
//    opcode instanceof Opcode::Constant and
//    resultType = expr.getAllocator().getParameter(0).getUnspecifiedType() and
//     = false
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//      EdgeKind kind) {
//    tag = AllocationSizeTag() and
//    kind instanceof GotoEdge and
//    result = getParent().getChildSuccessor(this)
//  }
//
//  override final TranslatedElement getChild(int id) {
//    none()
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    none()
//  }
//
//  override final string getInstructionConstantValue(InstructionTag tag) {
//    tag = AllocationSizeTag() and
//    result = expr.getAllocatedType().getSize().toString()
//  }
//}

///**
// * The IR translation of a non-constant allocation size.
// *
// * This class is used for the allocation size of a `new[]` expression where the
// * array extent is not known at compile time. It performs the multiplication of
// * the extent by the element size.
// */
//class TranslatedNonConstantAllocationSize extends TranslatedAllocationSize {
//  override NewArrayExpr expr;
//
//  TranslatedNonConstantAllocationSize() {
//    exists(expr.getExtent())
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getExtent().getFirstInstruction()
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//      Type resultType, boolean ) {
//     = false and
//    resultType = expr.getAllocator().getParameter(0).getUnspecifiedType() and
//    (
//      // Convert the extent to `size_t`, because the AST doesn't do this already.
//      tag = AllocationExtentConvertTag() and opcode instanceof Opcode::Convert or
//      tag = AllocationElementSizeTag() and opcode instanceof Opcode::Constant or
//      tag = AllocationSizeTag() and opcode instanceof Opcode::Mul // REVIEW: Overflow?
//    )
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//      EdgeKind kind) {
//    kind instanceof GotoEdge and
//    (
//      (
//        tag = AllocationExtentConvertTag() and
//        result = getInstruction(AllocationElementSizeTag())
//      ) or
//      (
//        tag = AllocationElementSizeTag() and
//        result = getInstruction(AllocationSizeTag())
//      ) or
//      (
//        tag = AllocationSizeTag() and
//        result = getParent().getChildSuccessor(this)
//      )
//    )
//  }
//
//  override final TranslatedElement getChild(int id) {
//    id = 0 and result = getExtent()
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    child = getExtent() and
//    result = getInstruction(AllocationExtentConvertTag())
//  }
//
//  override final string getInstructionConstantValue(InstructionTag tag) {
//    tag = AllocationElementSizeTag() and
//    result = expr.getAllocatedElementType().getSize().toString()
//  }
//
//  override final Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    (
//      tag = AllocationSizeTag() and
//      (
//        operandTag instanceof LeftOperandTag and result = getInstruction(AllocationExtentConvertTag()) or
//        operandTag instanceof RightOperandTag and result = getInstruction(AllocationElementSizeTag())
//      )
//    ) or
//    (
//      tag = AllocationExtentConvertTag() and
//      operandTag instanceof UnaryOperandTag and
//      result = getExtent().getResult()
//    )
//  }
//
//  private TranslatedExpr getExtent() {
//    result = getTranslatedExpr(expr.getExtent().getFullyConverted())
//  }
//}

/**
 * The IR translation of a call to `operator new` as part of a `new` expression.
 */
//class TranslatedAllocatorCall extends TTranslatedAllocatorCall,
//    TranslatedExpr {
//  override ObjectCreation expr;
//
//  TranslatedAllocatorCall() {
//    this = TTranslatedAllocatorCall(expr)
//  }
//    
//  override final string toString() {
//    result = "Allocator call for " + expr.toString()
//  }
//
//  override final predicate producesExprResult() {
//    none()
//  }
//
//  override final TranslatedElement getChild(int id) {
//      none()
//  }
//    
//  // TODO: Will probably need a side effect instruction
//  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
//      Type resultType, boolean isLValue) {
//      tag = NewObjTag() and
//      opcode instanceof Opcode::NewObj and 
//      resultType = expr.getType() and
//      isLValue = false
//  }
//  
//  override final Instruction getFirstInstruction() {
//    result = getInstruction(NewObjTag())
//  }
//  
//  override final Instruction getChildSuccessor(TranslatedElement element) {
//    none()  
//  }
//    
//  override final Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
//    tag = NewObjTag() and
//    kind instanceof GotoEdge and
//    result = getParent().getChildSuccessor(this)
//  }
//  
//  override final Instruction getResult() {
//    none()
//  }
//}

//TranslatedAllocatorCall getTranslatedAllocatorCall(ObjectCreation newExpr) {
//  result.getAST() = newExpr
//}

//class TranslatedObjectCreation extends TranslatedNonConstantExpr,
//    InitializationContext {
//  override ObjectCreation expr;
//
//  override final TranslatedElement getChild(int id) {
//    id = 0 and result = getInitialization()
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//      Type resultType, boolean isLValue) {
//      tag = NewObjTag() and
//      opcode instanceof Opcode::NewObj and 
//      resultType = expr.getType() and
//      isLValue = false
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getInstruction(NewObjTag())
//  }
//
//  override final Instruction getResult() {
//    result = getInstruction(NewObjTag())
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//      EdgeKind kind) {
//    kind instanceof GotoEdge and
//    tag = NewObjTag() and
//    if exists(getInitialization()) then
//      result = getInitialization().getFirstInstruction()
//    else
//      result = getParent().getChildSuccessor(this)
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    child = getInitialization() and result = getParent().getChildSuccessor(this)
//  }
//
//  override final Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    none()
//  }
//  
//  override final Instruction getTargetAddress() {
//    result = getInstruction(NewObjTag())
//  }
//
//  override final Type getTargetType() {
//    result = expr.getType()
//  }
//
//  final TranslatedInitialization getInitialization() {
//    result = getTranslatedInitialization(expr)
//  }
//}

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

// TODO: Reason about how to translate destructors in C# (finalizers + dispose)
///**
// * Represents the IR translation of the destruction of a field from within
// * the destructor of the field's declaring class.
// */
//class TranslatedDestructorFieldDestruction extends TranslatedNonConstantExpr,
//    StructorCallContext {
//  override DestructorFieldDestruction expr;
//
//  override final TranslatedElement getChild(int id) {
//    id = 0 and result = getDestructorCall()
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//    Type resultType, boolean ) {
//    tag = OnlyInstructionTag() and
//    opcode instanceof Opcode::FieldAddress and
//    resultType = expr.getTarget().getUnspecifiedType() and
//     = true
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//    EdgeKind kind) {
//    tag = OnlyInstructionTag() and
//    kind instanceof GotoEdge and
//    result = getDestructorCall().getFirstInstruction()
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    child = getDestructorCall() and
//    result = getParent().getChildSuccessor(this)
//  }
//
//  override final Instruction getResult() {
//    none()
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getInstruction(OnlyInstructionTag())
//  }
//
//  override final Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
//    tag = OnlyInstructionTag() and
//    operandTag instanceof UnaryOperandTag and
//    result = getTranslatedFunction(expr.getEnclosingFunction()).getInitializeThisInstruction()
//  }
//
//  override final Field getInstructionField(InstructionTag tag) {
//    tag = OnlyInstructionTag() and
//    result = expr.getTarget()
//  }
//
//  override final Instruction getReceiver() {
//    result = getInstruction(OnlyInstructionTag())
//  }
//
//  private TranslatedExpr getDestructorCall() {
//    result = getTranslatedExpr(expr.getExpr())
//  }
// }

class TranslatedConditionalExpr extends TranslatedNonConstantExpr,
  ConditionContext {
  override ConditionalExpr expr;

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getCondition() or
    id = 1 and result = getThen() or
    id = 2 and result = getElse()
  }

  override Instruction getFirstInstruction() {
    result = getCondition().getFirstInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
    Type resultType, boolean isLValue) {
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
        isLValue = true
      ) or
      (
        (
          (not thenIsVoid() and (tag = ConditionValueTrueStoreTag())) or
          (not elseIsVoid() and (tag = ConditionValueFalseStoreTag()))
        ) and
        opcode instanceof Opcode::Store and
        resultType = getResultType() and
        isLValue = false
      ) or
      (
        tag = ConditionValueResultLoadTag() and
        opcode instanceof Opcode::Load and
        resultType = getResultType() and
        isLValue = isResultLValue()
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
            operandTag instanceof AddressOperandTag and
            result = getInstruction(ConditionValueTrueTempAddressTag())
          ) or
          (
            operandTag instanceof StoreValueOperandTag and
            result = getThen().getResult()
          )
        )
      ) or
      (
        not elseIsVoid() and
        tag = ConditionValueFalseStoreTag() and
        (
          (
            operandTag instanceof AddressOperandTag and
            result = getInstruction(ConditionValueFalseTempAddressTag())
          ) or
          (
            operandTag instanceof StoreValueOperandTag and
            result = getElse().getResult()
          )
        )
      ) or
      (
        tag = ConditionValueResultLoadTag() and
        (
          (
            operandTag instanceof AddressOperandTag and
            result = getInstruction(ConditionValueResultTempAddressTag())
          ) or
          (
            operandTag instanceof LoadOperandTag and
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
    result = getTranslatedCondition(expr.getCondition())
  }

  private TranslatedExpr getThen() {
    result = getTranslatedExpr(expr.getThen())
  }

  private TranslatedExpr getElse() {
    result = getTranslatedExpr(expr.getElse())
  }

  private predicate thenIsVoid() {
    getThen().getResultType() instanceof VoidType or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    expr.getThen() instanceof ThrowExpr
  }

  private predicate elseIsVoid() {
    getElse().getResultType() instanceof VoidType or
    // A `ThrowExpr.getType()` incorrectly returns the type of exception being
    // thrown, rather than `void`. Handle that case here.
    expr.getElse() instanceof ThrowExpr
  }

  private predicate resultIsVoid() {
    getResultType() instanceof VoidType
  }
}

/**
 * IR translation of a `throw` expression.
 */
abstract class TranslatedThrowExpr extends TranslatedNonConstantExpr {
  override ThrowExpr expr;


  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isLValue) {
    tag = ThrowTag() and
    opcode = getThrowOpcode() and
    resultType instanceof VoidType and
    isLValue = false
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
    not expr instanceof ThrowExpr
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isLValue) {
    TranslatedThrowExpr.super.hasInstruction(opcode, tag, resultType, isLValue) or
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getExceptionType() and
    isLValue = true
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
    result = getIRTempVariable(expr, ThrowTempVar())
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
        operandTag instanceof AddressOperandTag and
        result = getInstruction(InitializerVariableAddressTag())
      ) or
      (
        operandTag instanceof LoadOperandTag and
        result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
      )
    )
  }

  override final Type getInstructionOperandType(InstructionTag tag,
      TypedOperandTag operandTag) {
    tag = ThrowTag() and
    operandTag instanceof LoadOperandTag and
    result = getExceptionType()
  }

  override Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() {
    result = getExceptionType()
  }

  TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(
      expr.getExpr())
  }

  override final Opcode getThrowOpcode() {
    result instanceof Opcode::ThrowValue
  }

  private Type getExceptionType() {
    result = expr.getType()
  }
}

// TODO: Should be handeled by the normal throw in C#
///**
// * IR translation of a `throw` expression with no argument (e.g. `throw;`).
// */
//class TranslatedReThrowExpr extends TranslatedThrowExpr {
//  override ReThrowExpr expr;
//
//  override TranslatedElement getChild(int id) {
//    none()
//  }
//
//  override Instruction getFirstInstruction() {
//    result = getInstruction(ThrowTag())
//  }
//
//  override Instruction getChildSuccessor(TranslatedElement child) {
//    none()
//  }
//
//  override final Opcode getThrowOpcode() {
//    result instanceof Opcode::ReThrow
//  }
//}

// TODO: Probably does not have a translation in C#
///**
// * The IR translation of a built-in operation (i.e. anything that extends
// * `BuiltInOperation`).
// */
//abstract class TranslatedBuiltInOperation extends TranslatedNonConstantExpr {
//  override final Instruction getResult() {
//    result = getInstruction(OnlyInstructionTag())
//  }
//
//  override final Instruction getFirstInstruction() {
//    if exists(getChild(0)) then 
//      result = getChild(0).getFirstInstruction()
//    else
//      result = getInstruction(OnlyInstructionTag())
//  }
//
//  override final TranslatedElement getChild(int id) {
//    result = getTranslatedExpr(expr.getChild(id))
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//      EdgeKind kind) {
//    tag = OnlyInstructionTag() and
//    kind instanceof GotoEdge and
//    result = getParent().getChildSuccessor(this)
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    exists(int id |
//      child = getChild(id) and
//      (
//        result = getChild(id + 1).getFirstInstruction() or
//        not exists(getChild(id + 1)) and result = getInstruction(OnlyInstructionTag())
//      )
//    )
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//      Type resultType, boolean isLValue) {
//    tag = OnlyInstructionTag() and
//    opcode = getOpcode() and
//    resultType = getResultType() and
//    isLValue = isResultLValue()
//  }
//
//  override final Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    tag = OnlyInstructionTag() and
//    exists(int index |
//      operandTag = positionalArgumentOperand(index) and
//      result = getChild(index).(TranslatedExpr).getResult()
//    )
//  }
//
//  abstract Opcode getOpcode();
//}


// TODO: See how and if we would adapt those to C#
///**
// * The IR translation of a `BuiltInVarArgsStart` expression.
// */
//class TranslatedVarArgsStart extends TranslatedBuiltInOperation {
//  override BuiltInVarArgsStart expr;
//
//  override final Opcode getOpcode() {
//    result instanceof Opcode::VarArgsStart
//  }
//}
//
///**
// * The IR translation of a `BuiltInVarArgsEnd` expression.
// */
//class TranslatedVarArgsEnd extends TranslatedBuiltInOperation {
//  override BuiltInVarArgsEnd expr;
//
//  override final Opcode getOpcode() {
//    result instanceof Opcode::VarArgsEnd
//  }
//}
//
///**
// * The IR translation of a `BuiltInVarArg` expression.
// */
//class TranslatedVarArg extends TranslatedBuiltInOperation {
//  override BuiltInVarArg expr;
//
//  override final Opcode getOpcode() {
//    result instanceof Opcode::VarArg
//  }
//}
//
///**
// * The IR translation of a `BuiltInVarArgCopy` expression.
// */
//class TranslatedVarArgCopy extends TranslatedBuiltInOperation {
//  override BuiltInVarArgCopy expr;
//
//  override final Opcode getOpcode() {
//    result instanceof Opcode::VarArgCopy
//  }
//}
//
///**
// * The IR translation of a `new` or `new[]` expression.
// */
//abstract class TranslatedNewExpr extends TranslatedNonConstantExpr,
//    InitializationContext {
//  override ObjectCreation expr;
//
//  override final TranslatedElement getChild(int id) {
//    id = 0 and result = getAllocatorCall() or
//    id = 1 and result = getInitialization()
//  }
//
//  final TranslatedInitialization getInitialization() {
//    result = getTranslatedInitialization(expr.getInitializer())
//  }
//
//  override final predicate hasInstruction(Opcode opcode, InstructionTag tag,
//      Type resultType, boolean isLValue) {
//    none()
//  }
//
//  override final Instruction getFirstInstruction() {
//    result = getAllocatorCall().getFirstInstruction()
//  }
//
//  override final Instruction getResult() {
//    result = getInstruction(OnlyInstructionTag())
//  }
//
//  override final Instruction getInstructionSuccessor(InstructionTag tag,
//      EdgeKind kind) {
//    kind instanceof GotoEdge and
//    tag = OnlyInstructionTag() and
//    if exists(getInitialization()) then
//      result = getInitialization().getFirstInstruction()
//    else
//      result = getParent().getChildSuccessor(this)
//  }
//
//  override final Type getTargetType() {
//    result = expr.getType()
//  }
//
//  override final Instruction getChildSuccessor(TranslatedElement child) {
//    child = getAllocatorCall() and result = getInstruction(OnlyInstructionTag()) or
//    child = getInitialization() and result = getParent().getChildSuccessor(this)
//  }
//
//  override final Instruction getInstructionOperand(InstructionTag tag,
//      OperandTag operandTag) {
//    tag = OnlyInstructionTag() and
//    operandTag instanceof UnaryOperandTag and
//    result = getAllocatorCall().getResult()
//  }
//  
//  override final Instruction getTargetAddress() {
//    result = getInstruction(OnlyInstructionTag())
//  }
//
//  private TranslatedAllocatorCall getAllocatorCall() {
//    result = getTranslatedAllocatorCall(expr)
//  }
//}


/**
 * The IR translation of a `ConditionDeclExpr`, which represents the value of the declared variable
 * after conversion to `bool` in code such as:
 * ```
 * if (int* p = &x) {
 * }
 * ```
 */
 // TODO: DOESNT EXIST IN C#
//class TranslatedConditionDeclExpr extends TranslatedNonConstantExpr {
//  override ConditionDeclExpr expr;
//
//  override final Instruction getFirstInstruction() {
//    result = getDecl().getFirstInstruction()
//  }
//
//  override final TranslatedElement getChild(int id) {
//    id = 0 and result = getDecl() or
//    id = 1 and result = getConditionExpr()
//  }
//
//  override Instruction getResult() {
//    result = getConditionExpr().getResult()
//  }
//
//  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
//    none()
//  }
//
//  override Instruction getChildSuccessor(TranslatedElement child) {
//    (
//      child = getDecl() and
//      result = getConditionExpr().getFirstInstruction()
//    ) or
//    child = getConditionExpr() and result = getParent().getChildSuccessor(this)
//  }
//
//  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType,
//      boolean ) {
//    none()
//  }
//
//  private TranslatedConditionDecl getDecl() {
//    result = getTranslatedConditionDecl(expr)
//  }
//
//  private TranslatedExpr getConditionExpr() {
//    result = getTranslatedExpr(expr.getVariableAccess().getFullyConverted())
//  }
//}

/**
 * The IR translation of a lambda expression. This initializes a temporary variable whose type is that of the lambda,
 * using the initializer list that represents the captures of the lambda.
 */
class TranslatedLambdaExpr extends TranslatedNonConstantExpr, InitializationContext {
  override LambdaExpr expr;

  override final Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override final TranslatedElement getChild(int id) {
    id = 0 and result = getInitialization()
  }

  override Instruction getResult() {
    result = getInstruction(LoadTag())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    (
      tag = InitializerVariableAddressTag() and
      kind instanceof GotoEdge and
      result = getInstruction(InitializerStoreTag())
    ) or
    (
      tag = InitializerStoreTag() and
      kind instanceof GotoEdge and
      (
        result = getInitialization().getFirstInstruction() or
        not hasInitializer() and result = getInstruction(LoadTag())
      )
    ) or
    (
      tag = LoadTag() and
      kind instanceof GotoEdge and
      result = getParent().getChildSuccessor(this)
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and
    result = getInstruction(LoadTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Type resultType,
      boolean isLValue) {
    (
      tag = InitializerVariableAddressTag() and
      opcode instanceof Opcode::VariableAddress and
      resultType = getResultType() and
      isLValue = true
    ) or
    (
      tag = InitializerStoreTag() and
      opcode instanceof Opcode::Uninitialized and
      resultType = getResultType() and
      isLValue = false
    ) or
    (
      tag = LoadTag() and
      opcode instanceof Opcode::Load and
      resultType = getResultType() and
      isLValue = false
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    (
      tag = InitializerStoreTag() and
      operandTag instanceof AddressOperandTag and
      result = getInstruction(InitializerVariableAddressTag())
    ) or
    (
      tag = LoadTag() and
      (
        (
          operandTag instanceof AddressOperandTag and
          result = getInstruction(InitializerVariableAddressTag())
        ) or
        (
          operandTag instanceof LoadOperandTag and
          result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
        )
      )
    )
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerVariableAddressTag() or
      tag = InitializerStoreTag()
    ) and
    result = getTempVariable(LambdaTempVar())
  }

  override predicate hasTempVariable(TempVariableTag tag, Type type) {
    tag = LambdaTempVar() and
    type = getResultType()
  }

  override final Instruction getTargetAddress() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  override final Type getTargetType() {
    result = getResultType()
  }

  private predicate hasInitializer() {
    exists(getInitialization())
  }

  private TranslatedInitialization getInitialization() {
    result = getTranslatedInitialization(expr.getChild(0))
  }
}
