/**
 * Provides default sources, sinks, and sanitizers for reasoning about uncontrolled allocation size issues,
 * as well as extension points for adding your own.
 */

import go
private import semmle.go.security.AllocationSizeOverflow

/**
 * Provides extension points for customizing the taint-tracking configuration for reasoning
 * about uncontrolled allocation size issues.
 */
module UncontrolledAllocationSize {
  /** A data flow source for uncontrolled allocation size vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for uncontrolled allocation size vulnerabilities. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for uncontrolled allocation size vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of untrusted data, considered as a taint source for uncontrolled size allocation vulnerabilities. */
  private class ThreatModelFlowAsSource extends Source instanceof ThreatModelFlowSource { }

  /** The size argument of a memory allocation function. */
  private class AllocationSizeAsSink extends Sink instanceof AllocationSizeOverflow::AllocationSize {
  }

  /** A check that a value is below some upper limit. */
  private class SizeCheckSanitizer extends Sanitizer instanceof AllocationSizeOverflow::AllocationSizeCheckBarrier
  { }
}
