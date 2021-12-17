/** Provides definitions related to the `System.Collections.Immutable` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.Immutable.IImmutableDictionary<,>`. */
private class SystemCollectionsImmutableIImmutableDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Immutable;IImmutableDictionary<,>;true;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Element of Argument[0];Element of Argument[-1];value"
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableDictionary<,>`. */
private class SystemCollectionsImmutableImmutableDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableDictionary<,>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(TKey,TValue);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(TKey,TValue);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableDictionary<,>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;get_Item;(TKey);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableSortedDictionary<,>`. */
private class SystemCollectionsImmutableImmutableSortedDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableSortedDictionary<,>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(TKey,TValue);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(TKey,TValue);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableSortedDictionary<,>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;get_Item;(TKey);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
      ]
  }
}
