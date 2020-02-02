/**
 * @name Denial of Service from comparison of user input against expensive regex
 * @description User input should not be matched against a regular expression that could require
 *              exponential time on certain input.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/redos
 * @tags security
 *       external/cwe/cwe-400
 */

import java
import semmle.code.java.dataflow.DataFlow
import Regex

/** A data flow source for exponential regex. */
class ExponentialRegexLiteral extends RegexPatternSource {
  ExponentialRegexLiteral() { isExponentialRegex(this.asExpr()) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RegexInputFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to regular expression operation with dangerous regex.", source.getNode(),
  "User-provided value"
