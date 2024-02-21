// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Cors, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class CorsEndpointConventionBuilderExtensions
            {
                public static TBuilder RequireCors<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireCors<TBuilder>(this TBuilder builder, string policyName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireCors<TBuilder>(this TBuilder builder, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder> configurePolicy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }
            public static partial class CorsMiddlewareExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCors(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCors(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string policyName) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCors(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder> configurePolicy) => throw null;
            }
        }
        namespace Cors
        {
            public class CorsPolicyMetadata : Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata, Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyMetadata
            {
                public CorsPolicyMetadata(Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy) => throw null;
                public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy Policy { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = false)]
            public class DisableCorsAttribute : System.Attribute, Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata, Microsoft.AspNetCore.Cors.Infrastructure.IDisableCorsAttribute
            {
                public DisableCorsAttribute() => throw null;
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class EnableCorsAttribute : System.Attribute, Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata, Microsoft.AspNetCore.Cors.Infrastructure.IEnableCorsAttribute
            {
                public EnableCorsAttribute() => throw null;
                public EnableCorsAttribute(string policyName) => throw null;
                public string PolicyName { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            namespace Infrastructure
            {
                public static class CorsConstants
                {
                    public static readonly string AccessControlAllowCredentials;
                    public static readonly string AccessControlAllowHeaders;
                    public static readonly string AccessControlAllowMethods;
                    public static readonly string AccessControlAllowOrigin;
                    public static readonly string AccessControlExposeHeaders;
                    public static readonly string AccessControlMaxAge;
                    public static readonly string AccessControlRequestHeaders;
                    public static readonly string AccessControlRequestMethod;
                    public static readonly string AnyOrigin;
                    public static readonly string Origin;
                    public static readonly string PreflightHttpMethod;
                }
                public class CorsMiddleware
                {
                    public CorsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public CorsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, string policyName) => throw null;
                    public CorsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyProvider corsPolicyProvider) => throw null;
                }
                public class CorsOptions
                {
                    public void AddDefaultPolicy(Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy) => throw null;
                    public void AddDefaultPolicy(System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder> configurePolicy) => throw null;
                    public void AddPolicy(string name, Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy) => throw null;
                    public void AddPolicy(string name, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder> configurePolicy) => throw null;
                    public CorsOptions() => throw null;
                    public string DefaultPolicyName { get => throw null; set { } }
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy GetPolicy(string name) => throw null;
                }
                public class CorsPolicy
                {
                    public bool AllowAnyHeader { get => throw null; }
                    public bool AllowAnyMethod { get => throw null; }
                    public bool AllowAnyOrigin { get => throw null; }
                    public CorsPolicy() => throw null;
                    public System.Collections.Generic.IList<string> ExposedHeaders { get => throw null; }
                    public System.Collections.Generic.IList<string> Headers { get => throw null; }
                    public System.Func<string, bool> IsOriginAllowed { get => throw null; set { } }
                    public System.Collections.Generic.IList<string> Methods { get => throw null; }
                    public System.Collections.Generic.IList<string> Origins { get => throw null; }
                    public System.TimeSpan? PreflightMaxAge { get => throw null; set { } }
                    public bool SupportsCredentials { get => throw null; set { } }
                    public override string ToString() => throw null;
                }
                public class CorsPolicyBuilder
                {
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder AllowAnyHeader() => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder AllowAnyMethod() => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder AllowAnyOrigin() => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder AllowCredentials() => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy Build() => throw null;
                    public CorsPolicyBuilder(params string[] origins) => throw null;
                    public CorsPolicyBuilder(Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder DisallowCredentials() => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder SetIsOriginAllowed(System.Func<string, bool> isOriginAllowed) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder SetIsOriginAllowedToAllowWildcardSubdomains() => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder SetPreflightMaxAge(System.TimeSpan preflightMaxAge) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder WithExposedHeaders(params string[] exposedHeaders) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder WithHeaders(params string[] headers) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder WithMethods(params string[] methods) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicyBuilder WithOrigins(params string[] origins) => throw null;
                }
                public class CorsResult
                {
                    public System.Collections.Generic.IList<string> AllowedExposedHeaders { get => throw null; }
                    public System.Collections.Generic.IList<string> AllowedHeaders { get => throw null; }
                    public System.Collections.Generic.IList<string> AllowedMethods { get => throw null; }
                    public string AllowedOrigin { get => throw null; set { } }
                    public CorsResult() => throw null;
                    public bool IsOriginAllowed { get => throw null; set { } }
                    public bool IsPreflightRequest { get => throw null; set { } }
                    public System.TimeSpan? PreflightMaxAge { get => throw null; set { } }
                    public bool SupportsCredentials { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public bool VaryByOrigin { get => throw null; set { } }
                }
                public class CorsService : Microsoft.AspNetCore.Cors.Infrastructure.ICorsService
                {
                    public virtual void ApplyResult(Microsoft.AspNetCore.Cors.Infrastructure.CorsResult result, Microsoft.AspNetCore.Http.HttpResponse response) => throw null;
                    public CorsService(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsResult EvaluatePolicy(Microsoft.AspNetCore.Http.HttpContext context, string policyName) => throw null;
                    public Microsoft.AspNetCore.Cors.Infrastructure.CorsResult EvaluatePolicy(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy) => throw null;
                    public virtual void EvaluatePreflightRequest(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy, Microsoft.AspNetCore.Cors.Infrastructure.CorsResult result) => throw null;
                    public virtual void EvaluateRequest(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy, Microsoft.AspNetCore.Cors.Infrastructure.CorsResult result) => throw null;
                }
                public class DefaultCorsPolicyProvider : Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyProvider
                {
                    public DefaultCorsPolicyProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> options) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy> GetPolicyAsync(Microsoft.AspNetCore.Http.HttpContext context, string policyName) => throw null;
                }
                public interface ICorsPolicyMetadata : Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata
                {
                    Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy Policy { get; }
                }
                public interface ICorsPolicyProvider
                {
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy> GetPolicyAsync(Microsoft.AspNetCore.Http.HttpContext context, string policyName);
                }
                public interface ICorsService
                {
                    void ApplyResult(Microsoft.AspNetCore.Cors.Infrastructure.CorsResult result, Microsoft.AspNetCore.Http.HttpResponse response);
                    Microsoft.AspNetCore.Cors.Infrastructure.CorsResult EvaluatePolicy(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Cors.Infrastructure.CorsPolicy policy);
                }
                public interface IDisableCorsAttribute : Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata
                {
                }
                public interface IEnableCorsAttribute : Microsoft.AspNetCore.Cors.Infrastructure.ICorsMetadata
                {
                    string PolicyName { get; set; }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class CorsServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCors(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCors(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> setupAction) => throw null;
            }
        }
    }
}
