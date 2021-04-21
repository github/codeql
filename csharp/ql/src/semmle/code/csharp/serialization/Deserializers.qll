/**
 * Provides a library of known unsafe deserializers.
 * See https://www.blackhat.com/docs/us-17/thursday/us-17-Munoz-Friday-The-13th-Json-Attacks.pdf.
 */

import csharp

/** An unsafe deserializer. */
abstract class UnsafeDeserializer extends Callable { }

/** Unsafe deserialization calls. */
class UnsafeDeserializerCallable extends Callable {
  UnsafeDeserializerCallable() {
    this instanceof BinaryFormatterDeserializeMethod
    or
    this instanceof BinaryFormatterUnsafeDeserializeMethod
    or
    this instanceof BinaryFormatterUnsafeDeserializeMethodResponseMethod
    or
    this instanceof SoapFormatterDeserializeMethod
    or
    this instanceof ObjectStateFormatterDeserializeMethod
    or
    this instanceof NetDataContractSerializerDeserializeMethod
    or
    this instanceof NetDataContractSerializerReadObjectMethod
    or
    this instanceof DataContractJsonSerializerReadObjectMethod
    or
    this instanceof JavaScriptSerializerClassDeserializeMethod
    or
    this instanceof JavaScriptSerializerClassDeserializeObjectMethod
    or
    this instanceof XmlObjectSerializerReadObjectMethod
    or
    this instanceof XmlSerializerDeserializeMethod
    or
    this instanceof DataContractSerializerReadObjectMethod
    or
    this instanceof XmlMessageFormatterReadMethod
    or
    this instanceof LosFormatterDeserializeMethod
    or
    this instanceof FastJsonClassToObjectMethod
    or
    this instanceof ActivityLoadMethod
    or
    this instanceof ResourceReaderConstructor
    or
    this instanceof BinaryMessageFormatterReadMethod
    or
    this instanceof XamlReaderParseMethod
    or
    this instanceof XamlReaderLoadMethod
    or
    this instanceof XamlReaderLoadAsyncMethod
    or
    this instanceof ProxyObjectDecodeValueMethod
    or
    this instanceof ProxyObjectDecodeSerializedObjectMethod
    or
    this instanceof JaysonConverterToObjectMethod
    or
    this instanceof ServiceStackTextJsonSerializerDeserializeFromStringMethod
    or
    this instanceof ServiceStackTextJsonSerializerDeserializeFromReaderMethod
    or
    this instanceof ServiceStackTextJsonSerializerDeserializeFromStreamMethod
    or
    this instanceof ServiceStackTextTypeSerializerDeserializeFromStringMethod
    or
    this instanceof ServiceStackTextTypeSerializerDeserializeFromReaderMethod
    or
    this instanceof ServiceStackTextTypeSerializerDeserializeFromStreamMethod
    or
    this instanceof ServiceStackTextCsvSerializerDeserializeFromStringMethod
    or
    this instanceof ServiceStackTextCsvSerializerDeserializeFromReaderMethod
    or
    this instanceof ServiceStackTextCsvSerializerDeserializeFromStreamMethod
    or
    this instanceof ServiceStackTextXmlSerializerDeserializeFromStringMethod
    or
    this instanceof ServiceStackTextXmlSerializerDeserializeFromReaderMethod
    or
    this instanceof ServiceStackTextXmlSerializerDeserializeFromStreamMethod
  }
}

/** A deserializer exploitable only if user controls the expected object type. */
class StrongTypeDeserializer extends Class {
  StrongTypeDeserializer() {
    this instanceof XmlSerializerClass
    or
    this instanceof DataContractJsonSerializerClass
    or
    this instanceof DataContractSerializerClass
    or
    this instanceof XmlMessageFormatterClass
  }
}

/** A deserializer that doesn't make strong expected type check. */
class WeakTypeDeserializer extends Class {
  WeakTypeDeserializer() {
    this instanceof BinaryFormatterClass
    or
    this instanceof SoapFormatterClass
    or
    this instanceof ObjectStateFormatterClass
    or
    this instanceof NetDataContractSerializerClass
    or
    this instanceof JavaScriptSerializerClass
    or
    this instanceof LosFormatterClass
    or
    this instanceof BinaryMessageFormatterClass
    or
    this instanceof FastJsonClass
    or
    this instanceof ActivityClass
    or
    this instanceof XamlReaderClass
    or
    this instanceof ProxyObjectClass
    or
    this instanceof ResourceReaderClass
    or
    this instanceof JaysonConverterClass
    or
    this instanceof ServiceStackTextJsonSerializerClass
    or
    this instanceof ServiceStackTextTypeSerializerClass
    or
    this instanceof ServiceStackTextCsvSerializerClass
    or
    this instanceof ServiceStackTextXmlSerializerClass
  }
}

/**
 * An unsafe deserializer method that calls any unsafe deserializer on any of
 * the parameters.
 */
class WrapperDeserializer extends UnsafeDeserializerCallable, UnsafeDeserializer {
  WrapperDeserializer() {
    exists(Call call |
      call.getEnclosingCallable() = this and
      call.getAnArgument() instanceof ParameterAccess and
      call.getTarget() instanceof UnsafeDeserializerCallable
    )
  }
}

/** BinaryFormatter */
class BinaryFormatterClass extends Class {
  BinaryFormatterClass() {
    this.hasQualifiedName("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter")
  }
}

class BinaryFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  BinaryFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof BinaryFormatterClass and
    this.hasName("Deserialize")
  }
}

class BinaryFormatterUnsafeDeserializeMethod extends Method, UnsafeDeserializer {
  BinaryFormatterUnsafeDeserializeMethod() {
    this.getDeclaringType() instanceof BinaryFormatterClass and
    this.hasName("UnsafeDeserialize")
  }
}

class BinaryFormatterUnsafeDeserializeMethodResponseMethod extends Method, UnsafeDeserializer {
  BinaryFormatterUnsafeDeserializeMethodResponseMethod() {
    this.getDeclaringType() instanceof BinaryFormatterClass and
    this.hasName("UnsafeDeserializeMethodResponse")
  }
}

/** SoapFormatter */
class SoapFormatterClass extends Class {
  SoapFormatterClass() {
    this.hasQualifiedName("System.Runtime.Serialization.Formatters.Soap.SoapFormatter")
  }
}

class SoapFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  SoapFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof SoapFormatterClass and
    this.hasName("Deserialize")
  }
}

/** ObjectStateFormatter */
class ObjectStateFormatterClass extends Class {
  ObjectStateFormatterClass() { this.hasQualifiedName("System.Web.UI.ObjectStateFormatter") }
}

class ObjectStateFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  ObjectStateFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof ObjectStateFormatterClass and
    this.hasName("Deserialize")
  }
}

/** NetDataContractSerializer */
class NetDataContractSerializerClass extends Class {
  NetDataContractSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.NetDataContractSerializer")
  }
}

class NetDataContractSerializerDeserializeMethod extends Method, UnsafeDeserializer {
  NetDataContractSerializerDeserializeMethod() {
    this.getDeclaringType() instanceof NetDataContractSerializerClass and
    this.hasName("Deserialize")
  }
}

class NetDataContractSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  NetDataContractSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof NetDataContractSerializerClass and
    this.hasName("ReadObject")
  }
}

/** DataContractJsonSerializer */
class DataContractJsonSerializerClass extends Class {
  DataContractJsonSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.Json.DataContractJsonSerializer")
  }
}

class DataContractJsonSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  DataContractJsonSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof DataContractJsonSerializerClass and
    this.hasName("ReadObject")
  }
}

/** JavaScriptSerializer */
class JavaScriptSerializerClass extends Class {
  JavaScriptSerializerClass() {
    this.hasQualifiedName("System.Web.Script.Serialization.JavaScriptSerializer")
  }
}

class JavaScriptSerializerClassDeserializeMethod extends Method, UnsafeDeserializer {
  JavaScriptSerializerClassDeserializeMethod() {
    this.getDeclaringType() instanceof JavaScriptSerializerClass and
    this.hasName("Deserialize")
  }
}

class JavaScriptSerializerClassDeserializeObjectMethod extends Method, UnsafeDeserializer {
  JavaScriptSerializerClassDeserializeObjectMethod() {
    this.getDeclaringType() instanceof JavaScriptSerializerClass and
    this.hasName("DeserializeObject")
  }
}

/** XmlObjectSerializer */
class XmlObjectSerializerClass extends Class {
  XmlObjectSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.XmlObjectSerializer")
  }
}

class XmlObjectSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  XmlObjectSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof XmlObjectSerializerClass and
    this.hasName("ReadObject")
  }
}

/** XmlSerializer */
class XmlSerializerClass extends Class {
  XmlSerializerClass() { this.hasQualifiedName("System.Xml.Serialization.XmlSerializer") }
}

class XmlSerializerDeserializeMethod extends Method, UnsafeDeserializer {
  XmlSerializerDeserializeMethod() {
    this.getDeclaringType() instanceof XmlSerializerClass and
    this.hasName("Deserialize")
  }
}

/** DataContractSerializer */
class DataContractSerializerClass extends Class {
  DataContractSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.DataContractSerializer")
  }
}

class DataContractSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  DataContractSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof DataContractSerializerClass and
    this.hasName("ReadObject")
  }
}

/** XmlMessageFormatter */
class XmlMessageFormatterClass extends Class {
  XmlMessageFormatterClass() { this.hasQualifiedName("System.Messaging.XmlMessageFormatter") }
}

class XmlMessageFormatterReadMethod extends Method, UnsafeDeserializer {
  XmlMessageFormatterReadMethod() {
    this.getDeclaringType() instanceof XmlMessageFormatterClass and
    this.hasName("Read")
  }
}

/** LosFormatter */
class LosFormatterClass extends Class {
  LosFormatterClass() { this.hasQualifiedName("System.Web.UI.LosFormatter") }
}

class LosFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  LosFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof LosFormatterClass and
    this.hasName("Deserialize")
  }
}

/** fastJSON */
class FastJsonClass extends Class {
  FastJsonClass() { this.hasQualifiedName("fastJSON.JSON") }
}

class FastJsonClassToObjectMethod extends Method, UnsafeDeserializer {
  FastJsonClassToObjectMethod() {
    this.getDeclaringType() instanceof FastJsonClass and
    this.hasName("ToObject") and
    this.isStatic()
  }
}

/** Activity */
class ActivityClass extends Class {
  ActivityClass() { this.hasQualifiedName("System.Workflow.ComponentModel.Activity") }
}

class ActivityLoadMethod extends Method, UnsafeDeserializer {
  ActivityLoadMethod() {
    this.getDeclaringType() instanceof ActivityClass and
    this.hasName("Load")
  }
}

/** ResourceReader */
class ResourceReaderClass extends Class {
  ResourceReaderClass() { this.hasQualifiedName("System.Resources.ResourceReader") }
}

class ResourceReaderConstructor extends Constructor, UnsafeDeserializer {
  ResourceReaderConstructor() {
    this.getDeclaringType() instanceof ResourceReaderClass and
    this.hasName("ResourceReader")
  }
}

/** BinaryMessageFormatter */
class BinaryMessageFormatterClass extends Class {
  BinaryMessageFormatterClass() { this.hasQualifiedName("System.Messaging.BinaryMessageFormatter") }
}

class BinaryMessageFormatterReadMethod extends Method, UnsafeDeserializer {
  BinaryMessageFormatterReadMethod() {
    this.getDeclaringType() instanceof BinaryMessageFormatterClass and
    this.hasName("Read")
  }
}

/** XamlReader */
class XamlReaderClass extends Class {
  XamlReaderClass() { this.hasQualifiedName("System.Windows.Markup.XamlReader") }
}

class XamlReaderParseMethod extends Method, UnsafeDeserializer {
  XamlReaderParseMethod() {
    this.getDeclaringType() instanceof XamlReaderClass and
    this.hasName("Parse") and
    this.isStatic()
  }
}

class XamlReaderLoadMethod extends Method, UnsafeDeserializer {
  XamlReaderLoadMethod() {
    this.getDeclaringType() instanceof XamlReaderClass and
    this.hasName("Load") and
    this.isStatic()
  }
}

class XamlReaderLoadAsyncMethod extends Method, UnsafeDeserializer {
  XamlReaderLoadAsyncMethod() {
    this.getDeclaringType() instanceof XamlReaderClass and
    this.hasName("LoadAsync")
  }
}

/** ProxyObject */
class ProxyObjectClass extends Class {
  ProxyObjectClass() { this.hasQualifiedName("Microsoft.Web.Design.Remote.ProxyObject") }
}

class ProxyObjectDecodeValueMethod extends Method, UnsafeDeserializer {
  ProxyObjectDecodeValueMethod() {
    this.getDeclaringType() instanceof ProxyObjectClass and
    this.hasName("DecodeValue")
  }
}

class ProxyObjectDecodeSerializedObjectMethod extends Method, UnsafeDeserializer {
  ProxyObjectDecodeSerializedObjectMethod() {
    this.getDeclaringType() instanceof ProxyObjectClass and
    this.hasName("DecodeSerializedObject")
  }
}

/** SweetJayson */
class JaysonConverterClass extends Class {
  JaysonConverterClass() { this.hasQualifiedName("Sweet.Jayson.JaysonConverter") }
}

class JaysonConverterToObjectMethod extends Method, UnsafeDeserializer {
  JaysonConverterToObjectMethod() {
    this.getDeclaringType() instanceof JaysonConverterClass and
    this.hasName("ToObject") and
    this.isStatic()
  }
}

/** ServiceStack.Text.JsonSerializer */
class ServiceStackTextJsonSerializerClass extends Class {
  ServiceStackTextJsonSerializerClass() {
    this.hasQualifiedName("ServiceStack.Text.JsonSerializer")
  }
}

class ServiceStackTextJsonSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextJsonSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextJsonSerializerClass and
    this.hasName("DeserializeFromString") and
    this.isStatic()
  }
}

class ServiceStackTextJsonSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextJsonSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextJsonSerializerClass and
    this.hasName("DeserializeFromReader") and
    this.isStatic()
  }
}

class ServiceStackTextJsonSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextJsonSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextJsonSerializerClass and
    this.hasName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** ServiceStack.Text.TypeSerializer */
class ServiceStackTextTypeSerializerClass extends Class {
  ServiceStackTextTypeSerializerClass() {
    this.hasQualifiedName("ServiceStack.Text.TypeSerializer")
  }
}

class ServiceStackTextTypeSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextTypeSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextTypeSerializerClass and
    this.hasName("DeserializeFromString") and
    this.isStatic()
  }
}

class ServiceStackTextTypeSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextTypeSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextTypeSerializerClass and
    this.hasName("DeserializeFromReader") and
    this.isStatic()
  }
}

class ServiceStackTextTypeSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextTypeSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextTypeSerializerClass and
    this.hasName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** ServiceStack.Text.CsvSerializer */
class ServiceStackTextCsvSerializerClass extends Class {
  ServiceStackTextCsvSerializerClass() { this.hasQualifiedName("ServiceStack.Text.CsvSerializer") }
}

class ServiceStackTextCsvSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextCsvSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextCsvSerializerClass and
    this.hasName("DeserializeFromString") and
    this.isStatic()
  }
}

class ServiceStackTextCsvSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextCsvSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextCsvSerializerClass and
    this.hasName("DeserializeFromReader") and
    this.isStatic()
  }
}

class ServiceStackTextCsvSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextCsvSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextCsvSerializerClass and
    this.hasName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** ServiceStack.Text.XmlSerializer */
class ServiceStackTextXmlSerializerClass extends Class {
  ServiceStackTextXmlSerializerClass() { this.hasQualifiedName("ServiceStack.Text.XmlSerializer") }
}

class ServiceStackTextXmlSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextXmlSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextXmlSerializerClass and
    this.hasName("DeserializeFromString") and
    this.isStatic()
  }
}

class ServiceStackTextXmlSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextXmlSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextXmlSerializerClass and
    this.hasName("DeserializeFromReader") and
    this.isStatic()
  }
}

class ServiceStackTextXmlSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextXmlSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextXmlSerializerClass and
    this.hasName("DeserializeFromStream") and
    this.isStatic()
  }
}
