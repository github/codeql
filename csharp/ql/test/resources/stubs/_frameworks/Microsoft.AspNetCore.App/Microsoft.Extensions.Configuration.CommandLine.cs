// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.CommandLine, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            namespace CommandLine
            {
                public class CommandLineConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider
                {
                    protected System.Collections.Generic.IEnumerable<string> Args { get => throw null; }
                    public CommandLineConfigurationProvider(System.Collections.Generic.IEnumerable<string> args, System.Collections.Generic.IDictionary<string, string> switchMappings = default(System.Collections.Generic.IDictionary<string, string>)) => throw null;
                    public override void Load() => throw null;
                }
                public class CommandLineConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public System.Collections.Generic.IEnumerable<string> Args { get => throw null; set { } }
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public CommandLineConfigurationSource() => throw null;
                    public System.Collections.Generic.IDictionary<string, string> SwitchMappings { get => throw null; set { } }
                }
            }
            public static partial class CommandLineConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddCommandLine(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.CommandLine.CommandLineConfigurationSource> configureSource) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddCommandLine(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, string[] args) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddCommandLine(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, string[] args, System.Collections.Generic.IDictionary<string, string> switchMappings) => throw null;
            }
        }
    }
}
