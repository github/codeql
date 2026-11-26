/**
 * Classes for modeling Json.NET.
 */

import csharp

/** Definitions relating to the `Json.NET` package. */
module JsonNET {
  /** The namespace `Newtonsoft.Json`. */
  class JsonNETNamespace extends Namespace {
    JsonNETNamespace() { this.getFullName() = "Newtonsoft.Json" }
  }

  /** A class in `Newtonsoft.Json`. */
  class JsonClass extends Class {
    JsonClass() { this.getParent() instanceof JsonNETNamespace }
  }

  /** Newtonsoft.Json.TypeNameHandling enum */
  class TypeNameHandlingEnum extends Enum {
    TypeNameHandlingEnum() {
      this.getParent() instanceof JsonNETNamespace and
      this.hasName("TypeNameHandling")
    }
  }

  /** Newtonsoft.Json.JsonSerializerSettings class */
  class JsonSerializerSettingsClass extends JsonClass {
    JsonSerializerSettingsClass() { this.hasName("JsonSerializerSettings") }
  }

  /** The class `Newtonsoft.Json.JsonConvert`. */
  class JsonConvertClass extends JsonClass {
    JsonConvertClass() { this.hasName("JsonConvert") }

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
        attribute
            .hasName([
                "JsonPropertyAttribute", "JsonDictionaryAttribute", "JsonRequiredAttribute",
                "JsonArrayAttribute", "JsonConverterAttribute", "JsonExtensionDataAttribute",
                "SerializableAttribute", // System.SerializableAttribute
                "DataMemberAttribute" // System.DataMemberAttribute
              ])
      )
      or
      // This field is a member of an explicitly serialized type
      this.getDeclaringType() instanceof SerializedType and
      not this.getDeclaringType().(SerializedType).isOptIn() and
      not this.(Attributable).getAnAttribute().getType() instanceof NotSerializedAttributeClass
    }
  }

  /** The class `NewtonSoft.Json.JsonSerializer`. */
  class JsonSerializerClass extends JsonClass {
    JsonSerializerClass() { this.hasName("JsonSerializer") }

    /** Gets the method for `JsonSerializer.Serialize`. */
    Method getSerializeMethod() { result = this.getAMethod("Serialize") }

    /** Gets the method for `JsonSerializer.Deserialize`. */
    Method getDeserializeMethod() { result = this.getAMethod("Deserialize") }
  }

  /** Any attribute class that marks a member to not be serialized. */
  private class NotSerializedAttributeClass extends JsonClass {
    NotSerializedAttributeClass() {
      this.hasName(["JsonIgnoreAttribute", "NonSerializedAttribute"])
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
  class JObjectClass extends LinqClass {
    JObjectClass() { this.hasName("JObject") }

    /** Gets the `Parse` method. */
    Method getParseMethod() { result = this.getAMethod("Parse") }

    /** Gets the `SelectToken` method. */
    Method getSelectTokenMethod() { result = this.getABaseType*().getAMethod("SelectToken") }
  }
}
