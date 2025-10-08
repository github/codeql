// This file contains auto-generated code.
// Generated from `Microsoft.Identity.ServiceEssentials.Caching, Version=1.19.6.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace Identity
    {
        namespace ServiceEssentials
        {
            namespace Caching
            {
                public enum CacheMetric
                {
                    Hit = 0,
                    Miss = 1,
                    Expired = 2,
                    Prefetch = 3,
                    Set = 4,
                    Remove = 5,
                    Fresh = 6,
                    Stale = 7,
                    EncryptionFailed = 8,
                    SerializationFailed = 9,
                    DecryptionFailed = 10,
                    DeserializationFailed = 11,
                    Timeout = 12,
                    CacheUnavailable = 13,
                }
                public class CacheSerializationProvider : Microsoft.Identity.ServiceEssentials.Caching.ICacheSerializationProvider
                {
                    public CacheSerializationProvider() => throw null;
                    public Microsoft.Identity.ServiceEssentials.CacheItem<TData> Deserialize<TData>(byte[] serializedValue) where TData : new() => throw null;
                    public byte[] Serialize<TData>(Microsoft.Identity.ServiceEssentials.CacheItem<TData> input) where TData : new() => throw null;
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                }
                public interface ICacheEncryptionProvider
                {
                    byte[] Decrypt(byte[] encryptedData);
                    byte[] Encrypt(byte[] data);
                }
                public interface ICacheSerializationProvider
                {
                    Microsoft.Identity.ServiceEssentials.CacheItem<TData> Deserialize<TData>(byte[] serializedValue) where TData : new();
                    byte[] Serialize<TData>(Microsoft.Identity.ServiceEssentials.CacheItem<TData> input) where TData : new();
                }
                public interface ICacheTelemetryClient
                {
                    void LogMetric(Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.Caching.CacheMetric metric, long value, string cacheSource);
                }
                public class MiseCache : Microsoft.Identity.ServiceEssentials.IMiseCache, Microsoft.Identity.ServiceEssentials.IMiseComponent, Microsoft.Identity.ServiceEssentials.IMultiLevelCacheSupport
                {
                    public Microsoft.Identity.ServiceEssentials.Caching.ICacheTelemetryClient CacheTelemetryClient { get => throw null; set { } }
                    public MiseCache(Microsoft.Extensions.Caching.Memory.IMemoryCache memoryCache) => throw null;
                    public MiseCache(Microsoft.Extensions.Caching.Memory.IMemoryCache memoryCache, Microsoft.Extensions.Caching.Distributed.IDistributedCache distributedCache, Microsoft.Identity.ServiceEssentials.Caching.ICacheSerializationProvider serializationProvider, Microsoft.Identity.ServiceEssentials.Caching.ICacheEncryptionProvider encryptionProvider, Microsoft.Identity.ServiceEssentials.Caching.ICacheTelemetryClient cacheTelemetryClient) => throw null;
                    public MiseCache(Microsoft.Extensions.Caching.Memory.IMemoryCache memoryCache, Microsoft.Extensions.Caching.Distributed.IDistributedCache distributedCache, Microsoft.Identity.ServiceEssentials.Caching.ICacheSerializationProvider serializationProvider, Microsoft.Identity.ServiceEssentials.Caching.ICacheEncryptionProvider encryptionProvider) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> GetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, string key, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new() => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.CacheItem<TData>>> GetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IReadOnlyCollection<string> keys, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new() => throw null;
                    public bool IsMultiLevelCachingEnabled() => throw null;
                    public string Name { get => throw null; set { } }
                    public System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, string key, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IReadOnlyCollection<string> keys, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public System.Threading.Tasks.Task SetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.CacheItem<TData> cacheItem, Microsoft.Identity.ServiceEssentials.SetCause cause = default(Microsoft.Identity.ServiceEssentials.SetCause), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new() => throw null;
                    public System.Threading.Tasks.Task SetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> cacheItems, Microsoft.Identity.ServiceEssentials.SetCause cause = default(Microsoft.Identity.ServiceEssentials.SetCause), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new() => throw null;
                }
                public class NullCacheTelemetryClient : Microsoft.Identity.ServiceEssentials.Caching.ICacheTelemetryClient
                {
                    public NullCacheTelemetryClient() => throw null;
                    public void LogMetric(Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.Caching.CacheMetric metric, long value, string cacheSource) => throw null;
                }
            }
            public static partial class MiseAuthenticationBuilderCachingExtensions
            {
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithInMemoryMiseCache(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, System.Action<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> memoryCacheOptions = default(System.Action<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions>)) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithMultilevelMiseCache(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.Caching.ICacheEncryptionProvider cacheEncryptionProvider, System.Action<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions> memoryCacheOptions = default(System.Action<Microsoft.Extensions.Caching.Memory.MemoryCacheOptions>), Microsoft.Identity.ServiceEssentials.Caching.ICacheSerializationProvider cacheSerializationProvider = default(Microsoft.Identity.ServiceEssentials.Caching.ICacheSerializationProvider), Microsoft.Identity.ServiceEssentials.Caching.ICacheTelemetryClient cacheTelemetryClient = default(Microsoft.Identity.ServiceEssentials.Caching.ICacheTelemetryClient), bool verifyDistributedCacheIsRegistered = default(bool)) => throw null;
            }
            public static class MiseCacheEventIds
            {
                public const string DecryptionFailed = default;
                public const string DeserializationFailed = default;
                public const string EncryptionFailed = default;
                public const string SerializationFailed = default;
            }
        }
    }
}
