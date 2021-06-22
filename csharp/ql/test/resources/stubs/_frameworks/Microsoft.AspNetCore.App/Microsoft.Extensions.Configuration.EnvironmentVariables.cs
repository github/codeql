// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.EnvironmentVariablesExtensions` in `Microsoft.Extensions.Configuration.EnvironmentVariables, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EnvironmentVariablesExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddEnvironmentVariables(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, string prefix) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddEnvironmentVariables(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddEnvironmentVariables(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.EnvironmentVariables.EnvironmentVariablesConfigurationSource> configureSource) => throw null;
            }

            namespace EnvironmentVariables
            {
                // Generated from `Microsoft.Extensions.Configuration.EnvironmentVariables.EnvironmentVariablesConfigurationProvider` in `Microsoft.Extensions.Configuration.EnvironmentVariables, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EnvironmentVariablesConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider
                {
                    public EnvironmentVariablesConfigurationProvider(string prefix) => throw null;
                    public EnvironmentVariablesConfigurationProvider() => throw null;
                    public override void Load() => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.EnvironmentVariables.EnvironmentVariablesConfigurationSource` in `Microsoft.Extensions.Configuration.EnvironmentVariables, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EnvironmentVariablesConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public EnvironmentVariablesConfigurationSource() => throw null;
                    public string Prefix { get => throw null; set => throw null; }
                }

            }
        }
    }
}
