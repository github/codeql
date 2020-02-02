/**
 * @name Denial of Service from comparison of user input against regex built from user-controlled
 *       source
 * @description User input should not be matched against a regular expression built from
 *              user-controlled source, because that could require exponential time on certain
 *              input.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/regex-injection
 * @tags security
 *       external/cwe/cwe-400
 */

import java
import semmle.code.java.dataflow.DataFlow
import Regex

/** A data flow source for user-controlled regex. */
class RemoteRegexPatternSource extends RegexPatternSource {
  RemoteRegexPatternSource() { this instanceof RemoteFlowSource }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RegexInputFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to regular expression operation with user-provided regex.", source.getNode(),
  "User-provided value"
