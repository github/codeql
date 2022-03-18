/**
 * File that provides the desugaring of a `Foreach` stmt.
 * Since Roslyn rewrites it in quite a few ways,
 * for now only desugar it to a "canonical" form.
 * Also we only deal with foreach stmts where there is only
 * one declaration (see below).
 * For example the code:
 *    ```csharp
 *      foreach(var item in some_enumerable) {
 *        // body
 *      }
 *    ```
 * gets desugared to:
 *    ```csharp
 *      Enumerator e = some_enumerable.GetEnumerator();
 *      try
 *      {
 *        while(e.MoveNext())
 *        {
 *          int current = e.Current;
 *          //body
 *        }
 *      }
 *      finally
 *      {
 *        e.Dispose();
 *      }
 *    ```
 * More info about the desugaring process for `foreach` stmts:
 * https://github.com/dotnet/roslyn/blob/master/src/Compilers/CSharp/Portable/Lowering/LocalRewriter/LocalRewriter_ForEachStatement.cs
 * A TODO is to not call `Dispose` no matter what, but desugar the `finally` as an `AsExpr` (cast to IDisposable),
 * the call to `Dispose` being made only if the result of the `AsExpr` is not null.
 * This is a rough approximation which will need further refining.
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.TempVariableTag
private import experimental.ir.implementation.raw.internal.InstructionTag
private import experimental.ir.implementation.raw.internal.TranslatedExpr
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedStmt
private import experimental.ir.implementation.raw.internal.common.TranslatedConditionBase
private import experimental.ir.implementation.raw.internal.common.TranslatedExprBase
private import experimental.ir.internal.IRCSharpLanguage as Language
private import Common
private import internal.TranslatedCompilerGeneratedStmt
private import internal.TranslatedCompilerGeneratedCall
private import internal.TranslatedCompilerGeneratedDeclaration
private import internal.TranslatedCompilerGeneratedCondition
private import internal.TranslatedCompilerGeneratedElement

/**
 * Module that exposes the functions needed for the translation of the `foreach` stmt.
 */
module ForeachElements {
  TranslatedForeachTry getTry(ForeachStmt generatedBy) { result.getAst() = generatedBy }

  TranslatedForeachEnumerator getEnumDecl(ForeachStmt generatedBy) { result.getAst() = generatedBy }

  int noGeneratedElements() { result = 13 }
}

private class TranslatedForeachTry extends TranslatedCompilerGeneratedTry,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachTry() { this = TTranslatedCompilerGeneratedElement(generatedBy, 0) }

  override TranslatedElement getFinally() {
    exists(TranslatedForeachFinally ff |
      ff.getAst() = generatedBy and
      result = ff
    )
  }

  override TranslatedElement getBody() {
    exists(TranslatedForeachWhile fw |
      fw.getAst() = generatedBy and
      result = fw
    )
  }
}

/**
 * The translation of the finally block.
 */
private class TranslatedForeachFinally extends TranslatedCompilerGeneratedBlock,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachFinally() { this = TTranslatedCompilerGeneratedElement(generatedBy, 1) }

  override TranslatedElement getStmt(int index) {
    index = 0 and
    exists(TranslatedForeachDispose fd |
      fd.getAst() = generatedBy and
      result = fd
    )
  }
}

/**
 * The compiler generated while loop.
 * Note that this class is not private since it is needed in `IRConstruction.qll`,
 * to correctly mark which edges should be back edges.
 */
class TranslatedForeachWhile extends TranslatedCompilerGeneratedStmt, ConditionContext,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachWhile() { this = TTranslatedCompilerGeneratedElement(generatedBy, 2) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getFirstInstruction() { result = getCondition().getFirstInstruction() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInit() and result = getBody().getFirstInstruction()
    or
    child = getBody() and result = getCondition().getFirstInstruction()
  }

  override TranslatedElement getChild(int id) {
    id = 0 and result = getCondition()
    or
    id = 1 and result = getInit()
    or
    id = 2 and result = getBody()
  }

  final override Instruction getChildTrueSuccessor(ConditionBase child) {
    child = getCondition() and result = getInit().getFirstInstruction()
  }

  final override Instruction getChildFalseSuccessor(ConditionBase child) {
    child = getCondition() and result = getParent().getChildSuccessor(this)
  }

  TranslatedStmt getBody() { result = getTranslatedStmt(generatedBy.getBody()) }

  TranslatedElement getInit() {
    exists(TranslatedForeachIterVar iv |
      iv.getAst() = generatedBy and
      result = iv
    )
  }

  ValueConditionBase getCondition() {
    exists(TranslatedForeachWhileCondition cond |
      cond.getAst() = generatedBy and
      result = cond
    )
  }
}

/**
 * The translation of the call to the `MoveNext` method, used as a condition for the while.
 */
private class TranslatedForeachMoveNext extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachMoveNext() { this = TTranslatedCompilerGeneratedElement(generatedBy, 3) }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    result = generatedBy.getMoveNext()
  }

  override Type getCallResultType() { result instanceof BoolType }

  override TranslatedExpr getArgument(int id) { none() }

  override TranslatedExprBase getQualifier() {
    exists(TranslatedMoveNextEnumAcc acc |
      acc.getAst() = generatedBy and
      result = acc
    )
  }

  override Instruction getQualifierResult() { result = getQualifier().getResult() }
}

/**
 * The translation of the call to retrieve the enumerator.
 */
private class TranslatedForeachGetEnumerator extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachGetEnumerator() { this = TTranslatedCompilerGeneratedElement(generatedBy, 4) }

  final override Type getCallResultType() {
    result = getInstructionFunction(CallTargetTag()).getReturnType()
  }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    result = generatedBy.getGetEnumerator()
  }

  override TranslatedExpr getArgument(int id) { none() }

  override TranslatedExprBase getQualifier() {
    result = getTranslatedExpr(generatedBy.getIterableExpr())
  }

  override Instruction getQualifierResult() { result = getQualifier().getResult() }
}

/**
 * The translation of the call to the getter method of the `Current` property of the enumerator.
 */
private class TranslatedForeachCurrent extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachCurrent() { this = TTranslatedCompilerGeneratedElement(generatedBy, 5) }

  override Type getCallResultType() { result = generatedBy.getElementType() }

  override TranslatedExpr getArgument(int id) { none() }

  override TranslatedExprBase getQualifier() {
    exists(TranslatedForeachCurrentEnumAcc acc |
      acc.getAst() = generatedBy and
      result = acc
    )
  }

  override Instruction getQualifierResult() { result = getQualifier().getResult() }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    result = generatedBy.getCurrent().getGetter()
  }
}

/**
 * The translation of the call to dispose (inside the finally block)
 */
private class TranslatedForeachDispose extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachDispose() { this = TTranslatedCompilerGeneratedElement(generatedBy, 6) }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    result = generatedBy.getDispose()
  }

  final override Type getCallResultType() { result instanceof VoidType }

  override TranslatedExpr getArgument(int id) { none() }

  override TranslatedExprBase getQualifier() {
    exists(TranslatedForeachDisposeEnumAcc acc |
      acc.getAst() = generatedBy and
      result = acc
    )
  }

  override Instruction getQualifierResult() { result = getQualifier().getResult() }
}

/**
 * The condition for the while, ie. a call to MoveNext.
 */
private class TranslatedForeachWhileCondition extends TranslatedCompilerGeneratedValueCondition,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachWhileCondition() { this = TTranslatedCompilerGeneratedElement(generatedBy, 7) }

  override TranslatedCompilerGeneratedCall getValueExpr() {
    exists(TranslatedForeachMoveNext mn |
      mn.getAst() = generatedBy and
      result = mn
    )
  }

  override Instruction valueExprResult() { result = getValueExpr().getResult() }
}

/**
 * Class that represents that translation of the declaration that happens before the `try ... finally` block (the
 * declaration of the `temporary` enumerator variable)
 */
private class TranslatedForeachEnumerator extends TranslatedCompilerGeneratedDeclaration,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachEnumerator() { this = TTranslatedCompilerGeneratedElement(generatedBy, 8) }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = ForeachEnumTempVar() and
    type = getTypeForPRValue(getInitialization().getCallResultType())
  }

  override IRTempVariable getIRVariable() {
    result = getIRTempVariable(generatedBy, ForeachEnumTempVar())
  }

  override TranslatedCompilerGeneratedCall getInitialization() {
    exists(TranslatedForeachGetEnumerator ge |
      ge.getAst() = generatedBy and
      result = ge
    )
  }

  override Instruction getInitializationResult() { result = getInitialization().getResult() }
}

/**
 * Class that represents that translation of the declaration that's happening inside the body of the while.
 */
private class TranslatedForeachIterVar extends TranslatedCompilerGeneratedDeclaration,
  TTranslatedCompilerGeneratedElement {
  override ForeachStmt generatedBy;

  TranslatedForeachIterVar() { this = TTranslatedCompilerGeneratedElement(generatedBy, 9) }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRVariable()
  }

  override IRVariable getIRVariable() {
    result = getIRUserVariable(getFunction(), generatedBy.getAVariable())
  }

  override TranslatedCompilerGeneratedCall getInitialization() {
    exists(TranslatedForeachCurrent crtProp |
      crtProp.getAst() = generatedBy and
      result = crtProp
    )
  }

  override Instruction getInitializationResult() { result = getInitialization().getResult() }
}

/**
 * Class that represents that translation of access to the temporary enumerator variable. Used as the qualifier
 * for the call to `MoveNext`.
 */
private class TranslatedMoveNextEnumAcc extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override ForeachStmt generatedBy;

  TranslatedMoveNextEnumAcc() { this = TTranslatedCompilerGeneratedElement(generatedBy, 10) }

  override Type getResultType() { result instanceof BoolType }

  override Type getVariableType() {
    exists(TranslatedForeachGetEnumerator ge |
      ge.getAst() = generatedBy and
      result = ge.getCallResultType()
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = ForeachEnumTempVar() and
    type = getTypeForPRValue(getVariableType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(ForeachEnumTempVar())
  }

  override predicate needsLoad() { any() }
}

/**
 * Class that represents that translation of access to the temporary enumerator variable. Used as the qualifier
 * for the call to the getter of the property `Current`.
 */
private class TranslatedForeachCurrentEnumAcc extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override ForeachStmt generatedBy;

  TranslatedForeachCurrentEnumAcc() { this = TTranslatedCompilerGeneratedElement(generatedBy, 11) }

  override Type getResultType() { result instanceof BoolType }

  override Type getVariableType() {
    exists(TranslatedForeachGetEnumerator ge |
      ge.getAst() = generatedBy and
      result = ge.getCallResultType()
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = ForeachEnumTempVar() and
    type = getTypeForPRValue(getVariableType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(ForeachEnumTempVar())
  }

  override predicate needsLoad() { any() }
}

/**
 * Class that represents that translation of access to the temporary enumerator variable. Used as the qualifier
 * for the call to `Dispose`.
 */
private class TranslatedForeachDisposeEnumAcc extends TTranslatedCompilerGeneratedElement,
  TranslatedCompilerGeneratedVariableAccess {
  override ForeachStmt generatedBy;

  TranslatedForeachDisposeEnumAcc() { this = TTranslatedCompilerGeneratedElement(generatedBy, 12) }

  override Type getResultType() { result instanceof BoolType }

  override Type getVariableType() {
    exists(TranslatedForeachGetEnumerator ge |
      ge.getAst() = generatedBy and
      result = ge.getCallResultType()
    )
  }

  override predicate hasTempVariable(TempVariableTag tag, CSharpType type) {
    tag = ForeachEnumTempVar() and
    type = getTypeForPRValue(getVariableType())
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = AddressTag() and
    result = getTempVariable(ForeachEnumTempVar())
  }

  override predicate needsLoad() { any() }
}
