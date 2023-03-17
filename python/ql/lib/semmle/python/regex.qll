import python
// Need to import since frameworks can extend the abstract `RegExpInterpretation::Range`
private import semmle.python.Frameworks
private import regexp.internal.RegExpTracking as RegExpTracking
private import semmle.python.Concepts as Concepts
private import semmle.python.regexp.RegexTreeView
import regexp.internal.ParseRegExp

/** Gets a parsed regular expression term that is executed at `exec`. */
RegExpTerm getTermForExecution(Concepts::RegexExecution exec) {
  exists(DataFlow::Node source | source = RegExpTracking::regExpSource(exec.getRegex()) |
    result.getRegex() = source.asExpr() and
    result.isRootTerm()
  )
}

/** Provides a class for modeling regular expression interpretations. */
module RegExpInterpretation {
  /**
   * A node that is not a regular expression literal, but is used in places that
   * may interpret it as one. Instances of this class are typically strings that
   * flow to method calls like `re.compile`.
   */
  abstract class Range extends DataFlow::Node { }
}

private import semmle.python.ApiGraphs

/**
 * A node interpreted as a regular expression.
 * Speficically nodes where string values are interpreted as regular expressions.
 */
class StdLibRegExpInterpretation extends RegExpInterpretation::Range {
  StdLibRegExpInterpretation() {
    this =
      API::moduleImport("re").getMember(any(string name | name != "escape")).getACall().getArg(0)
  }
}

/** A StrConst used as a regular expression */
deprecated class RegexString extends Regex {
  RegexString() { this = RegExpTracking::regExpSource(_).asExpr() }
}
