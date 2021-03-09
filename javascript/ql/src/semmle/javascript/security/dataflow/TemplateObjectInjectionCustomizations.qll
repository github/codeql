/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * template object injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
private import semmle.javascript.security.TaintedObjectCustomizations

/**
 * Provides sources, sinks and sanitizers for reasoning about
 * template object injection vulnerabilities.
 */
module TemplateObjectInjection {
  /**
   * A data flow source for template object injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow label to associate with this source. */
    abstract DataFlow::FlowLabel getAFlowLabel();
  }

  /**
   * A data flow sink for template object injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for template object injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  private class TaintedObjectSourceAsSource extends Source {
    TaintedObjectSourceAsSource() { this instanceof TaintedObject::Source }

    override DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }

  private class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }

    override DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }
  }

  private class TemplateSink extends Sink {
    TemplateSink() { this.asExpr() instanceof Express::TemplateObjectInput }
  }
}
