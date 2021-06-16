// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.UserSecretsConfigurationExtensions` in `Microsoft.Extensions.Configuration.UserSecrets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class UserSecretsConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets<T>(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, bool optional, bool reloadOnChange) where T : class => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets<T>(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, bool optional) where T : class => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets<T>(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration) where T : class => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, string userSecretsId, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, string userSecretsId) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, System.Reflection.Assembly assembly, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, System.Reflection.Assembly assembly, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddUserSecrets(this Microsoft.Extensions.Configuration.IConfigurationBuilder configuration, System.Reflection.Assembly assembly) => throw null;
            }

            namespace UserSecrets
            {
                // Generated from `Microsoft.Extensions.Configuration.UserSecrets.PathHelper` in `Microsoft.Extensions.Configuration.UserSecrets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PathHelper
                {
                    public static string GetSecretsPathFromSecretsId(string userSecretsId) => throw null;
                    public PathHelper() => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.UserSecrets.UserSecretsIdAttribute` in `Microsoft.Extensions.Configuration.UserSecrets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UserSecretsIdAttribute : System.Attribute
                {
                    public string UserSecretsId { get => throw null; }
                    public UserSecretsIdAttribute(string userSecretId) => throw null;
                }

            }
        }
    }
}
