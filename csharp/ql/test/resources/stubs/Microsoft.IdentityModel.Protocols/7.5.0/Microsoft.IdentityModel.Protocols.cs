// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Protocols, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Protocols
        {
            public abstract class AuthenticationProtocolMessage
            {
                public virtual string BuildFormPost() => throw null;
                public virtual string BuildRedirectUrl() => throw null;
                protected AuthenticationProtocolMessage() => throw null;
                public virtual string GetParameter(string parameter) => throw null;
                public string IssuerAddress { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> Parameters { get => throw null; }
                public string PostTitle { get => throw null; set { } }
                public virtual void RemoveParameter(string parameter) => throw null;
                public string Script { get => throw null; set { } }
                public string ScriptButtonText { get => throw null; set { } }
                public string ScriptDisabledText { get => throw null; set { } }
                public void SetParameter(string parameter, string value) => throw null;
                public virtual void SetParameters(System.Collections.Specialized.NameValueCollection nameValueCollection) => throw null;
            }
            namespace Configuration
            {
                public class InvalidConfigurationException : System.Exception
                {
                    public InvalidConfigurationException() => throw null;
                    public InvalidConfigurationException(string message) => throw null;
                    public InvalidConfigurationException(string message, System.Exception innerException) => throw null;
                    protected InvalidConfigurationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class LastKnownGoodConfigurationCacheOptions : Microsoft.IdentityModel.Tokens.Configuration.LKGConfigurationCacheOptions
                {
                    public LastKnownGoodConfigurationCacheOptions() => throw null;
                    public static readonly int DefaultLastKnownGoodConfigurationSizeLimit;
                }
            }
            public class ConfigurationManager<T> : Microsoft.IdentityModel.Tokens.BaseConfigurationManager, Microsoft.IdentityModel.Protocols.IConfigurationManager<T> where T : class
            {
                public ConfigurationManager(string metadataAddress, Microsoft.IdentityModel.Protocols.IConfigurationRetriever<T> configRetriever) => throw null;
                public ConfigurationManager(string metadataAddress, Microsoft.IdentityModel.Protocols.IConfigurationRetriever<T> configRetriever, System.Net.Http.HttpClient httpClient) => throw null;
                public ConfigurationManager(string metadataAddress, Microsoft.IdentityModel.Protocols.IConfigurationRetriever<T> configRetriever, Microsoft.IdentityModel.Protocols.IDocumentRetriever docRetriever) => throw null;
                public ConfigurationManager(string metadataAddress, Microsoft.IdentityModel.Protocols.IConfigurationRetriever<T> configRetriever, Microsoft.IdentityModel.Protocols.IDocumentRetriever docRetriever, Microsoft.IdentityModel.Protocols.Configuration.LastKnownGoodConfigurationCacheOptions lkgCacheOptions) => throw null;
                public ConfigurationManager(string metadataAddress, Microsoft.IdentityModel.Protocols.IConfigurationRetriever<T> configRetriever, Microsoft.IdentityModel.Protocols.IDocumentRetriever docRetriever, Microsoft.IdentityModel.Protocols.IConfigurationValidator<T> configValidator) => throw null;
                public ConfigurationManager(string metadataAddress, Microsoft.IdentityModel.Protocols.IConfigurationRetriever<T> configRetriever, Microsoft.IdentityModel.Protocols.IDocumentRetriever docRetriever, Microsoft.IdentityModel.Protocols.IConfigurationValidator<T> configValidator, Microsoft.IdentityModel.Protocols.Configuration.LastKnownGoodConfigurationCacheOptions lkgCacheOptions) => throw null;
                public static readonly System.TimeSpan DefaultAutomaticRefreshInterval;
                public static readonly System.TimeSpan DefaultRefreshInterval;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.BaseConfiguration> GetBaseConfigurationAsync(System.Threading.CancellationToken cancel) => throw null;
                public System.Threading.Tasks.Task<T> GetConfigurationAsync() => throw null;
                public System.Threading.Tasks.Task<T> GetConfigurationAsync(System.Threading.CancellationToken cancel) => throw null;
                public static readonly System.TimeSpan MinimumAutomaticRefreshInterval;
                public static readonly System.TimeSpan MinimumRefreshInterval;
                public override void RequestRefresh() => throw null;
            }
            public class ConfigurationValidationResult
            {
                public ConfigurationValidationResult() => throw null;
                public string ErrorMessage { get => throw null; set { } }
                public bool Succeeded { get => throw null; set { } }
            }
            public class FileDocumentRetriever : Microsoft.IdentityModel.Protocols.IDocumentRetriever
            {
                public FileDocumentRetriever() => throw null;
                public System.Threading.Tasks.Task<string> GetDocumentAsync(string address, System.Threading.CancellationToken cancel) => throw null;
            }
            public class HttpDocumentRetriever : Microsoft.IdentityModel.Protocols.IDocumentRetriever
            {
                public HttpDocumentRetriever() => throw null;
                public HttpDocumentRetriever(System.Net.Http.HttpClient httpClient) => throw null;
                public static bool DefaultSendAdditionalHeaderData { get => throw null; set { } }
                public System.Threading.Tasks.Task<string> GetDocumentAsync(string address, System.Threading.CancellationToken cancel) => throw null;
                public bool RequireHttps { get => throw null; set { } }
                public const string ResponseContent = default;
                public bool SendAdditionalHeaderData { get => throw null; set { } }
                public const string StatusCode = default;
            }
            public class HttpRequestData
            {
                public void AppendHeaders(System.Net.Http.Headers.HttpHeaders headers) => throw null;
                public byte[] Body { get => throw null; set { } }
                public System.Security.Cryptography.X509Certificates.X509Certificate2Collection ClientCertificates { get => throw null; }
                public HttpRequestData() => throw null;
                public System.Collections.Generic.IDictionary<string, System.Collections.Generic.IEnumerable<string>> Headers { get => throw null; set { } }
                public string Method { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; set { } }
                public System.Uri Uri { get => throw null; set { } }
            }
            public interface IConfigurationManager<T> where T : class
            {
                System.Threading.Tasks.Task<T> GetConfigurationAsync(System.Threading.CancellationToken cancel);
                void RequestRefresh();
            }
            public interface IConfigurationRetriever<T>
            {
                System.Threading.Tasks.Task<T> GetConfigurationAsync(string address, Microsoft.IdentityModel.Protocols.IDocumentRetriever retriever, System.Threading.CancellationToken cancel);
            }
            public interface IConfigurationValidator<T>
            {
                Microsoft.IdentityModel.Protocols.ConfigurationValidationResult Validate(T configuration);
            }
            public interface IDocumentRetriever
            {
                System.Threading.Tasks.Task<string> GetDocumentAsync(string address, System.Threading.CancellationToken cancel);
            }
            public class StaticConfigurationManager<T> : Microsoft.IdentityModel.Tokens.BaseConfigurationManager, Microsoft.IdentityModel.Protocols.IConfigurationManager<T> where T : class
            {
                public StaticConfigurationManager(T configuration) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.BaseConfiguration> GetBaseConfigurationAsync(System.Threading.CancellationToken cancel) => throw null;
                public System.Threading.Tasks.Task<T> GetConfigurationAsync(System.Threading.CancellationToken cancel) => throw null;
                public override void RequestRefresh() => throw null;
            }
            public class X509CertificateValidationMode
            {
                public X509CertificateValidationMode() => throw null;
            }
        }
    }
}
