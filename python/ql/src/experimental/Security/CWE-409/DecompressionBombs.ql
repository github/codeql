/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id py/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.internal.DataFlowPublic
import experimental.semmle.python.security.DecompressionBomb
import FileAndFormRemoteFlowSource::FileAndFormRemoteFlowSource

/**
 * `io.TextIOWrapper(ip, encoding='utf-8')` like following:
 * ```python
 * with gzip.open(bomb_input, 'rb') as ip:
 *   with io.TextIOWrapper(ip, encoding='utf-8') as decoder:
 *     content = decoder.read()
 *     print(content)
 * ```
 * I saw this builtin method many places so I added it as a AdditionalTaintStep.
 * it would be nice if it is added as a global AdditionalTaintStep
 */
predicate isAdditionalTaintStepTextIOWrapper(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(API::CallNode textIOWrapper |
    textIOWrapper = API::moduleImport("io").getMember("TextIOWrapper").getACall()
  |
    nodeFrom = textIOWrapper.getParameter(0, "input").asSink() and
    nodeTo = textIOWrapper
  )
}

module BombsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    (
      source instanceof RemoteFlowSource
      or
      source instanceof FastAPI
    ) and
    not source.getLocation().getFile().inStdlib() and
    not source.getLocation().getFile().getRelativePath().matches("%venv%")
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof DecompressionBomb::Sink and
    not sink.getLocation().getFile().inStdlib() and
    not sink.getLocation().getFile().getRelativePath().matches("%venv%")
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    (
      any(DecompressionBomb::AdditionalTaintStep a).isAdditionalTaintStep(pred, succ) or
      isAdditionalTaintStepTextIOWrapper(pred, succ)
    ) and
    not succ.getLocation().getFile().inStdlib() and
    not succ.getLocation().getFile().getRelativePath().matches("%venv%")
  }
}

module BombsFlow = TaintTracking::Global<BombsConfig>;

import BombsFlow::PathGraph

from BombsFlow::PathNode source, BombsFlow::PathNode sink
where BombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This uncontrolled file extraction is $@.", source.getNode(),
  "depends on this user controlled data"
