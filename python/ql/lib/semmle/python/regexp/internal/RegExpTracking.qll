/**
 * Provides predicates that track strings to where they are used as regular expressions.
 * This is implemented using TypeTracking in two phases:
 *
 * 1: An exploratory backwards analysis that imprecisely tracks all nodes that may be used as regular expressions.
 * The exploratory phase ends with a forwards analysis from string constants that were reached by the backwards analysis.
 * This is similar to the exploratory phase of the JavaScript global DataFlow library.
 *
 * 2: A precise type tracking analysis that tracks constant strings to where they are used as regular expressions.
 * This phase keeps track of which strings and regular expressions end up in which places.
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts as Concepts

/** Gets a constant string value that may be used as a regular expression. */
DataFlow::LocalSourceNode strStart() { result.asExpr() instanceof StringLiteral }

private import semmle.python.regex as Regex

/** A node where regular expressions that flow to the node are used. */
class RegExpSink extends DataFlow::Node {
  RegExpSink() {
    this = any(Concepts::RegexExecution exec).getRegex()
    or
    this instanceof Concepts::RegExpInterpretation
  }
}

/**
 * Gets a dataflow node that may end up being in any regular expression execution.
 * This is the backwards exploratory phase of the analysis.
 */
private DataFlow::TypeTrackingNode backwards(DataFlow::TypeBackTracker t) {
  t.start() and
  result = any(RegExpSink sink).getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 | result = backwards(t2).backtrack(t2, t))
}

/**
 * Gets a reference to a string that reaches any regular expression execution.
 * This is the forwards exploratory phase of the analysis.
 */
private DataFlow::TypeTrackingNode forwards(DataFlow::TypeTracker t) {
  t.start() and
  result = backwards(DataFlow::TypeBackTracker::end()) and
  result = strStart()
  or
  exists(DataFlow::TypeTracker t2 | result = forwards(t2).track(t2, t)) and
  result = backwards(_)
}

/**
 * Gets a node that has been tracked from the string constant `start` to some node.
 * This is used to figure out where `start` is evaluated as a regular expression.
 *
 * The result of the exploratory phase is used to limit the size of the search space in this precise analysis.
 */
private DataFlow::TypeTrackingNode regexTracking(DataFlow::Node start, DataFlow::TypeTracker t) {
  result = forwards(t) and
  (
    t.start() and
    start = strStart() and
    result = start
    or
    exists(DataFlow::TypeTracker t2 | result = regexTracking(start, t2).track(t2, t))
  )
}

/** Gets a node holding a value for the regular expression that is evaluated at `re`. */
cached
DataFlow::Node regExpSource(RegExpSink re) {
  regexTracking(result, DataFlow::TypeTracker::end()).flowsTo(re)
}
