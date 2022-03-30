// This file contains auto-generated code.

namespace System
{
    // Generated from `System.UriTypeConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public class UriTypeConverter : System.ComponentModel.TypeConverter
    {
        public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
        public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
        public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
        public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
        public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
        public UriTypeConverter() => throw null;
    }

    namespace ComponentModel
    {
        // Generated from `System.ComponentModel.AddingNewEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AddingNewEventArgs : System.EventArgs
        {
            public AddingNewEventArgs() => throw null;
            public AddingNewEventArgs(object newObject) => throw null;
            public object NewObject { get => throw null; set => throw null; }
        }

        // Generated from `System.ComponentModel.AddingNewEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void AddingNewEventHandler(object sender, System.ComponentModel.AddingNewEventArgs e);

        // Generated from `System.ComponentModel.AmbientValueAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AmbientValueAttribute : System.Attribute
        {
            public AmbientValueAttribute(System.Type type, string value) => throw null;
            public AmbientValueAttribute(bool value) => throw null;
            public AmbientValueAttribute(System.Byte value) => throw null;
            public AmbientValueAttribute(System.Char value) => throw null;
            public AmbientValueAttribute(double value) => throw null;
            public AmbientValueAttribute(float value) => throw null;
            public AmbientValueAttribute(int value) => throw null;
            public AmbientValueAttribute(System.Int64 value) => throw null;
            public AmbientValueAttribute(object value) => throw null;
            public AmbientValueAttribute(System.Int16 value) => throw null;
            public AmbientValueAttribute(string value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public object Value { get => throw null; }
        }

        // Generated from `System.ComponentModel.ArrayConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ArrayConverter : System.ComponentModel.CollectionConverter
        {
            public ArrayConverter() => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.ComponentModel.AttributeCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AttributeCollection : System.Collections.ICollection, System.Collections.IEnumerable
        {
            protected AttributeCollection() => throw null;
            public AttributeCollection(params System.Attribute[] attributes) => throw null;
            protected virtual System.Attribute[] Attributes { get => throw null; }
            public bool Contains(System.Attribute attribute) => throw null;
            public bool Contains(System.Attribute[] attributes) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            public static System.ComponentModel.AttributeCollection Empty;
            public static System.ComponentModel.AttributeCollection FromExisting(System.ComponentModel.AttributeCollection existing, params System.Attribute[] newAttributes) => throw null;
            protected System.Attribute GetDefaultAttribute(System.Type attributeType) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public virtual System.Attribute this[System.Type attributeType] { get => throw null; }
            public virtual System.Attribute this[int index] { get => throw null; }
            public bool Matches(System.Attribute attribute) => throw null;
            public bool Matches(System.Attribute[] attributes) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }

        // Generated from `System.ComponentModel.AttributeProviderAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AttributeProviderAttribute : System.Attribute
        {
            public AttributeProviderAttribute(System.Type type) => throw null;
            public AttributeProviderAttribute(string typeName) => throw null;
            public AttributeProviderAttribute(string typeName, string propertyName) => throw null;
            public string PropertyName { get => throw null; }
            public string TypeName { get => throw null; }
        }

        // Generated from `System.ComponentModel.BaseNumberConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class BaseNumberConverter : System.ComponentModel.TypeConverter
        {
            internal BaseNumberConverter() => throw null;
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
        }

        // Generated from `System.ComponentModel.BindableAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BindableAttribute : System.Attribute
        {
            public bool Bindable { get => throw null; }
            public BindableAttribute(System.ComponentModel.BindableSupport flags) => throw null;
            public BindableAttribute(System.ComponentModel.BindableSupport flags, System.ComponentModel.BindingDirection direction) => throw null;
            public BindableAttribute(bool bindable) => throw null;
            public BindableAttribute(bool bindable, System.ComponentModel.BindingDirection direction) => throw null;
            public static System.ComponentModel.BindableAttribute Default;
            public System.ComponentModel.BindingDirection Direction { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.BindableAttribute No;
            public static System.ComponentModel.BindableAttribute Yes;
        }

        // Generated from `System.ComponentModel.BindableSupport` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum BindableSupport
        {
            Default,
            No,
            Yes,
        }

        // Generated from `System.ComponentModel.BindingDirection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum BindingDirection
        {
            OneWay,
            TwoWay,
        }

        // Generated from `System.ComponentModel.BindingList<>` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BindingList<T> : System.Collections.ObjectModel.Collection<T>, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.IBindingList, System.ComponentModel.ICancelAddNew, System.ComponentModel.IRaiseItemChangedEvents
        {
            void System.ComponentModel.IBindingList.AddIndex(System.ComponentModel.PropertyDescriptor prop) => throw null;
            public T AddNew() => throw null;
            object System.ComponentModel.IBindingList.AddNew() => throw null;
            protected virtual object AddNewCore() => throw null;
            public event System.ComponentModel.AddingNewEventHandler AddingNew;
            public bool AllowEdit { get => throw null; set => throw null; }
            bool System.ComponentModel.IBindingList.AllowEdit { get => throw null; }
            public bool AllowNew { get => throw null; set => throw null; }
            bool System.ComponentModel.IBindingList.AllowNew { get => throw null; }
            public bool AllowRemove { get => throw null; set => throw null; }
            bool System.ComponentModel.IBindingList.AllowRemove { get => throw null; }
            void System.ComponentModel.IBindingList.ApplySort(System.ComponentModel.PropertyDescriptor prop, System.ComponentModel.ListSortDirection direction) => throw null;
            protected virtual void ApplySortCore(System.ComponentModel.PropertyDescriptor prop, System.ComponentModel.ListSortDirection direction) => throw null;
            public BindingList() => throw null;
            public BindingList(System.Collections.Generic.IList<T> list) => throw null;
            public virtual void CancelNew(int itemIndex) => throw null;
            protected override void ClearItems() => throw null;
            public virtual void EndNew(int itemIndex) => throw null;
            int System.ComponentModel.IBindingList.Find(System.ComponentModel.PropertyDescriptor prop, object key) => throw null;
            protected virtual int FindCore(System.ComponentModel.PropertyDescriptor prop, object key) => throw null;
            protected override void InsertItem(int index, T item) => throw null;
            bool System.ComponentModel.IBindingList.IsSorted { get => throw null; }
            protected virtual bool IsSortedCore { get => throw null; }
            public event System.ComponentModel.ListChangedEventHandler ListChanged;
            protected virtual void OnAddingNew(System.ComponentModel.AddingNewEventArgs e) => throw null;
            protected virtual void OnListChanged(System.ComponentModel.ListChangedEventArgs e) => throw null;
            public bool RaiseListChangedEvents { get => throw null; set => throw null; }
            bool System.ComponentModel.IRaiseItemChangedEvents.RaisesItemChangedEvents { get => throw null; }
            void System.ComponentModel.IBindingList.RemoveIndex(System.ComponentModel.PropertyDescriptor prop) => throw null;
            protected override void RemoveItem(int index) => throw null;
            void System.ComponentModel.IBindingList.RemoveSort() => throw null;
            protected virtual void RemoveSortCore() => throw null;
            public void ResetBindings() => throw null;
            public void ResetItem(int position) => throw null;
            protected override void SetItem(int index, T item) => throw null;
            System.ComponentModel.ListSortDirection System.ComponentModel.IBindingList.SortDirection { get => throw null; }
            protected virtual System.ComponentModel.ListSortDirection SortDirectionCore { get => throw null; }
            System.ComponentModel.PropertyDescriptor System.ComponentModel.IBindingList.SortProperty { get => throw null; }
            protected virtual System.ComponentModel.PropertyDescriptor SortPropertyCore { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsChangeNotification { get => throw null; }
            protected virtual bool SupportsChangeNotificationCore { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSearching { get => throw null; }
            protected virtual bool SupportsSearchingCore { get => throw null; }
            bool System.ComponentModel.IBindingList.SupportsSorting { get => throw null; }
            protected virtual bool SupportsSortingCore { get => throw null; }
        }

        // Generated from `System.ComponentModel.BooleanConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BooleanConverter : System.ComponentModel.TypeConverter
        {
            public BooleanConverter() => throw null;
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.ComponentModel.ByteConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ByteConverter : System.ComponentModel.BaseNumberConverter
        {
            public ByteConverter() => throw null;
        }

        // Generated from `System.ComponentModel.CancelEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void CancelEventHandler(object sender, System.ComponentModel.CancelEventArgs e);

        // Generated from `System.ComponentModel.CharConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CharConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public CharConverter() => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
        }

        // Generated from `System.ComponentModel.CollectionChangeAction` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum CollectionChangeAction
        {
            Add,
            Refresh,
            Remove,
        }

        // Generated from `System.ComponentModel.CollectionChangeEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CollectionChangeEventArgs : System.EventArgs
        {
            public virtual System.ComponentModel.CollectionChangeAction Action { get => throw null; }
            public CollectionChangeEventArgs(System.ComponentModel.CollectionChangeAction action, object element) => throw null;
            public virtual object Element { get => throw null; }
        }

        // Generated from `System.ComponentModel.CollectionChangeEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void CollectionChangeEventHandler(object sender, System.ComponentModel.CollectionChangeEventArgs e);

        // Generated from `System.ComponentModel.CollectionConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CollectionConverter : System.ComponentModel.TypeConverter
        {
            public CollectionConverter() => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.ComponentModel.ComplexBindingPropertiesAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ComplexBindingPropertiesAttribute : System.Attribute
        {
            public ComplexBindingPropertiesAttribute() => throw null;
            public ComplexBindingPropertiesAttribute(string dataSource) => throw null;
            public ComplexBindingPropertiesAttribute(string dataSource, string dataMember) => throw null;
            public string DataMember { get => throw null; }
            public string DataSource { get => throw null; }
            public static System.ComponentModel.ComplexBindingPropertiesAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
        }

        // Generated from `System.ComponentModel.ComponentConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ComponentConverter : System.ComponentModel.ReferenceConverter
        {
            public ComponentConverter(System.Type type) : base(default(System.Type)) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.ComponentModel.ComponentEditor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class ComponentEditor
        {
            protected ComponentEditor() => throw null;
            public abstract bool EditComponent(System.ComponentModel.ITypeDescriptorContext context, object component);
            public bool EditComponent(object component) => throw null;
        }

        // Generated from `System.ComponentModel.ComponentResourceManager` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ComponentResourceManager : System.Resources.ResourceManager
        {
            public void ApplyResources(object value, string objectName) => throw null;
            public virtual void ApplyResources(object value, string objectName, System.Globalization.CultureInfo culture) => throw null;
            public ComponentResourceManager() => throw null;
            public ComponentResourceManager(System.Type t) => throw null;
        }

        // Generated from `System.ComponentModel.Container` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Container : System.ComponentModel.IContainer, System.IDisposable
        {
            public virtual void Add(System.ComponentModel.IComponent component) => throw null;
            public virtual void Add(System.ComponentModel.IComponent component, string name) => throw null;
            public virtual System.ComponentModel.ComponentCollection Components { get => throw null; }
            public Container() => throw null;
            protected virtual System.ComponentModel.ISite CreateSite(System.ComponentModel.IComponent component, string name) => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected virtual object GetService(System.Type service) => throw null;
            public virtual void Remove(System.ComponentModel.IComponent component) => throw null;
            protected void RemoveWithoutUnsiting(System.ComponentModel.IComponent component) => throw null;
            protected virtual void ValidateName(System.ComponentModel.IComponent component, string name) => throw null;
            // ERR: Stub generator didn't handle member: ~Container
        }

        // Generated from `System.ComponentModel.ContainerFilterService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class ContainerFilterService
        {
            protected ContainerFilterService() => throw null;
            public virtual System.ComponentModel.ComponentCollection FilterComponents(System.ComponentModel.ComponentCollection components) => throw null;
        }

        // Generated from `System.ComponentModel.CultureInfoConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CultureInfoConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public CultureInfoConverter() => throw null;
            protected virtual string GetCultureName(System.Globalization.CultureInfo culture) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.ComponentModel.CustomTypeDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class CustomTypeDescriptor : System.ComponentModel.ICustomTypeDescriptor
        {
            protected CustomTypeDescriptor() => throw null;
            protected CustomTypeDescriptor(System.ComponentModel.ICustomTypeDescriptor parent) => throw null;
            public virtual System.ComponentModel.AttributeCollection GetAttributes() => throw null;
            public virtual string GetClassName() => throw null;
            public virtual string GetComponentName() => throw null;
            public virtual System.ComponentModel.TypeConverter GetConverter() => throw null;
            public virtual System.ComponentModel.EventDescriptor GetDefaultEvent() => throw null;
            public virtual System.ComponentModel.PropertyDescriptor GetDefaultProperty() => throw null;
            public virtual object GetEditor(System.Type editorBaseType) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection GetEvents() => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection GetEvents(System.Attribute[] attributes) => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection GetProperties() => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection GetProperties(System.Attribute[] attributes) => throw null;
            public virtual object GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd) => throw null;
        }

        // Generated from `System.ComponentModel.DataObjectAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataObjectAttribute : System.Attribute
        {
            public static System.ComponentModel.DataObjectAttribute DataObject;
            public DataObjectAttribute() => throw null;
            public DataObjectAttribute(bool isDataObject) => throw null;
            public static System.ComponentModel.DataObjectAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsDataObject { get => throw null; }
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.DataObjectAttribute NonDataObject;
        }

        // Generated from `System.ComponentModel.DataObjectFieldAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataObjectFieldAttribute : System.Attribute
        {
            public DataObjectFieldAttribute(bool primaryKey) => throw null;
            public DataObjectFieldAttribute(bool primaryKey, bool isIdentity) => throw null;
            public DataObjectFieldAttribute(bool primaryKey, bool isIdentity, bool isNullable) => throw null;
            public DataObjectFieldAttribute(bool primaryKey, bool isIdentity, bool isNullable, int length) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsIdentity { get => throw null; }
            public bool IsNullable { get => throw null; }
            public int Length { get => throw null; }
            public bool PrimaryKey { get => throw null; }
        }

        // Generated from `System.ComponentModel.DataObjectMethodAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DataObjectMethodAttribute : System.Attribute
        {
            public DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType methodType) => throw null;
            public DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType methodType, bool isDefault) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsDefault { get => throw null; }
            public override bool Match(object obj) => throw null;
            public System.ComponentModel.DataObjectMethodType MethodType { get => throw null; }
        }

        // Generated from `System.ComponentModel.DataObjectMethodType` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DataObjectMethodType
        {
            Delete,
            Fill,
            Insert,
            Select,
            Update,
        }

        // Generated from `System.ComponentModel.DateTimeConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DateTimeConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DateTimeConverter() => throw null;
        }

        // Generated from `System.ComponentModel.DateTimeOffsetConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DateTimeOffsetConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DateTimeOffsetConverter() => throw null;
        }

        // Generated from `System.ComponentModel.DecimalConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DecimalConverter : System.ComponentModel.BaseNumberConverter
        {
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DecimalConverter() => throw null;
        }

        // Generated from `System.ComponentModel.DefaultBindingPropertyAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DefaultBindingPropertyAttribute : System.Attribute
        {
            public static System.ComponentModel.DefaultBindingPropertyAttribute Default;
            public DefaultBindingPropertyAttribute() => throw null;
            public DefaultBindingPropertyAttribute(string name) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }

        // Generated from `System.ComponentModel.DefaultEventAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DefaultEventAttribute : System.Attribute
        {
            public static System.ComponentModel.DefaultEventAttribute Default;
            public DefaultEventAttribute(string name) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }

        // Generated from `System.ComponentModel.DefaultPropertyAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DefaultPropertyAttribute : System.Attribute
        {
            public static System.ComponentModel.DefaultPropertyAttribute Default;
            public DefaultPropertyAttribute(string name) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }

        // Generated from `System.ComponentModel.DesignTimeVisibleAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DesignTimeVisibleAttribute : System.Attribute
        {
            public static System.ComponentModel.DesignTimeVisibleAttribute Default;
            public DesignTimeVisibleAttribute() => throw null;
            public DesignTimeVisibleAttribute(bool visible) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.DesignTimeVisibleAttribute No;
            public bool Visible { get => throw null; }
            public static System.ComponentModel.DesignTimeVisibleAttribute Yes;
        }

        // Generated from `System.ComponentModel.DoubleConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DoubleConverter : System.ComponentModel.BaseNumberConverter
        {
            public DoubleConverter() => throw null;
        }

        // Generated from `System.ComponentModel.EnumConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EnumConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            protected virtual System.Collections.IComparer Comparer { get => throw null; }
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public EnumConverter(System.Type type) => throw null;
            protected System.Type EnumType { get => throw null; }
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            protected System.ComponentModel.TypeConverter.StandardValuesCollection Values { get => throw null; set => throw null; }
        }

        // Generated from `System.ComponentModel.EventDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EventDescriptor : System.ComponentModel.MemberDescriptor
        {
            public abstract void AddEventHandler(object component, System.Delegate value);
            public abstract System.Type ComponentType { get; }
            protected EventDescriptor(System.ComponentModel.MemberDescriptor descr) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            protected EventDescriptor(System.ComponentModel.MemberDescriptor descr, System.Attribute[] attrs) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            protected EventDescriptor(string name, System.Attribute[] attrs) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            public abstract System.Type EventType { get; }
            public abstract bool IsMulticast { get; }
            public abstract void RemoveEventHandler(object component, System.Delegate value);
        }

        // Generated from `System.ComponentModel.EventDescriptorCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EventDescriptorCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            public int Add(System.ComponentModel.EventDescriptor value) => throw null;
            int System.Collections.IList.Add(object value) => throw null;
            public void Clear() => throw null;
            void System.Collections.IList.Clear() => throw null;
            public bool Contains(System.ComponentModel.EventDescriptor value) => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            public static System.ComponentModel.EventDescriptorCollection Empty;
            public EventDescriptorCollection(System.ComponentModel.EventDescriptor[] events) => throw null;
            public EventDescriptorCollection(System.ComponentModel.EventDescriptor[] events, bool readOnly) => throw null;
            public virtual System.ComponentModel.EventDescriptor Find(string name, bool ignoreCase) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public int IndexOf(System.ComponentModel.EventDescriptor value) => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            public void Insert(int index, System.ComponentModel.EventDescriptor value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            protected void InternalSort(System.Collections.IComparer sorter) => throw null;
            protected void InternalSort(string[] names) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public virtual System.ComponentModel.EventDescriptor this[int index] { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
            public virtual System.ComponentModel.EventDescriptor this[string name] { get => throw null; }
            public void Remove(System.ComponentModel.EventDescriptor value) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            public void RemoveAt(int index) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort() => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort(System.Collections.IComparer comparer) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort(string[] names) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort(string[] names, System.Collections.IComparer comparer) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }

        // Generated from `System.ComponentModel.ExpandableObjectConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ExpandableObjectConverter : System.ComponentModel.TypeConverter
        {
            public ExpandableObjectConverter() => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.ComponentModel.ExtenderProvidedPropertyAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ExtenderProvidedPropertyAttribute : System.Attribute
        {
            public override bool Equals(object obj) => throw null;
            public System.ComponentModel.PropertyDescriptor ExtenderProperty { get => throw null; }
            public ExtenderProvidedPropertyAttribute() => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public System.ComponentModel.IExtenderProvider Provider { get => throw null; }
            public System.Type ReceiverType { get => throw null; }
        }

        // Generated from `System.ComponentModel.GuidConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class GuidConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public GuidConverter() => throw null;
        }

        // Generated from `System.ComponentModel.HandledEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class HandledEventArgs : System.EventArgs
        {
            public bool Handled { get => throw null; set => throw null; }
            public HandledEventArgs() => throw null;
            public HandledEventArgs(bool defaultHandledValue) => throw null;
        }

        // Generated from `System.ComponentModel.HandledEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void HandledEventHandler(object sender, System.ComponentModel.HandledEventArgs e);

        // Generated from `System.ComponentModel.IBindingList` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IBindingList : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            void AddIndex(System.ComponentModel.PropertyDescriptor property);
            object AddNew();
            bool AllowEdit { get; }
            bool AllowNew { get; }
            bool AllowRemove { get; }
            void ApplySort(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction);
            int Find(System.ComponentModel.PropertyDescriptor property, object key);
            bool IsSorted { get; }
            event System.ComponentModel.ListChangedEventHandler ListChanged;
            void RemoveIndex(System.ComponentModel.PropertyDescriptor property);
            void RemoveSort();
            System.ComponentModel.ListSortDirection SortDirection { get; }
            System.ComponentModel.PropertyDescriptor SortProperty { get; }
            bool SupportsChangeNotification { get; }
            bool SupportsSearching { get; }
            bool SupportsSorting { get; }
        }

        // Generated from `System.ComponentModel.IBindingListView` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IBindingListView : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.IBindingList
        {
            void ApplySort(System.ComponentModel.ListSortDescriptionCollection sorts);
            string Filter { get; set; }
            void RemoveFilter();
            System.ComponentModel.ListSortDescriptionCollection SortDescriptions { get; }
            bool SupportsAdvancedSorting { get; }
            bool SupportsFiltering { get; }
        }

        // Generated from `System.ComponentModel.ICancelAddNew` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICancelAddNew
        {
            void CancelNew(int itemIndex);
            void EndNew(int itemIndex);
        }

        // Generated from `System.ComponentModel.IComNativeDescriptorHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IComNativeDescriptorHandler
        {
            System.ComponentModel.AttributeCollection GetAttributes(object component);
            string GetClassName(object component);
            System.ComponentModel.TypeConverter GetConverter(object component);
            System.ComponentModel.EventDescriptor GetDefaultEvent(object component);
            System.ComponentModel.PropertyDescriptor GetDefaultProperty(object component);
            object GetEditor(object component, System.Type baseEditorType);
            System.ComponentModel.EventDescriptorCollection GetEvents(object component);
            System.ComponentModel.EventDescriptorCollection GetEvents(object component, System.Attribute[] attributes);
            string GetName(object component);
            System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, System.Attribute[] attributes);
            object GetPropertyValue(object component, int dispid, ref bool success);
            object GetPropertyValue(object component, string propertyName, ref bool success);
        }

        // Generated from `System.ComponentModel.ICustomTypeDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICustomTypeDescriptor
        {
            System.ComponentModel.AttributeCollection GetAttributes();
            string GetClassName();
            string GetComponentName();
            System.ComponentModel.TypeConverter GetConverter();
            System.ComponentModel.EventDescriptor GetDefaultEvent();
            System.ComponentModel.PropertyDescriptor GetDefaultProperty();
            object GetEditor(System.Type editorBaseType);
            System.ComponentModel.EventDescriptorCollection GetEvents();
            System.ComponentModel.EventDescriptorCollection GetEvents(System.Attribute[] attributes);
            System.ComponentModel.PropertyDescriptorCollection GetProperties();
            System.ComponentModel.PropertyDescriptorCollection GetProperties(System.Attribute[] attributes);
            object GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd);
        }

        // Generated from `System.ComponentModel.IDataErrorInfo` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IDataErrorInfo
        {
            string Error { get; }
            string this[string columnName] { get; }
        }

        // Generated from `System.ComponentModel.IExtenderProvider` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IExtenderProvider
        {
            bool CanExtend(object extendee);
        }

        // Generated from `System.ComponentModel.IIntellisenseBuilder` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IIntellisenseBuilder
        {
            string Name { get; }
            bool Show(string language, string value, ref string newValue);
        }

        // Generated from `System.ComponentModel.IListSource` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IListSource
        {
            bool ContainsListCollection { get; }
            System.Collections.IList GetList();
        }

        // Generated from `System.ComponentModel.INestedContainer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface INestedContainer : System.ComponentModel.IContainer, System.IDisposable
        {
            System.ComponentModel.IComponent Owner { get; }
        }

        // Generated from `System.ComponentModel.INestedSite` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface INestedSite : System.ComponentModel.ISite, System.IServiceProvider
        {
            string FullName { get; }
        }

        // Generated from `System.ComponentModel.IRaiseItemChangedEvents` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IRaiseItemChangedEvents
        {
            bool RaisesItemChangedEvents { get; }
        }

        // Generated from `System.ComponentModel.ISupportInitializeNotification` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ISupportInitializeNotification : System.ComponentModel.ISupportInitialize
        {
            event System.EventHandler Initialized;
            bool IsInitialized { get; }
        }

        // Generated from `System.ComponentModel.ITypeDescriptorContext` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ITypeDescriptorContext : System.IServiceProvider
        {
            System.ComponentModel.IContainer Container { get; }
            object Instance { get; }
            void OnComponentChanged();
            bool OnComponentChanging();
            System.ComponentModel.PropertyDescriptor PropertyDescriptor { get; }
        }

        // Generated from `System.ComponentModel.ITypedList` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ITypedList
        {
            System.ComponentModel.PropertyDescriptorCollection GetItemProperties(System.ComponentModel.PropertyDescriptor[] listAccessors);
            string GetListName(System.ComponentModel.PropertyDescriptor[] listAccessors);
        }

        // Generated from `System.ComponentModel.InheritanceAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InheritanceAttribute : System.Attribute
        {
            public static System.ComponentModel.InheritanceAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public InheritanceAttribute() => throw null;
            public InheritanceAttribute(System.ComponentModel.InheritanceLevel inheritanceLevel) => throw null;
            public System.ComponentModel.InheritanceLevel InheritanceLevel { get => throw null; }
            public static System.ComponentModel.InheritanceAttribute Inherited;
            public static System.ComponentModel.InheritanceAttribute InheritedReadOnly;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.InheritanceAttribute NotInherited;
            public override string ToString() => throw null;
        }

        // Generated from `System.ComponentModel.InheritanceLevel` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum InheritanceLevel
        {
            Inherited,
            InheritedReadOnly,
            NotInherited,
        }

        // Generated from `System.ComponentModel.InstallerTypeAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InstallerTypeAttribute : System.Attribute
        {
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Type InstallerType { get => throw null; }
            public InstallerTypeAttribute(System.Type installerType) => throw null;
            public InstallerTypeAttribute(string typeName) => throw null;
        }

        // Generated from `System.ComponentModel.InstanceCreationEditor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class InstanceCreationEditor
        {
            public abstract object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Type instanceType);
            protected InstanceCreationEditor() => throw null;
            public virtual string Text { get => throw null; }
        }

        // Generated from `System.ComponentModel.Int16Converter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Int16Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int16Converter() => throw null;
        }

        // Generated from `System.ComponentModel.Int32Converter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Int32Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int32Converter() => throw null;
        }

        // Generated from `System.ComponentModel.Int64Converter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Int64Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int64Converter() => throw null;
        }

        // Generated from `System.ComponentModel.LicFileLicenseProvider` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LicFileLicenseProvider : System.ComponentModel.LicenseProvider
        {
            protected virtual string GetKey(System.Type type) => throw null;
            public override System.ComponentModel.License GetLicense(System.ComponentModel.LicenseContext context, System.Type type, object instance, bool allowExceptions) => throw null;
            protected virtual bool IsKeyValid(string key, System.Type type) => throw null;
            public LicFileLicenseProvider() => throw null;
        }

        // Generated from `System.ComponentModel.License` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class License : System.IDisposable
        {
            public abstract void Dispose();
            protected License() => throw null;
            public abstract string LicenseKey { get; }
        }

        // Generated from `System.ComponentModel.LicenseContext` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LicenseContext : System.IServiceProvider
        {
            public virtual string GetSavedLicenseKey(System.Type type, System.Reflection.Assembly resourceAssembly) => throw null;
            public virtual object GetService(System.Type type) => throw null;
            public LicenseContext() => throw null;
            public virtual void SetSavedLicenseKey(System.Type type, string key) => throw null;
            public virtual System.ComponentModel.LicenseUsageMode UsageMode { get => throw null; }
        }

        // Generated from `System.ComponentModel.LicenseException` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LicenseException : System.SystemException
        {
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            protected LicenseException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public LicenseException(System.Type type) => throw null;
            public LicenseException(System.Type type, object instance) => throw null;
            public LicenseException(System.Type type, object instance, string message) => throw null;
            public LicenseException(System.Type type, object instance, string message, System.Exception innerException) => throw null;
            public System.Type LicensedType { get => throw null; }
        }

        // Generated from `System.ComponentModel.LicenseManager` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LicenseManager
        {
            public static object CreateWithContext(System.Type type, System.ComponentModel.LicenseContext creationContext) => throw null;
            public static object CreateWithContext(System.Type type, System.ComponentModel.LicenseContext creationContext, object[] args) => throw null;
            public static System.ComponentModel.LicenseContext CurrentContext { get => throw null; set => throw null; }
            public static bool IsLicensed(System.Type type) => throw null;
            public static bool IsValid(System.Type type) => throw null;
            public static bool IsValid(System.Type type, object instance, out System.ComponentModel.License license) => throw null;
            public static void LockContext(object contextUser) => throw null;
            public static void UnlockContext(object contextUser) => throw null;
            public static System.ComponentModel.LicenseUsageMode UsageMode { get => throw null; }
            public static void Validate(System.Type type) => throw null;
            public static System.ComponentModel.License Validate(System.Type type, object instance) => throw null;
        }

        // Generated from `System.ComponentModel.LicenseProvider` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class LicenseProvider
        {
            public abstract System.ComponentModel.License GetLicense(System.ComponentModel.LicenseContext context, System.Type type, object instance, bool allowExceptions);
            protected LicenseProvider() => throw null;
        }

        // Generated from `System.ComponentModel.LicenseProviderAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LicenseProviderAttribute : System.Attribute
        {
            public static System.ComponentModel.LicenseProviderAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public System.Type LicenseProvider { get => throw null; }
            public LicenseProviderAttribute() => throw null;
            public LicenseProviderAttribute(System.Type type) => throw null;
            public LicenseProviderAttribute(string typeName) => throw null;
            public override object TypeId { get => throw null; }
        }

        // Generated from `System.ComponentModel.LicenseUsageMode` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum LicenseUsageMode
        {
            Designtime,
            Runtime,
        }

        // Generated from `System.ComponentModel.ListBindableAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ListBindableAttribute : System.Attribute
        {
            public static System.ComponentModel.ListBindableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool ListBindable { get => throw null; }
            public ListBindableAttribute(System.ComponentModel.BindableSupport flags) => throw null;
            public ListBindableAttribute(bool listBindable) => throw null;
            public static System.ComponentModel.ListBindableAttribute No;
            public static System.ComponentModel.ListBindableAttribute Yes;
        }

        // Generated from `System.ComponentModel.ListChangedEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ListChangedEventArgs : System.EventArgs
        {
            public ListChangedEventArgs(System.ComponentModel.ListChangedType listChangedType, System.ComponentModel.PropertyDescriptor propDesc) => throw null;
            public ListChangedEventArgs(System.ComponentModel.ListChangedType listChangedType, int newIndex) => throw null;
            public ListChangedEventArgs(System.ComponentModel.ListChangedType listChangedType, int newIndex, System.ComponentModel.PropertyDescriptor propDesc) => throw null;
            public ListChangedEventArgs(System.ComponentModel.ListChangedType listChangedType, int newIndex, int oldIndex) => throw null;
            public System.ComponentModel.ListChangedType ListChangedType { get => throw null; }
            public int NewIndex { get => throw null; }
            public int OldIndex { get => throw null; }
            public System.ComponentModel.PropertyDescriptor PropertyDescriptor { get => throw null; }
        }

        // Generated from `System.ComponentModel.ListChangedEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void ListChangedEventHandler(object sender, System.ComponentModel.ListChangedEventArgs e);

        // Generated from `System.ComponentModel.ListChangedType` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ListChangedType
        {
            ItemAdded,
            ItemChanged,
            ItemDeleted,
            ItemMoved,
            PropertyDescriptorAdded,
            PropertyDescriptorChanged,
            PropertyDescriptorDeleted,
            Reset,
        }

        // Generated from `System.ComponentModel.ListSortDescription` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ListSortDescription
        {
            public ListSortDescription(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction) => throw null;
            public System.ComponentModel.PropertyDescriptor PropertyDescriptor { get => throw null; set => throw null; }
            public System.ComponentModel.ListSortDirection SortDirection { get => throw null; set => throw null; }
        }

        // Generated from `System.ComponentModel.ListSortDescriptionCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ListSortDescriptionCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            int System.Collections.IList.Add(object value) => throw null;
            void System.Collections.IList.Clear() => throw null;
            public bool Contains(object value) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public int IndexOf(object value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public System.ComponentModel.ListSortDescription this[int index] { get => throw null; set => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
            public ListSortDescriptionCollection() => throw null;
            public ListSortDescriptionCollection(System.ComponentModel.ListSortDescription[] sorts) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }

        // Generated from `System.ComponentModel.ListSortDirection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ListSortDirection
        {
            Ascending,
            Descending,
        }

        // Generated from `System.ComponentModel.LookupBindingPropertiesAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LookupBindingPropertiesAttribute : System.Attribute
        {
            public string DataSource { get => throw null; }
            public static System.ComponentModel.LookupBindingPropertiesAttribute Default;
            public string DisplayMember { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public LookupBindingPropertiesAttribute() => throw null;
            public LookupBindingPropertiesAttribute(string dataSource, string displayMember, string valueMember, string lookupMember) => throw null;
            public string LookupMember { get => throw null; }
            public string ValueMember { get => throw null; }
        }

        // Generated from `System.ComponentModel.MarshalByValueComponent` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MarshalByValueComponent : System.ComponentModel.IComponent, System.IDisposable, System.IServiceProvider
        {
            public virtual System.ComponentModel.IContainer Container { get => throw null; }
            public virtual bool DesignMode { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public event System.EventHandler Disposed;
            protected System.ComponentModel.EventHandlerList Events { get => throw null; }
            public virtual object GetService(System.Type service) => throw null;
            public MarshalByValueComponent() => throw null;
            public virtual System.ComponentModel.ISite Site { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            // ERR: Stub generator didn't handle member: ~MarshalByValueComponent
        }

        // Generated from `System.ComponentModel.MaskedTextProvider` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MaskedTextProvider : System.ICloneable
        {
            public bool Add(System.Char input) => throw null;
            public bool Add(System.Char input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Add(string input) => throw null;
            public bool Add(string input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool AllowPromptAsInput { get => throw null; }
            public bool AsciiOnly { get => throw null; }
            public int AssignedEditPositionCount { get => throw null; }
            public int AvailableEditPositionCount { get => throw null; }
            public void Clear() => throw null;
            public void Clear(out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public object Clone() => throw null;
            public System.Globalization.CultureInfo Culture { get => throw null; }
            public static System.Char DefaultPasswordChar { get => throw null; }
            public int EditPositionCount { get => throw null; }
            public System.Collections.IEnumerator EditPositions { get => throw null; }
            public int FindAssignedEditPositionFrom(int position, bool direction) => throw null;
            public int FindAssignedEditPositionInRange(int startPosition, int endPosition, bool direction) => throw null;
            public int FindEditPositionFrom(int position, bool direction) => throw null;
            public int FindEditPositionInRange(int startPosition, int endPosition, bool direction) => throw null;
            public int FindNonEditPositionFrom(int position, bool direction) => throw null;
            public int FindNonEditPositionInRange(int startPosition, int endPosition, bool direction) => throw null;
            public int FindUnassignedEditPositionFrom(int position, bool direction) => throw null;
            public int FindUnassignedEditPositionInRange(int startPosition, int endPosition, bool direction) => throw null;
            public static bool GetOperationResultFromHint(System.ComponentModel.MaskedTextResultHint hint) => throw null;
            public bool IncludeLiterals { get => throw null; set => throw null; }
            public bool IncludePrompt { get => throw null; set => throw null; }
            public bool InsertAt(System.Char input, int position) => throw null;
            public bool InsertAt(System.Char input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool InsertAt(string input, int position) => throw null;
            public bool InsertAt(string input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public static int InvalidIndex { get => throw null; }
            public bool IsAvailablePosition(int position) => throw null;
            public bool IsEditPosition(int position) => throw null;
            public bool IsPassword { get => throw null; set => throw null; }
            public static bool IsValidInputChar(System.Char c) => throw null;
            public static bool IsValidMaskChar(System.Char c) => throw null;
            public static bool IsValidPasswordChar(System.Char c) => throw null;
            public System.Char this[int index] { get => throw null; }
            public int LastAssignedPosition { get => throw null; }
            public int Length { get => throw null; }
            public string Mask { get => throw null; }
            public bool MaskCompleted { get => throw null; }
            public bool MaskFull { get => throw null; }
            public MaskedTextProvider(string mask) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture, bool restrictToAscii) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture, bool allowPromptAsInput, System.Char promptChar, System.Char passwordChar, bool restrictToAscii) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture, System.Char passwordChar, bool allowPromptAsInput) => throw null;
            public MaskedTextProvider(string mask, bool restrictToAscii) => throw null;
            public MaskedTextProvider(string mask, System.Char passwordChar, bool allowPromptAsInput) => throw null;
            public System.Char PasswordChar { get => throw null; set => throw null; }
            public System.Char PromptChar { get => throw null; set => throw null; }
            public bool Remove() => throw null;
            public bool Remove(out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool RemoveAt(int position) => throw null;
            public bool RemoveAt(int startPosition, int endPosition) => throw null;
            public bool RemoveAt(int startPosition, int endPosition, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(System.Char input, int position) => throw null;
            public bool Replace(System.Char input, int startPosition, int endPosition, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(System.Char input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(string input, int position) => throw null;
            public bool Replace(string input, int startPosition, int endPosition, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(string input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool ResetOnPrompt { get => throw null; set => throw null; }
            public bool ResetOnSpace { get => throw null; set => throw null; }
            public bool Set(string input) => throw null;
            public bool Set(string input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool SkipLiterals { get => throw null; set => throw null; }
            public string ToDisplayString() => throw null;
            public override string ToString() => throw null;
            public string ToString(bool ignorePasswordChar) => throw null;
            public string ToString(bool includePrompt, bool includeLiterals) => throw null;
            public string ToString(bool ignorePasswordChar, bool includePrompt, bool includeLiterals, int startPosition, int length) => throw null;
            public string ToString(bool includePrompt, bool includeLiterals, int startPosition, int length) => throw null;
            public string ToString(bool ignorePasswordChar, int startPosition, int length) => throw null;
            public string ToString(int startPosition, int length) => throw null;
            public bool VerifyChar(System.Char input, int position, out System.ComponentModel.MaskedTextResultHint hint) => throw null;
            public bool VerifyEscapeChar(System.Char input, int position) => throw null;
            public bool VerifyString(string input) => throw null;
            public bool VerifyString(string input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
        }

        // Generated from `System.ComponentModel.MaskedTextResultHint` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum MaskedTextResultHint
        {
            AlphanumericCharacterExpected,
            AsciiCharacterExpected,
            CharacterEscaped,
            DigitExpected,
            InvalidInput,
            LetterExpected,
            NoEffect,
            NonEditPosition,
            PositionOutOfRange,
            PromptCharNotAllowed,
            SideEffect,
            SignedDigitExpected,
            Success,
            UnavailableEditPosition,
            Unknown,
        }

        // Generated from `System.ComponentModel.MemberDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class MemberDescriptor
        {
            protected virtual System.Attribute[] AttributeArray { get => throw null; set => throw null; }
            public virtual System.ComponentModel.AttributeCollection Attributes { get => throw null; }
            public virtual string Category { get => throw null; }
            protected virtual System.ComponentModel.AttributeCollection CreateAttributeCollection() => throw null;
            public virtual string Description { get => throw null; }
            public virtual bool DesignTimeOnly { get => throw null; }
            public virtual string DisplayName { get => throw null; }
            public override bool Equals(object obj) => throw null;
            protected virtual void FillAttributes(System.Collections.IList attributeList) => throw null;
            protected static System.Reflection.MethodInfo FindMethod(System.Type componentClass, string name, System.Type[] args, System.Type returnType) => throw null;
            protected static System.Reflection.MethodInfo FindMethod(System.Type componentClass, string name, System.Type[] args, System.Type returnType, bool publicOnly) => throw null;
            public override int GetHashCode() => throw null;
            protected virtual object GetInvocationTarget(System.Type type, object instance) => throw null;
            protected static object GetInvokee(System.Type componentClass, object component) => throw null;
            protected static System.ComponentModel.ISite GetSite(object component) => throw null;
            public virtual bool IsBrowsable { get => throw null; }
            protected MemberDescriptor(System.ComponentModel.MemberDescriptor descr) => throw null;
            protected MemberDescriptor(System.ComponentModel.MemberDescriptor oldMemberDescriptor, System.Attribute[] newAttributes) => throw null;
            protected MemberDescriptor(string name) => throw null;
            protected MemberDescriptor(string name, System.Attribute[] attributes) => throw null;
            public virtual string Name { get => throw null; }
            protected virtual int NameHashCode { get => throw null; }
        }

        // Generated from `System.ComponentModel.MultilineStringConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MultilineStringConverter : System.ComponentModel.TypeConverter
        {
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public MultilineStringConverter() => throw null;
        }

        // Generated from `System.ComponentModel.NestedContainer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class NestedContainer : System.ComponentModel.Container, System.ComponentModel.IContainer, System.ComponentModel.INestedContainer, System.IDisposable
        {
            protected override System.ComponentModel.ISite CreateSite(System.ComponentModel.IComponent component, string name) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            protected override object GetService(System.Type service) => throw null;
            public NestedContainer(System.ComponentModel.IComponent owner) => throw null;
            public System.ComponentModel.IComponent Owner { get => throw null; }
            protected virtual string OwnerName { get => throw null; }
        }

        // Generated from `System.ComponentModel.NullableConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class NullableConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public NullableConverter(System.Type type) => throw null;
            public System.Type NullableType { get => throw null; }
            public System.Type UnderlyingType { get => throw null; }
            public System.ComponentModel.TypeConverter UnderlyingTypeConverter { get => throw null; }
        }

        // Generated from `System.ComponentModel.PasswordPropertyTextAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PasswordPropertyTextAttribute : System.Attribute
        {
            public static System.ComponentModel.PasswordPropertyTextAttribute Default;
            public override bool Equals(object o) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.PasswordPropertyTextAttribute No;
            public bool Password { get => throw null; }
            public PasswordPropertyTextAttribute() => throw null;
            public PasswordPropertyTextAttribute(bool password) => throw null;
            public static System.ComponentModel.PasswordPropertyTextAttribute Yes;
        }

        // Generated from `System.ComponentModel.PropertyDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class PropertyDescriptor : System.ComponentModel.MemberDescriptor
        {
            public virtual void AddValueChanged(object component, System.EventHandler handler) => throw null;
            public abstract bool CanResetValue(object component);
            public abstract System.Type ComponentType { get; }
            public virtual System.ComponentModel.TypeConverter Converter { get => throw null; }
            protected object CreateInstance(System.Type type) => throw null;
            public override bool Equals(object obj) => throw null;
            protected override void FillAttributes(System.Collections.IList attributeList) => throw null;
            public System.ComponentModel.PropertyDescriptorCollection GetChildProperties() => throw null;
            public System.ComponentModel.PropertyDescriptorCollection GetChildProperties(System.Attribute[] filter) => throw null;
            public System.ComponentModel.PropertyDescriptorCollection GetChildProperties(object instance) => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection GetChildProperties(object instance, System.Attribute[] filter) => throw null;
            public virtual object GetEditor(System.Type editorBaseType) => throw null;
            public override int GetHashCode() => throw null;
            protected override object GetInvocationTarget(System.Type type, object instance) => throw null;
            protected System.Type GetTypeFromName(string typeName) => throw null;
            public abstract object GetValue(object component);
            protected internal System.EventHandler GetValueChangedHandler(object component) => throw null;
            public virtual bool IsLocalizable { get => throw null; }
            public abstract bool IsReadOnly { get; }
            protected virtual void OnValueChanged(object component, System.EventArgs e) => throw null;
            protected PropertyDescriptor(System.ComponentModel.MemberDescriptor descr) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            protected PropertyDescriptor(System.ComponentModel.MemberDescriptor descr, System.Attribute[] attrs) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            protected PropertyDescriptor(string name, System.Attribute[] attrs) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            public abstract System.Type PropertyType { get; }
            public virtual void RemoveValueChanged(object component, System.EventHandler handler) => throw null;
            public abstract void ResetValue(object component);
            public System.ComponentModel.DesignerSerializationVisibility SerializationVisibility { get => throw null; }
            public abstract void SetValue(object component, object value);
            public abstract bool ShouldSerializeValue(object component);
            public virtual bool SupportsChangeEvents { get => throw null; }
        }

        // Generated from `System.ComponentModel.PropertyDescriptorCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PropertyDescriptorCollection : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable, System.Collections.IList
        {
            public int Add(System.ComponentModel.PropertyDescriptor value) => throw null;
            int System.Collections.IList.Add(object value) => throw null;
            void System.Collections.IDictionary.Add(object key, object value) => throw null;
            public void Clear() => throw null;
            void System.Collections.IDictionary.Clear() => throw null;
            void System.Collections.IList.Clear() => throw null;
            public bool Contains(System.ComponentModel.PropertyDescriptor value) => throw null;
            bool System.Collections.IDictionary.Contains(object key) => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            public static System.ComponentModel.PropertyDescriptorCollection Empty;
            public virtual System.ComponentModel.PropertyDescriptor Find(string name, bool ignoreCase) => throw null;
            public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public int IndexOf(System.ComponentModel.PropertyDescriptor value) => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            public void Insert(int index, System.ComponentModel.PropertyDescriptor value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            protected void InternalSort(System.Collections.IComparer sorter) => throw null;
            protected void InternalSort(string[] names) => throw null;
            bool System.Collections.IDictionary.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IDictionary.IsReadOnly { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public virtual System.ComponentModel.PropertyDescriptor this[int index] { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
            object System.Collections.IDictionary.this[object key] { get => throw null; set => throw null; }
            public virtual System.ComponentModel.PropertyDescriptor this[string name] { get => throw null; }
            System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
            public PropertyDescriptorCollection(System.ComponentModel.PropertyDescriptor[] properties) => throw null;
            public PropertyDescriptorCollection(System.ComponentModel.PropertyDescriptor[] properties, bool readOnly) => throw null;
            public void Remove(System.ComponentModel.PropertyDescriptor value) => throw null;
            void System.Collections.IDictionary.Remove(object key) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            public void RemoveAt(int index) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection Sort() => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection Sort(System.Collections.IComparer comparer) => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection Sort(string[] names) => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection Sort(string[] names, System.Collections.IComparer comparer) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
        }

        // Generated from `System.ComponentModel.PropertyTabAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PropertyTabAttribute : System.Attribute
        {
            public bool Equals(System.ComponentModel.PropertyTabAttribute other) => throw null;
            public override bool Equals(object other) => throw null;
            public override int GetHashCode() => throw null;
            protected void InitializeArrays(string[] tabClassNames, System.ComponentModel.PropertyTabScope[] tabScopes) => throw null;
            protected void InitializeArrays(System.Type[] tabClasses, System.ComponentModel.PropertyTabScope[] tabScopes) => throw null;
            public PropertyTabAttribute() => throw null;
            public PropertyTabAttribute(System.Type tabClass) => throw null;
            public PropertyTabAttribute(System.Type tabClass, System.ComponentModel.PropertyTabScope tabScope) => throw null;
            public PropertyTabAttribute(string tabClassName) => throw null;
            public PropertyTabAttribute(string tabClassName, System.ComponentModel.PropertyTabScope tabScope) => throw null;
            protected string[] TabClassNames { get => throw null; }
            public System.Type[] TabClasses { get => throw null; }
            public System.ComponentModel.PropertyTabScope[] TabScopes { get => throw null; }
        }

        // Generated from `System.ComponentModel.PropertyTabScope` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum PropertyTabScope
        {
            Component,
            Document,
            Global,
            Static,
        }

        // Generated from `System.ComponentModel.ProvidePropertyAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProvidePropertyAttribute : System.Attribute
        {
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string PropertyName { get => throw null; }
            public ProvidePropertyAttribute(string propertyName, System.Type receiverType) => throw null;
            public ProvidePropertyAttribute(string propertyName, string receiverTypeName) => throw null;
            public string ReceiverTypeName { get => throw null; }
            public override object TypeId { get => throw null; }
        }

        // Generated from `System.ComponentModel.RecommendedAsConfigurableAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RecommendedAsConfigurableAttribute : System.Attribute
        {
            public static System.ComponentModel.RecommendedAsConfigurableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.RecommendedAsConfigurableAttribute No;
            public bool RecommendedAsConfigurable { get => throw null; }
            public RecommendedAsConfigurableAttribute(bool recommendedAsConfigurable) => throw null;
            public static System.ComponentModel.RecommendedAsConfigurableAttribute Yes;
        }

        // Generated from `System.ComponentModel.ReferenceConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ReferenceConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            protected virtual bool IsValueAllowed(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public ReferenceConverter(System.Type type) => throw null;
        }

        // Generated from `System.ComponentModel.RefreshEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RefreshEventArgs : System.EventArgs
        {
            public object ComponentChanged { get => throw null; }
            public RefreshEventArgs(System.Type typeChanged) => throw null;
            public RefreshEventArgs(object componentChanged) => throw null;
            public System.Type TypeChanged { get => throw null; }
        }

        // Generated from `System.ComponentModel.RefreshEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void RefreshEventHandler(System.ComponentModel.RefreshEventArgs e);

        // Generated from `System.ComponentModel.RunInstallerAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RunInstallerAttribute : System.Attribute
        {
            public static System.ComponentModel.RunInstallerAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.RunInstallerAttribute No;
            public bool RunInstaller { get => throw null; }
            public RunInstallerAttribute(bool runInstaller) => throw null;
            public static System.ComponentModel.RunInstallerAttribute Yes;
        }

        // Generated from `System.ComponentModel.SByteConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SByteConverter : System.ComponentModel.BaseNumberConverter
        {
            public SByteConverter() => throw null;
        }

        // Generated from `System.ComponentModel.SettingsBindableAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SettingsBindableAttribute : System.Attribute
        {
            public bool Bindable { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static System.ComponentModel.SettingsBindableAttribute No;
            public SettingsBindableAttribute(bool bindable) => throw null;
            public static System.ComponentModel.SettingsBindableAttribute Yes;
        }

        // Generated from `System.ComponentModel.SingleConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SingleConverter : System.ComponentModel.BaseNumberConverter
        {
            public SingleConverter() => throw null;
        }

        // Generated from `System.ComponentModel.StringConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StringConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public StringConverter() => throw null;
        }

        // Generated from `System.ComponentModel.SyntaxCheck` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class SyntaxCheck
        {
            public static bool CheckMachineName(string value) => throw null;
            public static bool CheckPath(string value) => throw null;
            public static bool CheckRootedPath(string value) => throw null;
        }

        // Generated from `System.ComponentModel.TimeSpanConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TimeSpanConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public TimeSpanConverter() => throw null;
        }

        // Generated from `System.ComponentModel.ToolboxItemAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ToolboxItemAttribute : System.Attribute
        {
            public static System.ComponentModel.ToolboxItemAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.ToolboxItemAttribute None;
            public ToolboxItemAttribute(System.Type toolboxItemType) => throw null;
            public ToolboxItemAttribute(bool defaultType) => throw null;
            public ToolboxItemAttribute(string toolboxItemTypeName) => throw null;
            public System.Type ToolboxItemType { get => throw null; }
            public string ToolboxItemTypeName { get => throw null; }
        }

        // Generated from `System.ComponentModel.ToolboxItemFilterAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ToolboxItemFilterAttribute : System.Attribute
        {
            public override bool Equals(object obj) => throw null;
            public string FilterString { get => throw null; }
            public System.ComponentModel.ToolboxItemFilterType FilterType { get => throw null; }
            public override int GetHashCode() => throw null;
            public override bool Match(object obj) => throw null;
            public override string ToString() => throw null;
            public ToolboxItemFilterAttribute(string filterString) => throw null;
            public ToolboxItemFilterAttribute(string filterString, System.ComponentModel.ToolboxItemFilterType filterType) => throw null;
            public override object TypeId { get => throw null; }
        }

        // Generated from `System.ComponentModel.ToolboxItemFilterType` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum ToolboxItemFilterType
        {
            Allow,
            Custom,
            Prevent,
            Require,
        }

        // Generated from `System.ComponentModel.TypeConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TypeConverter
        {
            // Generated from `System.ComponentModel.TypeConverter+SimplePropertyDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            protected abstract class SimplePropertyDescriptor : System.ComponentModel.PropertyDescriptor
            {
                public override bool CanResetValue(object component) => throw null;
                public override System.Type ComponentType { get => throw null; }
                public override bool IsReadOnly { get => throw null; }
                public override System.Type PropertyType { get => throw null; }
                public override void ResetValue(object component) => throw null;
                public override bool ShouldSerializeValue(object component) => throw null;
                protected SimplePropertyDescriptor(System.Type componentType, string name, System.Type propertyType) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
                protected SimplePropertyDescriptor(System.Type componentType, string name, System.Type propertyType, System.Attribute[] attributes) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            }


            // Generated from `System.ComponentModel.TypeConverter+StandardValuesCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StandardValuesCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public object this[int index] { get => throw null; }
                public StandardValuesCollection(System.Collections.ICollection values) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }


            public virtual bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public bool CanConvertFrom(System.Type sourceType) => throw null;
            public virtual bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public bool CanConvertTo(System.Type destinationType) => throw null;
            public virtual object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public object ConvertFrom(object value) => throw null;
            public object ConvertFromInvariantString(System.ComponentModel.ITypeDescriptorContext context, string text) => throw null;
            public object ConvertFromInvariantString(string text) => throw null;
            public object ConvertFromString(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, string text) => throw null;
            public object ConvertFromString(System.ComponentModel.ITypeDescriptorContext context, string text) => throw null;
            public object ConvertFromString(string text) => throw null;
            public virtual object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public object ConvertTo(object value, System.Type destinationType) => throw null;
            public string ConvertToInvariantString(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public string ConvertToInvariantString(object value) => throw null;
            public string ConvertToString(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public string ConvertToString(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public string ConvertToString(object value) => throw null;
            public object CreateInstance(System.Collections.IDictionary propertyValues) => throw null;
            public virtual object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            protected System.Exception GetConvertFromException(object value) => throw null;
            protected System.Exception GetConvertToException(object value, System.Type destinationType) => throw null;
            public bool GetCreateInstanceSupported() => throw null;
            public virtual bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public virtual System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public System.ComponentModel.PropertyDescriptorCollection GetProperties(object value) => throw null;
            public bool GetPropertiesSupported() => throw null;
            public virtual bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public System.Collections.ICollection GetStandardValues() => throw null;
            public virtual System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public bool GetStandardValuesExclusive() => throw null;
            public virtual bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public bool GetStandardValuesSupported() => throw null;
            public virtual bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public virtual bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public bool IsValid(object value) => throw null;
            protected System.ComponentModel.PropertyDescriptorCollection SortProperties(System.ComponentModel.PropertyDescriptorCollection props, string[] names) => throw null;
            public TypeConverter() => throw null;
        }

        // Generated from `System.ComponentModel.TypeDescriptionProvider` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TypeDescriptionProvider
        {
            public virtual object CreateInstance(System.IServiceProvider provider, System.Type objectType, System.Type[] argTypes, object[] args) => throw null;
            public virtual System.Collections.IDictionary GetCache(object instance) => throw null;
            public virtual System.ComponentModel.ICustomTypeDescriptor GetExtendedTypeDescriptor(object instance) => throw null;
            protected internal virtual System.ComponentModel.IExtenderProvider[] GetExtenderProviders(object instance) => throw null;
            public virtual string GetFullComponentName(object component) => throw null;
            public System.Type GetReflectionType(System.Type objectType) => throw null;
            public virtual System.Type GetReflectionType(System.Type objectType, object instance) => throw null;
            public System.Type GetReflectionType(object instance) => throw null;
            public virtual System.Type GetRuntimeType(System.Type reflectionType) => throw null;
            public System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(System.Type objectType) => throw null;
            public virtual System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(System.Type objectType, object instance) => throw null;
            public System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(object instance) => throw null;
            public virtual bool IsSupportedType(System.Type type) => throw null;
            protected TypeDescriptionProvider() => throw null;
            protected TypeDescriptionProvider(System.ComponentModel.TypeDescriptionProvider parent) => throw null;
        }

        // Generated from `System.ComponentModel.TypeDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TypeDescriptor
        {
            public static System.ComponentModel.TypeDescriptionProvider AddAttributes(System.Type type, params System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.TypeDescriptionProvider AddAttributes(object instance, params System.Attribute[] attributes) => throw null;
            public static void AddEditorTable(System.Type editorBaseType, System.Collections.Hashtable table) => throw null;
            public static void AddProvider(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void AddProvider(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void AddProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void AddProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static System.ComponentModel.IComNativeDescriptorHandler ComNativeDescriptorHandler { get => throw null; set => throw null; }
            public static System.Type ComObjectType { get => throw null; }
            public static void CreateAssociation(object primary, object secondary) => throw null;
            public static System.ComponentModel.Design.IDesigner CreateDesigner(System.ComponentModel.IComponent component, System.Type designerBaseType) => throw null;
            public static System.ComponentModel.EventDescriptor CreateEvent(System.Type componentType, System.ComponentModel.EventDescriptor oldEventDescriptor, params System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.EventDescriptor CreateEvent(System.Type componentType, string name, System.Type type, params System.Attribute[] attributes) => throw null;
            public static object CreateInstance(System.IServiceProvider provider, System.Type objectType, System.Type[] argTypes, object[] args) => throw null;
            public static System.ComponentModel.PropertyDescriptor CreateProperty(System.Type componentType, System.ComponentModel.PropertyDescriptor oldPropertyDescriptor, params System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.PropertyDescriptor CreateProperty(System.Type componentType, string name, System.Type type, params System.Attribute[] attributes) => throw null;
            public static object GetAssociation(System.Type type, object primary) => throw null;
            public static System.ComponentModel.AttributeCollection GetAttributes(System.Type componentType) => throw null;
            public static System.ComponentModel.AttributeCollection GetAttributes(object component) => throw null;
            public static System.ComponentModel.AttributeCollection GetAttributes(object component, bool noCustomTypeDesc) => throw null;
            public static string GetClassName(System.Type componentType) => throw null;
            public static string GetClassName(object component) => throw null;
            public static string GetClassName(object component, bool noCustomTypeDesc) => throw null;
            public static string GetComponentName(object component) => throw null;
            public static string GetComponentName(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.TypeConverter GetConverter(System.Type type) => throw null;
            public static System.ComponentModel.TypeConverter GetConverter(object component) => throw null;
            public static System.ComponentModel.TypeConverter GetConverter(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.EventDescriptor GetDefaultEvent(System.Type componentType) => throw null;
            public static System.ComponentModel.EventDescriptor GetDefaultEvent(object component) => throw null;
            public static System.ComponentModel.EventDescriptor GetDefaultEvent(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.PropertyDescriptor GetDefaultProperty(System.Type componentType) => throw null;
            public static System.ComponentModel.PropertyDescriptor GetDefaultProperty(object component) => throw null;
            public static System.ComponentModel.PropertyDescriptor GetDefaultProperty(object component, bool noCustomTypeDesc) => throw null;
            public static object GetEditor(System.Type type, System.Type editorBaseType) => throw null;
            public static object GetEditor(object component, System.Type editorBaseType) => throw null;
            public static object GetEditor(object component, System.Type editorBaseType, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(System.Type componentType) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(System.Type componentType, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component, System.Attribute[] attributes, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component, bool noCustomTypeDesc) => throw null;
            public static string GetFullComponentName(object component) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(System.Type componentType) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(System.Type componentType, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, System.Attribute[] attributes, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.TypeDescriptionProvider GetProvider(System.Type type) => throw null;
            public static System.ComponentModel.TypeDescriptionProvider GetProvider(object instance) => throw null;
            public static System.Type GetReflectionType(System.Type type) => throw null;
            public static System.Type GetReflectionType(object instance) => throw null;
            public static System.Type InterfaceType { get => throw null; }
            public static void Refresh(System.Reflection.Assembly assembly) => throw null;
            public static void Refresh(System.Reflection.Module module) => throw null;
            public static void Refresh(System.Type type) => throw null;
            public static void Refresh(object component) => throw null;
            public static event System.ComponentModel.RefreshEventHandler Refreshed;
            public static void RemoveAssociation(object primary, object secondary) => throw null;
            public static void RemoveAssociations(object primary) => throw null;
            public static void RemoveProvider(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void RemoveProvider(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void RemoveProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void RemoveProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void SortDescriptorArray(System.Collections.IList infos) => throw null;
        }

        // Generated from `System.ComponentModel.TypeListConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TypeListConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            protected TypeListConverter(System.Type[] types) => throw null;
        }

        // Generated from `System.ComponentModel.UInt16Converter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UInt16Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt16Converter() => throw null;
        }

        // Generated from `System.ComponentModel.UInt32Converter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UInt32Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt32Converter() => throw null;
        }

        // Generated from `System.ComponentModel.UInt64Converter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class UInt64Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt64Converter() => throw null;
        }

        // Generated from `System.ComponentModel.VersionConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class VersionConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public VersionConverter() => throw null;
        }

        // Generated from `System.ComponentModel.WarningException` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class WarningException : System.SystemException
        {
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public string HelpTopic { get => throw null; }
            public string HelpUrl { get => throw null; }
            public WarningException() => throw null;
            protected WarningException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public WarningException(string message) => throw null;
            public WarningException(string message, System.Exception innerException) => throw null;
            public WarningException(string message, string helpUrl) => throw null;
            public WarningException(string message, string helpUrl, string helpTopic) => throw null;
        }

        namespace Design
        {
            // Generated from `System.ComponentModel.Design.ActiveDesignerEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ActiveDesignerEventArgs : System.EventArgs
            {
                public ActiveDesignerEventArgs(System.ComponentModel.Design.IDesignerHost oldDesigner, System.ComponentModel.Design.IDesignerHost newDesigner) => throw null;
                public System.ComponentModel.Design.IDesignerHost NewDesigner { get => throw null; }
                public System.ComponentModel.Design.IDesignerHost OldDesigner { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.ActiveDesignerEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void ActiveDesignerEventHandler(object sender, System.ComponentModel.Design.ActiveDesignerEventArgs e);

            // Generated from `System.ComponentModel.Design.CheckoutException` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CheckoutException : System.Runtime.InteropServices.ExternalException
            {
                public static System.ComponentModel.Design.CheckoutException Canceled;
                public CheckoutException() => throw null;
                protected CheckoutException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CheckoutException(string message) => throw null;
                public CheckoutException(string message, System.Exception innerException) => throw null;
                public CheckoutException(string message, int errorCode) => throw null;
            }

            // Generated from `System.ComponentModel.Design.CommandID` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CommandID
            {
                public CommandID(System.Guid menuGroup, int commandID) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public virtual System.Guid Guid { get => throw null; }
                public virtual int ID { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.ComponentModel.Design.ComponentChangedEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComponentChangedEventArgs : System.EventArgs
            {
                public object Component { get => throw null; }
                public ComponentChangedEventArgs(object component, System.ComponentModel.MemberDescriptor member, object oldValue, object newValue) => throw null;
                public System.ComponentModel.MemberDescriptor Member { get => throw null; }
                public object NewValue { get => throw null; }
                public object OldValue { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.ComponentChangedEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void ComponentChangedEventHandler(object sender, System.ComponentModel.Design.ComponentChangedEventArgs e);

            // Generated from `System.ComponentModel.Design.ComponentChangingEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComponentChangingEventArgs : System.EventArgs
            {
                public object Component { get => throw null; }
                public ComponentChangingEventArgs(object component, System.ComponentModel.MemberDescriptor member) => throw null;
                public System.ComponentModel.MemberDescriptor Member { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.ComponentChangingEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void ComponentChangingEventHandler(object sender, System.ComponentModel.Design.ComponentChangingEventArgs e);

            // Generated from `System.ComponentModel.Design.ComponentEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComponentEventArgs : System.EventArgs
            {
                public virtual System.ComponentModel.IComponent Component { get => throw null; }
                public ComponentEventArgs(System.ComponentModel.IComponent component) => throw null;
            }

            // Generated from `System.ComponentModel.Design.ComponentEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void ComponentEventHandler(object sender, System.ComponentModel.Design.ComponentEventArgs e);

            // Generated from `System.ComponentModel.Design.ComponentRenameEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ComponentRenameEventArgs : System.EventArgs
            {
                public object Component { get => throw null; }
                public ComponentRenameEventArgs(object component, string oldName, string newName) => throw null;
                public virtual string NewName { get => throw null; }
                public virtual string OldName { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.ComponentRenameEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void ComponentRenameEventHandler(object sender, System.ComponentModel.Design.ComponentRenameEventArgs e);

            // Generated from `System.ComponentModel.Design.DesignerCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesignerCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                int System.Collections.ICollection.Count { get => throw null; }
                public DesignerCollection(System.ComponentModel.Design.IDesignerHost[] designers) => throw null;
                public DesignerCollection(System.Collections.IList designers) => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public virtual System.ComponentModel.Design.IDesignerHost this[int index] { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.DesignerEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesignerEventArgs : System.EventArgs
            {
                public System.ComponentModel.Design.IDesignerHost Designer { get => throw null; }
                public DesignerEventArgs(System.ComponentModel.Design.IDesignerHost host) => throw null;
            }

            // Generated from `System.ComponentModel.Design.DesignerEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void DesignerEventHandler(object sender, System.ComponentModel.Design.DesignerEventArgs e);

            // Generated from `System.ComponentModel.Design.DesignerOptionService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DesignerOptionService : System.ComponentModel.Design.IDesignerOptionService
            {
                // Generated from `System.ComponentModel.Design.DesignerOptionService+DesignerOptionCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DesignerOptionCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
                {
                    int System.Collections.IList.Add(object value) => throw null;
                    void System.Collections.IList.Clear() => throw null;
                    bool System.Collections.IList.Contains(object value) => throw null;
                    public void CopyTo(System.Array array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.IEnumerator GetEnumerator() => throw null;
                    public int IndexOf(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection value) => throw null;
                    int System.Collections.IList.IndexOf(object value) => throw null;
                    void System.Collections.IList.Insert(int index, object value) => throw null;
                    bool System.Collections.IList.IsFixedSize { get => throw null; }
                    bool System.Collections.IList.IsReadOnly { get => throw null; }
                    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                    public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection this[int index] { get => throw null; }
                    object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                    public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection this[string name] { get => throw null; }
                    public string Name { get => throw null; }
                    public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection Parent { get => throw null; }
                    public System.ComponentModel.PropertyDescriptorCollection Properties { get => throw null; }
                    void System.Collections.IList.Remove(object value) => throw null;
                    void System.Collections.IList.RemoveAt(int index) => throw null;
                    public bool ShowDialog() => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                }


                protected System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection CreateOptionCollection(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection parent, string name, object value) => throw null;
                protected DesignerOptionService() => throw null;
                object System.ComponentModel.Design.IDesignerOptionService.GetOptionValue(string pageName, string valueName) => throw null;
                public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection Options { get => throw null; }
                protected virtual void PopulateOptionCollection(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection options) => throw null;
                void System.ComponentModel.Design.IDesignerOptionService.SetOptionValue(string pageName, string valueName, object value) => throw null;
                protected virtual bool ShowDialog(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection options, object optionObject) => throw null;
            }

            // Generated from `System.ComponentModel.Design.DesignerTransaction` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class DesignerTransaction : System.IDisposable
            {
                public void Cancel() => throw null;
                public bool Canceled { get => throw null; }
                public void Commit() => throw null;
                public bool Committed { get => throw null; }
                public string Description { get => throw null; }
                protected DesignerTransaction() => throw null;
                protected DesignerTransaction(string description) => throw null;
                void System.IDisposable.Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                protected abstract void OnCancel();
                protected abstract void OnCommit();
                // ERR: Stub generator didn't handle member: ~DesignerTransaction
            }

            // Generated from `System.ComponentModel.Design.DesignerTransactionCloseEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesignerTransactionCloseEventArgs : System.EventArgs
            {
                public DesignerTransactionCloseEventArgs(bool commit) => throw null;
                public DesignerTransactionCloseEventArgs(bool commit, bool lastTransaction) => throw null;
                public bool LastTransaction { get => throw null; }
                public bool TransactionCommitted { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.DesignerTransactionCloseEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate void DesignerTransactionCloseEventHandler(object sender, System.ComponentModel.Design.DesignerTransactionCloseEventArgs e);

            // Generated from `System.ComponentModel.Design.DesignerVerb` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesignerVerb : System.ComponentModel.Design.MenuCommand
            {
                public string Description { get => throw null; set => throw null; }
                public DesignerVerb(string text, System.EventHandler handler) : base(default(System.EventHandler), default(System.ComponentModel.Design.CommandID)) => throw null;
                public DesignerVerb(string text, System.EventHandler handler, System.ComponentModel.Design.CommandID startCommandID) : base(default(System.EventHandler), default(System.ComponentModel.Design.CommandID)) => throw null;
                public string Text { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.ComponentModel.Design.DesignerVerbCollection` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesignerVerbCollection : System.Collections.CollectionBase
            {
                public int Add(System.ComponentModel.Design.DesignerVerb value) => throw null;
                public void AddRange(System.ComponentModel.Design.DesignerVerbCollection value) => throw null;
                public void AddRange(System.ComponentModel.Design.DesignerVerb[] value) => throw null;
                public bool Contains(System.ComponentModel.Design.DesignerVerb value) => throw null;
                public void CopyTo(System.ComponentModel.Design.DesignerVerb[] array, int index) => throw null;
                public DesignerVerbCollection() => throw null;
                public DesignerVerbCollection(System.ComponentModel.Design.DesignerVerb[] value) => throw null;
                public int IndexOf(System.ComponentModel.Design.DesignerVerb value) => throw null;
                public void Insert(int index, System.ComponentModel.Design.DesignerVerb value) => throw null;
                public System.ComponentModel.Design.DesignerVerb this[int index] { get => throw null; set => throw null; }
                protected override void OnClear() => throw null;
                protected override void OnInsert(int index, object value) => throw null;
                protected override void OnRemove(int index, object value) => throw null;
                protected override void OnSet(int index, object oldValue, object newValue) => throw null;
                protected override void OnValidate(object value) => throw null;
                public void Remove(System.ComponentModel.Design.DesignerVerb value) => throw null;
            }

            // Generated from `System.ComponentModel.Design.DesigntimeLicenseContext` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesigntimeLicenseContext : System.ComponentModel.LicenseContext
            {
                public DesigntimeLicenseContext() => throw null;
                public override string GetSavedLicenseKey(System.Type type, System.Reflection.Assembly resourceAssembly) => throw null;
                public override void SetSavedLicenseKey(System.Type type, string key) => throw null;
                public override System.ComponentModel.LicenseUsageMode UsageMode { get => throw null; }
            }

            // Generated from `System.ComponentModel.Design.DesigntimeLicenseContextSerializer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesigntimeLicenseContextSerializer
            {
                public static void Serialize(System.IO.Stream o, string cryptoKey, System.ComponentModel.Design.DesigntimeLicenseContext context) => throw null;
            }

            // Generated from `System.ComponentModel.Design.HelpContextType` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HelpContextType
            {
                Ambient,
                Selection,
                ToolWindowSelection,
                Window,
            }

            // Generated from `System.ComponentModel.Design.HelpKeywordAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class HelpKeywordAttribute : System.Attribute
            {
                public static System.ComponentModel.Design.HelpKeywordAttribute Default;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string HelpKeyword { get => throw null; }
                public HelpKeywordAttribute() => throw null;
                public HelpKeywordAttribute(System.Type t) => throw null;
                public HelpKeywordAttribute(string keyword) => throw null;
                public override bool IsDefaultAttribute() => throw null;
            }

            // Generated from `System.ComponentModel.Design.HelpKeywordType` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HelpKeywordType
            {
                F1Keyword,
                FilterKeyword,
                GeneralKeyword,
            }

            // Generated from `System.ComponentModel.Design.IComponentChangeService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IComponentChangeService
            {
                event System.ComponentModel.Design.ComponentEventHandler ComponentAdded;
                event System.ComponentModel.Design.ComponentEventHandler ComponentAdding;
                event System.ComponentModel.Design.ComponentChangedEventHandler ComponentChanged;
                event System.ComponentModel.Design.ComponentChangingEventHandler ComponentChanging;
                event System.ComponentModel.Design.ComponentEventHandler ComponentRemoved;
                event System.ComponentModel.Design.ComponentEventHandler ComponentRemoving;
                event System.ComponentModel.Design.ComponentRenameEventHandler ComponentRename;
                void OnComponentChanged(object component, System.ComponentModel.MemberDescriptor member, object oldValue, object newValue);
                void OnComponentChanging(object component, System.ComponentModel.MemberDescriptor member);
            }

            // Generated from `System.ComponentModel.Design.IComponentDiscoveryService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IComponentDiscoveryService
            {
                System.Collections.ICollection GetComponentTypes(System.ComponentModel.Design.IDesignerHost designerHost, System.Type baseType);
            }

            // Generated from `System.ComponentModel.Design.IComponentInitializer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IComponentInitializer
            {
                void InitializeExistingComponent(System.Collections.IDictionary defaultValues);
                void InitializeNewComponent(System.Collections.IDictionary defaultValues);
            }

            // Generated from `System.ComponentModel.Design.IDesigner` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDesigner : System.IDisposable
            {
                System.ComponentModel.IComponent Component { get; }
                void DoDefaultAction();
                void Initialize(System.ComponentModel.IComponent component);
                System.ComponentModel.Design.DesignerVerbCollection Verbs { get; }
            }

            // Generated from `System.ComponentModel.Design.IDesignerEventService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDesignerEventService
            {
                System.ComponentModel.Design.IDesignerHost ActiveDesigner { get; }
                event System.ComponentModel.Design.ActiveDesignerEventHandler ActiveDesignerChanged;
                event System.ComponentModel.Design.DesignerEventHandler DesignerCreated;
                event System.ComponentModel.Design.DesignerEventHandler DesignerDisposed;
                System.ComponentModel.Design.DesignerCollection Designers { get; }
                event System.EventHandler SelectionChanged;
            }

            // Generated from `System.ComponentModel.Design.IDesignerFilter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDesignerFilter
            {
                void PostFilterAttributes(System.Collections.IDictionary attributes);
                void PostFilterEvents(System.Collections.IDictionary events);
                void PostFilterProperties(System.Collections.IDictionary properties);
                void PreFilterAttributes(System.Collections.IDictionary attributes);
                void PreFilterEvents(System.Collections.IDictionary events);
                void PreFilterProperties(System.Collections.IDictionary properties);
            }

            // Generated from `System.ComponentModel.Design.IDesignerHost` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDesignerHost : System.ComponentModel.Design.IServiceContainer, System.IServiceProvider
            {
                void Activate();
                event System.EventHandler Activated;
                System.ComponentModel.IContainer Container { get; }
                System.ComponentModel.IComponent CreateComponent(System.Type componentClass);
                System.ComponentModel.IComponent CreateComponent(System.Type componentClass, string name);
                System.ComponentModel.Design.DesignerTransaction CreateTransaction();
                System.ComponentModel.Design.DesignerTransaction CreateTransaction(string description);
                event System.EventHandler Deactivated;
                void DestroyComponent(System.ComponentModel.IComponent component);
                System.ComponentModel.Design.IDesigner GetDesigner(System.ComponentModel.IComponent component);
                System.Type GetType(string typeName);
                bool InTransaction { get; }
                event System.EventHandler LoadComplete;
                bool Loading { get; }
                System.ComponentModel.IComponent RootComponent { get; }
                string RootComponentClassName { get; }
                event System.ComponentModel.Design.DesignerTransactionCloseEventHandler TransactionClosed;
                event System.ComponentModel.Design.DesignerTransactionCloseEventHandler TransactionClosing;
                string TransactionDescription { get; }
                event System.EventHandler TransactionOpened;
                event System.EventHandler TransactionOpening;
            }

            // Generated from `System.ComponentModel.Design.IDesignerHostTransactionState` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDesignerHostTransactionState
            {
                bool IsClosingTransaction { get; }
            }

            // Generated from `System.ComponentModel.Design.IDesignerOptionService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDesignerOptionService
            {
                object GetOptionValue(string pageName, string valueName);
                void SetOptionValue(string pageName, string valueName, object value);
            }

            // Generated from `System.ComponentModel.Design.IDictionaryService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IDictionaryService
            {
                object GetKey(object value);
                object GetValue(object key);
                void SetValue(object key, object value);
            }

            // Generated from `System.ComponentModel.Design.IEventBindingService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IEventBindingService
            {
                string CreateUniqueMethodName(System.ComponentModel.IComponent component, System.ComponentModel.EventDescriptor e);
                System.Collections.ICollection GetCompatibleMethods(System.ComponentModel.EventDescriptor e);
                System.ComponentModel.EventDescriptor GetEvent(System.ComponentModel.PropertyDescriptor property);
                System.ComponentModel.PropertyDescriptorCollection GetEventProperties(System.ComponentModel.EventDescriptorCollection events);
                System.ComponentModel.PropertyDescriptor GetEventProperty(System.ComponentModel.EventDescriptor e);
                bool ShowCode();
                bool ShowCode(System.ComponentModel.IComponent component, System.ComponentModel.EventDescriptor e);
                bool ShowCode(int lineNumber);
            }

            // Generated from `System.ComponentModel.Design.IExtenderListService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IExtenderListService
            {
                System.ComponentModel.IExtenderProvider[] GetExtenderProviders();
            }

            // Generated from `System.ComponentModel.Design.IExtenderProviderService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IExtenderProviderService
            {
                void AddExtenderProvider(System.ComponentModel.IExtenderProvider provider);
                void RemoveExtenderProvider(System.ComponentModel.IExtenderProvider provider);
            }

            // Generated from `System.ComponentModel.Design.IHelpService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IHelpService
            {
                void AddContextAttribute(string name, string value, System.ComponentModel.Design.HelpKeywordType keywordType);
                void ClearContextAttributes();
                System.ComponentModel.Design.IHelpService CreateLocalContext(System.ComponentModel.Design.HelpContextType contextType);
                void RemoveContextAttribute(string name, string value);
                void RemoveLocalContext(System.ComponentModel.Design.IHelpService localContext);
                void ShowHelpFromKeyword(string helpKeyword);
                void ShowHelpFromUrl(string helpUrl);
            }

            // Generated from `System.ComponentModel.Design.IInheritanceService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IInheritanceService
            {
                void AddInheritedComponents(System.ComponentModel.IComponent component, System.ComponentModel.IContainer container);
                System.ComponentModel.InheritanceAttribute GetInheritanceAttribute(System.ComponentModel.IComponent component);
            }

            // Generated from `System.ComponentModel.Design.IMenuCommandService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IMenuCommandService
            {
                void AddCommand(System.ComponentModel.Design.MenuCommand command);
                void AddVerb(System.ComponentModel.Design.DesignerVerb verb);
                System.ComponentModel.Design.MenuCommand FindCommand(System.ComponentModel.Design.CommandID commandID);
                bool GlobalInvoke(System.ComponentModel.Design.CommandID commandID);
                void RemoveCommand(System.ComponentModel.Design.MenuCommand command);
                void RemoveVerb(System.ComponentModel.Design.DesignerVerb verb);
                void ShowContextMenu(System.ComponentModel.Design.CommandID menuID, int x, int y);
                System.ComponentModel.Design.DesignerVerbCollection Verbs { get; }
            }

            // Generated from `System.ComponentModel.Design.IReferenceService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IReferenceService
            {
                System.ComponentModel.IComponent GetComponent(object reference);
                string GetName(object reference);
                object GetReference(string name);
                object[] GetReferences();
                object[] GetReferences(System.Type baseType);
            }

            // Generated from `System.ComponentModel.Design.IResourceService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IResourceService
            {
                System.Resources.IResourceReader GetResourceReader(System.Globalization.CultureInfo info);
                System.Resources.IResourceWriter GetResourceWriter(System.Globalization.CultureInfo info);
            }

            // Generated from `System.ComponentModel.Design.IRootDesigner` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IRootDesigner : System.ComponentModel.Design.IDesigner, System.IDisposable
            {
                object GetView(System.ComponentModel.Design.ViewTechnology technology);
                System.ComponentModel.Design.ViewTechnology[] SupportedTechnologies { get; }
            }

            // Generated from `System.ComponentModel.Design.ISelectionService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISelectionService
            {
                bool GetComponentSelected(object component);
                System.Collections.ICollection GetSelectedComponents();
                object PrimarySelection { get; }
                event System.EventHandler SelectionChanged;
                event System.EventHandler SelectionChanging;
                int SelectionCount { get; }
                void SetSelectedComponents(System.Collections.ICollection components);
                void SetSelectedComponents(System.Collections.ICollection components, System.ComponentModel.Design.SelectionTypes selectionType);
            }

            // Generated from `System.ComponentModel.Design.IServiceContainer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IServiceContainer : System.IServiceProvider
            {
                void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback);
                void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback, bool promote);
                void AddService(System.Type serviceType, object serviceInstance);
                void AddService(System.Type serviceType, object serviceInstance, bool promote);
                void RemoveService(System.Type serviceType);
                void RemoveService(System.Type serviceType, bool promote);
            }

            // Generated from `System.ComponentModel.Design.ITreeDesigner` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ITreeDesigner : System.ComponentModel.Design.IDesigner, System.IDisposable
            {
                System.Collections.ICollection Children { get; }
                System.ComponentModel.Design.IDesigner Parent { get; }
            }

            // Generated from `System.ComponentModel.Design.ITypeDescriptorFilterService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ITypeDescriptorFilterService
            {
                bool FilterAttributes(System.ComponentModel.IComponent component, System.Collections.IDictionary attributes);
                bool FilterEvents(System.ComponentModel.IComponent component, System.Collections.IDictionary events);
                bool FilterProperties(System.ComponentModel.IComponent component, System.Collections.IDictionary properties);
            }

            // Generated from `System.ComponentModel.Design.ITypeDiscoveryService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ITypeDiscoveryService
            {
                System.Collections.ICollection GetTypes(System.Type baseType, bool excludeGlobalTypes);
            }

            // Generated from `System.ComponentModel.Design.ITypeResolutionService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ITypeResolutionService
            {
                System.Reflection.Assembly GetAssembly(System.Reflection.AssemblyName name);
                System.Reflection.Assembly GetAssembly(System.Reflection.AssemblyName name, bool throwOnError);
                string GetPathOfAssembly(System.Reflection.AssemblyName name);
                System.Type GetType(string name);
                System.Type GetType(string name, bool throwOnError);
                System.Type GetType(string name, bool throwOnError, bool ignoreCase);
                void ReferenceAssembly(System.Reflection.AssemblyName name);
            }

            // Generated from `System.ComponentModel.Design.MenuCommand` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MenuCommand
            {
                public virtual bool Checked { get => throw null; set => throw null; }
                public event System.EventHandler CommandChanged;
                public virtual System.ComponentModel.Design.CommandID CommandID { get => throw null; }
                public virtual bool Enabled { get => throw null; set => throw null; }
                public virtual void Invoke() => throw null;
                public virtual void Invoke(object arg) => throw null;
                public MenuCommand(System.EventHandler handler, System.ComponentModel.Design.CommandID command) => throw null;
                public virtual int OleStatus { get => throw null; }
                protected virtual void OnCommandChanged(System.EventArgs e) => throw null;
                public virtual System.Collections.IDictionary Properties { get => throw null; }
                public virtual bool Supported { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public virtual bool Visible { get => throw null; set => throw null; }
            }

            // Generated from `System.ComponentModel.Design.SelectionTypes` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SelectionTypes
            {
                Add,
                Auto,
                Click,
                MouseDown,
                MouseUp,
                Normal,
                Primary,
                Remove,
                Replace,
                Toggle,
                Valid,
            }

            // Generated from `System.ComponentModel.Design.ServiceContainer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ServiceContainer : System.ComponentModel.Design.IServiceContainer, System.IDisposable, System.IServiceProvider
            {
                public void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback) => throw null;
                public virtual void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback, bool promote) => throw null;
                public void AddService(System.Type serviceType, object serviceInstance) => throw null;
                public virtual void AddService(System.Type serviceType, object serviceInstance, bool promote) => throw null;
                protected virtual System.Type[] DefaultServices { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual object GetService(System.Type serviceType) => throw null;
                public void RemoveService(System.Type serviceType) => throw null;
                public virtual void RemoveService(System.Type serviceType, bool promote) => throw null;
                public ServiceContainer() => throw null;
                public ServiceContainer(System.IServiceProvider parentProvider) => throw null;
            }

            // Generated from `System.ComponentModel.Design.ServiceCreatorCallback` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public delegate object ServiceCreatorCallback(System.ComponentModel.Design.IServiceContainer container, System.Type serviceType);

            // Generated from `System.ComponentModel.Design.StandardCommands` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StandardCommands
            {
                public static System.ComponentModel.Design.CommandID AlignBottom;
                public static System.ComponentModel.Design.CommandID AlignHorizontalCenters;
                public static System.ComponentModel.Design.CommandID AlignLeft;
                public static System.ComponentModel.Design.CommandID AlignRight;
                public static System.ComponentModel.Design.CommandID AlignToGrid;
                public static System.ComponentModel.Design.CommandID AlignTop;
                public static System.ComponentModel.Design.CommandID AlignVerticalCenters;
                public static System.ComponentModel.Design.CommandID ArrangeBottom;
                public static System.ComponentModel.Design.CommandID ArrangeIcons;
                public static System.ComponentModel.Design.CommandID ArrangeRight;
                public static System.ComponentModel.Design.CommandID BringForward;
                public static System.ComponentModel.Design.CommandID BringToFront;
                public static System.ComponentModel.Design.CommandID CenterHorizontally;
                public static System.ComponentModel.Design.CommandID CenterVertically;
                public static System.ComponentModel.Design.CommandID Copy;
                public static System.ComponentModel.Design.CommandID Cut;
                public static System.ComponentModel.Design.CommandID Delete;
                public static System.ComponentModel.Design.CommandID DocumentOutline;
                public static System.ComponentModel.Design.CommandID F1Help;
                public static System.ComponentModel.Design.CommandID Group;
                public static System.ComponentModel.Design.CommandID HorizSpaceConcatenate;
                public static System.ComponentModel.Design.CommandID HorizSpaceDecrease;
                public static System.ComponentModel.Design.CommandID HorizSpaceIncrease;
                public static System.ComponentModel.Design.CommandID HorizSpaceMakeEqual;
                public static System.ComponentModel.Design.CommandID LineupIcons;
                public static System.ComponentModel.Design.CommandID LockControls;
                public static System.ComponentModel.Design.CommandID MultiLevelRedo;
                public static System.ComponentModel.Design.CommandID MultiLevelUndo;
                public static System.ComponentModel.Design.CommandID Paste;
                public static System.ComponentModel.Design.CommandID Properties;
                public static System.ComponentModel.Design.CommandID PropertiesWindow;
                public static System.ComponentModel.Design.CommandID Redo;
                public static System.ComponentModel.Design.CommandID Replace;
                public static System.ComponentModel.Design.CommandID SelectAll;
                public static System.ComponentModel.Design.CommandID SendBackward;
                public static System.ComponentModel.Design.CommandID SendToBack;
                public static System.ComponentModel.Design.CommandID ShowGrid;
                public static System.ComponentModel.Design.CommandID ShowLargeIcons;
                public static System.ComponentModel.Design.CommandID SizeToControl;
                public static System.ComponentModel.Design.CommandID SizeToControlHeight;
                public static System.ComponentModel.Design.CommandID SizeToControlWidth;
                public static System.ComponentModel.Design.CommandID SizeToFit;
                public static System.ComponentModel.Design.CommandID SizeToGrid;
                public static System.ComponentModel.Design.CommandID SnapToGrid;
                public StandardCommands() => throw null;
                public static System.ComponentModel.Design.CommandID TabOrder;
                public static System.ComponentModel.Design.CommandID Undo;
                public static System.ComponentModel.Design.CommandID Ungroup;
                public static System.ComponentModel.Design.CommandID VerbFirst;
                public static System.ComponentModel.Design.CommandID VerbLast;
                public static System.ComponentModel.Design.CommandID VertSpaceConcatenate;
                public static System.ComponentModel.Design.CommandID VertSpaceDecrease;
                public static System.ComponentModel.Design.CommandID VertSpaceIncrease;
                public static System.ComponentModel.Design.CommandID VertSpaceMakeEqual;
                public static System.ComponentModel.Design.CommandID ViewCode;
                public static System.ComponentModel.Design.CommandID ViewGrid;
            }

            // Generated from `System.ComponentModel.Design.StandardToolWindows` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StandardToolWindows
            {
                public static System.Guid ObjectBrowser;
                public static System.Guid OutputWindow;
                public static System.Guid ProjectExplorer;
                public static System.Guid PropertyBrowser;
                public static System.Guid RelatedLinks;
                public static System.Guid ServerExplorer;
                public StandardToolWindows() => throw null;
                public static System.Guid TaskList;
                public static System.Guid Toolbox;
            }

            // Generated from `System.ComponentModel.Design.TypeDescriptionProviderService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class TypeDescriptionProviderService
            {
                public abstract System.ComponentModel.TypeDescriptionProvider GetProvider(System.Type type);
                public abstract System.ComponentModel.TypeDescriptionProvider GetProvider(object instance);
                protected TypeDescriptionProviderService() => throw null;
            }

            // Generated from `System.ComponentModel.Design.ViewTechnology` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ViewTechnology
            {
                Default,
                Passthrough,
                WindowsForms,
            }

            namespace Serialization
            {
                // Generated from `System.ComponentModel.Design.Serialization.ComponentSerializationService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public abstract class ComponentSerializationService
                {
                    protected ComponentSerializationService() => throw null;
                    public abstract System.ComponentModel.Design.Serialization.SerializationStore CreateStore();
                    public abstract System.Collections.ICollection Deserialize(System.ComponentModel.Design.Serialization.SerializationStore store);
                    public abstract System.Collections.ICollection Deserialize(System.ComponentModel.Design.Serialization.SerializationStore store, System.ComponentModel.IContainer container);
                    public void DeserializeTo(System.ComponentModel.Design.Serialization.SerializationStore store, System.ComponentModel.IContainer container) => throw null;
                    public void DeserializeTo(System.ComponentModel.Design.Serialization.SerializationStore store, System.ComponentModel.IContainer container, bool validateRecycledTypes) => throw null;
                    public abstract void DeserializeTo(System.ComponentModel.Design.Serialization.SerializationStore store, System.ComponentModel.IContainer container, bool validateRecycledTypes, bool applyDefaults);
                    public abstract System.ComponentModel.Design.Serialization.SerializationStore LoadStore(System.IO.Stream stream);
                    public abstract void Serialize(System.ComponentModel.Design.Serialization.SerializationStore store, object value);
                    public abstract void SerializeAbsolute(System.ComponentModel.Design.Serialization.SerializationStore store, object value);
                    public abstract void SerializeMember(System.ComponentModel.Design.Serialization.SerializationStore store, object owningObject, System.ComponentModel.MemberDescriptor member);
                    public abstract void SerializeMemberAbsolute(System.ComponentModel.Design.Serialization.SerializationStore store, object owningObject, System.ComponentModel.MemberDescriptor member);
                }

                // Generated from `System.ComponentModel.Design.Serialization.ContextStack` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ContextStack
                {
                    public void Append(object context) => throw null;
                    public ContextStack() => throw null;
                    public object Current { get => throw null; }
                    public object this[System.Type type] { get => throw null; }
                    public object this[int level] { get => throw null; }
                    public object Pop() => throw null;
                    public void Push(object context) => throw null;
                }

                // Generated from `System.ComponentModel.Design.Serialization.DefaultSerializationProviderAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DefaultSerializationProviderAttribute : System.Attribute
                {
                    public DefaultSerializationProviderAttribute(System.Type providerType) => throw null;
                    public DefaultSerializationProviderAttribute(string providerTypeName) => throw null;
                    public string ProviderTypeName { get => throw null; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.DesignerLoader` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public abstract class DesignerLoader
                {
                    public abstract void BeginLoad(System.ComponentModel.Design.Serialization.IDesignerLoaderHost host);
                    protected DesignerLoader() => throw null;
                    public abstract void Dispose();
                    public virtual void Flush() => throw null;
                    public virtual bool Loading { get => throw null; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.IDesignerLoaderHost` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDesignerLoaderHost : System.ComponentModel.Design.IDesignerHost, System.ComponentModel.Design.IServiceContainer, System.IServiceProvider
                {
                    void EndLoad(string baseClassName, bool successful, System.Collections.ICollection errorCollection);
                    void Reload();
                }

                // Generated from `System.ComponentModel.Design.Serialization.IDesignerLoaderHost2` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDesignerLoaderHost2 : System.ComponentModel.Design.IDesignerHost, System.ComponentModel.Design.IServiceContainer, System.ComponentModel.Design.Serialization.IDesignerLoaderHost, System.IServiceProvider
                {
                    bool CanReloadWithErrors { get; set; }
                    bool IgnoreErrorsDuringReload { get; set; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.IDesignerLoaderService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDesignerLoaderService
                {
                    void AddLoadDependency();
                    void DependentLoadComplete(bool successful, System.Collections.ICollection errorCollection);
                    bool Reload();
                }

                // Generated from `System.ComponentModel.Design.Serialization.IDesignerSerializationManager` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDesignerSerializationManager : System.IServiceProvider
                {
                    void AddSerializationProvider(System.ComponentModel.Design.Serialization.IDesignerSerializationProvider provider);
                    System.ComponentModel.Design.Serialization.ContextStack Context { get; }
                    object CreateInstance(System.Type type, System.Collections.ICollection arguments, string name, bool addToContainer);
                    object GetInstance(string name);
                    string GetName(object value);
                    object GetSerializer(System.Type objectType, System.Type serializerType);
                    System.Type GetType(string typeName);
                    System.ComponentModel.PropertyDescriptorCollection Properties { get; }
                    void RemoveSerializationProvider(System.ComponentModel.Design.Serialization.IDesignerSerializationProvider provider);
                    void ReportError(object errorInformation);
                    event System.ComponentModel.Design.Serialization.ResolveNameEventHandler ResolveName;
                    event System.EventHandler SerializationComplete;
                    void SetName(object instance, string name);
                }

                // Generated from `System.ComponentModel.Design.Serialization.IDesignerSerializationProvider` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDesignerSerializationProvider
                {
                    object GetSerializer(System.ComponentModel.Design.Serialization.IDesignerSerializationManager manager, object currentSerializer, System.Type objectType, System.Type serializerType);
                }

                // Generated from `System.ComponentModel.Design.Serialization.IDesignerSerializationService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDesignerSerializationService
                {
                    System.Collections.ICollection Deserialize(object serializationData);
                    object Serialize(System.Collections.ICollection objects);
                }

                // Generated from `System.ComponentModel.Design.Serialization.INameCreationService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface INameCreationService
                {
                    string CreateName(System.ComponentModel.IContainer container, System.Type dataType);
                    bool IsValidName(string name);
                    void ValidateName(string name);
                }

                // Generated from `System.ComponentModel.Design.Serialization.InstanceDescriptor` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class InstanceDescriptor
                {
                    public System.Collections.ICollection Arguments { get => throw null; }
                    public InstanceDescriptor(System.Reflection.MemberInfo member, System.Collections.ICollection arguments) => throw null;
                    public InstanceDescriptor(System.Reflection.MemberInfo member, System.Collections.ICollection arguments, bool isComplete) => throw null;
                    public object Invoke() => throw null;
                    public bool IsComplete { get => throw null; }
                    public System.Reflection.MemberInfo MemberInfo { get => throw null; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.MemberRelationship` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct MemberRelationship
                {
                    public static bool operator !=(System.ComponentModel.Design.Serialization.MemberRelationship left, System.ComponentModel.Design.Serialization.MemberRelationship right) => throw null;
                    public static bool operator ==(System.ComponentModel.Design.Serialization.MemberRelationship left, System.ComponentModel.Design.Serialization.MemberRelationship right) => throw null;
                    public static System.ComponentModel.Design.Serialization.MemberRelationship Empty;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsEmpty { get => throw null; }
                    public System.ComponentModel.MemberDescriptor Member { get => throw null; }
                    // Stub generator skipped constructor 
                    public MemberRelationship(object owner, System.ComponentModel.MemberDescriptor member) => throw null;
                    public object Owner { get => throw null; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.MemberRelationshipService` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public abstract class MemberRelationshipService
                {
                    protected virtual System.ComponentModel.Design.Serialization.MemberRelationship GetRelationship(System.ComponentModel.Design.Serialization.MemberRelationship source) => throw null;
                    public System.ComponentModel.Design.Serialization.MemberRelationship this[System.ComponentModel.Design.Serialization.MemberRelationship source] { get => throw null; set => throw null; }
                    public System.ComponentModel.Design.Serialization.MemberRelationship this[object sourceOwner, System.ComponentModel.MemberDescriptor sourceMember] { get => throw null; set => throw null; }
                    protected MemberRelationshipService() => throw null;
                    protected virtual void SetRelationship(System.ComponentModel.Design.Serialization.MemberRelationship source, System.ComponentModel.Design.Serialization.MemberRelationship relationship) => throw null;
                    public abstract bool SupportsRelationship(System.ComponentModel.Design.Serialization.MemberRelationship source, System.ComponentModel.Design.Serialization.MemberRelationship relationship);
                }

                // Generated from `System.ComponentModel.Design.Serialization.ResolveNameEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ResolveNameEventArgs : System.EventArgs
                {
                    public string Name { get => throw null; }
                    public ResolveNameEventArgs(string name) => throw null;
                    public object Value { get => throw null; set => throw null; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.ResolveNameEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public delegate void ResolveNameEventHandler(object sender, System.ComponentModel.Design.Serialization.ResolveNameEventArgs e);

                // Generated from `System.ComponentModel.Design.Serialization.RootDesignerSerializerAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class RootDesignerSerializerAttribute : System.Attribute
                {
                    public bool Reloadable { get => throw null; }
                    public RootDesignerSerializerAttribute(System.Type serializerType, System.Type baseSerializerType, bool reloadable) => throw null;
                    public RootDesignerSerializerAttribute(string serializerTypeName, System.Type baseSerializerType, bool reloadable) => throw null;
                    public RootDesignerSerializerAttribute(string serializerTypeName, string baseSerializerTypeName, bool reloadable) => throw null;
                    public string SerializerBaseTypeName { get => throw null; }
                    public string SerializerTypeName { get => throw null; }
                    public override object TypeId { get => throw null; }
                }

                // Generated from `System.ComponentModel.Design.Serialization.SerializationStore` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public abstract class SerializationStore : System.IDisposable
                {
                    public abstract void Close();
                    void System.IDisposable.Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public abstract System.Collections.ICollection Errors { get; }
                    public abstract void Save(System.IO.Stream stream);
                    protected SerializationStore() => throw null;
                }

            }
        }
    }
    namespace Drawing
    {
        // Generated from `System.Drawing.ColorConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ColorConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public ColorConverter() => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }

        // Generated from `System.Drawing.PointConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PointConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public PointConverter() => throw null;
        }

        // Generated from `System.Drawing.RectangleConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RectangleConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public RectangleConverter() => throw null;
        }

        // Generated from `System.Drawing.SizeConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SizeConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public SizeConverter() => throw null;
        }

        // Generated from `System.Drawing.SizeFConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SizeFConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public SizeFConverter() => throw null;
        }

    }
    namespace Security
    {
        namespace Authentication
        {
            namespace ExtendedProtection
            {
                // Generated from `System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicyTypeConverter` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ExtendedProtectionPolicyTypeConverter : System.ComponentModel.TypeConverter
                {
                    public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
                    public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
                    public ExtendedProtectionPolicyTypeConverter() => throw null;
                }

            }
        }
    }
    namespace Timers
    {
        // Generated from `System.Timers.ElapsedEventArgs` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ElapsedEventArgs : System.EventArgs
        {
            public System.DateTime SignalTime { get => throw null; }
        }

        // Generated from `System.Timers.ElapsedEventHandler` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void ElapsedEventHandler(object sender, System.Timers.ElapsedEventArgs e);

        // Generated from `System.Timers.Timer` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Timer : System.ComponentModel.Component, System.ComponentModel.ISupportInitialize
        {
            public bool AutoReset { get => throw null; set => throw null; }
            public void BeginInit() => throw null;
            public void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public event System.Timers.ElapsedEventHandler Elapsed;
            public bool Enabled { get => throw null; set => throw null; }
            public void EndInit() => throw null;
            public double Interval { get => throw null; set => throw null; }
            public override System.ComponentModel.ISite Site { get => throw null; set => throw null; }
            public void Start() => throw null;
            public void Stop() => throw null;
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set => throw null; }
            public Timer() => throw null;
            public Timer(double interval) => throw null;
        }

        // Generated from `System.Timers.TimersDescriptionAttribute` in `System.ComponentModel.TypeConverter, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class TimersDescriptionAttribute : System.ComponentModel.DescriptionAttribute
        {
            public override string Description { get => throw null; }
            public TimersDescriptionAttribute(string description) => throw null;
        }

    }
}
