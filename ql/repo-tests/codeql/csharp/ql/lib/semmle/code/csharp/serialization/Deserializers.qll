/**
 * Provides a library of known unsafe deserializers.
 * See https://www.blackhat.com/docs/us-17/thursday/us-17-Munoz-Friday-The-13th-Json-Attacks.pdf.
 */

import csharp
import semmle.code.csharp.frameworks.JsonNET::JsonNET

/** An unsafe deserializer. */
abstract class UnsafeDeserializer extends Callable { }

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
    or
    this instanceof FsPicklerSerializerClass
    or
    this instanceof CsPicklerSerializerClass
    or
    this instanceof CsPicklerTextSerializerClass
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
    or
    this instanceof SharpSerializerClass
    or
    this instanceof YamlDotNetDeserializerClass
    or
    this instanceof JsonConvertClass
  }
}

/**
 * An unsafe deserializer method that calls any unsafe deserializer on any of
 * the parameters.
 */
private class WrapperDeserializer extends UnsafeDeserializer {
  WrapperDeserializer() {
    exists(Call call |
      call.getEnclosingCallable() = this and
      call.getAnArgument() instanceof ParameterAccess and
      call.getTarget() instanceof UnsafeDeserializer
    )
  }
}

/** BinaryFormatter */
private class BinaryFormatterClass extends Class {
  BinaryFormatterClass() {
    this.hasQualifiedName("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter")
  }
}

/** `System.Runtime.Serialization.Formatters.Binary.BinaryFormatter.Deserialize` method */
class BinaryFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  BinaryFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof BinaryFormatterClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** `System.Runtime.Serialization.Formatters.Binary.BinaryFormatter.UnsafeDeserialize` method */
class BinaryFormatterUnsafeDeserializeMethod extends Method, UnsafeDeserializer {
  BinaryFormatterUnsafeDeserializeMethod() {
    this.getDeclaringType() instanceof BinaryFormatterClass and
    this.hasUndecoratedName("UnsafeDeserialize")
  }
}

/** `System.Runtime.Serialization.Formatters.Binary.BinaryFormatter.UnsafeDeserializeMethodResponse` method */
class BinaryFormatterUnsafeDeserializeMethodResponseMethod extends Method, UnsafeDeserializer {
  BinaryFormatterUnsafeDeserializeMethodResponseMethod() {
    this.getDeclaringType() instanceof BinaryFormatterClass and
    this.hasUndecoratedName("UnsafeDeserializeMethodResponse")
  }
}

/** SoapFormatter */
private class SoapFormatterClass extends Class {
  SoapFormatterClass() {
    this.hasQualifiedName("System.Runtime.Serialization.Formatters.Soap.SoapFormatter")
  }
}

/** `System.Runtime.Serialization.Formatters.Soap.SoapFormatter.Deserialize` method */
class SoapFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  SoapFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof SoapFormatterClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** ObjectStateFormatter */
private class ObjectStateFormatterClass extends Class {
  ObjectStateFormatterClass() { this.hasQualifiedName("System.Web.UI.ObjectStateFormatter") }
}

/** `System.Web.UI.ObjectStateFormatter.Deserialize` method */
class ObjectStateFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  ObjectStateFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof ObjectStateFormatterClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** NetDataContractSerializer */
class NetDataContractSerializerClass extends Class {
  NetDataContractSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.NetDataContractSerializer")
  }
}

/** `System.Runtime.Serialization.NetDataContractSerializer.Deserialize` method */
class NetDataContractSerializerDeserializeMethod extends Method, UnsafeDeserializer {
  NetDataContractSerializerDeserializeMethod() {
    this.getDeclaringType() instanceof NetDataContractSerializerClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** `System.Runtime.Serialization.NetDataContractSerializer.ReadObject` method */
class NetDataContractSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  NetDataContractSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof NetDataContractSerializerClass and
    this.hasUndecoratedName("ReadObject")
  }
}

/** DataContractJsonSerializer */
class DataContractJsonSerializerClass extends Class {
  DataContractJsonSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.Json.DataContractJsonSerializer")
  }
}

/** `System.Runtime.Serialization.Json.DataContractJsonSerializer.ReadObject` method */
class DataContractJsonSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  DataContractJsonSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof DataContractJsonSerializerClass and
    this.hasUndecoratedName("ReadObject")
  }
}

/** JavaScriptSerializer */
class JavaScriptSerializerClass extends Class {
  JavaScriptSerializerClass() {
    this.hasQualifiedName("System.Web.Script.Serialization.JavaScriptSerializer")
  }
}

/** `System.Web.Script.Serialization.JavaScriptSerializer.Deserialize` method */
class JavaScriptSerializerClassDeserializeMethod extends Method, UnsafeDeserializer {
  JavaScriptSerializerClassDeserializeMethod() {
    this.getDeclaringType() instanceof JavaScriptSerializerClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** `System.Web.Script.Serialization.JavaScriptSerializer.DeserializeObject` method */
class JavaScriptSerializerClassDeserializeObjectMethod extends Method, UnsafeDeserializer {
  JavaScriptSerializerClassDeserializeObjectMethod() {
    this.getDeclaringType() instanceof JavaScriptSerializerClass and
    this.hasUndecoratedName("DeserializeObject")
  }
}

/** XmlObjectSerializer */
class XmlObjectSerializerClass extends Class {
  XmlObjectSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.XmlObjectSerializer")
  }
}

/** `System.Runtime.Serialization.XmlObjectSerializer.ReadObject` method */
class XmlObjectSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  XmlObjectSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof XmlObjectSerializerClass and
    this.hasUndecoratedName("ReadObject")
  }
}

/** XmlSerializer */
class XmlSerializerClass extends Class {
  XmlSerializerClass() { this.hasQualifiedName("System.Xml.Serialization.XmlSerializer") }
}

/** `System.Xml.Serialization.XmlSerializer.Deserialize` method */
class XmlSerializerDeserializeMethod extends Method, UnsafeDeserializer {
  XmlSerializerDeserializeMethod() {
    this.getDeclaringType() instanceof XmlSerializerClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** DataContractSerializer */
class DataContractSerializerClass extends Class {
  DataContractSerializerClass() {
    this.hasQualifiedName("System.Runtime.Serialization.DataContractSerializer")
  }
}

/** `System.Runtime.Serialization.DataContractSerializer.ReadObject` method */
class DataContractSerializerReadObjectMethod extends Method, UnsafeDeserializer {
  DataContractSerializerReadObjectMethod() {
    this.getDeclaringType() instanceof DataContractSerializerClass and
    this.hasUndecoratedName("ReadObject")
  }
}

/** XmlMessageFormatter */
class XmlMessageFormatterClass extends Class {
  XmlMessageFormatterClass() { this.hasQualifiedName("System.Messaging.XmlMessageFormatter") }
}

/** `System.Messaging.XmlMessageFormatter.Read` method */
class XmlMessageFormatterReadMethod extends Method, UnsafeDeserializer {
  XmlMessageFormatterReadMethod() {
    this.getDeclaringType() instanceof XmlMessageFormatterClass and
    this.hasUndecoratedName("Read")
  }
}

/** LosFormatter */
private class LosFormatterClass extends Class {
  LosFormatterClass() { this.hasQualifiedName("System.Web.UI.LosFormatter") }
}

/** `System.Web.UI.LosFormatter.Deserialize` method */
class LosFormatterDeserializeMethod extends Method, UnsafeDeserializer {
  LosFormatterDeserializeMethod() {
    this.getDeclaringType() instanceof LosFormatterClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** fastJSON */
private class FastJsonClass extends Class {
  FastJsonClass() { this.hasQualifiedName("fastJSON.JSON") }
}

/** `fastJSON.JSON.ToObject` method */
class FastJsonClassToObjectMethod extends Method, UnsafeDeserializer {
  FastJsonClassToObjectMethod() {
    this.getDeclaringType() instanceof FastJsonClass and
    this.hasUndecoratedName("ToObject") and
    this.isStatic()
  }
}

/** Activity */
private class ActivityClass extends Class {
  ActivityClass() { this.hasQualifiedName("System.Workflow.ComponentModel.Activity") }
}

/** `System.Workflow.ComponentModel.Activity.Load` method */
class ActivityLoadMethod extends Method, UnsafeDeserializer {
  ActivityLoadMethod() {
    this.getDeclaringType() instanceof ActivityClass and
    this.hasUndecoratedName("Load")
  }
}

/** ResourceReader */
private class ResourceReaderClass extends Class {
  ResourceReaderClass() { this.hasQualifiedName("System.Resources.ResourceReader") }
}

/** `System.Resources.ResourceReader` constructor */
class ResourceReaderConstructor extends Constructor, UnsafeDeserializer {
  ResourceReaderConstructor() {
    this.getDeclaringType() instanceof ResourceReaderClass and
    this.hasName("ResourceReader")
  }
}

/** BinaryMessageFormatter */
private class BinaryMessageFormatterClass extends Class {
  BinaryMessageFormatterClass() { this.hasQualifiedName("System.Messaging.BinaryMessageFormatter") }
}

/** `System.Messaging.BinaryMessageFormatter.Read` method */
class BinaryMessageFormatterReadMethod extends Method, UnsafeDeserializer {
  BinaryMessageFormatterReadMethod() {
    this.getDeclaringType() instanceof BinaryMessageFormatterClass and
    this.hasUndecoratedName("Read")
  }
}

/** XamlReader */
private class XamlReaderClass extends Class {
  XamlReaderClass() { this.hasQualifiedName("System.Windows.Markup.XamlReader") }
}

/** `System.Windows.Markup.XamlReader.Parse` method */
class XamlReaderParseMethod extends Method, UnsafeDeserializer {
  XamlReaderParseMethod() {
    this.getDeclaringType() instanceof XamlReaderClass and
    this.hasUndecoratedName("Parse") and
    this.isStatic()
  }
}

/** `System.Windows.Markup.XamlReader.Load` method */
class XamlReaderLoadMethod extends Method, UnsafeDeserializer {
  XamlReaderLoadMethod() {
    this.getDeclaringType() instanceof XamlReaderClass and
    this.hasUndecoratedName("Load") and
    this.isStatic()
  }
}

/** `System.Windows.Markup.XamlReader.LoadAsync` method */
class XamlReaderLoadAsyncMethod extends Method, UnsafeDeserializer {
  XamlReaderLoadAsyncMethod() {
    this.getDeclaringType() instanceof XamlReaderClass and
    this.hasUndecoratedName("LoadAsync")
  }
}

/** ProxyObject */
private class ProxyObjectClass extends Class {
  ProxyObjectClass() { this.hasQualifiedName("Microsoft.Web.Design.Remote.ProxyObject") }
}

/** `Microsoft.Web.Design.Remote.ProxyObject.DecodeValue` method */
class ProxyObjectDecodeValueMethod extends Method, UnsafeDeserializer {
  ProxyObjectDecodeValueMethod() {
    this.getDeclaringType() instanceof ProxyObjectClass and
    this.hasUndecoratedName("DecodeValue")
  }
}

/** `Microsoft.Web.Design.Remote.ProxyObject.DecodeSerializedObject` method */
class ProxyObjectDecodeSerializedObjectMethod extends Method, UnsafeDeserializer {
  ProxyObjectDecodeSerializedObjectMethod() {
    this.getDeclaringType() instanceof ProxyObjectClass and
    this.hasUndecoratedName("DecodeSerializedObject")
  }
}

/** SweetJayson */
private class JaysonConverterClass extends Class {
  JaysonConverterClass() { this.hasQualifiedName("Sweet.Jayson.JaysonConverter") }
}

/** `Sweet.Jayson.JaysonConverter.ToObject` method */
class JaysonConverterToObjectMethod extends Method, UnsafeDeserializer {
  JaysonConverterToObjectMethod() {
    this.getDeclaringType() instanceof JaysonConverterClass and
    this.hasUndecoratedName("ToObject") and
    this.isStatic()
  }
}

/** ServiceStack.Text.JsonSerializer */
private class ServiceStackTextJsonSerializerClass extends Class {
  ServiceStackTextJsonSerializerClass() {
    this.hasQualifiedName("ServiceStack.Text.JsonSerializer")
  }
}

/** `ServiceStack.Text.JsonSerializer.DeserializeFromString` method */
class ServiceStackTextJsonSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextJsonSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextJsonSerializerClass and
    this.hasUndecoratedName("DeserializeFromString") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.JsonSerializer.DeserializeFromReader` method */
class ServiceStackTextJsonSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextJsonSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextJsonSerializerClass and
    this.hasUndecoratedName("DeserializeFromReader") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.JsonSerializer.DeserializeFromStream` method */
class ServiceStackTextJsonSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextJsonSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextJsonSerializerClass and
    this.hasUndecoratedName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** ServiceStack.Text.TypeSerializer */
private class ServiceStackTextTypeSerializerClass extends Class {
  ServiceStackTextTypeSerializerClass() {
    this.hasQualifiedName("ServiceStack.Text.TypeSerializer")
  }
}

/** `ServiceStack.Text.TypeSerializer.DeserializeFromString` method */
class ServiceStackTextTypeSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextTypeSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextTypeSerializerClass and
    this.hasUndecoratedName("DeserializeFromString") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.TypeSerializer.DeserializeFromReader` method */
class ServiceStackTextTypeSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextTypeSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextTypeSerializerClass and
    this.hasUndecoratedName("DeserializeFromReader") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.TypeSerializer.DeserializeFromStream` method */
class ServiceStackTextTypeSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextTypeSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextTypeSerializerClass and
    this.hasUndecoratedName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** ServiceStack.Text.CsvSerializer */
private class ServiceStackTextCsvSerializerClass extends Class {
  ServiceStackTextCsvSerializerClass() { this.hasQualifiedName("ServiceStack.Text.CsvSerializer") }
}

/** `ServiceStack.Text.CsvSerializer.DeserializeFromString` method */
class ServiceStackTextCsvSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextCsvSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextCsvSerializerClass and
    this.hasUndecoratedName("DeserializeFromString") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.TypeSeriCsvSerializeralizer.DeserializeFromReader` method */
class ServiceStackTextCsvSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextCsvSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextCsvSerializerClass and
    this.hasUndecoratedName("DeserializeFromReader") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.CsvSerializer.DeserializeFromStream` method */
class ServiceStackTextCsvSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextCsvSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextCsvSerializerClass and
    this.hasUndecoratedName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** ServiceStack.Text.XmlSerializer */
private class ServiceStackTextXmlSerializerClass extends Class {
  ServiceStackTextXmlSerializerClass() { this.hasQualifiedName("ServiceStack.Text.XmlSerializer") }
}

/** `ServiceStack.Text.XmlSerializer.DeserializeFromString` method */
class ServiceStackTextXmlSerializerDeserializeFromStringMethod extends Method, UnsafeDeserializer {
  ServiceStackTextXmlSerializerDeserializeFromStringMethod() {
    this.getDeclaringType() instanceof ServiceStackTextXmlSerializerClass and
    this.hasUndecoratedName("DeserializeFromString") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.XmlSerializer.DeserializeFromReader` method */
class ServiceStackTextXmlSerializerDeserializeFromReaderMethod extends Method, UnsafeDeserializer {
  ServiceStackTextXmlSerializerDeserializeFromReaderMethod() {
    this.getDeclaringType() instanceof ServiceStackTextXmlSerializerClass and
    this.hasUndecoratedName("DeserializeFromReader") and
    this.isStatic()
  }
}

/** `ServiceStack.Text.XmlSerializer.DeserializeFromStream` method */
class ServiceStackTextXmlSerializerDeserializeFromStreamMethod extends Method, UnsafeDeserializer {
  ServiceStackTextXmlSerializerDeserializeFromStreamMethod() {
    this.getDeclaringType() instanceof ServiceStackTextXmlSerializerClass and
    this.hasUndecoratedName("DeserializeFromStream") and
    this.isStatic()
  }
}

/** MBrace.FsPickler.FsPicklerSerializer */
private class FsPicklerSerializerClass extends Class {
  FsPicklerSerializerClass() { this.hasQualifiedName("MBrace.FsPickler.FsPicklerSerializer") }
}

/** `MBrace.FsPickler.FsPicklerSerializer.Deserialize` method */
class FsPicklerSerializerClassDeserializeMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassDeserializeMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.DeserializeSequence` method */
class FsPicklerSerializerClassDeserializeSequenceMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassDeserializeSequenceMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("DeserializeSequence")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.DeserializeSifted` method */
class FsPicklerSerializerClasDeserializeSiftedMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClasDeserializeSiftedMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("DeserializeSifted")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.UnPickle` method */
class FsPicklerSerializerClassUnPickleMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassUnPickleMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("UnPickle")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.UnPickleSifted` method */
class FsPicklerSerializerClassUnPickleSiftedMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassUnPickleSiftedMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("UnPickleSifted")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.DeserializeUntyped` method */
class FsPicklerSerializerClassDeserializeUntypedMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassDeserializeUntypedMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("DeserializeUntyped")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.DeserializeSequenceUntyped` method */
class FsPicklerSerializerClassDeserializeSequenceUntypedMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassDeserializeSequenceUntypedMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("DeserializeSequenceUntyped")
  }
}

/** `MBrace.FsPickler.FsPicklerSerializer.UnPickleUntyped` method */
class FsPicklerSerializerClassUnPickleUntypedMethod extends Method, UnsafeDeserializer {
  FsPicklerSerializerClassUnPickleUntypedMethod() {
    this.getDeclaringType().getBaseClass*() instanceof FsPicklerSerializerClass and
    this.hasUndecoratedName("UnPickleUntyped")
  }
}

/** MBrace.CsPickler.CsPicklerSerializer */
private class CsPicklerSerializerClass extends Class {
  CsPicklerSerializerClass() { this.hasQualifiedName("MBrace.CsPickler.CsPicklerSerializer") }
}

/** `MBrace.FsPickler.CsPicklerSerializer.Deserialize` method */
class CsPicklerSerializerClassDeserializeMethod extends Method, UnsafeDeserializer {
  CsPicklerSerializerClassDeserializeMethod() {
    this.getDeclaringType().getBaseClass*() instanceof CsPicklerSerializerClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** `MBrace.FsPickler.CsPicklerSerializer.UnPickle` method */
class CsPicklerSerializerClassUnPickleMethod extends Method, UnsafeDeserializer {
  CsPicklerSerializerClassUnPickleMethod() {
    this.getDeclaringType().getBaseClass*() instanceof CsPicklerSerializerClass and
    this.hasUndecoratedName("UnPickle")
  }
}

/** MBrace.CsPickler.CsPicklerTextSerializer */
private class CsPicklerTextSerializerClass extends Class {
  CsPicklerTextSerializerClass() {
    this.hasQualifiedName("MBrace.CsPickler.CsPicklerTextSerializer")
  }
}

/** `MBrace.FsPickler.CsPicklerTextSerializer.UnPickleOfString` method */
class CsPicklerSerializerClassUnPickleOfStringMethod extends Method, UnsafeDeserializer {
  CsPicklerSerializerClassUnPickleOfStringMethod() {
    this.getDeclaringType().getBaseClass*() instanceof CsPicklerTextSerializerClass and
    this.hasUndecoratedName("UnPickleOfString")
  }
}

/** Polenter.Serialization.SharpSerializer */
private class SharpSerializerClass extends Class {
  SharpSerializerClass() { this.hasQualifiedName("Polenter.Serialization.SharpSerializer") }
}

/** `Polenter.Serialization.SharpSerializer.Deserialize` method */
class SharpSerializerClassDeserializeMethod extends Method, UnsafeDeserializer {
  SharpSerializerClassDeserializeMethod() {
    this.getDeclaringType().getBaseClass*() instanceof SharpSerializerClass and
    this.hasUndecoratedName("Deserialize")
  }
}

/** YamlDotNet.Serialization.Deserializer */
private class YamlDotNetDeserializerClass extends Class {
  YamlDotNetDeserializerClass() { this.hasQualifiedName("YamlDotNet.Serialization.Deserializer") }
}

/** `YamlDotNet.Serialization.Deserializer.Deserialize` method */
class YamlDotNetDeserializerClasseserializeMethod extends Method, UnsafeDeserializer {
  YamlDotNetDeserializerClasseserializeMethod() {
    exists(YamlDotNetDeserializerClass c |
      this.getDeclaringType().getBaseClass*() = c and
      this.hasUndecoratedName("Deserialize") and
      c.getALocation().(Assembly).getVersion().getMajor() < 5
    )
  }
}

/** `Newtonsoft.Json.JsonConvert.DeserializeObject` method */
class NewtonsoftJsonConvertClassDeserializeObjectMethod extends Method, UnsafeDeserializer {
  NewtonsoftJsonConvertClassDeserializeObjectMethod() {
    this.getDeclaringType() instanceof JsonConvertClass and
    this.hasUndecoratedName("DeserializeObject") and
    this.isStatic()
  }
}
