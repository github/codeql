/**
 * Provides a taint-tracking configuration for tracking user-controlled objects flowing
 * into a vulnerable `extends` call.
 */

import javascript
import semmle.javascript.security.TaintedObject

module PrototypePollution {
  /**
   * Label for wrappers around tainted objects, that is, objects that are
   * not completely user-controlled, but contain a user-controlled object.
   *
   * For example, `options` below is is a tainted wrapper, but is not itself
   * a tainted object:
   * ```
   * let options = {
   *   prefs: {
   *     locale: req.query.locale
   *   }
   * }
   * ```
   */
  module TaintedObjectWrapper {
    private class TaintedObjectWrapper extends DataFlow::FlowLabel {
      TaintedObjectWrapper() { this = "tainted-object-wrapper" }
    }

    TaintedObjectWrapper label() { any() }
  }

  /**
   * A data flow source for prototype pollution.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the type of data coming from this source.
     */
    abstract DataFlow::FlowLabel getAFlowLabel();
  }

  /**
   * A data flow sink for prototype pollution.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the type of data that can taint this sink.
     */
    abstract DataFlow::FlowLabel getAFlowLabel();
  }

  /**
   * A taint tracking configuration for user-controlled objects flowing into deep `extend` calls,
   * leading to prototype pollution.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "PrototypePollution" }

    override predicate isSource(DataFlow::Node node, DataFlow::FlowLabel label) {
      node.(Source).getAFlowLabel() = label
    }

    override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
      node.(Sink).getAFlowLabel() = label
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      TaintedObject::step(src, dst, inlbl, outlbl)
      or
      // Track objects are wrapped in other objects
      exists(DataFlow::PropWrite write |
        src = write.getRhs() and
        inlbl = TaintedObject::label() and
        dst = write.getBase().getALocalSource() and
        outlbl = TaintedObjectWrapper::label()
      )
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
      node instanceof TaintedObject::SanitizerGuard
    }
  }

  /**
   * A user-controlled string value, as a source of prototype pollution.
   *
   * Note that values from this type of source will need to flow through a `JSON.parse` call
   * in order to be flagged for prototype pollution.
   */
  private class RemoteFlowAsSource extends Source {
    RemoteFlowAsSource() { this instanceof RemoteFlowSource }

    override DataFlow::FlowLabel getAFlowLabel() { result = DataFlow::FlowLabel::data() }
  }

  /**
   * A source of user-controlled objects.
   */
  private class TaintedObjectSource extends Source {
    TaintedObjectSource() { this instanceof TaintedObject::Source }

    override DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }
  
  string getModuleName(ExtendCall call) {
    call = DataFlow::moduleImport(result).getACall() or
    call = DataFlow::moduleMember(result, _).getACall()
  }

  class DeepExtendSink extends Sink {
    ExtendCall call;

    DeepExtendSink() {
      this = call.getASourceOperand() and
      call.isDeep() and
      exists(string moduleName | moduleName = getModuleName(call) |
        moduleName = "lodash" + any(string s) or
        moduleName = "just-extend" or
        moduleName = "extend" or
        moduleName = "extend2" or
        moduleName = "node.extend" or
        moduleName = "merge" or
        moduleName = "smart-extend" or
        moduleName = "js-extend" or
        moduleName = "deep" or
        moduleName = "defaults-deep"
      )
    }

    override DataFlow::FlowLabel getAFlowLabel() {
      result = TaintedObject::label()
      or
      result = TaintedObjectWrapper::label()
    }
  }
}
