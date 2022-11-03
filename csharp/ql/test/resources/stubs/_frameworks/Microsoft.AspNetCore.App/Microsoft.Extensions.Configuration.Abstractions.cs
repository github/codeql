// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.ConfigurationExtensions` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder Add<TSource>(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<TSource> configureSource) where TSource : Microsoft.Extensions.Configuration.IConfigurationSource, new() => throw null;
                public static System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> AsEnumerable(this Microsoft.Extensions.Configuration.IConfiguration configuration, bool makePathsRelative) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> AsEnumerable(this Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                public static bool Exists(this Microsoft.Extensions.Configuration.IConfigurationSection section) => throw null;
                public static string GetConnectionString(this Microsoft.Extensions.Configuration.IConfiguration configuration, string name) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationPath` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConfigurationPath
            {
                public static string Combine(params string[] pathSegments) => throw null;
                public static string Combine(System.Collections.Generic.IEnumerable<string> pathSegments) => throw null;
                public static string GetParentPath(string path) => throw null;
                public static string GetSectionKey(string path) => throw null;
                public static string KeyDelimiter;
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationRootExtensions` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConfigurationRootExtensions
            {
                public static string GetDebugView(this Microsoft.Extensions.Configuration.IConfigurationRoot root) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.IConfiguration` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfiguration
            {
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren();
                Microsoft.Extensions.Primitives.IChangeToken GetReloadToken();
                Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key);
                string this[string key] { get; set; }
            }

            // Generated from `Microsoft.Extensions.Configuration.IConfigurationBuilder` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigurationBuilder
            {
                Microsoft.Extensions.Configuration.IConfigurationBuilder Add(Microsoft.Extensions.Configuration.IConfigurationSource source);
                Microsoft.Extensions.Configuration.IConfigurationRoot Build();
                System.Collections.Generic.IDictionary<string, object> Properties { get; }
                System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationSource> Sources { get; }
            }

            // Generated from `Microsoft.Extensions.Configuration.IConfigurationProvider` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigurationProvider
            {
                System.Collections.Generic.IEnumerable<string> GetChildKeys(System.Collections.Generic.IEnumerable<string> earlierKeys, string parentPath);
                Microsoft.Extensions.Primitives.IChangeToken GetReloadToken();
                void Load();
                void Set(string key, string value);
                bool TryGet(string key, out string value);
            }

            // Generated from `Microsoft.Extensions.Configuration.IConfigurationRoot` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigurationRoot : Microsoft.Extensions.Configuration.IConfiguration
            {
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationProvider> Providers { get; }
                void Reload();
            }

            // Generated from `Microsoft.Extensions.Configuration.IConfigurationSection` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigurationSection : Microsoft.Extensions.Configuration.IConfiguration
            {
                string Key { get; }
                string Path { get; }
                string Value { get; set; }
            }

            // Generated from `Microsoft.Extensions.Configuration.IConfigurationSource` in `Microsoft.Extensions.Configuration.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigurationSource
            {
                Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder);
            }

        }
    }
}
