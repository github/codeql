/**
 * Contains an abstract class that is the super class of the classes that deal with compiler generated calls.
 */

import csharp
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedElement
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedFunction
private import semmle.code.csharp.ir.implementation.raw.internal.common.TranslatedCallBase
private import TranslatedCompilerGeneratedElement
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedCall extends TranslatedCallBase,
  TranslatedCompilerGeneratedElement {
  final override string toString() {
    result = "compiler generated call (" + generatedBy.toString() + ")"
  }
}
