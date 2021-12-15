/**
 * Provides classes modeling security-relevant aspects of the `jmespath` PyPI package.
 * See https://pypi.org/project/jmespath/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `jmespath` PyPI package.
 * See https://pypi.org/project/jmespath/.
 */
private module Jmespath {
  class JmespathAdditionalTaintSteps extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(DataFlow::CallCfgNode call |
        call = API::moduleImport("jmespath").getMember("search").getACall() and
        nodeFrom in [call.getArg(1), call.getArgByName("data")] and
        nodeTo = call
        or
        call =
          API::moduleImport("jmespath")
              .getMember("compile")
              .getReturn()
              .getMember("search")
              .getACall() and
        nodeFrom in [call.getArg(0), call.getArgByName("value")] and
        nodeTo = call
      )
    }
  }
}
