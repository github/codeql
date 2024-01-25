// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authorization.Policy, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authorization
        {
            public class AuthorizationMiddleware
            {
                public AuthorizationMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider) => throw null;
                public AuthorizationMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider, System.IServiceProvider services, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Authorization.AuthorizationMiddleware> logger) => throw null;
                public AuthorizationMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider, System.IServiceProvider services) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public interface IAuthorizationMiddlewareResultHandler
            {
                System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult authorizeResult);
            }
            namespace Policy
            {
                public class AuthorizationMiddlewareResultHandler : Microsoft.AspNetCore.Authorization.IAuthorizationMiddlewareResultHandler
                {
                    public AuthorizationMiddlewareResultHandler() => throw null;
                    public System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult authorizeResult) => throw null;
                }
                public interface IPolicyEvaluator
                {
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Http.HttpContext context);
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult> AuthorizeAsync(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authentication.AuthenticateResult authenticationResult, Microsoft.AspNetCore.Http.HttpContext context, object resource);
                }
                public class PolicyAuthorizationResult
                {
                    public Microsoft.AspNetCore.Authorization.AuthorizationFailure AuthorizationFailure { get => throw null; }
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Challenge() => throw null;
                    public bool Challenged { get => throw null; }
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Forbid() => throw null;
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Forbid(Microsoft.AspNetCore.Authorization.AuthorizationFailure authorizationFailure) => throw null;
                    public bool Forbidden { get => throw null; }
                    public bool Succeeded { get => throw null; }
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Success() => throw null;
                }
                public class PolicyEvaluator : Microsoft.AspNetCore.Authorization.Policy.IPolicyEvaluator
                {
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult> AuthorizeAsync(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authentication.AuthenticateResult authenticationResult, Microsoft.AspNetCore.Http.HttpContext context, object resource) => throw null;
                    public PolicyEvaluator(Microsoft.AspNetCore.Authorization.IAuthorizationService authorization) => throw null;
                }
            }
        }
        namespace Builder
        {
            public static partial class AuthorizationAppBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseAuthorization(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
            public static partial class AuthorizationEndpointConventionBuilderExtensions
            {
                public static TBuilder AllowAnonymous<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder, params string[] policyNames) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder, params Microsoft.AspNetCore.Authorization.IAuthorizeData[] authorizeData) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder> configurePolicy) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class PolicyServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationOptions> configure) => throw null;
                public static Microsoft.AspNetCore.Authorization.AuthorizationBuilder AddAuthorizationBuilder(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorizationPolicyEvaluator(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }
        }
    }
}
