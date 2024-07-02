/**
 * @name JavaScript code execution.
 * @description Passing user supplied arguments to a Javascript to Python translation engine such as Js2Py can lead to remote code execution.
 * @severity high
 * @kind path-problem
 * @id python/js2py-rce
 * @tags security
 *       experimental
 *       external/cwe/cwe-94
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts

private API::Node js2py() { result = API::moduleImport("js2py") }

private API::Node js2evaljs() { result = js2py().getMember(["eval_js", "eval_js6"]) }

private class DisablePyImportCall extends API::CallNode, DataFlow::CallCfgNode {
  DisablePyImportCall() { this = js2py().getMember("disable_pyimport").getACall() }
}

class EvalJsCall extends API::CallNode, DataFlow::CallCfgNode {
  EvalJsCall() { this = js2evaljs().getACall() }
}

module Js2PyFlowConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) { exists(EvalJsCall e | e.getArg(_) = node) }
}

module Js2PyFlow = TaintTracking::Global<Js2PyFlowConfiguration>;

import Js2PyFlow::PathGraph

from Js2PyFlow::PathNode source, Js2PyFlow::PathNode sink
where
  Js2PyFlow::flowPath(source, sink) and
  not exists(DisablePyImportCall c)
select sink, source, sink, "This can lead to arbitrary code execution"
