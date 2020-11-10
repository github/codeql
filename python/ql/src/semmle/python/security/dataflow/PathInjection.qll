/**
 * Provides a taint-tracking configuration for detecting path injection
 * vulnerabilities.
 *
 * We detect cases where a user-controlled path is used in an unsafe manner,
 * meaning it is not both normalized and _afterwards_ checked.
 *
 * It does so by dividing the problematic situation into two cases:
 *  1. The file path is never normalized.
 *     This is easily detected by using normalization as a sanitizer.
 *
 *  2. The file path is normalized at least once, but never checked afterwards.
 *     This is detected by finding the earliest normalization and then ensuring that
 *     no checks happen later. Since we start from the earliest normalization,
 *     we know that the absence of checks means that no normalization has a
 *     check after it. (No checks after a second normalization would be ok if
 *     there was a check between the first and the second.)
 *
 * Note that one could make the dual split on whether the file path is ever checked. This does
 * not work as nicely, however, since checking is modelled as a `BarrierGuard` rather than
 * as a `Sanitizer`. That means that only some dataflow paths out of a check will be removed,
 * and so identifying the last check is not possible simply by finding a dataflow path from it
 * to a sink.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.DataFlow2
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.TaintTracking2
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources
import ChainedConfigs12

// ---------------------------------------------------------------------------
// Case 1. The path is never normalized.
// ---------------------------------------------------------------------------
/** Configuration to find paths from sources to sinks that contain no normalization. */
class PathNotNormalizedConfiguration extends TaintTracking::Configuration {
  PathNotNormalizedConfiguration() { this = "PathNotNormalizedConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemAccess e).getAPathArgument()
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Path::PathNormalization }
}

/**
 * Holds if there is a path injection from source to sink, where the (python) path is
 * not normalized.
 */
predicate pathNotNormalized(CustomPathNode source, CustomPathNode sink) {
  any(PathNotNormalizedConfiguration config).hasFlowPath(source.asNode1(), sink.asNode1())
}

// ---------------------------------------------------------------------------
// Case 2. The path is normalized at least once, but never checked afterwards.
// ---------------------------------------------------------------------------
/** Configuration to find paths from sources to normalizations that contain no prior normalizations. */
class FirstNormalizationConfiguration extends TaintTracking::Configuration {
  FirstNormalizationConfiguration() { this = "FirstNormalizationConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Path::PathNormalization }

  override predicate isSanitizerOut(DataFlow::Node node) { node instanceof Path::PathNormalization }
}

/** Configuration to find paths from normalizations to sinks that do not go through a check. */
class NormalizedPathNotCheckedConfiguration extends TaintTracking2::Configuration {
  NormalizedPathNotCheckedConfiguration() { this = "NormalizedPathNotCheckedConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof Path::PathNormalization }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemAccess e).getAPathArgument()
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof Path::SafeAccessCheck
  }
}

/**
 * Holds if there is a path injection from source to sink, where the (python) path is
 * normalized at least once, but never checked afterwards.
 */
predicate pathNotCheckedAfterNormalization(CustomPathNode source, CustomPathNode sink) {
  exists(
    FirstNormalizationConfiguration config, DataFlow::PathNode mid1, DataFlow2::PathNode mid2,
    NormalizedPathNotCheckedConfiguration config2
  |
    config.hasFlowPath(source.asNode1(), mid1) and
    config2.hasFlowPath(mid2, sink.asNode2()) and
    mid1.getNode().asCfgNode() = mid2.getNode().asCfgNode()
  )
}

// ---------------------------------------------------------------------------
// Query: Either case 1 or case 2.
// ---------------------------------------------------------------------------
/** Holds if there is a path injection from source to sink */
predicate pathInjection(CustomPathNode source, CustomPathNode sink) {
  pathNotNormalized(source, sink)
  or
  pathNotCheckedAfterNormalization(source, sink)
}
