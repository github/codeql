// This file contains auto-generated code.

namespace System
{
    namespace Collections
    {
        namespace Concurrent
        {
            // Generated from `System.Collections.Concurrent.BlockingCollection<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class BlockingCollection<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.ICollection, System.Collections.IEnumerable, System.IDisposable
            {
                public void Add(T item) => throw null;
                public void Add(T item, System.Threading.CancellationToken cancellationToken) => throw null;
                public static int AddToAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, T item) => throw null;
                public static int AddToAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, T item, System.Threading.CancellationToken cancellationToken) => throw null;
                public BlockingCollection() => throw null;
                public BlockingCollection(System.Collections.Concurrent.IProducerConsumerCollection<T> collection) => throw null;
                public BlockingCollection(System.Collections.Concurrent.IProducerConsumerCollection<T> collection, int boundedCapacity) => throw null;
                public BlockingCollection(int boundedCapacity) => throw null;
                public int BoundedCapacity { get => throw null; }
                public void CompleteAdding() => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public int Count { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Collections.Generic.IEnumerable<T> GetConsumingEnumerable() => throw null;
                public System.Collections.Generic.IEnumerable<T> GetConsumingEnumerable(System.Threading.CancellationToken cancellationToken) => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsAddingCompleted { get => throw null; }
                public bool IsCompleted { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T Take() => throw null;
                public T Take(System.Threading.CancellationToken cancellationToken) => throw null;
                public static int TakeFromAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, out T item) => throw null;
                public static int TakeFromAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, out T item, System.Threading.CancellationToken cancellationToken) => throw null;
                public T[] ToArray() => throw null;
                public bool TryAdd(T item) => throw null;
                public bool TryAdd(T item, System.TimeSpan timeout) => throw null;
                public bool TryAdd(T item, int millisecondsTimeout) => throw null;
                public bool TryAdd(T item, int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public static int TryAddToAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, T item) => throw null;
                public static int TryAddToAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, T item, System.TimeSpan timeout) => throw null;
                public static int TryAddToAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, T item, int millisecondsTimeout) => throw null;
                public static int TryAddToAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, T item, int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public bool TryTake(out T item) => throw null;
                public bool TryTake(out T item, System.TimeSpan timeout) => throw null;
                public bool TryTake(out T item, int millisecondsTimeout) => throw null;
                public bool TryTake(out T item, int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
                public static int TryTakeFromAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, out T item) => throw null;
                public static int TryTakeFromAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, out T item, System.TimeSpan timeout) => throw null;
                public static int TryTakeFromAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, out T item, int millisecondsTimeout) => throw null;
                public static int TryTakeFromAny(System.Collections.Concurrent.BlockingCollection<T>[] collections, out T item, int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            }

            // Generated from `System.Collections.Concurrent.ConcurrentBag<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConcurrentBag<T> : System.Collections.Concurrent.IProducerConsumerCollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void Add(T item) => throw null;
                public void Clear() => throw null;
                public ConcurrentBag() => throw null;
                public ConcurrentBag(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsEmpty { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T[] ToArray() => throw null;
                bool System.Collections.Concurrent.IProducerConsumerCollection<T>.TryAdd(T item) => throw null;
                public bool TryPeek(out T result) => throw null;
                public bool TryTake(out T result) => throw null;
            }

            // Generated from `System.Collections.Concurrent.ConcurrentDictionary<,>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConcurrentDictionary<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>, System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
            {
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Add(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.Generic.IDictionary<TKey, TValue>.Add(TKey key, TValue value) => throw null;
                void System.Collections.IDictionary.Add(object key, object value) => throw null;
                public TValue AddOrUpdate(TKey key, System.Func<TKey, TValue> addValueFactory, System.Func<TKey, TValue, TValue> updateValueFactory) => throw null;
                public TValue AddOrUpdate(TKey key, TValue addValue, System.Func<TKey, TValue, TValue> updateValueFactory) => throw null;
                public TValue AddOrUpdate<TArg>(TKey key, System.Func<TKey, TArg, TValue> addValueFactory, System.Func<TKey, TValue, TArg, TValue> updateValueFactory, TArg factoryArgument) => throw null;
                public void Clear() => throw null;
                public ConcurrentDictionary() => throw null;
                public ConcurrentDictionary(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection) => throw null;
                public ConcurrentDictionary(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public ConcurrentDictionary(System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public ConcurrentDictionary(int concurrencyLevel, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public ConcurrentDictionary(int concurrencyLevel, int capacity) => throw null;
                public ConcurrentDictionary(int concurrencyLevel, int capacity, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Contains(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                bool System.Collections.IDictionary.Contains(object key) => throw null;
                public bool ContainsKey(TKey key) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.CopyTo(System.Collections.Generic.KeyValuePair<TKey, TValue>[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public TValue GetOrAdd(TKey key, System.Func<TKey, TValue> valueFactory) => throw null;
                public TValue GetOrAdd(TKey key, TValue value) => throw null;
                public TValue GetOrAdd<TArg>(TKey key, System.Func<TKey, TArg, TValue> valueFactory, TArg factoryArgument) => throw null;
                public bool IsEmpty { get => throw null; }
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.IsReadOnly { get => throw null; }
                bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public TValue this[TKey key] { get => throw null; set => throw null; }
                object System.Collections.IDictionary.this[object key] { get => throw null; set => throw null; }
                public System.Collections.Generic.ICollection<TKey> Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<TKey> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Remove(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                bool System.Collections.Generic.IDictionary<TKey, TValue>.Remove(TKey key) => throw null;
                void System.Collections.IDictionary.Remove(object key) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public System.Collections.Generic.KeyValuePair<TKey, TValue>[] ToArray() => throw null;
                public bool TryAdd(TKey key, TValue value) => throw null;
                public bool TryGetValue(TKey key, out TValue value) => throw null;
                public bool TryRemove(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                public bool TryRemove(TKey key, out TValue value) => throw null;
                public bool TryUpdate(TKey key, TValue newValue, TValue comparisonValue) => throw null;
                public System.Collections.Generic.ICollection<TValue> Values { get => throw null; }
                System.Collections.Generic.IEnumerable<TValue> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
            }

            // Generated from `System.Collections.Concurrent.ConcurrentQueue<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConcurrentQueue<T> : System.Collections.Concurrent.IProducerConsumerCollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void Clear() => throw null;
                public ConcurrentQueue() => throw null;
                public ConcurrentQueue(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public int Count { get => throw null; }
                public void Enqueue(T item) => throw null;
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsEmpty { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T[] ToArray() => throw null;
                bool System.Collections.Concurrent.IProducerConsumerCollection<T>.TryAdd(T item) => throw null;
                public bool TryDequeue(out T result) => throw null;
                public bool TryPeek(out T result) => throw null;
                bool System.Collections.Concurrent.IProducerConsumerCollection<T>.TryTake(out T item) => throw null;
            }

            // Generated from `System.Collections.Concurrent.ConcurrentStack<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConcurrentStack<T> : System.Collections.Concurrent.IProducerConsumerCollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void Clear() => throw null;
                public ConcurrentStack() => throw null;
                public ConcurrentStack(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsEmpty { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public void Push(T item) => throw null;
                public void PushRange(T[] items) => throw null;
                public void PushRange(T[] items, int startIndex, int count) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T[] ToArray() => throw null;
                bool System.Collections.Concurrent.IProducerConsumerCollection<T>.TryAdd(T item) => throw null;
                public bool TryPeek(out T result) => throw null;
                public bool TryPop(out T result) => throw null;
                public int TryPopRange(T[] items) => throw null;
                public int TryPopRange(T[] items, int startIndex, int count) => throw null;
                bool System.Collections.Concurrent.IProducerConsumerCollection<T>.TryTake(out T item) => throw null;
            }

            // Generated from `System.Collections.Concurrent.EnumerablePartitionerOptions` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum EnumerablePartitionerOptions
            {
                NoBuffering,
                None,
            }

            // Generated from `System.Collections.Concurrent.IProducerConsumerCollection<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IProducerConsumerCollection<T> : System.Collections.Generic.IEnumerable<T>, System.Collections.ICollection, System.Collections.IEnumerable
            {
                void CopyTo(T[] array, int index);
                T[] ToArray();
                bool TryAdd(T item);
                bool TryTake(out T item);
            }

            // Generated from `System.Collections.Concurrent.OrderablePartitioner<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class OrderablePartitioner<TSource> : System.Collections.Concurrent.Partitioner<TSource>
            {
                public override System.Collections.Generic.IEnumerable<TSource> GetDynamicPartitions() => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.Int64, TSource>> GetOrderableDynamicPartitions() => throw null;
                public abstract System.Collections.Generic.IList<System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<System.Int64, TSource>>> GetOrderablePartitions(int partitionCount);
                public override System.Collections.Generic.IList<System.Collections.Generic.IEnumerator<TSource>> GetPartitions(int partitionCount) => throw null;
                public bool KeysNormalized { get => throw null; }
                public bool KeysOrderedAcrossPartitions { get => throw null; }
                public bool KeysOrderedInEachPartition { get => throw null; }
                protected OrderablePartitioner(bool keysOrderedInEachPartition, bool keysOrderedAcrossPartitions, bool keysNormalized) => throw null;
            }

            // Generated from `System.Collections.Concurrent.Partitioner` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class Partitioner
            {
                public static System.Collections.Concurrent.OrderablePartitioner<System.Tuple<int, int>> Create(int fromInclusive, int toExclusive) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<System.Tuple<int, int>> Create(int fromInclusive, int toExclusive, int rangeSize) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<System.Tuple<System.Int64, System.Int64>> Create(System.Int64 fromInclusive, System.Int64 toExclusive) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<System.Tuple<System.Int64, System.Int64>> Create(System.Int64 fromInclusive, System.Int64 toExclusive, System.Int64 rangeSize) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<TSource> Create<TSource>(System.Collections.Generic.IEnumerable<TSource> source) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<TSource> Create<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Collections.Concurrent.EnumerablePartitionerOptions partitionerOptions) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<TSource> Create<TSource>(System.Collections.Generic.IList<TSource> list, bool loadBalance) => throw null;
                public static System.Collections.Concurrent.OrderablePartitioner<TSource> Create<TSource>(TSource[] array, bool loadBalance) => throw null;
            }

            // Generated from `System.Collections.Concurrent.Partitioner<>` in `System.Collections.Concurrent, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class Partitioner<TSource>
            {
                public virtual System.Collections.Generic.IEnumerable<TSource> GetDynamicPartitions() => throw null;
                public abstract System.Collections.Generic.IList<System.Collections.Generic.IEnumerator<TSource>> GetPartitions(int partitionCount);
                protected Partitioner() => throw null;
                public virtual bool SupportsDynamicPartitions { get => throw null; }
            }

        }
    }
}
