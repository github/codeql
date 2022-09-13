/** Provides definitions related to the `System.Collections.ObjectModel` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.ObjectModel.ReadOnlyDictionary<,>`. */
private class SystemCollectionsObjectModelReadOnlyDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.ObjectModel;ReadOnlyCollection<>;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;ReadOnlyDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;ReadOnlyDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Item;(TKey);;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Keys;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value;manual",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Values;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.ObjectModel.KeyedCollection<,>`. */
private class SystemCollectionsObjectModelKeyedCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.ObjectModel;KeyedCollection<,>;false;get_Item;(TKey);;Argument[this].Element;ReturnValue;value;manual"
  }
}
