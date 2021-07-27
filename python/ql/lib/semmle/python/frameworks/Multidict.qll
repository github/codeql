/**
 * Provides classes modeling security-relevant aspects of the `multidict` PyPI package.
 * See https://multidict.readthedocs.io/en/stable/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `multidict` PyPI package.
 * See https://multidict.readthedocs.io/en/stable/.
 */
module Multidict {
  /**
   * Provides models for a `MultiDictProxy` class:
   * - `multidict.MultiDictProxy`
   * - `multidict.CIMultiDictProxy`
   *
   * See https://multidict.readthedocs.io/en/stable/multidict.html#multidictproxy
   */
  module MultiDictProxy {
    /** Gets a reference to a `MultiDictProxy` class. */
    API::Node classRef() {
      result = API::moduleImport("multidict").getMember(["MultiDictProxy", "CIMultiDictProxy"])
    }

    /**
     * A source of instances of `multidict.MultiDictProxy`, extend this class to model
     * new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use `MultiDictProxy::instance()` predicate to get
     * references to instances of `multidict.MultiDictProxy`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of a `MultiDictProxy` class. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of a `MultiDictProxy` class. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of a `MultiDictProxy` class. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `multidict.MultiDictProxy`.
     *
     * See https://multidict.readthedocs.io/en/stable/multidict.html#multidictproxy
     */
    class MultiDictProxyAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // class instantiation
        exists(ClassInstantiation call |
          nodeFrom = call.getArg(0) and
          nodeTo = call
        )
        or
        // Methods
        //
        // TODO: When we have tools that make it easy, model these properly to handle
        // `meth = obj.meth; meth()`. Until then, we'll use this more syntactic approach
        // (since it allows us to at least capture the most common cases).
        nodeFrom = instance() and
        exists(DataFlow::AttrRead attr | attr.getObject() = nodeFrom |
          // methods (non-async)
          attr.getAttributeName() in ["getone", "getall"] and
          nodeTo.(DataFlow::CallCfgNode).getFunction() = attr
        )
      }
    }
  }
}
