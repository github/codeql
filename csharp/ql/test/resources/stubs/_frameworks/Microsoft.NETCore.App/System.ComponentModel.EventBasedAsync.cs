// This file contains auto-generated code.
// Generated from `System.ComponentModel.EventBasedAsync, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace ComponentModel
    {
        public class AsyncCompletedEventArgs : System.EventArgs
        {
            public bool Cancelled { get => throw null; }
            public AsyncCompletedEventArgs(System.Exception error, bool cancelled, object userState) => throw null;
            public System.Exception Error { get => throw null; }
            protected void RaiseExceptionIfNecessary() => throw null;
            public object UserState { get => throw null; }
        }
        public delegate void AsyncCompletedEventHandler(object sender, System.ComponentModel.AsyncCompletedEventArgs e);
        public sealed class AsyncOperation
        {
            public void OperationCompleted() => throw null;
            public void Post(System.Threading.SendOrPostCallback d, object arg) => throw null;
            public void PostOperationCompleted(System.Threading.SendOrPostCallback d, object arg) => throw null;
            public System.Threading.SynchronizationContext SynchronizationContext { get => throw null; }
            public object UserSuppliedState { get => throw null; }
        }
        public static class AsyncOperationManager
        {
            public static System.ComponentModel.AsyncOperation CreateOperation(object userSuppliedState) => throw null;
            public static System.Threading.SynchronizationContext SynchronizationContext { get => throw null; set { } }
        }
        public class BackgroundWorker : System.ComponentModel.Component
        {
            public void CancelAsync() => throw null;
            public bool CancellationPending { get => throw null; }
            public BackgroundWorker() => throw null;
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
            public bool WorkerReportsProgress { get => throw null; set { } }
            public bool WorkerSupportsCancellation { get => throw null; set { } }
        }
        public class DoWorkEventArgs : System.ComponentModel.CancelEventArgs
        {
            public object Argument { get => throw null; }
            public DoWorkEventArgs(object argument) => throw null;
            public object Result { get => throw null; set { } }
        }
        public delegate void DoWorkEventHandler(object sender, System.ComponentModel.DoWorkEventArgs e);
        public class ProgressChangedEventArgs : System.EventArgs
        {
            public ProgressChangedEventArgs(int progressPercentage, object userState) => throw null;
            public int ProgressPercentage { get => throw null; }
            public object UserState { get => throw null; }
        }
        public delegate void ProgressChangedEventHandler(object sender, System.ComponentModel.ProgressChangedEventArgs e);
        public class RunWorkerCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
        {
            public RunWorkerCompletedEventArgs(object result, System.Exception error, bool cancelled) : base(default(System.Exception), default(bool), default(object)) => throw null;
            public object Result { get => throw null; }
            public object UserState { get => throw null; }
        }
        public delegate void RunWorkerCompletedEventHandler(object sender, System.ComponentModel.RunWorkerCompletedEventArgs e);
    }
}
