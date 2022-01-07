// This file contains auto-generated code.

namespace System
{
    namespace Threading
    {
        // Generated from `System.Threading.AbandonedMutexException` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AbandonedMutexException : System.SystemException
        {
            public AbandonedMutexException() => throw null;
            protected AbandonedMutexException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public AbandonedMutexException(int location, System.Threading.WaitHandle handle) => throw null;
            public AbandonedMutexException(string message) => throw null;
            public AbandonedMutexException(string message, System.Exception inner) => throw null;
            public AbandonedMutexException(string message, System.Exception inner, int location, System.Threading.WaitHandle handle) => throw null;
            public AbandonedMutexException(string message, int location, System.Threading.WaitHandle handle) => throw null;
            public System.Threading.Mutex Mutex { get => throw null; }
            public int MutexIndex { get => throw null; }
        }

        // Generated from `System.Threading.AsyncFlowControl` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct AsyncFlowControl : System.IDisposable
        {
            public static bool operator !=(System.Threading.AsyncFlowControl a, System.Threading.AsyncFlowControl b) => throw null;
            public static bool operator ==(System.Threading.AsyncFlowControl a, System.Threading.AsyncFlowControl b) => throw null;
            // Stub generator skipped constructor 
            public void Dispose() => throw null;
            public bool Equals(System.Threading.AsyncFlowControl obj) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public void Undo() => throw null;
        }

        // Generated from `System.Threading.AsyncLocal<>` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AsyncLocal<T>
        {
            public AsyncLocal() => throw null;
            public AsyncLocal(System.Action<System.Threading.AsyncLocalValueChangedArgs<T>> valueChangedHandler) => throw null;
            public T Value { get => throw null; set => throw null; }
        }

        // Generated from `System.Threading.AsyncLocalValueChangedArgs<>` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct AsyncLocalValueChangedArgs<T>
        {
            // Stub generator skipped constructor 
            public T CurrentValue { get => throw null; }
            public T PreviousValue { get => throw null; }
            public bool ThreadContextChanged { get => throw null; }
        }

        // Generated from `System.Threading.AutoResetEvent` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class AutoResetEvent : System.Threading.EventWaitHandle
        {
            public AutoResetEvent(bool initialState) : base(default(bool), default(System.Threading.EventResetMode)) => throw null;
        }

        // Generated from `System.Threading.Barrier` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Barrier : System.IDisposable
        {
            public System.Int64 AddParticipant() => throw null;
            public System.Int64 AddParticipants(int participantCount) => throw null;
            public Barrier(int participantCount) => throw null;
            public Barrier(int participantCount, System.Action<System.Threading.Barrier> postPhaseAction) => throw null;
            public System.Int64 CurrentPhaseNumber { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int ParticipantCount { get => throw null; }
            public int ParticipantsRemaining { get => throw null; }
            public void RemoveParticipant() => throw null;
            public void RemoveParticipants(int participantCount) => throw null;
            public void SignalAndWait() => throw null;
            public void SignalAndWait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool SignalAndWait(System.TimeSpan timeout) => throw null;
            public bool SignalAndWait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public bool SignalAndWait(int millisecondsTimeout) => throw null;
            public bool SignalAndWait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
        }

        // Generated from `System.Threading.BarrierPostPhaseException` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class BarrierPostPhaseException : System.Exception
        {
            public BarrierPostPhaseException() => throw null;
            public BarrierPostPhaseException(System.Exception innerException) => throw null;
            protected BarrierPostPhaseException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public BarrierPostPhaseException(string message) => throw null;
            public BarrierPostPhaseException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Threading.ContextCallback` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void ContextCallback(object state);

        // Generated from `System.Threading.CountdownEvent` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(System.TimeSpan timeout) => throw null;
            public bool Wait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(int millisecondsTimeout) => throw null;
            public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.WaitHandle WaitHandle { get => throw null; }
        }

        // Generated from `System.Threading.EventResetMode` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum EventResetMode
        {
            AutoReset,
            ManualReset,
        }

        // Generated from `System.Threading.EventWaitHandle` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Threading.ExecutionContext` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ExecutionContext : System.IDisposable, System.Runtime.Serialization.ISerializable
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

        // Generated from `System.Threading.HostExecutionContext` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class HostExecutionContext : System.IDisposable
        {
            public virtual System.Threading.HostExecutionContext CreateCopy() => throw null;
            public void Dispose() => throw null;
            public virtual void Dispose(bool disposing) => throw null;
            public HostExecutionContext() => throw null;
            public HostExecutionContext(object state) => throw null;
            protected internal object State { get => throw null; set => throw null; }
        }

        // Generated from `System.Threading.HostExecutionContextManager` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class HostExecutionContextManager
        {
            public virtual System.Threading.HostExecutionContext Capture() => throw null;
            public HostExecutionContextManager() => throw null;
            public virtual void Revert(object previousState) => throw null;
            public virtual object SetHostExecutionContext(System.Threading.HostExecutionContext hostExecutionContext) => throw null;
        }

        // Generated from `System.Threading.Interlocked` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Interlocked
        {
            public static int Add(ref int location1, int value) => throw null;
            public static System.Int64 Add(ref System.Int64 location1, System.Int64 value) => throw null;
            public static System.UInt32 Add(ref System.UInt32 location1, System.UInt32 value) => throw null;
            public static System.UInt64 Add(ref System.UInt64 location1, System.UInt64 value) => throw null;
            public static int And(ref int location1, int value) => throw null;
            public static System.Int64 And(ref System.Int64 location1, System.Int64 value) => throw null;
            public static System.UInt32 And(ref System.UInt32 location1, System.UInt32 value) => throw null;
            public static System.UInt64 And(ref System.UInt64 location1, System.UInt64 value) => throw null;
            public static System.IntPtr CompareExchange(ref System.IntPtr location1, System.IntPtr value, System.IntPtr comparand) => throw null;
            public static double CompareExchange(ref double location1, double value, double comparand) => throw null;
            public static float CompareExchange(ref float location1, float value, float comparand) => throw null;
            public static int CompareExchange(ref int location1, int value, int comparand) => throw null;
            public static System.Int64 CompareExchange(ref System.Int64 location1, System.Int64 value, System.Int64 comparand) => throw null;
            public static object CompareExchange(ref object location1, object value, object comparand) => throw null;
            public static System.UInt32 CompareExchange(ref System.UInt32 location1, System.UInt32 value, System.UInt32 comparand) => throw null;
            public static System.UInt64 CompareExchange(ref System.UInt64 location1, System.UInt64 value, System.UInt64 comparand) => throw null;
            public static T CompareExchange<T>(ref T location1, T value, T comparand) where T : class => throw null;
            public static int Decrement(ref int location) => throw null;
            public static System.Int64 Decrement(ref System.Int64 location) => throw null;
            public static System.UInt32 Decrement(ref System.UInt32 location) => throw null;
            public static System.UInt64 Decrement(ref System.UInt64 location) => throw null;
            public static System.IntPtr Exchange(ref System.IntPtr location1, System.IntPtr value) => throw null;
            public static double Exchange(ref double location1, double value) => throw null;
            public static float Exchange(ref float location1, float value) => throw null;
            public static int Exchange(ref int location1, int value) => throw null;
            public static System.Int64 Exchange(ref System.Int64 location1, System.Int64 value) => throw null;
            public static object Exchange(ref object location1, object value) => throw null;
            public static System.UInt32 Exchange(ref System.UInt32 location1, System.UInt32 value) => throw null;
            public static System.UInt64 Exchange(ref System.UInt64 location1, System.UInt64 value) => throw null;
            public static T Exchange<T>(ref T location1, T value) where T : class => throw null;
            public static int Increment(ref int location) => throw null;
            public static System.Int64 Increment(ref System.Int64 location) => throw null;
            public static System.UInt32 Increment(ref System.UInt32 location) => throw null;
            public static System.UInt64 Increment(ref System.UInt64 location) => throw null;
            public static void MemoryBarrier() => throw null;
            public static void MemoryBarrierProcessWide() => throw null;
            public static int Or(ref int location1, int value) => throw null;
            public static System.Int64 Or(ref System.Int64 location1, System.Int64 value) => throw null;
            public static System.UInt32 Or(ref System.UInt32 location1, System.UInt32 value) => throw null;
            public static System.UInt64 Or(ref System.UInt64 location1, System.UInt64 value) => throw null;
            public static System.Int64 Read(ref System.Int64 location) => throw null;
            public static System.UInt64 Read(ref System.UInt64 location) => throw null;
        }

        // Generated from `System.Threading.LazyInitializer` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class LazyInitializer
        {
            public static T EnsureInitialized<T>(ref T target) where T : class => throw null;
            public static T EnsureInitialized<T>(ref T target, System.Func<T> valueFactory) where T : class => throw null;
            public static T EnsureInitialized<T>(ref T target, ref bool initialized, ref object syncLock) => throw null;
            public static T EnsureInitialized<T>(ref T target, ref bool initialized, ref object syncLock, System.Func<T> valueFactory) => throw null;
            public static T EnsureInitialized<T>(ref T target, ref object syncLock, System.Func<T> valueFactory) where T : class => throw null;
        }

        // Generated from `System.Threading.LockCookie` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct LockCookie
        {
            public static bool operator !=(System.Threading.LockCookie a, System.Threading.LockCookie b) => throw null;
            public static bool operator ==(System.Threading.LockCookie a, System.Threading.LockCookie b) => throw null;
            public bool Equals(System.Threading.LockCookie obj) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            // Stub generator skipped constructor 
        }

        // Generated from `System.Threading.LockRecursionException` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class LockRecursionException : System.Exception
        {
            public LockRecursionException() => throw null;
            protected LockRecursionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public LockRecursionException(string message) => throw null;
            public LockRecursionException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Threading.LockRecursionPolicy` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum LockRecursionPolicy
        {
            NoRecursion,
            SupportsRecursion,
        }

        // Generated from `System.Threading.ManualResetEvent` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ManualResetEvent : System.Threading.EventWaitHandle
        {
            public ManualResetEvent(bool initialState) : base(default(bool), default(System.Threading.EventResetMode)) => throw null;
        }

        // Generated from `System.Threading.ManualResetEventSlim` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ManualResetEventSlim : System.IDisposable
        {
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public bool IsSet { get => throw null; }
            public ManualResetEventSlim() => throw null;
            public ManualResetEventSlim(bool initialState) => throw null;
            public ManualResetEventSlim(bool initialState, int spinCount) => throw null;
            public void Reset() => throw null;
            public void Set() => throw null;
            public int SpinCount { get => throw null; }
            public void Wait() => throw null;
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(System.TimeSpan timeout) => throw null;
            public bool Wait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(int millisecondsTimeout) => throw null;
            public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.WaitHandle WaitHandle { get => throw null; }
        }

        // Generated from `System.Threading.Monitor` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Monitor
        {
            public static void Enter(object obj) => throw null;
            public static void Enter(object obj, ref bool lockTaken) => throw null;
            public static void Exit(object obj) => throw null;
            public static bool IsEntered(object obj) => throw null;
            public static System.Int64 LockContentionCount { get => throw null; }
            public static void Pulse(object obj) => throw null;
            public static void PulseAll(object obj) => throw null;
            public static bool TryEnter(object obj) => throw null;
            public static bool TryEnter(object obj, System.TimeSpan timeout) => throw null;
            public static void TryEnter(object obj, System.TimeSpan timeout, ref bool lockTaken) => throw null;
            public static bool TryEnter(object obj, int millisecondsTimeout) => throw null;
            public static void TryEnter(object obj, int millisecondsTimeout, ref bool lockTaken) => throw null;
            public static void TryEnter(object obj, ref bool lockTaken) => throw null;
            public static bool Wait(object obj) => throw null;
            public static bool Wait(object obj, System.TimeSpan timeout) => throw null;
            public static bool Wait(object obj, System.TimeSpan timeout, bool exitContext) => throw null;
            public static bool Wait(object obj, int millisecondsTimeout) => throw null;
            public static bool Wait(object obj, int millisecondsTimeout, bool exitContext) => throw null;
        }

        // Generated from `System.Threading.Mutex` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Mutex : System.Threading.WaitHandle
        {
            public Mutex() => throw null;
            public Mutex(bool initiallyOwned) => throw null;
            public Mutex(bool initiallyOwned, string name) => throw null;
            public Mutex(bool initiallyOwned, string name, out bool createdNew) => throw null;
            public static System.Threading.Mutex OpenExisting(string name) => throw null;
            public void ReleaseMutex() => throw null;
            public static bool TryOpenExisting(string name, out System.Threading.Mutex result) => throw null;
        }

        // Generated from `System.Threading.ReaderWriterLock` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ReaderWriterLock : System.Runtime.ConstrainedExecution.CriticalFinalizerObject
        {
            public void AcquireReaderLock(System.TimeSpan timeout) => throw null;
            public void AcquireReaderLock(int millisecondsTimeout) => throw null;
            public void AcquireWriterLock(System.TimeSpan timeout) => throw null;
            public void AcquireWriterLock(int millisecondsTimeout) => throw null;
            public bool AnyWritersSince(int seqNum) => throw null;
            public void DowngradeFromWriterLock(ref System.Threading.LockCookie lockCookie) => throw null;
            public bool IsReaderLockHeld { get => throw null; }
            public bool IsWriterLockHeld { get => throw null; }
            public ReaderWriterLock() => throw null;
            public System.Threading.LockCookie ReleaseLock() => throw null;
            public void ReleaseReaderLock() => throw null;
            public void ReleaseWriterLock() => throw null;
            public void RestoreLock(ref System.Threading.LockCookie lockCookie) => throw null;
            public System.Threading.LockCookie UpgradeToWriterLock(System.TimeSpan timeout) => throw null;
            public System.Threading.LockCookie UpgradeToWriterLock(int millisecondsTimeout) => throw null;
            public int WriterSeqNum { get => throw null; }
        }

        // Generated from `System.Threading.ReaderWriterLockSlim` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ReaderWriterLockSlim : System.IDisposable
        {
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
            public ReaderWriterLockSlim() => throw null;
            public ReaderWriterLockSlim(System.Threading.LockRecursionPolicy recursionPolicy) => throw null;
            public System.Threading.LockRecursionPolicy RecursionPolicy { get => throw null; }
            public int RecursiveReadCount { get => throw null; }
            public int RecursiveUpgradeCount { get => throw null; }
            public int RecursiveWriteCount { get => throw null; }
            public bool TryEnterReadLock(System.TimeSpan timeout) => throw null;
            public bool TryEnterReadLock(int millisecondsTimeout) => throw null;
            public bool TryEnterUpgradeableReadLock(System.TimeSpan timeout) => throw null;
            public bool TryEnterUpgradeableReadLock(int millisecondsTimeout) => throw null;
            public bool TryEnterWriteLock(System.TimeSpan timeout) => throw null;
            public bool TryEnterWriteLock(int millisecondsTimeout) => throw null;
            public int WaitingReadCount { get => throw null; }
            public int WaitingUpgradeCount { get => throw null; }
            public int WaitingWriteCount { get => throw null; }
        }

        // Generated from `System.Threading.Semaphore` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Semaphore : System.Threading.WaitHandle
        {
            public static System.Threading.Semaphore OpenExisting(string name) => throw null;
            public int Release() => throw null;
            public int Release(int releaseCount) => throw null;
            public Semaphore(int initialCount, int maximumCount) => throw null;
            public Semaphore(int initialCount, int maximumCount, string name) => throw null;
            public Semaphore(int initialCount, int maximumCount, string name, out bool createdNew) => throw null;
            public static bool TryOpenExisting(string name, out System.Threading.Semaphore result) => throw null;
        }

        // Generated from `System.Threading.SemaphoreFullException` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SemaphoreFullException : System.SystemException
        {
            public SemaphoreFullException() => throw null;
            protected SemaphoreFullException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SemaphoreFullException(string message) => throw null;
            public SemaphoreFullException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Threading.SemaphoreSlim` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SemaphoreSlim : System.IDisposable
        {
            public System.Threading.WaitHandle AvailableWaitHandle { get => throw null; }
            public int CurrentCount { get => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public int Release() => throw null;
            public int Release(int releaseCount) => throw null;
            public SemaphoreSlim(int initialCount) => throw null;
            public SemaphoreSlim(int initialCount, int maxCount) => throw null;
            public void Wait() => throw null;
            public void Wait(System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(System.TimeSpan timeout) => throw null;
            public bool Wait(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public bool Wait(int millisecondsTimeout) => throw null;
            public bool Wait(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task WaitAsync() => throw null;
            public System.Threading.Tasks.Task WaitAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(System.TimeSpan timeout) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(int millisecondsTimeout) => throw null;
            public System.Threading.Tasks.Task<bool> WaitAsync(int millisecondsTimeout, System.Threading.CancellationToken cancellationToken) => throw null;
        }

        // Generated from `System.Threading.SendOrPostCallback` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void SendOrPostCallback(object state);

        // Generated from `System.Threading.SpinLock` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct SpinLock
        {
            public void Enter(ref bool lockTaken) => throw null;
            public void Exit() => throw null;
            public void Exit(bool useMemoryBarrier) => throw null;
            public bool IsHeld { get => throw null; }
            public bool IsHeldByCurrentThread { get => throw null; }
            public bool IsThreadOwnerTrackingEnabled { get => throw null; }
            // Stub generator skipped constructor 
            public SpinLock(bool enableThreadOwnerTracking) => throw null;
            public void TryEnter(System.TimeSpan timeout, ref bool lockTaken) => throw null;
            public void TryEnter(int millisecondsTimeout, ref bool lockTaken) => throw null;
            public void TryEnter(ref bool lockTaken) => throw null;
        }

        // Generated from `System.Threading.SpinWait` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct SpinWait
        {
            public int Count { get => throw null; }
            public bool NextSpinWillYield { get => throw null; }
            public void Reset() => throw null;
            public void SpinOnce() => throw null;
            public void SpinOnce(int sleep1Threshold) => throw null;
            public static void SpinUntil(System.Func<bool> condition) => throw null;
            public static bool SpinUntil(System.Func<bool> condition, System.TimeSpan timeout) => throw null;
            public static bool SpinUntil(System.Func<bool> condition, int millisecondsTimeout) => throw null;
            // Stub generator skipped constructor 
        }

        // Generated from `System.Threading.SynchronizationContext` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SynchronizationContext
        {
            public virtual System.Threading.SynchronizationContext CreateCopy() => throw null;
            public static System.Threading.SynchronizationContext Current { get => throw null; }
            public bool IsWaitNotificationRequired() => throw null;
            public virtual void OperationCompleted() => throw null;
            public virtual void OperationStarted() => throw null;
            public virtual void Post(System.Threading.SendOrPostCallback d, object state) => throw null;
            public virtual void Send(System.Threading.SendOrPostCallback d, object state) => throw null;
            public static void SetSynchronizationContext(System.Threading.SynchronizationContext syncContext) => throw null;
            protected void SetWaitNotificationRequired() => throw null;
            public SynchronizationContext() => throw null;
            public virtual int Wait(System.IntPtr[] waitHandles, bool waitAll, int millisecondsTimeout) => throw null;
            protected static int WaitHelper(System.IntPtr[] waitHandles, bool waitAll, int millisecondsTimeout) => throw null;
        }

        // Generated from `System.Threading.SynchronizationLockException` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class SynchronizationLockException : System.SystemException
        {
            public SynchronizationLockException() => throw null;
            protected SynchronizationLockException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public SynchronizationLockException(string message) => throw null;
            public SynchronizationLockException(string message, System.Exception innerException) => throw null;
        }

        // Generated from `System.Threading.ThreadLocal<>` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ThreadLocal<T> : System.IDisposable
        {
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public bool IsValueCreated { get => throw null; }
            public ThreadLocal() => throw null;
            public ThreadLocal(System.Func<T> valueFactory) => throw null;
            public ThreadLocal(System.Func<T> valueFactory, bool trackAllValues) => throw null;
            public ThreadLocal(bool trackAllValues) => throw null;
            public override string ToString() => throw null;
            public T Value { get => throw null; set => throw null; }
            public System.Collections.Generic.IList<T> Values { get => throw null; }
            // ERR: Stub generator didn't handle member: ~ThreadLocal
        }

        // Generated from `System.Threading.Volatile` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Volatile
        {
            public static System.IntPtr Read(ref System.IntPtr location) => throw null;
            public static System.UIntPtr Read(ref System.UIntPtr location) => throw null;
            public static bool Read(ref bool location) => throw null;
            public static System.Byte Read(ref System.Byte location) => throw null;
            public static double Read(ref double location) => throw null;
            public static float Read(ref float location) => throw null;
            public static int Read(ref int location) => throw null;
            public static System.Int64 Read(ref System.Int64 location) => throw null;
            public static System.SByte Read(ref System.SByte location) => throw null;
            public static System.Int16 Read(ref System.Int16 location) => throw null;
            public static System.UInt32 Read(ref System.UInt32 location) => throw null;
            public static System.UInt64 Read(ref System.UInt64 location) => throw null;
            public static System.UInt16 Read(ref System.UInt16 location) => throw null;
            public static T Read<T>(ref T location) where T : class => throw null;
            public static void Write(ref System.IntPtr location, System.IntPtr value) => throw null;
            public static void Write(ref System.UIntPtr location, System.UIntPtr value) => throw null;
            public static void Write(ref bool location, bool value) => throw null;
            public static void Write(ref System.Byte location, System.Byte value) => throw null;
            public static void Write(ref double location, double value) => throw null;
            public static void Write(ref float location, float value) => throw null;
            public static void Write(ref int location, int value) => throw null;
            public static void Write(ref System.Int64 location, System.Int64 value) => throw null;
            public static void Write(ref System.SByte location, System.SByte value) => throw null;
            public static void Write(ref System.Int16 location, System.Int16 value) => throw null;
            public static void Write(ref System.UInt32 location, System.UInt32 value) => throw null;
            public static void Write(ref System.UInt64 location, System.UInt64 value) => throw null;
            public static void Write(ref System.UInt16 location, System.UInt16 value) => throw null;
            public static void Write<T>(ref T location, T value) where T : class => throw null;
        }

        // Generated from `System.Threading.WaitHandleCannotBeOpenedException` in `System.Threading, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class WaitHandleCannotBeOpenedException : System.ApplicationException
        {
            public WaitHandleCannotBeOpenedException() => throw null;
            protected WaitHandleCannotBeOpenedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public WaitHandleCannotBeOpenedException(string message) => throw null;
            public WaitHandleCannotBeOpenedException(string message, System.Exception innerException) => throw null;
        }

    }
}
