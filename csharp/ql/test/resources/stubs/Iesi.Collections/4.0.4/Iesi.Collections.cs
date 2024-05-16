// This file contains auto-generated code.
// Generated from `Iesi.Collections, Version=4.0.0.4000, Culture=neutral, PublicKeyToken=aa95f207798dfdb4`.
namespace Iesi
{
    namespace Collections
    {
        namespace Generic
        {
            public class LinkedHashSet<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.ISet<T>
            {
                void System.Collections.Generic.ICollection<T>.Add(T item) => throw null;
                public bool Add(T item) => throw null;
                public void Clear() => throw null;
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public LinkedHashSet() => throw null;
                public LinkedHashSet(System.Collections.Generic.IEnumerable<T> initialValues) => throw null;
                public void ExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public void IntersectWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                bool System.Collections.Generic.ICollection<T>.IsReadOnly { get => throw null; }
                public bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Overlaps(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Remove(T item) => throw null;
                public bool SetEquals(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void SymmetricExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void UnionWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
            }
            public sealed class ReadOnlySet<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.ISet<T>
            {
                void System.Collections.Generic.ICollection<T>.Add(T item) => throw null;
                bool System.Collections.Generic.ISet<T>.Add(T item) => throw null;
                void System.Collections.Generic.ICollection<T>.Clear() => throw null;
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public ReadOnlySet(System.Collections.Generic.ISet<T> basisSet) => throw null;
                void System.Collections.Generic.ISet<T>.ExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                void System.Collections.Generic.ISet<T>.IntersectWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsReadOnly { get => throw null; }
                public bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Overlaps(System.Collections.Generic.IEnumerable<T> other) => throw null;
                bool System.Collections.Generic.ICollection<T>.Remove(T item) => throw null;
                public bool SetEquals(System.Collections.Generic.IEnumerable<T> other) => throw null;
                void System.Collections.Generic.ISet<T>.SymmetricExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                void System.Collections.Generic.ISet<T>.UnionWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
            }
            public sealed class SynchronizedSet<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Collections.Generic.ISet<T>
            {
                void System.Collections.Generic.ICollection<T>.Add(T item) => throw null;
                public bool Add(T item) => throw null;
                public void Clear() => throw null;
                public bool Contains(T item) => throw null;
                public void CopyTo(T[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public SynchronizedSet(System.Collections.Generic.ISet<T> basisSet) => throw null;
                public void ExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                public void IntersectWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsProperSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsReadOnly { get => throw null; }
                public bool IsSubsetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool IsSupersetOf(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Overlaps(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public bool Remove(T item) => throw null;
                public bool SetEquals(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void SymmetricExceptWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
                public void UnionWith(System.Collections.Generic.IEnumerable<T> other) => throw null;
            }
        }
    }
}
