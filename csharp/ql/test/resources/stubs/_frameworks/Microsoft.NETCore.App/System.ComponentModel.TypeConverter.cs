// This file contains auto-generated code.
// Generated from `System.ComponentModel.TypeConverter, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace ComponentModel
    {
        public class AddingNewEventArgs : System.EventArgs
        {
            public AddingNewEventArgs() => throw null;
            public AddingNewEventArgs(object newObject) => throw null;
            public object NewObject { get => throw null; set { } }
        }
        public delegate void AddingNewEventHandler(object sender, System.ComponentModel.AddingNewEventArgs e);
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class AmbientValueAttribute : System.Attribute
        {
            public AmbientValueAttribute(bool value) => throw null;
            public AmbientValueAttribute(byte value) => throw null;
            public AmbientValueAttribute(char value) => throw null;
            public AmbientValueAttribute(double value) => throw null;
            public AmbientValueAttribute(short value) => throw null;
            public AmbientValueAttribute(int value) => throw null;
            public AmbientValueAttribute(long value) => throw null;
            public AmbientValueAttribute(object value) => throw null;
            public AmbientValueAttribute(float value) => throw null;
            public AmbientValueAttribute(string value) => throw null;
            public AmbientValueAttribute(System.Type type, string value) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public object Value { get => throw null; }
        }
        public class ArrayConverter : System.ComponentModel.CollectionConverter
        {
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public ArrayConverter() => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class AttributeCollection : System.Collections.ICollection, System.Collections.IEnumerable
        {
            protected virtual System.Attribute[] Attributes { get => throw null; }
            public bool Contains(System.Attribute attribute) => throw null;
            public bool Contains(System.Attribute[] attributes) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            protected AttributeCollection() => throw null;
            public AttributeCollection(params System.Attribute[] attributes) => throw null;
            public static readonly System.ComponentModel.AttributeCollection Empty;
            public static System.ComponentModel.AttributeCollection FromExisting(System.ComponentModel.AttributeCollection existing, params System.Attribute[] newAttributes) => throw null;
            protected System.Attribute GetDefaultAttribute(System.Type attributeType) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public bool Matches(System.Attribute attribute) => throw null;
            public bool Matches(System.Attribute[] attributes) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public virtual System.Attribute this[int index] { get => throw null; }
            public virtual System.Attribute this[System.Type attributeType] { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class AttributeProviderAttribute : System.Attribute
        {
            public AttributeProviderAttribute(string typeName) => throw null;
            public AttributeProviderAttribute(string typeName, string propertyName) => throw null;
            public AttributeProviderAttribute(System.Type type) => throw null;
            public string PropertyName { get => throw null; }
            public string TypeName { get => throw null; }
        }
        public abstract class BaseNumberConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class BindableAttribute : System.Attribute
        {
            public bool Bindable { get => throw null; }
            public BindableAttribute(bool bindable) => throw null;
            public BindableAttribute(bool bindable, System.ComponentModel.BindingDirection direction) => throw null;
            public BindableAttribute(System.ComponentModel.BindableSupport flags) => throw null;
            public BindableAttribute(System.ComponentModel.BindableSupport flags, System.ComponentModel.BindingDirection direction) => throw null;
            public static readonly System.ComponentModel.BindableAttribute Default;
            public System.ComponentModel.BindingDirection Direction { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.BindableAttribute No;
            public static readonly System.ComponentModel.BindableAttribute Yes;
        }
        public enum BindableSupport
        {
            No = 0,
            Yes = 1,
            Default = 2,
        }
        public enum BindingDirection
        {
            OneWay = 0,
            TwoWay = 1,
        }
        public class BindingList<T> : System.Collections.ObjectModel.Collection<T>, System.ComponentModel.IBindingList, System.ComponentModel.ICancelAddNew, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.ComponentModel.IRaiseItemChangedEvents
        {
            void System.ComponentModel.IBindingList.AddIndex(System.ComponentModel.PropertyDescriptor prop) => throw null;
            public event System.ComponentModel.AddingNewEventHandler AddingNew;
            public T AddNew() => throw null;
            object System.ComponentModel.IBindingList.AddNew() => throw null;
            protected virtual object AddNewCore() => throw null;
            public bool AllowEdit { get => throw null; set { } }
            bool System.ComponentModel.IBindingList.AllowEdit { get => throw null; }
            public bool AllowNew { get => throw null; set { } }
            bool System.ComponentModel.IBindingList.AllowNew { get => throw null; }
            public bool AllowRemove { get => throw null; set { } }
            bool System.ComponentModel.IBindingList.AllowRemove { get => throw null; }
            void System.ComponentModel.IBindingList.ApplySort(System.ComponentModel.PropertyDescriptor prop, System.ComponentModel.ListSortDirection direction) => throw null;
            protected virtual void ApplySortCore(System.ComponentModel.PropertyDescriptor prop, System.ComponentModel.ListSortDirection direction) => throw null;
            public virtual void CancelNew(int itemIndex) => throw null;
            protected override void ClearItems() => throw null;
            public BindingList() => throw null;
            public BindingList(System.Collections.Generic.IList<T> list) => throw null;
            public virtual void EndNew(int itemIndex) => throw null;
            int System.ComponentModel.IBindingList.Find(System.ComponentModel.PropertyDescriptor prop, object key) => throw null;
            protected virtual int FindCore(System.ComponentModel.PropertyDescriptor prop, object key) => throw null;
            protected override void InsertItem(int index, T item) => throw null;
            bool System.ComponentModel.IBindingList.IsSorted { get => throw null; }
            protected virtual bool IsSortedCore { get => throw null; }
            public event System.ComponentModel.ListChangedEventHandler ListChanged;
            protected virtual void OnAddingNew(System.ComponentModel.AddingNewEventArgs e) => throw null;
            protected virtual void OnListChanged(System.ComponentModel.ListChangedEventArgs e) => throw null;
            public bool RaiseListChangedEvents { get => throw null; set { } }
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
        public class BooleanConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public BooleanConverter() => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class ByteConverter : System.ComponentModel.BaseNumberConverter
        {
            public ByteConverter() => throw null;
        }
        public delegate void CancelEventHandler(object sender, System.ComponentModel.CancelEventArgs e);
        public class CharConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public CharConverter() => throw null;
        }
        public enum CollectionChangeAction
        {
            Add = 1,
            Remove = 2,
            Refresh = 3,
        }
        public class CollectionChangeEventArgs : System.EventArgs
        {
            public virtual System.ComponentModel.CollectionChangeAction Action { get => throw null; }
            public CollectionChangeEventArgs(System.ComponentModel.CollectionChangeAction action, object element) => throw null;
            public virtual object Element { get => throw null; }
        }
        public delegate void CollectionChangeEventHandler(object sender, System.ComponentModel.CollectionChangeEventArgs e);
        public class CollectionConverter : System.ComponentModel.TypeConverter
        {
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public CollectionConverter() => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class ComplexBindingPropertiesAttribute : System.Attribute
        {
            public ComplexBindingPropertiesAttribute() => throw null;
            public ComplexBindingPropertiesAttribute(string dataSource) => throw null;
            public ComplexBindingPropertiesAttribute(string dataSource, string dataMember) => throw null;
            public string DataMember { get => throw null; }
            public string DataSource { get => throw null; }
            public static readonly System.ComponentModel.ComplexBindingPropertiesAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
        }
        public class ComponentConverter : System.ComponentModel.ReferenceConverter
        {
            public ComponentConverter(System.Type type) : base(default(System.Type)) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public abstract class ComponentEditor
        {
            protected ComponentEditor() => throw null;
            public abstract bool EditComponent(System.ComponentModel.ITypeDescriptorContext context, object component);
            public bool EditComponent(object component) => throw null;
        }
        public class ComponentResourceManager : System.Resources.ResourceManager
        {
            public void ApplyResources(object value, string objectName) => throw null;
            public virtual void ApplyResources(object value, string objectName, System.Globalization.CultureInfo culture) => throw null;
            public ComponentResourceManager() => throw null;
            public ComponentResourceManager(System.Type t) => throw null;
        }
        public class Container : System.ComponentModel.IContainer, System.IDisposable
        {
            public virtual void Add(System.ComponentModel.IComponent component) => throw null;
            public virtual void Add(System.ComponentModel.IComponent component, string name) => throw null;
            public virtual System.ComponentModel.ComponentCollection Components { get => throw null; }
            protected virtual System.ComponentModel.ISite CreateSite(System.ComponentModel.IComponent component, string name) => throw null;
            public Container() => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected virtual object GetService(System.Type service) => throw null;
            public virtual void Remove(System.ComponentModel.IComponent component) => throw null;
            protected void RemoveWithoutUnsiting(System.ComponentModel.IComponent component) => throw null;
            protected virtual void ValidateName(System.ComponentModel.IComponent component, string name) => throw null;
        }
        public abstract class ContainerFilterService
        {
            protected ContainerFilterService() => throw null;
            public virtual System.ComponentModel.ComponentCollection FilterComponents(System.ComponentModel.ComponentCollection components) => throw null;
        }
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
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class DataObjectAttribute : System.Attribute
        {
            public DataObjectAttribute() => throw null;
            public DataObjectAttribute(bool isDataObject) => throw null;
            public static readonly System.ComponentModel.DataObjectAttribute DataObject;
            public static readonly System.ComponentModel.DataObjectAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsDataObject { get => throw null; }
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.DataObjectAttribute NonDataObject;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public sealed class DataObjectFieldAttribute : System.Attribute
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
        [System.AttributeUsage((System.AttributeTargets)64)]
        public sealed class DataObjectMethodAttribute : System.Attribute
        {
            public DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType methodType) => throw null;
            public DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType methodType, bool isDefault) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsDefault { get => throw null; }
            public override bool Match(object obj) => throw null;
            public System.ComponentModel.DataObjectMethodType MethodType { get => throw null; }
        }
        public enum DataObjectMethodType
        {
            Fill = 0,
            Select = 1,
            Update = 2,
            Insert = 3,
            Delete = 4,
        }
        public class DateOnlyConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DateOnlyConverter() => throw null;
        }
        public class DateTimeConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DateTimeConverter() => throw null;
        }
        public class DateTimeOffsetConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DateTimeOffsetConverter() => throw null;
        }
        public class DecimalConverter : System.ComponentModel.BaseNumberConverter
        {
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public DecimalConverter() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class DefaultBindingPropertyAttribute : System.Attribute
        {
            public DefaultBindingPropertyAttribute() => throw null;
            public DefaultBindingPropertyAttribute(string name) => throw null;
            public static readonly System.ComponentModel.DefaultBindingPropertyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class DefaultEventAttribute : System.Attribute
        {
            public DefaultEventAttribute(string name) => throw null;
            public static readonly System.ComponentModel.DefaultEventAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class DefaultPropertyAttribute : System.Attribute
        {
            public DefaultPropertyAttribute(string name) => throw null;
            public static readonly System.ComponentModel.DefaultPropertyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; }
        }
        namespace Design
        {
            public class ActiveDesignerEventArgs : System.EventArgs
            {
                public ActiveDesignerEventArgs(System.ComponentModel.Design.IDesignerHost oldDesigner, System.ComponentModel.Design.IDesignerHost newDesigner) => throw null;
                public System.ComponentModel.Design.IDesignerHost NewDesigner { get => throw null; }
                public System.ComponentModel.Design.IDesignerHost OldDesigner { get => throw null; }
            }
            public delegate void ActiveDesignerEventHandler(object sender, System.ComponentModel.Design.ActiveDesignerEventArgs e);
            public class CheckoutException : System.Runtime.InteropServices.ExternalException
            {
                public static readonly System.ComponentModel.Design.CheckoutException Canceled;
                public CheckoutException() => throw null;
                protected CheckoutException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public CheckoutException(string message) => throw null;
                public CheckoutException(string message, System.Exception innerException) => throw null;
                public CheckoutException(string message, int errorCode) => throw null;
            }
            public class CommandID
            {
                public CommandID(System.Guid menuGroup, int commandID) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public virtual System.Guid Guid { get => throw null; }
                public virtual int ID { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class ComponentChangedEventArgs : System.EventArgs
            {
                public object Component { get => throw null; }
                public ComponentChangedEventArgs(object component, System.ComponentModel.MemberDescriptor member, object oldValue, object newValue) => throw null;
                public System.ComponentModel.MemberDescriptor Member { get => throw null; }
                public object NewValue { get => throw null; }
                public object OldValue { get => throw null; }
            }
            public delegate void ComponentChangedEventHandler(object sender, System.ComponentModel.Design.ComponentChangedEventArgs e);
            public sealed class ComponentChangingEventArgs : System.EventArgs
            {
                public object Component { get => throw null; }
                public ComponentChangingEventArgs(object component, System.ComponentModel.MemberDescriptor member) => throw null;
                public System.ComponentModel.MemberDescriptor Member { get => throw null; }
            }
            public delegate void ComponentChangingEventHandler(object sender, System.ComponentModel.Design.ComponentChangingEventArgs e);
            public class ComponentEventArgs : System.EventArgs
            {
                public virtual System.ComponentModel.IComponent Component { get => throw null; }
                public ComponentEventArgs(System.ComponentModel.IComponent component) => throw null;
            }
            public delegate void ComponentEventHandler(object sender, System.ComponentModel.Design.ComponentEventArgs e);
            public class ComponentRenameEventArgs : System.EventArgs
            {
                public object Component { get => throw null; }
                public ComponentRenameEventArgs(object component, string oldName, string newName) => throw null;
                public virtual string NewName { get => throw null; }
                public virtual string OldName { get => throw null; }
            }
            public delegate void ComponentRenameEventHandler(object sender, System.ComponentModel.Design.ComponentRenameEventArgs e);
            public class DesignerCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                int System.Collections.ICollection.Count { get => throw null; }
                public DesignerCollection(System.Collections.IList designers) => throw null;
                public DesignerCollection(System.ComponentModel.Design.IDesignerHost[] designers) => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public virtual System.ComponentModel.Design.IDesignerHost this[int index] { get => throw null; }
            }
            public class DesignerEventArgs : System.EventArgs
            {
                public DesignerEventArgs(System.ComponentModel.Design.IDesignerHost host) => throw null;
                public System.ComponentModel.Design.IDesignerHost Designer { get => throw null; }
            }
            public delegate void DesignerEventHandler(object sender, System.ComponentModel.Design.DesignerEventArgs e);
            public abstract class DesignerOptionService : System.ComponentModel.Design.IDesignerOptionService
            {
                protected System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection CreateOptionCollection(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection parent, string name, object value) => throw null;
                protected DesignerOptionService() => throw null;
                public sealed class DesignerOptionCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
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
                    object System.Collections.IList.this[int index] { get => throw null; set { } }
                    public string Name { get => throw null; }
                    public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection Parent { get => throw null; }
                    public System.ComponentModel.PropertyDescriptorCollection Properties { get => throw null; }
                    void System.Collections.IList.Remove(object value) => throw null;
                    void System.Collections.IList.RemoveAt(int index) => throw null;
                    public bool ShowDialog() => throw null;
                    object System.Collections.ICollection.SyncRoot { get => throw null; }
                    public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection this[int index] { get => throw null; }
                    public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection this[string name] { get => throw null; }
                }
                object System.ComponentModel.Design.IDesignerOptionService.GetOptionValue(string pageName, string valueName) => throw null;
                public System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection Options { get => throw null; }
                protected virtual void PopulateOptionCollection(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection options) => throw null;
                void System.ComponentModel.Design.IDesignerOptionService.SetOptionValue(string pageName, string valueName, object value) => throw null;
                protected virtual bool ShowDialog(System.ComponentModel.Design.DesignerOptionService.DesignerOptionCollection options, object optionObject) => throw null;
            }
            public abstract class DesignerTransaction : System.IDisposable
            {
                public void Cancel() => throw null;
                public bool Canceled { get => throw null; }
                public void Commit() => throw null;
                public bool Committed { get => throw null; }
                protected DesignerTransaction() => throw null;
                protected DesignerTransaction(string description) => throw null;
                public string Description { get => throw null; }
                protected virtual void Dispose(bool disposing) => throw null;
                void System.IDisposable.Dispose() => throw null;
                protected abstract void OnCancel();
                protected abstract void OnCommit();
            }
            public class DesignerTransactionCloseEventArgs : System.EventArgs
            {
                public DesignerTransactionCloseEventArgs(bool commit) => throw null;
                public DesignerTransactionCloseEventArgs(bool commit, bool lastTransaction) => throw null;
                public bool LastTransaction { get => throw null; }
                public bool TransactionCommitted { get => throw null; }
            }
            public delegate void DesignerTransactionCloseEventHandler(object sender, System.ComponentModel.Design.DesignerTransactionCloseEventArgs e);
            public class DesignerVerb : System.ComponentModel.Design.MenuCommand
            {
                public DesignerVerb(string text, System.EventHandler handler) : base(default(System.EventHandler), default(System.ComponentModel.Design.CommandID)) => throw null;
                public DesignerVerb(string text, System.EventHandler handler, System.ComponentModel.Design.CommandID startCommandID) : base(default(System.EventHandler), default(System.ComponentModel.Design.CommandID)) => throw null;
                public string Description { get => throw null; set { } }
                public string Text { get => throw null; }
                public override string ToString() => throw null;
            }
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
                protected override void OnValidate(object value) => throw null;
                public void Remove(System.ComponentModel.Design.DesignerVerb value) => throw null;
                public System.ComponentModel.Design.DesignerVerb this[int index] { get => throw null; set { } }
            }
            public class DesigntimeLicenseContext : System.ComponentModel.LicenseContext
            {
                public DesigntimeLicenseContext() => throw null;
                public override string GetSavedLicenseKey(System.Type type, System.Reflection.Assembly resourceAssembly) => throw null;
                public override void SetSavedLicenseKey(System.Type type, string key) => throw null;
                public override System.ComponentModel.LicenseUsageMode UsageMode { get => throw null; }
            }
            public class DesigntimeLicenseContextSerializer
            {
                public static void Serialize(System.IO.Stream o, string cryptoKey, System.ComponentModel.Design.DesigntimeLicenseContext context) => throw null;
            }
            public enum HelpContextType
            {
                Ambient = 0,
                Window = 1,
                Selection = 2,
                ToolWindowSelection = 3,
            }
            [System.AttributeUsage((System.AttributeTargets)32767, AllowMultiple = false, Inherited = false)]
            public sealed class HelpKeywordAttribute : System.Attribute
            {
                public HelpKeywordAttribute() => throw null;
                public HelpKeywordAttribute(string keyword) => throw null;
                public HelpKeywordAttribute(System.Type t) => throw null;
                public static readonly System.ComponentModel.Design.HelpKeywordAttribute Default;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string HelpKeyword { get => throw null; }
                public override bool IsDefaultAttribute() => throw null;
            }
            public enum HelpKeywordType
            {
                F1Keyword = 0,
                GeneralKeyword = 1,
                FilterKeyword = 2,
            }
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
            public interface IComponentDiscoveryService
            {
                System.Collections.ICollection GetComponentTypes(System.ComponentModel.Design.IDesignerHost designerHost, System.Type baseType);
            }
            public interface IComponentInitializer
            {
                void InitializeExistingComponent(System.Collections.IDictionary defaultValues);
                void InitializeNewComponent(System.Collections.IDictionary defaultValues);
            }
            public interface IDesigner : System.IDisposable
            {
                System.ComponentModel.IComponent Component { get; }
                void DoDefaultAction();
                void Initialize(System.ComponentModel.IComponent component);
                System.ComponentModel.Design.DesignerVerbCollection Verbs { get; }
            }
            public interface IDesignerEventService
            {
                System.ComponentModel.Design.IDesignerHost ActiveDesigner { get; }
                event System.ComponentModel.Design.ActiveDesignerEventHandler ActiveDesignerChanged;
                event System.ComponentModel.Design.DesignerEventHandler DesignerCreated;
                event System.ComponentModel.Design.DesignerEventHandler DesignerDisposed;
                System.ComponentModel.Design.DesignerCollection Designers { get; }
                event System.EventHandler SelectionChanged;
            }
            public interface IDesignerFilter
            {
                void PostFilterAttributes(System.Collections.IDictionary attributes);
                void PostFilterEvents(System.Collections.IDictionary events);
                void PostFilterProperties(System.Collections.IDictionary properties);
                void PreFilterAttributes(System.Collections.IDictionary attributes);
                void PreFilterEvents(System.Collections.IDictionary events);
                void PreFilterProperties(System.Collections.IDictionary properties);
            }
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
            public interface IDesignerHostTransactionState
            {
                bool IsClosingTransaction { get; }
            }
            public interface IDesignerOptionService
            {
                object GetOptionValue(string pageName, string valueName);
                void SetOptionValue(string pageName, string valueName, object value);
            }
            public interface IDictionaryService
            {
                object GetKey(object value);
                object GetValue(object key);
                void SetValue(object key, object value);
            }
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
            public interface IExtenderListService
            {
                System.ComponentModel.IExtenderProvider[] GetExtenderProviders();
            }
            public interface IExtenderProviderService
            {
                void AddExtenderProvider(System.ComponentModel.IExtenderProvider provider);
                void RemoveExtenderProvider(System.ComponentModel.IExtenderProvider provider);
            }
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
            public interface IInheritanceService
            {
                void AddInheritedComponents(System.ComponentModel.IComponent component, System.ComponentModel.IContainer container);
                System.ComponentModel.InheritanceAttribute GetInheritanceAttribute(System.ComponentModel.IComponent component);
            }
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
            public interface IReferenceService
            {
                System.ComponentModel.IComponent GetComponent(object reference);
                string GetName(object reference);
                object GetReference(string name);
                object[] GetReferences();
                object[] GetReferences(System.Type baseType);
            }
            public interface IResourceService
            {
                System.Resources.IResourceReader GetResourceReader(System.Globalization.CultureInfo info);
                System.Resources.IResourceWriter GetResourceWriter(System.Globalization.CultureInfo info);
            }
            public interface IRootDesigner : System.ComponentModel.Design.IDesigner, System.IDisposable
            {
                object GetView(System.ComponentModel.Design.ViewTechnology technology);
                System.ComponentModel.Design.ViewTechnology[] SupportedTechnologies { get; }
            }
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
            public interface IServiceContainer : System.IServiceProvider
            {
                void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback);
                void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback, bool promote);
                void AddService(System.Type serviceType, object serviceInstance);
                void AddService(System.Type serviceType, object serviceInstance, bool promote);
                void RemoveService(System.Type serviceType);
                void RemoveService(System.Type serviceType, bool promote);
            }
            public interface ITreeDesigner : System.ComponentModel.Design.IDesigner, System.IDisposable
            {
                System.Collections.ICollection Children { get; }
                System.ComponentModel.Design.IDesigner Parent { get; }
            }
            public interface ITypeDescriptorFilterService
            {
                bool FilterAttributes(System.ComponentModel.IComponent component, System.Collections.IDictionary attributes);
                bool FilterEvents(System.ComponentModel.IComponent component, System.Collections.IDictionary events);
                bool FilterProperties(System.ComponentModel.IComponent component, System.Collections.IDictionary properties);
            }
            public interface ITypeDiscoveryService
            {
                System.Collections.ICollection GetTypes(System.Type baseType, bool excludeGlobalTypes);
            }
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
            public class MenuCommand
            {
                public virtual bool Checked { get => throw null; set { } }
                public event System.EventHandler CommandChanged;
                public virtual System.ComponentModel.Design.CommandID CommandID { get => throw null; }
                public MenuCommand(System.EventHandler handler, System.ComponentModel.Design.CommandID command) => throw null;
                public virtual bool Enabled { get => throw null; set { } }
                public virtual void Invoke() => throw null;
                public virtual void Invoke(object arg) => throw null;
                public virtual int OleStatus { get => throw null; }
                protected virtual void OnCommandChanged(System.EventArgs e) => throw null;
                public virtual System.Collections.IDictionary Properties { get => throw null; }
                public virtual bool Supported { get => throw null; set { } }
                public override string ToString() => throw null;
                public virtual bool Visible { get => throw null; set { } }
            }
            [System.Flags]
            public enum SelectionTypes
            {
                Auto = 1,
                Normal = 1,
                Replace = 2,
                MouseDown = 4,
                MouseUp = 8,
                Click = 16,
                Primary = 16,
                Valid = 31,
                Toggle = 32,
                Add = 64,
                Remove = 128,
            }
            namespace Serialization
            {
                public abstract class ComponentSerializationService
                {
                    public abstract System.ComponentModel.Design.Serialization.SerializationStore CreateStore();
                    protected ComponentSerializationService() => throw null;
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
                public sealed class ContextStack
                {
                    public void Append(object context) => throw null;
                    public ContextStack() => throw null;
                    public object Current { get => throw null; }
                    public object Pop() => throw null;
                    public void Push(object context) => throw null;
                    public object this[int level] { get => throw null; }
                    public object this[System.Type type] { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)4, Inherited = false)]
                public sealed class DefaultSerializationProviderAttribute : System.Attribute
                {
                    public DefaultSerializationProviderAttribute(string providerTypeName) => throw null;
                    public DefaultSerializationProviderAttribute(System.Type providerType) => throw null;
                    public string ProviderTypeName { get => throw null; }
                }
                public abstract class DesignerLoader
                {
                    public abstract void BeginLoad(System.ComponentModel.Design.Serialization.IDesignerLoaderHost host);
                    protected DesignerLoader() => throw null;
                    public abstract void Dispose();
                    public virtual void Flush() => throw null;
                    public virtual bool Loading { get => throw null; }
                }
                public interface IDesignerLoaderHost : System.ComponentModel.Design.IDesignerHost, System.ComponentModel.Design.IServiceContainer, System.IServiceProvider
                {
                    void EndLoad(string baseClassName, bool successful, System.Collections.ICollection errorCollection);
                    void Reload();
                }
                public interface IDesignerLoaderHost2 : System.ComponentModel.Design.IDesignerHost, System.ComponentModel.Design.Serialization.IDesignerLoaderHost, System.ComponentModel.Design.IServiceContainer, System.IServiceProvider
                {
                    bool CanReloadWithErrors { get; set; }
                    bool IgnoreErrorsDuringReload { get; set; }
                }
                public interface IDesignerLoaderService
                {
                    void AddLoadDependency();
                    void DependentLoadComplete(bool successful, System.Collections.ICollection errorCollection);
                    bool Reload();
                }
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
                public interface IDesignerSerializationProvider
                {
                    object GetSerializer(System.ComponentModel.Design.Serialization.IDesignerSerializationManager manager, object currentSerializer, System.Type objectType, System.Type serializerType);
                }
                public interface IDesignerSerializationService
                {
                    System.Collections.ICollection Deserialize(object serializationData);
                    object Serialize(System.Collections.ICollection objects);
                }
                public interface INameCreationService
                {
                    string CreateName(System.ComponentModel.IContainer container, System.Type dataType);
                    bool IsValidName(string name);
                    void ValidateName(string name);
                }
                public sealed class InstanceDescriptor
                {
                    public System.Collections.ICollection Arguments { get => throw null; }
                    public InstanceDescriptor(System.Reflection.MemberInfo member, System.Collections.ICollection arguments) => throw null;
                    public InstanceDescriptor(System.Reflection.MemberInfo member, System.Collections.ICollection arguments, bool isComplete) => throw null;
                    public object Invoke() => throw null;
                    public bool IsComplete { get => throw null; }
                    public System.Reflection.MemberInfo MemberInfo { get => throw null; }
                }
                public struct MemberRelationship : System.IEquatable<System.ComponentModel.Design.Serialization.MemberRelationship>
                {
                    public MemberRelationship(object owner, System.ComponentModel.MemberDescriptor member) => throw null;
                    public static readonly System.ComponentModel.Design.Serialization.MemberRelationship Empty;
                    public bool Equals(System.ComponentModel.Design.Serialization.MemberRelationship other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsEmpty { get => throw null; }
                    public System.ComponentModel.MemberDescriptor Member { get => throw null; }
                    public static bool operator ==(System.ComponentModel.Design.Serialization.MemberRelationship left, System.ComponentModel.Design.Serialization.MemberRelationship right) => throw null;
                    public static bool operator !=(System.ComponentModel.Design.Serialization.MemberRelationship left, System.ComponentModel.Design.Serialization.MemberRelationship right) => throw null;
                    public object Owner { get => throw null; }
                }
                public abstract class MemberRelationshipService
                {
                    protected MemberRelationshipService() => throw null;
                    protected virtual System.ComponentModel.Design.Serialization.MemberRelationship GetRelationship(System.ComponentModel.Design.Serialization.MemberRelationship source) => throw null;
                    protected virtual void SetRelationship(System.ComponentModel.Design.Serialization.MemberRelationship source, System.ComponentModel.Design.Serialization.MemberRelationship relationship) => throw null;
                    public abstract bool SupportsRelationship(System.ComponentModel.Design.Serialization.MemberRelationship source, System.ComponentModel.Design.Serialization.MemberRelationship relationship);
                    public System.ComponentModel.Design.Serialization.MemberRelationship this[System.ComponentModel.Design.Serialization.MemberRelationship source] { get => throw null; set { } }
                    public System.ComponentModel.Design.Serialization.MemberRelationship this[object sourceOwner, System.ComponentModel.MemberDescriptor sourceMember] { get => throw null; set { } }
                }
                public class ResolveNameEventArgs : System.EventArgs
                {
                    public ResolveNameEventArgs(string name) => throw null;
                    public string Name { get => throw null; }
                    public object Value { get => throw null; set { } }
                }
                public delegate void ResolveNameEventHandler(object sender, System.ComponentModel.Design.Serialization.ResolveNameEventArgs e);
                [System.AttributeUsage((System.AttributeTargets)1028, AllowMultiple = true, Inherited = true)]
                public sealed class RootDesignerSerializerAttribute : System.Attribute
                {
                    public RootDesignerSerializerAttribute(string serializerTypeName, string baseSerializerTypeName, bool reloadable) => throw null;
                    public RootDesignerSerializerAttribute(string serializerTypeName, System.Type baseSerializerType, bool reloadable) => throw null;
                    public RootDesignerSerializerAttribute(System.Type serializerType, System.Type baseSerializerType, bool reloadable) => throw null;
                    public bool Reloadable { get => throw null; }
                    public string SerializerBaseTypeName { get => throw null; }
                    public string SerializerTypeName { get => throw null; }
                    public override object TypeId { get => throw null; }
                }
                public abstract class SerializationStore : System.IDisposable
                {
                    public abstract void Close();
                    protected SerializationStore() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    public abstract System.Collections.ICollection Errors { get; }
                    public abstract void Save(System.IO.Stream stream);
                }
            }
            public class ServiceContainer : System.IDisposable, System.ComponentModel.Design.IServiceContainer, System.IServiceProvider
            {
                public void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback) => throw null;
                public virtual void AddService(System.Type serviceType, System.ComponentModel.Design.ServiceCreatorCallback callback, bool promote) => throw null;
                public void AddService(System.Type serviceType, object serviceInstance) => throw null;
                public virtual void AddService(System.Type serviceType, object serviceInstance, bool promote) => throw null;
                public ServiceContainer() => throw null;
                public ServiceContainer(System.IServiceProvider parentProvider) => throw null;
                protected virtual System.Type[] DefaultServices { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual object GetService(System.Type serviceType) => throw null;
                public void RemoveService(System.Type serviceType) => throw null;
                public virtual void RemoveService(System.Type serviceType, bool promote) => throw null;
            }
            public delegate object ServiceCreatorCallback(System.ComponentModel.Design.IServiceContainer container, System.Type serviceType);
            public class StandardCommands
            {
                public static readonly System.ComponentModel.Design.CommandID AlignBottom;
                public static readonly System.ComponentModel.Design.CommandID AlignHorizontalCenters;
                public static readonly System.ComponentModel.Design.CommandID AlignLeft;
                public static readonly System.ComponentModel.Design.CommandID AlignRight;
                public static readonly System.ComponentModel.Design.CommandID AlignToGrid;
                public static readonly System.ComponentModel.Design.CommandID AlignTop;
                public static readonly System.ComponentModel.Design.CommandID AlignVerticalCenters;
                public static readonly System.ComponentModel.Design.CommandID ArrangeBottom;
                public static readonly System.ComponentModel.Design.CommandID ArrangeIcons;
                public static readonly System.ComponentModel.Design.CommandID ArrangeRight;
                public static readonly System.ComponentModel.Design.CommandID BringForward;
                public static readonly System.ComponentModel.Design.CommandID BringToFront;
                public static readonly System.ComponentModel.Design.CommandID CenterHorizontally;
                public static readonly System.ComponentModel.Design.CommandID CenterVertically;
                public static readonly System.ComponentModel.Design.CommandID Copy;
                public StandardCommands() => throw null;
                public static readonly System.ComponentModel.Design.CommandID Cut;
                public static readonly System.ComponentModel.Design.CommandID Delete;
                public static readonly System.ComponentModel.Design.CommandID DocumentOutline;
                public static readonly System.ComponentModel.Design.CommandID F1Help;
                public static readonly System.ComponentModel.Design.CommandID Group;
                public static readonly System.ComponentModel.Design.CommandID HorizSpaceConcatenate;
                public static readonly System.ComponentModel.Design.CommandID HorizSpaceDecrease;
                public static readonly System.ComponentModel.Design.CommandID HorizSpaceIncrease;
                public static readonly System.ComponentModel.Design.CommandID HorizSpaceMakeEqual;
                public static readonly System.ComponentModel.Design.CommandID LineupIcons;
                public static readonly System.ComponentModel.Design.CommandID LockControls;
                public static readonly System.ComponentModel.Design.CommandID MultiLevelRedo;
                public static readonly System.ComponentModel.Design.CommandID MultiLevelUndo;
                public static readonly System.ComponentModel.Design.CommandID Paste;
                public static readonly System.ComponentModel.Design.CommandID Properties;
                public static readonly System.ComponentModel.Design.CommandID PropertiesWindow;
                public static readonly System.ComponentModel.Design.CommandID Redo;
                public static readonly System.ComponentModel.Design.CommandID Replace;
                public static readonly System.ComponentModel.Design.CommandID SelectAll;
                public static readonly System.ComponentModel.Design.CommandID SendBackward;
                public static readonly System.ComponentModel.Design.CommandID SendToBack;
                public static readonly System.ComponentModel.Design.CommandID ShowGrid;
                public static readonly System.ComponentModel.Design.CommandID ShowLargeIcons;
                public static readonly System.ComponentModel.Design.CommandID SizeToControl;
                public static readonly System.ComponentModel.Design.CommandID SizeToControlHeight;
                public static readonly System.ComponentModel.Design.CommandID SizeToControlWidth;
                public static readonly System.ComponentModel.Design.CommandID SizeToFit;
                public static readonly System.ComponentModel.Design.CommandID SizeToGrid;
                public static readonly System.ComponentModel.Design.CommandID SnapToGrid;
                public static readonly System.ComponentModel.Design.CommandID TabOrder;
                public static readonly System.ComponentModel.Design.CommandID Undo;
                public static readonly System.ComponentModel.Design.CommandID Ungroup;
                public static readonly System.ComponentModel.Design.CommandID VerbFirst;
                public static readonly System.ComponentModel.Design.CommandID VerbLast;
                public static readonly System.ComponentModel.Design.CommandID VertSpaceConcatenate;
                public static readonly System.ComponentModel.Design.CommandID VertSpaceDecrease;
                public static readonly System.ComponentModel.Design.CommandID VertSpaceIncrease;
                public static readonly System.ComponentModel.Design.CommandID VertSpaceMakeEqual;
                public static readonly System.ComponentModel.Design.CommandID ViewCode;
                public static readonly System.ComponentModel.Design.CommandID ViewGrid;
            }
            public class StandardToolWindows
            {
                public StandardToolWindows() => throw null;
                public static readonly System.Guid ObjectBrowser;
                public static readonly System.Guid OutputWindow;
                public static readonly System.Guid ProjectExplorer;
                public static readonly System.Guid PropertyBrowser;
                public static readonly System.Guid RelatedLinks;
                public static readonly System.Guid ServerExplorer;
                public static readonly System.Guid TaskList;
                public static readonly System.Guid Toolbox;
            }
            public abstract class TypeDescriptionProviderService
            {
                protected TypeDescriptionProviderService() => throw null;
                public abstract System.ComponentModel.TypeDescriptionProvider GetProvider(object instance);
                public abstract System.ComponentModel.TypeDescriptionProvider GetProvider(System.Type type);
            }
            public enum ViewTechnology
            {
                Passthrough = 0,
                WindowsForms = 1,
                Default = 2,
            }
        }
        [System.AttributeUsage((System.AttributeTargets)1028)]
        public sealed class DesignTimeVisibleAttribute : System.Attribute
        {
            public DesignTimeVisibleAttribute() => throw null;
            public DesignTimeVisibleAttribute(bool visible) => throw null;
            public static readonly System.ComponentModel.DesignTimeVisibleAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.DesignTimeVisibleAttribute No;
            public bool Visible { get => throw null; }
            public static readonly System.ComponentModel.DesignTimeVisibleAttribute Yes;
        }
        public class DoubleConverter : System.ComponentModel.BaseNumberConverter
        {
            public DoubleConverter() => throw null;
        }
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
            protected System.ComponentModel.TypeConverter.StandardValuesCollection Values { get => throw null; set { } }
        }
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
            public EventDescriptorCollection(System.ComponentModel.EventDescriptor[] events) => throw null;
            public EventDescriptorCollection(System.ComponentModel.EventDescriptor[] events, bool readOnly) => throw null;
            public static readonly System.ComponentModel.EventDescriptorCollection Empty;
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
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            public void Remove(System.ComponentModel.EventDescriptor value) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            public void RemoveAt(int index) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort() => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort(System.Collections.IComparer comparer) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort(string[] names) => throw null;
            public virtual System.ComponentModel.EventDescriptorCollection Sort(string[] names, System.Collections.IComparer comparer) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public virtual System.ComponentModel.EventDescriptor this[int index] { get => throw null; }
            public virtual System.ComponentModel.EventDescriptor this[string name] { get => throw null; }
        }
        public class ExpandableObjectConverter : System.ComponentModel.TypeConverter
        {
            public ExpandableObjectConverter() => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class ExtenderProvidedPropertyAttribute : System.Attribute
        {
            public ExtenderProvidedPropertyAttribute() => throw null;
            public override bool Equals(object obj) => throw null;
            public System.ComponentModel.PropertyDescriptor ExtenderProperty { get => throw null; }
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public System.ComponentModel.IExtenderProvider Provider { get => throw null; }
            public System.Type ReceiverType { get => throw null; }
        }
        public class GuidConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public GuidConverter() => throw null;
        }
        public class HalfConverter : System.ComponentModel.BaseNumberConverter
        {
            public HalfConverter() => throw null;
        }
        public class HandledEventArgs : System.EventArgs
        {
            public HandledEventArgs() => throw null;
            public HandledEventArgs(bool defaultHandledValue) => throw null;
            public bool Handled { get => throw null; set { } }
        }
        public delegate void HandledEventHandler(object sender, System.ComponentModel.HandledEventArgs e);
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
        public interface IBindingListView : System.ComponentModel.IBindingList, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            void ApplySort(System.ComponentModel.ListSortDescriptionCollection sorts);
            string Filter { get; set; }
            void RemoveFilter();
            System.ComponentModel.ListSortDescriptionCollection SortDescriptions { get; }
            bool SupportsAdvancedSorting { get; }
            bool SupportsFiltering { get; }
        }
        public interface ICancelAddNew
        {
            void CancelNew(int itemIndex);
            void EndNew(int itemIndex);
        }
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
        public interface IDataErrorInfo
        {
            string Error { get; }
            string this[string columnName] { get; }
        }
        public interface IExtenderProvider
        {
            bool CanExtend(object extendee);
        }
        public interface IIntellisenseBuilder
        {
            string Name { get; }
            bool Show(string language, string value, ref string newValue);
        }
        public interface IListSource
        {
            bool ContainsListCollection { get; }
            System.Collections.IList GetList();
        }
        public interface INestedContainer : System.ComponentModel.IContainer, System.IDisposable
        {
            System.ComponentModel.IComponent Owner { get; }
        }
        public interface INestedSite : System.IServiceProvider, System.ComponentModel.ISite
        {
            string FullName { get; }
        }
        [System.AttributeUsage((System.AttributeTargets)896)]
        public sealed class InheritanceAttribute : System.Attribute
        {
            public InheritanceAttribute() => throw null;
            public InheritanceAttribute(System.ComponentModel.InheritanceLevel inheritanceLevel) => throw null;
            public static readonly System.ComponentModel.InheritanceAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public System.ComponentModel.InheritanceLevel InheritanceLevel { get => throw null; }
            public static readonly System.ComponentModel.InheritanceAttribute Inherited;
            public static readonly System.ComponentModel.InheritanceAttribute InheritedReadOnly;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.InheritanceAttribute NotInherited;
            public override string ToString() => throw null;
        }
        public enum InheritanceLevel
        {
            Inherited = 1,
            InheritedReadOnly = 2,
            NotInherited = 3,
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public class InstallerTypeAttribute : System.Attribute
        {
            public InstallerTypeAttribute(string typeName) => throw null;
            public InstallerTypeAttribute(System.Type installerType) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public virtual System.Type InstallerType { get => throw null; }
        }
        public abstract class InstanceCreationEditor
        {
            public abstract object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Type instanceType);
            protected InstanceCreationEditor() => throw null;
            public virtual string Text { get => throw null; }
        }
        public class Int128Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int128Converter() => throw null;
        }
        public class Int16Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int16Converter() => throw null;
        }
        public class Int32Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int32Converter() => throw null;
        }
        public class Int64Converter : System.ComponentModel.BaseNumberConverter
        {
            public Int64Converter() => throw null;
        }
        public interface IRaiseItemChangedEvents
        {
            bool RaisesItemChangedEvents { get; }
        }
        public interface ISupportInitializeNotification : System.ComponentModel.ISupportInitialize
        {
            event System.EventHandler Initialized;
            bool IsInitialized { get; }
        }
        public interface ITypeDescriptorContext : System.IServiceProvider
        {
            System.ComponentModel.IContainer Container { get; }
            object Instance { get; }
            void OnComponentChanged();
            bool OnComponentChanging();
            System.ComponentModel.PropertyDescriptor PropertyDescriptor { get; }
        }
        public interface ITypedList
        {
            System.ComponentModel.PropertyDescriptorCollection GetItemProperties(System.ComponentModel.PropertyDescriptor[] listAccessors);
            string GetListName(System.ComponentModel.PropertyDescriptor[] listAccessors);
        }
        public abstract class License : System.IDisposable
        {
            protected License() => throw null;
            public abstract void Dispose();
            public abstract string LicenseKey { get; }
        }
        public class LicenseContext : System.IServiceProvider
        {
            public LicenseContext() => throw null;
            public virtual string GetSavedLicenseKey(System.Type type, System.Reflection.Assembly resourceAssembly) => throw null;
            public virtual object GetService(System.Type type) => throw null;
            public virtual void SetSavedLicenseKey(System.Type type, string key) => throw null;
            public virtual System.ComponentModel.LicenseUsageMode UsageMode { get => throw null; }
        }
        public class LicenseException : System.SystemException
        {
            protected LicenseException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public LicenseException(System.Type type) => throw null;
            public LicenseException(System.Type type, object instance) => throw null;
            public LicenseException(System.Type type, object instance, string message) => throw null;
            public LicenseException(System.Type type, object instance, string message, System.Exception innerException) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Type LicensedType { get => throw null; }
        }
        public sealed class LicenseManager
        {
            public static object CreateWithContext(System.Type type, System.ComponentModel.LicenseContext creationContext) => throw null;
            public static object CreateWithContext(System.Type type, System.ComponentModel.LicenseContext creationContext, object[] args) => throw null;
            public static System.ComponentModel.LicenseContext CurrentContext { get => throw null; set { } }
            public static bool IsLicensed(System.Type type) => throw null;
            public static bool IsValid(System.Type type) => throw null;
            public static bool IsValid(System.Type type, object instance, out System.ComponentModel.License license) => throw null;
            public static void LockContext(object contextUser) => throw null;
            public static void UnlockContext(object contextUser) => throw null;
            public static System.ComponentModel.LicenseUsageMode UsageMode { get => throw null; }
            public static void Validate(System.Type type) => throw null;
            public static System.ComponentModel.License Validate(System.Type type, object instance) => throw null;
        }
        public abstract class LicenseProvider
        {
            protected LicenseProvider() => throw null;
            public abstract System.ComponentModel.License GetLicense(System.ComponentModel.LicenseContext context, System.Type type, object instance, bool allowExceptions);
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = false)]
        public sealed class LicenseProviderAttribute : System.Attribute
        {
            public LicenseProviderAttribute() => throw null;
            public LicenseProviderAttribute(string typeName) => throw null;
            public LicenseProviderAttribute(System.Type type) => throw null;
            public static readonly System.ComponentModel.LicenseProviderAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public System.Type LicenseProvider { get => throw null; }
            public override object TypeId { get => throw null; }
        }
        public enum LicenseUsageMode
        {
            Runtime = 0,
            Designtime = 1,
        }
        public class LicFileLicenseProvider : System.ComponentModel.LicenseProvider
        {
            public LicFileLicenseProvider() => throw null;
            protected virtual string GetKey(System.Type type) => throw null;
            public override System.ComponentModel.License GetLicense(System.ComponentModel.LicenseContext context, System.Type type, object instance, bool allowExceptions) => throw null;
            protected virtual bool IsKeyValid(string key, System.Type type) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class ListBindableAttribute : System.Attribute
        {
            public ListBindableAttribute(bool listBindable) => throw null;
            public ListBindableAttribute(System.ComponentModel.BindableSupport flags) => throw null;
            public static readonly System.ComponentModel.ListBindableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool ListBindable { get => throw null; }
            public static readonly System.ComponentModel.ListBindableAttribute No;
            public static readonly System.ComponentModel.ListBindableAttribute Yes;
        }
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
        public delegate void ListChangedEventHandler(object sender, System.ComponentModel.ListChangedEventArgs e);
        public enum ListChangedType
        {
            Reset = 0,
            ItemAdded = 1,
            ItemDeleted = 2,
            ItemMoved = 3,
            ItemChanged = 4,
            PropertyDescriptorAdded = 5,
            PropertyDescriptorDeleted = 6,
            PropertyDescriptorChanged = 7,
        }
        public class ListSortDescription
        {
            public ListSortDescription(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction) => throw null;
            public System.ComponentModel.PropertyDescriptor PropertyDescriptor { get => throw null; set { } }
            public System.ComponentModel.ListSortDirection SortDirection { get => throw null; set { } }
        }
        public class ListSortDescriptionCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            int System.Collections.IList.Add(object value) => throw null;
            void System.Collections.IList.Clear() => throw null;
            public bool Contains(object value) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public ListSortDescriptionCollection() => throw null;
            public ListSortDescriptionCollection(System.ComponentModel.ListSortDescription[] sorts) => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public int IndexOf(object value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            void System.Collections.IList.Remove(object value) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public System.ComponentModel.ListSortDescription this[int index] { get => throw null; set { } }
        }
        public enum ListSortDirection
        {
            Ascending = 0,
            Descending = 1,
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class LookupBindingPropertiesAttribute : System.Attribute
        {
            public LookupBindingPropertiesAttribute() => throw null;
            public LookupBindingPropertiesAttribute(string dataSource, string displayMember, string valueMember, string lookupMember) => throw null;
            public string DataSource { get => throw null; }
            public static readonly System.ComponentModel.LookupBindingPropertiesAttribute Default;
            public string DisplayMember { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string LookupMember { get => throw null; }
            public string ValueMember { get => throw null; }
        }
        public class MarshalByValueComponent : System.ComponentModel.IComponent, System.IDisposable, System.IServiceProvider
        {
            public virtual System.ComponentModel.IContainer Container { get => throw null; }
            public MarshalByValueComponent() => throw null;
            public virtual bool DesignMode { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public event System.EventHandler Disposed;
            protected System.ComponentModel.EventHandlerList Events { get => throw null; }
            public virtual object GetService(System.Type service) => throw null;
            public virtual System.ComponentModel.ISite Site { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public class MaskedTextProvider : System.ICloneable
        {
            public bool Add(char input) => throw null;
            public bool Add(char input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Add(string input) => throw null;
            public bool Add(string input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool AllowPromptAsInput { get => throw null; }
            public bool AsciiOnly { get => throw null; }
            public int AssignedEditPositionCount { get => throw null; }
            public int AvailableEditPositionCount { get => throw null; }
            public void Clear() => throw null;
            public void Clear(out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public object Clone() => throw null;
            public MaskedTextProvider(string mask) => throw null;
            public MaskedTextProvider(string mask, bool restrictToAscii) => throw null;
            public MaskedTextProvider(string mask, char passwordChar, bool allowPromptAsInput) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture, bool restrictToAscii) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture, bool allowPromptAsInput, char promptChar, char passwordChar, bool restrictToAscii) => throw null;
            public MaskedTextProvider(string mask, System.Globalization.CultureInfo culture, char passwordChar, bool allowPromptAsInput) => throw null;
            public System.Globalization.CultureInfo Culture { get => throw null; }
            public static char DefaultPasswordChar { get => throw null; }
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
            public bool IncludeLiterals { get => throw null; set { } }
            public bool IncludePrompt { get => throw null; set { } }
            public bool InsertAt(char input, int position) => throw null;
            public bool InsertAt(char input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool InsertAt(string input, int position) => throw null;
            public bool InsertAt(string input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public static int InvalidIndex { get => throw null; }
            public bool IsAvailablePosition(int position) => throw null;
            public bool IsEditPosition(int position) => throw null;
            public bool IsPassword { get => throw null; set { } }
            public static bool IsValidInputChar(char c) => throw null;
            public static bool IsValidMaskChar(char c) => throw null;
            public static bool IsValidPasswordChar(char c) => throw null;
            public int LastAssignedPosition { get => throw null; }
            public int Length { get => throw null; }
            public string Mask { get => throw null; }
            public bool MaskCompleted { get => throw null; }
            public bool MaskFull { get => throw null; }
            public char PasswordChar { get => throw null; set { } }
            public char PromptChar { get => throw null; set { } }
            public bool Remove() => throw null;
            public bool Remove(out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool RemoveAt(int position) => throw null;
            public bool RemoveAt(int startPosition, int endPosition) => throw null;
            public bool RemoveAt(int startPosition, int endPosition, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(char input, int position) => throw null;
            public bool Replace(char input, int startPosition, int endPosition, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(char input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(string input, int position) => throw null;
            public bool Replace(string input, int startPosition, int endPosition, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool Replace(string input, int position, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool ResetOnPrompt { get => throw null; set { } }
            public bool ResetOnSpace { get => throw null; set { } }
            public bool Set(string input) => throw null;
            public bool Set(string input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
            public bool SkipLiterals { get => throw null; set { } }
            public char this[int index] { get => throw null; }
            public string ToDisplayString() => throw null;
            public override string ToString() => throw null;
            public string ToString(bool ignorePasswordChar) => throw null;
            public string ToString(bool includePrompt, bool includeLiterals) => throw null;
            public string ToString(bool ignorePasswordChar, bool includePrompt, bool includeLiterals, int startPosition, int length) => throw null;
            public string ToString(bool includePrompt, bool includeLiterals, int startPosition, int length) => throw null;
            public string ToString(bool ignorePasswordChar, int startPosition, int length) => throw null;
            public string ToString(int startPosition, int length) => throw null;
            public bool VerifyChar(char input, int position, out System.ComponentModel.MaskedTextResultHint hint) => throw null;
            public bool VerifyEscapeChar(char input, int position) => throw null;
            public bool VerifyString(string input) => throw null;
            public bool VerifyString(string input, out int testPosition, out System.ComponentModel.MaskedTextResultHint resultHint) => throw null;
        }
        public enum MaskedTextResultHint
        {
            PositionOutOfRange = -55,
            NonEditPosition = -54,
            UnavailableEditPosition = -53,
            PromptCharNotAllowed = -52,
            InvalidInput = -51,
            SignedDigitExpected = -5,
            LetterExpected = -4,
            DigitExpected = -3,
            AlphanumericCharacterExpected = -2,
            AsciiCharacterExpected = -1,
            Unknown = 0,
            CharacterEscaped = 1,
            NoEffect = 2,
            SideEffect = 3,
            Success = 4,
        }
        public abstract class MemberDescriptor
        {
            protected virtual System.Attribute[] AttributeArray { get => throw null; set { } }
            public virtual System.ComponentModel.AttributeCollection Attributes { get => throw null; }
            public virtual string Category { get => throw null; }
            protected virtual System.ComponentModel.AttributeCollection CreateAttributeCollection() => throw null;
            protected MemberDescriptor(System.ComponentModel.MemberDescriptor descr) => throw null;
            protected MemberDescriptor(System.ComponentModel.MemberDescriptor oldMemberDescriptor, System.Attribute[] newAttributes) => throw null;
            protected MemberDescriptor(string name) => throw null;
            protected MemberDescriptor(string name, System.Attribute[] attributes) => throw null;
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
            public virtual string Name { get => throw null; }
            protected virtual int NameHashCode { get => throw null; }
        }
        public class MultilineStringConverter : System.ComponentModel.TypeConverter
        {
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public MultilineStringConverter() => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class NestedContainer : System.ComponentModel.Container, System.ComponentModel.IContainer, System.IDisposable, System.ComponentModel.INestedContainer
        {
            protected override System.ComponentModel.ISite CreateSite(System.ComponentModel.IComponent component, string name) => throw null;
            public NestedContainer(System.ComponentModel.IComponent owner) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            protected override object GetService(System.Type service) => throw null;
            public System.ComponentModel.IComponent Owner { get => throw null; }
            protected virtual string OwnerName { get => throw null; }
        }
        public class NullableConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public NullableConverter(System.Type type) => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
            public System.Type NullableType { get => throw null; }
            public System.Type UnderlyingType { get => throw null; }
            public System.ComponentModel.TypeConverter UnderlyingTypeConverter { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class PasswordPropertyTextAttribute : System.Attribute
        {
            public PasswordPropertyTextAttribute() => throw null;
            public PasswordPropertyTextAttribute(bool password) => throw null;
            public static readonly System.ComponentModel.PasswordPropertyTextAttribute Default;
            public override bool Equals(object o) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.PasswordPropertyTextAttribute No;
            public bool Password { get => throw null; }
            public static readonly System.ComponentModel.PasswordPropertyTextAttribute Yes;
        }
        public abstract class PropertyDescriptor : System.ComponentModel.MemberDescriptor
        {
            public virtual void AddValueChanged(object component, System.EventHandler handler) => throw null;
            public abstract bool CanResetValue(object component);
            public abstract System.Type ComponentType { get; }
            public virtual System.ComponentModel.TypeConverter Converter { get => throw null; }
            protected object CreateInstance(System.Type type) => throw null;
            protected PropertyDescriptor(System.ComponentModel.MemberDescriptor descr) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            protected PropertyDescriptor(System.ComponentModel.MemberDescriptor descr, System.Attribute[] attrs) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
            protected PropertyDescriptor(string name, System.Attribute[] attrs) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
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
            protected System.EventHandler GetValueChangedHandler(object component) => throw null;
            public virtual bool IsLocalizable { get => throw null; }
            public abstract bool IsReadOnly { get; }
            protected virtual void OnValueChanged(object component, System.EventArgs e) => throw null;
            public abstract System.Type PropertyType { get; }
            public virtual void RemoveValueChanged(object component, System.EventHandler handler) => throw null;
            public abstract void ResetValue(object component);
            public System.ComponentModel.DesignerSerializationVisibility SerializationVisibility { get => throw null; }
            public abstract void SetValue(object component, object value);
            public abstract bool ShouldSerializeValue(object component);
            public virtual bool SupportsChangeEvents { get => throw null; }
        }
        public class PropertyDescriptorCollection : System.Collections.ICollection, System.Collections.IDictionary, System.Collections.IEnumerable, System.Collections.IList
        {
            public int Add(System.ComponentModel.PropertyDescriptor value) => throw null;
            void System.Collections.IDictionary.Add(object key, object value) => throw null;
            int System.Collections.IList.Add(object value) => throw null;
            public void Clear() => throw null;
            void System.Collections.IDictionary.Clear() => throw null;
            void System.Collections.IList.Clear() => throw null;
            public bool Contains(System.ComponentModel.PropertyDescriptor value) => throw null;
            bool System.Collections.IDictionary.Contains(object key) => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            public PropertyDescriptorCollection(System.ComponentModel.PropertyDescriptor[] properties) => throw null;
            public PropertyDescriptorCollection(System.ComponentModel.PropertyDescriptor[] properties, bool readOnly) => throw null;
            public static readonly System.ComponentModel.PropertyDescriptorCollection Empty;
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
            object System.Collections.IDictionary.this[object key] { get => throw null; set { } }
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            System.Collections.ICollection System.Collections.IDictionary.Keys { get => throw null; }
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
            public virtual System.ComponentModel.PropertyDescriptor this[int index] { get => throw null; }
            public virtual System.ComponentModel.PropertyDescriptor this[string name] { get => throw null; }
            System.Collections.ICollection System.Collections.IDictionary.Values { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class PropertyTabAttribute : System.Attribute
        {
            public PropertyTabAttribute() => throw null;
            public PropertyTabAttribute(string tabClassName) => throw null;
            public PropertyTabAttribute(string tabClassName, System.ComponentModel.PropertyTabScope tabScope) => throw null;
            public PropertyTabAttribute(System.Type tabClass) => throw null;
            public PropertyTabAttribute(System.Type tabClass, System.ComponentModel.PropertyTabScope tabScope) => throw null;
            public bool Equals(System.ComponentModel.PropertyTabAttribute other) => throw null;
            public override bool Equals(object other) => throw null;
            public override int GetHashCode() => throw null;
            protected void InitializeArrays(string[] tabClassNames, System.ComponentModel.PropertyTabScope[] tabScopes) => throw null;
            protected void InitializeArrays(System.Type[] tabClasses, System.ComponentModel.PropertyTabScope[] tabScopes) => throw null;
            public System.Type[] TabClasses { get => throw null; }
            protected string[] TabClassNames { get => throw null; }
            public System.ComponentModel.PropertyTabScope[] TabScopes { get => throw null; }
        }
        public enum PropertyTabScope
        {
            Static = 0,
            Global = 1,
            Document = 2,
            Component = 3,
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
        public sealed class ProvidePropertyAttribute : System.Attribute
        {
            public ProvidePropertyAttribute(string propertyName, string receiverTypeName) => throw null;
            public ProvidePropertyAttribute(string propertyName, System.Type receiverType) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string PropertyName { get => throw null; }
            public string ReceiverTypeName { get => throw null; }
            public override object TypeId { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class RecommendedAsConfigurableAttribute : System.Attribute
        {
            public RecommendedAsConfigurableAttribute(bool recommendedAsConfigurable) => throw null;
            public static readonly System.ComponentModel.RecommendedAsConfigurableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.RecommendedAsConfigurableAttribute No;
            public bool RecommendedAsConfigurable { get => throw null; }
            public static readonly System.ComponentModel.RecommendedAsConfigurableAttribute Yes;
        }
        public class ReferenceConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public ReferenceConverter(System.Type type) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            protected virtual bool IsValueAllowed(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
        }
        public class RefreshEventArgs : System.EventArgs
        {
            public object ComponentChanged { get => throw null; }
            public RefreshEventArgs(object componentChanged) => throw null;
            public RefreshEventArgs(System.Type typeChanged) => throw null;
            public System.Type TypeChanged { get => throw null; }
        }
        public delegate void RefreshEventHandler(System.ComponentModel.RefreshEventArgs e);
        [System.AttributeUsage((System.AttributeTargets)4)]
        public class RunInstallerAttribute : System.Attribute
        {
            public RunInstallerAttribute(bool runInstaller) => throw null;
            public static readonly System.ComponentModel.RunInstallerAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.RunInstallerAttribute No;
            public bool RunInstaller { get => throw null; }
            public static readonly System.ComponentModel.RunInstallerAttribute Yes;
        }
        public class SByteConverter : System.ComponentModel.BaseNumberConverter
        {
            public SByteConverter() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public sealed class SettingsBindableAttribute : System.Attribute
        {
            public bool Bindable { get => throw null; }
            public SettingsBindableAttribute(bool bindable) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static readonly System.ComponentModel.SettingsBindableAttribute No;
            public static readonly System.ComponentModel.SettingsBindableAttribute Yes;
        }
        public class SingleConverter : System.ComponentModel.BaseNumberConverter
        {
            public SingleConverter() => throw null;
        }
        public class StringConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public StringConverter() => throw null;
        }
        public static class SyntaxCheck
        {
            public static bool CheckMachineName(string value) => throw null;
            public static bool CheckPath(string value) => throw null;
            public static bool CheckRootedPath(string value) => throw null;
        }
        public class TimeOnlyConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public TimeOnlyConverter() => throw null;
        }
        public class TimeSpanConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public TimeSpanConverter() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class ToolboxItemAttribute : System.Attribute
        {
            public ToolboxItemAttribute(bool defaultType) => throw null;
            public ToolboxItemAttribute(string toolboxItemTypeName) => throw null;
            public ToolboxItemAttribute(System.Type toolboxItemType) => throw null;
            public static readonly System.ComponentModel.ToolboxItemAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.ToolboxItemAttribute None;
            public System.Type ToolboxItemType { get => throw null; }
            public string ToolboxItemTypeName { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
        public sealed class ToolboxItemFilterAttribute : System.Attribute
        {
            public ToolboxItemFilterAttribute(string filterString) => throw null;
            public ToolboxItemFilterAttribute(string filterString, System.ComponentModel.ToolboxItemFilterType filterType) => throw null;
            public override bool Equals(object obj) => throw null;
            public string FilterString { get => throw null; }
            public System.ComponentModel.ToolboxItemFilterType FilterType { get => throw null; }
            public override int GetHashCode() => throw null;
            public override bool Match(object obj) => throw null;
            public override string ToString() => throw null;
            public override object TypeId { get => throw null; }
        }
        public enum ToolboxItemFilterType
        {
            Allow = 0,
            Custom = 1,
            Prevent = 2,
            Require = 3,
        }
        public class TypeConverter
        {
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
            public TypeConverter() => throw null;
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
            protected abstract class SimplePropertyDescriptor : System.ComponentModel.PropertyDescriptor
            {
                public override bool CanResetValue(object component) => throw null;
                public override System.Type ComponentType { get => throw null; }
                protected SimplePropertyDescriptor(System.Type componentType, string name, System.Type propertyType) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
                protected SimplePropertyDescriptor(System.Type componentType, string name, System.Type propertyType, System.Attribute[] attributes) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
                public override bool IsReadOnly { get => throw null; }
                public override System.Type PropertyType { get => throw null; }
                public override void ResetValue(object component) => throw null;
                public override bool ShouldSerializeValue(object component) => throw null;
            }
            protected System.ComponentModel.PropertyDescriptorCollection SortProperties(System.ComponentModel.PropertyDescriptorCollection props, string[] names) => throw null;
            public class StandardValuesCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public StandardValuesCollection(System.Collections.ICollection values) => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public object this[int index] { get => throw null; }
            }
        }
        public abstract class TypeDescriptionProvider
        {
            public virtual object CreateInstance(System.IServiceProvider provider, System.Type objectType, System.Type[] argTypes, object[] args) => throw null;
            protected TypeDescriptionProvider() => throw null;
            protected TypeDescriptionProvider(System.ComponentModel.TypeDescriptionProvider parent) => throw null;
            public virtual System.Collections.IDictionary GetCache(object instance) => throw null;
            public virtual System.ComponentModel.ICustomTypeDescriptor GetExtendedTypeDescriptor(object instance) => throw null;
            protected virtual System.ComponentModel.IExtenderProvider[] GetExtenderProviders(object instance) => throw null;
            public virtual string GetFullComponentName(object component) => throw null;
            public System.Type GetReflectionType(object instance) => throw null;
            public System.Type GetReflectionType(System.Type objectType) => throw null;
            public virtual System.Type GetReflectionType(System.Type objectType, object instance) => throw null;
            public virtual System.Type GetRuntimeType(System.Type reflectionType) => throw null;
            public System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(object instance) => throw null;
            public System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(System.Type objectType) => throw null;
            public virtual System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(System.Type objectType, object instance) => throw null;
            public virtual bool IsSupportedType(System.Type type) => throw null;
        }
        public sealed class TypeDescriptor
        {
            public static System.ComponentModel.TypeDescriptionProvider AddAttributes(object instance, params System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.TypeDescriptionProvider AddAttributes(System.Type type, params System.Attribute[] attributes) => throw null;
            public static void AddEditorTable(System.Type editorBaseType, System.Collections.Hashtable table) => throw null;
            public static void AddProvider(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void AddProvider(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void AddProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void AddProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static System.ComponentModel.IComNativeDescriptorHandler ComNativeDescriptorHandler { get => throw null; set { } }
            public static System.Type ComObjectType { get => throw null; }
            public static void CreateAssociation(object primary, object secondary) => throw null;
            public static System.ComponentModel.Design.IDesigner CreateDesigner(System.ComponentModel.IComponent component, System.Type designerBaseType) => throw null;
            public static System.ComponentModel.EventDescriptor CreateEvent(System.Type componentType, System.ComponentModel.EventDescriptor oldEventDescriptor, params System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.EventDescriptor CreateEvent(System.Type componentType, string name, System.Type type, params System.Attribute[] attributes) => throw null;
            public static object CreateInstance(System.IServiceProvider provider, System.Type objectType, System.Type[] argTypes, object[] args) => throw null;
            public static System.ComponentModel.PropertyDescriptor CreateProperty(System.Type componentType, System.ComponentModel.PropertyDescriptor oldPropertyDescriptor, params System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.PropertyDescriptor CreateProperty(System.Type componentType, string name, System.Type type, params System.Attribute[] attributes) => throw null;
            public static object GetAssociation(System.Type type, object primary) => throw null;
            public static System.ComponentModel.AttributeCollection GetAttributes(object component) => throw null;
            public static System.ComponentModel.AttributeCollection GetAttributes(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.AttributeCollection GetAttributes(System.Type componentType) => throw null;
            public static string GetClassName(object component) => throw null;
            public static string GetClassName(object component, bool noCustomTypeDesc) => throw null;
            public static string GetClassName(System.Type componentType) => throw null;
            public static string GetComponentName(object component) => throw null;
            public static string GetComponentName(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.TypeConverter GetConverter(object component) => throw null;
            public static System.ComponentModel.TypeConverter GetConverter(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.TypeConverter GetConverter(System.Type type) => throw null;
            public static System.ComponentModel.EventDescriptor GetDefaultEvent(object component) => throw null;
            public static System.ComponentModel.EventDescriptor GetDefaultEvent(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.EventDescriptor GetDefaultEvent(System.Type componentType) => throw null;
            public static System.ComponentModel.PropertyDescriptor GetDefaultProperty(object component) => throw null;
            public static System.ComponentModel.PropertyDescriptor GetDefaultProperty(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.PropertyDescriptor GetDefaultProperty(System.Type componentType) => throw null;
            public static object GetEditor(object component, System.Type editorBaseType) => throw null;
            public static object GetEditor(object component, System.Type editorBaseType, bool noCustomTypeDesc) => throw null;
            public static object GetEditor(System.Type type, System.Type editorBaseType) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component, System.Attribute[] attributes, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(System.Type componentType) => throw null;
            public static System.ComponentModel.EventDescriptorCollection GetEvents(System.Type componentType, System.Attribute[] attributes) => throw null;
            public static string GetFullComponentName(object component) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, System.Attribute[] attributes, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(object component, bool noCustomTypeDesc) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(System.Type componentType) => throw null;
            public static System.ComponentModel.PropertyDescriptorCollection GetProperties(System.Type componentType, System.Attribute[] attributes) => throw null;
            public static System.ComponentModel.TypeDescriptionProvider GetProvider(object instance) => throw null;
            public static System.ComponentModel.TypeDescriptionProvider GetProvider(System.Type type) => throw null;
            public static System.Type GetReflectionType(object instance) => throw null;
            public static System.Type GetReflectionType(System.Type type) => throw null;
            public static System.Type InterfaceType { get => throw null; }
            public static void Refresh(object component) => throw null;
            public static void Refresh(System.Reflection.Assembly assembly) => throw null;
            public static void Refresh(System.Reflection.Module module) => throw null;
            public static void Refresh(System.Type type) => throw null;
            public static event System.ComponentModel.RefreshEventHandler Refreshed;
            public static void RemoveAssociation(object primary, object secondary) => throw null;
            public static void RemoveAssociations(object primary) => throw null;
            public static void RemoveProvider(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void RemoveProvider(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void RemoveProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, object instance) => throw null;
            public static void RemoveProviderTransparent(System.ComponentModel.TypeDescriptionProvider provider, System.Type type) => throw null;
            public static void SortDescriptorArray(System.Collections.IList infos) => throw null;
        }
        public abstract class TypeListConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            protected TypeListConverter(System.Type[] types) => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class UInt128Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt128Converter() => throw null;
        }
        public class UInt16Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt16Converter() => throw null;
        }
        public class UInt32Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt32Converter() => throw null;
        }
        public class UInt64Converter : System.ComponentModel.BaseNumberConverter
        {
            public UInt64Converter() => throw null;
        }
        public class VersionConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public VersionConverter() => throw null;
            public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
        }
        public class WarningException : System.SystemException
        {
            public WarningException() => throw null;
            protected WarningException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public WarningException(string message) => throw null;
            public WarningException(string message, System.Exception innerException) => throw null;
            public WarningException(string message, string helpUrl) => throw null;
            public WarningException(string message, string helpUrl, string helpTopic) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public string HelpTopic { get => throw null; }
            public string HelpUrl { get => throw null; }
        }
    }
    namespace Drawing
    {
        public class ColorConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public ColorConverter() => throw null;
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class PointConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public PointConverter() => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class RectangleConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public RectangleConverter() => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class SizeConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public SizeConverter() => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
        public class SizeFConverter : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary propertyValues) => throw null;
            public SizeFConverter() => throw null;
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
            public override System.ComponentModel.PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributes) => throw null;
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) => throw null;
        }
    }
    namespace Security
    {
        namespace Authentication
        {
            namespace ExtendedProtection
            {
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
        public class ElapsedEventArgs : System.EventArgs
        {
            public System.DateTime SignalTime { get => throw null; }
        }
        public delegate void ElapsedEventHandler(object sender, System.Timers.ElapsedEventArgs e);
        public class Timer : System.ComponentModel.Component, System.ComponentModel.ISupportInitialize
        {
            public bool AutoReset { get => throw null; set { } }
            public void BeginInit() => throw null;
            public void Close() => throw null;
            public Timer() => throw null;
            public Timer(double interval) => throw null;
            public Timer(System.TimeSpan interval) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public event System.Timers.ElapsedEventHandler Elapsed;
            public bool Enabled { get => throw null; set { } }
            public void EndInit() => throw null;
            public double Interval { get => throw null; set { } }
            public override System.ComponentModel.ISite Site { get => throw null; set { } }
            public void Start() => throw null;
            public void Stop() => throw null;
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class TimersDescriptionAttribute : System.ComponentModel.DescriptionAttribute
        {
            public TimersDescriptionAttribute(string description) => throw null;
            public override string Description { get => throw null; }
        }
    }
    public class UriTypeConverter : System.ComponentModel.TypeConverter
    {
        public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType) => throw null;
        public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) => throw null;
        public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) => throw null;
        public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) => throw null;
        public UriTypeConverter() => throw null;
        public override bool IsValid(System.ComponentModel.ITypeDescriptorContext context, object value) => throw null;
    }
}
