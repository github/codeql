/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * user-controlled objects flowing into a vulnerable `extends` call,
 * as well as extension points for adding your own.
 */

import javascript
import semmle.javascript.security.TaintedObject
import semmle.javascript.dependencies.Dependencies
import semmle.javascript.dependencies.SemVer

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

    /**
     * Gets the dependency that defines this sink.
     */
    abstract Dependency getDependency();
  }

  /**
   * A user-controlled string value, as a source of prototype pollution.
   *
   * Note that values from this type of source will need to flow through a `JSON.parse` call
   * in order to be flagged for prototype pollution.
   */
  private class RemoteFlowAsSource extends Source {
    RemoteFlowAsSource() { this instanceof RemoteFlowSource }

    override DataFlow::FlowLabel getAFlowLabel() { result.isData() }
  }

  /**
   * A source of user-controlled objects.
   */
  private class TaintedObjectSource extends Source {
    TaintedObjectSource() { this instanceof TaintedObject::Source }

    override DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }

  class DeepExtendSink extends Sink {
    ExtendCall call;

    Dependency dependency;

    DeepExtendSink() {
      this = call.getASourceOperand() and
      isVulnerableDeepExtendCall(call, dependency)
    }

    override DataFlow::FlowLabel getAFlowLabel() {
      result = TaintedObject::label()
      or
      result = TaintedObjectWrapper::label()
    }

    override Dependency getDependency() { result = dependency }
  }

  /**
   * Holds if `call` is vulnerable to prototype pollution because the callee is defined by `dep`.
   */
  predicate isVulnerableDeepExtendCall(ExtendCall call, Dependency dep) {
    call.isDeep() and
    (
      call = DataFlow::dependencyModuleImport(dep).getAMemberCall(_) or
      call = DataFlow::dependencyModuleImport(dep).getACall()
    ) and
    exists(DependencySemVer version, string id | dep.info(id, version) |
      id = "assign-deep" and
      version.maybeBefore("0.4.7")
      or
      id = "deep"
      or
      id = "deep-extend" and
      version.maybeBefore("0.5.1")
      or
      id = "defaults-deep" and
      version.maybeBefore("0.2.4")
      or
      id = "extend" and
      (version.maybeBefore("2.0.2") or version.maybeBetween("3.0.0", "3.0.2"))
      or
      id = "extend2"
      or
      id = "js-extend"
      or
      id = "just-extend" and
      version.maybeBefore("4.0.1")
      or
      id = "lodash" + any(string s) and
      version.maybeBefore("4.17.12")
      or
      id = "merge" and
      version.maybeBefore("1.2.1")
      or
      id = "merge-deep" and
      version.maybeBefore("3.0.1")
      or
      id = "merge-options" and
      version.maybeBefore("1.0.1")
      or
      id = "node.extend" and
      (version.maybeBefore("1.1.7") or version.maybeBetween("2.0.0", "2.0.1"))
      or
      id = "smart-extend"
    )
  }
}
