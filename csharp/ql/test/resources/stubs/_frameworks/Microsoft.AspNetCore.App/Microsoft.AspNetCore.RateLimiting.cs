// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.RateLimiting, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class RateLimiterApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRateLimiter(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRateLimiter(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.RateLimiting.RateLimiterOptions options) => throw null;
            }
            public static partial class RateLimiterEndpointConventionBuilderExtensions
            {
                public static TBuilder DisableRateLimiting<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireRateLimiting<TBuilder>(this TBuilder builder, string policyName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireRateLimiting<TBuilder, TPartitionKey>(this TBuilder builder, Microsoft.AspNetCore.RateLimiting.IRateLimiterPolicy<TPartitionKey> policy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }
            public static partial class RateLimiterServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRateLimiter(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.RateLimiting.RateLimiterOptions> configureOptions) => throw null;
            }
        }
        namespace RateLimiting
        {
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public sealed class DisableRateLimitingAttribute : System.Attribute
            {
                public DisableRateLimitingAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public sealed class EnableRateLimitingAttribute : System.Attribute
            {
                public EnableRateLimitingAttribute(string policyName) => throw null;
                public string PolicyName { get => throw null; }
            }
            public interface IRateLimiterPolicy<TPartitionKey>
            {
                System.Threading.RateLimiting.RateLimitPartition<TPartitionKey> GetPartition(Microsoft.AspNetCore.Http.HttpContext httpContext);
                System.Func<Microsoft.AspNetCore.RateLimiting.OnRejectedContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> OnRejected { get; }
            }
            public sealed class OnRejectedContext
            {
                public OnRejectedContext() => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set { } }
                public System.Threading.RateLimiting.RateLimitLease Lease { get => throw null; set { } }
            }
            public sealed class RateLimiterOptions
            {
                public Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddPolicy<TPartitionKey>(string policyName, System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Threading.RateLimiting.RateLimitPartition<TPartitionKey>> partitioner) => throw null;
                public Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddPolicy<TPartitionKey, TPolicy>(string policyName) where TPolicy : Microsoft.AspNetCore.RateLimiting.IRateLimiterPolicy<TPartitionKey> => throw null;
                public Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddPolicy<TPartitionKey>(string policyName, Microsoft.AspNetCore.RateLimiting.IRateLimiterPolicy<TPartitionKey> policy) => throw null;
                public RateLimiterOptions() => throw null;
                public System.Threading.RateLimiting.PartitionedRateLimiter<Microsoft.AspNetCore.Http.HttpContext> GlobalLimiter { get => throw null; set { } }
                public System.Func<Microsoft.AspNetCore.RateLimiting.OnRejectedContext, System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> OnRejected { get => throw null; set { } }
                public int RejectionStatusCode { get => throw null; set { } }
            }
            public static partial class RateLimiterOptionsExtensions
            {
                public static Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddConcurrencyLimiter(this Microsoft.AspNetCore.RateLimiting.RateLimiterOptions options, string policyName, System.Action<System.Threading.RateLimiting.ConcurrencyLimiterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddFixedWindowLimiter(this Microsoft.AspNetCore.RateLimiting.RateLimiterOptions options, string policyName, System.Action<System.Threading.RateLimiting.FixedWindowRateLimiterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddSlidingWindowLimiter(this Microsoft.AspNetCore.RateLimiting.RateLimiterOptions options, string policyName, System.Action<System.Threading.RateLimiting.SlidingWindowRateLimiterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.RateLimiting.RateLimiterOptions AddTokenBucketLimiter(this Microsoft.AspNetCore.RateLimiting.RateLimiterOptions options, string policyName, System.Action<System.Threading.RateLimiting.TokenBucketRateLimiterOptions> configureOptions) => throw null;
            }
        }
    }
}
