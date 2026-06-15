/**
 * @name Predictable token
 * @description Tokens used for sensitive tasks, such as, password recovery,
 *  and email confirmation, should not use predictable values.
 * @kind path-problem
 * @precision medium
 * @problem.severity error
 * @security-severity 5
 * @id js/predictable-token
 * @tags security
 *       experimental
 *       external/cwe/cwe-340
 */

import javascript
import DataFlow

class PredictableResultSource extends DataFlow::Node {
  PredictableResultSource() {
    exists(API::Node uuidCallRet |
      uuidCallRet = API::moduleImport("uuid").getMember(["v1", "v3", "v5"]).getReturn()
    |
      this = uuidCallRet.asSource()
    )
  }
}

class TokenAssignmentValueSink extends DataFlow::Node {
  TokenAssignmentValueSink() {
    exists(string name | name.toLowerCase().matches(["%token", "%code"]) |
      exists(PropWrite pw | this = pw.getRhs() | pw.getPropertyName().toLowerCase() = name)
      or
      exists(AssignExpr ae | this = ae.getRhs().flow() |
        ae.getLhs().(VariableAccess).getVariable().getName().toLowerCase() = name
      )
    )
  }
}

module TokenBuiltFromUuidConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof PredictableResultSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof TokenAssignmentValueSink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module TokenBuiltFromUuidFlow = TaintTracking::Global<TokenBuiltFromUuidConfig>;

import TokenBuiltFromUuidFlow::PathGraph

from TokenBuiltFromUuidFlow::PathNode source, TokenBuiltFromUuidFlow::PathNode sink
where TokenBuiltFromUuidFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Token built from $@.", source.getNode(), "predictable value"
