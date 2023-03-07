// This file contains auto-generated code.
// Generated from `System.Threading.Thread, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    public class LocalDataStoreSlot
    {
        // ERR: Stub generator didn't handle member: ~LocalDataStoreSlot
    }

    namespace Threading
    {
        public enum ApartmentState : int
        {
            MTA = 1,
            STA = 0,
            Unknown = 2,
        }

        public class CompressedStack : System.Runtime.Serialization.ISerializable
        {
            public static System.Threading.CompressedStack Capture() => throw null;
            public System.Threading.CompressedStack CreateCopy() => throw null;
            public static System.Threading.CompressedStack GetCompressedStack() => throw null;
            public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static void Run(System.Threading.CompressedStack compressedStack, System.Threading.ContextCallback callback, object state) => throw null;
        }

        public delegate void ParameterizedThreadStart(object obj);

        public class Thread : System.Runtime.ConstrainedExecution.CriticalFinalizerObject
        {
            public void Abort() => throw null;
            public void Abort(object stateInfo) => throw null;
            public static System.LocalDataStoreSlot AllocateDataSlot() => throw null;
            public static System.LocalDataStoreSlot AllocateNamedDataSlot(string name) => throw null;
            public System.Threading.ApartmentState ApartmentState { get => throw null; set => throw null; }
            public static void BeginCriticalRegion() => throw null;
            public static void BeginThreadAffinity() => throw null;
            public System.Globalization.CultureInfo CurrentCulture { get => throw null; set => throw null; }
            public static System.Security.Principal.IPrincipal CurrentPrincipal { get => throw null; set => throw null; }
            public static System.Threading.Thread CurrentThread { get => throw null; }
            public System.Globalization.CultureInfo CurrentUICulture { get => throw null; set => throw null; }
            public void DisableComObjectEagerCleanup() => throw null;
            public static void EndCriticalRegion() => throw null;
            public static void EndThreadAffinity() => throw null;
            public System.Threading.ExecutionContext ExecutionContext { get => throw null; }
            public static void FreeNamedDataSlot(string name) => throw null;
            public System.Threading.ApartmentState GetApartmentState() => throw null;
            public System.Threading.CompressedStack GetCompressedStack() => throw null;
            public static int GetCurrentProcessorId() => throw null;
            public static object GetData(System.LocalDataStoreSlot slot) => throw null;
            public static System.AppDomain GetDomain() => throw null;
            public static int GetDomainID() => throw null;
            public override int GetHashCode() => throw null;
            public static System.LocalDataStoreSlot GetNamedDataSlot(string name) => throw null;
            public void Interrupt() => throw null;
            public bool IsAlive { get => throw null; }
            public bool IsBackground { get => throw null; set => throw null; }
            public bool IsThreadPoolThread { get => throw null; }
            public void Join() => throw null;
            public bool Join(System.TimeSpan timeout) => throw null;
            public bool Join(int millisecondsTimeout) => throw null;
            public int ManagedThreadId { get => throw null; }
            public static void MemoryBarrier() => throw null;
            public string Name { get => throw null; set => throw null; }
            public System.Threading.ThreadPriority Priority { get => throw null; set => throw null; }
            public static void ResetAbort() => throw null;
            public void Resume() => throw null;
            public void SetApartmentState(System.Threading.ApartmentState state) => throw null;
            public void SetCompressedStack(System.Threading.CompressedStack stack) => throw null;
            public static void SetData(System.LocalDataStoreSlot slot, object data) => throw null;
            public static void Sleep(System.TimeSpan timeout) => throw null;
            public static void Sleep(int millisecondsTimeout) => throw null;
            public static void SpinWait(int iterations) => throw null;
            public void Start() => throw null;
            public void Start(object parameter) => throw null;
            public void Suspend() => throw null;
            public Thread(System.Threading.ParameterizedThreadStart start) => throw null;
            public Thread(System.Threading.ParameterizedThreadStart start, int maxStackSize) => throw null;
            public Thread(System.Threading.ThreadStart start) => throw null;
            public Thread(System.Threading.ThreadStart start, int maxStackSize) => throw null;
            public System.Threading.ThreadState ThreadState { get => throw null; }
            public bool TrySetApartmentState(System.Threading.ApartmentState state) => throw null;
            public void UnsafeStart() => throw null;
            public void UnsafeStart(object parameter) => throw null;
            public static System.IntPtr VolatileRead(ref System.IntPtr address) => throw null;
            public static System.UIntPtr VolatileRead(ref System.UIntPtr address) => throw null;
            public static System.Byte VolatileRead(ref System.Byte address) => throw null;
            public static double VolatileRead(ref double address) => throw null;
            public static float VolatileRead(ref float address) => throw null;
            public static int VolatileRead(ref int address) => throw null;
            public static System.Int64 VolatileRead(ref System.Int64 address) => throw null;
            public static object VolatileRead(ref object address) => throw null;
            public static System.SByte VolatileRead(ref System.SByte address) => throw null;
            public static System.Int16 VolatileRead(ref System.Int16 address) => throw null;
            public static System.UInt32 VolatileRead(ref System.UInt32 address) => throw null;
            public static System.UInt64 VolatileRead(ref System.UInt64 address) => throw null;
            public static System.UInt16 VolatileRead(ref System.UInt16 address) => throw null;
            public static void VolatileWrite(ref System.IntPtr address, System.IntPtr value) => throw null;
            public static void VolatileWrite(ref System.UIntPtr address, System.UIntPtr value) => throw null;
            public static void VolatileWrite(ref System.Byte address, System.Byte value) => throw null;
            public static void VolatileWrite(ref double address, double value) => throw null;
            public static void VolatileWrite(ref float address, float value) => throw null;
            public static void VolatileWrite(ref int address, int value) => throw null;
            public static void VolatileWrite(ref System.Int64 address, System.Int64 value) => throw null;
            public static void VolatileWrite(ref object address, object value) => throw null;
            public static void VolatileWrite(ref System.SByte address, System.SByte value) => throw null;
            public static void VolatileWrite(ref System.Int16 address, System.Int16 value) => throw null;
            public static void VolatileWrite(ref System.UInt32 address, System.UInt32 value) => throw null;
            public static void VolatileWrite(ref System.UInt64 address, System.UInt64 value) => throw null;
            public static void VolatileWrite(ref System.UInt16 address, System.UInt16 value) => throw null;
            public static bool Yield() => throw null;
            // ERR: Stub generator didn't handle member: ~Thread
        }

        public class ThreadAbortException : System.SystemException
        {
            public object ExceptionState { get => throw null; }
        }

        public class ThreadExceptionEventArgs : System.EventArgs
        {
            public System.Exception Exception { get => throw null; }
            public ThreadExceptionEventArgs(System.Exception t) => throw null;
        }

        public delegate void ThreadExceptionEventHandler(object sender, System.Threading.ThreadExceptionEventArgs e);

        public class ThreadInterruptedException : System.SystemException
        {
            public ThreadInterruptedException() => throw null;
            protected ThreadInterruptedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ThreadInterruptedException(string message) => throw null;
            public ThreadInterruptedException(string message, System.Exception innerException) => throw null;
        }

        public enum ThreadPriority : int
        {
            AboveNormal = 3,
            BelowNormal = 1,
            Highest = 4,
            Lowest = 0,
            Normal = 2,
        }

        public delegate void ThreadStart();

        public class ThreadStartException : System.SystemException
        {
        }

        [System.Flags]
        public enum ThreadState : int
        {
            AbortRequested = 128,
            Aborted = 256,
            Background = 4,
            Running = 0,
            StopRequested = 1,
            Stopped = 16,
            SuspendRequested = 2,
            Suspended = 64,
            Unstarted = 8,
            WaitSleepJoin = 32,
        }

        public class ThreadStateException : System.SystemException
        {
            public ThreadStateException() => throw null;
            protected ThreadStateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ThreadStateException(string message) => throw null;
            public ThreadStateException(string message, System.Exception innerException) => throw null;
        }

    }
}
