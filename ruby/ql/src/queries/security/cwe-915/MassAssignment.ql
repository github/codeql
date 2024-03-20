/**
 * @name Insecure Mass Assignment
 * @description Using mass assignment with user-controlled keys allows unintended parameters to be set.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id ruby/insecure-mass-assignment
 * @tags security
 *       external/cwe/cwe-915
 */

import codeql.ruby.security.MassAssignmentQuery
import MassAssignmentFlow::PathGraph

from MassAssignmentFlow::PathNode source, MassAssignmentFlow::PathNode sink
where MassAssignmentFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "mass assignment"
