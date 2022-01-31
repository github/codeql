/** Provides definitions related to the `System.Collections.Concurrent` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Collections.Concurrent.ConcurrentDictionary<,>`. */
private class SystemCollectionsConcurrentConcurrentDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Int32,System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;ConcurrentDictionary;(System.Int32,System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];Element of ReturnValue;value",
        "System.Collections.Concurrent;ConcurrentDictionary<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Concurrent.BlockingCollection<>`. */
private class SystemCollectionsConcurrentBlockingCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Concurrent;BlockingCollection<>;false;Add;(T);;Argument[0];Element of Argument[Qualifier];value",
        "System.Collections.Concurrent;BlockingCollection<>;false;CopyTo;(T[],System.Int32);;Element of Argument[Qualifier];Element of Argument[0];value",
      ]
  }
}

/** Data flow for `System.Collections.Concurrent.IProducerConsumerCollection<>`. */
private class SystemCollectionsConcurrentIProducerConsumerCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Concurrent;IProducerConsumerCollection<>;true;CopyTo;(T[],System.Int32);;Element of Argument[Qualifier];Element of Argument[0];value"
  }
}

/** Data flow for `System.Collections.Concurrent.ConcurrentBag<>`. */
private class SystemCollectionsConcurrentConcurrentBagFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Concurrent;ConcurrentBag<>;false;Add;(T);;Argument[0];Element of Argument[Qualifier];value"
  }
}
