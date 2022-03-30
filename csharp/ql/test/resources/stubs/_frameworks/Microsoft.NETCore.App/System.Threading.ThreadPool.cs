// This file contains auto-generated code.

namespace System
{
    namespace Threading
    {
        // Generated from `System.Threading.IThreadPoolWorkItem` in `System.Threading.ThreadPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IThreadPoolWorkItem
        {
            void Execute();
        }

        // Generated from `System.Threading.RegisteredWaitHandle` in `System.Threading.ThreadPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RegisteredWaitHandle : System.MarshalByRefObject
        {
            public bool Unregister(System.Threading.WaitHandle waitObject) => throw null;
        }

        // Generated from `System.Threading.ThreadPool` in `System.Threading.ThreadPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class ThreadPool
        {
            public static bool BindHandle(System.IntPtr osHandle) => throw null;
            public static bool BindHandle(System.Runtime.InteropServices.SafeHandle osHandle) => throw null;
            public static System.Int64 CompletedWorkItemCount { get => throw null; }
            public static void GetAvailableThreads(out int workerThreads, out int completionPortThreads) => throw null;
            public static void GetMaxThreads(out int workerThreads, out int completionPortThreads) => throw null;
            public static void GetMinThreads(out int workerThreads, out int completionPortThreads) => throw null;
            public static System.Int64 PendingWorkItemCount { get => throw null; }
            public static bool QueueUserWorkItem(System.Threading.WaitCallback callBack) => throw null;
            public static bool QueueUserWorkItem(System.Threading.WaitCallback callBack, object state) => throw null;
            public static bool QueueUserWorkItem<TState>(System.Action<TState> callBack, TState state, bool preferLocal) => throw null;
            public static System.Threading.RegisteredWaitHandle RegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, System.TimeSpan timeout, bool executeOnlyOnce) => throw null;
            public static System.Threading.RegisteredWaitHandle RegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, int millisecondsTimeOutInterval, bool executeOnlyOnce) => throw null;
            public static System.Threading.RegisteredWaitHandle RegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, System.Int64 millisecondsTimeOutInterval, bool executeOnlyOnce) => throw null;
            public static System.Threading.RegisteredWaitHandle RegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, System.UInt32 millisecondsTimeOutInterval, bool executeOnlyOnce) => throw null;
            public static bool SetMaxThreads(int workerThreads, int completionPortThreads) => throw null;
            public static bool SetMinThreads(int workerThreads, int completionPortThreads) => throw null;
            public static int ThreadCount { get => throw null; }
            unsafe public static bool UnsafeQueueNativeOverlapped(System.Threading.NativeOverlapped* overlapped) => throw null;
            public static bool UnsafeQueueUserWorkItem(System.Threading.IThreadPoolWorkItem callBack, bool preferLocal) => throw null;
            public static bool UnsafeQueueUserWorkItem(System.Threading.WaitCallback callBack, object state) => throw null;
            public static bool UnsafeQueueUserWorkItem<TState>(System.Action<TState> callBack, TState state, bool preferLocal) => throw null;
            public static System.Threading.RegisteredWaitHandle UnsafeRegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, System.TimeSpan timeout, bool executeOnlyOnce) => throw null;
            public static System.Threading.RegisteredWaitHandle UnsafeRegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, int millisecondsTimeOutInterval, bool executeOnlyOnce) => throw null;
            public static System.Threading.RegisteredWaitHandle UnsafeRegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, System.Int64 millisecondsTimeOutInterval, bool executeOnlyOnce) => throw null;
            public static System.Threading.RegisteredWaitHandle UnsafeRegisterWaitForSingleObject(System.Threading.WaitHandle waitObject, System.Threading.WaitOrTimerCallback callBack, object state, System.UInt32 millisecondsTimeOutInterval, bool executeOnlyOnce) => throw null;
        }

        // Generated from `System.Threading.WaitCallback` in `System.Threading.ThreadPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void WaitCallback(object state);

        // Generated from `System.Threading.WaitOrTimerCallback` in `System.Threading.ThreadPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void WaitOrTimerCallback(object state, bool timedOut);

    }
}
