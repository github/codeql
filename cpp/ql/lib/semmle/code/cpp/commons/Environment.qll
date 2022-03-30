/**
 * Reading from the environment, for example with 'getenv'.
 */

import cpp

/**
 * An expression that reads from an environment variable.
 */
class EnvironmentRead extends Expr {
  EnvironmentRead() { readsEnvironment(this, _) }

  /**
   * The name of the environment variable.
   */
  string getEnvironmentVariable() {
    // Conveniently, it's always the first argument to the call
    this.(Call).getArgument(0).(TextLiteral).getValue() = result
  }

  /**
   * A very short description of the source, suitable for use in
   * an error message.
   */
  string getSourceDescription() { readsEnvironment(this, result) }
}

private predicate readsEnvironment(Expr read, string sourceDescription) {
  exists(FunctionCall call, string name |
    read = call and
    call.getTarget().hasGlobalOrStdName(name) and
    name = ["getenv", "secure_getenv", "_wgetenv"] and
    sourceDescription = name
  )
}
