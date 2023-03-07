// This file contains auto-generated code.
// Generated from `System.Threading.RateLimiting, Version=7.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.

namespace System
{
    namespace Threading
    {
        namespace RateLimiting
        {
            public class ConcurrencyLimiter : System.Threading.RateLimiting.RateLimiter
            {
                protected override System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsyncCore(int permitCount, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Threading.RateLimiting.RateLimitLease AttemptAcquireCore(int permitCount) => throw null;
                public ConcurrencyLimiter(System.Threading.RateLimiting.ConcurrencyLimiterOptions options) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public override System.Threading.RateLimiting.RateLimiterStatistics GetStatistics() => throw null;
                public override System.TimeSpan? IdleDuration { get => throw null; }
            }

            public class ConcurrencyLimiterOptions
            {
                public ConcurrencyLimiterOptions() => throw null;
                public int PermitLimit { get => throw null; set => throw null; }
                public int QueueLimit { get => throw null; set => throw null; }
                public System.Threading.RateLimiting.QueueProcessingOrder QueueProcessingOrder { get => throw null; set => throw null; }
            }

            public class FixedWindowRateLimiter : System.Threading.RateLimiting.ReplenishingRateLimiter
            {
                protected override System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsyncCore(int permitCount, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Threading.RateLimiting.RateLimitLease AttemptAcquireCore(int permitCount) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public FixedWindowRateLimiter(System.Threading.RateLimiting.FixedWindowRateLimiterOptions options) => throw null;
                public override System.Threading.RateLimiting.RateLimiterStatistics GetStatistics() => throw null;
                public override System.TimeSpan? IdleDuration { get => throw null; }
                public override bool IsAutoReplenishing { get => throw null; }
                public override System.TimeSpan ReplenishmentPeriod { get => throw null; }
                public override bool TryReplenish() => throw null;
            }

            public class FixedWindowRateLimiterOptions
            {
                public bool AutoReplenishment { get => throw null; set => throw null; }
                public FixedWindowRateLimiterOptions() => throw null;
                public int PermitLimit { get => throw null; set => throw null; }
                public int QueueLimit { get => throw null; set => throw null; }
                public System.Threading.RateLimiting.QueueProcessingOrder QueueProcessingOrder { get => throw null; set => throw null; }
                public System.TimeSpan Window { get => throw null; set => throw null; }
            }

            public static class MetadataName
            {
                public static System.Threading.RateLimiting.MetadataName<T> Create<T>(string name) => throw null;
                public static System.Threading.RateLimiting.MetadataName<string> ReasonPhrase { get => throw null; }
                public static System.Threading.RateLimiting.MetadataName<System.TimeSpan> RetryAfter { get => throw null; }
            }

            public class MetadataName<T> : System.IEquatable<System.Threading.RateLimiting.MetadataName<T>>
            {
                public static bool operator !=(System.Threading.RateLimiting.MetadataName<T> left, System.Threading.RateLimiting.MetadataName<T> right) => throw null;
                public static bool operator ==(System.Threading.RateLimiting.MetadataName<T> left, System.Threading.RateLimiting.MetadataName<T> right) => throw null;
                public bool Equals(System.Threading.RateLimiting.MetadataName<T> other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public MetadataName(string name) => throw null;
                public string Name { get => throw null; }
                public override string ToString() => throw null;
            }

            public static class PartitionedRateLimiter
            {
                public static System.Threading.RateLimiting.PartitionedRateLimiter<TResource> Create<TResource, TPartitionKey>(System.Func<TResource, System.Threading.RateLimiting.RateLimitPartition<TPartitionKey>> partitioner, System.Collections.Generic.IEqualityComparer<TPartitionKey> equalityComparer = default(System.Collections.Generic.IEqualityComparer<TPartitionKey>)) => throw null;
                public static System.Threading.RateLimiting.PartitionedRateLimiter<TResource> CreateChained<TResource>(params System.Threading.RateLimiting.PartitionedRateLimiter<TResource>[] limiters) => throw null;
            }

            public abstract class PartitionedRateLimiter<TResource> : System.IAsyncDisposable, System.IDisposable
            {
                public System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsync(TResource resource, int permitCount = default(int), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected abstract System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsyncCore(TResource resource, int permitCount, System.Threading.CancellationToken cancellationToken);
                public System.Threading.RateLimiting.RateLimitLease AttemptAcquire(TResource resource, int permitCount = default(int)) => throw null;
                protected abstract System.Threading.RateLimiting.RateLimitLease AttemptAcquireCore(TResource resource, int permitCount);
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected virtual System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public abstract System.Threading.RateLimiting.RateLimiterStatistics GetStatistics(TResource resource);
                protected PartitionedRateLimiter() => throw null;
                public System.Threading.RateLimiting.PartitionedRateLimiter<TOuter> WithTranslatedKey<TOuter>(System.Func<TOuter, TResource> keyAdapter, bool leaveOpen) => throw null;
            }

            public enum QueueProcessingOrder : int
            {
                NewestFirst = 1,
                OldestFirst = 0,
            }

            public abstract class RateLimitLease : System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> GetAllMetadata() => throw null;
                public abstract bool IsAcquired { get; }
                public abstract System.Collections.Generic.IEnumerable<string> MetadataNames { get; }
                protected RateLimitLease() => throw null;
                public abstract bool TryGetMetadata(string metadataName, out object metadata);
                public bool TryGetMetadata<T>(System.Threading.RateLimiting.MetadataName<T> metadataName, out T metadata) => throw null;
            }

            public static class RateLimitPartition
            {
                public static System.Threading.RateLimiting.RateLimitPartition<TKey> Get<TKey>(TKey partitionKey, System.Func<TKey, System.Threading.RateLimiting.RateLimiter> factory) => throw null;
                public static System.Threading.RateLimiting.RateLimitPartition<TKey> GetConcurrencyLimiter<TKey>(TKey partitionKey, System.Func<TKey, System.Threading.RateLimiting.ConcurrencyLimiterOptions> factory) => throw null;
                public static System.Threading.RateLimiting.RateLimitPartition<TKey> GetFixedWindowLimiter<TKey>(TKey partitionKey, System.Func<TKey, System.Threading.RateLimiting.FixedWindowRateLimiterOptions> factory) => throw null;
                public static System.Threading.RateLimiting.RateLimitPartition<TKey> GetNoLimiter<TKey>(TKey partitionKey) => throw null;
                public static System.Threading.RateLimiting.RateLimitPartition<TKey> GetSlidingWindowLimiter<TKey>(TKey partitionKey, System.Func<TKey, System.Threading.RateLimiting.SlidingWindowRateLimiterOptions> factory) => throw null;
                public static System.Threading.RateLimiting.RateLimitPartition<TKey> GetTokenBucketLimiter<TKey>(TKey partitionKey, System.Func<TKey, System.Threading.RateLimiting.TokenBucketRateLimiterOptions> factory) => throw null;
            }

            public struct RateLimitPartition<TKey>
            {
                public System.Func<TKey, System.Threading.RateLimiting.RateLimiter> Factory { get => throw null; }
                public TKey PartitionKey { get => throw null; }
                // Stub generator skipped constructor 
                public RateLimitPartition(TKey partitionKey, System.Func<TKey, System.Threading.RateLimiting.RateLimiter> factory) => throw null;
            }

            public abstract class RateLimiter : System.IAsyncDisposable, System.IDisposable
            {
                public System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsync(int permitCount = default(int), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected abstract System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsyncCore(int permitCount, System.Threading.CancellationToken cancellationToken);
                public System.Threading.RateLimiting.RateLimitLease AttemptAcquire(int permitCount = default(int)) => throw null;
                protected abstract System.Threading.RateLimiting.RateLimitLease AttemptAcquireCore(int permitCount);
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected virtual System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public abstract System.Threading.RateLimiting.RateLimiterStatistics GetStatistics();
                public abstract System.TimeSpan? IdleDuration { get; }
                protected RateLimiter() => throw null;
            }

            public class RateLimiterStatistics
            {
                public System.Int64 CurrentAvailablePermits { get => throw null; set => throw null; }
                public System.Int64 CurrentQueuedCount { get => throw null; set => throw null; }
                public RateLimiterStatistics() => throw null;
                public System.Int64 TotalFailedLeases { get => throw null; set => throw null; }
                public System.Int64 TotalSuccessfulLeases { get => throw null; set => throw null; }
            }

            public abstract class ReplenishingRateLimiter : System.Threading.RateLimiting.RateLimiter
            {
                public abstract bool IsAutoReplenishing { get; }
                protected ReplenishingRateLimiter() => throw null;
                public abstract System.TimeSpan ReplenishmentPeriod { get; }
                public abstract bool TryReplenish();
            }

            public class SlidingWindowRateLimiter : System.Threading.RateLimiting.ReplenishingRateLimiter
            {
                protected override System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsyncCore(int permitCount, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Threading.RateLimiting.RateLimitLease AttemptAcquireCore(int permitCount) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public override System.Threading.RateLimiting.RateLimiterStatistics GetStatistics() => throw null;
                public override System.TimeSpan? IdleDuration { get => throw null; }
                public override bool IsAutoReplenishing { get => throw null; }
                public override System.TimeSpan ReplenishmentPeriod { get => throw null; }
                public SlidingWindowRateLimiter(System.Threading.RateLimiting.SlidingWindowRateLimiterOptions options) => throw null;
                public override bool TryReplenish() => throw null;
            }

            public class SlidingWindowRateLimiterOptions
            {
                public bool AutoReplenishment { get => throw null; set => throw null; }
                public int PermitLimit { get => throw null; set => throw null; }
                public int QueueLimit { get => throw null; set => throw null; }
                public System.Threading.RateLimiting.QueueProcessingOrder QueueProcessingOrder { get => throw null; set => throw null; }
                public int SegmentsPerWindow { get => throw null; set => throw null; }
                public SlidingWindowRateLimiterOptions() => throw null;
                public System.TimeSpan Window { get => throw null; set => throw null; }
            }

            public class TokenBucketRateLimiter : System.Threading.RateLimiting.ReplenishingRateLimiter
            {
                protected override System.Threading.Tasks.ValueTask<System.Threading.RateLimiting.RateLimitLease> AcquireAsyncCore(int tokenCount, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected override System.Threading.RateLimiting.RateLimitLease AttemptAcquireCore(int tokenCount) => throw null;
                protected override void Dispose(bool disposing) => throw null;
                protected override System.Threading.Tasks.ValueTask DisposeAsyncCore() => throw null;
                public override System.Threading.RateLimiting.RateLimiterStatistics GetStatistics() => throw null;
                public override System.TimeSpan? IdleDuration { get => throw null; }
                public override bool IsAutoReplenishing { get => throw null; }
                public override System.TimeSpan ReplenishmentPeriod { get => throw null; }
                public TokenBucketRateLimiter(System.Threading.RateLimiting.TokenBucketRateLimiterOptions options) => throw null;
                public override bool TryReplenish() => throw null;
            }

            public class TokenBucketRateLimiterOptions
            {
                public bool AutoReplenishment { get => throw null; set => throw null; }
                public int QueueLimit { get => throw null; set => throw null; }
                public System.Threading.RateLimiting.QueueProcessingOrder QueueProcessingOrder { get => throw null; set => throw null; }
                public System.TimeSpan ReplenishmentPeriod { get => throw null; set => throw null; }
                public TokenBucketRateLimiterOptions() => throw null;
                public int TokenLimit { get => throw null; set => throw null; }
                public int TokensPerPeriod { get => throw null; set => throw null; }
            }

        }
    }
}
