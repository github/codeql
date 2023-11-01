import python
// Need to import since frameworks can extend the abstract `RegExpInterpretation::Range`
private import semmle.python.Frameworks
private import regexp.internal.RegExpTracking as RegExpTracking
private import semmle.python.Concepts as Concepts
private import semmle.python.regexp.RegexTreeView
private import semmle.python.dataflow.new.DataFlow
import regexp.internal.ParseRegExp

/** Gets a parsed regular expression term that is executed at `exec`. */
RegExpTerm getTermForExecution(Concepts::RegexExecution exec) {
  exists(DataFlow::Node source | source = RegExpTracking::regExpSource(exec.getRegex()) |
    result.getRegex() = source.asExpr() and
    result.isRootTerm()
  )
}

/** A StrConst used as a regular expression */
deprecated class RegexString extends Regex {
  RegexString() { this = RegExpTracking::regExpSource(_).asExpr() }
}
