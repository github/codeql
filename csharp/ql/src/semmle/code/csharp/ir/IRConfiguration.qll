import csharp

private newtype TIRConfiguration = MkIRConfiguration()

/**
 * The query can extend this class to control which functions have IR generated for them.
 */
class IRConfiguration extends TIRConfiguration {
  string toString() {
    result = "IRConfiguration"
  }

  /**
   * Holds if IR should be created for method `method`. By default, holds for all method.
   */
  predicate shouldCreateIRForFunction(Callable callable) {
    any()
  }
}
