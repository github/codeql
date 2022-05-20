/**
 * File that translates the desugaring of delegate creation and call expressions.
 * In particular, in the IR we explicitly allocate a new object and call the delegate's constructor when
 * creating a new one.
 * For the delegate call, we explicitly call the `Invoke` method.
 * More information about the internals:
 * https://github.com/dotnet/roslyn/blob/master/src/Compilers/CSharp/Portable/Lowering/LocalRewriter/LocalRewriter_DelegateCreationExpression.cs
 * This is a rough approximation which will need further refining.
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.internal.TempVariableTag
private import experimental.ir.implementation.raw.internal.InstructionTag
private import experimental.ir.implementation.raw.internal.TranslatedExpr
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedStmt
private import experimental.ir.implementation.raw.internal.TranslatedCondition
private import experimental.ir.internal.IRCSharpLanguage as Language
private import Common
private import internal.TranslatedCompilerGeneratedCall
private import experimental.ir.implementation.raw.internal.common.TranslatedExprBase

/**
 * Module that exposes the functions needed for the translation of the delegate creation and call expressions.
 */
module DelegateElements {
  TranslatedDelegateConstructorCall getConstructor(DelegateCreation generatedBy) {
    result.getAst() = generatedBy
  }

  TranslatedDelegateInvokeCall getInvoke(DelegateCall generatedBy) { result.getAst() = generatedBy }

  int noGeneratedElements(Element generatedBy) {
    (
      generatedBy instanceof DelegateCreation or
      generatedBy instanceof DelegateCall
    ) and
    result = 2
  }
}

/**
 * The translation of the constructor call that happens as part of the delegate creation.
 */
private class TranslatedDelegateConstructorCall extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override DelegateCreation generatedBy;

  TranslatedDelegateConstructorCall() { this = TTranslatedCompilerGeneratedElement(generatedBy, 0) }

  final override Type getCallResultType() { result instanceof VoidType }

  override TranslatedExpr getArgument(int index) {
    index = 0 and result = getTranslatedExpr(generatedBy.getArgument())
  }

  override TranslatedExprBase getQualifier() { none() }

  override Instruction getQualifierResult() {
    exists(ConstructorCallContext context |
      context = getParent() and
      result = context.getReceiver()
    )
  }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    exists(Callable internal |
      internal.getName() = generatedBy.getDelegateType().getName() and
      internal.isCompilerGenerated() and
      internal.getFile() = generatedBy.getFile() and
      result = internal
    )
  }
}

/**
 * The translation of the invoke call that happens as part of the desugaring of the delegate call.
 */
private class TranslatedDelegateInvokeCall extends TranslatedCompilerGeneratedCall,
  TTranslatedCompilerGeneratedElement {
  override DelegateCall generatedBy;

  TranslatedDelegateInvokeCall() { this = TTranslatedCompilerGeneratedElement(generatedBy, 1) }

  final override Type getCallResultType() { result instanceof VoidType }

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and
    exists(Callable internal |
      internal.getName() = "Invoke" and
      internal.isCompilerGenerated() and
      internal.getFile() = generatedBy.getFile() and
      result = internal
    )
  }

  override TranslatedExprBase getQualifier() { result = getTranslatedExpr(generatedBy.getExpr()) }

  override Instruction getQualifierResult() { result = getQualifier().getResult() }

  override TranslatedExpr getArgument(int index) {
    result = getTranslatedExpr(generatedBy.getArgument(index))
  }
}
