// This file contains auto-generated code.
// Generated from `Microsoft.Identity.ServiceEssentials.Modules.TrV2Module, Version=2.6.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace Identity
    {
        namespace ServiceEssentials
        {
            namespace Modules
            {
                namespace TrV2Module
                {
                    public class TrV2Constants
                    {
                        public const string AckResponseHeaderName = default;
                        public const string AuthenticateHeaderName = default;
                        public TrV2Constants() => throw null;
                        public const string ExtendedIdpClaim = default;
                        public const string ExtendedTenantIdClaim = default;
                        public const string IdpClaim = default;
                        public const string Issuer = default;
                        public class RestrictAccessConfirmValue
                        {
                            public RestrictAccessConfirmValue() => throw null;
                            public const string NoMatchingPolicy = default;
                            public const string NotAbleToCheck = default;
                            public const string TrV2Checked = default;
                        }
                        public const string TenantIdClaim = default;
                        public const string TrV2ClaimType = default;
                        public const string TrV2HeaderName = default;
                    }
                    public class TrV2Module : Microsoft.Identity.ServiceEssentials.MiseModule<Microsoft.Identity.ServiceEssentials.MiseHttpContext, Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions>
                    {
                        public TrV2Module(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions> options) : base(default(Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions)) => throw null;
                        public TrV2Module() : base(default(Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions)) => throw null;
                        public TrV2Module(Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions options) : base(default(Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions)) => throw null;
                        protected override System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.ModuleResult> HandleAsync(Microsoft.Identity.ServiceEssentials.MiseHttpContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                        public override System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.ModuleResult> HandleRequestAsync(Microsoft.Identity.ServiceEssentials.MiseHttpContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                        public override string Name { get => throw null; set { } }
                    }
                    public static class TrV2ModuleDefaults
                    {
                        public const string Name = default;
                    }
                    public class TrV2ModuleOptions : Microsoft.Identity.ServiceEssentials.MiseModuleOptions
                    {
                        public TrV2ModuleOptions() => throw null;
                        public bool IsNbfEnabled { get => throw null; set { } }
                        public int NbfRoundUpMinutes { get => throw null; set { } }
                    }
                    public class TrV2ModuleStandalone
                    {
                        public static Microsoft.Identity.ServiceEssentials.HttpResponse ValidateTenantRestrictionsV2(System.Security.Claims.ClaimsIdentity claims, System.Collections.Specialized.NameValueCollection headers, System.Threading.CancellationToken cancellationToken) => throw null;
                        public static Microsoft.Identity.ServiceEssentials.HttpResponse ValidateTenantRestrictionsV2(System.Security.Claims.ClaimsIdentity claims, System.Collections.Specialized.NameValueCollection headers, Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                        public static System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.HttpResponse> ValidateTenantRestrictionsV2Async(System.Security.Claims.ClaimsIdentity claims, System.Net.Http.Headers.HttpRequestHeaders headers, System.Threading.CancellationToken cancellationToken) => throw null;
                        public static System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.HttpResponse> ValidateTenantRestrictionsV2Async(System.Security.Claims.ClaimsIdentity claims, System.Collections.Specialized.NameValueCollection headers, System.Threading.CancellationToken cancellationToken) => throw null;
                        public static System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.HttpResponse> ValidateTenantRestrictionsV2Async(System.Security.Claims.ClaimsIdentity claims, System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                        public static System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.HttpResponse> ValidateTenantRestrictionsV2Async(System.Security.Claims.ClaimsIdentity claims, System.Collections.Specialized.NameValueCollection headers, Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                    }
                }
            }
            public static partial class TrV2ModuleExtensions
            {
                public static Microsoft.Identity.ServiceEssentials.Builders.ModuleCollectionBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> AddTrV2Module(this Microsoft.Identity.ServiceEssentials.Builders.ModuleCollectionBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> moduleCollectionBuilder) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithTrV2Module(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string moduleName = default(string)) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithTrV2Module(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string sectionName, string moduleName = default(string)) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithTrV2Module(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, System.Action<Microsoft.Identity.ServiceEssentials.Modules.TrV2Module.TrV2ModuleOptions> configureOptions, string moduleName = default(string)) => throw null;
            }
        }
    }
}
