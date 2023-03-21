/**
 * @name Predictable token
 * @description Tokens used for sensitive tasks, such as, password recovery,
 *  and email confirmation, should not use predictable values.
 * @kind path-problem
 * @precision medium
 * @problem.severity error
 * @security-severity 5
 * @id py/predictable-token
 * @tags security
 *       experimental
 *       external/cwe/cwe-340
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import DataFlow::PathGraph

class PredictableResultSource extends DataFlow::Node {
  PredictableResultSource() {
    exists(API::Node uuidCallRet |
      uuidCallRet = API::moduleImport("uuid").getMember(["uuid1", "uuid3", "uuid5"]).getReturn()
    |
      this = uuidCallRet.asSource()
      or
      this = uuidCallRet.getMember(["hex", "bytes", "bytes_le"]).asSource()
    )
  }
}

class TokenAssignmentValueSink extends DataFlow::Node {
  TokenAssignmentValueSink() {
    exists(string name | name.toLowerCase().matches(["%token", "%code"]) |
      exists(DefinitionNode n | n.getValue() = this.asCfgNode() | name = n.(NameNode).getId())
      or
      exists(DataFlow::AttrWrite aw | aw.getValue() = this | name = aw.getAttributeName())
    )
  }
}

class TokenBuiltFromUuidConfig extends TaintTracking::Configuration {
  TokenBuiltFromUuidConfig() { this = "TokenBuiltFromUuidConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof PredictableResultSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof TokenAssignmentValueSink }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::CallCfgNode call |
      call = API::builtin("str").getACall() and
      nodeFrom = call.getArg(0) and
      nodeTo = call
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TokenBuiltFromUuidConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Token built from $@.", source.getNode(), "predictable value"
