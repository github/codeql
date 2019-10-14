/**
 * Known unsafe deserializers.
 * See https://www.blackhat.com/docs/us-17/thursday/us-17-Munoz-Friday-The-13th-Json-Attacks.pdf
 * CVE-2017-10712
 * CVE-2017-9424
 * CVE-2017-8565
 * CVE-2017-9822
 */

import csharp

private Callable api(string type, string name) {
  result.getDeclaringType().getQualifiedName() = type and
  result.hasName(name)
}

class UnsafeDeserializer extends Callable {
  UnsafeDeserializer() {
    this = api("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter", "Deserialize")
    or
    this = api("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter", "UnsafeDeserialize")
    or
    this = api("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter",
        "UnsafeDeserializeMethodResponse")
    or
    this = api("System.Runtime.Deserialization.Formatters.Soap.SoapFormatter", "Deserialize")
    or
    this = api("System.Web.UI.ObjectStateFormatter", "Deserialize")
    or
    this = api("System.Runtime.Serialization.NetDataContractSerializer", "Deserialize")
    or
    this = api("System.Runtime.Serialization.NetDataContractSerializer", "ReadObject")
    or
    this = api("System.Web.UI.LosFormatter", "Deserialize")
    or
    this = api("System.Workflow.ComponentModel.Activity", "Load")
    or
    this = api("System.Resources.ResourceReader", "ResourceReader")
    or
    this = api("Microsoft.Web.Design.Remote.ProxyObject", "DecodeValue")
    or
    this = api("System.Messaging", "BinaryMessageFormatter")
    or
    this = api("System.Windows.Markup.XamlReader", "Parse")
    or
    this = api("System.Windows.Markup.XamlReader", "Load")
    or
    this = api("System.Windows.Markup.XamlReader", "LoadAsync")
    or
    exists(Call call |
      call.getEnclosingCallable() = this and
      call.getAnArgument() instanceof ParameterAccess and
      call.getTarget() instanceof UnsafeDeserializer
    )
  }
}
