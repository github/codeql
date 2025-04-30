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
import semmle.code.java.dataflow.DataFlow
deprecated import SpringViewManipulationLib
deprecated import SpringViewManipulationFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, SpringViewManipulationFlow::PathNode source,
  SpringViewManipulationFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  thymeleafIsUsed() and
  SpringViewManipulationFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Potential Spring Expression Language injection from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}
