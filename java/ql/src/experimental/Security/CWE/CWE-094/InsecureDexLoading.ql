/**
 * @name Insecure loading of an Android Dex File
 * @description Loading a DEX library located in a world-writable location such as
 * an SD card can lead to arbitrary code execution vulnerabilities.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/android-insecure-dex-loading
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.dataflow.DataFlow
deprecated import InsecureDexLoading
deprecated import InsecureDexFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, InsecureDexFlow::PathNode source, InsecureDexFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  InsecureDexFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Potential arbitrary code execution due to $@." and
  sourceNode = source.getNode() and
  message2 = "a value loaded from a world-writable source."
}
