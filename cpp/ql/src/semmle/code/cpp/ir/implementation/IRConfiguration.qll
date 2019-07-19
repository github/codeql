private import internal.IRConfigurationInternal

private newtype TIRConfiguration = MkIRConfiguration()

/**
 * The query can extend this class to control which functions have IR generated for them.
 */
class IRConfiguration extends TIRConfiguration {
  string toString() {
    result = "IRConfiguration"
  }

  /**
   * Holds if IR should be created for function `func`. By default, holds for all functions.
   */
  predicate shouldCreateIRForFunction(Language::Function func) {
    any()
  }
}
