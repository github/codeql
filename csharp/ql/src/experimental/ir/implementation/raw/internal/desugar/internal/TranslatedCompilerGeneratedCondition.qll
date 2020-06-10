/**
 * Contains an abstract class that is the super class of the classes that deal with compiler generated conditions.
 */

import csharp
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.common.TranslatedConditionBase
private import TranslatedCompilerGeneratedElement
private import experimental.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedValueCondition extends TranslatedCompilerGeneratedElement,
  ValueConditionBase {
  final override string toString() {
    result = "compiler generated condition (" + generatedBy.toString() + ")"
  }
}
