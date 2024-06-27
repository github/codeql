// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.EnvironmentVariables, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            namespace EnvironmentVariables
            {
                public class EnvironmentVariablesConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider
                {
                    public EnvironmentVariablesConfigurationProvider() => throw null;
                    public EnvironmentVariablesConfigurationProvider(string prefix) => throw null;
                    public override void Load() => throw null;
                    public override string ToString() => throw null;
                }
                public class EnvironmentVariablesConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public EnvironmentVariablesConfigurationSource() => throw null;
                    public string Prefix { get => throw null; set { } }
                }
            }
            public static partial class EnvironmentVariablesExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddEnvironmentVariables(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddEnvironmentVariables(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.EnvironmentVariables.EnvironmentVariablesConfigurationSource> configureSource) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddEnvironmentVariables(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, string prefix) => throw null;
            }
        }
    }
}
