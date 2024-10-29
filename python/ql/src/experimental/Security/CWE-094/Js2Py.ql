/**
 * @name JavaScript code execution.
 * @description Passing user supplied arguments to a Javascript to Python translation engine such as Js2Py can lead to remote code execution.
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @kind path-problem
 * @id py/js2py-rce
 * @tags security
 *       experimental
 *       external/cwe/cwe-94
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.Concepts

module Js2PyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node node) {
    API::moduleImport("js2py").getMember(["eval_js", "eval_js6", "EvalJs"]).getACall().getArg(_) =
      node
  }
}

module Js2PyFlow = TaintTracking::Global<Js2PyFlowConfig>;

import Js2PyFlow::PathGraph

from Js2PyFlow::PathNode source, Js2PyFlow::PathNode sink
where
  Js2PyFlow::flowPath(source, sink) and
  not exists(API::moduleImport("js2py").getMember("disable_pyimport").getACall())
select sink, source, sink, "This input to Js2Py depends on a $@.", source.getNode(),
  "user-provided value"
