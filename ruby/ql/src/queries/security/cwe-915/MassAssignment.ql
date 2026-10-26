/**
 * @name Insecure Mass Assignment
 * @description Using mass assignment with user-controlled attributes allows unintended parameters to be set.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id rb/insecure-mass-assignment
 * @tags security
 *       external/cwe/cwe-915
 */

import codeql.ruby.security.MassAssignmentQuery
import MassAssignmentFlow::PathGraph

from MassAssignmentFlow::PathNode source, MassAssignmentFlow::PathNode sink
where MassAssignmentFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This mass assignment operation can assign user-controlled attributes from $@.", source.getNode(),
  "this remote flow source"
