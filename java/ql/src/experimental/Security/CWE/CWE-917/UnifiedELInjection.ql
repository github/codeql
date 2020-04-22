/**
 * @name Unified Expression Language statement with user-controlled input
 * @description Evaluation of Unified Expression Language statement with user-controlled input can
 *              lead to execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unified-el-injection
 * @tags security
 *       external/cwe/cwe-917
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow
import DataFlow::PathGraph
import UnifiedELInjectionLib

from DataFlow::PathNode source, DataFlow::PathNode sink, UnifiedELInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unified EL expression might include input from $@.",
  source.getNode(), "this user input"
