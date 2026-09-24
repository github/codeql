/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id unified/swift/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import unified

/**
 * A string that might be a label for a path argument.
 */
pragma[inline]
private predicate pathLikeHeuristic(string label) {
  label =
    [
      "atFile", "atPath", "atDirectory", "toFile", "toPath", "toDirectory", "inFile", "inPath",
      "inDirectory", "contentsOfFile", "contentsOfPath", "contentsOfDirectory", "filePath",
      "directory", "directoryPath"
    ]
}

predicate heuristicSink(DataFlow::Node node) {
  node.isIncomingValue(any(Identifier id | id.getValue() = "sqlite3_temp_directory"))
  or
  exists(Argument arg |
    pathLikeHeuristic(arg.getName()) and
    node.asExpr() = arg.getValue()
  )
}

module PathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    Models::isSink(node, "path-injection") or
    heuristicSink(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  predicate isBarrier(DataFlow::Node node) { none() }
}

module PathInjectionFlow = DataFlow::Global<PathInjectionConfig>;

import PathInjectionFlow::PathGraph

from PathInjectionFlow::PathNode source, PathInjectionFlow::PathNode sink
where PathInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
