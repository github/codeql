// This file contains auto-generated code.
// Generated from `System.IO.FileSystem.Watcher, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace IO
    {
        public class ErrorEventArgs : System.EventArgs
        {
            public ErrorEventArgs(System.Exception exception) => throw null;
            public virtual System.Exception GetException() => throw null;
        }

        public delegate void ErrorEventHandler(object sender, System.IO.ErrorEventArgs e);

        public class FileSystemEventArgs : System.EventArgs
        {
            public System.IO.WatcherChangeTypes ChangeType { get => throw null; }
            public FileSystemEventArgs(System.IO.WatcherChangeTypes changeType, string directory, string name) => throw null;
            public string FullPath { get => throw null; }
            public string Name { get => throw null; }
        }

        public delegate void FileSystemEventHandler(object sender, System.IO.FileSystemEventArgs e);

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
            public System.IO.WaitForChangedResult WaitForChanged(System.IO.WatcherChangeTypes changeType, System.TimeSpan timeout) => throw null;
            public System.IO.WaitForChangedResult WaitForChanged(System.IO.WatcherChangeTypes changeType, int timeout) => throw null;
        }

        public class InternalBufferOverflowException : System.SystemException
        {
            public InternalBufferOverflowException() => throw null;
            protected InternalBufferOverflowException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public InternalBufferOverflowException(string message) => throw null;
            public InternalBufferOverflowException(string message, System.Exception inner) => throw null;
        }

        [System.Flags]
        public enum NotifyFilters : int
        {
            Attributes = 4,
            CreationTime = 64,
            DirectoryName = 2,
            FileName = 1,
            LastAccess = 32,
            LastWrite = 16,
            Security = 256,
            Size = 8,
        }

        public class RenamedEventArgs : System.IO.FileSystemEventArgs
        {
            public string OldFullPath { get => throw null; }
            public string OldName { get => throw null; }
            public RenamedEventArgs(System.IO.WatcherChangeTypes changeType, string directory, string name, string oldName) : base(default(System.IO.WatcherChangeTypes), default(string), default(string)) => throw null;
        }

        public delegate void RenamedEventHandler(object sender, System.IO.RenamedEventArgs e);

        public struct WaitForChangedResult
        {
            public System.IO.WatcherChangeTypes ChangeType { get => throw null; set => throw null; }
            public string Name { get => throw null; set => throw null; }
            public string OldName { get => throw null; set => throw null; }
            public bool TimedOut { get => throw null; set => throw null; }
            // Stub generator skipped constructor 
        }

        [System.Flags]
        public enum WatcherChangeTypes : int
        {
            All = 15,
            Changed = 4,
            Created = 1,
            Deleted = 2,
            Renamed = 8,
        }

    }
}
