/**
 * Module used to configure the IR generation process.
 */

private import internal.IRConfigurationInternal

private newtype TIRConfiguration = MkIRConfiguration()

/**
 * The query can extend this class to control which functions have IR generated for them.
 */
class IRConfiguration extends TIRConfiguration {
  string toString() { result = "IRConfiguration" }

  /**
   * Holds if IR should be created for function `func`. By default, holds for all functions.
   */
  predicate shouldCreateIRForFunction(Language::Function func) { any() }

  predicate shouldEvaluateDebugStringsForFunction(Language::Function func) { any() }
}

private newtype TIREscapeAnalysisConfiguration = MkIREscapeAnalysisConfiguration()

/**
 * The query can extend this class to control what escape analysis is used when generating SSA.
 */
class IREscapeAnalysisConfiguration extends TIREscapeAnalysisConfiguration {
  string toString() { result = "IREscapeAnalysisConfiguration" }

  /**
   * Holds if the escape analysis done by SSA construction should be sound. By default, the SSA is
   * built assuming that no variable's address ever escapes.
   */
  predicate useSoundEscapeAnalysis() { none() }
}
