/**
 * Provides a library of known unsafe deserializers.
 * See https://www.blackhat.com/docs/us-17/thursday/us-17-Munoz-Friday-The-13th-Json-Attacks.pdf.
 */

import csharp

/** An unsafe deserializer. */
abstract class UnsafeDeserializer extends Callable { }

/** An unsafe deserializer method in the `System.*` namespace. */
class SystemDeserializer extends UnsafeDeserializer {
  SystemDeserializer() {
    this
        .hasQualifiedName("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter",
          "Deserialize")
    or
    this
        .hasQualifiedName("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter",
          "UnsafeDeserialize")
    or
    this
        .hasQualifiedName("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter",
          "UnsafeDeserializeMethodResponse")
    or
    this
        .hasQualifiedName("System.Runtime.Deserialization.Formatters.Soap.SoapFormatter",
          "Deserialize")
    or
    this.hasQualifiedName("System.Web.UI.ObjectStateFormatter", "Deserialize")
    or
    this.hasQualifiedName("System.Runtime.Serialization.NetDataContractSerializer", "Deserialize")
    or
    this.hasQualifiedName("System.Runtime.Serialization.NetDataContractSerializer", "ReadObject")
    or
    this.hasQualifiedName("System.Web.UI.LosFormatter", "Deserialize")
    or
    this.hasQualifiedName("System.Workflow.ComponentModel.Activity", "Load")
    or
    this.hasQualifiedName("System.Resources.ResourceReader", "ResourceReader")
    or
    this.hasQualifiedName("System.Messaging", "BinaryMessageFormatter")
    or
    this.hasQualifiedName("System.Windows.Markup.XamlReader", "Parse")
    or
    this.hasQualifiedName("System.Windows.Markup.XamlReader", "Load")
    or
    this.hasQualifiedName("System.Windows.Markup.XamlReader", "LoadAsync")
  }
}

/** An unsafe deserializer method in the `Microsoft.*` namespace. */
class MicrosoftDeserializer extends UnsafeDeserializer {
  MicrosoftDeserializer() {
    this.hasQualifiedName("Microsoft.Web.Design.Remote.ProxyObject", "DecodeValue")
  }
}

/**
 * An unsafe deserializer method that calls any unsafe deserializer on any of
 * the parameters.
 */
class WrapperDeserializer extends UnsafeDeserializer {
  WrapperDeserializer() {
    exists(Call call |
      call.getEnclosingCallable() = this and
      call.getAnArgument() instanceof ParameterAccess and
      call.getTarget() instanceof UnsafeDeserializer
    )
  }
}
