// This file contains auto-generated code.
// Generated from `System.Collections.NonGeneric, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Collections
    {
        public class CaseInsensitiveComparer : System.Collections.IComparer
        {
            public int Compare(object a, object b) => throw null;
            public CaseInsensitiveComparer() => throw null;
            public CaseInsensitiveComparer(System.Globalization.CultureInfo culture) => throw null;
            public static System.Collections.CaseInsensitiveComparer Default { get => throw null; }
            public static System.Collections.CaseInsensitiveComparer DefaultInvariant { get => throw null; }
        }
        public class CaseInsensitiveHashCodeProvider : System.Collections.IHashCodeProvider
        {
            public CaseInsensitiveHashCodeProvider() => throw null;
            public CaseInsensitiveHashCodeProvider(System.Globalization.CultureInfo culture) => throw null;
            public static System.Collections.CaseInsensitiveHashCodeProvider Default { get => throw null; }
            public static System.Collections.CaseInsensitiveHashCodeProvider DefaultInvariant { get => throw null; }
            public int GetHashCode(object obj) => throw null;
        }
        public abstract class CollectionBase : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            int System.Collections.IList.Add(object value) => throw null;
            public int Capacity { get => throw null; set { } }
            public void Clear() => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            protected CollectionBase() => throw null;
            protected CollectionBase(int capacity) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            protected System.Collections.ArrayList InnerList { get => throw null; }
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            protected System.Collections.IList List { get => throw null; }
            protected virtual void OnClear() => throw null;
            protected virtual void OnClearComplete() => throw null;
            protected virtual void OnInsert(int index, object value) => throw null;
            protected virtual void OnInsertComplete(int index, object value) => throw null;
            protected virtual void OnRemove(int index, object value) => throw null;
            protected virtual void OnRemoveComplete(int index, object value) => throw null;
            protected virtual void OnSet(int index, object oldValue, object newValue) => throw null;
            protected virtual void OnSetComplete(int index, object oldValue, object newValue) => throw null;
            protected virtual void OnValidate(object value) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            public void RemoveAt(int index) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }
        public abstract class DictionaryBase : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
        {
            void System.Collections.IDictionary.Add(object key, object value) => throw null;
            public void Clear() => throw null;
            bool System.Collections.IDictionary.Contains(object key) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            protected DictionaryBase() => throw null;
            protected System.Collections.IDictionary Dictionary { get => throw null; }
            public System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            protected System.Collections.Hashtable InnerHashtable { get => throw null; }
            bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
            bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IDictionary.this[object key] { get => throw null; set { } }
            System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
            protected virtual void OnClear() => throw null;
            protected virtual void OnClearComplete() => throw null;
            protected virtual object OnGet(object key, object currentValue) => throw null;
            protected virtual void OnInsert(object key, object value) => throw null;
            protected virtual void OnInsertComplete(object key, object value) => throw null;
            protected virtual void OnRemove(object key, object value) => throw null;
            protected virtual void OnRemoveComplete(object key, object value) => throw null;
            protected virtual void OnSet(object key, object oldValue, object newValue) => throw null;
            protected virtual void OnSetComplete(object key, object oldValue, object newValue) => throw null;
            protected virtual void OnValidate(object key, object value) => throw null;
            void System.Collections.IDictionary.Remove(object key) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
        }
        public class Queue : System.ICloneable, System.Collections.ICollection, System.Collections.IEnumerable
        {
            public virtual void Clear() => throw null;
            public virtual object Clone() => throw null;
            public virtual bool Contains(object obj) => throw null;
            public virtual void CopyTo(System.Array array, int index) => throw null;
            public virtual int Count { get => throw null; }
            public Queue() => throw null;
            public Queue(System.Collections.ICollection col) => throw null;
            public Queue(int capacity) => throw null;
            public Queue(int capacity, float growFactor) => throw null;
            public virtual object Dequeue() => throw null;
            public virtual void Enqueue(object obj) => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            public virtual bool IsSynchronized { get => throw null; }
            public virtual object Peek() => throw null;
            public static System.Collections.Queue Synchronized(System.Collections.Queue queue) => throw null;
            public virtual object SyncRoot { get => throw null; }
            public virtual object[] ToArray() => throw null;
            public virtual void TrimToSize() => throw null;
        }
        public abstract class ReadOnlyCollectionBase : System.Collections.ICollection, System.Collections.IEnumerable
        {
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public virtual int Count { get => throw null; }
            protected ReadOnlyCollectionBase() => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            protected System.Collections.ArrayList InnerList { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }
        public class SortedList : System.ICloneable, System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
        {
            public virtual void Add(object key, object value) => throw null;
            public virtual int Capacity { get => throw null; set { } }
            public virtual void Clear() => throw null;
            public virtual object Clone() => throw null;
            public virtual bool Contains(object key) => throw null;
            public virtual bool ContainsKey(object key) => throw null;
            public virtual bool ContainsValue(object value) => throw null;
            public virtual void CopyTo(System.Array array, int arrayIndex) => throw null;
            public virtual int Count { get => throw null; }
            public SortedList() => throw null;
            public SortedList(System.Collections.IComparer comparer) => throw null;
            public SortedList(System.Collections.IComparer comparer, int capacity) => throw null;
            public SortedList(System.Collections.IDictionary d) => throw null;
            public SortedList(System.Collections.IDictionary d, System.Collections.IComparer comparer) => throw null;
            public SortedList(int initialCapacity) => throw null;
            public virtual object GetByIndex(int index) => throw null;
            public virtual System.Collections.IDictionaryEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public virtual object GetKey(int index) => throw null;
            public virtual System.Collections.IList GetKeyList() => throw null;
            public virtual System.Collections.IList GetValueList() => throw null;
            public virtual int IndexOfKey(object key) => throw null;
            public virtual int IndexOfValue(object value) => throw null;
            public virtual bool IsFixedSize { get => throw null; }
            public virtual bool IsReadOnly { get => throw null; }
            public virtual bool IsSynchronized { get => throw null; }
            public virtual System.Collections.ICollection Keys { get => throw null; }
            public virtual void Remove(object key) => throw null;
            public virtual void RemoveAt(int index) => throw null;
            public virtual void SetByIndex(int index, object value) => throw null;
            public static System.Collections.SortedList Synchronized(System.Collections.SortedList list) => throw null;
            public virtual object SyncRoot { get => throw null; }
            public virtual object this[object key] { get => throw null; set { } }
            public virtual void TrimToSize() => throw null;
            public virtual System.Collections.ICollection Values { get => throw null; }
        }
        namespace Specialized
        {
            public class CollectionsUtil
            {
                public static System.Collections.Hashtable CreateCaseInsensitiveHashtable() => throw null;
                public static System.Collections.Hashtable CreateCaseInsensitiveHashtable(System.Collections.IDictionary d) => throw null;
                public static System.Collections.Hashtable CreateCaseInsensitiveHashtable(int capacity) => throw null;
                public static System.Collections.SortedList CreateCaseInsensitiveSortedList() => throw null;
                public CollectionsUtil() => throw null;
            }
        }
        public class Stack : System.ICloneable, System.Collections.ICollection, System.Collections.IEnumerable
        {
            public virtual void Clear() => throw null;
            public virtual object Clone() => throw null;
            public virtual bool Contains(object obj) => throw null;
            public virtual void CopyTo(System.Array array, int index) => throw null;
            public virtual int Count { get => throw null; }
            public Stack() => throw null;
            public Stack(System.Collections.ICollection col) => throw null;
            public Stack(int initialCapacity) => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            public virtual bool IsSynchronized { get => throw null; }
            public virtual object Peek() => throw null;
            public virtual object Pop() => throw null;
            public virtual void Push(object obj) => throw null;
            public static System.Collections.Stack Synchronized(System.Collections.Stack stack) => throw null;
            public virtual object SyncRoot { get => throw null; }
            public virtual object[] ToArray() => throw null;
        }
    }
}
