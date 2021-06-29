// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.IniConfigurationExtensions` in `Microsoft.Extensions.Configuration.Ini, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class IniConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddIniFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddIniFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddIniFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddIniFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.Ini.IniConfigurationSource> configureSource) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddIniFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, Microsoft.Extensions.FileProviders.IFileProvider provider, string path, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddIniStream(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.IO.Stream stream) => throw null;
            }

            namespace Ini
            {
                // Generated from `Microsoft.Extensions.Configuration.Ini.IniConfigurationProvider` in `Microsoft.Extensions.Configuration.Ini, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IniConfigurationProvider : Microsoft.Extensions.Configuration.FileConfigurationProvider
                {
                    public IniConfigurationProvider(Microsoft.Extensions.Configuration.Ini.IniConfigurationSource source) : base(default(Microsoft.Extensions.Configuration.FileConfigurationSource)) => throw null;
                    public override void Load(System.IO.Stream stream) => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.Ini.IniConfigurationSource` in `Microsoft.Extensions.Configuration.Ini, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IniConfigurationSource : Microsoft.Extensions.Configuration.FileConfigurationSource
                {
                    public override Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public IniConfigurationSource() => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.Ini.IniStreamConfigurationProvider` in `Microsoft.Extensions.Configuration.Ini, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IniStreamConfigurationProvider : Microsoft.Extensions.Configuration.StreamConfigurationProvider
                {
                    public IniStreamConfigurationProvider(Microsoft.Extensions.Configuration.Ini.IniStreamConfigurationSource source) : base(default(Microsoft.Extensions.Configuration.StreamConfigurationSource)) => throw null;
                    public override void Load(System.IO.Stream stream) => throw null;
                    public static System.Collections.Generic.IDictionary<string, string> Read(System.IO.Stream stream) => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.Ini.IniStreamConfigurationSource` in `Microsoft.Extensions.Configuration.Ini, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IniStreamConfigurationSource : Microsoft.Extensions.Configuration.StreamConfigurationSource
                {
                    public override Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public IniStreamConfigurationSource() => throw null;
                }

            }
        }
    }
}
