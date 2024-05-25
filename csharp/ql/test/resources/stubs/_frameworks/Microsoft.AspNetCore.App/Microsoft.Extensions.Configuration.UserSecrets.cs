// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.UserSecrets, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            namespace UserSecrets
            {
                public class PathHelper
                {
                    public PathHelper() => throw null;
                    public static string GetSecretsPathFromSecretsId(string userSecretsId) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)1, Inherited = false, AllowMultiple = false)]
                public class UserSecretsIdAttribute : System.Attribute
                {
                    public UserSecretsIdAttribute(string userSecretId) => throw null;
                    public string UserSecretsId { get => throw null; }
                }
            }
            public static partial class UserSecretsConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, System.Reflection.Assembly assembly) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, System.Reflection.Assembly assembly, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, System.Reflection.Assembly assembly, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, string userSecretsId) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, string userSecretsId, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets<T>(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration) where T : class => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets<T>(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, bool optional) where T : class => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets<T>(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, bool optional, bool reloadOnChange) where T : class => throw null;
            }
        }
    }
}
