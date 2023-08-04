/**
 * @name Spring View Manipulation
 * @description Untrusted input in a Spring View can lead to RCE.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/spring-view-manipulation
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 */

import java
import SpringViewManipulationLib
import SpringViewManipulationFlow::PathGraph

from SpringViewManipulationFlow::PathNode source, SpringViewManipulationFlow::PathNode sink
where
  thymeleafIsUsed() and
  SpringViewManipulationFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potential Spring Expression Language injection from $@.",
  source.getNode(), "this user input"
