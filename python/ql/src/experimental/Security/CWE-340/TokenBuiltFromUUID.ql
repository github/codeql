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

private module TokenBuiltFromUuidConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof PredictableResultSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof TokenAssignmentValueSink }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::CallCfgNode call |
      call = API::builtin("str").getACall() and
      nodeFrom = call.getArg(0) and
      nodeTo = call
    )
  }
}

/** Global taint-tracking for detecting "TokenBuiltFromUUID" vulnerabilities. */
module TokenBuiltFromUuidFlow = TaintTracking::Global<TokenBuiltFromUuidConfig>;

import TokenBuiltFromUuidFlow::PathGraph

from TokenBuiltFromUuidFlow::PathNode source, TokenBuiltFromUuidFlow::PathNode sink
where TokenBuiltFromUuidFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Token built from $@.", source.getNode(), "predictable value"
