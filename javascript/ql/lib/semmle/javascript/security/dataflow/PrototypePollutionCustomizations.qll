/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * user-controlled objects flowing into a vulnerable `extends` call,
 * as well as extension points for adding your own.
 */

import javascript
import semmle.javascript.security.TaintedObject
import semmle.javascript.dependencies.SemVer

module PrototypePollution {
  import semmle.javascript.security.CommonFlowState

  /**
   * DEPRECATED. This flow label is no longer in use, and there is no corresponding flow state, as
   * the query instead relies on implicit reads at the sinks.
   *
   * A label for wrappers around tainted objects, that is, objects that are
   * not completely user-controlled, but contain a user-controlled object.
   *
   * For example, `options` below is a tainted wrapper, but is not itself
   * a tainted object:
   * ```
   * let options = {
   *   prefs: {
   *     locale: req.query.locale
   *   }
   * }
   * ```
   */
  abstract deprecated class TaintedObjectWrapper extends DataFlow::FlowLabel {
    TaintedObjectWrapper() { this = "tainted-object-wrapper" }
  }

  /** DEPRECATED. Use `FlowState::taintedObjectWrapper()` instead. */
  deprecated module TaintedObjectWrapper {
    /** Gets the instance of the `TaintedObjectWrapper` label. */
    TaintedObjectWrapper label() { any() }
  }

  /**
   * A data flow source for prototype pollution.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the type of data coming from this source.
     */
    FlowState getAFlowState() { result.isTaintedObject() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for prototype pollution.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the type of data that can taint this sink.
     */
    FlowState getAFlowState() { result.isTaintedObject() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }

    /**
     * Holds if `moduleName` is the name of the module that defines this sink,
     * and `location` is the declaration of that dependency.
     *
     * If no meaningful `location` exists, it should be bound to the sink itself.
     */
    abstract predicate dependencyInfo(string moduleName, Locatable location);
  }

  /**
   * A user-controlled string value, as a source of prototype pollution.
   *
   * Note that values from this type of source will need to flow through a `JSON.parse` call
   * in order to be flagged for prototype pollution.
   */
  private class RemoteFlowAsSource extends Source instanceof RemoteFlowSource {
    override FlowState getAFlowState() { result.isTaint() }
  }

  /**
   * A source of user-controlled objects.
   */
  private class TaintedObjectSource extends Source instanceof TaintedObject::Source {
    override FlowState getAFlowState() { result.isTaintedObject() }
  }

  class DeepExtendSink extends Sink {
    string moduleName;
    Locatable location;

    DeepExtendSink() {
      exists(ExtendCall call |
        this = call.getASourceOperand() and
        (
          exists(Dependency dep |
            isVulnerableVersionOfDeepExtendCall(call, dep) and
            dep = location and
            dep.info(moduleName, _)
          )
          or
          isVulnerableDeepExtendCallAllVersions(call, moduleName) and
          location = call.asExpr()
        )
      )
    }

    override predicate dependencyInfo(string moduleName_, Locatable loc) {
      moduleName = moduleName_ and
      location = loc
    }
  }

  /**
   * Holds if `call` is vulnerable to prototype pollution because the callee is defined by `dep`.
   */
  predicate isVulnerableVersionOfDeepExtendCall(ExtendCall call, Dependency dep) {
    call.isDeep() and
    (
      call = DataFlow::dependencyModuleImport(dep).getAMemberCall(_) or
      call = DataFlow::dependencyModuleImport(dep).getACall()
    ) and
    exists(DependencySemVer version, string id | dep.info(id, version) |
      id = "assign-deep" and
      version.maybeBefore("0.4.7")
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
      id = "just-extend" and
      version.maybeBefore("4.0.1")
      or
      id = "jquery" and
      version.maybeBefore("3.4.0")
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
    )
  }

  /**
   * Holds if `call` comes from a package named `id` and is vulnerable to prototype pollution
   * in every version of that package.
   */
  predicate isVulnerableDeepExtendCallAllVersions(ExtendCall call, string id) {
    call.isDeep() and
    (
      call = DataFlow::moduleImport(id).getACall() or
      call = DataFlow::moduleImport(id).getAMemberCall(_)
    ) and
    id = ["deep", "extend2", "js-extend", "smart-extend"]
    or
    call.isDeep() and
    call = AngularJS::angular().getAMemberCall("merge") and
    id = "angular"
    or
    call.isDeep() and
    call = Webix::webix().getMember(["extend", "copy"]).getACall() and
    id = "webix"
  }
}
