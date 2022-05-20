// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Caching
        {
            namespace Distributed
            {
                // Generated from `Microsoft.Extensions.Caching.Distributed.MemoryDistributedCache` in `Microsoft.Extensions.Caching.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryDistributedCache : Microsoft.Extensions.Caching.Distributed.IDistributedCache
                {
                    public System.Byte[] Get(string key) => throw null;
                    public System.Threading.Tasks.Task<System.Byte[]> GetAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public MemoryDistributedCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions> optionsAccessor, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public MemoryDistributedCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions> optionsAccessor) => throw null;
                    public void Refresh(string key) => throw null;
                    public System.Threading.Tasks.Task RefreshAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public void Remove(string key) => throw null;
                    public System.Threading.Tasks.Task RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public void Set(string key, System.Byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options) => throw null;
                    public System.Threading.Tasks.Task SetAsync(string key, System.Byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                }

            }
            namespace Memory
            {
                // Generated from `Microsoft.Extensions.Caching.Memory.MemoryCache` in `Microsoft.Extensions.Caching.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryCache : System.IDisposable, Microsoft.Extensions.Caching.Memory.IMemoryCache
                {
                    public void Compact(double percentage) => throw null;
                    public int Count { get => throw null; }
                    public Microsoft.Extensions.Caching.Memory.ICacheEntry CreateEntry(object key) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public MemoryCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> optionsAccessor, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public MemoryCache(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> optionsAccessor) => throw null;
                    public void Remove(object key) => throw null;
                    public bool TryGetValue(object key, out object result) => throw null;
                    // ERR: Stub generator didn't handle member: ~MemoryCache
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.MemoryCacheOptions` in `Microsoft.Extensions.Caching.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryCacheOptions : Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions>
                {
                    public Microsoft.Extensions.Internal.ISystemClock Clock { get => throw null; set => throw null; }
                    public double CompactionPercentage { get => throw null; set => throw null; }
                    public System.TimeSpan ExpirationScanFrequency { get => throw null; set => throw null; }
                    public MemoryCacheOptions() => throw null;
                    public System.Int64? SizeLimit { get => throw null; set => throw null; }
                    Microsoft.Extensions.Caching.Memory.MemoryCacheOptions Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions>.Value { get => throw null; }
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions` in `Microsoft.Extensions.Caching.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryDistributedCacheOptions : Microsoft.Extensions.Caching.Memory.MemoryCacheOptions
                {
                    public MemoryDistributedCacheOptions() => throw null;
                }

            }
        }
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.MemoryCacheServiceCollectionExtensions` in `Microsoft.Extensions.Caching.Memory, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MemoryCacheServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddDistributedMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Caching.Memory.MemoryDistributedCacheOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddDistributedMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddMemoryCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
