/**
 * @name Android fragment injection
 * @description Instantiating an Android fragment from a user-provided value
 *              may allow a malicious application to bypass access controls,  exposing the application to unintended effects.
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
