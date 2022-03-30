/** Provides definitions related to the `System.Collections.ObjectModel` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.ObjectModel.ReadOnlyDictionary<,>`. */
private class SystemCollectionsObjectModelReadOnlyDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.ObjectModel;ReadOnlyCollection<>;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;ReadOnlyDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;ReadOnlyDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Item;(TKey);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Keys;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Values;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value",
      ]
  }
}

/** Data flow for `System.Collections.ObjectModel.KeyedCollection<,>`. */
private class SystemCollectionsObjectModelKeyedCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.ObjectModel;KeyedCollection<,>;false;get_Item;(TKey);;Argument[Qualifier].Element;ReturnValue;value"
  }
}
