/** Provides definitions related to the `System.Collections.Immutable` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.Immutable.IImmutableDictionary<,>`. */
private class SystemCollectionsImmutableIImmutableDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;IImmutableDictionary<,>;true;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;IImmutableDictionary<,>;true;Clear;();;Argument[this].WithoutElement;ReturnValue;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableDictionary<,>`. */
private class SystemCollectionsImmutableImmutableDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableDictionary<,>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;get_Keys;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>+Builder;false;get_Values;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(TKey,TValue);;Argument[0];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;Add;(TKey,TValue);;Argument[1];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableDictionary<,>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;get_Item;(TKey);;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;get_Keys;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableDictionary<,>;false;get_Values;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableSortedDictionary<,>`. */
private class SystemCollectionsImmutableImmutableSortedDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableSortedDictionary<,>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;get_Keys;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>+Builder;false;get_Values;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(TKey,TValue);;Argument[0];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;Add;(TKey,TValue);;Argument[1];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;AddRange;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableSortedDictionary<,>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;get_Item;(TKey);;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;get_Keys;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedDictionary<,>;false;get_Values;();;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.IImmutableList<>. */
private class SystemCollectionsImmutableIImmutableListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;IImmutableList<>;true;Add;(T);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Immutable;IImmutableList<>;true;AddRange;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;IImmutableList<>;true;Clear;();;Argument[this].WithoutElement;ReturnValue;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableList<>. */
private class SystemCollectionsImmutableImmutableListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableList<>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Find;(System.Predicate<T>);;Argument[this].Element;Argument[0].Parameter[0];value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Find;(System.Predicate<T>);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindAll;(System.Predicate<T>);;Argument[this].Element;Argument[0].Parameter[0];value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindAll;(System.Predicate<T>);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindLast;(System.Predicate<T>);;Argument[this].Element;Argument[0].Parameter[0];value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;FindLast;(System.Predicate<T>);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableList<>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;GetRange;(System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;InsertRange;(System.Int32,System.Collections.Generic.IEnumerable<T>);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Reverse;();;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>+Builder;false;Reverse;(System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;Add;(T);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;Find;(System.Predicate<T>);;Argument[this].Element;Argument[0].Parameter[0];value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;Find;(System.Predicate<T>);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;FindAll;(System.Predicate<T>);;Argument[this].Element;Argument[0].Parameter[0];value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;FindAll;(System.Predicate<T>);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;FindLast;(System.Predicate<T>);;Argument[this].Element;Argument[0].Parameter[0];value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;FindLast;(System.Predicate<T>);;Argument[this].Element;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableList<>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;GetRange;(System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;Insert;(System.Int32,T);;Argument[1];Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;InsertRange;(System.Int32,System.Collections.Generic.IEnumerable<T>);;Argument[1].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;Reverse;();;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;Reverse;(System.Int32,System.Int32);;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableList<>;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableSortedSet<>. */
private class SystemCollectionsImmutableImmutableSortedSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableSortedSet<>+Builder;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableSortedSet<>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableSortedSet<>+Builder;false;Reverse;();;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;Add;(T);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableSortedSet<>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;Reverse;();;Argument[0].Element;ReturnValue.Element;value;manual",
        "System.Collections.Immutable;ImmutableSortedSet<>;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.IImmutableSet<>. */
private class SystemCollectionsImmutableIImmutableSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;IImmutableSet<>;true;Add;(T);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Immutable;IImmutableSet<>;true;Clear;();;Argument[this].WithoutElement;ReturnValue;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableArray<>. */
private class SystemCollectionsImmutableImmutableArrayFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(System.Collections.Immutable.ImmutableArray<>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(System.Collections.Immutable.ImmutableArray<>+Builder);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange;(T[]);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange<>;(System.Collections.Immutable.ImmutableArray<TDerived>);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange<>;(System.Collections.Immutable.ImmutableArray<TDerived>+Builder);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;AddRange<>;(TDerived[]);;Argument[0].Element;Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Generic.IEnumerator<>.Current];value;manual",
        "System.Collections.Immutable;ImmutableArray<>+Builder;false;Reverse;();;Argument[0].Element;ReturnValue.Element;value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableHashSet<>. */
private class SystemCollectionsImmutableImmutableHashSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;ImmutableHashSet<>+Builder;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableHashSet<>+Enumerator.Current];value;manual",
        "System.Collections.Immutable;ImmutableHashSet<>;false;Add;(T);;Argument[0];Argument[this].Element;value;manual",
        "System.Collections.Immutable;ImmutableHashSet<>;false;Clear;();;Argument[this].WithoutElement;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableHashSet<>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableHashSet<>+Enumerator.Current];value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableQueue<>. */
private class SystemCollectionsImmutableImmutableQueueFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;IImmutableQueue<>;true;Clear;();;Argument[this].WithoutElement;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableQueue<>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableQueue<>+Enumerator.Current];value;manual",
      ]
  }
}

/** Data flow for `System.Collections.Immutable.ImmutableStack<>. */
private class SystemCollectionsImmutableImmutableStackFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Immutable;IImmutableStack<>;true;Clear;();;Argument[this].WithoutElement;ReturnValue;value;manual",
        "System.Collections.Immutable;ImmutableStack<>;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.Immutable.ImmutableStack<>+Enumerator.Current];value;manual",
      ]
  }
}
