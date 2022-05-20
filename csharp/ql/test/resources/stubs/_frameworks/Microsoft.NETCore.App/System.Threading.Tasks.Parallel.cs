// This file contains auto-generated code.

namespace System
{
    namespace Threading
    {
        namespace Tasks
        {
            // Generated from `System.Threading.Tasks.Parallel` in `System.Threading.Tasks.Parallel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                public static void Invoke(System.Threading.Tasks.ParallelOptions parallelOptions, params System.Action[] actions) => throw null;
                public static void Invoke(params System.Action[] actions) => throw null;
            }

            // Generated from `System.Threading.Tasks.ParallelLoopResult` in `System.Threading.Tasks.Parallel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct ParallelLoopResult
            {
                public bool IsCompleted { get => throw null; }
                public System.Int64? LowestBreakIteration { get => throw null; }
                // Stub generator skipped constructor 
            }

            // Generated from `System.Threading.Tasks.ParallelLoopState` in `System.Threading.Tasks.Parallel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ParallelLoopState
            {
                public void Break() => throw null;
                public bool IsExceptional { get => throw null; }
                public bool IsStopped { get => throw null; }
                public System.Int64? LowestBreakIteration { get => throw null; }
                public bool ShouldExitCurrentIteration { get => throw null; }
                public void Stop() => throw null;
            }

            // Generated from `System.Threading.Tasks.ParallelOptions` in `System.Threading.Tasks.Parallel, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
