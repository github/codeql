/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * injections in property names, used either for writing into a
 * property, into a header or for calling an object's method, as well
 * as extension points for adding your own.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared

module RemotePropertyInjection {
  /**
   * A data flow source for remote property injection.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for remote property injection.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a string to identify the different types of sinks.
     */
    abstract string getMessage();
  }

  /**
   * A sanitizer for remote property injection.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for property writes with dynamically computed property name.
   */
  class PropertyWriteSink extends Sink, DataFlow::ValueNode {
    PropertyWriteSink() {
      exists(DataFlow::PropWrite pw | astNode = pw.getPropertyNameExpr()) or
      exists(DeleteExpr expr | expr.getOperand().(PropAccess).getPropertyNameExpr() = astNode)
    }

    override string getMessage() { result = "A property name to write to" }
  }

  /**
   * A sink for HTTP header writes with dynamically computed header name.
   * This sink avoids double-flagging by ignoring `SetMultipleHeaders` since
   * the multiple headers use case consists of an objects containing different
   * header names as properties. This case is already handled by
   * `PropertyWriteSink`.
   */
  class HeaderNameSink extends Sink {
    HeaderNameSink() {
      exists(Http::ExplicitHeaderDefinition hd |
        not hd instanceof Express::SetMultipleHeaders and
        this = hd.getNameNode()
      )
    }

    override string getMessage() { result = "A header name" }
  }
}
