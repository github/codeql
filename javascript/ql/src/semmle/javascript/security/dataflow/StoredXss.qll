/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import semmle.javascript.security.dataflow.ReflectedXss as ReflectedXss
import semmle.javascript.security.dataflow.DomBasedXss as DomBasedXss

module StoredXss {
  /**
   * A data flow source for XSS vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for XSS vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for XSS vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StoredXss" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /** A file name, considered as a flow source for stored XSS. */
  class FileNameSourceAsSource extends Source {
    FileNameSourceAsSource() {
      this instanceof FileNameSource
    }
  }

  /** An ordinary XSS sink, considered as a flow sink for stored XSS. */
  class XssSinkAsSink extends Sink {
    XssSinkAsSink() {
      this instanceof ReflectedXss::ReflectedXss::Sink or
      this instanceof DomBasedXss::DomBasedXss::Sink
    }
  }

}
