// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.Json, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            namespace Json
            {
                public class JsonConfigurationProvider : Microsoft.Extensions.Configuration.FileConfigurationProvider
                {
                    public JsonConfigurationProvider(Microsoft.Extensions.Configuration.Json.JsonConfigurationSource source) : base(default(Microsoft.Extensions.Configuration.FileConfigurationSource)) => throw null;
                    public override void Load(System.IO.Stream stream) => throw null;
                }
                public class JsonConfigurationSource : Microsoft.Extensions.Configuration.FileConfigurationSource
                {
                    public override Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public JsonConfigurationSource() => throw null;
                }
                public class JsonStreamConfigurationProvider : Microsoft.Extensions.Configuration.StreamConfigurationProvider
                {
                    public JsonStreamConfigurationProvider(Microsoft.Extensions.Configuration.Json.JsonStreamConfigurationSource source) : base(default(Microsoft.Extensions.Configuration.StreamConfigurationSource)) => throw null;
                    public override void Load(System.IO.Stream stream) => throw null;
                }
                public class JsonStreamConfigurationSource : Microsoft.Extensions.Configuration.StreamConfigurationSource
                {
                    public override Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public JsonStreamConfigurationSource() => throw null;
                }
            }
            public static partial class JsonConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddJsonFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, Microsoft.Extensions.FileProviders.IFileProvider provider, string path, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddJsonFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.Json.JsonConfigurationSource> configureSource) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddJsonFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddJsonFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddJsonFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddJsonStream(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.IO.Stream stream) => throw null;
            }
        }
    }
}
