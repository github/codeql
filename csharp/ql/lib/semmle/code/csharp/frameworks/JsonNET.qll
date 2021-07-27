/**
 * Classes for modelling Json.NET.
 */

import csharp
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow

/** Definitions relating to the `Json.NET` package. */
module JsonNET {
  /** The namespace `Newtonsoft.Json`. */
  class JsonNETNamespace extends Namespace {
    JsonNETNamespace() { this.hasQualifiedName("Newtonsoft.Json") }
  }

  /** A class in `Newtonsoft.Json`. */
  class JsonClass extends Class {
    JsonClass() { this.getParent() instanceof JsonNETNamespace }
  }

  /** The class `Newtonsoft.Json.JsonConvert`. */
  class JsonConvertClass extends JsonClass, LibraryTypeDataFlow {
    JsonConvertClass() { this.hasName("JsonConvert") }

    /** Gets a `ToString` method. */
    private Method getAToStringMethod() {
      result = this.getAMethod("ToString") and
      result.isStatic()
    }

    /** Gets a `Deserialize` method. */
    Method getADeserializeMethod() {
      result = this.getAMethod() and
      result.getName().matches("Deserialize%")
    }

    /** Gets a `Serialize` method. */
    Method getASerializeMethod() {
      result = this.getAMethod() and
      result.getName().matches("Serialize%")
    }

    private Method getAPopulateMethod() {
      result = this.getAMethod() and
      result.getName().matches("Populate%")
    }

    override predicate callableFlow(
      CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
      boolean preservesValue
    ) {
      // ToString methods
      c = getAToStringMethod() and
      preservesValue = false and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink instanceof CallableFlowSinkReturn
      or
      // Deserialize methods
      c = getADeserializeMethod() and
      preservesValue = false and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink instanceof CallableFlowSinkReturn
      or
      // Serialize methods
      c = getASerializeMethod() and
      preservesValue = false and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink instanceof CallableFlowSinkReturn
      or
      // Populate methods
      c = getAPopulateMethod() and
      preservesValue = false and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink = any(CallableFlowSinkArg arg | arg.getArgumentIndex() = 1)
    }
  }

  /** A type that is serialized. */
  private class SerializedType extends ValueOrRefType {
    SerializedType() {
      // Supplied as a parameter to a serialize or deserialize method
      exists(TypeParameter tp, JsonConvertClass jc, UnboundGenericMethod serializeMethod |
        this = tp.getAnUltimatelySuppliedType() and
        tp = serializeMethod.getATypeParameter()
      |
        serializeMethod = jc.getASerializeMethod()
        or
        serializeMethod = jc.getADeserializeMethod()
      )
      or
      exists(Class attribute | attribute = this.getAnAttribute().getType() |
        attribute instanceof JsonObjectAttributeClass
        or
        attribute.hasName("JsonConverterAttribute")
      )
      or
      this.getAConstructor().getAnAttribute().getType().hasName("JsonConstructorAttribute")
    }

    predicate isOptIn() { this.getAnAttribute().(JsonObjectAttribute).isOptIn() }
  }

  /**
   * A field/property that can be serialized, either explicitly
   * or as a member of a serialized type.
   */
  private class SerializedMember extends TaintTracking::TaintedMember {
    SerializedMember() {
      // This member has a Json attribute
      exists(Class attribute | attribute = this.getAnAttribute().getType() |
        attribute.hasName("JsonPropertyAttribute")
        or
        attribute.hasName("JsonDictionaryAttribute")
        or
        attribute.hasName("JsonRequiredAttribute")
        or
        attribute.hasName("JsonArrayAttribute")
        or
        attribute.hasName("JsonConverterAttribute")
        or
        attribute.hasName("JsonExtensionDataAttribute")
        or
        attribute.hasName("SerializableAttribute") // System.SerializableAttribute
        or
        attribute.hasName("DataMemberAttribute") // System.DataMemberAttribute
      )
      or
      // This field is a member of an explicitly serialized type
      this.getDeclaringType() instanceof SerializedType and
      not this.getDeclaringType().(SerializedType).isOptIn() and
      not this.(Attributable).getAnAttribute().getType() instanceof NotSerializedAttributeClass
    }
  }

  /** The class `NewtonSoft.Json.JsonSerializer`. */
  class JsonSerializerClass extends JsonClass, LibraryTypeDataFlow {
    JsonSerializerClass() { this.hasName("JsonSerializer") }

    /** Gets the method for `JsonSerializer.Serialize`. */
    Method getSerializeMethod() { result = this.getAMethod("Serialize") }

    /** Gets the method for `JsonSerializer.Deserialize`. */
    Method getDeserializeMethod() { result = this.getAMethod("Deserialize") }

    override predicate callableFlow(
      CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
      boolean preservesValue
    ) {
      // Serialize
      c = this.getSerializeMethod() and
      preservesValue = false and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink = any(CallableFlowSinkArg arg | arg.getArgumentIndex() = 1)
      or
      // Deserialize
      c = this.getDeserializeMethod() and
      preservesValue = false and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink = any(CallableFlowSinkArg arg | arg.getArgumentIndex() = 1)
    }
  }

  /** Any attribute class that marks a member to not be serialized. */
  private class NotSerializedAttributeClass extends JsonClass {
    NotSerializedAttributeClass() {
      this.hasName("JsonIgnoreAttribute") or this.hasName("NonSerializedAttribute")
    }
  }

  /** The class `Newtonsoft.Json.ObjectAttribute`. */
  class JsonObjectAttributeClass extends JsonClass {
    JsonObjectAttributeClass() { this.hasName("JsonObjectAttribute") }
  }

  /** An attribute of type `Newtonsoft.Json.ObjectAttribute`. */
  class JsonObjectAttribute extends Attribute {
    JsonObjectAttribute() { this.getType() instanceof JsonObjectAttributeClass }

    /** Holds if the `OptIn` argument has been supplied to this attribute. */
    predicate isOptIn() { this.getArgument(_).(FieldAccess).getTarget().hasName("OptIn") }
  }

  /** The namespace `Newtonsoft.Json.Linq`. */
  class LinqNamespace extends Namespace {
    LinqNamespace() {
      this.getParentNamespace() instanceof JsonNETNamespace and this.hasName("Linq")
    }
  }

  /** A class in `Newtonsoft.Json.Linq`. */
  class LinqClass extends Class {
    LinqClass() { this.getDeclaringNamespace() instanceof LinqNamespace }
  }

  /** The `NewtonSoft.Json.Linq.JObject` class. */
  class JObjectClass extends LinqClass, LibraryTypeDataFlow {
    JObjectClass() { this.hasName("JObject") }

    override predicate callableFlow(
      CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
      boolean preservesValue
    ) {
      // ToString method
      c = this.getAMethod("ToString") and
      source instanceof CallableFlowSourceQualifier and
      sink instanceof CallableFlowSinkReturn and
      preservesValue = false
      or
      // Parse method
      c = this.getParseMethod() and
      source = any(CallableFlowSourceArg arg | arg.getArgumentIndex() = 0) and
      sink instanceof CallableFlowSinkReturn and
      preservesValue = false
      or
      // operator string
      c =
        any(Operator op |
          op.getDeclaringType() = this.getABaseType*() and op.getReturnType() instanceof StringType
        ) and
      source.(CallableFlowSourceArg).getArgumentIndex() = 0 and
      sink instanceof CallableFlowSinkReturn and
      preservesValue = false
      or
      // SelectToken method
      c = this.getSelectTokenMethod() and
      source instanceof CallableFlowSourceQualifier and
      sink instanceof CallableFlowSinkReturn and
      preservesValue = false
    }

    /** Gets the `Parse` method. */
    Method getParseMethod() { result = this.getAMethod("Parse") }

    /** Gets the `SelectToken` method. */
    Method getSelectTokenMethod() { result = this.getABaseType*().getAMethod("SelectToken") }
  }
}
