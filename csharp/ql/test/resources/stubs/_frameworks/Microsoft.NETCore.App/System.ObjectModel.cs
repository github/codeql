// This file contains auto-generated code.
// Generated from `System.ObjectModel, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Collections
    {
        namespace ObjectModel
        {
            public abstract class KeyedCollection<TKey, TItem> : System.Collections.ObjectModel.Collection<TItem>
            {
                protected void ChangeItemKey(TItem item, TKey newKey) => throw null;
                protected override void ClearItems() => throw null;
                public System.Collections.Generic.IEqualityComparer<TKey> Comparer { get => throw null; }
                public bool Contains(TKey key) => throw null;
                protected KeyedCollection() => throw null;
                protected KeyedCollection(System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                protected KeyedCollection(System.Collections.Generic.IEqualityComparer<TKey> comparer, int dictionaryCreationThreshold) => throw null;
                protected System.Collections.Generic.IDictionary<TKey, TItem> Dictionary { get => throw null; }
                protected abstract TKey GetKeyForItem(TItem item);
                protected override void InsertItem(int index, TItem item) => throw null;
                public bool Remove(TKey key) => throw null;
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, TItem item) => throw null;
                public TItem this[TKey key] { get => throw null; }
                public bool TryGetValue(TKey key, out TItem item) => throw null;
            }
            public class ObservableCollection<T> : System.Collections.ObjectModel.Collection<T>, System.Collections.Specialized.INotifyCollectionChanged, System.ComponentModel.INotifyPropertyChanged
            {
                protected System.IDisposable BlockReentrancy() => throw null;
                protected void CheckReentrancy() => throw null;
                protected override void ClearItems() => throw null;
                public virtual event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
                public ObservableCollection() => throw null;
                public ObservableCollection(System.Collections.Generic.IEnumerable<T> collection) => throw null;
                public ObservableCollection(System.Collections.Generic.List<T> list) => throw null;
                protected override void InsertItem(int index, T item) => throw null;
                public void Move(int oldIndex, int newIndex) => throw null;
                protected virtual void MoveItem(int oldIndex, int newIndex) => throw null;
                protected virtual void OnCollectionChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e) => throw null;
                protected virtual void OnPropertyChanged(System.ComponentModel.PropertyChangedEventArgs e) => throw null;
                protected virtual event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
                event System.ComponentModel.PropertyChangedEventHandler System.ComponentModel.INotifyPropertyChanged.PropertyChanged { add { } remove { } }
                protected override void RemoveItem(int index) => throw null;
                protected override void SetItem(int index, T item) => throw null;
            }
            public class ReadOnlyObservableCollection<T> : System.Collections.ObjectModel.ReadOnlyCollection<T>, System.Collections.Specialized.INotifyCollectionChanged, System.ComponentModel.INotifyPropertyChanged
            {
                protected virtual event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
                event System.Collections.Specialized.NotifyCollectionChangedEventHandler System.Collections.Specialized.INotifyCollectionChanged.CollectionChanged { add { } remove { } }
                public ReadOnlyObservableCollection(System.Collections.ObjectModel.ObservableCollection<T> list) : base(default(System.Collections.Generic.IList<T>)) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyObservableCollection<T> Empty { get => throw null; }
                protected virtual void OnCollectionChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs args) => throw null;
                protected virtual void OnPropertyChanged(System.ComponentModel.PropertyChangedEventArgs args) => throw null;
                protected virtual event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
                event System.ComponentModel.PropertyChangedEventHandler System.ComponentModel.INotifyPropertyChanged.PropertyChanged { add { } remove { } }
            }
        }
        namespace Specialized
        {
            public interface INotifyCollectionChanged
            {
                event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
            }
            public enum NotifyCollectionChangedAction
            {
                Add = 0,
                Remove = 1,
                Replace = 2,
                Move = 3,
                Reset = 4,
            }
            public class NotifyCollectionChangedEventArgs : System.EventArgs
            {
                public System.Collections.Specialized.NotifyCollectionChangedAction Action { get => throw null; }
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
                public System.Collections.IList NewItems { get => throw null; }
                public int NewStartingIndex { get => throw null; }
                public System.Collections.IList OldItems { get => throw null; }
                public int OldStartingIndex { get => throw null; }
            }
            public delegate void NotifyCollectionChangedEventHandler(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e);
        }
    }
    namespace ComponentModel
    {
        public class DataErrorsChangedEventArgs : System.EventArgs
        {
            public DataErrorsChangedEventArgs(string propertyName) => throw null;
            public virtual string PropertyName { get => throw null; }
        }
        public interface INotifyDataErrorInfo
        {
            event System.EventHandler<System.ComponentModel.DataErrorsChangedEventArgs> ErrorsChanged;
            System.Collections.IEnumerable GetErrors(string propertyName);
            bool HasErrors { get; }
        }
        public interface INotifyPropertyChanged
        {
            event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        }
        public interface INotifyPropertyChanging
        {
            event System.ComponentModel.PropertyChangingEventHandler PropertyChanging;
        }
        public class PropertyChangedEventArgs : System.EventArgs
        {
            public PropertyChangedEventArgs(string propertyName) => throw null;
            public virtual string PropertyName { get => throw null; }
        }
        public delegate void PropertyChangedEventHandler(object sender, System.ComponentModel.PropertyChangedEventArgs e);
        public class PropertyChangingEventArgs : System.EventArgs
        {
            public PropertyChangingEventArgs(string propertyName) => throw null;
            public virtual string PropertyName { get => throw null; }
        }
        public delegate void PropertyChangingEventHandler(object sender, System.ComponentModel.PropertyChangingEventArgs e);
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class TypeConverterAttribute : System.Attribute
        {
            public string ConverterTypeName { get => throw null; }
            public TypeConverterAttribute() => throw null;
            public TypeConverterAttribute(string typeName) => throw null;
            public TypeConverterAttribute(System.Type type) => throw null;
            public static readonly System.ComponentModel.TypeConverterAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4, Inherited = true)]
        public sealed class TypeDescriptionProviderAttribute : System.Attribute
        {
            public TypeDescriptionProviderAttribute(string typeName) => throw null;
            public TypeDescriptionProviderAttribute(System.Type type) => throw null;
            public string TypeName { get => throw null; }
        }
    }
    namespace Reflection
    {
        public interface ICustomTypeProvider
        {
            System.Type GetCustomType();
        }
    }
    namespace Windows
    {
        namespace Input
        {
            public interface ICommand
            {
                bool CanExecute(object parameter);
                event System.EventHandler CanExecuteChanged;
                void Execute(object parameter);
            }
        }
        namespace Markup
        {
            [System.AttributeUsage((System.AttributeTargets)1244, AllowMultiple = false, Inherited = true)]
            public sealed class ValueSerializerAttribute : System.Attribute
            {
                public ValueSerializerAttribute(string valueSerializerTypeName) => throw null;
                public ValueSerializerAttribute(System.Type valueSerializerType) => throw null;
                public System.Type ValueSerializerType { get => throw null; }
                public string ValueSerializerTypeName { get => throw null; }
            }
        }
    }
}
