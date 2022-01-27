// This file contains auto-generated code.

namespace System
{
    // Generated from `System.IServiceProvider` in `System.ComponentModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
    public interface IServiceProvider
    {
        object GetService(System.Type serviceType);
    }

    namespace ComponentModel
    {
        // Generated from `System.ComponentModel.CancelEventArgs` in `System.ComponentModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CancelEventArgs : System.EventArgs
        {
            public bool Cancel { get => throw null; set => throw null; }
            public CancelEventArgs() => throw null;
            public CancelEventArgs(bool cancel) => throw null;
        }

        // Generated from `System.ComponentModel.IChangeTracking` in `System.ComponentModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IChangeTracking
        {
            void AcceptChanges();
            bool IsChanged { get; }
        }

        // Generated from `System.ComponentModel.IEditableObject` in `System.ComponentModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IEditableObject
        {
            void BeginEdit();
            void CancelEdit();
            void EndEdit();
        }

        // Generated from `System.ComponentModel.IRevertibleChangeTracking` in `System.ComponentModel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IRevertibleChangeTracking : System.ComponentModel.IChangeTracking
        {
            void RejectChanges();
        }

    }
}
