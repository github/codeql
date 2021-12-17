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

/** Data flow for `System.Collections.Specialized.IOrderedDictionary`. */
private class SystemCollectionsSpecializedIOrderedDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Specialized;IOrderedDictionary;true;get_Item;(System.Int32);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Collections.Specialized;IOrderedDictionary;true;set_Item;(System.Int32,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Specialized;IOrderedDictionary;true;set_Item;(System.Int32,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
      ]
  }
}
