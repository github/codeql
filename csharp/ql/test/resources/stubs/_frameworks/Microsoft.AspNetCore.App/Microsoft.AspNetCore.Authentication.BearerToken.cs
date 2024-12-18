// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authentication.BearerToken, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            namespace BearerToken
            {
                public sealed class AccessTokenResponse
                {
                    public string AccessToken { get => throw null; set { } }
                    public AccessTokenResponse() => throw null;
                    public long ExpiresIn { get => throw null; set { } }
                    public string RefreshToken { get => throw null; set { } }
                    public string TokenType { get => throw null; }
                }
                public static class BearerTokenDefaults
                {
                    public const string AuthenticationScheme = default;
                }
                public class BearerTokenEvents
                {
                    public BearerTokenEvents() => throw null;
                    public virtual System.Threading.Tasks.Task MessageReceivedAsync(Microsoft.AspNetCore.Authentication.BearerToken.MessageReceivedContext context) => throw null;
                    public System.Func<Microsoft.AspNetCore.Authentication.BearerToken.MessageReceivedContext, System.Threading.Tasks.Task> OnMessageReceived { get => throw null; set { } }
                }
                public sealed class BearerTokenOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
                {
                    public System.TimeSpan BearerTokenExpiration { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.ISecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationTicket> BearerTokenProtector { get => throw null; set { } }
                    public BearerTokenOptions() => throw null;
                    public Microsoft.AspNetCore.Authentication.BearerToken.BearerTokenEvents Events { get => throw null; set { } }
                    public System.TimeSpan RefreshTokenExpiration { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.ISecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationTicket> RefreshTokenProtector { get => throw null; set { } }
                }
                public class MessageReceivedContext : Microsoft.AspNetCore.Authentication.ResultContext<Microsoft.AspNetCore.Authentication.BearerToken.BearerTokenOptions>
                {
                    public MessageReceivedContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.BearerToken.BearerTokenOptions options) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.BearerToken.BearerTokenOptions)) => throw null;
                    public string Token { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class BearerTokenExtensions
            {
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddBearerToken(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddBearerToken(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddBearerToken(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, System.Action<Microsoft.AspNetCore.Authentication.BearerToken.BearerTokenOptions> configure) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddBearerToken(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, System.Action<Microsoft.AspNetCore.Authentication.BearerToken.BearerTokenOptions> configure) => throw null;
            }
        }
    }
}
