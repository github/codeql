/**
 * @name Uncontrolled format string
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.3
 * @precision high
 * @id unified/swift/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import unified

/**
 * A taint configuration for tainted data that reaches a format string.
 */
module TaintedFormatConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    // TODO: the MaD format currently has the varargs argument first in the
    //  signature, rather than in its normal position.
    // TODO: we currently model `printf(_:_:)` etc explicitly, rather than with a
    //  more flexible pattern as in the original Swift's `StringFormat.qll`.
    // TODO: Port the variadic-call heuristic from original Swift's
    //  `UncontrolledFormatStringExtensions.qll` once variadic parameters are extracted.
    Models::isSink(node, "format-string")
  }

  predicate isBarrier(DataFlow::Node node) {
    // TODO: Port the numeric-type barrier from original Swift's UncontrolledFormatStringExtensions.qll.
    none()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of tainted data that reaches a format string.
 */
module TaintedFormatFlow = TaintTracking::Global<TaintedFormatConfig>;

import TaintedFormatFlow::PathGraph

from TaintedFormatFlow::PathNode sourceNode, TaintedFormatFlow::PathNode sinkNode
where TaintedFormatFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This format string depends on $@.",
  sourceNode.getNode(), "this user-provided value"
