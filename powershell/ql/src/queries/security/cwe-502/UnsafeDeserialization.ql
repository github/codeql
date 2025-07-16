/**
 * @name Unsafe deserializer
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/unsafe-deserialization
 * @tags correctness
 *       security
 *       external/cwe/cwe-502
 */

import powershell
import semmle.code.powershell.dataflow.flowsources.FlowSources
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.dataflow.TaintTracking

module DeserializationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SourceNode }

  predicate isSink(DataFlow::Node sink) { 
    exists(DataFlow::ObjectCreationNode ocn, DataFlow::CallNode cn | 
        cn.getQualifier().getALocalSource() = ocn and 
        ocn.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Runtime.Serialization.Formatters.Binary.BinaryFormatter" and
        cn.getLowerCaseName() = "deserialize" and
        cn.getAnArgument() = sink
    )
  }
  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo){
    exists(InvokeMemberExpr ime | 
        nodeTo.asExpr().getExpr() = ime and 
        nodeFrom.asExpr().getExpr() = ime.getAnArgument()
    )
  }
}

module DeserializationFlow = TaintTracking::Global<DeserializationConfig>; 

from DataFlow::Node source, DataFlow::Node sink
where DeserializationFlow::flow(source, sink)
select sink, "Unsafe deserializer is used. Make sure the value being deserialized comes from a trusted source."
