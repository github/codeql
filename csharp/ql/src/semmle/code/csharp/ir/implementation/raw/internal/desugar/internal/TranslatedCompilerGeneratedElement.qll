/**
 * The abstract super class of every `TranslatedCompilerX` class. It has one member field, `generatedBy`,
 * which represents the element that generated the compiler generated element.
 */

import csharp
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedElement
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedElement extends TranslatedElement {
  // The element that generates generated the compiler element can
  // only be a stmt or an expr
  ControlFlowElement generatedBy;

  override string toString() {
    result = "compiler generated element (" + generatedBy.toString() + ")"
  }

  override final Callable getFunction() {
    result = generatedBy.getEnclosingCallable() 
  }
  
  override final Language::AST getAST() {
    result = generatedBy
  }
}