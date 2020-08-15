/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * insufficient random sources used as keys in cryptographic algorithms,
 * as well as extension points for adding your own.
 */

import go

module InsecureRandomness {
  /**
   * A data flow source for insufficient random sources
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for cryptographic algorithms that take a key as input
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for insufficient random sources used as cryptographic keys
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A random source that is not sufficient for security use. So far this is only made up
   * of the math package's rand function, more insufficient random sources can be added here.
   */
  class InsecureRandomSource extends Source, DataFlow::CallNode {
    InsecureRandomSource() { this.getTarget().getPackage().getPath() = "math/rand" }
  }

  /**
   * A cryptographic algorithm.
   */
  class CryptographicSink extends Sink, DataFlow::Node {
    CryptographicSink() {
      exists(DataFlow::CallNode call |
        call.getTarget().getPackage().getPath().regexpMatch("crypto/.*") and
        this = call.getAnArgument()
      )
    }
  }

  /**
   * A configuration depicting taint flow from insufficient random sources to cryptographic
   * algorithms that take a key as input.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsecureRandomness" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { none() }
  }
}
