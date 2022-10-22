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
 *       external/cwe/cwe-340
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class PredictableResultSource extends DataFlow::Node {
  PredictableResultSource() {
    exists(API::Node uuidCallRet |
      uuidCallRet =
        API::moduleImport("uuid").getMember(["v1", "v2", "v3", "v5"]).getACall().getReturn()
    |
      this = uuidCallRet.asSource()
    )
  }
}

class TokenAssignmentValueSink extends DataFlow::Node {
  TokenAssignmentValueSink() {
    exists(PropWrite pw | this = pw.getRhs() |
      pw.getPropertyName().toLowerCase().matches(["%token", "%code"])
    )
    or
    exists(AssignExpr ae | this = ae.getRhs().flow() |
      ae.getLhs()
          .(VariableAccess)
          .getVariable()
          .getName()
          .toLowerCase()
          .matches(["%token", "%code"])
    )
  }
}

class TokenBuiltFromUUIDConfig extends TaintTracking::Configuration {
  TokenBuiltFromUUIDConfig() { this = "TokenBuiltFromUUIDConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof PredictableResultSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof TokenAssignmentValueSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TokenBuiltFromUUIDConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Token built from $@.", source.getNode(), "predictable value"
