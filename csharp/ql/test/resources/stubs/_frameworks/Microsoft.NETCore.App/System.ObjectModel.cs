// This file contains auto-generated code.

namespace System
{
    namespace Collections
    {
        namespace ObjectModel
        {
            // Generated from `System.Collections.ObjectModel.KeyedCollection<,>` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class KeyedCollection<TKey, TItem> : System.Collections.ObjectModel.Collection<TItem>
            {
                protected void ChangeItemKey(TItem item, TKey newKey) => throw null;
                protected override void ClearItems() => throw null;
                public System.Collections.Generic.IEqualityComparer<TKey> Comparer { get => throw null; }
                public bool Contains(TKey key) => throw null;
                protected System.Collections.Generic.IDictionary<TKey, TItem> Dictionary { get => throw null; }
                protected abstract TKey GetKeyForItem(TItem item);
                protected override void InsertItem(int index, TItem item) => throw null;
                public TItem this[TKey key] { get => throw null; }
                protected KeyedCollection() => throw null;
                protected KeyedCollection(System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                protected KeyedCollection(System.Collections.Generic.IEqualityComparer<TKey> comparer, int dictionaryCreationThreshold) => throw null;
                public bool Remove(TKey key) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, TItem item) => throw null;
                public bool TryGetValue(TKey key, out TItem item) => throw null;
            }

            // Generated from `System.Collections.ObjectModel.ObservableCollection<>` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ObservableCollection<T> : System.Collections.ObjectModel.Collection<T>, System.Collections.Specialized.INotifyCollectionChanged, System.ComponentModel.INotifyPropertyChanged
            {
                protected System.IDisposable BlockReentrancy() => throw null;
                protected void CheckReentrancy() => throw null;
                protected override void ClearItems() => throw null;
                public virtual event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
                protected override void InsertItem(int index, T item) => throw null;
                public void Move(int oldIndex, int newIndex) => throw null;
                protected virtual void MoveItem(int oldIndex, int newIndex) => throw null;
                public ObservableCollection() => throw null;
                public ObservableCollection(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public ObservableCollection(System.Collections.Generic.List<T> list) => throw null;
                protected virtual void OnCollectionChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e) => throw null;
                protected virtual void OnPropertyChanged(System.ComponentModel.PropertyChangedEventArgs e) => throw null;
                protected virtual event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
                event System.ComponentModel.PropertyChangedEventHandler System.ComponentModel.INotifyPropertyChanged.PropertyChanged { add => throw null; remove => throw null; }
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, T item) => throw null;
            }

            // Generated from `System.Collections.ObjectModel.ReadOnlyDictionary<,>` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ReadOnlyDictionary<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>, System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable
            {
                // Generated from `System.Collections.ObjectModel.ReadOnlyDictionary<,>+KeyCollection` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class KeyCollection : System.Collections.Generic.ICollection<TKey>, System.Collections.Generic.IEnumerable<TKey>, System.Collections.Generic.IReadOnlyCollection<TKey>, System.Collections.ICollection, System.Collections.IEnumerable
                {
                    void System.Collections.Generic.ICollection<TKey>.Add(TKey item) => throw null;
                    void System.Collections.Generic.ICollection<TKey>.Clear() => throw null;
                    bool System.Collections.Generic.ICollection<TKey>.Contains(TKey item) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(TKey[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.Generic.IEnumerator<TKey> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<TKey>.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    bool System.Collections.Generic.ICollection<TKey>.Remove(TKey item) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                // Generated from `System.Collections.ObjectModel.ReadOnlyDictionary<,>+ValueCollection` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ValueCollection : System.Collections.Generic.ICollection<TValue>, System.Collections.Generic.IEnumerable<TValue>, System.Collections.Generic.IReadOnlyCollection<TValue>, System.Collections.ICollection, System.Collections.IEnumerable
                {
                    void System.Collections.Generic.ICollection<TValue>.Add(TValue item) => throw null;
                    void System.Collections.Generic.ICollection<TValue>.Clear() => throw null;
                    bool System.Collections.Generic.ICollection<TValue>.Contains(TValue item) => throw null;
                    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                    public void CopyTo(TValue[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.Generic.IEnumerator<TValue> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<TValue>.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    bool System.Collections.Generic.ICollection<TValue>.Remove(TValue item) => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Add(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                void System.Collections.Generic.IDictionary<TKey, TValue>.Add(TKey key, TValue value) => throw null;
                void System.Collections.IDictionary.Add(object key, object value) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Clear() => throw null;
                void System.Collections.IDictionary.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Contains(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                bool System.Collections.IDictionary.Contains(object key) => throw null;
                public bool ContainsKey(TKey key) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.CopyTo(System.Collections.Generic.KeyValuePair<TKey, TValue>[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                protected System.Collections.Generic.IDictionary<TKey, TValue> Dictionary { get => throw null; }
                public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey, TValue>> GetEnumerator() => throw null;
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.IsReadOnly { get => throw null; }
                bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public TValue this[TKey key] { get => throw null; }
                TValue System.Collections.Generic.IDictionary<TKey, TValue>.this[TKey key] { get => throw null; set => throw null; }
                object System.Collections.IDictionary.this[object key] { get => throw null; set => throw null; }
                public System.Collections.ObjectModel.ReadOnlyDictionary<TKey, TValue>.KeyCollection Keys { get => throw null; }
                System.Collections.Generic.ICollection<TKey> System.Collections.Generic.IDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.Generic.IEnumerable<TKey> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Keys { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
                public ReadOnlyDictionary(System.Collections.Generic.IDictionary<TKey, TValue> dictionary) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>.Remove(System.Collections.Generic.KeyValuePair<TKey, TValue> item) => throw null;
                bool System.Collections.Generic.IDictionary<TKey, TValue>.Remove(TKey key) => throw null;
                void System.Collections.IDictionary.Remove(object key) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public bool TryGetValue(TKey key, out TValue value) => throw null;
                public System.Collections.ObjectModel.ReadOnlyDictionary<TKey, TValue>.ValueCollection Values { get => throw null; }
                System.Collections.Generic.ICollection<TValue> System.Collections.Generic.IDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.Generic.IEnumerable<TValue> System.Collections.Generic.IReadOnlyDictionary<TKey, TValue>.Values { get => throw null; }
                System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
            }

            // Generated from `System.Collections.ObjectModel.ReadOnlyObservableCollection<>` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ReadOnlyObservableCollection<T> : System.Collections.ObjectModel.ReadOnlyCollection<T>, System.Collections.Specialized.INotifyCollectionChanged, System.ComponentModel.INotifyPropertyChanged
            {
                protected virtual event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
                event System.Collections.Specialized.NotifyCollectionChangedEventHandler System.Collections.Specialized.INotifyCollectionChanged.CollectionChanged { add => throw null; remove => throw null; }
                protected virtual void OnCollectionChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs args) => throw null;
                protected virtual void OnPropertyChanged(System.ComponentModel.PropertyChangedEventArgs args) => throw null;
                protected virtual event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
                event System.ComponentModel.PropertyChangedEventHandler System.ComponentModel.INotifyPropertyChanged.PropertyChanged { add => throw null; remove => throw null; }
                public ReadOnlyObservableCollection(System.Collections.ObjectModel.ObservableCollection<T> list) : base(default(System.Collections.Generic.IList<T>)) => throw null;
            }

        }
        namespace Specialized
        {
            // Generated from `System.Collections.Specialized.INotifyCollectionChanged` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface INotifyCollectionChanged
            {
                event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
            }

            // Generated from `System.Collections.Specialized.NotifyCollectionChangedAction` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum NotifyCollectionChangedAction
            {
                Add,
                Move,
                Remove,
                Replace,
                Reset,
            }

            // Generated from `System.Collections.Specialized.NotifyCollectionChangedEventArgs` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NotifyCollectionChangedEventArgs : System.EventArgs
            {
                public System.Collections.Specialized.NotifyCollectionChangedAction Action { get => throw null; }
                public System.Collections.IList NewItems { get => throw null; }
                public int NewStartingIndex { get => throw null; }
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, System.Collections.IList changedItems) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, System.Collections.IList newItems, System.Collections.IList oldItems) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, System.Collections.IList newItems, System.Collections.IList oldItems, int startingIndex) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, System.Collections.IList changedItems, int startingIndex) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, System.Collections.IList changedItems, int index, int oldIndex) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, object changedItem) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, object changedItem, int index) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, object changedItem, int index, int oldIndex) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, object newItem, object oldItem) => throw null;
                public NotifyCollectionChangedEventArgs(System.Collections.Specialized.NotifyCollectionChangedAction action, object newItem, object oldItem, int index) => throw null;
                public System.Collections.IList OldItems { get => throw null; }
                public int OldStartingIndex { get => throw null; }
            }

            // Generated from `System.Collections.Specialized.NotifyCollectionChangedEventHandler` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void NotifyCollectionChangedEventHandler(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e);

        }
    }
    namespace ComponentModel
    {
        // Generated from `System.ComponentModel.DataErrorsChangedEventArgs` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataErrorsChangedEventArgs : System.EventArgs
        {
            public DataErrorsChangedEventArgs(string propertyName) => throw null;
            public virtual string PropertyName { get => throw null; }
        }

        // Generated from `System.ComponentModel.INotifyDataErrorInfo` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface INotifyDataErrorInfo
        {
            event System.EventHandler<System.ComponentModel.DataErrorsChangedEventArgs> ErrorsChanged;
            System.Collections.IEnumerable GetErrors(string propertyName);
            bool HasErrors { get; }
        }

        // Generated from `System.ComponentModel.INotifyPropertyChanged` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface INotifyPropertyChanged
        {
            event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        }

        // Generated from `System.ComponentModel.INotifyPropertyChanging` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface INotifyPropertyChanging
        {
            event System.ComponentModel.PropertyChangingEventHandler PropertyChanging;
        }

        // Generated from `System.ComponentModel.PropertyChangedEventArgs` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PropertyChangedEventArgs : System.EventArgs
        {
            public PropertyChangedEventArgs(string propertyName) => throw null;
            public virtual string PropertyName { get => throw null; }
        }

        // Generated from `System.ComponentModel.PropertyChangedEventHandler` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void PropertyChangedEventHandler(object sender, System.ComponentModel.PropertyChangedEventArgs e);

        // Generated from `System.ComponentModel.PropertyChangingEventArgs` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PropertyChangingEventArgs : System.EventArgs
        {
            public PropertyChangingEventArgs(string propertyName) => throw null;
            public virtual string PropertyName { get => throw null; }
        }

        // Generated from `System.ComponentModel.PropertyChangingEventHandler` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void PropertyChangingEventHandler(object sender, System.ComponentModel.PropertyChangingEventArgs e);

        // Generated from `System.ComponentModel.TypeConverterAttribute` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TypeConverterAttribute : System.Attribute
        {
            public string ConverterTypeName { get => throw null; }
            public static System.ComponentModel.TypeConverterAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public TypeConverterAttribute() => throw null;
            public TypeConverterAttribute(System.Type type) => throw null;
            public TypeConverterAttribute(string typeName) => throw null;
        }

        // Generated from `System.ComponentModel.TypeDescriptionProviderAttribute` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TypeDescriptionProviderAttribute : System.Attribute
        {
            public TypeDescriptionProviderAttribute(System.Type type) => throw null;
            public TypeDescriptionProviderAttribute(string typeName) => throw null;
            public string TypeName { get => throw null; }
        }

    }
    namespace Reflection
    {
        // Generated from `System.Reflection.ICustomTypeProvider` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICustomTypeProvider
        {
            System.Type GetCustomType();
        }

    }
    namespace Windows
    {
        namespace Input
        {
            // Generated from `System.Windows.Input.ICommand` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ICommand
            {
                bool CanExecute(object parameter);
                event System.EventHandler CanExecuteChanged;
                void Execute(object parameter);
            }

        }
        namespace Markup
        {
            // Generated from `System.Windows.Markup.ValueSerializerAttribute` in `System.ObjectModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ValueSerializerAttribute : System.Attribute
            {
                public ValueSerializerAttribute(System.Type valueSerializerType) => throw null;
                public ValueSerializerAttribute(string valueSerializerTypeName) => throw null;
                public System.Type ValueSerializerType { get => throw null; }
                public string ValueSerializerTypeName { get => throw null; }
            }

        }
    }
}
