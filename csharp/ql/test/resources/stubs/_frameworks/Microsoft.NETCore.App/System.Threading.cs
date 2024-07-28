// This file contains auto-generated code.
// Generated from `System.Threading, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Threading
    {
        public class AbandonedMutexException : System.SystemException
        {
            public AbandonedMutexException() => throw null;
            public AbandonedMutexException(int location, System.Threading.WaitHandle handle) => throw null;
            protected AbandonedMutexException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public AbandonedMutexException(string message) => throw null;
            public AbandonedMutexException(string message, System.Exception inner) => throw null;
            public AbandonedMutexException(string message, System.Exception inner, int location, System.Threading.WaitHandle handle) => throw null;
            public AbandonedMutexException(string message, int location, System.Threading.WaitHandle handle) => throw null;
            public System.Threading.Mutex Mutex { get => throw null; }
            public int MutexIndex { get => throw null; }
        }
        public struct AsyncFlowControl : System.IDisposable, System.IEquatable<System.Threading.AsyncFlowControl>
        {
            public void Dispose() => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(System.Threading.AsyncFlowControl obj) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(System.Threading.AsyncFlowControl a, System.Threading.AsyncFlowControl b) => throw null;
            public static bool operator !=(System.Threading.AsyncFlowControl a, System.Threading.AsyncFlowControl b) => throw null;
            public void Undo() => throw null;
        }
        public sealed class AsyncLocal<T>
        {
            public AsyncLocal() => throw null;
            public AsyncLocal(System.Action<System.Threading.AsyncLocalValueChangedArgs<T>> valueChangedHandler) => throw null;
            public T Value { get => throw null; set { } }
        }
        public struct AsyncLocalValueChangedArgs<T>
        {
            public T CurrentValue { get => throw null; }
            public T PreviousValue { get => throw null; }
            public bool ThreadContextChanged { get => throw null; }
        }
        public sealed class AutoResetEvent : System.Threading.EventWaitHandle
        {
            public AutoResetEvent(bool initialState) : base(default(bool), default(System.Threading.EventResetMode)) => throw null;
        }
        public class Barrier : System.IDisposable
        {
            public long AddParticipant() => throw null;
            public long AddParticipants(int participantCount) => throw null;
            public Barrier(int participantCount) => throw null;
            public Barrier(int participantCount, System.Action<System.Threading.Barrier> postPhaseAction) => throw null;
            public long CurrentPhaseNumber { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int ParticipantCount { get => throw null; }
            public int ParticipantsRemaining { get => throw null; }
            public void RemoveParticipant() => throw null;
            public void RemoveParticipants(int participantCount) => throw null;
            public void SignalAndWait() => throw null;
            public bool SignalAndWait(int millisecondsTimeout) => throw null;
            public bool SignalAndWait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public void SignalAndWait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool SignalAndWait(System.TimeSpan timeout) => throw null;
            public bool SignalAndWait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
        }
        public class BarrierPostPhaseException : System.Exception
        {
            public BarrierPostPhaseException() => throw null;
            public BarrierPostPhaseException(System.Exception innerException) => throw null;
            protected BarrierPostPhaseException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public BarrierPostPhaseException(string message) => throw null;
            public BarrierPostPhaseException(string message, System.Exception innerException) => throw null;
        }
        public delegate void ContextCallback(object state);
        public class CountdownEvent : System.IDisposable
        {
            public void AddCount() => throw null;
            public void AddCount(int signalCount) => throw null;
            public CountdownEvent(int initialCount) => throw null;
            public int CurrentCount { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int InitialCount { get => throw null; }
            public bool IsSet { get => throw null; }
            public void Reset() => throw null;
            public void Reset(int count) => throw null;
            public bool Signal() => throw null;
            public bool Signal(int signalCount) => throw null;
            public bool TryAddCount() => throw null;
            public bool TryAddCount(int signalCount) => throw null;
            public void Wait() => throw null;
            public bool Wait(int millisecondsTimeout) => throw null;
            public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(System.TimeSpan timeout) => throw null;
            public bool Wait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.WaitHandle WaitHandle { get => throw null; }
        }
        public enum EventResetMode
        {
            AutoReset = 0,
            ManualReset = 1,
        }
        public class EventWaitHandle : System.Threading.WaitHandle
        {
            public EventWaitHandle(bool initialState, System.Threading.EventResetMode mode) => throw null;
            public EventWaitHandle(bool initialState, System.Threading.EventResetMode mode, string name) => throw null;
            public EventWaitHandle(bool initialState, System.Threading.EventResetMode mode, string name, out bool createdNew) => throw null;
            public static System.Threading.EventWaitHandle OpenExisting(string name) => throw null;
            public bool Reset() => throw null;
            public bool Set() => throw null;
            public static bool TryOpenExisting(string name, out System.Threading.EventWaitHandle result) => throw null;
        }
        public sealed class ExecutionContext : System.IDisposable, System.Runtime.Serialization.ISerializable
        {
            public static System.Threading.ExecutionContext Capture() => throw null;
            public System.Threading.ExecutionContext CreateCopy() => throw null;
            public void Dispose() => throw null;
            public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public static bool IsFlowSuppressed() => throw null;
            public static void Restore(System.Threading.ExecutionContext executionContext) => throw null;
            public static void RestoreFlow() => throw null;
            public static void Run(System.Threading.ExecutionContext executionContext, System.Threading.ContextCallback callback, object state) => throw null;
            public static System.Threading.AsyncFlowControl SuppressFlow() => throw null;
        }
        public class HostExecutionContext : System.IDisposable
        {
            public virtual System.Threading.HostExecutionContext CreateCopy() => throw null;
            public HostExecutionContext() => throw null;
            public HostExecutionContext(object state) => throw null;
            public void Dispose() => throw null;
            public virtual void Dispose(bool disposing) => throw null;
            protected object State { get => throw null; set { } }
        }
        public class HostExecutionContextManager
        {
            public virtual System.Threading.HostExecutionContext Capture() => throw null;
            public HostExecutionContextManager() => throw null;
            public virtual void Revert(object previousState) => throw null;
            public virtual object SetHostExecutionContext(System.Threading.HostExecutionContext hostExecutionContext) => throw null;
        }
        public static class Interlocked
        {
            public static int Add(ref int location1, int value) => throw null;
            public static long Add(ref long location1, long value) => throw null;
            public static uint Add(ref uint location1, uint value) => throw null;
            public static ulong Add(ref ulong location1, ulong value) => throw null;
            public static int And(ref int location1, int value) => throw null;
            public static long And(ref long location1, long value) => throw null;
            public static uint And(ref uint location1, uint value) => throw null;
            public static ulong And(ref ulong location1, ulong value) => throw null;
            public static double CompareExchange(ref double location1, double value, double comparand) => throw null;
            public static int CompareExchange(ref int location1, int value, int comparand) => throw null;
            public static long CompareExchange(ref long location1, long value, long comparand) => throw null;
            public static nint CompareExchange(ref nint location1, nint value, nint comparand) => throw null;
            public static nuint CompareExchange(ref nuint location1, nuint value, nuint comparand) => throw null;
            public static object CompareExchange(ref object location1, object value, object comparand) => throw null;
            public static float CompareExchange(ref float location1, float value, float comparand) => throw null;
            public static uint CompareExchange(ref uint location1, uint value, uint comparand) => throw null;
            public static ulong CompareExchange(ref ulong location1, ulong value, ulong comparand) => throw null;
            public static T CompareExchange<T>(ref T location1, T value, T comparand) where T : class => throw null;
            public static int Decrement(ref int location) => throw null;
            public static long Decrement(ref long location) => throw null;
            public static uint Decrement(ref uint location) => throw null;
            public static ulong Decrement(ref ulong location) => throw null;
            public static double Exchange(ref double location1, double value) => throw null;
            public static int Exchange(ref int location1, int value) => throw null;
            public static long Exchange(ref long location1, long value) => throw null;
            public static nint Exchange(ref nint location1, nint value) => throw null;
            public static nuint Exchange(ref nuint location1, nuint value) => throw null;
            public static object Exchange(ref object location1, object value) => throw null;
            public static float Exchange(ref float location1, float value) => throw null;
            public static uint Exchange(ref uint location1, uint value) => throw null;
            public static ulong Exchange(ref ulong location1, ulong value) => throw null;
            public static T Exchange<T>(ref T location1, T value) where T : class => throw null;
            public static int Increment(ref int location) => throw null;
            public static long Increment(ref long location) => throw null;
            public static uint Increment(ref uint location) => throw null;
            public static ulong Increment(ref ulong location) => throw null;
            public static void MemoryBarrier() => throw null;
            public static void MemoryBarrierProcessWide() => throw null;
            public static int Or(ref int location1, int value) => throw null;
            public static long Or(ref long location1, long value) => throw null;
            public static uint Or(ref uint location1, uint value) => throw null;
            public static ulong Or(ref ulong location1, ulong value) => throw null;
            public static long Read(ref readonly long location) => throw null;
            public static ulong Read(ref readonly ulong location) => throw null;
        }
        public static class LazyInitializer
        {
            public static T EnsureInitialized<T>(ref T target) where T : class => throw null;
            public static T EnsureInitialized<T>(ref T target, ref bool initialized, ref object syncLock) => throw null;
            public static T EnsureInitialized<T>(ref T target, ref bool initialized, ref object syncLock, System.Func<T> valueFactory) => throw null;
            public static T EnsureInitialized<T>(ref T target, System.Func<T> valueFactory) where T : class => throw null;
            public static T EnsureInitialized<T>(ref T target, ref object syncLock, System.Func<T> valueFactory) where T : class => throw null;
        }
        public struct LockCookie : System.IEquatable<System.Threading.LockCookie>
        {
            public override bool Equals(object obj) => throw null;
            public bool Equals(System.Threading.LockCookie obj) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(System.Threading.LockCookie a, System.Threading.LockCookie b) => throw null;
            public static bool operator !=(System.Threading.LockCookie a, System.Threading.LockCookie b) => throw null;
        }
        public class LockRecursionException : System.Exception
        {
            public LockRecursionException() => throw null;
            protected LockRecursionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public LockRecursionException(string message) => throw null;
            public LockRecursionException(string message, System.Exception innerException) => throw null;
        }
        public enum LockRecursionPolicy
        {
            NoRecursion = 0,
            SupportsRecursion = 1,
        }
        public sealed class ManualResetEvent : System.Threading.EventWaitHandle
        {
            public ManualResetEvent(bool initialState) : base(default(bool), default(System.Threading.EventResetMode)) => throw null;
        }
        public class ManualResetEventSlim : System.IDisposable
        {
            public ManualResetEventSlim() => throw null;
            public ManualResetEventSlim(bool initialState) => throw null;
            public ManualResetEventSlim(bool initialState, int spinCount) => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public bool IsSet { get => throw null; }
            public void Reset() => throw null;
            public void Set() => throw null;
            public int SpinCount { get => throw null; }
            public void Wait() => throw null;
            public bool Wait(int millisecondsTimeout) => throw null;
            public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(System.TimeSpan timeout) => throw null;
            public bool Wait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.WaitHandle WaitHandle { get => throw null; }
        }
        public static class Monitor
        {
            public static void Enter(object obj) => throw null;
            public static void Enter(object obj, ref bool lockTaken) => throw null;
            public static void Exit(object obj) => throw null;
            public static bool IsEntered(object obj) => throw null;
            public static long LockContentionCount { get => throw null; }
            public static void Pulse(object obj) => throw null;
            public static void PulseAll(object obj) => throw null;
            public static bool TryEnter(object obj) => throw null;
            public static void TryEnter(object obj, ref bool lockTaken) => throw null;
            public static bool TryEnter(object obj, int millisecondsTimeout) => throw null;
            public static void TryEnter(object obj, int millisecondsTimeout, ref bool lockTaken) => throw null;
            public static bool TryEnter(object obj, System.TimeSpan timeout) => throw null;
            public static void TryEnter(object obj, System.TimeSpan timeout, ref bool lockTaken) => throw null;
            public static bool Wait(object obj) => throw null;
            public static bool Wait(object obj, int millisecondsTimeout) => throw null;
            public static bool Wait(object obj, int millisecondsTimeout, bool exitContext) => throw null;
            public static bool Wait(object obj, System.TimeSpan timeout) => throw null;
            public static bool Wait(object obj, System.TimeSpan timeout, bool exitContext) => throw null;
        }
        public sealed class Mutex : System.Threading.WaitHandle
        {
            public Mutex() => throw null;
            public Mutex(bool initiallyOwned) => throw null;
            public Mutex(bool initiallyOwned, string name) => throw null;
            public Mutex(bool initiallyOwned, string name, out bool createdNew) => throw null;
            public static System.Threading.Mutex OpenExisting(string name) => throw null;
            public void ReleaseMutex() => throw null;
            public static bool TryOpenExisting(string name, out System.Threading.Mutex result) => throw null;
        }
        public sealed class ReaderWriterLock : System.Runtime.ConstrainedExecution.CriticalFinalizerObject
        {
            public void AcquireReaderLock(int millisecondsTimeout) => throw null;
            public void AcquireReaderLock(System.TimeSpan timeout) => throw null;
            public void AcquireWriterLock(int millisecondsTimeout) => throw null;
            public void AcquireWriterLock(System.TimeSpan timeout) => throw null;
            public bool AnyWritersSince(int seqNum) => throw null;
            public ReaderWriterLock() => throw null;
            public void DowngradeFromWriterLock(ref System.Threading.LockCookie lockCookie) => throw null;
            public bool IsReaderLockHeld { get => throw null; }
            public bool IsWriterLockHeld { get => throw null; }
            public System.Threading.LockCookie ReleaseLock() => throw null;
            public void ReleaseReaderLock() => throw null;
            public void ReleaseWriterLock() => throw null;
            public void RestoreLock(ref System.Threading.LockCookie lockCookie) => throw null;
            public System.Threading.LockCookie UpgradeToWriterLock(int millisecondsTimeout) => throw null;
            public System.Threading.LockCookie UpgradeToWriterLock(System.TimeSpan timeout) => throw null;
            public int WriterSeqNum { get => throw null; }
        }
        public class ReaderWriterLockSlim : System.IDisposable
        {
            public ReaderWriterLockSlim() => throw null;
            public ReaderWriterLockSlim(System.Threading.LockRecursionPolicy recursionPolicy) => throw null;
            public int CurrentReadCount { get => throw null; }
            public void Dispose() => throw null;
            public void EnterReadLock() => throw null;
            public void EnterUpgradeableReadLock() => throw null;
            public void EnterWriteLock() => throw null;
            public void ExitReadLock() => throw null;
            public void ExitUpgradeableReadLock() => throw null;
            public void ExitWriteLock() => throw null;
            public bool IsReadLockHeld { get => throw null; }
            public bool IsUpgradeableReadLockHeld { get => throw null; }
            public bool IsWriteLockHeld { get => throw null; }
            public System.Threading.LockRecursionPolicy RecursionPolicy { get => throw null; }
            public int RecursiveReadCount { get => throw null; }
            public int RecursiveUpgradeCount { get => throw null; }
            public int RecursiveWriteCount { get => throw null; }
            public bool TryEnterReadLock(int millisecondsTimeout) => throw null;
            public bool TryEnterReadLock(System.TimeSpan timeout) => throw null;
            public bool TryEnterUpgradeableReadLock(int millisecondsTimeout) => throw null;
            public bool TryEnterUpgradeableReadLock(System.TimeSpan timeout) => throw null;
            public bool TryEnterWriteLock(int millisecondsTimeout) => throw null;
            public bool TryEnterWriteLock(System.TimeSpan timeout) => throw null;
            public int WaitingReadCount { get => throw null; }
            public int WaitingUpgradeCount { get => throw null; }
            public int WaitingWriteCount { get => throw null; }
        }
        public sealed class Semaphore : System.Threading.WaitHandle
        {
            public Semaphore(int initialCount, int maximumCount) => throw null;
            public Semaphore(int initialCount, int maximumCount, string name) => throw null;
            public Semaphore(int initialCount, int maximumCount, string name, out bool createdNew) => throw null;
            public static System.Threading.Semaphore OpenExisting(string name) => throw null;
            public int Release() => throw null;
            public int Release(int releaseCount) => throw null;
            public static bool TryOpenExisting(string name, out System.Threading.Semaphore result) => throw null;
        }
        public class SemaphoreFullException : System.SystemException
        {
            public SemaphoreFullException() => throw null;
            protected SemaphoreFullException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SemaphoreFullException(string message) => throw null;
            public SemaphoreFullException(string message, System.Exception innerException) => throw null;
        }
        public class SemaphoreSlim : System.IDisposable
        {
            public System.Threading.WaitHandle AvailableWaitHandle { get => throw null; }
            public SemaphoreSlim(int initialCount) => throw null;
            public SemaphoreSlim(int initialCount, int maxCount) => throw null;
            public int CurrentCount { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int Release() => throw null;
            public int Release(int releaseCount) => throw null;
            public void Wait() => throw null;
            public bool Wait(int millisecondsTimeout) => throw null;
            public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(System.TimeSpan timeout) => throw null;
            public bool Wait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task WaitAsync() => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(int millisecondsTimeout) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task WaitAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(System.TimeSpan timeout) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
        }
        public delegate void SendOrPostCallback(object state);
        public struct SpinLock
        {
            public SpinLock(bool enableThreadOwnerTracking) => throw null;
            public void Enter(ref bool lockTaken) => throw null;
            public void Exit() => throw null;
            public void Exit(bool useMemoryBarrier) => throw null;
            public bool IsHeld { get => throw null; }
            public bool IsHeldByCurrentThread { get => throw null; }
            public bool IsThreadOwnerTrackingEnabled { get => throw null; }
            public void TryEnter(ref bool lockTaken) => throw null;
            public void TryEnter(int millisecondsTimeout, ref bool lockTaken) => throw null;
            public void TryEnter(System.TimeSpan timeout, ref bool lockTaken) => throw null;
        }
        public struct SpinWait
        {
            public int Count { get => throw null; }
            public bool NextSpinWillYield { get => throw null; }
            public void Reset() => throw null;
            public void SpinOnce() => throw null;
            public void SpinOnce(int sleep1Threshold) => throw null;
            public static void SpinUntil(System.Func<bool> condition) => throw null;
            public static bool SpinUntil(System.Func<bool> condition, int millisecondsTimeout) => throw null;
            public static bool SpinUntil(System.Func<bool> condition, System.TimeSpan timeout) => throw null;
        }
        public class SynchronizationContext
        {
            public virtual System.Threading.SynchronizationContext CreateCopy() => throw null;
            public SynchronizationContext() => throw null;
            public static System.Threading.SynchronizationContext Current { get => throw null; }
            public bool IsWaitNotificationRequired() => throw null;
            public virtual void OperationCompleted() => throw null;
            public virtual void OperationStarted() => throw null;
            public virtual void Post(System.Threading.SendOrPostCallback d, object state) => throw null;
            public virtual void Send(System.Threading.SendOrPostCallback d, object state) => throw null;
            public static void SetSynchronizationContext(System.Threading.SynchronizationContext syncContext) => throw null;
            protected void SetWaitNotificationRequired() => throw null;
            public virtual int Wait(nint[] waitHandles, bool waitAll, int millisecondsTimeout) => throw null;
            protected static int WaitHelper(nint[] waitHandles, bool waitAll, int millisecondsTimeout) => throw null;
        }
        public class SynchronizationLockException : System.SystemException
        {
            public SynchronizationLockException() => throw null;
            protected SynchronizationLockException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SynchronizationLockException(string message) => throw null;
            public SynchronizationLockException(string message, System.Exception innerException) => throw null;
        }
        public class ThreadLocal<T> : System.IDisposable
        {
            public ThreadLocal() => throw null;
            public ThreadLocal(bool trackAllValues) => throw null;
            public ThreadLocal(System.Func<T> valueFactory) => throw null;
            public ThreadLocal(System.Func<T> valueFactory, bool trackAllValues) => throw null;
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public bool IsValueCreated { get => throw null; }
            public override string ToString() => throw null;
            public T Value { get => throw null; set { } }
            public System.Collections.Generic.IList<T> Values { get => throw null; }
        }
        public static class Volatile
        {
            public static bool Read(ref readonly bool location) => throw null;
            public static byte Read(ref readonly byte location) => throw null;
            public static double Read(ref readonly double location) => throw null;
            public static short Read(ref readonly short location) => throw null;
            public static int Read(ref readonly int location) => throw null;
            public static long Read(ref readonly long location) => throw null;
            public static nint Read(ref readonly nint location) => throw null;
            public static sbyte Read(ref readonly sbyte location) => throw null;
            public static float Read(ref readonly float location) => throw null;
            public static ushort Read(ref readonly ushort location) => throw null;
            public static uint Read(ref readonly uint location) => throw null;
            public static ulong Read(ref readonly ulong location) => throw null;
            public static nuint Read(ref readonly nuint location) => throw null;
            public static T Read<T>(ref readonly T location) where T : class => throw null;
            public static void Write(ref bool location, bool value) => throw null;
            public static void Write(ref byte location, byte value) => throw null;
            public static void Write(ref double location, double value) => throw null;
            public static void Write(ref short location, short value) => throw null;
            public static void Write(ref int location, int value) => throw null;
            public static void Write(ref long location, long value) => throw null;
            public static void Write(ref nint location, nint value) => throw null;
            public static void Write(ref sbyte location, sbyte value) => throw null;
            public static void Write(ref float location, float value) => throw null;
            public static void Write(ref ushort location, ushort value) => throw null;
            public static void Write(ref uint location, uint value) => throw null;
            public static void Write(ref ulong location, ulong value) => throw null;
            public static void Write(ref nuint location, nuint value) => throw null;
            public static void Write<T>(ref T location, T value) where T : class => throw null;
        }
        public class WaitHandleCannotBeOpenedException : System.ApplicationException
        {
            public WaitHandleCannotBeOpenedException() => throw null;
            protected WaitHandleCannotBeOpenedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public WaitHandleCannotBeOpenedException(string message) => throw null;
            public WaitHandleCannotBeOpenedException(string message, System.Exception innerException) => throw null;
        }
    }
}
