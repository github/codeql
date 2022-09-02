/** Provides definitions related to the `System.Xml.Schema` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Xml.Schema.XmlSchemaObjectCollection`. */
private class SystemXmlSchemaXmlSchemaObjectCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Schema;XmlSchemaObjectCollection;false;Add;(System.Xml.Schema.XmlSchemaObject);;Argument[0];Argument[this].Element;value;manual",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;CopyTo;(System.Xml.Schema.XmlSchemaObject[],System.Int32);;Argument[this].Element;Argument[0].Element;value;manual",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Xml.Schema.XmlSchemaObjectEnumerator.Current];value;manual",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;Insert;(System.Int32,System.Xml.Schema.XmlSchemaObject);;Argument[1];Argument[this].Element;value;manual",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;set_Item;(System.Int32,System.Xml.Schema.XmlSchemaObject);;Argument[1];Argument[this].Element;value;manual",
      ]
  }
}

/** Data flow for `System.Xml.Schema.XmlSchemaCollection`. */
private class SystemXmlSchemaXmlSchemaCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Schema;XmlSchemaCollection;false;Add;(System.Xml.Schema.XmlSchema);;Argument[0];Argument[this].Element;value;manual",
        "System.Xml.Schema;XmlSchemaCollection;false;Add;(System.Xml.Schema.XmlSchemaCollection);;Argument[0];Argument[this].Element;value;manual",
        "System.Xml.Schema;XmlSchemaCollection;false;CopyTo;(System.Xml.Schema.XmlSchema[],System.Int32);;Argument[this].Element;Argument[0].Element;value;manual",
        "System.Xml.Schema;XmlSchemaCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Xml.Schema.XmlSchemaCollectionEnumerator.Current];value;manual",
      ]
  }
}
