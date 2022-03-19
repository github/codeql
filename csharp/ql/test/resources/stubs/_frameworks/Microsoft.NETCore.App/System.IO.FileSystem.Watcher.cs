// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        // Generated from `System.IO.ErrorEventArgs` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ErrorEventArgs : System.EventArgs
        {
            public ErrorEventArgs(System.Exception exception) => throw null;
            public virtual System.Exception GetException() => throw null;
        }

        // Generated from `System.IO.ErrorEventHandler` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void ErrorEventHandler(object sender, System.IO.ErrorEventArgs e);

        // Generated from `System.IO.FileSystemEventArgs` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FileSystemEventArgs : System.EventArgs
        {
            public System.IO.WatcherChangeTypes ChangeType { get => throw null; }
            public FileSystemEventArgs(System.IO.WatcherChangeTypes changeType, string directory, string name) => throw null;
            public string FullPath { get => throw null; }
            public string Name { get => throw null; }
        }

        // Generated from `System.IO.FileSystemEventHandler` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void FileSystemEventHandler(object sender, System.IO.FileSystemEventArgs e);

        // Generated from `System.IO.FileSystemWatcher` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FileSystemWatcher : System.ComponentModel.Component, System.ComponentModel.ISupportInitialize
        {
            public void BeginInit() => throw null;
            public event System.IO.FileSystemEventHandler Changed;
            public event System.IO.FileSystemEventHandler Created;
            public event System.IO.FileSystemEventHandler Deleted;
            protected override void Dispose(bool disposing) => throw null;
            public bool EnableRaisingEvents { get => throw null; set => throw null; }
            public void EndInit() => throw null;
            public event System.IO.ErrorEventHandler Error;
            public FileSystemWatcher() => throw null;
            public FileSystemWatcher(string path) => throw null;
            public FileSystemWatcher(string path, string filter) => throw null;
            public string Filter { get => throw null; set => throw null; }
            public System.Collections.ObjectModel.Collection<string> Filters { get => throw null; }
            public bool IncludeSubdirectories { get => throw null; set => throw null; }
            public int InternalBufferSize { get => throw null; set => throw null; }
            public System.IO.NotifyFilters NotifyFilter { get => throw null; set => throw null; }
            protected void OnChanged(System.IO.FileSystemEventArgs e) => throw null;
            protected void OnCreated(System.IO.FileSystemEventArgs e) => throw null;
            protected void OnDeleted(System.IO.FileSystemEventArgs e) => throw null;
            protected void OnError(System.IO.ErrorEventArgs e) => throw null;
            protected void OnRenamed(System.IO.RenamedEventArgs e) => throw null;
            public string Path { get => throw null; set => throw null; }
            public event System.IO.RenamedEventHandler Renamed;
            public override System.ComponentModel.ISite Site { get => throw null; set => throw null; }
            public System.ComponentModel.ISynchronizeInvoke SynchronizingObject { get => throw null; set => throw null; }
            public System.IO.WaitForChangedResult WaitForChanged(System.IO.WatcherChangeTypes changeType) => throw null;
            public System.IO.WaitForChangedResult WaitForChanged(System.IO.WatcherChangeTypes changeType, int timeout) => throw null;
        }

        // Generated from `System.IO.InternalBufferOverflowException` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class InternalBufferOverflowException : System.SystemException
        {
            public InternalBufferOverflowException() => throw null;
            protected InternalBufferOverflowException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InternalBufferOverflowException(string message) => throw null;
            public InternalBufferOverflowException(string message, System.Exception inner) => throw null;
        }

        // Generated from `System.IO.NotifyFilters` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum NotifyFilters
        {
            Attributes,
            CreationTime,
            DirectoryName,
            FileName,
            LastAccess,
            LastWrite,
            Security,
            Size,
        }

        // Generated from `System.IO.RenamedEventArgs` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RenamedEventArgs : System.IO.FileSystemEventArgs
        {
            public string OldFullPath { get => throw null; }
            public string OldName { get => throw null; }
            public RenamedEventArgs(System.IO.WatcherChangeTypes changeType, string directory, string name, string oldName) : base(default(System.IO.WatcherChangeTypes), default(string), default(string)) => throw null;
        }

        // Generated from `System.IO.RenamedEventHandler` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void RenamedEventHandler(object sender, System.IO.RenamedEventArgs e);

        // Generated from `System.IO.WaitForChangedResult` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct WaitForChangedResult
        {
            public System.IO.WatcherChangeTypes ChangeType { get => throw null; set => throw null; }
            public string Name { get => throw null; set => throw null; }
            public string OldName { get => throw null; set => throw null; }
            public bool TimedOut { get => throw null; set => throw null; }
            // Stub generator skipped constructor 
        }

        // Generated from `System.IO.WatcherChangeTypes` in `System.IO.FileSystem.Watcher, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum WatcherChangeTypes
        {
            All,
            Changed,
            Created,
            Deleted,
            Renamed,
        }

    }
}
