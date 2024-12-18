/**
 * Provides classes modeling security-relevant aspects of the `pydantic` PyPI package.
 *
 * See
 * - https://pypi.org/project/pydantic/
 * - https://pydantic-docs.helpmanual.io/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for `pydantic` PyPI package.
 *
 * See
 * - https://pypi.org/project/pydantic/
 * - https://pydantic-docs.helpmanual.io/
 */
module Pydantic {
  /**
   * Provides models for `pydantic.BaseModel` subclasses (a pydantic model).
   *
   * See https://pydantic-docs.helpmanual.io/usage/models/.
   */
  module BaseModel {
    /** Gets a reference to a `pydantic.BaseModel` subclass (a pydantic model). */
    API::Node subclassRef() {
      result = API::moduleImport("pydantic").getMember("BaseModel").getASubclass+()
      or
      result = ModelOutput::getATypeNode("pydantic.BaseModel~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `pydantic.BaseModel` subclasses, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `BaseModel::instance()` to get references to instances of `pydantic.BaseModel`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of a `pydantic.BaseModel` subclass. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      t.start() and
      instanceStepToPydanticModel(_, result)
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of a `pydantic.BaseModel` subclass. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * A step from an instance of a `pydantic.BaseModel` subclass, that might result in
     * an instance of a `pydantic.BaseModel` subclass.
     *
     * NOTE: We currently overapproximate, and treat all attributes as containing
     * another pydantic model. For the code below, we _could_ limit this to `main_foo`
     * and members of `other_foos`. IF THIS IS CHANGED, YOU MUST CHANGE THE ADDITIONAL
     * TAINT STEPS BELOW, SUCH THAT SIMPLE ACCESS OF SOMETHING LIKE `str` IS STILL
     * TAINTED.
     *
     *
     * ```py
     * class MyComplexModel(BaseModel):
     * field: str
     * main_foo: Foo
     * other_foos: List[Foo]
     * ```
     */
    private predicate instanceStepToPydanticModel(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      // attributes (such as `model.foo`)
      nodeFrom = instance() and
      nodeTo.(DataFlow::AttrRead).getObject() = nodeFrom
      or
      // subscripts on attributes (such as `model.foo[0]`). This needs to handle nested
      // lists (such as `model.foo[0][0]`), and access being split into multiple
      // statements (such as `xs = model.foo; xs[0]`).
      //
      // To handle this we overapproximate which things are a Pydantic model, by
      // treating any subscript on anything that originates on a Pydantic model to also
      // be a Pydantic model. So `model[0]` will be an overapproximation, but should not
      // really cause problems (since we don't expect real code to contain such accesses)
      nodeFrom = instance() and
      nodeTo.asCfgNode().(SubscriptNode).getObject() = nodeFrom.asCfgNode()
    }

    /**
     * Extra taint propagation for `pydantic.BaseModel` subclasses. (note that these could also be `pydantic.BaseModel` subclasses)
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // NOTE: if `instanceStepToPydanticModel` is changed to be more precise, these
        // taint steps should be expanded, such that a field that has type `str` is
        // still tainted.
        instanceStepToPydanticModel(nodeFrom, nodeTo)
      }
    }
  }
}
