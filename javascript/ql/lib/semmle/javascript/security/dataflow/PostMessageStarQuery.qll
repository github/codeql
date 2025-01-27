/**
 * Provides a taint tracking configuration for reasoning about
 * cross-window communication with unrestricted origin.
 *
 * Note, for performance reasons: only import this file if
 * `PostMessageStar::Configuration` is needed, otherwise
 * `PostMessageStarCustomizations` should be imported instead.
 */

import javascript
import PostMessageStarCustomizations::PostMessageStar

// Materialize flow labels
/**
 * A taint tracking configuration for cross-window communication with unrestricted origin.
 *
 * This configuration identifies flows from `Source`s, which are sources of
 * sensitive data, to `Sink`s, which is an abstract class representing all
 * the places sensitive data may be transmitted across window boundaries without restricting
 * the origin.
 *
 * Additional sources or sinks can be added either by extending the relevant class, or by subclassing
 * this configuration itself, and amending the sources and sinks.
 */
module PostMessageStarConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    // If an object leaks, all of its properties have leaked
    isSink(node) and contents = DataFlow::ContentSet::anyProperty()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * A taint tracking configuration for cross-window communication with unrestricted origin.
 */
module PostMessageStarFlow = TaintTracking::Global<PostMessageStarConfig>;
