import go

module SafeUrlFlow {
  /** A sink for safe URL flow. */
  abstract class Sink extends DataFlow::Node { }

  /** An outgoing sanitizer edge for safe URL flow. */
  abstract class SanitizerEdge extends DataFlow::Node { }

  /**
   * A method on a `net/url.URL` that is considered unsafe to use.
   */
  private class UnsafeUrlMethod extends URL::UrlGetter {
    UnsafeUrlMethod() { this.getName() = "Query" }
  }

  /** A function model step using `UnsafeUrlMethod`, considered as a sanitizer for safe URL flow. */
  private class UnsafeUrlMethodEdge extends SanitizerEdge {
    UnsafeUrlMethodEdge() { TaintTracking::functionModelStep(any(UnsafeUrlMethod um), this, _) }
  }
}
