// This file contains auto-generated code.
// Generated from `Microsoft.Identity.ServiceEssentials.TokenAcquisition, Version=1.19.6.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace Identity
    {
        namespace ServiceEssentials
        {
            public static partial class MiseAuthenticationBuilderTokenAcquisitionExtensions
            {
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithDataProviderAuthentication(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string sectionName = default(string)) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithDataProviderAuthentication(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, System.Action<Microsoft.Identity.ServiceEssentials.TokenAcquisition.MiseTokenAcquisitionOptions> configureAction) => throw null;
            }
            namespace TokenAcquisition
            {
                public delegate Microsoft.Identity.Client.IConfidentialClientApplication ConfidentialClientApplicationCreator(Microsoft.Identity.ServiceEssentials.TokenAcquisition.MiseTokenAcquisitionOptions miseTokenAcquisitionOptions, string authority);
                public interface ITokenAcquisitionCacheProvider
                {
                    void RegisterCache(Microsoft.Identity.Client.ITokenCache tokenCache);
                }
                public class MiseTokenAcquisition : Microsoft.Identity.ServiceEssentials.IMiseComponent, Microsoft.Identity.ServiceEssentials.IMiseTokenAcquisition
                {
                    public System.Threading.Tasks.Task<string> AcquireTokenForClientAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                    public System.Threading.Tasks.Task<string> AcquireTokenForClientAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.ServiceEssentials.AcquireTokenOptions acquireTokenOptions) => throw null;
                    public Microsoft.Identity.ServiceEssentials.TokenAcquisition.ConfidentialClientApplicationCreator ConfidentialClientApplicationCreator { get => throw null; set { } }
                    public MiseTokenAcquisition(Microsoft.Identity.ServiceEssentials.TokenAcquisition.MiseTokenAcquisitionOptions tokenAcquisitionOptions) => throw null;
                    public MiseTokenAcquisition(Microsoft.Extensions.Options.IOptions<Microsoft.Identity.ServiceEssentials.TokenAcquisition.MiseTokenAcquisitionOptions> tokenAcquisitionOptions) => throw null;
                    public Microsoft.Identity.ServiceEssentials.IMiseLogger Logger { get => throw null; set { } }
                    public Microsoft.Identity.Client.IMsalHttpClientFactory MsalHttpClientFactory { get => throw null; set { } }
                    public string Name { get => throw null; set { } }
                    public Microsoft.Identity.ServiceEssentials.TokenAcquisition.ITokenAcquisitionCacheProvider TokenAcquisitionCacheProvider { get => throw null; set { } }
                }
                public static class MiseTokenAcquisitionDefaults
                {
                    public const string Name = default;
                }
                public class MiseTokenAcquisitionOptions
                {
                    public Microsoft.Identity.Client.AzureCloudInstance AzureCloudInstance { get => throw null; set { } }
                    public System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCertificate { get => throw null; set { } }
                    public string ClientId { get => throw null; set { } }
                    public string ClientSecret { get => throw null; set { } }
                    public MiseTokenAcquisitionOptions() => throw null;
                    public bool EnablePiiLogging { get => throw null; set { } }
                    public string Instance { get => throw null; set { } }
                    public bool SendX5c { get => throw null; set { } }
                    public string TenantId { get => throw null; set { } }
                }
                public static class TokenAcquisitionConstants
                {
                    public const string DefaultSectionName = default;
                }
            }
        }
    }
}
