/**
 * Provides classes and predicates for detecting unsafe usage of
 * Newtonsoft.Json `TypeNameHandling` settings.
 *
 * Setting `TypeNameHandling` to any value other than `None` during
 * deserialization can enable remote code execution if untrusted data
 * is deserialized without a custom `SerializationBinder`.
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.serialization.Deserializers

// ---------------------------------------------------------------------------
// Source expressions: unsafe TypeNameHandling values
// ---------------------------------------------------------------------------
/**
 * An expression that represents an unsafe `TypeNameHandling` value —
 * any member of the `TypeNameHandling` enum other than `None`, or an
 * integer literal greater than zero (which maps to a non-`None` value).
 */
class BadTypeHandling extends Expr {
  BadTypeHandling() {
    exists(Enum e, EnumConstant c |
      e.hasFullyQualifiedName("Newtonsoft.Json", "TypeNameHandling") and
      c = e.getAnEnumConstant() and
      this = c.getAnAccess() and
      not c.hasName("None")
    )
    or
    this.(IntegerLiteral).getValue().toInt() > 0
  }
}

// ---------------------------------------------------------------------------
// TypeNameHandling property modelling
// ---------------------------------------------------------------------------
/**
 * The `TypeNameHandling` property on `JsonSerializerSettings` or `JsonSerializer`.
 */
class TypeNameHandlingProperty extends Property {
  TypeNameHandlingProperty() {
    this.hasFullyQualifiedName("Newtonsoft.Json",
      ["JsonSerializerSettings", "JsonSerializer"], "TypeNameHandling")
  }
}

/** A write to a `TypeNameHandling` property. */
class TypeNameHandlingPropertyWrite extends PropertyWrite {
  TypeNameHandlingPropertyWrite() { this.getProperty() instanceof TypeNameHandlingProperty }

  /** Gets the right-hand side value assigned to this property. */
  Expr getAssignedValue() {
    exists(AssignExpr a |
      a.getLValue() = this and
      result = a.getRValue()
    )
  }
}

/**
 * A write to a `TypeNameHandling` property where the assigned value is
 * known to be unsafe (i.e. not `None`).
 */
class BadTypeHandlingPropertyWrite extends TypeNameHandlingPropertyWrite {
  BadTypeHandlingPropertyWrite() {
    exists(BadTypeHandling b |
      DataFlow::localExprFlow(b, this.getAssignedValue())
    )
  }
}

// ---------------------------------------------------------------------------
// Binder property modelling
// ---------------------------------------------------------------------------
/**
 * A write to the `SerializationBinder` or `Binder` property on
 * `JsonSerializerSettings` or `JsonSerializer`. Setting a custom binder
 * is a mitigation against unsafe `TypeNameHandling`.
 */
class BinderPropertyWrite extends PropertyWrite {
  BinderPropertyWrite() {
    this.getProperty()
        .hasFullyQualifiedName("Newtonsoft.Json",
          ["JsonSerializerSettings", "JsonSerializer"],
          ["SerializationBinder", "Binder"])
  }
}

// ---------------------------------------------------------------------------
// Deserialize call argument modelling
// ---------------------------------------------------------------------------
/**
 * An argument passed to a `Newtonsoft.Json.JsonConvert.DeserializeObject` call.
 */
class DeserializeArg extends Expr {
  MethodCall deserializeCall;

  DeserializeArg() {
    deserializeCall.getTarget() instanceof NewtonsoftJsonConvertClassDeserializeObjectMethod and
    deserializeCall.getAnArgument() = this
  }

  /** Gets the enclosing `DeserializeObject` method call. */
  MethodCall getDeserializeCall() { result = deserializeCall }
}

/**
 * A `JsonSerializerSettings`-typed argument passed to a `DeserializeObject`
 * call. This is the primary sink for unsafe `TypeNameHandling` flow.
 */
class JsonSerializerSettingsArg extends DeserializeArg {
  JsonSerializerSettingsArg() { this.getType() instanceof JsonSerializerSettingsClass }
}

// ---------------------------------------------------------------------------
// Taint tracking: remote input → DeserializeObject
// ---------------------------------------------------------------------------
/**
 * Tracks tainted data flowing from remote sources into arguments of
 * `JsonConvert.DeserializeObject`, including flow through `ToString()` calls.
 */
module UserInputToDeserializeObjectCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasFullyQualifiedName("Newtonsoft.Json.JsonConvert", _) and
      mc.getTarget().hasUndecoratedName("DeserializeObject") and
      sink.asExpr() = mc.getAnArgument()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodCall ma |
      ma.getTarget().hasName("ToString") and
      ma.getQualifier() = pred.asExpr() and
      succ.asExpr() = ma
    )
  }
}

module UserInputToDeserializeObjectCallFlow =
  TaintTracking::Global<UserInputToDeserializeObjectCallConfig>;

// ---------------------------------------------------------------------------
// Data flow: binder set on settings object
// ---------------------------------------------------------------------------
/**
 * Tracks whether a `SerializationBinder` is assigned via an object
 * initializer and the resulting settings object flows to a
 * `DeserializeObject` call argument.
 */
module BinderConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ObjectCreation oc, MemberInitializer mi |
      oc.getInitializer().(ObjectInitializer).getAMemberInitializer() = mi and
      mi.getInitializedMember().hasName(["Binder", "SerializationBinder"]) and
      source.asExpr() = oc
    )
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof JsonSerializerSettingsArg }
}

module BinderFlow = DataFlow::Global<BinderConfig>;

// ---------------------------------------------------------------------------
// Binder-set check (mitigation detection)
// ---------------------------------------------------------------------------
/**
 * Holds if a custom `SerializationBinder` or `Binder` has been set on the
 * settings object referenced by `arg`, either through an object initializer
 * (tracked via `BinderFlow`) or through a later property write on the same
 * variable.
 */
predicate hasBinderSet(JsonSerializerSettingsArg arg) {
  // Binder was set in an object initializer and flowed to `arg`
  exists(BinderFlow::PathNode sink |
    sink.isSink() and
    sink.getNode().asExpr() = arg
  )
  or
  // Binder was set via a property write on the same variable
  exists(PropertyWrite pw |
    pw.getProperty().hasName(["Binder", "SerializationBinder"]) and
    pw.getQualifier().(Access).getTarget() = arg.(Access).getTarget()
  )
}

// ---------------------------------------------------------------------------
// Sink node: TypeNameHandling property write value
// ---------------------------------------------------------------------------
/**
 * A data-flow node representing the value assigned to a `TypeNameHandling`
 * property. Provides a predicate to check whether a mitigating binder is set.
 */
class TypeNameHandlingPropertySink extends DataFlow::Node {
  TypeNameHandlingPropertySink() {
    exists(TypeNameHandlingPropertyWrite pw |
      this.asExpr() = pw.getAssignedValue()
    )
  }

  /** Holds if a custom binder is set on the same settings object. */
  predicate hasBinderSet() {
    exists(JsonSerializerSettingsArg arg |
      this.asExpr() = arg and
      hasBinderSet(arg)
    )
  }
}

// ---------------------------------------------------------------------------
// Main flow: unsafe TypeNameHandling value → DeserializeObject settings arg
// ---------------------------------------------------------------------------
/**
 * Tracks unsafe `TypeNameHandling` values flowing into `JsonSerializerSettings`
 * arguments of `DeserializeObject` calls. Includes additional flow steps for
 * integer-to-enum casts and property writes on settings objects.
 */
module UnsafeTypeNameHandlingFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof BadTypeHandling }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof JsonSerializerSettingsArg }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Cast from integer literal to TypeNameHandling enum
    node1.asExpr() instanceof IntegerLiteral and
    node2.asExpr().(CastExpr).getExpr() = node1.asExpr()
    or
    node1.getType() instanceof TypeNameHandlingEnum and
    exists(TypeNameHandlingPropertyWrite pw, Assignment a |
      a.getLValue() = pw and
      (
        // Explicit property write: flow from the assigned value to the
        // JsonSerializerSettingsArg that accesses the same settings variable
        node1.asExpr() = a.getRValue() and
        node2.asExpr().(JsonSerializerSettingsArg).(VariableAccess).getTarget() =
          pw.getQualifier().(VariableAccess).getTarget()
        or
        // Object initializer: flow from the member initializer value to the
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

// ---------------------------------------------------------------------------
// Settings / serializer object creation modelling
// ---------------------------------------------------------------------------
/**
 * An `ObjectCreation` of type `Newtonsoft.Json.JsonSerializerSettings` or
 * `Newtonsoft.Json.JsonSerializer`.
 */
class JsonSerializerSettingsCreation extends ObjectCreation {
  JsonSerializerSettingsCreation() {
    this.getTarget()
        .hasFullyQualifiedName("Newtonsoft.Json.JsonSerializerSettings",
          "JsonSerializerSettings")
    or
    this.getTarget()
        .hasFullyQualifiedName("Newtonsoft.Json.JsonSerializer", "JsonSerializer")
  }

  /** Gets the type of the binder assigned to this settings object. */
  Class getAssignedBinderType() {
    exists(AssignExpr ae |
      ae.getLValue() = this.getBinderPropertyWrite() and
      ae.getRValue().getType() = result
    )
  }

  /** Gets a `BinderPropertyWrite` associated with this settings object. */
  BinderPropertyWrite getBinderPropertyWrite() { result = this.getPropertyWrite() }

  /** Gets a `TypeNameHandlingPropertyWrite` associated with this settings object. */
  TypeNameHandlingPropertyWrite getTypeNameHandlingPropertyWrite() {
    result = this.getPropertyWrite()
  }

  /**
   * Gets a `PropertyWrite` associated with this settings object, via an
   * initializer, direct local flow, or an assignment to the same property.
   */
  PropertyWrite getPropertyWrite() {
    result = this.getInitializer().getAChild*()
    or
    // Direct local flow via some intermediary
    DataFlow::localExprFlow(this, result.getQualifier())
    or
    // Local flow via property writes
    this.hasPropertyWrite(result)
  }

  /**
   * Holds if `pw` is a property write on the same target that this object
   * creation is assigned to, within the same callable.
   */
  bindingset[pw]
  pragma[inline_late]
  predicate hasPropertyWrite(PropertyWrite pw) {
    exists(Assignment a |
      a.getRValue() = this and
      a.getLValue().(PropertyAccess).getTarget() =
        pw.getQualifier().(PropertyAccess).getTarget() and
      a.getEnclosingCallable() = pw.getEnclosingCallable()
    )
  }
}