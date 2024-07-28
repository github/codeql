// This file contains auto-generated code.
// Generated from `System.Collections.Specialized, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Collections
    {
        namespace Specialized
        {
            public struct BitVector32 : System.IEquatable<System.Collections.Specialized.BitVector32>
            {
                public static int CreateMask() => throw null;
                public static int CreateMask(int previous) => throw null;
                public static System.Collections.Specialized.BitVector32.Section CreateSection(short maxValue) => throw null;
                public static System.Collections.Specialized.BitVector32.Section CreateSection(short maxValue, System.Collections.Specialized.BitVector32.Section previous) => throw null;
                public BitVector32(System.Collections.Specialized.BitVector32 value) => throw null;
                public BitVector32(int data) => throw null;
                public int Data { get => throw null; }
                public bool Equals(System.Collections.Specialized.BitVector32 other) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public struct Section : System.IEquatable<System.Collections.Specialized.BitVector32.Section>
                {
                    public bool Equals(System.Collections.Specialized.BitVector32.Section obj) => throw null;
                    public override bool Equals(object o) => throw null;
                    public override int GetHashCode() => throw null;
                    public short Mask { get => throw null; }
                    public short Offset { get => throw null; }
                    public static bool operator ==(System.Collections.Specialized.BitVector32.Section a, System.Collections.Specialized.BitVector32.Section b) => throw null;
                    public static bool operator !=(System.Collections.Specialized.BitVector32.Section a, System.Collections.Specialized.BitVector32.Section b) => throw null;
                    public override string ToString() => throw null;
                    public static string ToString(System.Collections.Specialized.BitVector32.Section value) => throw null;
                }
                public int this[System.Collections.Specialized.BitVector32.Section section] { get => throw null; set { } }
                public bool this[int bit] { get => throw null; set { } }
                public override string ToString() => throw null;
                public static string ToString(System.Collections.Specialized.BitVector32 value) => throw null;
            }
            public class HybridDictionary : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
            {
                public void Add(object key, object value) => throw null;
                public void Clear() => throw null;
                public bool Contains(object key) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public HybridDictionary() => throw null;
                public HybridDictionary(bool caseInsensitive) => throw null;
                public HybridDictionary(int initialSize) => throw null;
                public HybridDictionary(int initialSize, bool caseInsensitive) => throw null;
                public System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                public System.Collections.ICollection Keys { get => throw null; }
                public void Remove(object key) => throw null;
                public object SyncRoot { get => throw null; }
                public object this[object key] { get => throw null; set { } }
                public System.Collections.ICollection Values { get => throw null; }
            }
            public interface IOrderedDictionary : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
            {
                System.Collections.IDictionaryEnumerator GetEnumerator();
                void Insert(int index, object key, object value);
                void RemoveAt(int index);
                object this[int index] { get; set; }
            }
            public class ListDictionary : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
            {
                public void Add(object key, object value) => throw null;
                public void Clear() => throw null;
                public bool Contains(object key) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public ListDictionary() => throw null;
                public ListDictionary(System.Collections.IComparer comparer) => throw null;
                public System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                public System.Collections.ICollection Keys { get => throw null; }
                public void Remove(object key) => throw null;
                public object SyncRoot { get => throw null; }
                public object this[object key] { get => throw null; set { } }
                public System.Collections.ICollection Values { get => throw null; }
            }
            public abstract class NameObjectCollectionBase : System.Collections.ICollection, System.Runtime.Serialization.IDeserializationCallback, System.Collections.IEnumerable, System.Runtime.Serialization.ISerializable
            {
                protected void BaseAdd(string name, object value) => throw null;
                protected void BaseClear() => throw null;
                protected object BaseGet(int index) => throw null;
                protected object BaseGet(string name) => throw null;
                protected string[] BaseGetAllKeys() => throw null;
                protected object[] BaseGetAllValues() => throw null;
                protected object[] BaseGetAllValues(System.Type type) => throw null;
                protected string BaseGetKey(int index) => throw null;
                protected bool BaseHasKeys() => throw null;
                protected void BaseRemove(string name) => throw null;
                protected void BaseRemoveAt(int index) => throw null;
                protected void BaseSet(int index, object value) => throw null;
                protected void BaseSet(string name, object value) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public virtual int Count { get => throw null; }
                protected NameObjectCollectionBase() => throw null;
                protected NameObjectCollectionBase(System.Collections.IEqualityComparer equalityComparer) => throw null;
                protected NameObjectCollectionBase(System.Collections.IHashCodeProvider hashProvider, System.Collections.IComparer comparer) => throw null;
                protected NameObjectCollectionBase(int capacity) => throw null;
                protected NameObjectCollectionBase(int capacity, System.Collections.IEqualityComparer equalityComparer) => throw null;
                protected NameObjectCollectionBase(int capacity, System.Collections.IHashCodeProvider hashProvider, System.Collections.IComparer comparer) => throw null;
                protected NameObjectCollectionBase(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
                public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                protected bool IsReadOnly { get => throw null; set { } }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public virtual System.Collections.Specialized.NameObjectCollectionBase.KeysCollection Keys { get => throw null; }
                public class KeysCollection : System.Collections.ICollection, System.Collections.IEnumerable
                {
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public virtual string Get(int index) => throw null;
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                    public string this[int index] { get => throw null; }
                }
                public virtual void OnDeserialization(object sender) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }
            public class NameValueCollection : System.Collections.Specialized.NameObjectCollectionBase
            {
                public void Add(System.Collections.Specialized.NameValueCollection c) => throw null;
                public virtual void Add(string name, string value) => throw null;
                public virtual string[] AllKeys { get => throw null; }
                public virtual void Clear() => throw null;
                public void CopyTo(System.Array dest, int index) => throw null;
                public NameValueCollection() => throw null;
                public NameValueCollection(System.Collections.IEqualityComparer equalityComparer) => throw null;
                public NameValueCollection(System.Collections.IHashCodeProvider hashProvider, System.Collections.IComparer comparer) => throw null;
                public NameValueCollection(System.Collections.Specialized.NameValueCollection col) => throw null;
                public NameValueCollection(int capacity) => throw null;
                public NameValueCollection(int capacity, System.Collections.IEqualityComparer equalityComparer) => throw null;
                public NameValueCollection(int capacity, System.Collections.IHashCodeProvider hashProvider, System.Collections.IComparer comparer) => throw null;
                public NameValueCollection(int capacity, System.Collections.Specialized.NameValueCollection col) => throw null;
                protected NameValueCollection(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual string Get(int index) => throw null;
                public virtual string Get(string name) => throw null;
                public virtual string GetKey(int index) => throw null;
                public virtual string[] GetValues(int index) => throw null;
                public virtual string[] GetValues(string name) => throw null;
                public bool HasKeys() => throw null;
                protected void InvalidateCachedArrays() => throw null;
                public virtual void Remove(string name) => throw null;
                public virtual void Set(string name, string value) => throw null;
                public string this[int index] { get => throw null; }
                public string this[string name] { get => throw null; set { } }
            }
            public class OrderedDictionary : System.Collections.ICollection, System.Runtime.Serialization.IDeserializationCallback, System.Collections.IDictionary, System.Collections.IEnumerable, System.Collections.Specialized.IOrderedDictionary, System.Runtime.Serialization.ISerializable
            {
                public void Add(object key, object value) => throw null;
                public System.Collections.Specialized.OrderedDictionary AsReadOnly() => throw null;
                public void Clear() => throw null;
                public bool Contains(object key) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public OrderedDictionary() => throw null;
                public OrderedDictionary(System.Collections.IEqualityComparer comparer) => throw null;
                public OrderedDictionary(int capacity) => throw null;
                public OrderedDictionary(int capacity, System.Collections.IEqualityComparer comparer) => throw null;
                protected OrderedDictionary(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public void Insert(int index, object key, object value) => throw null;
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public System.Collections.ICollection Keys { get => throw null; }
                protected virtual void OnDeserialization(object sender) => throw null;
                void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                public void Remove(object key) => throw null;
                public void RemoveAt(int index) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public object this[int index] { get => throw null; set { } }
                public object this[object key] { get => throw null; set { } }
                public System.Collections.ICollection Values { get => throw null; }
            }
            public class StringCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
            {
                public int Add(string value) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                public void AddRange(string[] value) => throw null;
                public void Clear() => throw null;
                public bool Contains(string value) => throw null;
                bool System.Collections.IList.Contains(object value) => throw null;
                public void CopyTo(string[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public StringCollection() => throw null;
                public System.Collections.Specialized.StringEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(string value) => throw null;
                int System.Collections.IList.IndexOf(object value) => throw null;
                public void Insert(int index, string value) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                public bool IsReadOnly { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set { } }
                public void Remove(string value) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                public void RemoveAt(int index) => throw null;
                public object SyncRoot { get => throw null; }
                public string this[int index] { get => throw null; set { } }
            }
            public class StringDictionary : System.Collections.IEnumerable
            {
                public virtual void Add(string key, string value) => throw null;
                public virtual void Clear() => throw null;
                public virtual bool ContainsKey(string key) => throw null;
                public virtual bool ContainsValue(string value) => throw null;
                public virtual void CopyTo(System.Array array, int index) => throw null;
                public virtual int Count { get => throw null; }
                public StringDictionary() => throw null;
                public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
                public virtual bool IsSynchronized { get => throw null; }
                public virtual System.Collections.ICollection Keys { get => throw null; }
                public virtual void Remove(string key) => throw null;
                public virtual object SyncRoot { get => throw null; }
                public virtual string this[string key] { get => throw null; set { } }
                public virtual System.Collections.ICollection Values { get => throw null; }
            }
            public class StringEnumerator
            {
                public string Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
        }
    }
}
