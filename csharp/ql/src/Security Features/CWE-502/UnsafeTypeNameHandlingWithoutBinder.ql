/**
 * @name Unsafe TypeNameHandling without Binder to deserialize user input
 * @description Using an unsafe TypeNameHandling constant is a security vulnerability.
 * @kind path-problem
 * @id cs/unsafe-type-name-handling-without-binder
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.serialization.Deserializers
import semmle.code.csharp.security.dataflow.TypeNameHandlingQuery

class DeserializeArg extends Expr {
  MethodCall deserializeCall; 
  DeserializeArg() {
    deserializeCall.getTarget() instanceof NewtonsoftJsonConvertClassDeserializeObjectMethod and
    deserializeCall.getAnArgument() = this
  }
  MethodCall getDeserializeCall() {
    result = deserializeCall
  }
}

class JsonSerializerSettingsArg extends DeserializeArg {
  JsonSerializerSettingsArg() {
    this.getType() instanceof JsonSerializerSettingsClass
  }
}

predicate hasBinderSet(JsonSerializerSettingsArg arg) {
  // //passed as argument to initializer
  exists(BinderFlow::PathNode sink | 
    sink.isSink() and
    sink.getNode().asExpr() = arg
  ) or
  //set in later Propertywrite
  exists(PropertyWrite pw |
    pw.getProperty().hasName(["Binder", "SerializationBinder"]) and
    pw.getQualifier().(Access).getTarget() = arg.(Access).getTarget()
  )
}

module BinderConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source){
    exists(ObjectCreation oc, MemberInitializer mi |
      oc.getInitializer().(ObjectInitializer).getAMemberInitializer() = mi and
      mi.getInitializedMember().hasName(["Binder", "SerializationBinder"]) and
      source.asExpr() = oc
    )
  }
  predicate isSink(DataFlow::Node sink){
    sink.asExpr() instanceof JsonSerializerSettingsArg
  }
}
module BinderFlow = DataFlow::Global<BinderConfig>;

module TypeNameFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof BadTypeHandling
  }

  predicate isSink(DataFlow::Node sink) {
    exists(JsonSerializerSettingsArg arg |
      not hasBinderSet(arg) and
      sink.asExpr() = arg
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.asExpr() instanceof IntegerLiteral and
    node2.asExpr().(CastExpr).getExpr() = node1.asExpr()
    or
    node1.getType() instanceof TypeNameHandlingEnum and
    exists(TypeNameHandlingPropertyWrite pw, Assignment a |
      a.getLValue() = pw and
      (
        node1.asExpr() = a.getRValue() and
        node2.asExpr() = pw.getQualifier()
        or
        exists(ObjectInitializer oi |
          node1.asExpr() = oi.getAMemberInitializer().getRValue() and
          node2.asExpr() = oi
        )
      )
    )
  }
}

module TypeNameFlow = DataFlow::Global<TypeNameFlowConfig>;

import UserInputToDeserializeObjectCallFlow::PathGraph

from 
UserInputToDeserializeObjectCallFlow::PathNode userInput, UserInputToDeserializeObjectCallFlow::PathNode deserializeArg,
DataFlow::Node badTypeNameHandling, DataFlow::Node typeNameHandlingSettingArg, 
BadTypeHandling bth
where 
TypeNameFlow::flow(badTypeNameHandling, typeNameHandlingSettingArg) and 
UserInputToDeserializeObjectCallFlow::flowPath(userInput, deserializeArg) and 
deserializeArg.getNode().asExpr().(DeserializeArg).getDeserializeCall() =  typeNameHandlingSettingArg.asExpr().(JsonSerializerSettingsArg).getDeserializeCall() and
bth = badTypeNameHandling.asExpr()
select deserializeArg.getNode(), userInput, deserializeArg, "Use of $@ constant to deserialize user-controlled input is unsafe", bth, "this Json.net TypeNameHandling"