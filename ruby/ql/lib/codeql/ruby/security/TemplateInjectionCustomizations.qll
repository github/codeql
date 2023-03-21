/**
 * Provides default sources, sinks and sanitizers for detecting
 * ERB Server Side Template Injections, as well as extension points for adding your own
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources

/**
 * Provides default sources, sinks and sanitizers for detecting
 * Server Side Template Injections, as well as extension points for adding your own
 */
module TemplateInjection {
  /** A data flow source for SSTI vulnerabilities */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for SSTI vulnerabilities */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for SSTI vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  private class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An Server Side Template Injection rendering, considered as a flow sink.
   */
  private class TemplateRenderingAsSink extends Sink {
    TemplateRenderingAsSink() { this = any(TemplateRendering e).getTemplate() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  private class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }

  /**
   * An inclusion check against an array of constant strings, considered as a
   * sanitizer-guard.
   */
  private class StringConstArrayInclusionCallAsSanitizer extends Sanitizer,
    StringConstArrayInclusionCallBarrier
  { }
}
