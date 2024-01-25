// This file contains auto-generated code.
// Generated from `System.ComponentModel.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace ComponentModel
    {
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class BrowsableAttribute : System.Attribute
        {
            public bool Browsable { get => throw null; }
            public BrowsableAttribute(bool browsable) => throw null;
            public static readonly System.ComponentModel.BrowsableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.BrowsableAttribute No;
            public static readonly System.ComponentModel.BrowsableAttribute Yes;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class CategoryAttribute : System.Attribute
        {
            public static System.ComponentModel.CategoryAttribute Action { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Appearance { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Asynchronous { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Behavior { get => throw null; }
            public string Category { get => throw null; }
            public CategoryAttribute() => throw null;
            public CategoryAttribute(string category) => throw null;
            public static System.ComponentModel.CategoryAttribute Data { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Default { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Design { get => throw null; }
            public static System.ComponentModel.CategoryAttribute DragDrop { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public static System.ComponentModel.CategoryAttribute Focus { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Format { get => throw null; }
            public override int GetHashCode() => throw null;
            protected virtual string GetLocalizedString(string value) => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.CategoryAttribute Key { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Layout { get => throw null; }
            public static System.ComponentModel.CategoryAttribute Mouse { get => throw null; }
            public static System.ComponentModel.CategoryAttribute WindowStyle { get => throw null; }
        }
        public class Component : System.MarshalByRefObject, System.ComponentModel.IComponent, System.IDisposable
        {
            protected virtual bool CanRaiseEvents { get => throw null; }
            public System.ComponentModel.IContainer Container { get => throw null; }
            public Component() => throw null;
            protected bool DesignMode { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public event System.EventHandler Disposed;
            protected System.ComponentModel.EventHandlerList Events { get => throw null; }
            protected virtual object GetService(System.Type service) => throw null;
            public virtual System.ComponentModel.ISite Site { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public class ComponentCollection : System.Collections.ReadOnlyCollectionBase
        {
            public void CopyTo(System.ComponentModel.IComponent[] array, int index) => throw null;
            public ComponentCollection(System.ComponentModel.IComponent[] components) => throw null;
            public virtual System.ComponentModel.IComponent this[int index] { get => throw null; }
            public virtual System.ComponentModel.IComponent this[string name] { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public class DescriptionAttribute : System.Attribute
        {
            public DescriptionAttribute() => throw null;
            public DescriptionAttribute(string description) => throw null;
            public static readonly System.ComponentModel.DescriptionAttribute Default;
            public virtual string Description { get => throw null; }
            protected string DescriptionValue { get => throw null; set { } }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
        }
        namespace Design
        {
            namespace Serialization
            {
                [System.AttributeUsage((System.AttributeTargets)1028, AllowMultiple = true, Inherited = true)]
                public sealed class DesignerSerializerAttribute : System.Attribute
                {
                    public DesignerSerializerAttribute(string serializerTypeName, string baseSerializerTypeName) => throw null;
                    public DesignerSerializerAttribute(string serializerTypeName, System.Type baseSerializerType) => throw null;
                    public DesignerSerializerAttribute(System.Type serializerType, System.Type baseSerializerType) => throw null;
                    public string SerializerBaseTypeName { get => throw null; }
                    public string SerializerTypeName { get => throw null; }
                    public override object TypeId { get => throw null; }
                }
            }
        }
        [System.AttributeUsage((System.AttributeTargets)1028, AllowMultiple = true, Inherited = true)]
        public sealed class DesignerAttribute : System.Attribute
        {
            public DesignerAttribute(string designerTypeName) => throw null;
            public DesignerAttribute(string designerTypeName, string designerBaseTypeName) => throw null;
            public DesignerAttribute(string designerTypeName, System.Type designerBaseType) => throw null;
            public DesignerAttribute(System.Type designerType) => throw null;
            public DesignerAttribute(System.Type designerType, System.Type designerBaseType) => throw null;
            public string DesignerBaseTypeName { get => throw null; }
            public string DesignerTypeName { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override object TypeId { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
        public sealed class DesignerCategoryAttribute : System.Attribute
        {
            public string Category { get => throw null; }
            public static readonly System.ComponentModel.DesignerCategoryAttribute Component;
            public DesignerCategoryAttribute() => throw null;
            public DesignerCategoryAttribute(string category) => throw null;
            public static readonly System.ComponentModel.DesignerCategoryAttribute Default;
            public override bool Equals(object obj) => throw null;
            public static readonly System.ComponentModel.DesignerCategoryAttribute Form;
            public static readonly System.ComponentModel.DesignerCategoryAttribute Generic;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public override object TypeId { get => throw null; }
        }
        public enum DesignerSerializationVisibility
        {
            Hidden = 0,
            Visible = 1,
            Content = 2,
        }
        [System.AttributeUsage((System.AttributeTargets)960)]
        public sealed class DesignerSerializationVisibilityAttribute : System.Attribute
        {
            public static readonly System.ComponentModel.DesignerSerializationVisibilityAttribute Content;
            public DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility visibility) => throw null;
            public static readonly System.ComponentModel.DesignerSerializationVisibilityAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static readonly System.ComponentModel.DesignerSerializationVisibilityAttribute Hidden;
            public override bool IsDefaultAttribute() => throw null;
            public System.ComponentModel.DesignerSerializationVisibility Visibility { get => throw null; }
            public static readonly System.ComponentModel.DesignerSerializationVisibilityAttribute Visible;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class DesignOnlyAttribute : System.Attribute
        {
            public DesignOnlyAttribute(bool isDesignOnly) => throw null;
            public static readonly System.ComponentModel.DesignOnlyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool IsDesignOnly { get => throw null; }
            public static readonly System.ComponentModel.DesignOnlyAttribute No;
            public static readonly System.ComponentModel.DesignOnlyAttribute Yes;
        }
        [System.AttributeUsage((System.AttributeTargets)708)]
        public class DisplayNameAttribute : System.Attribute
        {
            public DisplayNameAttribute() => throw null;
            public DisplayNameAttribute(string displayName) => throw null;
            public static readonly System.ComponentModel.DisplayNameAttribute Default;
            public virtual string DisplayName { get => throw null; }
            protected string DisplayNameValue { get => throw null; set { } }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767, AllowMultiple = true, Inherited = true)]
        public sealed class EditorAttribute : System.Attribute
        {
            public EditorAttribute() => throw null;
            public EditorAttribute(string typeName, string baseTypeName) => throw null;
            public EditorAttribute(string typeName, System.Type baseType) => throw null;
            public EditorAttribute(System.Type type, System.Type baseType) => throw null;
            public string EditorBaseTypeName { get => throw null; }
            public string EditorTypeName { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override object TypeId { get => throw null; }
        }
        public sealed class EventHandlerList : System.IDisposable
        {
            public void AddHandler(object key, System.Delegate value) => throw null;
            public void AddHandlers(System.ComponentModel.EventHandlerList listToAddFrom) => throw null;
            public EventHandlerList() => throw null;
            public void Dispose() => throw null;
            public void RemoveHandler(object key, System.Delegate value) => throw null;
            public System.Delegate this[object key] { get => throw null; set { } }
        }
        public interface IComponent : System.IDisposable
        {
            event System.EventHandler Disposed;
            System.ComponentModel.ISite Site { get; set; }
        }
        public interface IContainer : System.IDisposable
        {
            void Add(System.ComponentModel.IComponent component);
            void Add(System.ComponentModel.IComponent component, string name);
            System.ComponentModel.ComponentCollection Components { get; }
            void Remove(System.ComponentModel.IComponent component);
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class ImmutableObjectAttribute : System.Attribute
        {
            public ImmutableObjectAttribute(bool immutable) => throw null;
            public static readonly System.ComponentModel.ImmutableObjectAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool Immutable { get => throw null; }
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.ImmutableObjectAttribute No;
            public static readonly System.ComponentModel.ImmutableObjectAttribute Yes;
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public sealed class InitializationEventAttribute : System.Attribute
        {
            public InitializationEventAttribute(string eventName) => throw null;
            public string EventName { get => throw null; }
        }
        public class InvalidAsynchronousStateException : System.ArgumentException
        {
            public InvalidAsynchronousStateException() => throw null;
            protected InvalidAsynchronousStateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidAsynchronousStateException(string message) => throw null;
            public InvalidAsynchronousStateException(string message, System.Exception innerException) => throw null;
        }
        public class InvalidEnumArgumentException : System.ArgumentException
        {
            public InvalidEnumArgumentException() => throw null;
            protected InvalidEnumArgumentException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidEnumArgumentException(string message) => throw null;
            public InvalidEnumArgumentException(string message, System.Exception innerException) => throw null;
            public InvalidEnumArgumentException(string argumentName, int invalidValue, System.Type enumClass) => throw null;
        }
        public interface ISite : System.IServiceProvider
        {
            System.ComponentModel.IComponent Component { get; }
            System.ComponentModel.IContainer Container { get; }
            bool DesignMode { get; }
            string Name { get; set; }
        }
        public interface ISupportInitialize
        {
            void BeginInit();
            void EndInit();
        }
        public interface ISynchronizeInvoke
        {
            System.IAsyncResult BeginInvoke(System.Delegate method, object[] args);
            object EndInvoke(System.IAsyncResult result);
            object Invoke(System.Delegate method, object[] args);
            bool InvokeRequired { get; }
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class LocalizableAttribute : System.Attribute
        {
            public LocalizableAttribute(bool isLocalizable) => throw null;
            public static readonly System.ComponentModel.LocalizableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool IsLocalizable { get => throw null; }
            public static readonly System.ComponentModel.LocalizableAttribute No;
            public static readonly System.ComponentModel.LocalizableAttribute Yes;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class MergablePropertyAttribute : System.Attribute
        {
            public bool AllowMerge { get => throw null; }
            public MergablePropertyAttribute(bool allowMerge) => throw null;
            public static readonly System.ComponentModel.MergablePropertyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.MergablePropertyAttribute No;
            public static readonly System.ComponentModel.MergablePropertyAttribute Yes;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public sealed class NotifyParentPropertyAttribute : System.Attribute
        {
            public NotifyParentPropertyAttribute(bool notifyParent) => throw null;
            public static readonly System.ComponentModel.NotifyParentPropertyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static readonly System.ComponentModel.NotifyParentPropertyAttribute No;
            public bool NotifyParent { get => throw null; }
            public static readonly System.ComponentModel.NotifyParentPropertyAttribute Yes;
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class ParenthesizePropertyNameAttribute : System.Attribute
        {
            public ParenthesizePropertyNameAttribute() => throw null;
            public ParenthesizePropertyNameAttribute(bool needParenthesis) => throw null;
            public static readonly System.ComponentModel.ParenthesizePropertyNameAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool NeedParenthesis { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class ReadOnlyAttribute : System.Attribute
        {
            public ReadOnlyAttribute(bool isReadOnly) => throw null;
            public static readonly System.ComponentModel.ReadOnlyAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool IsReadOnly { get => throw null; }
            public static readonly System.ComponentModel.ReadOnlyAttribute No;
            public static readonly System.ComponentModel.ReadOnlyAttribute Yes;
        }
        public enum RefreshProperties
        {
            None = 0,
            All = 1,
            Repaint = 2,
        }
        [System.AttributeUsage((System.AttributeTargets)32767)]
        public sealed class RefreshPropertiesAttribute : System.Attribute
        {
            public static readonly System.ComponentModel.RefreshPropertiesAttribute All;
            public RefreshPropertiesAttribute(System.ComponentModel.RefreshProperties refresh) => throw null;
            public static readonly System.ComponentModel.RefreshPropertiesAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public System.ComponentModel.RefreshProperties RefreshProperties { get => throw null; }
            public static readonly System.ComponentModel.RefreshPropertiesAttribute Repaint;
        }
    }
}
