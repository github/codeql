/**
 * Contains an abstract class that is the super class of the classes that deal with compiler generated calls.
 */

import csharp
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedFunction
private import experimental.ir.implementation.raw.internal.common.TranslatedCallBase
private import TranslatedCompilerGeneratedElement
private import experimental.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedCall extends TranslatedCallBase,
  TranslatedCompilerGeneratedElement {
  final override string toString() {
    result = "compiler generated call (" + generatedBy.toString() + ")"
  }
}
