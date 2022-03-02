/**
 * Classes for modeling Json.NET.
 */

import csharp
private import semmle.code.csharp.dataflow.ExternalFlow

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

  /** Data flow for `Newtonsoft.Json.JsonConvert`. */
  private class JsonConvertClassFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "Newtonsoft.Json;JsonConvert;false;DeserializeAnonymousType<>;(System.String,T);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeAnonymousType<>;(System.String,T,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject;(System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject;(System.String,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject;(System.String,System.Type);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject;(System.String,System.Type,Newtonsoft.Json.JsonConverter[]);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject;(System.String,System.Type,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject<>;(System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject<>;(System.String,Newtonsoft.Json.JsonConverter[]);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeObject<>;(System.String,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXNode;(System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXNode;(System.String,System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXNode;(System.String,System.String,System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXNode;(System.String,System.String,System.Boolean,System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXmlNode;(System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXmlNode;(System.String,System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXmlNode;(System.String,System.String,System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;DeserializeXmlNode;(System.String,System.String,System.Boolean,System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;PopulateObject;(System.String,System.Object);;Argument[0];Argument[1];taint",
          "Newtonsoft.Json;JsonConvert;false;PopulateObject;(System.String,System.Object,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];Argument[1];taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,Newtonsoft.Json.Formatting);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,Newtonsoft.Json.Formatting,Newtonsoft.Json.JsonConverter[]);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,Newtonsoft.Json.Formatting,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,Newtonsoft.Json.JsonConverter[]);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,System.Type,Newtonsoft.Json.Formatting,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeObject;(System.Object,System.Type,Newtonsoft.Json.JsonSerializerSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeXNode;(System.Xml.Linq.XObject);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeXNode;(System.Xml.Linq.XObject,Newtonsoft.Json.Formatting);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeXNode;(System.Xml.Linq.XObject,Newtonsoft.Json.Formatting,System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeXmlNode;(System.Xml.XmlNode);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeXmlNode;(System.Xml.XmlNode,Newtonsoft.Json.Formatting);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;SerializeXmlNode;(System.Xml.XmlNode,Newtonsoft.Json.Formatting,System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Boolean);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Byte);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Char);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.DateTime);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.DateTime,Newtonsoft.Json.DateFormatHandling,Newtonsoft.Json.DateTimeZoneHandling);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.DateTimeOffset);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.DateTimeOffset,Newtonsoft.Json.DateFormatHandling);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Decimal);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Double);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Enum);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Guid);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Int16);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Int32);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Int64);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Object);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.SByte);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Single);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.String,System.Char);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.String,System.Char,Newtonsoft.Json.StringEscapeHandling);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.TimeSpan);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.UInt16);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.UInt32);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.UInt64);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonConvert;false;ToString;(System.Uri);;Argument[0];ReturnValue;taint",
        ]
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

  /** Data flow for `NewtonSoft.Json.JSonSerializer`. */
  private class JsonSerializerClassFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "Newtonsoft.Json;JsonSerializer;false;Deserialize;(Newtonsoft.Json.JsonReader);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonSerializer;false;Deserialize;(Newtonsoft.Json.JsonReader,System.Type);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonSerializer;false;Deserialize;(System.IO.TextReader,System.Type);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json;JsonSerializer;false;Serialize;(Newtonsoft.Json.JsonWriter,System.Object);;Argument[1];Argument[0];taint",
          "Newtonsoft.Json;JsonSerializer;false;Serialize;(Newtonsoft.Json.JsonWriter,System.Object,System.Type);;Argument[1];Argument[0];taint",
          "Newtonsoft.Json;JsonSerializer;false;Serialize;(System.IO.TextWriter,System.Object);;Argument[1];Argument[0];taint",
          "Newtonsoft.Json;JsonSerializer;false;Serialize;(System.IO.TextWriter,System.Object,System.Type);;Argument[1];Argument[0];taint"
        ]
    }
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

  /** Data flow for `Newtonsoft.Json.Linq.JToken`. */
  private class JTokenClassFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "Newtonsoft.Json.Linq;JToken;false;SelectToken;(System.String);;Argument[Qualifier];ReturnValue;taint",
          "Newtonsoft.Json.Linq;JToken;false;SelectToken;(System.String,Newtonsoft.Json.Linq.JsonSelectSettings);;Argument[Qualifier];ReturnValue;taint",
          "Newtonsoft.Json.Linq;JToken;false;SelectToken;(System.String,System.Boolean);;Argument[Qualifier];ReturnValue;taint",
          "Newtonsoft.Json.Linq;JToken;false;ToString;();;Argument[Qualifier];ReturnValue;taint",
          "Newtonsoft.Json.Linq;JToken;false;ToString;(Newtonsoft.Json.Formatting,Newtonsoft.Json.JsonConverter[]);;Argument[Qualifier];ReturnValue;taint",
        ]
    }
  }

  /** The `NewtonSoft.Json.Linq.JObject` class. */
  class JObjectClass extends LinqClass {
    JObjectClass() { this.hasName("JObject") }

    /** Gets the `Parse` method. */
    Method getParseMethod() { result = this.getAMethod("Parse") }

    /** Gets the `SelectToken` method. */
    Method getSelectTokenMethod() { result = this.getABaseType*().getAMethod("SelectToken") }
  }

  /** Data flow for `NewtonSoft.Json.Linq.JObject`. */
  private class JObjectClassFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "Newtonsoft.Json.Linq;JObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,Newtonsoft.Json.Linq.JToken>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
          "Newtonsoft.Json.Linq;JObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,Newtonsoft.Json.Linq.JToken>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
          "Newtonsoft.Json.Linq;JObject;false;JObject;(Newtonsoft.Json.Linq.JObject);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
          "Newtonsoft.Json.Linq;JObject;false;JObject;(Newtonsoft.Json.Linq.JObject);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
          "Newtonsoft.Json.Linq;JObject;false;JObject;(System.Object[]);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
          "Newtonsoft.Json.Linq;JObject;false;JObject;(System.Object[]);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
          "Newtonsoft.Json.Linq;JObject;false;Parse;(System.String);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json.Linq;JObject;false;Parse;(System.String,Newtonsoft.Json.Linq.JsonLoadSettings);;Argument[0];ReturnValue;taint",
          "Newtonsoft.Json.Linq;JObject;false;get_Item;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
          "Newtonsoft.Json.Linq;JObject;false;get_Item;(System.Object);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
          "Newtonsoft.Json.Linq;JObject;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
          "Newtonsoft.Json.Linq;JObject;false;set_Item;(System.Object,Newtonsoft.Json.Linq.JToken);;Argument[0];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
          "Newtonsoft.Json.Linq;JObject;false;set_Item;(System.Object,Newtonsoft.Json.Linq.JToken);;Argument[1];Argument[Qualifier].Element;value",
          "Newtonsoft.Json.Linq;JObject;false;set_Item;(System.Object,Newtonsoft.Json.Linq.JToken);;Argument[1];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
          "Newtonsoft.Json.Linq;JObject;false;set_Item;(System.String,Newtonsoft.Json.Linq.JToken);;Argument[1];Argument[Qualifier].Element;value",
        ]
    }
  }

  /** Data flow for `Newtonsoft.JSon.Linq.JArray` */
  private class NewtonsoftJsonLinqJArrayFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "Newtonsoft.Json.Linq;JArray;false;get_Item;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
          "Newtonsoft.Json.Linq;JArray;false;set_Item;(System.Object,Newtonsoft.Json.Linq.JToken);;Argument[1];Argument[Qualifier].Element;value",
        ]
    }
  }

  /** Data flow for `Newtonsoft.JSon.Linq.JConstructor` */
  private class NewtonsoftJsonLinqJConstructorFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        [
          "Newtonsoft.Json.Linq;JConstructor;false;get_Item;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
          "Newtonsoft.Json.Linq;JConstructor;false;set_Item;(System.Object,Newtonsoft.Json.Linq.JToken);;Argument[1];Argument[Qualifier].Element;value",
        ]
    }
  }

  /** Data flow for `Newtonsoft.JSon.Linq.JContainer` */
  private class NewtonsoftJsonLinqJContainerFlowModelCsv extends SummaryModelCsv {
    override predicate row(string row) {
      row =
        "Newtonsoft.Json.Linq;JContainer;true;Add;(System.Object);;Argument[0];Argument[Qualifier].Element;value"
    }
  }
}
