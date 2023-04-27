// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.OutputCaching, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static class OutputCacheApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseOutputCache(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

        }
        namespace OutputCaching
        {
            public class CacheVaryByRules
            {
                public string CacheKeyPrefix { get => throw null; set => throw null; }
                public CacheVaryByRules() => throw null;
                public Microsoft.Extensions.Primitives.StringValues HeaderNames { get => throw null; set => throw null; }
                public Microsoft.Extensions.Primitives.StringValues QueryKeys { get => throw null; set => throw null; }
                public Microsoft.Extensions.Primitives.StringValues RouteValueNames { get => throw null; set => throw null; }
                public bool VaryByHost { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, string> VaryByValues { get => throw null; }
            }

            public interface IOutputCacheFeature
            {
                Microsoft.AspNetCore.OutputCaching.OutputCacheContext Context { get; }
            }

            public interface IOutputCachePolicy
            {
                System.Threading.Tasks.ValueTask CacheRequestAsync(Microsoft.AspNetCore.OutputCaching.OutputCacheContext context, System.Threading.CancellationToken cancellation);
                System.Threading.Tasks.ValueTask ServeFromCacheAsync(Microsoft.AspNetCore.OutputCaching.OutputCacheContext context, System.Threading.CancellationToken cancellation);
                System.Threading.Tasks.ValueTask ServeResponseAsync(Microsoft.AspNetCore.OutputCaching.OutputCacheContext context, System.Threading.CancellationToken cancellation);
            }

            public interface IOutputCacheStore
            {
                System.Threading.Tasks.ValueTask EvictByTagAsync(string tag, System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.ValueTask<System.Byte[]> GetAsync(string key, System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.ValueTask SetAsync(string key, System.Byte[] value, string[] tags, System.TimeSpan validFor, System.Threading.CancellationToken cancellationToken);
            }

            public class OutputCacheAttribute : System.Attribute
            {
                public int Duration { get => throw null; set => throw null; }
                public bool NoStore { get => throw null; set => throw null; }
                public OutputCacheAttribute() => throw null;
                public string PolicyName { get => throw null; set => throw null; }
                public string[] VaryByHeaderNames { get => throw null; set => throw null; }
                public string[] VaryByQueryKeys { get => throw null; set => throw null; }
                public string[] VaryByRouteValueNames { get => throw null; set => throw null; }
            }

            public class OutputCacheContext
            {
                public bool AllowCacheLookup { get => throw null; set => throw null; }
                public bool AllowCacheStorage { get => throw null; set => throw null; }
                public bool AllowLocking { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.OutputCaching.CacheVaryByRules CacheVaryByRules { get => throw null; }
                public bool EnableOutputCaching { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set => throw null; }
                public OutputCacheContext() => throw null;
                public System.TimeSpan? ResponseExpirationTimeSpan { get => throw null; set => throw null; }
                public System.DateTimeOffset? ResponseTime { get => throw null; set => throw null; }
                public System.Collections.Generic.HashSet<string> Tags { get => throw null; }
            }

            public class OutputCacheOptions
            {
                public void AddBasePolicy(System.Action<Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder> build) => throw null;
                public void AddBasePolicy(System.Action<Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder> build, bool excludeDefaultPolicy) => throw null;
                public void AddBasePolicy(Microsoft.AspNetCore.OutputCaching.IOutputCachePolicy policy) => throw null;
                public void AddPolicy(string name, System.Action<Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder> build) => throw null;
                public void AddPolicy(string name, System.Action<Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder> build, bool excludeDefaultPolicy) => throw null;
                public void AddPolicy(string name, Microsoft.AspNetCore.OutputCaching.IOutputCachePolicy policy) => throw null;
                public System.IServiceProvider ApplicationServices { get => throw null; set => throw null; }
                public System.TimeSpan DefaultExpirationTimeSpan { get => throw null; set => throw null; }
                public System.Int64 MaximumBodySize { get => throw null; set => throw null; }
                public OutputCacheOptions() => throw null;
                public System.Int64 SizeLimit { get => throw null; set => throw null; }
                public bool UseCaseSensitivePaths { get => throw null; set => throw null; }
            }

            public class OutputCachePolicyBuilder
            {
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder AddPolicy(System.Type policyType) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder AddPolicy<T>() where T : Microsoft.AspNetCore.OutputCaching.IOutputCachePolicy => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder Cache() => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder Expire(System.TimeSpan expiration) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder NoCache() => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetCacheKeyPrefix(System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<string>> keyPrefix) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetCacheKeyPrefix(System.Func<Microsoft.AspNetCore.Http.HttpContext, string> keyPrefix) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetCacheKeyPrefix(string keyPrefix) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetLocking(bool enabled) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByHeader(string[] headerNames) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByHeader(string headerName, params string[] headerNames) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByHost(bool enabled) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByQuery(string[] queryKeys) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByQuery(string queryKey, params string[] queryKeys) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByRouteValue(string[] routeValueNames) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder SetVaryByRouteValue(string routeValueName, params string[] routeValueNames) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder Tag(params string[] tags) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder VaryByValue(System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Collections.Generic.KeyValuePair<string, string>>> varyBy) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder VaryByValue(System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Collections.Generic.KeyValuePair<string, string>> varyBy) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder VaryByValue(string key, string value) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder With(System.Func<Microsoft.AspNetCore.OutputCaching.OutputCacheContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<bool>> predicate) => throw null;
                public Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder With(System.Func<Microsoft.AspNetCore.OutputCaching.OutputCacheContext, bool> predicate) => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class OutputCacheConventionBuilderExtensions
            {
                public static TBuilder CacheOutput<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder CacheOutput<TBuilder>(this TBuilder builder, System.Action<Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder> policy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder CacheOutput<TBuilder>(this TBuilder builder, System.Action<Microsoft.AspNetCore.OutputCaching.OutputCachePolicyBuilder> policy, bool excludeDefaultPolicy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder CacheOutput<TBuilder>(this TBuilder builder, Microsoft.AspNetCore.OutputCaching.IOutputCachePolicy policy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder CacheOutput<TBuilder>(this TBuilder builder, string policyName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }

            public static class OutputCacheServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddOutputCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddOutputCache(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.OutputCaching.OutputCacheOptions> configureOptions) => throw null;
            }

        }
    }
}
