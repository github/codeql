// This file contains auto-generated code.
// Generated from `System.Threading.Tasks.Parallel, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

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
                public static System.Threading.Tasks.ParallelLoopResult For(System.Int64 fromInclusive, System.Int64 toExclusive, System.Action<System.Int64, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(System.Int64 fromInclusive, System.Int64 toExclusive, System.Action<System.Int64> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(System.Int64 fromInclusive, System.Int64 toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<System.Int64, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For(System.Int64 fromInclusive, System.Int64 toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<System.Int64> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(int fromInclusive, int toExclusive, System.Func<TLocal> localInit, System.Func<int, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(int fromInclusive, int toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<int, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(System.Int64 fromInclusive, System.Int64 toExclusive, System.Func<TLocal> localInit, System.Func<System.Int64, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult For<TLocal>(System.Int64 fromInclusive, System.Int64 toExclusive, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<System.Int64, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.Partitioner<TSource> source, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource, TLocal>(System.Collections.Concurrent.Partitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TLocal> localInit, System.Func<TSource, System.Threading.Tasks.ParallelLoopState, TLocal, TLocal> body, System.Action<TLocal> localFinally) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.OrderablePartitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState, System.Int64> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource, System.Threading.Tasks.ParallelLoopState> body) => throw null;
                public static System.Threading.Tasks.ParallelLoopResult ForEach<TSource>(System.Collections.Concurrent.Partitioner<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Action<TSource> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IAsyncEnumerable<TSource> source, System.Threading.CancellationToken cancellationToken, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IAsyncEnumerable<TSource> source, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IAsyncEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.CancellationToken cancellationToken, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<TSource>(System.Collections.Generic.IEnumerable<TSource> source, System.Threading.Tasks.ParallelOptions parallelOptions, System.Func<TSource, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> body) => throw null;
                public static void Invoke(System.Threading.Tasks.ParallelOptions parallelOptions, params System.Action[] actions) => throw null;
                public static void Invoke(params System.Action[] actions) => throw null;
            }

            public struct ParallelLoopResult
            {
                public bool IsCompleted { get => throw null; }
                public System.Int64? LowestBreakIteration { get => throw null; }
                // Stub generator skipped constructor 
            }

            public class ParallelLoopState
            {
                public void Break() => throw null;
                public bool IsExceptional { get => throw null; }
                public bool IsStopped { get => throw null; }
                public System.Int64? LowestBreakIteration { get => throw null; }
                public bool ShouldExitCurrentIteration { get => throw null; }
                public void Stop() => throw null;
            }

            public class ParallelOptions
            {
                public System.Threading.CancellationToken CancellationToken { get => throw null; set => throw null; }
                public int MaxDegreeOfParallelism { get => throw null; set => throw null; }
                public ParallelOptions() => throw null;
                public System.Threading.Tasks.TaskScheduler TaskScheduler { get => throw null; set => throw null; }
            }

        }
    }
}
