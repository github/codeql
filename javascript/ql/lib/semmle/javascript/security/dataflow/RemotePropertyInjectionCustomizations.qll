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
   * A source of remote user input, considered as a flow source for remote property
   * injection.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A sink for property writes with dynamically computed property name.
   */
  class PropertyWriteSink extends Sink, DataFlow::ValueNode {
    PropertyWriteSink() {
      exists(DataFlow::PropWrite pw | astNode = pw.getPropertyNameExpr()) or
      exists(DeleteExpr expr | expr.getOperand().(PropAccess).getPropertyNameExpr() = astNode)
    }

    override string getMessage() { result = " a property name to write to." }
  }

  /**
   * A sink for HTTP header writes with dynamically computed header name.
   * This sink avoids double-flagging by ignoring `SetMultipleHeaders` since
   * the multiple headers use case consists of an objects containing different
   * header names as properties. This case is already handled by
   * `PropertyWriteSink`.
   */
  class HeaderNameSink extends Sink, DataFlow::ValueNode {
    HeaderNameSink() {
      exists(HTTP::ExplicitHeaderDefinition hd |
        not hd instanceof Express::SetMultipleHeaders and
        astNode = hd.getNameExpr()
      )
    }

    override string getMessage() { result = " a header name." }
  }
}
