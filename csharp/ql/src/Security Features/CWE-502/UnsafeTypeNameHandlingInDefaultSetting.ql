/**
 * @name Unsafe TypeNameHandling assigned to JsonConvert.DefaultSetting
 * @description Using an unsafe TypeNameHandling constant is a security vulnerability.
 * @kind problem
 * @id cs/unsafe-type-name-handling-default-setting
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.TypeNameHandlingQuery
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate

module TypeNameHandlingDefaultSettingsFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JsonSerializerSettingsCreation
  }

  predicate isSink(DataFlow::Node sink) {
    exists(AssignExpr ae, PropertyWrite pw |
      pw.getProperty().hasFullyQualifiedName("Newtonsoft.Json.JsonConvert", "DefaultSettings") and
      sink.asExpr() = ae.getRValue() and
      pw = ae.getLValue()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Step from the dataflow node representing the return value of the lambda to the lambda itself.
    exists(LambdaExpr le |
      pred.(DataFlowPrivate::ReturnNode).getEnclosingCallable() = le and
      le = succ.asExpr()
    )
  }
}

module TypeNameHandlingDefaultSettingsFlow =
  TaintTracking::Global<TypeNameHandlingDefaultSettingsFlowConfig>;

from DataFlow::Node badTypeNameHandling, DataFlow::Node typeNameHandlingPropertyWrite
where
  TypeNameHandlingDefaultSettingsFlow::flow(badTypeNameHandling, typeNameHandlingPropertyWrite) and
  // Detecting if there exists some flow from user input to a call that could use the unsafe settings
  // Not including the actual flow in the results because doing so a cartesian product as the two flows are unrelated
  UserInputToDeserializeObjectCallFlow::flow(_, _)
select badTypeNameHandling,
  "Assignment of this TypeNameHandling constant to JsonConvert.DefaultSettings is unsafe"
