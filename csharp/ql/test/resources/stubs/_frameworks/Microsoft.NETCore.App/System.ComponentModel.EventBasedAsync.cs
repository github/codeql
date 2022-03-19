// This file contains auto-generated code.

namespace System
{
    namespace ComponentModel
    {
        // Generated from `System.ComponentModel.AsyncCompletedEventArgs` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AsyncCompletedEventArgs : System.EventArgs
        {
            public AsyncCompletedEventArgs(System.Exception error, bool cancelled, object userState) => throw null;
            public bool Cancelled { get => throw null; }
            public System.Exception Error { get => throw null; }
            protected void RaiseExceptionIfNecessary() => throw null;
            public object UserState { get => throw null; }
        }

        // Generated from `System.ComponentModel.AsyncCompletedEventHandler` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void AsyncCompletedEventHandler(object sender, System.ComponentModel.AsyncCompletedEventArgs e);

        // Generated from `System.ComponentModel.AsyncOperation` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AsyncOperation
        {
            public void OperationCompleted() => throw null;
            public void Post(System.Threading.SendOrPostCallback d, object arg) => throw null;
            public void PostOperationCompleted(System.Threading.SendOrPostCallback d, object arg) => throw null;
            public System.Threading.SynchronizationContext SynchronizationContext { get => throw null; }
            public object UserSuppliedState { get => throw null; }
            // ERR: Stub generator didn't handle member: ~AsyncOperation
        }

        // Generated from `System.ComponentModel.AsyncOperationManager` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class AsyncOperationManager
        {
            public static System.ComponentModel.AsyncOperation CreateOperation(object userSuppliedState) => throw null;
            public static System.Threading.SynchronizationContext SynchronizationContext { get => throw null; set => throw null; }
        }

        // Generated from `System.ComponentModel.BackgroundWorker` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BackgroundWorker : System.ComponentModel.Component
        {
            public BackgroundWorker() => throw null;
            public void CancelAsync() => throw null;
            public bool CancellationPending { get => throw null; }
            protected override void Dispose(bool disposing) => throw null;
            public event System.ComponentModel.DoWorkEventHandler DoWork;
            public bool IsBusy { get => throw null; }
            protected virtual void OnDoWork(System.ComponentModel.DoWorkEventArgs e) => throw null;
            protected virtual void OnProgressChanged(System.ComponentModel.ProgressChangedEventArgs e) => throw null;
            protected virtual void OnRunWorkerCompleted(System.ComponentModel.RunWorkerCompletedEventArgs e) => throw null;
            public event System.ComponentModel.ProgressChangedEventHandler ProgressChanged;
            public void ReportProgress(int percentProgress) => throw null;
            public void ReportProgress(int percentProgress, object userState) => throw null;
            public void RunWorkerAsync() => throw null;
            public void RunWorkerAsync(object argument) => throw null;
            public event System.ComponentModel.RunWorkerCompletedEventHandler RunWorkerCompleted;
            public bool WorkerReportsProgress { get => throw null; set => throw null; }
            public bool WorkerSupportsCancellation { get => throw null; set => throw null; }
        }

        // Generated from `System.ComponentModel.DoWorkEventArgs` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DoWorkEventArgs : System.ComponentModel.CancelEventArgs
        {
            public object Argument { get => throw null; }
            public DoWorkEventArgs(object argument) => throw null;
            public object Result { get => throw null; set => throw null; }
        }

        // Generated from `System.ComponentModel.DoWorkEventHandler` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void DoWorkEventHandler(object sender, System.ComponentModel.DoWorkEventArgs e);

        // Generated from `System.ComponentModel.ProgressChangedEventArgs` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProgressChangedEventArgs : System.EventArgs
        {
            public ProgressChangedEventArgs(int progressPercentage, object userState) => throw null;
            public int ProgressPercentage { get => throw null; }
            public object UserState { get => throw null; }
        }

        // Generated from `System.ComponentModel.ProgressChangedEventHandler` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void ProgressChangedEventHandler(object sender, System.ComponentModel.ProgressChangedEventArgs e);

        // Generated from `System.ComponentModel.RunWorkerCompletedEventArgs` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RunWorkerCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public object Result { get => throw null; }
            public RunWorkerCompletedEventArgs(object result, System.Exception error, bool cancelled) : base(default(System.Exception), default(bool), default(object)) => throw null;
            public object UserState { get => throw null; }
        }

        // Generated from `System.ComponentModel.RunWorkerCompletedEventHandler` in `System.ComponentModel.EventBasedAsync, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void RunWorkerCompletedEventHandler(object sender, System.ComponentModel.RunWorkerCompletedEventArgs e);

    }
}
