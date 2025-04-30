/**
 * @name Uncontrolled command line with additional heuristic sources
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id js/command-line-injection-more-sources
 * @tags experimental
 *       correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import semmle.javascript.security.dataflow.CommandInjectionQuery
import semmle.javascript.heuristics.AdditionalSources
import CommandInjectionFlow::PathGraph

from
  CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink,
  DataFlow::Node highlight, Source sourceNode
where
  CommandInjectionFlow::flowPath(source, sink) and
  (
    if isSinkWithHighlight(sink.getNode(), _)
    then isSinkWithHighlight(sink.getNode(), highlight)
    else highlight = sink.getNode()
  ) and
  sourceNode = source.getNode() and
  source.getNode() instanceof HeuristicSource
select highlight, source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
