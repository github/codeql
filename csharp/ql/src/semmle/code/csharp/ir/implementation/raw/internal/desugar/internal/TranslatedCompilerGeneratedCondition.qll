/**
 * Contains an abstract class that is the super class of the classes that deal with compiler generated conditions.
 */

import csharp
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedElement
private import semmle.code.csharp.ir.implementation.raw.internal.common.TranslatedConditionBlueprint
private import TranslatedCompilerGeneratedElement
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedValueCondition extends TranslatedCompilerGeneratedElement,
                                                                 ValueConditionBlueprint {
  override final string toString() {
    result = "compiler generated condition (" + generatedBy.toString() + ")"
  }
}