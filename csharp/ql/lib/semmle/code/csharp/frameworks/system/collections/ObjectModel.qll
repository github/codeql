/** Provides definitions related to the `System.Collections.ObjectModel` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.ObjectModel.ReadOnlyDictionary<,>`. */
private class SystemCollectionsObjectModelReadOnlyDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.ObjectModel;ReadOnlyCollection<>;false;get_Item;(System.Int32);;Element of Argument[Qualifier];ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;ReadOnlyDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;ReadOnlyDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Item;(TKey);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];Element of ReturnValue;value",
        "System.Collections.ObjectModel;ReadOnlyDictionary<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.ObjectModel.KeyedCollection<,>`. */
private class SystemCollectionsObjectModelKeyedCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.ObjectModel;KeyedCollection<,>;false;get_Item;(TKey);;Element of Argument[Qualifier];ReturnValue;value"
  }
}
