/**
 * Provides default sources, sinks and sanitizers for reasoning about zip-slip
 * vulnerabilities, as well as extension points for adding your own.
 */

import go

module ZipSlip {
  private import TaintedPathCustomizations

  /**
   * A data flow source for zip-slip vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for zip-slip vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for zip-slip vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for zip-slip vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /** A file name from a zip or tar entry, as a source for zip slip. */
  class FileNameSource extends Source, DataFlow::FieldReadNode {
    FileNameSource() {
      exists(Type t |
        t.hasQualifiedName("archive/zip", "File") or
        t.hasQualifiedName("archive/tar", "Header")
      |
        getField() = t.getField("Name")
      )
    }
  }

  /** A path-traversal sink, considered as a taint sink for zip slip. */
  class TaintedPathSinkAsSink extends Sink {
    TaintedPathSinkAsSink() { this instanceof TaintedPath::Sink }
  }

  /** A path-traversal sanitizer, considered as a sanitizer for zip slip. */
  class TaintedPathSanitizerAsSanitizer extends Sanitizer {
    TaintedPathSanitizerAsSanitizer() { this instanceof TaintedPath::Sanitizer }
  }

  /** A path-traversal sanitizer guard, considered as a sanitizer guard for zip slip. */
  class TaintedPathSanitizerGuardAsSanitizerGuard extends SanitizerGuard {
    TaintedPath::SanitizerGuard self;

    TaintedPathSanitizerGuardAsSanitizerGuard() { self = this }

    override predicate checks(Expr e, boolean branch) { self.checks(e, branch) }
  }
}
