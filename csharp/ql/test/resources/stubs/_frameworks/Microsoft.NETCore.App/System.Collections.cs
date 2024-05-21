// This file contains auto-generated code.
// Generated from `System.Collections, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Collections
    {
        public sealed class BitArray : System.ICloneable, System.Collections.ICollection, System.Collections.IEnumerable
        {
            public System.Collections.BitArray And(System.Collections.BitArray value) => throw null;
            public object Clone() => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public BitArray(bool[] values) => throw null;
            public BitArray(byte[] bytes) => throw null;
            public BitArray(System.Collections.BitArray bits) => throw null;
            public BitArray(int length) => throw null;
            public BitArray(int length, bool defaultValue) => throw null;
            public BitArray(int[] values) => throw null;
            public bool Get(int index) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool HasAllSet() => throw null;
            public bool HasAnySet() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            public System.Collections.BitArray LeftShift(int count) => throw null;
            public int Length { get => throw null; set { } }
            public System.Collections.BitArray Not() => throw null;
            public System.Collections.BitArray Or(System.Collections.BitArray value) => throw null;
            public System.Collections.BitArray RightShift(int count) => throw null;
            public void Set(int index, bool value) => throw null;
            public void SetAll(bool value) => throw null;
            public object SyncRoot { get => throw null; }
            public bool this[int index] { get => throw null; set { } }
            public System.Collections.BitArray Xor(System.Collections.BitArray value) => throw null;
        }
        namespace Generic
        {
            public static partial class CollectionExtensions
            {
                public static void AddRange<T>(this System.Collections.Generic.List<T> list, System.ReadOnlySpan<T> source) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<T> AsReadOnly<T>(this System.Collections.Generic.IList<T> list) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyDictionary<TKey, TValue> AsReadOnly<TKey, TValue>(this System.Collections.Generic.IDictionary<TKey, TValue> dictionary) => throw null;
                public static void CopyTo<T>(this System.Collections.Generic.List<T> list, System.Span<T> destination) => throw null;
                public static TValue GetValueOrDefault<TKey, TValue>(this System.Collections.Generic.IReadOnlyDictionary<TKey, TValue> dictionary, TKey key) => throw null;
                public static TValue GetValueOrDefault<TKey, TValue>(this System.Collections.Generic.IReadOnlyDictionary<TKey, TValue> dictionary, TKey key, TValue defaultValue) => throw null;
                public static void InsertRange<T>(this System.Collections.Generic.List<T> list, int index, System.ReadOnlySpan<T> source) => throw null;
                public static bool Remove<TKey, TValue>(this System.Collections.Generic.IDictionary<TKey, TValue> dictionary, TKey key, out TValue value) => throw null;
                public static bool TryAdd<TKey, TValue>(this System.Collections.Generic.IDictionary<TKey, TValue> dictionary, TKey key, TValue value) => throw null;
            }
            public abstract class Comparer<T> : System.Collections.Generic.IComparer<T>, System.Collections.IComparer
            {
                public abstract int Compare(T x, T y);
                int System.Collections.IComparer.Compare(object x, object y) => throw null;
                public static System.Collections.Generic.Comparer<T> Create(System.Comparison<T> comparison) => throw null;
                protected Comparer() => throw null;
                public static System.Collections.Generic.Comparer<T> Default { get => throw null; }
            }
            public class Dictionary<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.ICollection, System.Runtime.Serialization.IDeserializationCallback, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.IDictionary, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>, System.Runtime.Serialization.ISerializable
            {
                public void Add(TKey key, TValue value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Add(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.IDictionary.Add(object key, object value) => throw null;
                public void Clear() => throw null;
                public System.Collections.Generic.IEqualityComparer<TKey> Comparer { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Contains(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                bool System.Collections.IDictionary.Contains(object key) => throw null;
                public bool ContainsKey(TKey key) => throw null;
                public bool ContainsValue(TValue value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.CopyTo(System.Collections.Generic.KeyValuePair<TKey, TValue>[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public Dictionary() => throw null;
                public Dictionary(System.Collections.Generic.IDictionary<TKey, TValue> dictionary) => throw null;
                public Dictionary(System.Collections.Generic.IDictionary<TKey, TValue> dictionary, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public Dictionary(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection) => throw null;
                public Dictionary(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public Dictionary(System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public Dictionary(int capacity) => throw null;
                public Dictionary(int capacity, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                protected Dictionary(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public int EnsureCapacity(int capacity) => throw null;
                public struct Enumerator : System.Collections.IDictionaryEnumerator, System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerator
                {
                    public System.Collections.Generic.KeyValuePair<TKey, TValue> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    System.Collections.DictionaryEntry System.Collections.IDictionaryEnumerator.Entry { get => throw null; }
                    object System.Collections.IDictionaryEnumerator.Key { get => throw null; }
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                    object System.Collections.IDictionaryEnumerator.Value { get => throw null; }
                }
                public System.Collections.Generic.Dictionary<TKey, TValue>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>.GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.IsReadOnly { get => throw null; }
                bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IDictionary.this[object key] { get => throw null; set { } }
                public sealed class KeyCollection : System.Collections.Generic.ICollection<TKey>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<TKey>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<TKey>
                {
                    void System.Collections.Generic.ICollection<TKey>.Add(TKey item) => throw null;
                    void System.Collections.Generic.ICollection<TKey>.Clear() => throw null;
                    public bool Contains(TKey item) => throw null;
                    public void CopyTo(TKey[] array, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public KeyCollection(System.Collections.Generic.Dictionary<TKey, TValue> dictionary) => throw null;
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<TKey>, System.Collections.IEnumerator
                    {
                        public TKey Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                    public System.Collections.Generic.Dictionary<TKey, TValue>.KeyCollection.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<TKey> System.Collections.Generic.IEnumerable<TKey>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<TKey>.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    bool System.Collections.Generic.ICollection<TKey>.Remove(TKey item) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }
                public System.Collections.Generic.Dictionary<TKey, TValue>.KeyCollection Keys { get => throw null; }
                System.Collections.Generic.ICollection<TKey> System.Collections.Generic.IDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<TKey> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
                public virtual void OnDeserialization(object sender) => throw null;
                public bool Remove(TKey key) => throw null;
                public bool Remove(TKey key, out TValue value) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Remove(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.IDictionary.Remove(object key) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public TValue this[TKey key] { get => throw null; set { } }
                public void TrimExcess() => throw null;
                public void TrimExcess(int capacity) => throw null;
                public bool TryAdd(TKey key, TValue value) => throw null;
                public bool TryGetValue(TKey key, out TValue value) => throw null;
                public sealed class ValueCollection : System.Collections.Generic.ICollection<TValue>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<TValue>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<TValue>
                {
                    void System.Collections.Generic.ICollection<TValue>.Add(TValue item) => throw null;
                    void System.Collections.Generic.ICollection<TValue>.Clear() => throw null;
                    bool System.Collections.Generic.ICollection<TValue>.Contains(TValue item) => throw null;
                    public void CopyTo(TValue[] array, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public ValueCollection(System.Collections.Generic.Dictionary<TKey, TValue> dictionary) => throw null;
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<TValue>, System.Collections.IEnumerator
                    {
                        public TValue Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                    public System.Collections.Generic.Dictionary<TKey, TValue>.ValueCollection.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<TValue> System.Collections.Generic.IEnumerable<TValue>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<TValue>.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    bool System.Collections.Generic.ICollection<TValue>.Remove(TValue item) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }
                System.Collections.Generic.ICollection<TValue> System.Collections.Generic.IDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.Generic.IEnumerable<TValue> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
                public System.Collections.Generic.Dictionary<TKey, TValue>.ValueCollection Values { get => throw null; }
            }
            public abstract class EqualityComparer<T> : System.Collections.Generic.IEqualityComparer<T>, System.Collections.IEqualityComparer
            {
                public static System.Collections.Generic.EqualityComparer<T> Create(System.Func<T, T, bool> equals, System.Func<T, int> getHashCode = default(System.Func<T, int>)) => throw null;
                protected EqualityComparer() => throw null;
                public static System.Collections.Generic.EqualityComparer<T> Default { get => throw null; }
                public abstract bool Equals(T x, T y);
                bool System.Collections.IEqualityComparer.Equals(object x, object y) => throw null;
                public abstract int GetHashCode(T obj);
                int System.Collections.IEqualityComparer.GetHashCode(object obj) => throw null;
            }
            public class HashSet<T> : System.Collections.Generic.ICollection<T>, System.Runtime.Serialization.IDeserializationCallback, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlySet<T>, System.Runtime.Serialization.ISerializable, System.Collections.Generic.ISet<T>
            {
                public bool Add(T item) => throw null;
                void System.Collections.Generic.ICollection<T>.Add(T item) => throw null;
                public void Clear() => throw null;
                public System.Collections.Generic.IEqualityComparer<T> Comparer { get => throw null; }
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                public void CopyTo(T[] array, int arrayIndex, int count) => throw null;
                public int Count { get => throw null; }
                public static System.Collections.Generic.IEqualityComparer<System.Collections.Generic.HashSet<T>> CreateSetComparer() => throw null;
                public HashSet() => throw null;
                public HashSet(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public HashSet(System.Collections.Generic.IEnumerable<T> collection, System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
                public HashSet(System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
                public HashSet(int capacity) => throw null;
                public HashSet(int capacity, System.Collections.Generic.IEqualityComparer<T> comparer) => throw null;
                protected HashSet(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public int EnsureCapacity(int capacity) => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                {
                    public T Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public void ExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public System.Collections.Generic.HashSet<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public void IntersectWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                public bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public virtual void OnDeserialization(object sender) => throw null;
                public bool Overlaps(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Remove(T item) => throw null;
                public int RemoveWhere(System.Predicate<T> match) => throw null;
                public bool SetEquals(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void SymmetricExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void TrimExcess() => throw null;
                public bool TryGetValue(T equalValue, out T actualValue) => throw null;
                public void UnionWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
            }
            public class LinkedList<T> : System.Collections.Generic.ICollection<T>, System.Collections.ICollection, System.Runtime.Serialization.IDeserializationCallback, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<T>, System.Runtime.Serialization.ISerializable
            {
                void System.Collections.Generic.ICollection<T>.Add(T value) => throw null;
                public void AddAfter(System.Collections.Generic.LinkedListNode<T> node, System.Collections.Generic.LinkedListNode<T> newNode) => throw null;
                public System.Collections.Generic.LinkedListNode<T> AddAfter(System.Collections.Generic.LinkedListNode<T> node, T value) => throw null;
                public void AddBefore(System.Collections.Generic.LinkedListNode<T> node, System.Collections.Generic.LinkedListNode<T> newNode) => throw null;
                public System.Collections.Generic.LinkedListNode<T> AddBefore(System.Collections.Generic.LinkedListNode<T> node, T value) => throw null;
                public void AddFirst(System.Collections.Generic.LinkedListNode<T> node) => throw null;
                public System.Collections.Generic.LinkedListNode<T> AddFirst(T value) => throw null;
                public void AddLast(System.Collections.Generic.LinkedListNode<T> node) => throw null;
                public System.Collections.Generic.LinkedListNode<T> AddLast(T value) => throw null;
                public void Clear() => throw null;
                public bool Contains(T value) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public LinkedList() => throw null;
                public LinkedList(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                protected LinkedList(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public struct Enumerator : System.Runtime.Serialization.IDeserializationCallback, System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator, System.Runtime.Serialization.ISerializable
                {
                    public T Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public bool MoveNext() => throw null;
                    void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Collections.Generic.LinkedListNode<T> Find(T value) => throw null;
                public System.Collections.Generic.LinkedListNode<T> FindLast(T value) => throw null;
                public System.Collections.Generic.LinkedListNode<T> First { get => throw null; }
                public System.Collections.Generic.LinkedList<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public System.Collections.Generic.LinkedListNode<T> Last { get => throw null; }
                public virtual void OnDeserialization(object sender) => throw null;
                public void Remove(System.Collections.Generic.LinkedListNode<T> node) => throw null;
                public bool Remove(T value) => throw null;
                public void RemoveFirst() => throw null;
                public void RemoveLast() => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }
            public sealed class LinkedListNode<T>
            {
                public LinkedListNode(T value) => throw null;
                public System.Collections.Generic.LinkedList<T> List { get => throw null; }
                public System.Collections.Generic.LinkedListNode<T> Next { get => throw null; }
                public System.Collections.Generic.LinkedListNode<T> Previous { get => throw null; }
                public T Value { get => throw null; set { } }
                public T ValueRef { get => throw null; }
            }
            public class List<T> : System.Collections.Generic.ICollection<T>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IList<T>, System.Collections.IList, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T>
            {
                public void Add(T item) => throw null;
                int System.Collections.IList.Add(object item) => throw null;
                public void AddRange(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public System.Collections.ObjectModel.ReadOnlyCollection<T> AsReadOnly() => throw null;
                public int BinarySearch(int index, int count, T item, System.Collections.Generic.IComparer<T> comparer) => throw null;
                public int BinarySearch(T item) => throw null;
                public int BinarySearch(T item, System.Collections.Generic.IComparer<T> comparer) => throw null;
                public int Capacity { get => throw null; set { } }
                public void Clear() => throw null;
                public bool Contains(T item) => throw null;
                bool System.Collections.IList.Contains(object item) => throw null;
                public System.Collections.Generic.List<TOutput> ConvertAll<TOutput>(System.Converter<T, TOutput> converter) => throw null;
                public void CopyTo(int index, T[] array, int arrayIndex, int count) => throw null;
                public void CopyTo(T[] array) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public List() => throw null;
                public List(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public List(int capacity) => throw null;
                public int EnsureCapacity(int capacity) => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                {
                    public T Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public bool Exists(System.Predicate<T> match) => throw null;
                public T Find(System.Predicate<T> match) => throw null;
                public System.Collections.Generic.List<T> FindAll(System.Predicate<T> match) => throw null;
                public int FindIndex(int startIndex, int count, System.Predicate<T> match) => throw null;
                public int FindIndex(int startIndex, System.Predicate<T> match) => throw null;
                public int FindIndex(System.Predicate<T> match) => throw null;
                public T FindLast(System.Predicate<T> match) => throw null;
                public int FindLastIndex(int startIndex, int count, System.Predicate<T> match) => throw null;
                public int FindLastIndex(int startIndex, System.Predicate<T> match) => throw null;
                public int FindLastIndex(System.Predicate<T> match) => throw null;
                public void ForEach(System.Action<T> action) => throw null;
                public System.Collections.Generic.List<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Collections.Generic.List<T> GetRange(int index, int count) => throw null;
                public int IndexOf(T item) => throw null;
                public int IndexOf(T item, int index) => throw null;
                public int IndexOf(T item, int index, int count) => throw null;
                int System.Collections.IList.IndexOf(object item) => throw null;
                public void Insert(int index, T item) => throw null;
                void System.Collections.IList.Insert(int index, object item) => throw null;
                public void InsertRange(int index, System.Collections.Generic.IEnumerable<T> collection) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                public int LastIndexOf(T item) => throw null;
                public int LastIndexOf(T item, int index) => throw null;
                public int LastIndexOf(T item, int index, int count) => throw null;
                public bool Remove(T item) => throw null;
                void System.Collections.IList.Remove(object item) => throw null;
                public int RemoveAll(System.Predicate<T> match) => throw null;
                public void RemoveAt(int index) => throw null;
                public void RemoveRange(int index, int count) => throw null;
                public void Reverse() => throw null;
                public void Reverse(int index, int count) => throw null;
                public System.Collections.Generic.List<T> Slice(int start, int length) => throw null;
                public void Sort() => throw null;
                public void Sort(System.Collections.Generic.IComparer<T> comparer) => throw null;
                public void Sort(System.Comparison<T> comparison) => throw null;
                public void Sort(int index, int count, System.Collections.Generic.IComparer<T> comparer) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T this[int index] { get => throw null; set { } }
                public T[] ToArray() => throw null;
                public void TrimExcess() => throw null;
                public bool TrueForAll(System.Predicate<T> match) => throw null;
            }
            public class PriorityQueue<TElement, TPriority>
            {
                public void Clear() => throw null;
                public System.Collections.Generic.IComparer<TPriority> Comparer { get => throw null; }
                public int Count { get => throw null; }
                public PriorityQueue() => throw null;
                public PriorityQueue(System.Collections.Generic.IComparer<TPriority> comparer) => throw null;
                public PriorityQueue(System.Collections.Generic.IEnumerable<(TElement Element, TPriority Priority)> items) => throw null;
                public PriorityQueue(System.Collections.Generic.IEnumerable<(TElement Element, TPriority Priority)> items, System.Collections.Generic.IComparer<TPriority> comparer) => throw null;
                public PriorityQueue(int initialCapacity) => throw null;
                public PriorityQueue(int initialCapacity, System.Collections.Generic.IComparer<TPriority> comparer) => throw null;
                public TElement Dequeue() => throw null;
                public TElement DequeueEnqueue(TElement element, TPriority priority) => throw null;
                public void Enqueue(TElement element, TPriority priority) => throw null;
                public TElement EnqueueDequeue(TElement element, TPriority priority) => throw null;
                public void EnqueueRange(System.Collections.Generic.IEnumerable<(TElement Element, TPriority Priority)> items) => throw null;
                public void EnqueueRange(System.Collections.Generic.IEnumerable<TElement> elements, TPriority priority) => throw null;
                public int EnsureCapacity(int capacity) => throw null;
                public TElement Peek() => throw null;
                public void TrimExcess() => throw null;
                public bool TryDequeue(out TElement element, out TPriority priority) => throw null;
                public bool TryPeek(out TElement element, out TPriority priority) => throw null;
                public System.Collections.Generic.PriorityQueue<TElement, TPriority>.UnorderedItemsCollection UnorderedItems { get => throw null; }
                public sealed class UnorderedItemsCollection : System.Collections.ICollection, System.Collections.Generic.IEnumerable<(TElement Element, TPriority Priority)>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<(TElement Element, TPriority Priority)>
                {
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<(TElement Element, TPriority Priority)>, System.Collections.IEnumerator
                    {
                        (TElement Element, TPriority Priority) System.Collections.Generic.IEnumerator<(TElement Element, TPriority Priority)>.Current { get => throw null; }
                        public (TElement Element, TPriority Priority) Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                    public System.Collections.Generic.PriorityQueue<TElement, TPriority>.UnorderedItemsCollection.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<(TElement Element, TPriority Priority)> System.Collections.Generic.IEnumerable<(TElement Element, TPriority Priority)>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }
            }
            public class Queue<T> : System.Collections.ICollection, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<T>
            {
                public void Clear() => throw null;
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public Queue() => throw null;
                public Queue(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public Queue(int capacity) => throw null;
                public T Dequeue() => throw null;
                public void Enqueue(T item) => throw null;
                public int EnsureCapacity(int capacity) => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                {
                    public T Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Collections.Generic.Queue<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public T Peek() => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T[] ToArray() => throw null;
                public void TrimExcess() => throw null;
                public bool TryDequeue(out T result) => throw null;
                public bool TryPeek(out T result) => throw null;
            }
            public sealed class ReferenceEqualityComparer : System.Collections.Generic.IEqualityComparer<object>, System.Collections.IEqualityComparer
            {
                public bool Equals(object x, object y) => throw null;
                public int GetHashCode(object obj) => throw null;
                public static System.Collections.Generic.ReferenceEqualityComparer Instance { get => throw null; }
            }
            public class SortedDictionary<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.ICollection, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.IDictionary, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>
            {
                public void Add(TKey key, TValue value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Add(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.IDictionary.Add(object key, object value) => throw null;
                public void Clear() => throw null;
                public System.Collections.Generic.IComparer<TKey> Comparer { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Contains(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                bool System.Collections.IDictionary.Contains(object key) => throw null;
                public bool ContainsKey(TKey key) => throw null;
                public bool ContainsValue(TValue value) => throw null;
                public void CopyTo(System.Collections.Generic.KeyValuePair<TKey, TValue>[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public SortedDictionary() => throw null;
                public SortedDictionary(System.Collections.Generic.IComparer<TKey> comparer) => throw null;
                public SortedDictionary(System.Collections.Generic.IDictionary<TKey, TValue> dictionary) => throw null;
                public SortedDictionary(System.Collections.Generic.IDictionary<TKey, TValue> dictionary, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
                public struct Enumerator : System.Collections.IDictionaryEnumerator, System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerator
                {
                    public System.Collections.Generic.KeyValuePair<TKey, TValue> Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    System.Collections.DictionaryEntry System.Collections.IDictionaryEnumerator.Entry { get => throw null; }
                    object System.Collections.IDictionaryEnumerator.Key { get => throw null; }
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                    object System.Collections.IDictionaryEnumerator.Value { get => throw null; }
                }
                public System.Collections.Generic.SortedDictionary<TKey, TValue>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>.GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.IsReadOnly { get => throw null; }
                bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IDictionary.this[object key] { get => throw null; set { } }
                public sealed class KeyCollection : System.Collections.Generic.ICollection<TKey>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<TKey>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<TKey>
                {
                    void System.Collections.Generic.ICollection<TKey>.Add(TKey item) => throw null;
                    void System.Collections.Generic.ICollection<TKey>.Clear() => throw null;
                    public bool Contains(TKey item) => throw null;
                    public void CopyTo(TKey[] array, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public KeyCollection(System.Collections.Generic.SortedDictionary<TKey, TValue> dictionary) => throw null;
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<TKey>, System.Collections.IEnumerator
                    {
                        public TKey Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                    public System.Collections.Generic.SortedDictionary<TKey, TValue>.KeyCollection.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<TKey> System.Collections.Generic.IEnumerable<TKey>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<TKey>.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    bool System.Collections.Generic.ICollection<TKey>.Remove(TKey item) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }
                public System.Collections.Generic.SortedDictionary<TKey, TValue>.KeyCollection Keys { get => throw null; }
                System.Collections.Generic.ICollection<TKey> System.Collections.Generic.IDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<TKey> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
                public bool Remove(TKey key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Remove(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.IDictionary.Remove(object key) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public TValue this[TKey key] { get => throw null; set { } }
                public bool TryGetValue(TKey key, out TValue value) => throw null;
                public sealed class ValueCollection : System.Collections.Generic.ICollection<TValue>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<TValue>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<TValue>
                {
                    void System.Collections.Generic.ICollection<TValue>.Add(TValue item) => throw null;
                    void System.Collections.Generic.ICollection<TValue>.Clear() => throw null;
                    bool System.Collections.Generic.ICollection<TValue>.Contains(TValue item) => throw null;
                    public void CopyTo(TValue[] array, int index) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public ValueCollection(System.Collections.Generic.SortedDictionary<TKey, TValue> dictionary) => throw null;
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<TValue>, System.Collections.IEnumerator
                    {
                        public TValue Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                    public System.Collections.Generic.SortedDictionary<TKey, TValue>.ValueCollection.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<TValue> System.Collections.Generic.IEnumerable<TValue>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<TValue>.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    bool System.Collections.Generic.ICollection<TValue>.Remove(TValue item) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }
                System.Collections.Generic.ICollection<TValue> System.Collections.Generic.IDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.Generic.IEnumerable<TValue> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
                public System.Collections.Generic.SortedDictionary<TKey, TValue>.ValueCollection Values { get => throw null; }
            }
            public class SortedList<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.ICollection, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.IDictionary, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>
            {
                public void Add(TKey key, TValue value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Add(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.IDictionary.Add(object key, object value) => throw null;
                public int Capacity { get => throw null; set { } }
                public void Clear() => throw null;
                public System.Collections.Generic.IComparer<TKey> Comparer { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Contains(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                bool System.Collections.IDictionary.Contains(object key) => throw null;
                public bool ContainsKey(TKey key) => throw null;
                public bool ContainsValue(TValue value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.CopyTo(System.Collections.Generic.KeyValuePair<TKey, TValue>[] array, int arrayIndex) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public SortedList() => throw null;
                public SortedList(System.Collections.Generic.IComparer<TKey> comparer) => throw null;
                public SortedList(System.Collections.Generic.IDictionary<TKey, TValue> dictionary) => throw null;
                public SortedList(System.Collections.Generic.IDictionary<TKey, TValue> dictionary, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
                public SortedList(int capacity) => throw null;
                public SortedList(int capacity, System.Collections.Generic.IComparer<TKey> comparer) => throw null;
                public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>.GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public TKey GetKeyAtIndex(int index) => throw null;
                public TValue GetValueAtIndex(int index) => throw null;
                public int IndexOfKey(TKey key) => throw null;
                public int IndexOfValue(TValue value) => throw null;
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.IsReadOnly { get => throw null; }
                bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IDictionary.this[object key] { get => throw null; set { } }
                public System.Collections.Generic.IList<TKey> Keys { get => throw null; }
                System.Collections.Generic.ICollection<TKey> System.Collections.Generic.IDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<TKey> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
                public bool Remove(TKey key) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Remove(System.Collections.Generic.KeyValuePair<TKey, TValue> keyValuePair) => throw null;
                void System.Collections.IDictionary.Remove(object key) => throw null;
                public void RemoveAt(int index) => throw null;
                public void SetValueAtIndex(int index, TValue value) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public TValue this[TKey key] { get => throw null; set { } }
                public void TrimExcess() => throw null;
                public bool TryGetValue(TKey key, out TValue value) => throw null;
                System.Collections.Generic.ICollection<TValue> System.Collections.Generic.IDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.Generic.IEnumerable<TValue> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
                public System.Collections.Generic.IList<TValue> Values { get => throw null; }
            }
            public class SortedSet<T> : System.Collections.Generic.ICollection<T>, System.Collections.ICollection, System.Runtime.Serialization.IDeserializationCallback, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlySet<T>, System.Runtime.Serialization.ISerializable, System.Collections.Generic.ISet<T>
            {
                public bool Add(T item) => throw null;
                void System.Collections.Generic.ICollection<T>.Add(T item) => throw null;
                public virtual void Clear() => throw null;
                public System.Collections.Generic.IComparer<T> Comparer { get => throw null; }
                public virtual bool Contains(T item) => throw null;
                public void CopyTo(T[] array) => throw null;
                public void CopyTo(T[] array, int index) => throw null;
                public void CopyTo(T[] array, int index, int count) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public static System.Collections.Generic.IEqualityComparer<System.Collections.Generic.SortedSet<T>> CreateSetComparer() => throw null;
                public static System.Collections.Generic.IEqualityComparer<System.Collections.Generic.SortedSet<T>> CreateSetComparer(System.Collections.Generic.IEqualityComparer<T> memberEqualityComparer) => throw null;
                public SortedSet() => throw null;
                public SortedSet(System.Collections.Generic.IComparer<T> comparer) => throw null;
                public SortedSet(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public SortedSet(System.Collections.Generic.IEnumerable<T> collection, System.Collections.Generic.IComparer<T> comparer) => throw null;
                protected SortedSet(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public struct Enumerator : System.Runtime.Serialization.IDeserializationCallback, System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator, System.Runtime.Serialization.ISerializable
                {
                    public T Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public bool MoveNext() => throw null;
                    void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public void ExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public System.Collections.Generic.SortedSet<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual System.Collections.Generic.SortedSet<T> GetViewBetween(T lowerValue, T upperValue) => throw null;
                public virtual void IntersectWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                public bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public T Max { get => throw null; }
                public T Min { get => throw null; }
                protected virtual void OnDeserialization(object sender) => throw null;
                void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                public bool Overlaps(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Remove(T item) => throw null;
                public int RemoveWhere(System.Predicate<T> match) => throw null;
                public System.Collections.Generic.IEnumerable<T> Reverse() => throw null;
                public bool SetEquals(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void SymmetricExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public bool TryGetValue(T equalValue, out T actualValue) => throw null;
                public void UnionWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
            }
            public class Stack<T> : System.Collections.ICollection, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<T>
            {
                public void Clear() => throw null;
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public Stack() => throw null;
                public Stack(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public Stack(int capacity) => throw null;
                public int EnsureCapacity(int capacity) => throw null;
                public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                {
                    public T Current { get => throw null; }
                    object System.Collections.IEnumerator.Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    void System.Collections.IEnumerator.Reset() => throw null;
                }
                public System.Collections.Generic.Stack<T>.Enumerator GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public T Peek() => throw null;
                public T Pop() => throw null;
                public void Push(T item) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public T[] ToArray() => throw null;
                public void TrimExcess() => throw null;
                public bool TryPeek(out T result) => throw null;
                public bool TryPop(out T result) => throw null;
            }
        }
        public static class StructuralComparisons
        {
            public static System.Collections.IComparer StructuralComparer { get => throw null; }
            public static System.Collections.IEqualityComparer StructuralEqualityComparer { get => throw null; }
        }
    }
}
