// This file contains auto-generated code.
// Generated from `System.Threading.Thread, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    public sealed class LocalDataStoreSlot
    {
    }
    namespace Threading
    {
        public enum ApartmentState
        {
            STA = 0,
            MTA = 1,
            Unknown = 2,
        }
        public sealed class CompressedStack : System.Runtime.Serialization.ISerializable
        {
            public static System.Threading.CompressedStack Capture() => throw null;
            public System.Threading.CompressedStack CreateCopy() => throw null;
            public static System.Threading.CompressedStack GetCompressedStack() => throw null;
            public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static void Run(System.Threading.CompressedStack compressedStack, System.Threading.ContextCallback callback, object state) => throw null;
        }
        public delegate void ParameterizedThreadStart(object obj);
        public sealed class Thread : System.Runtime.ConstrainedExecution.CriticalFinalizerObject
        {
            public void Abort() => throw null;
            public void Abort(object stateInfo) => throw null;
            public static System.LocalDataStoreSlot AllocateDataSlot() => throw null;
            public static System.LocalDataStoreSlot AllocateNamedDataSlot(string name) => throw null;
            public System.Threading.ApartmentState ApartmentState { get => throw null; set { } }
            public static void BeginCriticalRegion() => throw null;
            public static void BeginThreadAffinity() => throw null;
            public Thread(System.Threading.ParameterizedThreadStart start) => throw null;
            public Thread(System.Threading.ParameterizedThreadStart start, int maxStackSize) => throw null;
            public Thread(System.Threading.ThreadStart start) => throw null;
            public Thread(System.Threading.ThreadStart start, int maxStackSize) => throw null;
            public System.Globalization.CultureInfo CurrentCulture { get => throw null; set { } }
            public static System.Security.Principal.IPrincipal CurrentPrincipal { get => throw null; set { } }
            public static System.Threading.Thread CurrentThread { get => throw null; }
            public System.Globalization.CultureInfo CurrentUICulture { get => throw null; set { } }
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
            public bool IsBackground { get => throw null; set { } }
            public bool IsThreadPoolThread { get => throw null; }
            public void Join() => throw null;
            public bool Join(int millisecondsTimeout) => throw null;
            public bool Join(System.TimeSpan timeout) => throw null;
            public int ManagedThreadId { get => throw null; }
            public static void MemoryBarrier() => throw null;
            public string Name { get => throw null; set { } }
            public System.Threading.ThreadPriority Priority { get => throw null; set { } }
            public static void ResetAbort() => throw null;
            public void Resume() => throw null;
            public void SetApartmentState(System.Threading.ApartmentState state) => throw null;
            public void SetCompressedStack(System.Threading.CompressedStack stack) => throw null;
            public static void SetData(System.LocalDataStoreSlot slot, object data) => throw null;
            public static void Sleep(int millisecondsTimeout) => throw null;
            public static void Sleep(System.TimeSpan timeout) => throw null;
            public static void SpinWait(int iterations) => throw null;
            public void Start() => throw null;
            public void Start(object parameter) => throw null;
            public void Suspend() => throw null;
            public System.Threading.ThreadState ThreadState { get => throw null; }
            public bool TrySetApartmentState(System.Threading.ApartmentState state) => throw null;
            public void UnsafeStart() => throw null;
            public void UnsafeStart(object parameter) => throw null;
            public static byte VolatileRead(ref byte address) => throw null;
            public static double VolatileRead(ref double address) => throw null;
            public static short VolatileRead(ref short address) => throw null;
            public static int VolatileRead(ref int address) => throw null;
            public static long VolatileRead(ref long address) => throw null;
            public static nint VolatileRead(ref nint address) => throw null;
            public static object VolatileRead(ref object address) => throw null;
            public static sbyte VolatileRead(ref sbyte address) => throw null;
            public static float VolatileRead(ref float address) => throw null;
            public static ushort VolatileRead(ref ushort address) => throw null;
            public static uint VolatileRead(ref uint address) => throw null;
            public static ulong VolatileRead(ref ulong address) => throw null;
            public static nuint VolatileRead(ref nuint address) => throw null;
            public static void VolatileWrite(ref byte address, byte value) => throw null;
            public static void VolatileWrite(ref double address, double value) => throw null;
            public static void VolatileWrite(ref short address, short value) => throw null;
            public static void VolatileWrite(ref int address, int value) => throw null;
            public static void VolatileWrite(ref long address, long value) => throw null;
            public static void VolatileWrite(ref nint address, nint value) => throw null;
            public static void VolatileWrite(ref object address, object value) => throw null;
            public static void VolatileWrite(ref sbyte address, sbyte value) => throw null;
            public static void VolatileWrite(ref float address, float value) => throw null;
            public static void VolatileWrite(ref ushort address, ushort value) => throw null;
            public static void VolatileWrite(ref uint address, uint value) => throw null;
            public static void VolatileWrite(ref ulong address, ulong value) => throw null;
            public static void VolatileWrite(ref nuint address, nuint value) => throw null;
            public static bool Yield() => throw null;
        }
        public sealed class ThreadAbortException : System.SystemException
        {
            public object ExceptionState { get => throw null; }
        }
        public class ThreadExceptionEventArgs : System.EventArgs
        {
            public ThreadExceptionEventArgs(System.Exception t) => throw null;
            public System.Exception Exception { get => throw null; }
        }
        public delegate void ThreadExceptionEventHandler(object sender, System.Threading.ThreadExceptionEventArgs e);
        public class ThreadInterruptedException : System.SystemException
        {
            public ThreadInterruptedException() => throw null;
            protected ThreadInterruptedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public ThreadInterruptedException(string message) => throw null;
            public ThreadInterruptedException(string message, System.Exception innerException) => throw null;
        }
        public enum ThreadPriority
        {
            Lowest = 0,
            BelowNormal = 1,
            Normal = 2,
            AboveNormal = 3,
            Highest = 4,
        }
        public delegate void ThreadStart();
        public sealed class ThreadStartException : System.SystemException
        {
        }
        [System.Flags]
        public enum ThreadState
        {
            Running = 0,
            StopRequested = 1,
            SuspendRequested = 2,
            Background = 4,
            Unstarted = 8,
            Stopped = 16,
            WaitSleepJoin = 32,
            Suspended = 64,
            AbortRequested = 128,
            Aborted = 256,
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
