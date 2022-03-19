// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'AllowNullAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'DisallowNullAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'DoesNotReturnAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'DoesNotReturnIfAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MaybeNullAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MaybeNullWhenAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MemberNotNullAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MemberNotNullWhenAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'NotNullAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'NotNullIfNotNullAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'NotNullWhenAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

        }
    }
    namespace Threading
    {
        namespace Tasks
        {
            namespace Dataflow
            {
                // Generated from `System.Threading.Tasks.Dataflow.ActionBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ActionBlock<TInput> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.ITargetBlock<TInput>
                {
                    public ActionBlock(System.Action<TInput> action) => throw null;
                    public ActionBlock(System.Action<TInput> action, System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public ActionBlock(System.Func<TInput, System.Threading.Tasks.Task> action) => throw null;
                    public ActionBlock(System.Func<TInput, System.Threading.Tasks.Task> action, System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public int InputCount { get => throw null; }
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<TInput>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, TInput messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<TInput> source, bool consumeToAccept) => throw null;
                    public bool Post(TInput item) => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.BatchBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class BatchBlock<T> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IPropagatorBlock<T, T[]>, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<T[]>, System.Threading.Tasks.Dataflow.ISourceBlock<T[]>, System.Threading.Tasks.Dataflow.ITargetBlock<T>
                {
                    public BatchBlock(int batchSize) => throw null;
                    public BatchBlock(int batchSize, System.Threading.Tasks.Dataflow.GroupingDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public int BatchSize { get => throw null; }
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    T[] System.Threading.Tasks.Dataflow.ISourceBlock<T[]>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T[]> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<T[]> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<T>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, T messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<T> source, bool consumeToAccept) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<T[]>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T[]> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<T[]>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T[]> target) => throw null;
                    public override string ToString() => throw null;
                    public void TriggerBatch() => throw null;
                    public bool TryReceive(System.Predicate<T[]> filter, out T[] item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<T[]> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.BatchedJoinBlock<,,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class BatchedJoinBlock<T1, T2, T3> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>>, System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>>
                {
                    public int BatchSize { get => throw null; }
                    public BatchedJoinBlock(int batchSize) => throw null;
                    public BatchedJoinBlock(int batchSize, System.Threading.Tasks.Dataflow.GroupingDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>> System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>> target) => throw null;
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T1> Target1 { get => throw null; }
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T2> Target2 { get => throw null; }
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T3> Target3 { get => throw null; }
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>> filter, out System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>> item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>, System.Collections.Generic.IList<T3>>> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.BatchedJoinBlock<,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class BatchedJoinBlock<T1, T2> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>>, System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>>
                {
                    public int BatchSize { get => throw null; }
                    public BatchedJoinBlock(int batchSize) => throw null;
                    public BatchedJoinBlock(int batchSize, System.Threading.Tasks.Dataflow.GroupingDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>> System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>> target) => throw null;
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T1> Target1 { get => throw null; }
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T2> Target2 { get => throw null; }
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>> filter, out System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>> item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<System.Tuple<System.Collections.Generic.IList<T1>, System.Collections.Generic.IList<T2>>> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.BroadcastBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class BroadcastBlock<T> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IPropagatorBlock<T, T>, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<T>, System.Threading.Tasks.Dataflow.ISourceBlock<T>, System.Threading.Tasks.Dataflow.ITargetBlock<T>
                {
                    public BroadcastBlock(System.Func<T, T> cloningFunction) => throw null;
                    public BroadcastBlock(System.Func<T, T> cloningFunction, System.Threading.Tasks.Dataflow.DataflowBlockOptions dataflowBlockOptions) => throw null;
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    T System.Threading.Tasks.Dataflow.ISourceBlock<T>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<T> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<T>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, T messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<T> source, bool consumeToAccept) => throw null;
                    void System.Threading.Tasks.Dataflow.ISourceBlock<T>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<T>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target) => throw null;
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<T> filter, out T item) => throw null;
                    bool System.Threading.Tasks.Dataflow.IReceivableSourceBlock<T>.TryReceiveAll(out System.Collections.Generic.IList<T> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.BufferBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class BufferBlock<T> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IPropagatorBlock<T, T>, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<T>, System.Threading.Tasks.Dataflow.ISourceBlock<T>, System.Threading.Tasks.Dataflow.ITargetBlock<T>
                {
                    public BufferBlock() => throw null;
                    public BufferBlock(System.Threading.Tasks.Dataflow.DataflowBlockOptions dataflowBlockOptions) => throw null;
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    T System.Threading.Tasks.Dataflow.ISourceBlock<T>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target, out bool messageConsumed) => throw null;
                    public int Count { get => throw null; }
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<T> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<T>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, T messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<T> source, bool consumeToAccept) => throw null;
                    void System.Threading.Tasks.Dataflow.ISourceBlock<T>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<T>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target) => throw null;
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<T> filter, out T item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<T> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.DataflowBlock` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public static class DataflowBlock
                {
                    public static System.IObservable<TOutput> AsObservable<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source) => throw null;
                    public static System.IObserver<TInput> AsObserver<TInput>(this System.Threading.Tasks.Dataflow.ITargetBlock<TInput> target) => throw null;
                    public static System.Threading.Tasks.Task<int> Choose<T1, T2, T3>(System.Threading.Tasks.Dataflow.ISourceBlock<T1> source1, System.Action<T1> action1, System.Threading.Tasks.Dataflow.ISourceBlock<T2> source2, System.Action<T2> action2, System.Threading.Tasks.Dataflow.ISourceBlock<T3> source3, System.Action<T3> action3) => throw null;
                    public static System.Threading.Tasks.Task<int> Choose<T1, T2, T3>(System.Threading.Tasks.Dataflow.ISourceBlock<T1> source1, System.Action<T1> action1, System.Threading.Tasks.Dataflow.ISourceBlock<T2> source2, System.Action<T2> action2, System.Threading.Tasks.Dataflow.ISourceBlock<T3> source3, System.Action<T3> action3, System.Threading.Tasks.Dataflow.DataflowBlockOptions dataflowBlockOptions) => throw null;
                    public static System.Threading.Tasks.Task<int> Choose<T1, T2>(System.Threading.Tasks.Dataflow.ISourceBlock<T1> source1, System.Action<T1> action1, System.Threading.Tasks.Dataflow.ISourceBlock<T2> source2, System.Action<T2> action2) => throw null;
                    public static System.Threading.Tasks.Task<int> Choose<T1, T2>(System.Threading.Tasks.Dataflow.ISourceBlock<T1> source1, System.Action<T1> action1, System.Threading.Tasks.Dataflow.ISourceBlock<T2> source2, System.Action<T2> action2, System.Threading.Tasks.Dataflow.DataflowBlockOptions dataflowBlockOptions) => throw null;
                    public static System.Threading.Tasks.Dataflow.IPropagatorBlock<TInput, TOutput> Encapsulate<TInput, TOutput>(System.Threading.Tasks.Dataflow.ITargetBlock<TInput> target, System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source) => throw null;
                    public static System.IDisposable LinkTo<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target) => throw null;
                    public static System.IDisposable LinkTo<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions, System.Predicate<TOutput> predicate) => throw null;
                    public static System.IDisposable LinkTo<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, System.Predicate<TOutput> predicate) => throw null;
                    public static System.Threading.Tasks.Dataflow.ITargetBlock<TInput> NullTarget<TInput>() => throw null;
                    public static System.Threading.Tasks.Task<bool> OutputAvailableAsync<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source) => throw null;
                    public static System.Threading.Tasks.Task<bool> OutputAvailableAsync<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static bool Post<TInput>(this System.Threading.Tasks.Dataflow.ITargetBlock<TInput> target, TInput item) => throw null;
                    public static TOutput Receive<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source) => throw null;
                    public static TOutput Receive<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static TOutput Receive<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.TimeSpan timeout) => throw null;
                    public static TOutput Receive<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<TOutput> ReceiveAsync<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source) => throw null;
                    public static System.Threading.Tasks.Task<TOutput> ReceiveAsync<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<TOutput> ReceiveAsync<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.TimeSpan timeout) => throw null;
                    public static System.Threading.Tasks.Task<TOutput> ReceiveAsync<TOutput>(this System.Threading.Tasks.Dataflow.ISourceBlock<TOutput> source, System.TimeSpan timeout, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static System.Threading.Tasks.Task<bool> SendAsync<TInput>(this System.Threading.Tasks.Dataflow.ITargetBlock<TInput> target, TInput item) => throw null;
                    public static System.Threading.Tasks.Task<bool> SendAsync<TInput>(this System.Threading.Tasks.Dataflow.ITargetBlock<TInput> target, TInput item, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static bool TryReceive<TOutput>(this System.Threading.Tasks.Dataflow.IReceivableSourceBlock<TOutput> source, out TOutput item) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.DataflowBlockOptions` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DataflowBlockOptions
                {
                    public int BoundedCapacity { get => throw null; set => throw null; }
                    public System.Threading.CancellationToken CancellationToken { get => throw null; set => throw null; }
                    public DataflowBlockOptions() => throw null;
                    public bool EnsureOrdered { get => throw null; set => throw null; }
                    public int MaxMessagesPerTask { get => throw null; set => throw null; }
                    public string NameFormat { get => throw null; set => throw null; }
                    public System.Threading.Tasks.TaskScheduler TaskScheduler { get => throw null; set => throw null; }
                    public const int Unbounded = default;
                }

                // Generated from `System.Threading.Tasks.Dataflow.DataflowLinkOptions` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DataflowLinkOptions
                {
                    public bool Append { get => throw null; set => throw null; }
                    public DataflowLinkOptions() => throw null;
                    public int MaxMessages { get => throw null; set => throw null; }
                    public bool PropagateCompletion { get => throw null; set => throw null; }
                }

                // Generated from `System.Threading.Tasks.Dataflow.DataflowMessageHeader` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public struct DataflowMessageHeader : System.IEquatable<System.Threading.Tasks.Dataflow.DataflowMessageHeader>
                {
                    public static bool operator !=(System.Threading.Tasks.Dataflow.DataflowMessageHeader left, System.Threading.Tasks.Dataflow.DataflowMessageHeader right) => throw null;
                    public static bool operator ==(System.Threading.Tasks.Dataflow.DataflowMessageHeader left, System.Threading.Tasks.Dataflow.DataflowMessageHeader right) => throw null;
                    // Stub generator skipped constructor 
                    public DataflowMessageHeader(System.Int64 id) => throw null;
                    public bool Equals(System.Threading.Tasks.Dataflow.DataflowMessageHeader other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Int64 Id { get => throw null; }
                    public bool IsValid { get => throw null; }
                }

                // Generated from `System.Threading.Tasks.Dataflow.DataflowMessageStatus` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum DataflowMessageStatus
                {
                    Accepted,
                    Declined,
                    DecliningPermanently,
                    NotAvailable,
                    Postponed,
                }

                // Generated from `System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ExecutionDataflowBlockOptions : System.Threading.Tasks.Dataflow.DataflowBlockOptions
                {
                    public ExecutionDataflowBlockOptions() => throw null;
                    public int MaxDegreeOfParallelism { get => throw null; set => throw null; }
                    public bool SingleProducerConstrained { get => throw null; set => throw null; }
                }

                // Generated from `System.Threading.Tasks.Dataflow.GroupingDataflowBlockOptions` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class GroupingDataflowBlockOptions : System.Threading.Tasks.Dataflow.DataflowBlockOptions
                {
                    public bool Greedy { get => throw null; set => throw null; }
                    public GroupingDataflowBlockOptions() => throw null;
                    public System.Int64 MaxNumberOfGroups { get => throw null; set => throw null; }
                }

                // Generated from `System.Threading.Tasks.Dataflow.IDataflowBlock` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IDataflowBlock
                {
                    void Complete();
                    System.Threading.Tasks.Task Completion { get; }
                    void Fault(System.Exception exception);
                }

                // Generated from `System.Threading.Tasks.Dataflow.IPropagatorBlock<,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IPropagatorBlock<TInput, TOutput> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>, System.Threading.Tasks.Dataflow.ITargetBlock<TInput>
                {
                }

                // Generated from `System.Threading.Tasks.Dataflow.IReceivableSourceBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IReceivableSourceBlock<TOutput> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>
                {
                    bool TryReceive(System.Predicate<TOutput> filter, out TOutput item);
                    bool TryReceiveAll(out System.Collections.Generic.IList<TOutput> items);
                }

                // Generated from `System.Threading.Tasks.Dataflow.ISourceBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ISourceBlock<TOutput> : System.Threading.Tasks.Dataflow.IDataflowBlock
                {
                    TOutput ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, out bool messageConsumed);
                    System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions);
                    void ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target);
                    bool ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target);
                }

                // Generated from `System.Threading.Tasks.Dataflow.ITargetBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface ITargetBlock<TInput> : System.Threading.Tasks.Dataflow.IDataflowBlock
                {
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, TInput messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<TInput> source, bool consumeToAccept);
                }

                // Generated from `System.Threading.Tasks.Dataflow.JoinBlock<,,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class JoinBlock<T1, T2, T3> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<System.Tuple<T1, T2, T3>>, System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2, T3>>
                {
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    System.Tuple<T1, T2, T3> System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2, T3>>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2, T3>> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public JoinBlock() => throw null;
                    public JoinBlock(System.Threading.Tasks.Dataflow.GroupingDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2, T3>> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2, T3>>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2, T3>> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2, T3>>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2, T3>> target) => throw null;
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T1> Target1 { get => throw null; }
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T2> Target2 { get => throw null; }
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T3> Target3 { get => throw null; }
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<System.Tuple<T1, T2, T3>> filter, out System.Tuple<T1, T2, T3> item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<System.Tuple<T1, T2, T3>> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.JoinBlock<,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class JoinBlock<T1, T2> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<System.Tuple<T1, T2>>, System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2>>
                {
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    System.Tuple<T1, T2> System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2>>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2>> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public JoinBlock() => throw null;
                    public JoinBlock(System.Threading.Tasks.Dataflow.GroupingDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2>> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2>>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2>> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<System.Tuple<T1, T2>>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<System.Tuple<T1, T2>> target) => throw null;
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T1> Target1 { get => throw null; }
                    public System.Threading.Tasks.Dataflow.ITargetBlock<T2> Target2 { get => throw null; }
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<System.Tuple<T1, T2>> filter, out System.Tuple<T1, T2> item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<System.Tuple<T1, T2>> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.TransformBlock<,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class TransformBlock<TInput, TOutput> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IPropagatorBlock<TInput, TOutput>, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<TOutput>, System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>, System.Threading.Tasks.Dataflow.ITargetBlock<TInput>
                {
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    TOutput System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public int InputCount { get => throw null; }
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<TInput>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, TInput messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<TInput> source, bool consumeToAccept) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target) => throw null;
                    public override string ToString() => throw null;
                    public TransformBlock(System.Func<TInput, TOutput> transform) => throw null;
                    public TransformBlock(System.Func<TInput, TOutput> transform, System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public TransformBlock(System.Func<TInput, System.Threading.Tasks.Task<TOutput>> transform) => throw null;
                    public TransformBlock(System.Func<TInput, System.Threading.Tasks.Task<TOutput>> transform, System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public bool TryReceive(System.Predicate<TOutput> filter, out TOutput item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<TOutput> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.TransformManyBlock<,>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class TransformManyBlock<TInput, TOutput> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IPropagatorBlock<TInput, TOutput>, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<TOutput>, System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>, System.Threading.Tasks.Dataflow.ITargetBlock<TInput>
                {
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    TOutput System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public int InputCount { get => throw null; }
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<TInput>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, TInput messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<TInput> source, bool consumeToAccept) => throw null;
                    public int OutputCount { get => throw null; }
                    void System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<TOutput>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<TOutput> target) => throw null;
                    public override string ToString() => throw null;
                    public TransformManyBlock(System.Func<TInput, System.Collections.Generic.IEnumerable<TOutput>> transform) => throw null;
                    public TransformManyBlock(System.Func<TInput, System.Collections.Generic.IEnumerable<TOutput>> transform, System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public TransformManyBlock(System.Func<TInput, System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TOutput>>> transform) => throw null;
                    public TransformManyBlock(System.Func<TInput, System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<TOutput>>> transform, System.Threading.Tasks.Dataflow.ExecutionDataflowBlockOptions dataflowBlockOptions) => throw null;
                    public bool TryReceive(System.Predicate<TOutput> filter, out TOutput item) => throw null;
                    public bool TryReceiveAll(out System.Collections.Generic.IList<TOutput> items) => throw null;
                }

                // Generated from `System.Threading.Tasks.Dataflow.WriteOnceBlock<>` in `System.Threading.Tasks.Dataflow, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class WriteOnceBlock<T> : System.Threading.Tasks.Dataflow.IDataflowBlock, System.Threading.Tasks.Dataflow.IPropagatorBlock<T, T>, System.Threading.Tasks.Dataflow.IReceivableSourceBlock<T>, System.Threading.Tasks.Dataflow.ISourceBlock<T>, System.Threading.Tasks.Dataflow.ITargetBlock<T>
                {
                    public void Complete() => throw null;
                    public System.Threading.Tasks.Task Completion { get => throw null; }
                    T System.Threading.Tasks.Dataflow.ISourceBlock<T>.ConsumeMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target, out bool messageConsumed) => throw null;
                    void System.Threading.Tasks.Dataflow.IDataflowBlock.Fault(System.Exception exception) => throw null;
                    public System.IDisposable LinkTo(System.Threading.Tasks.Dataflow.ITargetBlock<T> target, System.Threading.Tasks.Dataflow.DataflowLinkOptions linkOptions) => throw null;
                    System.Threading.Tasks.Dataflow.DataflowMessageStatus System.Threading.Tasks.Dataflow.ITargetBlock<T>.OfferMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, T messageValue, System.Threading.Tasks.Dataflow.ISourceBlock<T> source, bool consumeToAccept) => throw null;
                    void System.Threading.Tasks.Dataflow.ISourceBlock<T>.ReleaseReservation(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target) => throw null;
                    bool System.Threading.Tasks.Dataflow.ISourceBlock<T>.ReserveMessage(System.Threading.Tasks.Dataflow.DataflowMessageHeader messageHeader, System.Threading.Tasks.Dataflow.ITargetBlock<T> target) => throw null;
                    public override string ToString() => throw null;
                    public bool TryReceive(System.Predicate<T> filter, out T item) => throw null;
                    bool System.Threading.Tasks.Dataflow.IReceivableSourceBlock<T>.TryReceiveAll(out System.Collections.Generic.IList<T> items) => throw null;
                    public WriteOnceBlock(System.Func<T, T> cloningFunction) => throw null;
                    public WriteOnceBlock(System.Func<T, T> cloningFunction, System.Threading.Tasks.Dataflow.DataflowBlockOptions dataflowBlockOptions) => throw null;
                }

            }
        }
    }
}
