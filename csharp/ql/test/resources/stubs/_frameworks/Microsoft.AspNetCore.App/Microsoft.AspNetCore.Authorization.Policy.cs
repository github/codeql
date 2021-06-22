// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authorization
        {
            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationMiddleware` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationMiddleware
            {
                public AuthorizationMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationMiddlewareResultHandler` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationMiddlewareResultHandler
            {
                System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult authorizeResult);
            }

            namespace Policy
            {
                // Generated from `Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthorizationMiddlewareResultHandler : Microsoft.AspNetCore.Authorization.IAuthorizationMiddlewareResultHandler
                {
                    public AuthorizationMiddlewareResultHandler() => throw null;
                    public System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult authorizeResult) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Policy.IPolicyEvaluator` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPolicyEvaluator
                {
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Http.HttpContext context);
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult> AuthorizeAsync(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy, Microsoft.AspNetCore.Authentication.AuthenticateResult authenticationResult, Microsoft.AspNetCore.Http.HttpContext context, object resource);
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PolicyAuthorizationResult
                {
                    public Microsoft.AspNetCore.Authorization.AuthorizationFailure AuthorizationFailure { get => throw null; }
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Challenge() => throw null;
                    public bool Challenged { get => throw null; }
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Forbid(Microsoft.AspNetCore.Authorization.AuthorizationFailure authorizationFailure) => throw null;
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Forbid() => throw null;
                    public bool Forbidden { get => throw null; }
                    public bool Succeeded { get => throw null; }
                    public static Microsoft.AspNetCore.Authorization.Policy.PolicyAuthorizationResult Success() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Policy.PolicyEvaluator` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
            // Generated from `Microsoft.AspNetCore.Builder.AuthorizationAppBuilderExtensions` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AuthorizationAppBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseAuthorization(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.AuthorizationEndpointConventionBuilderExtensions` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AuthorizationEndpointConventionBuilderExtensions
            {
                public static TBuilder AllowAnonymous<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder, params string[] policyNames) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder, params Microsoft.AspNetCore.Authorization.IAuthorizeData[] authorizeData) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireAuthorization<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.PolicyServiceCollectionExtensions` in `Microsoft.AspNetCore.Authorization.Policy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class PolicyServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorizationPolicyEvaluator(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
