/** Provides classes for reasoning about email-injection vulnerabilities. */

import go

/**
 * Provides a library for reasoning about email-injection vulnerabilities.
 */
module EmailInjection {
  /**
   * A data-flow node that should be considered a source of untrusted data for email-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data-flow node that should be considered a sink for email-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ThreatModelFlowSource` or `Source` instead.
   */
  deprecated class UntrustedFlowSourceAsSource = ThreatModelFlowAsSource;

  /** A source of untrusted data, considered as a taint source for email injection. */
  private class ThreatModelFlowAsSource extends Source instanceof ThreatModelFlowSource { }

  /**
   * A data-flow node that becomes part of an email considered as a taint sink for email injection.
   */
  class MailDataAsSink extends Sink instanceof EmailData { }
}
