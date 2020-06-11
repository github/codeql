/**
 * Contains an abstract class, which is the super class  of all the classes that represent compiler
 * generated statements.
 */

import csharp
private import TranslatedCompilerGeneratedElement
private import experimental.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedStmt extends TranslatedCompilerGeneratedElement {
  final override string toString() {
    result = "compiler generated stmt (" + generatedBy.toString() + ")"
  }
}
