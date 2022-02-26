/** Provides definitions related to the `System.Xml.Serialization` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Xml.Serialization.XmlAnyElementAttributes`. */
private class SystemXmlSerializationXmlAnyElementAttributesFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Serialization;XmlAnyElementAttributes;false;Add;(System.Xml.Serialization.XmlAnyElementAttribute);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlAnyElementAttributes;false;CopyTo;(System.Xml.Serialization.XmlAnyElementAttribute[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Xml.Serialization;XmlAnyElementAttributes;false;Insert;(System.Int32,System.Xml.Serialization.XmlAnyElementAttribute);;Argument[1];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlAnyElementAttributes;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Serialization;XmlAnyElementAttributes;false;set_Item;(System.Int32,System.Xml.Serialization.XmlAnyElementAttribute);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Xml.Serialization.XmlArrayItemAttributes`. */
private class SystemXmlSerializationXmlArrayItemAttributesFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Serialization;XmlArrayItemAttributes;false;Add;(System.Xml.Serialization.XmlArrayItemAttribute);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlArrayItemAttributes;false;CopyTo;(System.Xml.Serialization.XmlArrayItemAttribute[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Xml.Serialization;XmlArrayItemAttributes;false;Insert;(System.Int32,System.Xml.Serialization.XmlArrayItemAttribute);;Argument[1];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlArrayItemAttributes;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Serialization;XmlArrayItemAttributes;false;set_Item;(System.Int32,System.Xml.Serialization.XmlArrayItemAttribute);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Xml.Serialization.XmlElementAttributes`. */
private class SystemXmlSerializationXmlElementAttributesFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Serialization;XmlElementAttributes;false;Add;(System.Xml.Serialization.XmlElementAttribute);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlElementAttributes;false;CopyTo;(System.Xml.Serialization.XmlElementAttribute[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Xml.Serialization;XmlElementAttributes;false;Insert;(System.Int32,System.Xml.Serialization.XmlElementAttribute);;Argument[1];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlElementAttributes;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Serialization;XmlElementAttributes;false;set_Item;(System.Int32,System.Xml.Serialization.XmlElementAttribute);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Xml.Serialization.XmlSchemas`. */
private class SystemXmlSerializationXmlSchemasFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Serialization;XmlSchemas;false;Add;(System.Xml.Schema.XmlSchema);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlSchemas;false;Add;(System.Xml.Serialization.XmlSchemas);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlSchemas;false;CopyTo;(System.Xml.Schema.XmlSchema[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Xml.Serialization;XmlSchemas;false;Find;(System.Xml.XmlQualifiedName,System.Type);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Serialization;XmlSchemas;false;Insert;(System.Int32,System.Xml.Schema.XmlSchema);;Argument[1];Argument[Qualifier].Element;value",
        "System.Xml.Serialization;XmlSchemas;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Serialization;XmlSchemas;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Serialization;XmlSchemas;false;set_Item;(System.Int32,System.Xml.Schema.XmlSchema);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}
