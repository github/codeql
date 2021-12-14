/**
 * @name Incomplete HTML attribute sanitization
 * @description Writing incompletely sanitized values to HTML
 *              attribute strings can lead to a cross-site
 *              scripting vulnerability.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id js/incomplete-html-attribute-sanitization
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 *       external/cwe/cwe-020
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.IncompleteHtmlAttributeSanitizationQuery
import semmle.javascript.security.IncompleteBlacklistSanitizer

/**
 * Gets a pretty string of the dangerous characters for `sink`.
 */
string prettyPrintDangerousCharaters(Sink sink) {
  result =
    strictconcat(string s |
      s = describeCharacters(sink.getADangerousCharacter())
    |
      s, ", " order by s
    ).regexpReplaceAll(",(?=[^,]+$)", " or")
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  // this message is slightly sub-optimal as we do not have an easy way
  // to get the flow labels that reach the sink, so the message includes
  // all of them in a disjunction
  "Cross-site scripting vulnerability as the output of $@ may contain " +
    prettyPrintDangerousCharaters(sink.getNode()) + " when it reaches this attribute definition.",
  source.getNode(), "this final HTML sanitizer step"
