// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.CommandLineConfigurationExtensions` in `Microsoft.Extensions.Configuration.CommandLine, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class CommandLineConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddCommandLine(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, string[] args, System.Collections.Generic.IDictionary<string, string> switchMappings) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddCommandLine(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, string[] args) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddCommandLine(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.CommandLine.CommandLineConfigurationSource> configureSource) => throw null;
            }

            namespace CommandLine
            {
                // Generated from `Microsoft.Extensions.Configuration.CommandLine.CommandLineConfigurationProvider` in `Microsoft.Extensions.Configuration.CommandLine, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CommandLineConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider
                {
                    protected System.Collections.Generic.IEnumerable<string> Args { get => throw null; }
                    public CommandLineConfigurationProvider(System.Collections.Generic.IEnumerable<string> args, System.Collections.Generic.IDictionary<string, string> switchMappings = default(System.Collections.Generic.IDictionary<string, string>)) => throw null;
                    public override void Load() => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.CommandLine.CommandLineConfigurationSource` in `Microsoft.Extensions.Configuration.CommandLine, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CommandLineConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public System.Collections.Generic.IEnumerable<string> Args { get => throw null; set => throw null; }
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public CommandLineConfigurationSource() => throw null;
                    public System.Collections.Generic.IDictionary<string, string> SwitchMappings { get => throw null; set => throw null; }
                }

            }
        }
    }
}
