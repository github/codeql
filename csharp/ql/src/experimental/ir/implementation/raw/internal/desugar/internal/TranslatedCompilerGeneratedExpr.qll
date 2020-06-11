/**
 * Contains an abstract class, which is the super class  of all the classes that represent compiler
 * generated expressions.
 */

import csharp
private import TranslatedCompilerGeneratedElement
private import experimental.ir.implementation.raw.Instruction
private import experimental.ir.implementation.raw.internal.common.TranslatedExprBase
private import experimental.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedExpr extends TranslatedCompilerGeneratedElement,
  TranslatedExprBase {
  override string toString() { result = "compiler generated expr (" + generatedBy.toString() + ")" }

  abstract Type getResultType();
}
