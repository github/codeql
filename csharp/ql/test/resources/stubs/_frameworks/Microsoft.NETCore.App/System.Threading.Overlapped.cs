// This file contains auto-generated code.

namespace System
{
    namespace Threading
    {
        // Generated from `System.Threading.IOCompletionCallback` in `System.Threading.Overlapped, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        unsafe public delegate void IOCompletionCallback(System.UInt32 errorCode, System.UInt32 numBytes, System.Threading.NativeOverlapped* pOVERLAP);

        // Generated from `System.Threading.NativeOverlapped` in `System.Threading.Overlapped, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct NativeOverlapped
        {
            public System.IntPtr EventHandle;
            public System.IntPtr InternalHigh;
            public System.IntPtr InternalLow;
            // Stub generator skipped constructor 
            public int OffsetHigh;
            public int OffsetLow;
        }

        // Generated from `System.Threading.Overlapped` in `System.Threading.Overlapped, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Overlapped
        {
            public System.IAsyncResult AsyncResult { get => throw null; set => throw null; }
            public int EventHandle { get => throw null; set => throw null; }
            public System.IntPtr EventHandleIntPtr { get => throw null; set => throw null; }
            unsafe public static void Free(System.Threading.NativeOverlapped* nativeOverlappedPtr) => throw null;
            public int OffsetHigh { get => throw null; set => throw null; }
            public int OffsetLow { get => throw null; set => throw null; }
            public Overlapped() => throw null;
            public Overlapped(int offsetLo, int offsetHi, System.IntPtr hEvent, System.IAsyncResult ar) => throw null;
            public Overlapped(int offsetLo, int offsetHi, int hEvent, System.IAsyncResult ar) => throw null;
            unsafe public System.Threading.NativeOverlapped* Pack(System.Threading.IOCompletionCallback iocb) => throw null;
            unsafe public System.Threading.NativeOverlapped* Pack(System.Threading.IOCompletionCallback iocb, object userData) => throw null;
            unsafe public static System.Threading.Overlapped Unpack(System.Threading.NativeOverlapped* nativeOverlappedPtr) => throw null;
            unsafe public System.Threading.NativeOverlapped* UnsafePack(System.Threading.IOCompletionCallback iocb) => throw null;
            unsafe public System.Threading.NativeOverlapped* UnsafePack(System.Threading.IOCompletionCallback iocb, object userData) => throw null;
        }

        // Generated from `System.Threading.PreAllocatedOverlapped` in `System.Threading.Overlapped, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class PreAllocatedOverlapped : System.IDisposable
        {
            public void Dispose() => throw null;
            public PreAllocatedOverlapped(System.Threading.IOCompletionCallback callback, object state, object pinData) => throw null;
            // ERR: Stub generator didn't handle member: ~PreAllocatedOverlapped
        }

        // Generated from `System.Threading.ThreadPoolBoundHandle` in `System.Threading.Overlapped, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ThreadPoolBoundHandle : System.IDisposable
        {
            unsafe public System.Threading.NativeOverlapped* AllocateNativeOverlapped(System.Threading.IOCompletionCallback callback, object state, object pinData) => throw null;
            unsafe public System.Threading.NativeOverlapped* AllocateNativeOverlapped(System.Threading.PreAllocatedOverlapped preAllocated) => throw null;
            public static System.Threading.ThreadPoolBoundHandle BindHandle(System.Runtime.InteropServices.SafeHandle handle) => throw null;
            public void Dispose() => throw null;
            unsafe public void FreeNativeOverlapped(System.Threading.NativeOverlapped* overlapped) => throw null;
            unsafe public static object GetNativeOverlappedState(System.Threading.NativeOverlapped* overlapped) => throw null;
            public System.Runtime.InteropServices.SafeHandle Handle { get => throw null; }
        }

    }
}
