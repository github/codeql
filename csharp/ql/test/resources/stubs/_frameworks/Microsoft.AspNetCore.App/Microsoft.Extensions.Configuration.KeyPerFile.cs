// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.KeyPerFile, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            namespace KeyPerFile
            {
                public class KeyPerFileConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider, System.IDisposable
                {
                    public KeyPerFileConfigurationProvider(Microsoft.Extensions.Configuration.KeyPerFile.KeyPerFileConfigurationSource source) => throw null;
                    public void Dispose() => throw null;
                    public override void Load() => throw null;
                    public override string ToString() => throw null;
                }
                public class KeyPerFileConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public KeyPerFileConfigurationSource() => throw null;
                    public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set { } }
                    public System.Func<string, bool> IgnoreCondition { get => throw null; set { } }
                    public string IgnorePrefix { get => throw null; set { } }
                    public bool Optional { get => throw null; set { } }
                    public int ReloadDelay { get => throw null; set { } }
                    public bool ReloadOnChange { get => throw null; set { } }
                    public string SectionDelimiter { get => throw null; set { } }
                }
            }
            public static partial class KeyPerFileConfigurationBuilderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string directoryPath) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string directoryPath, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string directoryPath, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.KeyPerFile.KeyPerFileConfigurationSource> configureSource) => throw null;
            }
        }
    }
}
