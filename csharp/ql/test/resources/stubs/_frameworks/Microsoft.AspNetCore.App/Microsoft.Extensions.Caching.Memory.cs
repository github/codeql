// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Caching.Memory, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Caching
        {
            namespace Distributed
            {
                public class MemoryDistributedCache : Microsoft.Extensions.Caching.Distributed.IDistributedCache
                {
                    public MemoryDistributedCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions> optionsAccessor) => throw null;
                    public MemoryDistributedCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions> optionsAccessor, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public byte[] Get(string key) => throw null;
                    public System.Threading.Tasks.Task<byte[]> GetAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public void Refresh(string key) => throw null;
                    public System.Threading.Tasks.Task RefreshAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public void Remove(string key) => throw null;
                    public System.Threading.Tasks.Task RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public void Set(string key, byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options) => throw null;
                    public System.Threading.Tasks.Task SetAsync(string key, byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                }
            }
            namespace Memory
            {
                public class MemoryCache : System.IDisposable, Microsoft.Extensions.Caching.Memory.IMemoryCache
                {
                    public void Clear() => throw null;
                    public void Compact(double percentage) => throw null;
                    public int Count { get => throw null; }
                    public Microsoft.Extensions.Caching.Memory.ICacheEntry CreateEntry(object key) => throw null;
                    public MemoryCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> optionsAccessor) => throw null;
                    public MemoryCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> optionsAccessor, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public Microsoft.Extensions.Caching.Memory.MemoryCacheStatistics GetCurrentStatistics() => throw null;
                    public void Remove(object key) => throw null;
                    public bool TryGetValue(object key, out object result) => throw null;
                }
                public class MemoryCacheOptions : Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions>
                {
                    public Microsoft.Extensions.Internal.ISystemClock Clock { get => throw null; set { } }
                    public double CompactionPercentage { get => throw null; set { } }
                    public bool CompactOnMemoryPressure { get => throw null; set { } }
                    public MemoryCacheOptions() => throw null;
                    public System.TimeSpan ExpirationScanFrequency { get => throw null; set { } }
                    public long? SizeLimit { get => throw null; set { } }
                    public bool TrackLinkedCacheEntries { get => throw null; set { } }
                    public bool TrackStatistics { get => throw null; set { } }
                    Microsoft.Extensions.Caching.Memory.MemoryCacheOptions Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions>.Value { get => throw null; }
                }
                public class MemoryDistributedCacheOptions : Microsoft.Extensions.Caching.Memory.MemoryCacheOptions
                {
                    public MemoryDistributedCacheOptions() => throw null;
                }
            }
        }
        namespace DependencyInjection
        {
            public static partial class MemoryCacheServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddDistributedMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddDistributedMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> setupAction) => throw null;
            }
        }
    }
}
