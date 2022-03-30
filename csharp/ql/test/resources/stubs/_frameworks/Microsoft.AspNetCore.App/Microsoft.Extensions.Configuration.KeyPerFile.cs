// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.KeyPerFileConfigurationBuilderExtensions` in `Microsoft.Extensions.Configuration.KeyPerFile, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class KeyPerFileConfigurationBuilderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string directoryPath, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string directoryPath, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string directoryPath) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddKeyPerFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.KeyPerFile.KeyPerFileConfigurationSource> configureSource) => throw null;
            }

            namespace KeyPerFile
            {
                // Generated from `Microsoft.Extensions.Configuration.KeyPerFile.KeyPerFileConfigurationProvider` in `Microsoft.Extensions.Configuration.KeyPerFile, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class KeyPerFileConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider, System.IDisposable
                {
                    public void Dispose() => throw null;
                    public KeyPerFileConfigurationProvider(Microsoft.Extensions.Configuration.KeyPerFile.KeyPerFileConfigurationSource source) => throw null;
                    public override void Load() => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.KeyPerFile.KeyPerFileConfigurationSource` in `Microsoft.Extensions.Configuration.KeyPerFile, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class KeyPerFileConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                    public System.Func<string, bool> IgnoreCondition { get => throw null; set => throw null; }
                    public string IgnorePrefix { get => throw null; set => throw null; }
                    public KeyPerFileConfigurationSource() => throw null;
                    public bool Optional { get => throw null; set => throw null; }
                    public int ReloadDelay { get => throw null; set => throw null; }
                    public bool ReloadOnChange { get => throw null; set => throw null; }
                }

            }
        }
    }
}
