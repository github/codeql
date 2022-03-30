/**
 * @name Spring View Manipulation
 * @description Untrusted input in a Spring View can lead to RCE.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/spring-view-manipulation
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import SpringViewManipulationLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, SpringViewManipulationConfig conf
where
  thymeleafIsUsed() and
  conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential Spring Expression Language injection from $@.",
  source.getNode(), "this user input"
