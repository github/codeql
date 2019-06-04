/**
 * Provides a taint-tracking configuration for reasoning about method invocations
 * with a user-controlled method name on objects with unsafe methods.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared

module UnsafeDynamicMethodAccess {
  private import DataFlow::FlowLabel

  /**
   * A data flow source for unsafe dynamic method access.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this source.
     */
    DataFlow::FlowLabel getFlowLabel() { result = data() }
  }

  /**
   * A data flow sink for unsafe dynamic method access.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this sink
     */
    abstract DataFlow::FlowLabel getFlowLabel();
  }

  /**
   * A sanitizer for unsafe dynamic method access.
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
   * A taint-tracking configuration for reasoning about unsafe dynamic method access.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "UnsafeDynamicMethodAccess" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source.(Source).getFlowLabel() = label
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink.(Sink).getFlowLabel() = label
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
      or
      exists(StringConcatenation::getOperand(node, _)) and
      not StringConcatenation::isCoercion(node)
    }

    /**
     * Holds if a property of the given object is an unsafe function.
     */
    predicate hasUnsafeMethods(DataFlow::SourceNode node) {
      PropertyInjection::hasUnsafeMethods(node) // Redefined here so custom queries can override it
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      // Reading a property of the global object or of a function
      exists(DataFlow::PropRead read |
        hasUnsafeMethods(read.getBase().getALocalSource()) and
        src = read.getPropertyNameExpr().flow() and
        dst = read and
        (srclabel = data() or srclabel = taint()) and
        dstlabel = unsafeFunction()
      )
      or
      // Reading a chain of properties from any object with a prototype can lead to Function
      exists(PropertyProjection proj |
        not PropertyInjection::isPrototypeLessObject(proj.getObject().getALocalSource()) and
        src = proj.getASelector() and
        dst = proj and
        (srclabel = data() or srclabel = taint()) and
        dstlabel = unsafeFunction()
      )
    }
  }

  /**
   * A source of remote user input, considered as a source for unsafe dynamic method access.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The page URL considered as a flow source for unsafe dynamic method access.
   */
  class DocumentUrlAsSource extends Source {
    DocumentUrlAsSource() { this = DOM::locationSource() }
  }

  /**
   * A function invocation of an unsafe function, as a sink for remote unsafe dynamic method access.
   */
  class CalleeAsSink extends Sink {
    CalleeAsSink() { this = any(DataFlow::InvokeNode node).getCalleeNode() }

    override DataFlow::FlowLabel getFlowLabel() { result = unsafeFunction() }
  }
}
