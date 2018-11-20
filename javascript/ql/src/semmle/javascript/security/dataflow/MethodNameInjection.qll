/**
 * Provides a taint-tracking configuration for reasoning about method invocations
 * with a user-controlled method name.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared

module MethodNameInjection {
  private import DataFlow::FlowLabel
  
  /**
   * A data flow source for method name injection.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this source.
     */
    DataFlow::FlowLabel getFlowLabel() {
      result = data()
    }
  }

  /**
   * A data flow sink for method name injection.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this sink
     */
    abstract DataFlow::FlowLabel getFlowLabel();
  }

  /**
   * A sanitizer for method name injection.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Gets the flow label describing values that may refer to an unsafe
   * function as a result of an attacker-controlled property name.
   */
  UnsafeFunction unsafeFunction() { any() }
  private class UnsafeFunction extends DataFlow::FlowLabel {
    UnsafeFunction() { this = "UnsafeFunction" }
  }

  /**
   * A taint-tracking configuration for reasoning about method name injection.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "RemotePropertyInjection" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source.(Source).getFlowLabel() = label
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink.(Sink).getFlowLabel() = label
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer or
      node instanceof PropertyInjection::Sanitizer
    }

    /**
     * Holds if a property of the given object is an unsafe function.
     */
    predicate hasUnsafeMethods(DataFlow::SourceNode node) {
      PropertyInjection::hasUnsafeMethods(node) // Redefined here so custom queries can override it
    }

    /**
     * Holds if the `node` is of form `Object.create(null)` and so it has no prototype.
     */
    predicate isPrototypeLessObject(DataFlow::MethodCallNode node) {
      node = DataFlow::globalVarRef("Object").getAMethodCall("create") and
      node.getArgument(0).asExpr() instanceof NullLiteral
    }

    override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel, DataFlow::FlowLabel dstlabel) {
      // Reading a property of the global object or of a function
      exists (DataFlow::PropRead read |
        hasUnsafeMethods(read.getBase().getALocalSource()) and
        src = read.getPropertyNameExpr().flow() and
        dst = read and
        srclabel = taint() and
        dstlabel = unsafeFunction())
      or
      // Reading a chain of properties from any object with a prototype can lead to Function
      exists (PropertyProjection proj |
        not isPrototypeLessObject(proj.getObject().getALocalSource()) and
        src = proj.getASelector() and
        dst = proj and
        srclabel = taint() and
        dstlabel = unsafeFunction())
    }
  }

  /**
   * A source of remote user input, considered as a source for method name injection. 
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The page URL considered as a flow source for method name injection. 
   */
  class DocumentUrlAsSource extends Source {
    DocumentUrlAsSource() { isDocumentURL(asExpr()) }
  }

  /**
   * A function invocation of an unsafe function, as a sink for remote method name injection.
   */
  class CalleeAsSink extends Sink {
    CalleeAsSink() {
      this = any(DataFlow::InvokeNode node).getCalleeNode()
    }

    override DataFlow::FlowLabel getFlowLabel() {
      result = unsafeFunction()
    }
  }
}
