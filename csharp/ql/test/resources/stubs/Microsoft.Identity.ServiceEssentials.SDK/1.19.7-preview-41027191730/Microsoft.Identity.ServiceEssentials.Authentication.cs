// This file contains auto-generated code.
// Generated from `Microsoft.Identity.ServiceEssentials.Authentication, Version=1.19.6.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace Identity
    {
        namespace ServiceEssentials
        {
            namespace Authentication
            {
                public static class AuthenticationDefaults
                {
                    public const string Name = default;
                    public const string S2SAuthenticationResult = default;
                    public const string S2SAuthenticationTicket = default;
                }
                public class AuthenticationTicketProvider : Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<Microsoft.Identity.ServiceEssentials.MiseHttpContext>, Microsoft.Identity.ServiceEssentials.IInitializeWithMiseContext, Microsoft.Identity.ServiceEssentials.IMiseComponent
                {
                    public System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.AuthenticationTicketProviderResult> AuthenticateAsync(Microsoft.Identity.ServiceEssentials.MiseHttpContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public bool CaptureLogs { get => throw null; set { } }
                    public AuthenticationTicketProvider(Microsoft.IdentityModel.S2S.S2SAuthenticationManager authenticationManager) => throw null;
                    public System.Collections.Generic.IReadOnlyCollection<Microsoft.IdentityModel.S2S.S2SInboundPolicy> InboundPolicies() => throw null;
                    public void InitializeWithMiseContext(Microsoft.Identity.ServiceEssentials.InitializationContext context) => throw null;
                    public string Name { get => throw null; set { } }
                }
                public static partial class MiseContextExtensions
                {
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationResult GetS2SAuthenticationResult(this Microsoft.Identity.ServiceEssentials.MiseHttpContext miseContext) => throw null;
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationTicket GetS2SAuthenticationTicket(this Microsoft.Identity.ServiceEssentials.MiseHttpContext miseContext) => throw null;
                }
            }
            public static class AuthenticationBuilderExtension
            {
                public static Microsoft.Identity.ServiceEssentials.Builders.ModuleContainerParameterBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> UseDefaultAuthentication(this Microsoft.Identity.ServiceEssentials.Builders.AuthenticationComponentParameterBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> miseBuilder, Microsoft.IdentityModel.S2S.S2SAuthenticationManager authenticationManager) => throw null;
                public static Microsoft.Identity.ServiceEssentials.Builders.ModuleContainerParameterBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> WithDefaultAuthentication(this Microsoft.Identity.ServiceEssentials.Builders.AuthenticationComponentParameterBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> miseBuilder, Microsoft.IdentityModel.S2S.S2SAuthenticationManager authenticationManager) => throw null;
            }
        }
    }
}
