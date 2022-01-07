// This file contains auto-generated code.

namespace System
{
    namespace ComponentModel
    {
        // Generated from `System.ComponentModel.BrowsableAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BrowsableAttribute : System.Attribute
        {
            public bool Browsable { get => throw null; }
            public BrowsableAttribute(bool browsable) => throw null;
            public static System.ComponentModel.BrowsableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.BrowsableAttribute No;
            public static System.ComponentModel.BrowsableAttribute Yes;
        }

        // Generated from `System.ComponentModel.CategoryAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.ComponentModel.Component` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Component : System.MarshalByRefObject, System.ComponentModel.IComponent, System.IDisposable
        {
            protected virtual bool CanRaiseEvents { get => throw null; }
            public Component() => throw null;
            public System.ComponentModel.IContainer Container { get => throw null; }
            protected bool DesignMode { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public event System.EventHandler Disposed;
            protected System.ComponentModel.EventHandlerList Events { get => throw null; }
            protected virtual object GetService(System.Type service) => throw null;
            public virtual System.ComponentModel.ISite Site { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            // ERR: Stub generator didn't handle member: ~Component
        }

        // Generated from `System.ComponentModel.ComponentCollection` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ComponentCollection : System.Collections.ReadOnlyCollectionBase
        {
            public ComponentCollection(System.ComponentModel.IComponent[] components) => throw null;
            public void CopyTo(System.ComponentModel.IComponent[] array, int index) => throw null;
            public virtual System.ComponentModel.IComponent this[int index] { get => throw null; }
            public virtual System.ComponentModel.IComponent this[string name] { get => throw null; }
        }

        // Generated from `System.ComponentModel.DescriptionAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DescriptionAttribute : System.Attribute
        {
            public static System.ComponentModel.DescriptionAttribute Default;
            public virtual string Description { get => throw null; }
            public DescriptionAttribute() => throw null;
            public DescriptionAttribute(string description) => throw null;
            protected string DescriptionValue { get => throw null; set => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
        }

        // Generated from `System.ComponentModel.DesignOnlyAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DesignOnlyAttribute : System.Attribute
        {
            public static System.ComponentModel.DesignOnlyAttribute Default;
            public DesignOnlyAttribute(bool isDesignOnly) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool IsDesignOnly { get => throw null; }
            public static System.ComponentModel.DesignOnlyAttribute No;
            public static System.ComponentModel.DesignOnlyAttribute Yes;
        }

        // Generated from `System.ComponentModel.DesignerAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DesignerAttribute : System.Attribute
        {
            public DesignerAttribute(System.Type designerType) => throw null;
            public DesignerAttribute(System.Type designerType, System.Type designerBaseType) => throw null;
            public DesignerAttribute(string designerTypeName) => throw null;
            public DesignerAttribute(string designerTypeName, System.Type designerBaseType) => throw null;
            public DesignerAttribute(string designerTypeName, string designerBaseTypeName) => throw null;
            public string DesignerBaseTypeName { get => throw null; }
            public string DesignerTypeName { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override object TypeId { get => throw null; }
        }

        // Generated from `System.ComponentModel.DesignerCategoryAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DesignerCategoryAttribute : System.Attribute
        {
            public string Category { get => throw null; }
            public static System.ComponentModel.DesignerCategoryAttribute Component;
            public static System.ComponentModel.DesignerCategoryAttribute Default;
            public DesignerCategoryAttribute() => throw null;
            public DesignerCategoryAttribute(string category) => throw null;
            public override bool Equals(object obj) => throw null;
            public static System.ComponentModel.DesignerCategoryAttribute Form;
            public static System.ComponentModel.DesignerCategoryAttribute Generic;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public override object TypeId { get => throw null; }
        }

        // Generated from `System.ComponentModel.DesignerSerializationVisibility` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DesignerSerializationVisibility
        {
            Content,
            Hidden,
            Visible,
        }

        // Generated from `System.ComponentModel.DesignerSerializationVisibilityAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DesignerSerializationVisibilityAttribute : System.Attribute
        {
            public static System.ComponentModel.DesignerSerializationVisibilityAttribute Content;
            public static System.ComponentModel.DesignerSerializationVisibilityAttribute Default;
            public DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility visibility) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static System.ComponentModel.DesignerSerializationVisibilityAttribute Hidden;
            public override bool IsDefaultAttribute() => throw null;
            public System.ComponentModel.DesignerSerializationVisibility Visibility { get => throw null; }
            public static System.ComponentModel.DesignerSerializationVisibilityAttribute Visible;
        }

        // Generated from `System.ComponentModel.DisplayNameAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DisplayNameAttribute : System.Attribute
        {
            public static System.ComponentModel.DisplayNameAttribute Default;
            public virtual string DisplayName { get => throw null; }
            public DisplayNameAttribute() => throw null;
            public DisplayNameAttribute(string displayName) => throw null;
            protected string DisplayNameValue { get => throw null; set => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
        }

        // Generated from `System.ComponentModel.EditorAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EditorAttribute : System.Attribute
        {
            public EditorAttribute() => throw null;
            public EditorAttribute(System.Type type, System.Type baseType) => throw null;
            public EditorAttribute(string typeName, System.Type baseType) => throw null;
            public EditorAttribute(string typeName, string baseTypeName) => throw null;
            public string EditorBaseTypeName { get => throw null; }
            public string EditorTypeName { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override object TypeId { get => throw null; }
        }

        // Generated from `System.ComponentModel.EventHandlerList` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class EventHandlerList : System.IDisposable
        {
            public void AddHandler(object key, System.Delegate value) => throw null;
            public void AddHandlers(System.ComponentModel.EventHandlerList listToAddFrom) => throw null;
            public void Dispose() => throw null;
            public EventHandlerList() => throw null;
            public System.Delegate this[object key] { get => throw null; set => throw null; }
            public void RemoveHandler(object key, System.Delegate value) => throw null;
        }

        // Generated from `System.ComponentModel.IComponent` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IComponent : System.IDisposable
        {
            event System.EventHandler Disposed;
            System.ComponentModel.ISite Site { get; set; }
        }

        // Generated from `System.ComponentModel.IContainer` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IContainer : System.IDisposable
        {
            void Add(System.ComponentModel.IComponent component);
            void Add(System.ComponentModel.IComponent component, string name);
            System.ComponentModel.ComponentCollection Components { get; }
            void Remove(System.ComponentModel.IComponent component);
        }

        // Generated from `System.ComponentModel.ISite` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ISite : System.IServiceProvider
        {
            System.ComponentModel.IComponent Component { get; }
            System.ComponentModel.IContainer Container { get; }
            bool DesignMode { get; }
            string Name { get; set; }
        }

        // Generated from `System.ComponentModel.ISupportInitialize` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ISupportInitialize
        {
            void BeginInit();
            void EndInit();
        }

        // Generated from `System.ComponentModel.ISynchronizeInvoke` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ISynchronizeInvoke
        {
            System.IAsyncResult BeginInvoke(System.Delegate method, object[] args);
            object EndInvoke(System.IAsyncResult result);
            object Invoke(System.Delegate method, object[] args);
            bool InvokeRequired { get; }
        }

        // Generated from `System.ComponentModel.ImmutableObjectAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ImmutableObjectAttribute : System.Attribute
        {
            public static System.ComponentModel.ImmutableObjectAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public bool Immutable { get => throw null; }
            public ImmutableObjectAttribute(bool immutable) => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.ImmutableObjectAttribute No;
            public static System.ComponentModel.ImmutableObjectAttribute Yes;
        }

        // Generated from `System.ComponentModel.InitializationEventAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InitializationEventAttribute : System.Attribute
        {
            public string EventName { get => throw null; }
            public InitializationEventAttribute(string eventName) => throw null;
        }

        // Generated from `System.ComponentModel.InvalidAsynchronousStateException` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InvalidAsynchronousStateException : System.ArgumentException
        {
            public InvalidAsynchronousStateException() => throw null;
            protected InvalidAsynchronousStateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidAsynchronousStateException(string message) => throw null;
            public InvalidAsynchronousStateException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.ComponentModel.InvalidEnumArgumentException` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InvalidEnumArgumentException : System.ArgumentException
        {
            public InvalidEnumArgumentException() => throw null;
            protected InvalidEnumArgumentException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InvalidEnumArgumentException(string message) => throw null;
            public InvalidEnumArgumentException(string message, System.Exception innerException) => throw null;
            public InvalidEnumArgumentException(string argumentName, int invalidValue, System.Type enumClass) => throw null;
        }

        // Generated from `System.ComponentModel.LocalizableAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LocalizableAttribute : System.Attribute
        {
            public static System.ComponentModel.LocalizableAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool IsLocalizable { get => throw null; }
            public LocalizableAttribute(bool isLocalizable) => throw null;
            public static System.ComponentModel.LocalizableAttribute No;
            public static System.ComponentModel.LocalizableAttribute Yes;
        }

        // Generated from `System.ComponentModel.MergablePropertyAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MergablePropertyAttribute : System.Attribute
        {
            public bool AllowMerge { get => throw null; }
            public static System.ComponentModel.MergablePropertyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public MergablePropertyAttribute(bool allowMerge) => throw null;
            public static System.ComponentModel.MergablePropertyAttribute No;
            public static System.ComponentModel.MergablePropertyAttribute Yes;
        }

        // Generated from `System.ComponentModel.NotifyParentPropertyAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class NotifyParentPropertyAttribute : System.Attribute
        {
            public static System.ComponentModel.NotifyParentPropertyAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public static System.ComponentModel.NotifyParentPropertyAttribute No;
            public bool NotifyParent { get => throw null; }
            public NotifyParentPropertyAttribute(bool notifyParent) => throw null;
            public static System.ComponentModel.NotifyParentPropertyAttribute Yes;
        }

        // Generated from `System.ComponentModel.ParenthesizePropertyNameAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ParenthesizePropertyNameAttribute : System.Attribute
        {
            public static System.ComponentModel.ParenthesizePropertyNameAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool NeedParenthesis { get => throw null; }
            public ParenthesizePropertyNameAttribute() => throw null;
            public ParenthesizePropertyNameAttribute(bool needParenthesis) => throw null;
        }

        // Generated from `System.ComponentModel.ReadOnlyAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ReadOnlyAttribute : System.Attribute
        {
            public static System.ComponentModel.ReadOnlyAttribute Default;
            public override bool Equals(object value) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public bool IsReadOnly { get => throw null; }
            public static System.ComponentModel.ReadOnlyAttribute No;
            public ReadOnlyAttribute(bool isReadOnly) => throw null;
            public static System.ComponentModel.ReadOnlyAttribute Yes;
        }

        // Generated from `System.ComponentModel.RefreshProperties` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum RefreshProperties
        {
            All,
            None,
            Repaint,
        }

        // Generated from `System.ComponentModel.RefreshPropertiesAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RefreshPropertiesAttribute : System.Attribute
        {
            public static System.ComponentModel.RefreshPropertiesAttribute All;
            public static System.ComponentModel.RefreshPropertiesAttribute Default;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public override bool IsDefaultAttribute() => throw null;
            public System.ComponentModel.RefreshProperties RefreshProperties { get => throw null; }
            public RefreshPropertiesAttribute(System.ComponentModel.RefreshProperties refresh) => throw null;
            public static System.ComponentModel.RefreshPropertiesAttribute Repaint;
        }

        namespace Design
        {
            namespace Serialization
            {
                // Generated from `System.ComponentModel.Design.Serialization.DesignerSerializerAttribute` in `System.ComponentModel.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DesignerSerializerAttribute : System.Attribute
                {
                    public DesignerSerializerAttribute(System.Type serializerType, System.Type baseSerializerType) => throw null;
                    public DesignerSerializerAttribute(string serializerTypeName, System.Type baseSerializerType) => throw null;
                    public DesignerSerializerAttribute(string serializerTypeName, string baseSerializerTypeName) => throw null;
                    public string SerializerBaseTypeName { get => throw null; }
                    public string SerializerTypeName { get => throw null; }
                    public override object TypeId { get => throw null; }
                }

            }
        }
    }
}
