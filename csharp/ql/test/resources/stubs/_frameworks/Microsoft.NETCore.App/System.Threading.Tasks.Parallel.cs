// This file contains auto-generated code.
// Generated from `System.Threading.Tasks.Parallel, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Threading
    {
        namespace Tasks
        {
            public static class Parallel
            {
                public static System.Threading.Tasks.ParallelLoopResult For(int fromInclusive, int toExclusive, System.Action<int, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(int fromInclusive, int toExclusive, System.Action<int> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(int fromInclusive, int toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<int, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(int fromInclusive, int toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<int> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(long fromInclusive, long toExclusive, System.Action<long, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(long fromInclusive, long toExclusive, System.Action<long> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(long fromInclusive, long toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<long, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(long fromInclusive, long toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<long> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(int fromInclusive, int toExclusive, System.Func<TLocal> localInit, System.Func<int, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(int fromInclusive, int toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<int, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(long fromInclusive, long toExclusive, System.Func<TLocal> localInit, System.Func<long, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(long fromInclusive, long toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<long, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.Task ForAsync<T>(T fromInclusive, T toExclusive, System.Func<T, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) where T : System.Numerics.IBinaryInteger<T> => throw null;
                public static System.Threading.Tasks.Task ForAsync<T>(T fromInclusive, T toExclusive, System.Threading.CancellationToken cancellationToken, System.Func<T, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) where T : System.Numerics.IBinaryInteger<T> => throw null;
                public static System.Threading.Tasks.Task ForAsync<T>(T fromInclusive, T toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<T, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) where T : System.Numerics.IBinaryInteger<T> => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, long> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, long> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, long> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, long> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, long, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, long, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.Partitioner<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.Partitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, long, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, long, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.CancellationToken cancellationToken, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IAsyncEnumerable<TSource> source, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IAsyncEnumerable<TSource> source, System.Threading.CancellationToken cancellationToken, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IAsyncEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static void Invoke(params System.Action[] actions) => throw null;
                public static void Invoke(System.Threading.Tasks.ParallelOptions parallelOptions, params System.Action[] actions) => throw null;
            }
            public struct ParallelLoopResult
            {
                public bool IsCompleted { get => throw null; }
                public long? LowestBreakIteration { get => throw null; }
            }
            public class ParallelLoopState
            {
                public void Break() => throw null;
                public bool IsExceptional { get => throw null; }
                public bool IsStopped { get => throw null; }
                public long? LowestBreakIteration { get => throw null; }
                public bool ShouldExitCurrentIteration { get => throw null; }
                public void Stop() => throw null;
            }
            public class ParallelOptions
            {
                public System.Threading.CancellationToken CancellationToken { get => throw null; set { } }
                public ParallelOptions() => throw null;
                public int MaxDegreeOfParallelism { get => throw null; set { } }
                public System.Threading.Tasks.TaskScheduler TaskScheduler { get => throw null; set { } }
            }
        }
    }
}
