// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Caching
        {
            namespace Distributed
            {
                // Generated from `Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryExtensions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class DistributedCacheEntryExtensions
                {
                    public static Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions SetAbsoluteExpiration(this Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.TimeSpan relative) => throw null;
                    public static Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions SetAbsoluteExpiration(this Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.DateTimeOffset absolute) => throw null;
                    public static Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions SetSlidingExpiration(this Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.TimeSpan offset) => throw null;
                }

                // Generated from `Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DistributedCacheEntryOptions
                {
                    public System.DateTimeOffset? AbsoluteExpiration { get => throw null; set => throw null; }
                    public System.TimeSpan? AbsoluteExpirationRelativeToNow { get => throw null; set => throw null; }
                    public DistributedCacheEntryOptions() => throw null;
                    public System.TimeSpan? SlidingExpiration { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Extensions.Caching.Distributed.DistributedCacheExtensions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class DistributedCacheExtensions
                {
                    public static string GetString(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key) => throw null;
                    public static System.Threading.Tasks.Task<string> GetStringAsync(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public static void Set(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, System.Byte[] value) => throw null;
                    public static System.Threading.Tasks.Task SetAsync(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public static void SetString(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, string value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options) => throw null;
                    public static void SetString(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, string value) => throw null;
                    public static System.Threading.Tasks.Task SetStringAsync(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                    public static System.Threading.Tasks.Task SetStringAsync(this Microsoft.Extensions.Caching.Distributed.IDistributedCache cache, string key, string value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
                }

                // Generated from `Microsoft.Extensions.Caching.Distributed.IDistributedCache` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IDistributedCache
                {
                    System.Byte[] Get(string key);
                    System.Threading.Tasks.Task<System.Byte[]> GetAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                    void Refresh(string key);
                    System.Threading.Tasks.Task RefreshAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                    void Remove(string key);
                    System.Threading.Tasks.Task RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                    void Set(string key, System.Byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options);
                    System.Threading.Tasks.Task SetAsync(string key, System.Byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                }

            }
            namespace Memory
            {
                // Generated from `Microsoft.Extensions.Caching.Memory.CacheEntryExtensions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class CacheEntryExtensions
                {
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry AddExpirationToken(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, Microsoft.Extensions.Primitives.IChangeToken expirationToken) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry RegisterPostEvictionCallback(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, Microsoft.Extensions.Caching.Memory.PostEvictionDelegate callback, object state) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry RegisterPostEvictionCallback(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, Microsoft.Extensions.Caching.Memory.PostEvictionDelegate callback) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetAbsoluteExpiration(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, System.TimeSpan relative) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetAbsoluteExpiration(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, System.DateTimeOffset absolute) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetOptions(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetPriority(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, Microsoft.Extensions.Caching.Memory.CacheItemPriority priority) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetSize(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, System.Int64 size) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetSlidingExpiration(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, System.TimeSpan offset) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.ICacheEntry SetValue(this Microsoft.Extensions.Caching.Memory.ICacheEntry entry, object value) => throw null;
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.CacheExtensions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class CacheExtensions
                {
                    public static object Get(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key) => throw null;
                    public static TItem Get<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key) => throw null;
                    public static TItem GetOrCreate<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, System.Func<Microsoft.Extensions.Caching.Memory.ICacheEntry, TItem> factory) => throw null;
                    public static System.Threading.Tasks.Task<TItem> GetOrCreateAsync<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, System.Func<Microsoft.Extensions.Caching.Memory.ICacheEntry, System.Threading.Tasks.Task<TItem>> factory) => throw null;
                    public static TItem Set<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, TItem value, System.TimeSpan absoluteExpirationRelativeToNow) => throw null;
                    public static TItem Set<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, TItem value, System.DateTimeOffset absoluteExpiration) => throw null;
                    public static TItem Set<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, TItem value, Microsoft.Extensions.Primitives.IChangeToken expirationToken) => throw null;
                    public static TItem Set<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, TItem value, Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options) => throw null;
                    public static TItem Set<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, TItem value) => throw null;
                    public static bool TryGetValue<TItem>(this Microsoft.Extensions.Caching.Memory.IMemoryCache cache, object key, out TItem value) => throw null;
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.CacheItemPriority` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum CacheItemPriority
                {
                    High,
                    Low,
                    NeverRemove,
                    Normal,
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.EvictionReason` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum EvictionReason
                {
                    Capacity,
                    Expired,
                    None,
                    Removed,
                    Replaced,
                    TokenExpired,
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.ICacheEntry` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICacheEntry : System.IDisposable
                {
                    System.DateTimeOffset? AbsoluteExpiration { get; set; }
                    System.TimeSpan? AbsoluteExpirationRelativeToNow { get; set; }
                    System.Collections.Generic.IList<Microsoft.Extensions.Primitives.IChangeToken> ExpirationTokens { get; }
                    object Key { get; }
                    System.Collections.Generic.IList<Microsoft.Extensions.Caching.Memory.PostEvictionCallbackRegistration> PostEvictionCallbacks { get; }
                    Microsoft.Extensions.Caching.Memory.CacheItemPriority Priority { get; set; }
                    System.Int64? Size { get; set; }
                    System.TimeSpan? SlidingExpiration { get; set; }
                    object Value { get; set; }
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.IMemoryCache` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IMemoryCache : System.IDisposable
                {
                    Microsoft.Extensions.Caching.Memory.ICacheEntry CreateEntry(object key);
                    void Remove(object key);
                    bool TryGetValue(object key, out object value);
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.MemoryCacheEntryExtensions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class MemoryCacheEntryExtensions
                {
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions AddExpirationToken(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, Microsoft.Extensions.Primitives.IChangeToken expirationToken) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions RegisterPostEvictionCallback(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, Microsoft.Extensions.Caching.Memory.PostEvictionDelegate callback, object state) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions RegisterPostEvictionCallback(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, Microsoft.Extensions.Caching.Memory.PostEvictionDelegate callback) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions SetAbsoluteExpiration(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, System.TimeSpan relative) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions SetAbsoluteExpiration(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, System.DateTimeOffset absolute) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions SetPriority(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, Microsoft.Extensions.Caching.Memory.CacheItemPriority priority) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions SetSize(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, System.Int64 size) => throw null;
                    public static Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions SetSlidingExpiration(this Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions options, System.TimeSpan offset) => throw null;
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.MemoryCacheEntryOptions` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryCacheEntryOptions
                {
                    public System.DateTimeOffset? AbsoluteExpiration { get => throw null; set => throw null; }
                    public System.TimeSpan? AbsoluteExpirationRelativeToNow { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.Extensions.Primitives.IChangeToken> ExpirationTokens { get => throw null; }
                    public MemoryCacheEntryOptions() => throw null;
                    public System.Collections.Generic.IList<Microsoft.Extensions.Caching.Memory.PostEvictionCallbackRegistration> PostEvictionCallbacks { get => throw null; }
                    public Microsoft.Extensions.Caching.Memory.CacheItemPriority Priority { get => throw null; set => throw null; }
                    public System.Int64? Size { get => throw null; set => throw null; }
                    public System.TimeSpan? SlidingExpiration { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.PostEvictionCallbackRegistration` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PostEvictionCallbackRegistration
                {
                    public Microsoft.Extensions.Caching.Memory.PostEvictionDelegate EvictionCallback { get => throw null; set => throw null; }
                    public PostEvictionCallbackRegistration() => throw null;
                    public object State { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.Extensions.Caching.Memory.PostEvictionDelegate` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate void PostEvictionDelegate(object key, object value, Microsoft.Extensions.Caching.Memory.EvictionReason reason, object state);

            }
        }
        namespace Internal
        {
            // Generated from `Microsoft.Extensions.Internal.ISystemClock` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISystemClock
            {
                System.DateTimeOffset UtcNow { get; }
            }

            // Generated from `Microsoft.Extensions.Internal.SystemClock` in `Microsoft.Extensions.Caching.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SystemClock : Microsoft.Extensions.Internal.ISystemClock
            {
                public SystemClock() => throw null;
                public System.DateTimeOffset UtcNow { get => throw null; }
            }

        }
    }
}
