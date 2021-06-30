// This file contains auto-generated code.

namespace System
{
    // Generated from `System.UriIdnScope` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
    public enum UriIdnScope
    {
        All,
        AllExceptIntranet,
        None,
    }

    namespace Configuration
    {
        // Generated from `System.Configuration.AppSettingsReader` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class AppSettingsReader
        {
            public AppSettingsReader() => throw null;
            public object GetValue(string key, System.Type type) => throw null;
        }

        // Generated from `System.Configuration.AppSettingsSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class AppSettingsSection : System.Configuration.ConfigurationSection
        {
            public AppSettingsSection() => throw null;
            protected override void DeserializeElement(System.Xml.XmlReader reader, bool serializeCollectionKey) => throw null;
            public string File { get => throw null; set => throw null; }
            protected override object GetRuntimeObject() => throw null;
            protected override bool IsModified() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            protected override void Reset(System.Configuration.ConfigurationElement parentSection) => throw null;
            protected override string SerializeSection(System.Configuration.ConfigurationElement parentElement, string name, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
            public System.Configuration.KeyValueConfigurationCollection Settings { get => throw null; }
        }

        // Generated from `System.Configuration.ApplicationScopedSettingAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ApplicationScopedSettingAttribute : System.Configuration.SettingAttribute
        {
            public ApplicationScopedSettingAttribute() => throw null;
        }

        // Generated from `System.Configuration.ApplicationSettingsBase` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ApplicationSettingsBase : System.Configuration.SettingsBase, System.ComponentModel.INotifyPropertyChanged
        {
            protected ApplicationSettingsBase(string settingsKey) => throw null;
            protected ApplicationSettingsBase(System.ComponentModel.IComponent owner, string settingsKey) => throw null;
            protected ApplicationSettingsBase(System.ComponentModel.IComponent owner) => throw null;
            protected ApplicationSettingsBase() => throw null;
            public override System.Configuration.SettingsContext Context { get => throw null; }
            public object GetPreviousVersion(string propertyName) => throw null;
            public override object this[string propertyName] { get => throw null; set => throw null; }
            protected virtual void OnPropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e) => throw null;
            protected virtual void OnSettingChanging(object sender, System.Configuration.SettingChangingEventArgs e) => throw null;
            protected virtual void OnSettingsLoaded(object sender, System.Configuration.SettingsLoadedEventArgs e) => throw null;
            protected virtual void OnSettingsSaving(object sender, System.ComponentModel.CancelEventArgs e) => throw null;
            public override System.Configuration.SettingsPropertyCollection Properties { get => throw null; }
            public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
            public override System.Configuration.SettingsPropertyValueCollection PropertyValues { get => throw null; }
            public override System.Configuration.SettingsProviderCollection Providers { get => throw null; }
            public void Reload() => throw null;
            public void Reset() => throw null;
            public override void Save() => throw null;
            public event System.Configuration.SettingChangingEventHandler SettingChanging;
            public string SettingsKey { get => throw null; set => throw null; }
            public event System.Configuration.SettingsLoadedEventHandler SettingsLoaded;
            public event System.Configuration.SettingsSavingEventHandler SettingsSaving;
            public virtual void Upgrade() => throw null;
        }

        // Generated from `System.Configuration.ApplicationSettingsGroup` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ApplicationSettingsGroup : System.Configuration.ConfigurationSectionGroup
        {
            public ApplicationSettingsGroup() => throw null;
        }

        // Generated from `System.Configuration.CallbackValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class CallbackValidator : System.Configuration.ConfigurationValidatorBase
        {
            public CallbackValidator(System.Type type, System.Configuration.ValidatorCallback callback) => throw null;
            public override bool CanValidate(System.Type type) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.CallbackValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class CallbackValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public string CallbackMethodName { get => throw null; set => throw null; }
            public CallbackValidatorAttribute() => throw null;
            public System.Type Type { get => throw null; set => throw null; }
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.ClientSettingsSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ClientSettingsSection : System.Configuration.ConfigurationSection
        {
            public ClientSettingsSection() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public System.Configuration.SettingElementCollection Settings { get => throw null; }
        }

        // Generated from `System.Configuration.CommaDelimitedStringCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class CommaDelimitedStringCollection : System.Collections.Specialized.StringCollection
        {
            public void Add(string value) => throw null;
            public void AddRange(string[] range) => throw null;
            public void Clear() => throw null;
            public System.Configuration.CommaDelimitedStringCollection Clone() => throw null;
            public CommaDelimitedStringCollection() => throw null;
            public void Insert(int index, string value) => throw null;
            public bool IsModified { get => throw null; }
            public bool IsReadOnly { get => throw null; }
            public string this[int index] { get => throw null; set => throw null; }
            public void Remove(string value) => throw null;
            public void SetReadOnly() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `System.Configuration.CommaDelimitedStringCollectionConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class CommaDelimitedStringCollectionConverter : System.Configuration.ConfigurationConverterBase
        {
            public CommaDelimitedStringCollectionConverter() => throw null;
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
        }

        // Generated from `System.Configuration.ConfigXmlDocument` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigXmlDocument : System.Xml.XmlDocument, System.Configuration.Internal.IConfigErrorInfo
        {
            public ConfigXmlDocument() => throw null;
            public override System.Xml.XmlAttribute CreateAttribute(string prefix, string localName, string namespaceUri) => throw null;
            public override System.Xml.XmlCDataSection CreateCDataSection(string data) => throw null;
            public override System.Xml.XmlComment CreateComment(string data) => throw null;
            public override System.Xml.XmlElement CreateElement(string prefix, string localName, string namespaceUri) => throw null;
            public override System.Xml.XmlSignificantWhitespace CreateSignificantWhitespace(string data) => throw null;
            public override System.Xml.XmlText CreateTextNode(string text) => throw null;
            public override System.Xml.XmlWhitespace CreateWhitespace(string data) => throw null;
            string System.Configuration.Internal.IConfigErrorInfo.Filename { get => throw null; }
            public string Filename { get => throw null; }
            public int LineNumber { get => throw null; }
            int System.Configuration.Internal.IConfigErrorInfo.LineNumber { get => throw null; }
            public override void Load(string filename) => throw null;
            public void LoadSingleElement(string filename, System.Xml.XmlTextReader sourceReader) => throw null;
        }

        // Generated from `System.Configuration.Configuration` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class Configuration
        {
            public System.Configuration.AppSettingsSection AppSettings { get => throw null; }
            public System.Func<string, string> AssemblyStringTransformer { get => throw null; set => throw null; }
            public System.Configuration.ConnectionStringsSection ConnectionStrings { get => throw null; }
            public System.Configuration.ContextInformation EvaluationContext { get => throw null; }
            public string FilePath { get => throw null; }
            public System.Configuration.ConfigurationSection GetSection(string sectionName) => throw null;
            public System.Configuration.ConfigurationSectionGroup GetSectionGroup(string sectionGroupName) => throw null;
            public bool HasFile { get => throw null; }
            public System.Configuration.ConfigurationLocationCollection Locations { get => throw null; }
            public bool NamespaceDeclared { get => throw null; set => throw null; }
            public System.Configuration.ConfigurationSectionGroup RootSectionGroup { get => throw null; }
            public void Save(System.Configuration.ConfigurationSaveMode saveMode, bool forceSaveAll) => throw null;
            public void Save(System.Configuration.ConfigurationSaveMode saveMode) => throw null;
            public void Save() => throw null;
            public void SaveAs(string filename, System.Configuration.ConfigurationSaveMode saveMode, bool forceSaveAll) => throw null;
            public void SaveAs(string filename, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
            public void SaveAs(string filename) => throw null;
            public System.Configuration.ConfigurationSectionGroupCollection SectionGroups { get => throw null; }
            public System.Configuration.ConfigurationSectionCollection Sections { get => throw null; }
            public System.Runtime.Versioning.FrameworkName TargetFramework { get => throw null; set => throw null; }
            public System.Func<string, string> TypeStringTransformer { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationAllowDefinition` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ConfigurationAllowDefinition
        {
            Everywhere,
            MachineOnly,
            MachineToApplication,
            MachineToWebRoot,
        }

        // Generated from `System.Configuration.ConfigurationAllowExeDefinition` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ConfigurationAllowExeDefinition
        {
            MachineOnly,
            MachineToApplication,
            MachineToLocalUser,
            MachineToRoamingUser,
        }

        // Generated from `System.Configuration.ConfigurationCollectionAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationCollectionAttribute : System.Attribute
        {
            public string AddItemName { get => throw null; set => throw null; }
            public string ClearItemsName { get => throw null; set => throw null; }
            public System.Configuration.ConfigurationElementCollectionType CollectionType { get => throw null; set => throw null; }
            public ConfigurationCollectionAttribute(System.Type itemType) => throw null;
            public System.Type ItemType { get => throw null; }
            public string RemoveItemName { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationConverterBase` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ConfigurationConverterBase : System.ComponentModel.TypeConverter
        {
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Type type) => throw null;
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Type type) => throw null;
            protected ConfigurationConverterBase() => throw null;
        }

        // Generated from `System.Configuration.ConfigurationElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ConfigurationElement
        {
            protected ConfigurationElement() => throw null;
            public System.Configuration.Configuration CurrentConfiguration { get => throw null; }
            protected virtual void DeserializeElement(System.Xml.XmlReader reader, bool serializeCollectionKey) => throw null;
            public System.Configuration.ElementInformation ElementInformation { get => throw null; }
            protected virtual System.Configuration.ConfigurationElementProperty ElementProperty { get => throw null; }
            public override bool Equals(object compareTo) => throw null;
            protected System.Configuration.ContextInformation EvaluationContext { get => throw null; }
            public override int GetHashCode() => throw null;
            protected virtual string GetTransformedAssemblyString(string assemblyName) => throw null;
            protected virtual string GetTransformedTypeString(string typeName) => throw null;
            protected bool HasContext { get => throw null; }
            protected virtual void Init() => throw null;
            protected virtual void InitializeDefault() => throw null;
            protected virtual bool IsModified() => throw null;
            public virtual bool IsReadOnly() => throw null;
            protected object this[string propertyName] { get => throw null; set => throw null; }
            protected object this[System.Configuration.ConfigurationProperty prop] { get => throw null; set => throw null; }
            protected virtual void ListErrors(System.Collections.IList errorList) => throw null;
            public System.Configuration.ConfigurationLockCollection LockAllAttributesExcept { get => throw null; }
            public System.Configuration.ConfigurationLockCollection LockAllElementsExcept { get => throw null; }
            public System.Configuration.ConfigurationLockCollection LockAttributes { get => throw null; }
            public System.Configuration.ConfigurationLockCollection LockElements { get => throw null; }
            public bool LockItem { get => throw null; set => throw null; }
            protected virtual bool OnDeserializeUnrecognizedAttribute(string name, string value) => throw null;
            protected virtual bool OnDeserializeUnrecognizedElement(string elementName, System.Xml.XmlReader reader) => throw null;
            protected virtual object OnRequiredPropertyNotFound(string name) => throw null;
            protected virtual void PostDeserialize() => throw null;
            protected virtual void PreSerialize(System.Xml.XmlWriter writer) => throw null;
            protected virtual System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            protected virtual void Reset(System.Configuration.ConfigurationElement parentElement) => throw null;
            protected virtual void ResetModified() => throw null;
            protected virtual bool SerializeElement(System.Xml.XmlWriter writer, bool serializeCollectionKey) => throw null;
            protected virtual bool SerializeToXmlElement(System.Xml.XmlWriter writer, string elementName) => throw null;
            protected void SetPropertyValue(System.Configuration.ConfigurationProperty prop, object value, bool ignoreLocks) => throw null;
            protected virtual void SetReadOnly() => throw null;
            protected virtual void Unmerge(System.Configuration.ConfigurationElement sourceElement, System.Configuration.ConfigurationElement parentElement, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationElementCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ConfigurationElementCollection : System.Configuration.ConfigurationElement, System.Collections.IEnumerable, System.Collections.ICollection
        {
            protected string AddElementName { get => throw null; set => throw null; }
            protected void BaseAdd(System.Configuration.ConfigurationElement element, bool throwIfExists) => throw null;
            protected virtual void BaseAdd(int index, System.Configuration.ConfigurationElement element) => throw null;
            protected virtual void BaseAdd(System.Configuration.ConfigurationElement element) => throw null;
            protected void BaseClear() => throw null;
            protected System.Configuration.ConfigurationElement BaseGet(object key) => throw null;
            protected System.Configuration.ConfigurationElement BaseGet(int index) => throw null;
            protected object[] BaseGetAllKeys() => throw null;
            protected object BaseGetKey(int index) => throw null;
            protected int BaseIndexOf(System.Configuration.ConfigurationElement element) => throw null;
            protected bool BaseIsRemoved(object key) => throw null;
            protected void BaseRemove(object key) => throw null;
            protected void BaseRemoveAt(int index) => throw null;
            protected string ClearElementName { get => throw null; set => throw null; }
            public virtual System.Configuration.ConfigurationElementCollectionType CollectionType { get => throw null; }
            protected ConfigurationElementCollection(System.Collections.IComparer comparer) => throw null;
            protected ConfigurationElementCollection() => throw null;
            void System.Collections.ICollection.CopyTo(System.Array arr, int index) => throw null;
            public void CopyTo(System.Configuration.ConfigurationElement[] array, int index) => throw null;
            public int Count { get => throw null; }
            protected virtual System.Configuration.ConfigurationElement CreateNewElement(string elementName) => throw null;
            protected abstract System.Configuration.ConfigurationElement CreateNewElement();
            protected virtual string ElementName { get => throw null; }
            public bool EmitClear { get => throw null; set => throw null; }
            public override bool Equals(object compareTo) => throw null;
            protected abstract object GetElementKey(System.Configuration.ConfigurationElement element);
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public override int GetHashCode() => throw null;
            protected virtual bool IsElementName(string elementName) => throw null;
            protected virtual bool IsElementRemovable(System.Configuration.ConfigurationElement element) => throw null;
            protected override bool IsModified() => throw null;
            public override bool IsReadOnly() => throw null;
            public bool IsSynchronized { get => throw null; }
            protected override bool OnDeserializeUnrecognizedElement(string elementName, System.Xml.XmlReader reader) => throw null;
            protected string RemoveElementName { get => throw null; set => throw null; }
            protected override void Reset(System.Configuration.ConfigurationElement parentElement) => throw null;
            protected override void ResetModified() => throw null;
            protected override bool SerializeElement(System.Xml.XmlWriter writer, bool serializeCollectionKey) => throw null;
            protected override void SetReadOnly() => throw null;
            public object SyncRoot { get => throw null; }
            protected virtual bool ThrowOnDuplicate { get => throw null; }
            protected override void Unmerge(System.Configuration.ConfigurationElement sourceElement, System.Configuration.ConfigurationElement parentElement, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationElementCollectionType` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ConfigurationElementCollectionType
        {
            AddRemoveClearMap,
            AddRemoveClearMapAlternate,
            BasicMap,
            BasicMapAlternate,
        }

        // Generated from `System.Configuration.ConfigurationElementProperty` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationElementProperty
        {
            public ConfigurationElementProperty(System.Configuration.ConfigurationValidatorBase validator) => throw null;
            public System.Configuration.ConfigurationValidatorBase Validator { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationErrorsException` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationErrorsException : System.Configuration.ConfigurationException
        {
            public override string BareMessage { get => throw null; }
            public ConfigurationErrorsException(string message, string filename, int line) => throw null;
            public ConfigurationErrorsException(string message, System.Xml.XmlReader reader) => throw null;
            public ConfigurationErrorsException(string message, System.Xml.XmlNode node) => throw null;
            public ConfigurationErrorsException(string message, System.Exception inner, string filename, int line) => throw null;
            public ConfigurationErrorsException(string message, System.Exception inner, System.Xml.XmlReader reader) => throw null;
            public ConfigurationErrorsException(string message, System.Exception inner, System.Xml.XmlNode node) => throw null;
            public ConfigurationErrorsException(string message, System.Exception inner) => throw null;
            public ConfigurationErrorsException(string message) => throw null;
            public ConfigurationErrorsException() => throw null;
            protected ConfigurationErrorsException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Collections.ICollection Errors { get => throw null; }
            public override string Filename { get => throw null; }
            public static string GetFilename(System.Xml.XmlReader reader) => throw null;
            public static string GetFilename(System.Xml.XmlNode node) => throw null;
            public static int GetLineNumber(System.Xml.XmlReader reader) => throw null;
            public static int GetLineNumber(System.Xml.XmlNode node) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public override int Line { get => throw null; }
            public override string Message { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationException` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationException : System.SystemException
        {
            public virtual string BareMessage { get => throw null; }
            public ConfigurationException(string message, string filename, int line) => throw null;
            public ConfigurationException(string message, System.Xml.XmlNode node) => throw null;
            public ConfigurationException(string message, System.Exception inner, string filename, int line) => throw null;
            public ConfigurationException(string message, System.Exception inner, System.Xml.XmlNode node) => throw null;
            public ConfigurationException(string message, System.Exception inner) => throw null;
            public ConfigurationException(string message) => throw null;
            public ConfigurationException() => throw null;
            protected ConfigurationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public virtual string Filename { get => throw null; }
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static string GetXmlNodeFilename(System.Xml.XmlNode node) => throw null;
            public static int GetXmlNodeLineNumber(System.Xml.XmlNode node) => throw null;
            public virtual int Line { get => throw null; }
            public override string Message { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationFileMap` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationFileMap : System.ICloneable
        {
            public virtual object Clone() => throw null;
            public ConfigurationFileMap(string machineConfigFilename) => throw null;
            public ConfigurationFileMap() => throw null;
            public string MachineConfigFilename { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationLocation` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationLocation
        {
            public System.Configuration.Configuration OpenConfiguration() => throw null;
            public string Path { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationLocationCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationLocationCollection : System.Collections.ReadOnlyCollectionBase
        {
            public System.Configuration.ConfigurationLocation this[int index] { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationLockCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationLockCollection : System.Collections.IEnumerable, System.Collections.ICollection
        {
            public void Add(string name) => throw null;
            public string AttributeList { get => throw null; }
            public void Clear() => throw null;
            public bool Contains(string name) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public void CopyTo(string[] array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool HasParentElements { get => throw null; }
            public bool IsModified { get => throw null; }
            public bool IsReadOnly(string name) => throw null;
            public bool IsSynchronized { get => throw null; }
            public void Remove(string name) => throw null;
            public void SetFromList(string attributeList) => throw null;
            public object SyncRoot { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationManager` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class ConfigurationManager
        {
            public static System.Collections.Specialized.NameValueCollection AppSettings { get => throw null; }
            public static System.Configuration.ConnectionStringSettingsCollection ConnectionStrings { get => throw null; }
            public static object GetSection(string sectionName) => throw null;
            public static System.Configuration.Configuration OpenExeConfiguration(string exePath) => throw null;
            public static System.Configuration.Configuration OpenExeConfiguration(System.Configuration.ConfigurationUserLevel userLevel) => throw null;
            public static System.Configuration.Configuration OpenMachineConfiguration() => throw null;
            public static System.Configuration.Configuration OpenMappedExeConfiguration(System.Configuration.ExeConfigurationFileMap fileMap, System.Configuration.ConfigurationUserLevel userLevel, bool preLoad) => throw null;
            public static System.Configuration.Configuration OpenMappedExeConfiguration(System.Configuration.ExeConfigurationFileMap fileMap, System.Configuration.ConfigurationUserLevel userLevel) => throw null;
            public static System.Configuration.Configuration OpenMappedMachineConfiguration(System.Configuration.ConfigurationFileMap fileMap) => throw null;
            public static void RefreshSection(string sectionName) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationProperty` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationProperty
        {
            public ConfigurationProperty(string name, System.Type type, object defaultValue, System.Configuration.ConfigurationPropertyOptions options) => throw null;
            public ConfigurationProperty(string name, System.Type type, object defaultValue, System.ComponentModel.TypeConverter typeConverter, System.Configuration.ConfigurationValidatorBase validator, System.Configuration.ConfigurationPropertyOptions options, string description) => throw null;
            public ConfigurationProperty(string name, System.Type type, object defaultValue, System.ComponentModel.TypeConverter typeConverter, System.Configuration.ConfigurationValidatorBase validator, System.Configuration.ConfigurationPropertyOptions options) => throw null;
            public ConfigurationProperty(string name, System.Type type, object defaultValue) => throw null;
            public ConfigurationProperty(string name, System.Type type) => throw null;
            public System.ComponentModel.TypeConverter Converter { get => throw null; }
            public object DefaultValue { get => throw null; }
            public string Description { get => throw null; }
            public bool IsAssemblyStringTransformationRequired { get => throw null; }
            public bool IsDefaultCollection { get => throw null; }
            public bool IsKey { get => throw null; }
            public bool IsRequired { get => throw null; }
            public bool IsTypeStringTransformationRequired { get => throw null; }
            public bool IsVersionCheckRequired { get => throw null; }
            public string Name { get => throw null; }
            public System.Type Type { get => throw null; }
            public System.Configuration.ConfigurationValidatorBase Validator { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationPropertyAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationPropertyAttribute : System.Attribute
        {
            public ConfigurationPropertyAttribute(string name) => throw null;
            public object DefaultValue { get => throw null; set => throw null; }
            public bool IsDefaultCollection { get => throw null; set => throw null; }
            public bool IsKey { get => throw null; set => throw null; }
            public bool IsRequired { get => throw null; set => throw null; }
            public string Name { get => throw null; }
            public System.Configuration.ConfigurationPropertyOptions Options { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationPropertyCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationPropertyCollection : System.Collections.IEnumerable, System.Collections.ICollection
        {
            public void Add(System.Configuration.ConfigurationProperty property) => throw null;
            public void Clear() => throw null;
            public ConfigurationPropertyCollection() => throw null;
            public bool Contains(string name) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public void CopyTo(System.Configuration.ConfigurationProperty[] array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool IsSynchronized { get => throw null; }
            public System.Configuration.ConfigurationProperty this[string name] { get => throw null; }
            public bool Remove(string name) => throw null;
            public object SyncRoot { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationPropertyOptions` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum ConfigurationPropertyOptions
        {
            IsAssemblyStringTransformationRequired,
            IsDefaultCollection,
            IsKey,
            IsRequired,
            IsTypeStringTransformationRequired,
            IsVersionCheckRequired,
            None,
        }

        // Generated from `System.Configuration.ConfigurationSaveMode` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ConfigurationSaveMode
        {
            Full,
            Minimal,
            Modified,
        }

        // Generated from `System.Configuration.ConfigurationSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ConfigurationSection : System.Configuration.ConfigurationElement
        {
            protected ConfigurationSection() => throw null;
            protected virtual void DeserializeSection(System.Xml.XmlReader reader) => throw null;
            protected virtual object GetRuntimeObject() => throw null;
            protected override bool IsModified() => throw null;
            protected override void ResetModified() => throw null;
            public System.Configuration.SectionInformation SectionInformation { get => throw null; }
            protected virtual string SerializeSection(System.Configuration.ConfigurationElement parentElement, string name, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
            protected virtual bool ShouldSerializeElementInTargetVersion(System.Configuration.ConfigurationElement element, string elementName, System.Runtime.Versioning.FrameworkName targetFramework) => throw null;
            protected virtual bool ShouldSerializePropertyInTargetVersion(System.Configuration.ConfigurationProperty property, string propertyName, System.Runtime.Versioning.FrameworkName targetFramework, System.Configuration.ConfigurationElement parentConfigurationElement) => throw null;
            protected virtual bool ShouldSerializeSectionInTargetVersion(System.Runtime.Versioning.FrameworkName targetFramework) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationSectionCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationSectionCollection : System.Collections.Specialized.NameObjectCollectionBase
        {
            public void Add(string name, System.Configuration.ConfigurationSection section) => throw null;
            public void Clear() => throw null;
            public void CopyTo(System.Configuration.ConfigurationSection[] array, int index) => throw null;
            public override int Count { get => throw null; }
            public System.Configuration.ConfigurationSection Get(string name) => throw null;
            public System.Configuration.ConfigurationSection Get(int index) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public string GetKey(int index) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Configuration.ConfigurationSection this[string name] { get => throw null; }
            public System.Configuration.ConfigurationSection this[int index] { get => throw null; }
            public override System.Collections.Specialized.NameObjectCollectionBase.KeysCollection Keys { get => throw null; }
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationSectionGroup` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationSectionGroup
        {
            public ConfigurationSectionGroup() => throw null;
            public void ForceDeclaration(bool force) => throw null;
            public void ForceDeclaration() => throw null;
            public bool IsDeclarationRequired { get => throw null; }
            public bool IsDeclared { get => throw null; }
            public string Name { get => throw null; }
            public string SectionGroupName { get => throw null; }
            public System.Configuration.ConfigurationSectionGroupCollection SectionGroups { get => throw null; }
            public System.Configuration.ConfigurationSectionCollection Sections { get => throw null; }
            protected virtual bool ShouldSerializeSectionGroupInTargetVersion(System.Runtime.Versioning.FrameworkName targetFramework) => throw null;
            public string Type { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationSectionGroupCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationSectionGroupCollection : System.Collections.Specialized.NameObjectCollectionBase
        {
            public void Add(string name, System.Configuration.ConfigurationSectionGroup sectionGroup) => throw null;
            public void Clear() => throw null;
            public void CopyTo(System.Configuration.ConfigurationSectionGroup[] array, int index) => throw null;
            public override int Count { get => throw null; }
            public System.Configuration.ConfigurationSectionGroup Get(string name) => throw null;
            public System.Configuration.ConfigurationSectionGroup Get(int index) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public string GetKey(int index) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Configuration.ConfigurationSectionGroup this[string name] { get => throw null; }
            public System.Configuration.ConfigurationSectionGroup this[int index] { get => throw null; }
            public override System.Collections.Specialized.NameObjectCollectionBase.KeysCollection Keys { get => throw null; }
            public void Remove(string name) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationSettings` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationSettings
        {
            public static System.Collections.Specialized.NameValueCollection AppSettings { get => throw null; }
            public static object GetConfig(string sectionName) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationUserLevel` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum ConfigurationUserLevel
        {
            None,
            PerUserRoaming,
            PerUserRoamingAndLocal,
        }

        // Generated from `System.Configuration.ConfigurationValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationValidatorAttribute : System.Attribute
        {
            public ConfigurationValidatorAttribute(System.Type validator) => throw null;
            protected ConfigurationValidatorAttribute() => throw null;
            public virtual System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
            public System.Type ValidatorType { get => throw null; }
        }

        // Generated from `System.Configuration.ConfigurationValidatorBase` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ConfigurationValidatorBase
        {
            public virtual bool CanValidate(System.Type type) => throw null;
            protected ConfigurationValidatorBase() => throw null;
            public abstract void Validate(object value);
        }

        // Generated from `System.Configuration.ConnectionStringSettings` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConnectionStringSettings : System.Configuration.ConfigurationElement
        {
            public string ConnectionString { get => throw null; set => throw null; }
            public ConnectionStringSettings(string name, string connectionString, string providerName) => throw null;
            public ConnectionStringSettings(string name, string connectionString) => throw null;
            public ConnectionStringSettings() => throw null;
            public string Name { get => throw null; set => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public string ProviderName { get => throw null; set => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Configuration.ConnectionStringSettingsCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConnectionStringSettingsCollection : System.Configuration.ConfigurationElementCollection
        {
            public void Add(System.Configuration.ConnectionStringSettings settings) => throw null;
            protected override void BaseAdd(int index, System.Configuration.ConfigurationElement element) => throw null;
            public void Clear() => throw null;
            public ConnectionStringSettingsCollection() => throw null;
            protected override System.Configuration.ConfigurationElement CreateNewElement() => throw null;
            protected override object GetElementKey(System.Configuration.ConfigurationElement element) => throw null;
            public int IndexOf(System.Configuration.ConnectionStringSettings settings) => throw null;
            public System.Configuration.ConnectionStringSettings this[string name] { get => throw null; }
            public System.Configuration.ConnectionStringSettings this[int index] { get => throw null; set => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public void Remove(string name) => throw null;
            public void Remove(System.Configuration.ConnectionStringSettings settings) => throw null;
            public void RemoveAt(int index) => throw null;
        }

        // Generated from `System.Configuration.ConnectionStringsSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConnectionStringsSection : System.Configuration.ConfigurationSection
        {
            public System.Configuration.ConnectionStringSettingsCollection ConnectionStrings { get => throw null; }
            public ConnectionStringsSection() => throw null;
            protected override object GetRuntimeObject() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
        }

        // Generated from `System.Configuration.ContextInformation` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ContextInformation
        {
            public object GetSection(string sectionName) => throw null;
            public object HostingContext { get => throw null; }
            public bool IsMachineLevel { get => throw null; }
        }

        // Generated from `System.Configuration.DefaultSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DefaultSection : System.Configuration.ConfigurationSection
        {
            public DefaultSection() => throw null;
            protected override void DeserializeSection(System.Xml.XmlReader xmlReader) => throw null;
            protected override bool IsModified() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            protected override void Reset(System.Configuration.ConfigurationElement parentSection) => throw null;
            protected override void ResetModified() => throw null;
            protected override string SerializeSection(System.Configuration.ConfigurationElement parentSection, string name, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
        }

        // Generated from `System.Configuration.DefaultSettingValueAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DefaultSettingValueAttribute : System.Attribute
        {
            public DefaultSettingValueAttribute(string value) => throw null;
            public string Value { get => throw null; }
        }

        // Generated from `System.Configuration.DefaultValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DefaultValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public DefaultValidator() => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.DictionarySectionHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DictionarySectionHandler : System.Configuration.IConfigurationSectionHandler
        {
            public virtual object Create(object parent, object context, System.Xml.XmlNode section) => throw null;
            public DictionarySectionHandler() => throw null;
            protected virtual string KeyAttributeName { get => throw null; }
            protected virtual string ValueAttributeName { get => throw null; }
        }

        // Generated from `System.Configuration.DpapiProtectedConfigurationProvider` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DpapiProtectedConfigurationProvider : System.Configuration.ProtectedConfigurationProvider
        {
            public override System.Xml.XmlNode Decrypt(System.Xml.XmlNode encryptedNode) => throw null;
            public DpapiProtectedConfigurationProvider() => throw null;
            public override System.Xml.XmlNode Encrypt(System.Xml.XmlNode node) => throw null;
            public override void Initialize(string name, System.Collections.Specialized.NameValueCollection configurationValues) => throw null;
            public bool UseMachineProtection { get => throw null; }
        }

        // Generated from `System.Configuration.ElementInformation` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ElementInformation
        {
            public System.Collections.ICollection Errors { get => throw null; }
            public bool IsCollection { get => throw null; }
            public bool IsLocked { get => throw null; }
            public bool IsPresent { get => throw null; }
            public int LineNumber { get => throw null; }
            public System.Configuration.PropertyInformationCollection Properties { get => throw null; }
            public string Source { get => throw null; }
            public System.Type Type { get => throw null; }
            public System.Configuration.ConfigurationValidatorBase Validator { get => throw null; }
        }

        // Generated from `System.Configuration.ExeConfigurationFileMap` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ExeConfigurationFileMap : System.Configuration.ConfigurationFileMap
        {
            public override object Clone() => throw null;
            public string ExeConfigFilename { get => throw null; set => throw null; }
            public ExeConfigurationFileMap(string machineConfigFileName) => throw null;
            public ExeConfigurationFileMap() => throw null;
            public string LocalUserConfigFilename { get => throw null; set => throw null; }
            public string RoamingUserConfigFilename { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.ExeContext` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ExeContext
        {
            public string ExePath { get => throw null; }
            public System.Configuration.ConfigurationUserLevel UserLevel { get => throw null; }
        }

        // Generated from `System.Configuration.GenericEnumConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class GenericEnumConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public GenericEnumConverter(System.Type typeEnum) => throw null;
        }

        // Generated from `System.Configuration.IApplicationSettingsProvider` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IApplicationSettingsProvider
        {
            System.Configuration.SettingsPropertyValue GetPreviousVersion(System.Configuration.SettingsContext context, System.Configuration.SettingsProperty property);
            void Reset(System.Configuration.SettingsContext context);
            void Upgrade(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyCollection properties);
        }

        // Generated from `System.Configuration.IConfigurationSectionHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IConfigurationSectionHandler
        {
            object Create(object parent, object configContext, System.Xml.XmlNode section);
        }

        // Generated from `System.Configuration.IConfigurationSystem` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IConfigurationSystem
        {
            object GetConfig(string configKey);
            void Init();
        }

        // Generated from `System.Configuration.IPersistComponentSettings` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IPersistComponentSettings
        {
            void LoadComponentSettings();
            void ResetComponentSettings();
            void SaveComponentSettings();
            bool SaveSettings { get; set; }
            string SettingsKey { get; set; }
        }

        // Generated from `System.Configuration.ISettingsProviderService` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface ISettingsProviderService
        {
            System.Configuration.SettingsProvider GetSettingsProvider(System.Configuration.SettingsProperty property);
        }

        // Generated from `System.Configuration.IdnElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class IdnElement : System.Configuration.ConfigurationElement
        {
            public System.UriIdnScope Enabled { get => throw null; set => throw null; }
            public IdnElement() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
        }

        // Generated from `System.Configuration.IgnoreSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class IgnoreSection : System.Configuration.ConfigurationSection
        {
            protected override void DeserializeSection(System.Xml.XmlReader xmlReader) => throw null;
            public IgnoreSection() => throw null;
            protected override bool IsModified() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            protected override void Reset(System.Configuration.ConfigurationElement parentSection) => throw null;
            protected override void ResetModified() => throw null;
            protected override string SerializeSection(System.Configuration.ConfigurationElement parentSection, string name, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
        }

        // Generated from `System.Configuration.IgnoreSectionHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class IgnoreSectionHandler : System.Configuration.IConfigurationSectionHandler
        {
            public virtual object Create(object parent, object configContext, System.Xml.XmlNode section) => throw null;
            public IgnoreSectionHandler() => throw null;
        }

        // Generated from `System.Configuration.InfiniteIntConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class InfiniteIntConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public InfiniteIntConverter() => throw null;
        }

        // Generated from `System.Configuration.InfiniteTimeSpanConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class InfiniteTimeSpanConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public InfiniteTimeSpanConverter() => throw null;
        }

        // Generated from `System.Configuration.IntegerValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class IntegerValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public IntegerValidator(int minValue, int maxValue, bool rangeIsExclusive, int resolution) => throw null;
            public IntegerValidator(int minValue, int maxValue, bool rangeIsExclusive) => throw null;
            public IntegerValidator(int minValue, int maxValue) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.IntegerValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class IntegerValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public bool ExcludeRange { get => throw null; set => throw null; }
            public IntegerValidatorAttribute() => throw null;
            public int MaxValue { get => throw null; set => throw null; }
            public int MinValue { get => throw null; set => throw null; }
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.IriParsingElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class IriParsingElement : System.Configuration.ConfigurationElement
        {
            public bool Enabled { get => throw null; set => throw null; }
            public IriParsingElement() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
        }

        // Generated from `System.Configuration.KeyValueConfigurationCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class KeyValueConfigurationCollection : System.Configuration.ConfigurationElementCollection
        {
            public void Add(string key, string value) => throw null;
            public void Add(System.Configuration.KeyValueConfigurationElement keyValue) => throw null;
            public string[] AllKeys { get => throw null; }
            public void Clear() => throw null;
            protected override System.Configuration.ConfigurationElement CreateNewElement() => throw null;
            protected override object GetElementKey(System.Configuration.ConfigurationElement element) => throw null;
            public System.Configuration.KeyValueConfigurationElement this[string key] { get => throw null; }
            public KeyValueConfigurationCollection() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public void Remove(string key) => throw null;
            protected override bool ThrowOnDuplicate { get => throw null; }
        }

        // Generated from `System.Configuration.KeyValueConfigurationElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class KeyValueConfigurationElement : System.Configuration.ConfigurationElement
        {
            protected override void Init() => throw null;
            public string Key { get => throw null; }
            public KeyValueConfigurationElement(string key, string value) => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public string Value { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.LocalFileSettingsProvider` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class LocalFileSettingsProvider : System.Configuration.SettingsProvider, System.Configuration.IApplicationSettingsProvider
        {
            public override string ApplicationName { get => throw null; set => throw null; }
            public System.Configuration.SettingsPropertyValue GetPreviousVersion(System.Configuration.SettingsContext context, System.Configuration.SettingsProperty property) => throw null;
            public override System.Configuration.SettingsPropertyValueCollection GetPropertyValues(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyCollection properties) => throw null;
            public override void Initialize(string name, System.Collections.Specialized.NameValueCollection values) => throw null;
            public LocalFileSettingsProvider() => throw null;
            public void Reset(System.Configuration.SettingsContext context) => throw null;
            public override void SetPropertyValues(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyValueCollection values) => throw null;
            public void Upgrade(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyCollection properties) => throw null;
        }

        // Generated from `System.Configuration.LongValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class LongValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public LongValidator(System.Int64 minValue, System.Int64 maxValue, bool rangeIsExclusive, System.Int64 resolution) => throw null;
            public LongValidator(System.Int64 minValue, System.Int64 maxValue, bool rangeIsExclusive) => throw null;
            public LongValidator(System.Int64 minValue, System.Int64 maxValue) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.LongValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class LongValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public bool ExcludeRange { get => throw null; set => throw null; }
            public LongValidatorAttribute() => throw null;
            public System.Int64 MaxValue { get => throw null; set => throw null; }
            public System.Int64 MinValue { get => throw null; set => throw null; }
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.NameValueConfigurationCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class NameValueConfigurationCollection : System.Configuration.ConfigurationElementCollection
        {
            public void Add(System.Configuration.NameValueConfigurationElement nameValue) => throw null;
            public string[] AllKeys { get => throw null; }
            public void Clear() => throw null;
            protected override System.Configuration.ConfigurationElement CreateNewElement() => throw null;
            protected override object GetElementKey(System.Configuration.ConfigurationElement element) => throw null;
            public System.Configuration.NameValueConfigurationElement this[string name] { get => throw null; set => throw null; }
            public NameValueConfigurationCollection() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public void Remove(string name) => throw null;
            public void Remove(System.Configuration.NameValueConfigurationElement nameValue) => throw null;
        }

        // Generated from `System.Configuration.NameValueConfigurationElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class NameValueConfigurationElement : System.Configuration.ConfigurationElement
        {
            public string Name { get => throw null; }
            public NameValueConfigurationElement(string name, string value) => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public string Value { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.NameValueFileSectionHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class NameValueFileSectionHandler : System.Configuration.IConfigurationSectionHandler
        {
            public object Create(object parent, object configContext, System.Xml.XmlNode section) => throw null;
            public NameValueFileSectionHandler() => throw null;
        }

        // Generated from `System.Configuration.NameValueSectionHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class NameValueSectionHandler : System.Configuration.IConfigurationSectionHandler
        {
            public object Create(object parent, object context, System.Xml.XmlNode section) => throw null;
            protected virtual string KeyAttributeName { get => throw null; }
            public NameValueSectionHandler() => throw null;
            protected virtual string ValueAttributeName { get => throw null; }
        }

        // Generated from `System.Configuration.NoSettingsVersionUpgradeAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class NoSettingsVersionUpgradeAttribute : System.Attribute
        {
            public NoSettingsVersionUpgradeAttribute() => throw null;
        }

        // Generated from `System.Configuration.OverrideMode` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum OverrideMode
        {
            Allow,
            Deny,
            Inherit,
        }

        // Generated from `System.Configuration.PositiveTimeSpanValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PositiveTimeSpanValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public PositiveTimeSpanValidator() => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.PositiveTimeSpanValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PositiveTimeSpanValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public PositiveTimeSpanValidatorAttribute() => throw null;
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.PropertyInformation` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PropertyInformation
        {
            public System.ComponentModel.TypeConverter Converter { get => throw null; }
            public object DefaultValue { get => throw null; }
            public string Description { get => throw null; }
            public bool IsKey { get => throw null; }
            public bool IsLocked { get => throw null; }
            public bool IsModified { get => throw null; }
            public bool IsRequired { get => throw null; }
            public int LineNumber { get => throw null; }
            public string Name { get => throw null; }
            public string Source { get => throw null; }
            public System.Type Type { get => throw null; }
            public System.Configuration.ConfigurationValidatorBase Validator { get => throw null; }
            public object Value { get => throw null; set => throw null; }
            public System.Configuration.PropertyValueOrigin ValueOrigin { get => throw null; }
        }

        // Generated from `System.Configuration.PropertyInformationCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PropertyInformationCollection : System.Collections.Specialized.NameObjectCollectionBase
        {
            public void CopyTo(System.Configuration.PropertyInformation[] array, int index) => throw null;
            public override System.Collections.IEnumerator GetEnumerator() => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Configuration.PropertyInformation this[string propertyName] { get => throw null; }
        }

        // Generated from `System.Configuration.PropertyValueOrigin` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum PropertyValueOrigin
        {
            Default,
            Inherited,
            SetHere,
        }

        // Generated from `System.Configuration.ProtectedConfiguration` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class ProtectedConfiguration
        {
            public const string DataProtectionProviderName = default;
            public static string DefaultProvider { get => throw null; }
            public const string ProtectedDataSectionName = default;
            public static System.Configuration.ProtectedConfigurationProviderCollection Providers { get => throw null; }
            public const string RsaProviderName = default;
        }

        // Generated from `System.Configuration.ProtectedConfigurationProvider` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class ProtectedConfigurationProvider : System.Configuration.Provider.ProviderBase
        {
            public abstract System.Xml.XmlNode Decrypt(System.Xml.XmlNode encryptedNode);
            public abstract System.Xml.XmlNode Encrypt(System.Xml.XmlNode node);
            protected ProtectedConfigurationProvider() => throw null;
        }

        // Generated from `System.Configuration.ProtectedConfigurationProviderCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ProtectedConfigurationProviderCollection : System.Configuration.Provider.ProviderCollection
        {
            public override void Add(System.Configuration.Provider.ProviderBase provider) => throw null;
            public System.Configuration.ProtectedConfigurationProvider this[string name] { get => throw null; }
            public ProtectedConfigurationProviderCollection() => throw null;
        }

        // Generated from `System.Configuration.ProtectedConfigurationSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ProtectedConfigurationSection : System.Configuration.ConfigurationSection
        {
            public string DefaultProvider { get => throw null; set => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public ProtectedConfigurationSection() => throw null;
            public System.Configuration.ProviderSettingsCollection Providers { get => throw null; }
        }

        // Generated from `System.Configuration.ProtectedProviderSettings` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ProtectedProviderSettings : System.Configuration.ConfigurationElement
        {
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public ProtectedProviderSettings() => throw null;
            public System.Configuration.ProviderSettingsCollection Providers { get => throw null; }
        }

        // Generated from `System.Configuration.ProviderSettings` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ProviderSettings : System.Configuration.ConfigurationElement
        {
            protected override bool IsModified() => throw null;
            public string Name { get => throw null; set => throw null; }
            protected override bool OnDeserializeUnrecognizedAttribute(string name, string value) => throw null;
            public System.Collections.Specialized.NameValueCollection Parameters { get => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public ProviderSettings(string name, string type) => throw null;
            public ProviderSettings() => throw null;
            protected override void Reset(System.Configuration.ConfigurationElement parentElement) => throw null;
            public string Type { get => throw null; set => throw null; }
            protected override void Unmerge(System.Configuration.ConfigurationElement sourceElement, System.Configuration.ConfigurationElement parentElement, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
        }

        // Generated from `System.Configuration.ProviderSettingsCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ProviderSettingsCollection : System.Configuration.ConfigurationElementCollection
        {
            public void Add(System.Configuration.ProviderSettings provider) => throw null;
            public void Clear() => throw null;
            protected override System.Configuration.ConfigurationElement CreateNewElement() => throw null;
            protected override object GetElementKey(System.Configuration.ConfigurationElement element) => throw null;
            public System.Configuration.ProviderSettings this[string key] { get => throw null; }
            public System.Configuration.ProviderSettings this[int index] { get => throw null; set => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public ProviderSettingsCollection() => throw null;
            public void Remove(string name) => throw null;
        }

        // Generated from `System.Configuration.RegexStringValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class RegexStringValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public RegexStringValidator(string regex) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.RegexStringValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class RegexStringValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public string Regex { get => throw null; }
            public RegexStringValidatorAttribute(string regex) => throw null;
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.RsaProtectedConfigurationProvider` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class RsaProtectedConfigurationProvider : System.Configuration.ProtectedConfigurationProvider
        {
            public void AddKey(int keySize, bool exportable) => throw null;
            public string CspProviderName { get => throw null; }
            public override System.Xml.XmlNode Decrypt(System.Xml.XmlNode encryptedNode) => throw null;
            public void DeleteKey() => throw null;
            public override System.Xml.XmlNode Encrypt(System.Xml.XmlNode node) => throw null;
            public void ExportKey(string xmlFileName, bool includePrivateParameters) => throw null;
            public void ImportKey(string xmlFileName, bool exportable) => throw null;
            public override void Initialize(string name, System.Collections.Specialized.NameValueCollection configurationValues) => throw null;
            public string KeyContainerName { get => throw null; }
            public RsaProtectedConfigurationProvider() => throw null;
            public System.Security.Cryptography.RSAParameters RsaPublicKey { get => throw null; }
            public bool UseFIPS { get => throw null; }
            public bool UseMachineContainer { get => throw null; }
            public bool UseOAEP { get => throw null; }
        }

        // Generated from `System.Configuration.SchemeSettingElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SchemeSettingElement : System.Configuration.ConfigurationElement
        {
            public System.GenericUriParserOptions GenericUriParserOptions { get => throw null; }
            public string Name { get => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public SchemeSettingElement() => throw null;
        }

        // Generated from `System.Configuration.SchemeSettingElementCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SchemeSettingElementCollection : System.Configuration.ConfigurationElementCollection
        {
            public override System.Configuration.ConfigurationElementCollectionType CollectionType { get => throw null; }
            protected override System.Configuration.ConfigurationElement CreateNewElement() => throw null;
            protected override object GetElementKey(System.Configuration.ConfigurationElement element) => throw null;
            public int IndexOf(System.Configuration.SchemeSettingElement element) => throw null;
            public System.Configuration.SchemeSettingElement this[string name] { get => throw null; }
            public System.Configuration.SchemeSettingElement this[int index] { get => throw null; }
            public SchemeSettingElementCollection() => throw null;
        }

        // Generated from `System.Configuration.SectionInformation` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SectionInformation
        {
            public System.Configuration.ConfigurationAllowDefinition AllowDefinition { get => throw null; set => throw null; }
            public System.Configuration.ConfigurationAllowExeDefinition AllowExeDefinition { get => throw null; set => throw null; }
            public bool AllowLocation { get => throw null; set => throw null; }
            public bool AllowOverride { get => throw null; set => throw null; }
            public string ConfigSource { get => throw null; set => throw null; }
            public void ForceDeclaration(bool force) => throw null;
            public void ForceDeclaration() => throw null;
            public bool ForceSave { get => throw null; set => throw null; }
            public System.Configuration.ConfigurationSection GetParentSection() => throw null;
            public string GetRawXml() => throw null;
            public bool InheritInChildApplications { get => throw null; set => throw null; }
            public bool IsDeclarationRequired { get => throw null; }
            public bool IsDeclared { get => throw null; }
            public bool IsLocked { get => throw null; }
            public bool IsProtected { get => throw null; }
            public string Name { get => throw null; }
            public System.Configuration.OverrideMode OverrideMode { get => throw null; set => throw null; }
            public System.Configuration.OverrideMode OverrideModeDefault { get => throw null; set => throw null; }
            public System.Configuration.OverrideMode OverrideModeEffective { get => throw null; }
            public void ProtectSection(string protectionProvider) => throw null;
            public System.Configuration.ProtectedConfigurationProvider ProtectionProvider { get => throw null; }
            public bool RequirePermission { get => throw null; set => throw null; }
            public bool RestartOnExternalChanges { get => throw null; set => throw null; }
            public void RevertToParent() => throw null;
            public string SectionName { get => throw null; }
            public void SetRawXml(string rawXml) => throw null;
            public string Type { get => throw null; set => throw null; }
            public void UnprotectSection() => throw null;
        }

        // Generated from `System.Configuration.SettingAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingAttribute : System.Attribute
        {
            public SettingAttribute() => throw null;
        }

        // Generated from `System.Configuration.SettingChangingEventArgs` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingChangingEventArgs : System.ComponentModel.CancelEventArgs
        {
            public object NewValue { get => throw null; }
            public SettingChangingEventArgs(string settingName, string settingClass, string settingKey, object newValue, bool cancel) => throw null;
            public string SettingClass { get => throw null; }
            public string SettingKey { get => throw null; }
            public string SettingName { get => throw null; }
        }

        // Generated from `System.Configuration.SettingChangingEventHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void SettingChangingEventHandler(object sender, System.Configuration.SettingChangingEventArgs e);

        // Generated from `System.Configuration.SettingElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingElement : System.Configuration.ConfigurationElement
        {
            public override bool Equals(object settings) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; set => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public System.Configuration.SettingsSerializeAs SerializeAs { get => throw null; set => throw null; }
            public SettingElement(string name, System.Configuration.SettingsSerializeAs serializeAs) => throw null;
            public SettingElement() => throw null;
            public System.Configuration.SettingValueElement Value { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.SettingElementCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingElementCollection : System.Configuration.ConfigurationElementCollection
        {
            public void Add(System.Configuration.SettingElement element) => throw null;
            public void Clear() => throw null;
            public override System.Configuration.ConfigurationElementCollectionType CollectionType { get => throw null; }
            protected override System.Configuration.ConfigurationElement CreateNewElement() => throw null;
            protected override string ElementName { get => throw null; }
            public System.Configuration.SettingElement Get(string elementKey) => throw null;
            protected override object GetElementKey(System.Configuration.ConfigurationElement element) => throw null;
            public void Remove(System.Configuration.SettingElement element) => throw null;
            public SettingElementCollection() => throw null;
        }

        // Generated from `System.Configuration.SettingValueElement` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingValueElement : System.Configuration.ConfigurationElement
        {
            protected override void DeserializeElement(System.Xml.XmlReader reader, bool serializeCollectionKey) => throw null;
            public override bool Equals(object settingValue) => throw null;
            public override int GetHashCode() => throw null;
            protected override bool IsModified() => throw null;
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            protected override void Reset(System.Configuration.ConfigurationElement parentElement) => throw null;
            protected override void ResetModified() => throw null;
            protected override bool SerializeToXmlElement(System.Xml.XmlWriter writer, string elementName) => throw null;
            public SettingValueElement() => throw null;
            protected override void Unmerge(System.Configuration.ConfigurationElement sourceElement, System.Configuration.ConfigurationElement parentElement, System.Configuration.ConfigurationSaveMode saveMode) => throw null;
            public System.Xml.XmlNode ValueXml { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.SettingsAttributeDictionary` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsAttributeDictionary : System.Collections.Hashtable
        {
            public SettingsAttributeDictionary(System.Configuration.SettingsAttributeDictionary attributes) => throw null;
            public SettingsAttributeDictionary() => throw null;
        }

        // Generated from `System.Configuration.SettingsBase` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class SettingsBase
        {
            public virtual System.Configuration.SettingsContext Context { get => throw null; }
            public void Initialize(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyCollection properties, System.Configuration.SettingsProviderCollection providers) => throw null;
            public bool IsSynchronized { get => throw null; }
            public virtual object this[string propertyName] { get => throw null; set => throw null; }
            public virtual System.Configuration.SettingsPropertyCollection Properties { get => throw null; }
            public virtual System.Configuration.SettingsPropertyValueCollection PropertyValues { get => throw null; }
            public virtual System.Configuration.SettingsProviderCollection Providers { get => throw null; }
            public virtual void Save() => throw null;
            protected SettingsBase() => throw null;
            public static System.Configuration.SettingsBase Synchronized(System.Configuration.SettingsBase settingsBase) => throw null;
        }

        // Generated from `System.Configuration.SettingsContext` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsContext : System.Collections.Hashtable
        {
            public SettingsContext() => throw null;
        }

        // Generated from `System.Configuration.SettingsDescriptionAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsDescriptionAttribute : System.Attribute
        {
            public string Description { get => throw null; }
            public SettingsDescriptionAttribute(string description) => throw null;
        }

        // Generated from `System.Configuration.SettingsGroupDescriptionAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsGroupDescriptionAttribute : System.Attribute
        {
            public string Description { get => throw null; }
            public SettingsGroupDescriptionAttribute(string description) => throw null;
        }

        // Generated from `System.Configuration.SettingsGroupNameAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsGroupNameAttribute : System.Attribute
        {
            public string GroupName { get => throw null; }
            public SettingsGroupNameAttribute(string groupName) => throw null;
        }

        // Generated from `System.Configuration.SettingsLoadedEventArgs` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsLoadedEventArgs : System.EventArgs
        {
            public System.Configuration.SettingsProvider Provider { get => throw null; }
            public SettingsLoadedEventArgs(System.Configuration.SettingsProvider provider) => throw null;
        }

        // Generated from `System.Configuration.SettingsLoadedEventHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void SettingsLoadedEventHandler(object sender, System.Configuration.SettingsLoadedEventArgs e);

        // Generated from `System.Configuration.SettingsManageability` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum SettingsManageability
        {
            Roaming,
        }

        // Generated from `System.Configuration.SettingsManageabilityAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsManageabilityAttribute : System.Attribute
        {
            public System.Configuration.SettingsManageability Manageability { get => throw null; }
            public SettingsManageabilityAttribute(System.Configuration.SettingsManageability manageability) => throw null;
        }

        // Generated from `System.Configuration.SettingsProperty` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsProperty
        {
            public virtual System.Configuration.SettingsAttributeDictionary Attributes { get => throw null; }
            public virtual object DefaultValue { get => throw null; set => throw null; }
            public virtual bool IsReadOnly { get => throw null; set => throw null; }
            public virtual string Name { get => throw null; set => throw null; }
            public virtual System.Type PropertyType { get => throw null; set => throw null; }
            public virtual System.Configuration.SettingsProvider Provider { get => throw null; set => throw null; }
            public virtual System.Configuration.SettingsSerializeAs SerializeAs { get => throw null; set => throw null; }
            public SettingsProperty(string name, System.Type propertyType, System.Configuration.SettingsProvider provider, bool isReadOnly, object defaultValue, System.Configuration.SettingsSerializeAs serializeAs, System.Configuration.SettingsAttributeDictionary attributes, bool throwOnErrorDeserializing, bool throwOnErrorSerializing) => throw null;
            public SettingsProperty(string name) => throw null;
            public SettingsProperty(System.Configuration.SettingsProperty propertyToCopy) => throw null;
            public bool ThrowOnErrorDeserializing { get => throw null; set => throw null; }
            public bool ThrowOnErrorSerializing { get => throw null; set => throw null; }
        }

        // Generated from `System.Configuration.SettingsPropertyCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsPropertyCollection : System.ICloneable, System.Collections.IEnumerable, System.Collections.ICollection
        {
            public void Add(System.Configuration.SettingsProperty property) => throw null;
            public void Clear() => throw null;
            public object Clone() => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool IsSynchronized { get => throw null; }
            public System.Configuration.SettingsProperty this[string name] { get => throw null; }
            protected virtual void OnAdd(System.Configuration.SettingsProperty property) => throw null;
            protected virtual void OnAddComplete(System.Configuration.SettingsProperty property) => throw null;
            protected virtual void OnClear() => throw null;
            protected virtual void OnClearComplete() => throw null;
            protected virtual void OnRemove(System.Configuration.SettingsProperty property) => throw null;
            protected virtual void OnRemoveComplete(System.Configuration.SettingsProperty property) => throw null;
            public void Remove(string name) => throw null;
            public void SetReadOnly() => throw null;
            public SettingsPropertyCollection() => throw null;
            public object SyncRoot { get => throw null; }
        }

        // Generated from `System.Configuration.SettingsPropertyIsReadOnlyException` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsPropertyIsReadOnlyException : System.Exception
        {
            public SettingsPropertyIsReadOnlyException(string message, System.Exception innerException) => throw null;
            public SettingsPropertyIsReadOnlyException(string message) => throw null;
            public SettingsPropertyIsReadOnlyException() => throw null;
            protected SettingsPropertyIsReadOnlyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }

        // Generated from `System.Configuration.SettingsPropertyNotFoundException` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsPropertyNotFoundException : System.Exception
        {
            public SettingsPropertyNotFoundException(string message, System.Exception innerException) => throw null;
            public SettingsPropertyNotFoundException(string message) => throw null;
            public SettingsPropertyNotFoundException() => throw null;
            protected SettingsPropertyNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }

        // Generated from `System.Configuration.SettingsPropertyValue` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsPropertyValue
        {
            public bool Deserialized { get => throw null; set => throw null; }
            public bool IsDirty { get => throw null; set => throw null; }
            public string Name { get => throw null; }
            public System.Configuration.SettingsProperty Property { get => throw null; }
            public object PropertyValue { get => throw null; set => throw null; }
            public object SerializedValue { get => throw null; set => throw null; }
            public SettingsPropertyValue(System.Configuration.SettingsProperty property) => throw null;
            public bool UsingDefaultValue { get => throw null; }
        }

        // Generated from `System.Configuration.SettingsPropertyValueCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsPropertyValueCollection : System.ICloneable, System.Collections.IEnumerable, System.Collections.ICollection
        {
            public void Add(System.Configuration.SettingsPropertyValue property) => throw null;
            public void Clear() => throw null;
            public object Clone() => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public bool IsSynchronized { get => throw null; }
            public System.Configuration.SettingsPropertyValue this[string name] { get => throw null; }
            public void Remove(string name) => throw null;
            public void SetReadOnly() => throw null;
            public SettingsPropertyValueCollection() => throw null;
            public object SyncRoot { get => throw null; }
        }

        // Generated from `System.Configuration.SettingsPropertyWrongTypeException` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsPropertyWrongTypeException : System.Exception
        {
            public SettingsPropertyWrongTypeException(string message, System.Exception innerException) => throw null;
            public SettingsPropertyWrongTypeException(string message) => throw null;
            public SettingsPropertyWrongTypeException() => throw null;
            protected SettingsPropertyWrongTypeException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }

        // Generated from `System.Configuration.SettingsProvider` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class SettingsProvider : System.Configuration.Provider.ProviderBase
        {
            public abstract string ApplicationName { get; set; }
            public abstract System.Configuration.SettingsPropertyValueCollection GetPropertyValues(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyCollection collection);
            public abstract void SetPropertyValues(System.Configuration.SettingsContext context, System.Configuration.SettingsPropertyValueCollection collection);
            protected SettingsProvider() => throw null;
        }

        // Generated from `System.Configuration.SettingsProviderAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsProviderAttribute : System.Attribute
        {
            public string ProviderTypeName { get => throw null; }
            public SettingsProviderAttribute(string providerTypeName) => throw null;
            public SettingsProviderAttribute(System.Type providerType) => throw null;
        }

        // Generated from `System.Configuration.SettingsProviderCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsProviderCollection : System.Configuration.Provider.ProviderCollection
        {
            public override void Add(System.Configuration.Provider.ProviderBase provider) => throw null;
            public System.Configuration.SettingsProvider this[string name] { get => throw null; }
            public SettingsProviderCollection() => throw null;
        }

        // Generated from `System.Configuration.SettingsSavingEventHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void SettingsSavingEventHandler(object sender, System.ComponentModel.CancelEventArgs e);

        // Generated from `System.Configuration.SettingsSerializeAs` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum SettingsSerializeAs
        {
            Binary,
            ProviderSpecific,
            String,
            Xml,
        }

        // Generated from `System.Configuration.SettingsSerializeAsAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SettingsSerializeAsAttribute : System.Attribute
        {
            public System.Configuration.SettingsSerializeAs SerializeAs { get => throw null; }
            public SettingsSerializeAsAttribute(System.Configuration.SettingsSerializeAs serializeAs) => throw null;
        }

        // Generated from `System.Configuration.SingleTagSectionHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SingleTagSectionHandler : System.Configuration.IConfigurationSectionHandler
        {
            public virtual object Create(object parent, object context, System.Xml.XmlNode section) => throw null;
            public SingleTagSectionHandler() => throw null;
        }

        // Generated from `System.Configuration.SpecialSetting` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum SpecialSetting
        {
            ConnectionString,
            WebServiceUrl,
        }

        // Generated from `System.Configuration.SpecialSettingAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SpecialSettingAttribute : System.Attribute
        {
            public System.Configuration.SpecialSetting SpecialSetting { get => throw null; }
            public SpecialSettingAttribute(System.Configuration.SpecialSetting specialSetting) => throw null;
        }

        // Generated from `System.Configuration.StringValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class StringValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public StringValidator(int minLength, int maxLength, string invalidCharacters) => throw null;
            public StringValidator(int minLength, int maxLength) => throw null;
            public StringValidator(int minLength) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.StringValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class StringValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public string InvalidCharacters { get => throw null; set => throw null; }
            public int MaxLength { get => throw null; set => throw null; }
            public int MinLength { get => throw null; set => throw null; }
            public StringValidatorAttribute() => throw null;
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.SubclassTypeValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SubclassTypeValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public SubclassTypeValidator(System.Type baseClass) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.SubclassTypeValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SubclassTypeValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public System.Type BaseClass { get => throw null; }
            public SubclassTypeValidatorAttribute(System.Type baseClass) => throw null;
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.TimeSpanMinutesConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TimeSpanMinutesConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public TimeSpanMinutesConverter() => throw null;
        }

        // Generated from `System.Configuration.TimeSpanMinutesOrInfiniteConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TimeSpanMinutesOrInfiniteConverter : System.Configuration.TimeSpanMinutesConverter
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public TimeSpanMinutesOrInfiniteConverter() => throw null;
        }

        // Generated from `System.Configuration.TimeSpanSecondsConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TimeSpanSecondsConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public TimeSpanSecondsConverter() => throw null;
        }

        // Generated from `System.Configuration.TimeSpanSecondsOrInfiniteConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TimeSpanSecondsOrInfiniteConverter : System.Configuration.TimeSpanSecondsConverter
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public TimeSpanSecondsOrInfiniteConverter() => throw null;
        }

        // Generated from `System.Configuration.TimeSpanValidator` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TimeSpanValidator : System.Configuration.ConfigurationValidatorBase
        {
            public override bool CanValidate(System.Type type) => throw null;
            public TimeSpanValidator(System.TimeSpan minValue, System.TimeSpan maxValue, bool rangeIsExclusive, System.Int64 resolutionInSeconds) => throw null;
            public TimeSpanValidator(System.TimeSpan minValue, System.TimeSpan maxValue, bool rangeIsExclusive) => throw null;
            public TimeSpanValidator(System.TimeSpan minValue, System.TimeSpan maxValue) => throw null;
            public override void Validate(object value) => throw null;
        }

        // Generated from `System.Configuration.TimeSpanValidatorAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TimeSpanValidatorAttribute : System.Configuration.ConfigurationValidatorAttribute
        {
            public bool ExcludeRange { get => throw null; set => throw null; }
            public System.TimeSpan MaxValue { get => throw null; }
            public string MaxValueString { get => throw null; set => throw null; }
            public System.TimeSpan MinValue { get => throw null; }
            public string MinValueString { get => throw null; set => throw null; }
            public const string TimeSpanMaxValue = default;
            public const string TimeSpanMinValue = default;
            public TimeSpanValidatorAttribute() => throw null;
            public override System.Configuration.ConfigurationValidatorBase ValidatorInstance { get => throw null; }
        }

        // Generated from `System.Configuration.TypeNameConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class TypeNameConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public TypeNameConverter() => throw null;
        }

        // Generated from `System.Configuration.UriSection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UriSection : System.Configuration.ConfigurationSection
        {
            public System.Configuration.IdnElement Idn { get => throw null; }
            public System.Configuration.IriParsingElement IriParsing { get => throw null; }
            protected override System.Configuration.ConfigurationPropertyCollection Properties { get => throw null; }
            public System.Configuration.SchemeSettingElementCollection SchemeSettings { get => throw null; }
            public UriSection() => throw null;
        }

        // Generated from `System.Configuration.UserScopedSettingAttribute` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UserScopedSettingAttribute : System.Configuration.SettingAttribute
        {
            public UserScopedSettingAttribute() => throw null;
        }

        // Generated from `System.Configuration.UserSettingsGroup` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class UserSettingsGroup : System.Configuration.ConfigurationSectionGroup
        {
            public UserSettingsGroup() => throw null;
        }

        // Generated from `System.Configuration.ValidatorCallback` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate void ValidatorCallback(object value);

        // Generated from `System.Configuration.WhiteSpaceTrimStringConverter` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class WhiteSpaceTrimStringConverter : System.Configuration.ConfigurationConverterBase
        {
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object data) => throw null;
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext ctx, System.Globalization.CultureInfo ci, object value, System.Type type) => throw null;
            public WhiteSpaceTrimStringConverter() => throw null;
        }

        namespace Internal
        {
            // Generated from `System.Configuration.Internal.DelegatingConfigHost` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class DelegatingConfigHost : System.Configuration.Internal.IInternalConfigHost
            {
                public virtual object CreateConfigurationContext(string configPath, string locationSubPath) => throw null;
                public virtual object CreateDeprecatedConfigContext(string configPath) => throw null;
                public virtual string DecryptSection(string encryptedXml, System.Configuration.ProtectedConfigurationProvider protectionProvider, System.Configuration.ProtectedConfigurationSection protectedConfigSection) => throw null;
                protected DelegatingConfigHost() => throw null;
                public virtual void DeleteStream(string streamName) => throw null;
                public virtual string EncryptSection(string clearTextXml, System.Configuration.ProtectedConfigurationProvider protectionProvider, System.Configuration.ProtectedConfigurationSection protectedConfigSection) => throw null;
                public virtual string GetConfigPathFromLocationSubPath(string configPath, string locationSubPath) => throw null;
                public virtual System.Type GetConfigType(string typeName, bool throwOnError) => throw null;
                public virtual string GetConfigTypeName(System.Type t) => throw null;
                public virtual string GetStreamName(string configPath) => throw null;
                public virtual string GetStreamNameForConfigSource(string streamName, string configSource) => throw null;
                public virtual object GetStreamVersion(string streamName) => throw null;
                protected System.Configuration.Internal.IInternalConfigHost Host { get => throw null; set => throw null; }
                public virtual System.IDisposable Impersonate() => throw null;
                public virtual void Init(System.Configuration.Internal.IInternalConfigRoot configRoot, params object[] hostInitParams) => throw null;
                public virtual void InitForConfiguration(ref string locationSubPath, out string configPath, out string locationConfigPath, System.Configuration.Internal.IInternalConfigRoot configRoot, params object[] hostInitConfigurationParams) => throw null;
                public virtual bool IsAboveApplication(string configPath) => throw null;
                public virtual bool IsConfigRecordRequired(string configPath) => throw null;
                public virtual bool IsDefinitionAllowed(string configPath, System.Configuration.ConfigurationAllowDefinition allowDefinition, System.Configuration.ConfigurationAllowExeDefinition allowExeDefinition) => throw null;
                public virtual bool IsFile(string streamName) => throw null;
                public virtual bool IsFullTrustSectionWithoutAptcaAllowed(System.Configuration.Internal.IInternalConfigRecord configRecord) => throw null;
                public virtual bool IsInitDelayed(System.Configuration.Internal.IInternalConfigRecord configRecord) => throw null;
                public virtual bool IsLocationApplicable(string configPath) => throw null;
                public virtual bool IsRemote { get => throw null; }
                public virtual bool IsSecondaryRoot(string configPath) => throw null;
                public virtual bool IsTrustedConfigPath(string configPath) => throw null;
                public virtual System.IO.Stream OpenStreamForRead(string streamName, bool assertPermissions) => throw null;
                public virtual System.IO.Stream OpenStreamForRead(string streamName) => throw null;
                public virtual System.IO.Stream OpenStreamForWrite(string streamName, string templateStreamName, ref object writeContext, bool assertPermissions) => throw null;
                public virtual System.IO.Stream OpenStreamForWrite(string streamName, string templateStreamName, ref object writeContext) => throw null;
                public virtual bool PrefetchAll(string configPath, string streamName) => throw null;
                public virtual bool PrefetchSection(string sectionGroupName, string sectionName) => throw null;
                public virtual void RequireCompleteInit(System.Configuration.Internal.IInternalConfigRecord configRecord) => throw null;
                public virtual object StartMonitoringStreamForChanges(string streamName, System.Configuration.Internal.StreamChangeCallback callback) => throw null;
                public virtual void StopMonitoringStreamForChanges(string streamName, System.Configuration.Internal.StreamChangeCallback callback) => throw null;
                public virtual bool SupportsChangeNotifications { get => throw null; }
                public virtual bool SupportsLocation { get => throw null; }
                public virtual bool SupportsPath { get => throw null; }
                public virtual bool SupportsRefresh { get => throw null; }
                public virtual void VerifyDefinitionAllowed(string configPath, System.Configuration.ConfigurationAllowDefinition allowDefinition, System.Configuration.ConfigurationAllowExeDefinition allowExeDefinition, System.Configuration.Internal.IConfigErrorInfo errorInfo) => throw null;
                public virtual void WriteCompleted(string streamName, bool success, object writeContext, bool assertPermissions) => throw null;
                public virtual void WriteCompleted(string streamName, bool success, object writeContext) => throw null;
            }

            // Generated from `System.Configuration.Internal.IConfigErrorInfo` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IConfigErrorInfo
            {
                string Filename { get; }
                int LineNumber { get; }
            }

            // Generated from `System.Configuration.Internal.IConfigSystem` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IConfigSystem
            {
                System.Configuration.Internal.IInternalConfigHost Host { get; }
                void Init(System.Type typeConfigHost, params object[] hostInitParams);
                System.Configuration.Internal.IInternalConfigRoot Root { get; }
            }

            // Generated from `System.Configuration.Internal.IConfigurationManagerHelper` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IConfigurationManagerHelper
            {
                void EnsureNetConfigLoaded();
            }

            // Generated from `System.Configuration.Internal.IConfigurationManagerInternal` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IConfigurationManagerInternal
            {
                string ApplicationConfigUri { get; }
                string ExeLocalConfigDirectory { get; }
                string ExeLocalConfigPath { get; }
                string ExeProductName { get; }
                string ExeProductVersion { get; }
                string ExeRoamingConfigDirectory { get; }
                string ExeRoamingConfigPath { get; }
                string MachineConfigPath { get; }
                bool SetConfigurationSystemInProgress { get; }
                bool SupportsUserConfig { get; }
                string UserConfigFilename { get; }
            }

            // Generated from `System.Configuration.Internal.IInternalConfigClientHost` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigClientHost
            {
                string GetExeConfigPath();
                string GetLocalUserConfigPath();
                string GetRoamingUserConfigPath();
                bool IsExeConfig(string configPath);
                bool IsLocalUserConfig(string configPath);
                bool IsRoamingUserConfig(string configPath);
            }

            // Generated from `System.Configuration.Internal.IInternalConfigConfigurationFactory` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigConfigurationFactory
            {
                System.Configuration.Configuration Create(System.Type typeConfigHost, params object[] hostInitConfigurationParams);
                string NormalizeLocationSubPath(string subPath, System.Configuration.Internal.IConfigErrorInfo errorInfo);
            }

            // Generated from `System.Configuration.Internal.IInternalConfigHost` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigHost
            {
                object CreateConfigurationContext(string configPath, string locationSubPath);
                object CreateDeprecatedConfigContext(string configPath);
                string DecryptSection(string encryptedXml, System.Configuration.ProtectedConfigurationProvider protectionProvider, System.Configuration.ProtectedConfigurationSection protectedConfigSection);
                void DeleteStream(string streamName);
                string EncryptSection(string clearTextXml, System.Configuration.ProtectedConfigurationProvider protectionProvider, System.Configuration.ProtectedConfigurationSection protectedConfigSection);
                string GetConfigPathFromLocationSubPath(string configPath, string locationSubPath);
                System.Type GetConfigType(string typeName, bool throwOnError);
                string GetConfigTypeName(System.Type t);
                string GetStreamName(string configPath);
                string GetStreamNameForConfigSource(string streamName, string configSource);
                object GetStreamVersion(string streamName);
                System.IDisposable Impersonate();
                void Init(System.Configuration.Internal.IInternalConfigRoot configRoot, params object[] hostInitParams);
                void InitForConfiguration(ref string locationSubPath, out string configPath, out string locationConfigPath, System.Configuration.Internal.IInternalConfigRoot configRoot, params object[] hostInitConfigurationParams);
                bool IsAboveApplication(string configPath);
                bool IsConfigRecordRequired(string configPath);
                bool IsDefinitionAllowed(string configPath, System.Configuration.ConfigurationAllowDefinition allowDefinition, System.Configuration.ConfigurationAllowExeDefinition allowExeDefinition);
                bool IsFile(string streamName);
                bool IsFullTrustSectionWithoutAptcaAllowed(System.Configuration.Internal.IInternalConfigRecord configRecord);
                bool IsInitDelayed(System.Configuration.Internal.IInternalConfigRecord configRecord);
                bool IsLocationApplicable(string configPath);
                bool IsRemote { get; }
                bool IsSecondaryRoot(string configPath);
                bool IsTrustedConfigPath(string configPath);
                System.IO.Stream OpenStreamForRead(string streamName, bool assertPermissions);
                System.IO.Stream OpenStreamForRead(string streamName);
                System.IO.Stream OpenStreamForWrite(string streamName, string templateStreamName, ref object writeContext, bool assertPermissions);
                System.IO.Stream OpenStreamForWrite(string streamName, string templateStreamName, ref object writeContext);
                bool PrefetchAll(string configPath, string streamName);
                bool PrefetchSection(string sectionGroupName, string sectionName);
                void RequireCompleteInit(System.Configuration.Internal.IInternalConfigRecord configRecord);
                object StartMonitoringStreamForChanges(string streamName, System.Configuration.Internal.StreamChangeCallback callback);
                void StopMonitoringStreamForChanges(string streamName, System.Configuration.Internal.StreamChangeCallback callback);
                bool SupportsChangeNotifications { get; }
                bool SupportsLocation { get; }
                bool SupportsPath { get; }
                bool SupportsRefresh { get; }
                void VerifyDefinitionAllowed(string configPath, System.Configuration.ConfigurationAllowDefinition allowDefinition, System.Configuration.ConfigurationAllowExeDefinition allowExeDefinition, System.Configuration.Internal.IConfigErrorInfo errorInfo);
                void WriteCompleted(string streamName, bool success, object writeContext, bool assertPermissions);
                void WriteCompleted(string streamName, bool success, object writeContext);
            }

            // Generated from `System.Configuration.Internal.IInternalConfigRecord` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigRecord
            {
                string ConfigPath { get; }
                object GetLkgSection(string configKey);
                object GetSection(string configKey);
                bool HasInitErrors { get; }
                void RefreshSection(string configKey);
                void Remove();
                string StreamName { get; }
                void ThrowIfInitErrors();
            }

            // Generated from `System.Configuration.Internal.IInternalConfigRoot` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigRoot
            {
                event System.Configuration.Internal.InternalConfigEventHandler ConfigChanged;
                event System.Configuration.Internal.InternalConfigEventHandler ConfigRemoved;
                System.Configuration.Internal.IInternalConfigRecord GetConfigRecord(string configPath);
                object GetSection(string section, string configPath);
                string GetUniqueConfigPath(string configPath);
                System.Configuration.Internal.IInternalConfigRecord GetUniqueConfigRecord(string configPath);
                void Init(System.Configuration.Internal.IInternalConfigHost host, bool isDesignTime);
                bool IsDesignTime { get; }
                void RemoveConfig(string configPath);
            }

            // Generated from `System.Configuration.Internal.IInternalConfigSettingsFactory` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigSettingsFactory
            {
                void CompleteInit();
                void SetConfigurationSystem(System.Configuration.Internal.IInternalConfigSystem internalConfigSystem, bool initComplete);
            }

            // Generated from `System.Configuration.Internal.IInternalConfigSystem` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IInternalConfigSystem
            {
                object GetSection(string configKey);
                void RefreshConfig(string sectionName);
                bool SupportsUserConfig { get; }
            }

            // Generated from `System.Configuration.Internal.InternalConfigEventArgs` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class InternalConfigEventArgs : System.EventArgs
            {
                public string ConfigPath { get => throw null; set => throw null; }
                public InternalConfigEventArgs(string configPath) => throw null;
            }

            // Generated from `System.Configuration.Internal.InternalConfigEventHandler` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void InternalConfigEventHandler(object sender, System.Configuration.Internal.InternalConfigEventArgs e);

            // Generated from `System.Configuration.Internal.StreamChangeCallback` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate void StreamChangeCallback(string streamName);

        }
        namespace Provider
        {
            // Generated from `System.Configuration.Provider.ProviderBase` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class ProviderBase
            {
                public virtual string Description { get => throw null; }
                public virtual void Initialize(string name, System.Collections.Specialized.NameValueCollection config) => throw null;
                public virtual string Name { get => throw null; }
                protected ProviderBase() => throw null;
            }

            // Generated from `System.Configuration.Provider.ProviderCollection` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ProviderCollection : System.Collections.IEnumerable, System.Collections.ICollection
            {
                public virtual void Add(System.Configuration.Provider.ProviderBase provider) => throw null;
                public void Clear() => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Configuration.Provider.ProviderBase[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Configuration.Provider.ProviderBase this[string name] { get => throw null; }
                public ProviderCollection() => throw null;
                public void Remove(string name) => throw null;
                public void SetReadOnly() => throw null;
                public object SyncRoot { get => throw null; }
            }

            // Generated from `System.Configuration.Provider.ProviderException` in `System.Configuration.ConfigurationManager, Version=4.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ProviderException : System.Exception
            {
                public ProviderException(string message, System.Exception innerException) => throw null;
                public ProviderException(string message) => throw null;
                public ProviderException() => throw null;
                protected ProviderException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }

        }
    }
}
