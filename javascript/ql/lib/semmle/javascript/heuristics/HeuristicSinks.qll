/**
 * Provides heuristically recognized sinks for security queries.
 */

import javascript
private import SyntacticHeuristics

/**
 * A heuristic sink for data flow in a security query.
 */
abstract class HeuristicSink extends DataFlow::Node { }

/**
 * A heuristically recognized sink for `js/code-injection` vulnerabilities.
 */
class HeuristicCodeInjectionSink extends HeuristicSink {
  HeuristicCodeInjectionSink() {
    isAssignedTo(this, "$where")
    or
    isAssignedToOrConcatenatedWith(this, "(?i)(command|cmd|exec|code|script|program)")
    or
    isArgTo(this, "(?i)(eval|run)") // "exec" clashes too often with `RegExp.prototype.exec`
    or
    exists(string srcPattern |
      // function/lambda syntax anywhere
      srcPattern = "(?s).*function\\s*\\(.*\\).*" or
      srcPattern = "(?s).*(\\(.*\\)|[A-Za-z_]+)\\s?=>.*"
    |
      isConcatenatedWithString(this, srcPattern)
    )
    or
    // dynamic property name
    isConcatenatedWithStrings("(?is)[a-z]+\\[", this, "(?s)\\].*")
  }
}
