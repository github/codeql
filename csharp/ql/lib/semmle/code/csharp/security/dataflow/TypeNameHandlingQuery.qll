import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.serialization.Deserializers

class BadTypeHandling extends Expr {
  BadTypeHandling() {
    exists(Enum e, EnumConstant c |
      e.hasFullyQualifiedName("Newtonsoft.Json", "TypeNameHandling") and
      c = e.getAnEnumConstant() and
      this = c.getAnAccess() and
      not c.hasName("None")
    ) or 
    this.(IntegerLiteral).getValue().toInt() > 0
  }
}

class TypeNameHandlingProperty extends Property {
    TypeNameHandlingProperty() {
      this.hasFullyQualifiedName("Newtonsoft.Json", ["JsonSerializerSettings", "JsonSerializer"], "TypeNameHandling")
    }
}

class TypeNameHandlingPropertyWrite extends PropertyWrite {
  TypeNameHandlingPropertyWrite() { this.getProperty() instanceof TypeNameHandlingProperty }

  Expr getAssignedValue() {
    exists(AssignExpr a |
      a.getLValue() = this and
      result = a.getRValue()
    )
  }
}

class BadTypeHandlingPropertyWrite extends TypeNameHandlingPropertyWrite {
  BadTypeHandlingPropertyWrite() {
    exists(BadTypeHandling b | 
      DataFlow::localExprFlow(b, this.getAssignedValue())  
    )
  }
}

class BinderPropertyWrite extends PropertyWrite {
  BinderPropertyWrite() {
    this.getProperty().hasFullyQualifiedName("Newtonsoft.Json", ["JsonSerializerSettings", "JsonSerializer"], ["SerializationBinder", "Binder"])
  }
}

module UserInputToDeserializeObjectCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc | 
      mc.getTarget().hasFullyQualifiedName("Newtonsoft.Json.JsonConvert", _) and 
      mc.getTarget().hasUndecoratedName("DeserializeObject") and 
      sink.asExpr() = mc.getAnArgument()
    )
  }
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ){
    exists(MethodCall ma |
      ma.getTarget().hasName("ToString") and
      ma.getQualifier() = pred.asExpr() and
      succ.asExpr() = ma
    )
  }
}

module UserInputToDeserializeObjectCallFlow = TaintTracking::Global<UserInputToDeserializeObjectCallConfig>;

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

class TypeNameHandlingPropertySink extends DataFlow::Node {
  TypeNameHandlingPropertySink() {
    exists(TypeNameHandlingPropertyWrite pw |
      this.asExpr() = pw.getAssignedValue()
    )
  }

  predicate hasBinderSet() {
    exists(JsonSerializerSettingsArg arg |
      this.asExpr() = arg and
      hasBinderSet(arg)
    )
  }

}

module UnsafeTypeNameHandlingFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof BadTypeHandling
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() instanceof JsonSerializerSettingsArg
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.asExpr() instanceof IntegerLiteral and
    node2.asExpr().(CastExpr).getExpr() = node1.asExpr()
    or
    node1.getType() instanceof TypeNameHandlingEnum and
    exists(TypeNameHandlingPropertyWrite pw, Assignment a |
      a.getLValue() = pw and
      (
        // Explicit property write: flow from the assigned value to the JsonSerializerSettingsArg
        // that accesses the same settings variable
        node1.asExpr() = a.getRValue() and
        node2.asExpr().(JsonSerializerSettingsArg).(VariableAccess).getTarget() =
          pw.getQualifier().(VariableAccess).getTarget()
        or
        // ObjectInitializer case: flow from the member initializer value to the
        // ObjectCreation, which then flows locally to the JsonSerializerSettingsArg
        exists(ObjectInitializer oi, ObjectCreation oc |
          node1.asExpr() = oi.getAMemberInitializer().getRValue() and
          oc.getInitializer() = oi and
          DataFlow::localExprFlow(oc, node2.asExpr().(JsonSerializerSettingsArg))
        )
      )
    )
  }
}

module UnsafeTypeNameHandlingFlow = DataFlow::Global<UnsafeTypeNameHandlingFlowConfig>;

/**
 * An ObjectCreation of type `Newtonson.Json.JsonSerializerSettings.JsonSerializerSettings` or  `Newtonson.Json.JsonSerializerSettings.JsonSerializer`.
 */
class JsonSerializerSettingsCreation extends ObjectCreation {
  JsonSerializerSettingsCreation() {
    this.getTarget()
        .hasFullyQualifiedName("Newtonsoft.Json.JsonSerializerSettings", "JsonSerializerSettings") or 
    this.getTarget()
        .hasFullyQualifiedName("Newtonsoft.Json.JsonSerializer", "JsonSerializer")        
  }
  Class getAssignedBinderType(){
    exists(AssignExpr ae | 
      ae.getLValue() = this.getBinderPropertyWrite() and
      ae.getRValue().getType() = result  
    )
  }

  BinderPropertyWrite getBinderPropertyWrite() {
    result = this.getPropertyWrite()
  }

  TypeNameHandlingPropertyWrite getTypeNameHandlingPropertyWrite() {
    result = this.getPropertyWrite()
  }

  PropertyWrite getPropertyWrite(){
    result = this.getInitializer().getAChild*()
    or
    // Direct local flow via some intermediary
    DataFlow::localExprFlow(this, result.getQualifier())
    or
    // Local flow via property writes
    hasPropertyWrite(result)
  }

  /**
   * The qualifier to `pw` is a property, which this value flows into somewhere locally.
   * Janky local DF. 
   * */
  bindingset[pw]
  pragma[inline_late]
  predicate hasPropertyWrite(PropertyWrite pw){
    exists(Assignment a |
      a.getRValue() = this
      and a.getLValue().(PropertyAccess).getTarget() = pw.getQualifier().(PropertyAccess).getTarget()
      and a.getEnclosingCallable() = pw.getEnclosingCallable()
    )
  }
}