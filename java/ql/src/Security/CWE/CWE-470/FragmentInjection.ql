/**
 * @name Android Fragment injection
 * @description Instantiating an Android Fragment from a user-provided value
 *              may lead to Fragment injection.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/android/fragment-injection
 * @tags security
 *       external/cwe/cwe-470
 */

import java
import semmle.code.java.security.FragmentInjectionQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink
where any(FragmentInjectionTaintConf conf).hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Fragment injection from $@.", source.getNode(),
  "this user input"
