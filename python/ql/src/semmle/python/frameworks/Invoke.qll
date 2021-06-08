/**
 * Provides classes modeling security-relevant aspects of the `invoke` PyPI package.
 * See https://www.pyinvoke.org/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `invoke` PyPI package.
 * See https://www.pyinvoke.org/.
 */
private module Invoke {
  // ---------------------------------------------------------------------------
  // invoke
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `invoke` module. */
  API::Node invoke() { result = API::moduleImport("invoke") }

  /** Provides models for the `invoke` module. */
  module invoke {
    /** Gets a reference to the `invoke.context` module. */
    API::Node context() { result = invoke().getMember("context") }

    /** Provides models for the `invoke.context` module */
    module context {
      /** Provides models for the `invoke.context.Context` class */
      module Context {
        /** Gets a reference to the `invoke.context.Context` class. */
        API::Node classRef() {
          result = API::moduleImport("invoke").getMember("context").getMember("Context")
          or
          result = API::moduleImport("invoke").getMember("Context")
        }

        /** Gets a reference to an instance of `invoke.context.Context`. */
        private DataFlow::LocalSourceNode instance(DataFlow::TypeTracker t) {
          t.start() and
          (
            result = invoke::context::Context::classRef().getACall()
            or
            exists(Function func |
              func.getADecorator() = invoke().getMember("task").getAUse().asExpr() and
              result.(DataFlow::ParameterNode).getParameter() = func.getArg(0)
            )
          )
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `invoke.context.Context`. */
        DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

        /** Gets a reference to the `run` or `sudo` methods on a `invoke.context.Context` instance. */
        private DataFlow::LocalSourceNode instanceRunMethods(DataFlow::TypeTracker t) {
          t.startInAttr(["run", "sudo"]) and
          result = invoke::context::Context::instance()
          or
          exists(DataFlow::TypeTracker t2 | result = instanceRunMethods(t2).track(t2, t))
        }

        /** Gets a reference to the `run` or `sudo` methods on a `invoke.context.Context` instance. */
        DataFlow::Node instanceRunMethods() {
          instanceRunMethods(DataFlow::TypeTracker::end()).flowsTo(result)
        }
      }
    }
  }

  /**
   * A call to either
   * - `invoke.run` or `invoke.sudo` functions (http://docs.pyinvoke.org/en/stable/api/__init__.html)
   * - `run` or `sudo` methods on a `invoke.context.Context` instance (http://docs.pyinvoke.org/en/stable/api/context.html#invoke.context.Context.run)
   */
  private class InvokeRunCommandCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    InvokeRunCommandCall() {
      this = invoke().getMember(["run", "sudo"]).getACall() or
      this.getFunction() = invoke::context::Context::instanceRunMethods()
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("command")]
    }
  }
}
