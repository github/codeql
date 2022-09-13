/** Provides definitions related to the namespace `System.Collections.Specialized`. */

import csharp
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Collections.Specialized` namespace. */
class SystemCollectionsSpecializedNamespace extends Namespace {
  SystemCollectionsSpecializedNamespace() {
    this.getParentNamespace() instanceof SystemCollectionsNamespace and
    this.hasName("Specialized")
  }
}

/** A class in the `System.Collections.Specialized` namespace. */
class SystemCollectionsSpecializedClass extends Class {
  SystemCollectionsSpecializedClass() {
    this.getNamespace() instanceof SystemCollectionsSpecializedNamespace
  }
}

/** The `System.Collections.Specialized.NameValueCollection` class. */
class SystemCollectionsSpecializedNameValueCollectionClass extends SystemCollectionsSpecializedClass {
  SystemCollectionsSpecializedNameValueCollectionClass() { this.hasName("NameValueCollection") }
}

/** Data flow for `System.Collections.Specialized.NameValueCollection`. */
private class SystemCollectionsSpecializedNameValueCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Specialized;NameValueCollection;false;Add;(System.Collections.Specialized.NameValueCollection);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Specialized;NameValueCollection;true;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Collections.Specialized;NameValueCollection;false;CopyTo;(System.Array,System.Int32);;Argument[this].Element;Argument[0].Element;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Specialized.IOrderedDictionary`. */
private class SystemCollectionsSpecializedIOrderedDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Specialized;IOrderedDictionary;true;get_Item;(System.Int32);;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value;manual",
        "System.Collections.Specialized;IOrderedDictionary;true;set_Item;(System.Int32,System.Object);;Argument[0];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Specialized;IOrderedDictionary;true;set_Item;(System.Int32,System.Object);;Argument[1];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Specialized.OrderedDictionary`. */
private class SystemCollectionsSpecializedOrderedDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Specialized;OrderedDictionary;false;AsReadOnly;();;Argument[0].Element;ReturnValue.Element;value;manual"
  }
}

/** Data flow for `System.Collections.Specialized.StringCollection`. */
private class SystemCollectionsSpecializedStringCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Specialized;StringCollection;false;Add;(System.String);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Specialized;StringCollection;false;AddRange;(System.String[]);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Specialized;StringCollection;false;CopyTo;(System.String[],System.Int32);;Argument[this].Element;Argument[0].Element;value;manual",
        "System.Collections.Specialized;StringCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Specialized.StringEnumerator.Current];value;manual",
        "System.Collections.Specialized;StringCollection;false;Insert;(System.Int32,System.String);;Argument[1];Argument[this].Element;value;manual",
        "System.Collections.Specialized;StringCollection;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Specialized;StringCollection;false;set_Item;(System.Int32,System.String);;Argument[1];Argument[this].Element;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Specialized.StringDictionary`. */
private class SystemCollectionsSpecializedStringDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Specialized;StringDictionary;true;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual"
  }
}
