/** Provides definitions related to the `System.Xml.Schema` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Xml.Schema.XmlSchemaObjectCollection`. */
private class SystemXmlSchemaXmlSchemaObjectCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Schema;XmlSchemaObjectCollection;false;Add;(System.Xml.Schema.XmlSchemaObject);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;CopyTo;(System.Xml.Schema.XmlSchemaObject[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Xml.Schema.XmlSchemaObjectEnumerator.Current];value",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;Insert;(System.Int32,System.Xml.Schema.XmlSchemaObject);;Argument[1];Argument[Qualifier].Element;value",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Xml.Schema;XmlSchemaObjectCollection;false;set_Item;(System.Int32,System.Xml.Schema.XmlSchemaObject);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Xml.Schema.XmlSchemaCollection`. */
private class SystemXmlSchemaXmlSchemaCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Xml.Schema;XmlSchemaCollection;false;Add;(System.Xml.Schema.XmlSchema);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Schema;XmlSchemaCollection;false;Add;(System.Xml.Schema.XmlSchemaCollection);;Argument[0];Argument[Qualifier].Element;value",
        "System.Xml.Schema;XmlSchemaCollection;false;CopyTo;(System.Xml.Schema.XmlSchema[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Xml.Schema;XmlSchemaCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Xml.Schema.XmlSchemaCollectionEnumerator.Current];value",
      ]
  }
}
