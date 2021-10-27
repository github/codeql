/**
 * Provides classes modeling security-relevant aspects of the `yarl` PyPI package.
 * See https://yarl.readthedocs.io/en/stable/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.Multidict
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `yarl` PyPI package.
 * See https://multidict.readthedocs.io/en/stable/.
 */
module Yarl {
  /**
   * Provides models for a the `yarl.URL` class:
   *
   * See https://yarl.readthedocs.io/en/stable/api.html#yarl.URL
   */
  module Url {
    /**
     * A source of instances of `yarl.URL`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use `Url::instance()` predicate to get references to instances of `yarl.URL`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `yarl.URL`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = API::moduleImport("yarl").getMember("URL").getACall() }
    }

    /** Gets a reference to an instance of `yarl.URL`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `yarl.URL`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `yarl.URL`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "yarl.URL" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "user", "raw_user", "password", "raw_password", "host", "raw_host", "port",
            "explicit_port", "authority", "raw_authority", "path", "raw_path", "path_qs",
            "raw_path_qs", "query_string", "raw_query_string", "fragment", "raw_fragment", "parts",
            "raw_parts", "name", "raw_name", "query"
          ]
      }

      override string getMethodName() { result = "human_repr" }

      override string getAsyncMethodName() { none() }
    }

    /**
     * Extra taint propagation for `yarl.URL`, not covered by `InstanceTaintSteps`.
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // class instantiation
        exists(ClassInstantiation call |
          nodeFrom in [call.getArg(0), call.getArgByName("val")] and
          nodeTo = call
        )
        or
        // methods that give an altered URL. taint both from object, and form argument
        // (to result of call)
        exists(DataFlow::MethodCallNode call |
          call.calls(instance(),
            [
              "with_scheme", "with_user", "with_password", "with_host", "with_port", "with_path",
              "with_query", "with_query", "update_query", "update_query", "with_fragment",
              "with_name",
              // join is a bit different, but is still correct to add here :+1:
              "join"
            ]) and
          nodeTo = call and
          nodeFrom in [call.getObject(), call.getArg(_), call.getArgByName(_)]
        )
      }
    }

    /** An attribute read on a `yarl.URL` that is a `MultiDictProxy` instance. */
    class YarlUrlMultiDictProxyInstance extends Multidict::MultiDictProxy::InstanceSource {
      YarlUrlMultiDictProxyInstance() {
        this.(DataFlow::AttrRead).getObject() = Yarl::Url::instance() and
        this.(DataFlow::AttrRead).getAttributeName() = "query"
      }
    }
  }
}
