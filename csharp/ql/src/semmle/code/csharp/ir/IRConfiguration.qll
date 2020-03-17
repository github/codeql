/**
 * Module used to configure the IR generation process.
 */

import csharp

private newtype TIRConfiguration = MkIRConfiguration()
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

/**
 * The query can extend this class to control which functions have IR generated for them.
 */
class IRConfiguration extends TIRConfiguration {
  string toString() { result = "IRConfiguration" }

  /**
   * Holds if IR should be created for callable `callable`. By default, holds for all callables.
   */
  predicate shouldCreateIRForFunction(Callable callable) { any() }

  predicate shouldEvaluateDebugStringsForFunction(Language::Function func) { any() }
}
