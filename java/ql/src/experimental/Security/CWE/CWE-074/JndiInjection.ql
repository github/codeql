/**
 * @name JNDI lookup with user-controlled name
 * @description Doing a JNDI lookup with user-controlled name can lead to download an untrusted
 *              object and to execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jndi-injection
 * @tags security
 *       external/cwe/cwe-074
 */

import java
import semmle.code.java.dataflow.FlowSources
import JndiInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, JndiInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "JNDI lookup might include name from $@.", source.getNode(),
  "this user input"
