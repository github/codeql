/**
 * Provides a taint tracking configuration for reasoning about file
 * data in outbound network requests.
 *
 * Note, for performance reasons: only import this file if
 * `FileAccessToHttp::Configuration` is needed, otherwise
 * `FileAccessToHttpCustomizations` should be imported instead.
 */

import javascript
import FileAccessToHttpCustomizations::FileAccessToHttp

/**
 * A taint tracking configuration for file data in outbound network requests.
 */
module FileAccessToHttpConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    isSink(node) and
    contents = DataFlow::ContentSet::anyProperty()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking for file data in outbound network requests.
 */
module FileAccessToHttpFlow = TaintTracking::Global<FileAccessToHttpConfig>;

/**
 * DEPRECATED. Use the `FileAccessToHttpFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "FileAccessToHttp" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // taint entire object on property write
    exists(DataFlow::PropWrite pwr |
      succ = pwr.getBase() and
      pred = pwr.getRhs()
    )
  }
}
