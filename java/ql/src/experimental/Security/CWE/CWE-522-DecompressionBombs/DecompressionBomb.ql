/**
 * @name Uncontrolled file decompression
 * @description Decompressing user-controlled files without checking the compression ratio may allow attackers to perform denial-of-service attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import java
deprecated import experimental.semmle.code.java.security.DecompressionBombQuery
deprecated import DecompressionBombsFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, DecompressionBombsFlow::PathNode source,
  DecompressionBombsFlow::PathNode sink, string message1, DataFlow::Node sourceNode, string message2
) {
  DecompressionBombsFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "This file extraction depends on a $@." and
  sourceNode = source.getNode() and
  message2 = "potentially untrusted source"
}
