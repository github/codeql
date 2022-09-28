// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authorization
        {
            // Generated from `Microsoft.AspNetCore.Authorization.AllowAnonymousAttribute` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AllowAnonymousAttribute : System.Attribute, Microsoft.AspNetCore.Authorization.IAllowAnonymous
            {
                public AllowAnonymousAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationFailure` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationFailure
            {
                public static Microsoft.AspNetCore.Authorization.AuthorizationFailure ExplicitFail() => throw null;
                public bool FailCalled { get => throw null; }
                public static Microsoft.AspNetCore.Authorization.AuthorizationFailure Failed(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.AuthorizationFailureReason> reasons) => throw null;
                public static Microsoft.AspNetCore.Authorization.AuthorizationFailure Failed(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> failed) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> FailedRequirements { get => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.AuthorizationFailureReason> FailureReasons { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationFailureReason` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationFailureReason
            {
                public AuthorizationFailureReason(Microsoft.AspNetCore.Authorization.IAuthorizationHandler handler, string message) => throw null;
                public Microsoft.AspNetCore.Authorization.IAuthorizationHandler Handler { get => throw null; }
                public string Message { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationHandler<,>` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class AuthorizationHandler<TRequirement, TResource> : Microsoft.AspNetCore.Authorization.IAuthorizationHandler where TRequirement : Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
            {
                protected AuthorizationHandler() => throw null;
                public virtual System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context) => throw null;
                protected abstract System.Threading.Tasks.Task HandleRequirementAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context, TRequirement requirement, TResource resource);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationHandler<>` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class AuthorizationHandler<TRequirement> : Microsoft.AspNetCore.Authorization.IAuthorizationHandler where TRequirement : Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
            {
                protected AuthorizationHandler() => throw null;
                public virtual System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context) => throw null;
                protected abstract System.Threading.Tasks.Task HandleRequirementAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context, TRequirement requirement);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationHandlerContext
            {
                public AuthorizationHandlerContext(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> requirements, System.Security.Claims.ClaimsPrincipal user, object resource) => throw null;
                public virtual void Fail() => throw null;
                public virtual void Fail(Microsoft.AspNetCore.Authorization.AuthorizationFailureReason reason) => throw null;
                public virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.AuthorizationFailureReason> FailureReasons { get => throw null; }
                public virtual bool HasFailed { get => throw null; }
                public virtual bool HasSucceeded { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> PendingRequirements { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> Requirements { get => throw null; }
                public virtual object Resource { get => throw null; }
                public virtual void Succeed(Microsoft.AspNetCore.Authorization.IAuthorizationRequirement requirement) => throw null;
                public virtual System.Security.Claims.ClaimsPrincipal User { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationOptions` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationOptions
            {
                public void AddPolicy(string name, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder> configurePolicy) => throw null;
                public void AddPolicy(string name, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                public AuthorizationOptions() => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicy DefaultPolicy { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicy FallbackPolicy { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicy GetPolicy(string name) => throw null;
                public bool InvokeHandlersAfterFailure { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationPolicy` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationPolicy
            {
                public System.Collections.Generic.IReadOnlyList<string> AuthenticationSchemes { get => throw null; }
                public AuthorizationPolicy(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> requirements, System.Collections.Generic.IEnumerable<string> authenticationSchemes) => throw null;
                public static Microsoft.AspNetCore.Authorization.AuthorizationPolicy Combine(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> policies) => throw null;
                public static Microsoft.AspNetCore.Authorization.AuthorizationPolicy Combine(params Microsoft.AspNetCore.Authorization.AuthorizationPolicy[] policies) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> CombineAsync(Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> authorizeData) => throw null;
                public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> Requirements { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationPolicyBuilder
            {
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder AddAuthenticationSchemes(params string[] schemes) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder AddRequirements(params Microsoft.AspNetCore.Authorization.IAuthorizationRequirement[] requirements) => throw null;
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                public AuthorizationPolicyBuilder(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                public AuthorizationPolicyBuilder(params string[] authenticationSchemes) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicy Build() => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder Combine(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireAssertion(System.Func<Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext, System.Threading.Tasks.Task<bool>> handler) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireAssertion(System.Func<Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext, bool> handler) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireAuthenticatedUser() => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireClaim(string claimType) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireClaim(string claimType, System.Collections.Generic.IEnumerable<string> allowedValues) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireClaim(string claimType, params string[] allowedValues) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireRole(System.Collections.Generic.IEnumerable<string> roles) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireRole(params string[] roles) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationPolicyBuilder RequireUserName(string userName) => throw null;
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> Requirements { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationResult` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizationResult
            {
                public static Microsoft.AspNetCore.Authorization.AuthorizationResult Failed() => throw null;
                public static Microsoft.AspNetCore.Authorization.AuthorizationResult Failed(Microsoft.AspNetCore.Authorization.AuthorizationFailure failure) => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationFailure Failure { get => throw null; }
                public bool Succeeded { get => throw null; }
                public static Microsoft.AspNetCore.Authorization.AuthorizationResult Success() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizationServiceExtensions` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AuthorizationServiceExtensions
            {
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(this Microsoft.AspNetCore.Authorization.IAuthorizationService service, System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(this Microsoft.AspNetCore.Authorization.IAuthorizationService service, System.Security.Claims.ClaimsPrincipal user, object resource, Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(this Microsoft.AspNetCore.Authorization.IAuthorizationService service, System.Security.Claims.ClaimsPrincipal user, object resource, Microsoft.AspNetCore.Authorization.IAuthorizationRequirement requirement) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(this Microsoft.AspNetCore.Authorization.IAuthorizationService service, System.Security.Claims.ClaimsPrincipal user, string policyName) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.AuthorizeAttribute` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthorizeAttribute : System.Attribute, Microsoft.AspNetCore.Authorization.IAuthorizeData
            {
                public string AuthenticationSchemes { get => throw null; set => throw null; }
                public AuthorizeAttribute() => throw null;
                public AuthorizeAttribute(string policy) => throw null;
                public string Policy { get => throw null; set => throw null; }
                public string Roles { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authorization.DefaultAuthorizationEvaluator` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultAuthorizationEvaluator : Microsoft.AspNetCore.Authorization.IAuthorizationEvaluator
            {
                public DefaultAuthorizationEvaluator() => throw null;
                public Microsoft.AspNetCore.Authorization.AuthorizationResult Evaluate(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.DefaultAuthorizationHandlerContextFactory` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultAuthorizationHandlerContextFactory : Microsoft.AspNetCore.Authorization.IAuthorizationHandlerContextFactory
            {
                public virtual Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext CreateContext(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> requirements, System.Security.Claims.ClaimsPrincipal user, object resource) => throw null;
                public DefaultAuthorizationHandlerContextFactory() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.DefaultAuthorizationHandlerProvider` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultAuthorizationHandlerProvider : Microsoft.AspNetCore.Authorization.IAuthorizationHandlerProvider
            {
                public DefaultAuthorizationHandlerProvider(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationHandler> handlers) => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationHandler>> GetHandlersAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.DefaultAuthorizationPolicyProvider` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultAuthorizationPolicyProvider : Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider
            {
                public DefaultAuthorizationPolicyProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Authorization.AuthorizationOptions> options) => throw null;
                public System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> GetDefaultPolicyAsync() => throw null;
                public System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> GetFallbackPolicyAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> GetPolicyAsync(string policyName) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.DefaultAuthorizationService` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultAuthorizationService : Microsoft.AspNetCore.Authorization.IAuthorizationService
            {
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(System.Security.Claims.ClaimsPrincipal user, object resource, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> requirements) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(System.Security.Claims.ClaimsPrincipal user, object resource, string policyName) => throw null;
                public DefaultAuthorizationService(Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider, Microsoft.AspNetCore.Authorization.IAuthorizationHandlerProvider handlers, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Authorization.DefaultAuthorizationService> logger, Microsoft.AspNetCore.Authorization.IAuthorizationHandlerContextFactory contextFactory, Microsoft.AspNetCore.Authorization.IAuthorizationEvaluator evaluator, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Authorization.AuthorizationOptions> options) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationEvaluator` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationEvaluator
            {
                Microsoft.AspNetCore.Authorization.AuthorizationResult Evaluate(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationHandler` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationHandler
            {
                System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationHandlerContextFactory` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationHandlerContextFactory
            {
                Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext CreateContext(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> requirements, System.Security.Claims.ClaimsPrincipal user, object resource);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationHandlerProvider` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationHandlerProvider
            {
                System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationHandler>> GetHandlersAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationPolicyProvider
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> GetDefaultPolicyAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> GetFallbackPolicyAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationPolicy> GetPolicyAsync(string policyName);
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationRequirement
            {
            }

            // Generated from `Microsoft.AspNetCore.Authorization.IAuthorizationService` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthorizationService
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(System.Security.Claims.ClaimsPrincipal user, object resource, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizationRequirement> requirements);
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authorization.AuthorizationResult> AuthorizeAsync(System.Security.Claims.ClaimsPrincipal user, object resource, string policyName);
            }

            namespace Infrastructure
            {
                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.AssertionRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AssertionRequirement : Microsoft.AspNetCore.Authorization.IAuthorizationHandler, Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
                {
                    public AssertionRequirement(System.Func<Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext, System.Threading.Tasks.Task<bool>> handler) => throw null;
                    public AssertionRequirement(System.Func<Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext, bool> handler) => throw null;
                    public System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context) => throw null;
                    public System.Func<Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext, System.Threading.Tasks.Task<bool>> Handler { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.ClaimsAuthorizationRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ClaimsAuthorizationRequirement : Microsoft.AspNetCore.Authorization.AuthorizationHandler<Microsoft.AspNetCore.Authorization.Infrastructure.ClaimsAuthorizationRequirement>, Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
                {
                    public System.Collections.Generic.IEnumerable<string> AllowedValues { get => throw null; }
                    public string ClaimType { get => throw null; }
                    public ClaimsAuthorizationRequirement(string claimType, System.Collections.Generic.IEnumerable<string> allowedValues) => throw null;
                    protected override System.Threading.Tasks.Task HandleRequirementAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context, Microsoft.AspNetCore.Authorization.Infrastructure.ClaimsAuthorizationRequirement requirement) => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.DenyAnonymousAuthorizationRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DenyAnonymousAuthorizationRequirement : Microsoft.AspNetCore.Authorization.AuthorizationHandler<Microsoft.AspNetCore.Authorization.Infrastructure.DenyAnonymousAuthorizationRequirement>, Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
                {
                    public DenyAnonymousAuthorizationRequirement() => throw null;
                    protected override System.Threading.Tasks.Task HandleRequirementAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context, Microsoft.AspNetCore.Authorization.Infrastructure.DenyAnonymousAuthorizationRequirement requirement) => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.NameAuthorizationRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NameAuthorizationRequirement : Microsoft.AspNetCore.Authorization.AuthorizationHandler<Microsoft.AspNetCore.Authorization.Infrastructure.NameAuthorizationRequirement>, Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
                {
                    protected override System.Threading.Tasks.Task HandleRequirementAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context, Microsoft.AspNetCore.Authorization.Infrastructure.NameAuthorizationRequirement requirement) => throw null;
                    public NameAuthorizationRequirement(string requiredName) => throw null;
                    public string RequiredName { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.OperationAuthorizationRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class OperationAuthorizationRequirement : Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
                {
                    public string Name { get => throw null; set => throw null; }
                    public OperationAuthorizationRequirement() => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.PassThroughAuthorizationHandler` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PassThroughAuthorizationHandler : Microsoft.AspNetCore.Authorization.IAuthorizationHandler
                {
                    public System.Threading.Tasks.Task HandleAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context) => throw null;
                    public PassThroughAuthorizationHandler() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authorization.Infrastructure.RolesAuthorizationRequirement` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RolesAuthorizationRequirement : Microsoft.AspNetCore.Authorization.AuthorizationHandler<Microsoft.AspNetCore.Authorization.Infrastructure.RolesAuthorizationRequirement>, Microsoft.AspNetCore.Authorization.IAuthorizationRequirement
                {
                    public System.Collections.Generic.IEnumerable<string> AllowedRoles { get => throw null; }
                    protected override System.Threading.Tasks.Task HandleRequirementAsync(Microsoft.AspNetCore.Authorization.AuthorizationHandlerContext context, Microsoft.AspNetCore.Authorization.Infrastructure.RolesAuthorizationRequirement requirement) => throw null;
                    public RolesAuthorizationRequirement(System.Collections.Generic.IEnumerable<string> allowedRoles) => throw null;
                    public override string ToString() => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.AuthorizationServiceCollectionExtensions` in `Microsoft.AspNetCore.Authorization, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AuthorizationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorizationCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthorizationCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationOptions> configure) => throw null;
            }

        }
    }
}
