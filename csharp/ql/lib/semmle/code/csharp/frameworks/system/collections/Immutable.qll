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

/** Data flow for `System.Collections.Immutable.IImmutableList<>. */
private class SystemCollectionsImmutableIImmutableListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;IImmutableList<>;true;Add;(T);;Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;IImmutableList<>;true;AddRange;(System.Collections.Generic.IEnumerable<T>);;Element of Argument[0];Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableList<>. */
private class SystemCollectionsImmutableImmutableListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableList<>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Find;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Find;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindAll;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindAll;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindLast;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindLast;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableList<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;GetRange;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;InsertRange;(System.Int32,System.Collections.Generic.IEnumerable<T>);;Element of Argument[1];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Reverse;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;Add;(T);;Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableList<>;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableList<>;false;Find;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Immutable;ImmutableList<>;false;Find;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;FindAll;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Immutable;ImmutableList<>;false;FindAll;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;FindLast;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Immutable;ImmutableList<>;false;FindLast;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableList<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;GetRange;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;Insert;(System.Int32,T);;Argument[1];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableList<>;false;InsertRange;(System.Int32,System.Collections.Generic.IEnumerable<T>);;Element of Argument[1];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableList<>;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;Reverse;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableList<>;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableSortedSet<>. */
private class SystemCollectionsImmutableImmutableSortedSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableSortedSet<>+Builder;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableSortedSet<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedSet<>+Builder;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;Add;(T);;Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableSortedSet<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.IImmutableSet<>. */
private class SystemCollectionsImmutableIImmutableSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Immutable;IImmutableSet<>;true;Add;(T);;Argument[0];Element of Argument[-1];value"
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableArray<>. */
private class SystemCollectionsImmutableImmutableArrayFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(System.Collections.Immutable.ImmutableArray<>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(System.Collections.Immutable.ImmutableArray<>+Builder);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(T[]);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange<>;(System.Collections.Immutable.ImmutableArray<TDerived>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange<>;(System.Collections.Immutable.ImmutableArray<TDerived>+Builder);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange<>;(TDerived[]);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.IEnumerator<>.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableHashSet<>. */
private class SystemCollectionsImmutableImmutableHashSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableHashSet<>+Builder;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableHashSet<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Immutable;ImmutableHashSet<>;false;Add;(T);;Argument[0];Element of Argument[-1];value",
        "System.Collections.Immutable;ImmutableHashSet<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableHashSet<>+Enumerator.Current] of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableQueue<>. */
private class SystemCollectionsImmutableImmutableQueueFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Immutable;ImmutableQueue<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableQueue<>+Enumerator.Current] of ReturnValue;value"
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableStack<>. */
private class SystemCollectionsImmutableImmutableStackFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Immutable;ImmutableStack<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Immutable.ImmutableStack<>+Enumerator.Current] of ReturnValue;value"
  }
}
