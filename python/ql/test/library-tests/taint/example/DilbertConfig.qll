/**
 * @kind path-problem
 *
 * An example configuration.
 * See ExampleConfiguration.expected for the results of running this query.
 */

import python
import semmle.python.dataflow.Configuration

/* First of all we set up some TaintKinds */
class Engineer extends TaintKind {
  Engineer() { this = "Wally" or this = "Dilbert" }
}

class Wally extends Engineer {
  Wally() { this = "Wally" }
}

/** The configuration for this example. */
class DilbertConfig extends TaintTracking::Configuration {
  DilbertConfig() { this = "Dilbert config" }

  override predicate isSource(DataFlow::Node node, TaintKind kind) {
    node.asAstNode().(Name).getId() = "ENGINEER" and kind instanceof Engineer
  }

  override predicate isSink(DataFlow::Node node, TaintKind kind) {
    /* Engineers hate meetings */
    function_param("meeting", node) and kind instanceof Engineer
  }

  override predicate isBarrier(DataFlow::Node node, TaintKind kind) {
    /* There is no way that Wally is working through lunch */
    function_param("lunch", node) and kind instanceof Wally
  }

  override predicate isBarrier(DataFlow::Node node) {
    /* Even the conscientious stop work if the building is on fire */
    function_param("fire", node)
  }
}

/** Helper predicate looking for `funcname(..., arg, ...)` */
private predicate function_param(string funcname, DataFlow::Node arg) {
  exists(Call call |
    call.getFunc().(Name).getId() = funcname and
    arg.asAstNode() = call.getAnArg()
  )
}
