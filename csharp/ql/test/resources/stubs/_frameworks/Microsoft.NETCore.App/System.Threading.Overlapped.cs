// This file contains auto-generated code.
// Generated from `System.Threading.Overlapped, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Threading
    {
        public unsafe delegate void IOCompletionCallback(uint errorCode, uint numBytes, System.Threading.NativeOverlapped* pOVERLAP);
        public struct NativeOverlapped
        {
            public nint EventHandle;
            public nint InternalHigh;
            public nint InternalLow;
            public int OffsetHigh;
            public int OffsetLow;
        }
        public class Overlapped
        {
            public System.IAsyncResult AsyncResult { get => throw null; set { } }
            public Overlapped() => throw null;
            public Overlapped(int offsetLo, int offsetHi, int hEvent, System.IAsyncResult ar) => throw null;
            public Overlapped(int offsetLo, int offsetHi, nint hEvent, System.IAsyncResult ar) => throw null;
            public int EventHandle { get => throw null; set { } }
            public nint EventHandleIntPtr { get => throw null; set { } }
            public static unsafe void Free(System.Threading.NativeOverlapped* nativeOverlappedPtr) => throw null;
            public int OffsetHigh { get => throw null; set { } }
            public int OffsetLow { get => throw null; set { } }
            public unsafe System.Threading.NativeOverlapped* Pack(System.Threading.IOCompletionCallback iocb) => throw null;
            public unsafe System.Threading.NativeOverlapped* Pack(System.Threading.IOCompletionCallback iocb, object userData) => throw null;
            public static unsafe System.Threading.Overlapped Unpack(System.Threading.NativeOverlapped* nativeOverlappedPtr) => throw null;
            public unsafe System.Threading.NativeOverlapped* UnsafePack(System.Threading.IOCompletionCallback iocb) => throw null;
            public unsafe System.Threading.NativeOverlapped* UnsafePack(System.Threading.IOCompletionCallback iocb, object userData) => throw null;
        }
        public sealed class PreAllocatedOverlapped : System.IDisposable
        {
            public PreAllocatedOverlapped(System.Threading.IOCompletionCallback callback, object state, object pinData) => throw null;
            public void Dispose() => throw null;
            public static System.Threading.PreAllocatedOverlapped UnsafeCreate(System.Threading.IOCompletionCallback callback, object state, object pinData) => throw null;
        }
        public sealed class ThreadPoolBoundHandle : System.IDisposable
        {
            public unsafe System.Threading.NativeOverlapped* AllocateNativeOverlapped(System.Threading.IOCompletionCallback callback, object state, object pinData) => throw null;
            public unsafe System.Threading.NativeOverlapped* AllocateNativeOverlapped(System.Threading.PreAllocatedOverlapped preAllocated) => throw null;
            public static System.Threading.ThreadPoolBoundHandle BindHandle(System.Runtime.InteropServices.SafeHandle handle) => throw null;
            public void Dispose() => throw null;
            public unsafe void FreeNativeOverlapped(System.Threading.NativeOverlapped* overlapped) => throw null;
            public static unsafe object GetNativeOverlappedState(System.Threading.NativeOverlapped* overlapped) => throw null;
            public System.Runtime.InteropServices.SafeHandle Handle { get => throw null; }
            public unsafe System.Threading.NativeOverlapped* UnsafeAllocateNativeOverlapped(System.Threading.IOCompletionCallback callback, object state, object pinData) => throw null;
        }
    }
}
