/** Provides definitions related to the `System.Collections.Concurrent` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.Concurrent.ConcurrentDictionary<,>`. */
private class SystemCollectionsConcurrentConcurrentDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Int32,System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Argument[1].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Int32,System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Argument[1].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;get_Keys;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;get_Values;();;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element;value",
      ]
  }
}

/** Data flow for `System.Collections.Concurrent.BlockingCollection<>`. */
private class SystemCollectionsConcurrentBlockingCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Concurrent;BlockingCollection<>;false;Add;(T);;Argument[0];Argument[Qualifier].Element;value",
        "System.Collections.Concurrent;BlockingCollection<>;false;CopyTo;(T[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
      ]
  }
}

/** Data flow for `System.Collections.Concurrent.IProducerConsumerCollection<>`. */
private class SystemCollectionsConcurrentIProducerConsumerCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Concurrent;IProducerConsumerCollection<>;true;CopyTo;(T[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value"
  }
}

/** Data flow for `System.Collections.Concurrent.ConcurrentBag<>`. */
private class SystemCollectionsConcurrentConcurrentBagFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Concurrent;ConcurrentBag<>;false;Add;(T);;Argument[0];Argument[Qualifier].Element;value"
  }
}
