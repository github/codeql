// This file contains auto-generated code.
// Generated from `System.ComponentModel, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace ComponentModel
    {
        public class CancelEventArgs : System.EventArgs
        {
            public bool Cancel { get => throw null; set { } }
            public CancelEventArgs() => throw null;
            public CancelEventArgs(bool cancel) => throw null;
        }
        public interface IChangeTracking
        {
            void AcceptChanges();
            bool IsChanged { get; }
        }
        public interface IEditableObject
        {
            void BeginEdit();
            void CancelEdit();
            void EndEdit();
        }
        public interface IRevertibleChangeTracking : System.ComponentModel.IChangeTracking
        {
            void RejectChanges();
        }
    }
    public interface IServiceProvider
    {
        object GetService(System.Type serviceType);
    }
}
