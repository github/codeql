/**
 * Contains an abstract class that is the super class of the classes that deal with compiler generated calls.
 */

import csharp
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedElement
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedFunction
private import semmle.code.csharp.ir.implementation.raw.internal.common.TranslatedCallBlueprint
private import TranslatedCompilerGeneratedElement
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedCall extends TranslatedCallBlueprint, 
                                                       TranslatedCompilerGeneratedElement { 
  override final string toString() {
    result = "compiler generated call (" + generatedBy.toString() + ")"
  }
  
  override Instruction getUnmodeledDefinitionInstruction() {
    result = getTranslatedFunction(this.getFunction()).getUnmodeledDefinitionInstruction()
  }
}