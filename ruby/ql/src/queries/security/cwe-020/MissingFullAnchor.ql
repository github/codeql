/**
 * @name Badly anchored regular expression
 * @description Regular expressions anchored using `^` or `$` are vulnerable to bypassing.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id rb/regex/badly-anchored-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import codeql.ruby.security.regexp.MissingFullAnchorQuery
import MissingFullAnchorFlow::PathGraph

from MissingFullAnchorFlow::PathNode source, MissingFullAnchorFlow::PathNode sink, Sink sinkNode
where MissingFullAnchorFlow::flowPath(source, sink) and sink.getNode() = sinkNode
select sink, source, sink, "This value depends on $@, and is $@ against a $@.", source.getNode(),
  source.getNode().(Source).describe(), sinkNode.getCallNode(), "checked", sinkNode.getRegex(),
  "badly anchored regular expression"
