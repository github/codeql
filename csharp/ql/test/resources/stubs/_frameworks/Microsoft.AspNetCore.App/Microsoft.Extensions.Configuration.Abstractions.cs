// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            public struct ConfigurationDebugViewContext
            {
                public Microsoft.Extensions.Configuration.IConfigurationProvider ConfigurationProvider { get => throw null; }
                public ConfigurationDebugViewContext(string path, string key, string value, Microsoft.Extensions.Configuration.IConfigurationProvider configurationProvider) => throw null;
                public string Key { get => throw null; }
                public string Path { get => throw null; }
                public string Value { get => throw null; }
            }
            public static partial class ConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder Add<TSource>(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<TSource> configureSource) where TSource : Microsoft.Extensions.Configuration.IConfigurationSource, new() => throw null;
                public static System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> AsEnumerable(this Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> AsEnumerable(this Microsoft.Extensions.Configuration.IConfiguration configuration, bool makePathsRelative) => throw null;
                public static bool Exists(this Microsoft.Extensions.Configuration.IConfigurationSection section) => throw null;
                public static string GetConnectionString(this Microsoft.Extensions.Configuration.IConfiguration configuration, string name) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationSection GetRequiredSection(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)128)]
            public sealed class ConfigurationKeyNameAttribute : System.Attribute
            {
                public ConfigurationKeyNameAttribute(string name) => throw null;
                public string Name { get => throw null; }
            }
            public static class ConfigurationPath
            {
                public static string Combine(System.Collections.Generic.IEnumerable<string> pathSegments) => throw null;
                public static string Combine(params string[] pathSegments) => throw null;
                public static string GetParentPath(string path) => throw null;
                public static string GetSectionKey(string path) => throw null;
                public static readonly string KeyDelimiter;
            }
            public static partial class ConfigurationRootExtensions
            {
                public static string GetDebugView(this Microsoft.Extensions.Configuration.IConfigurationRoot root) => throw null;
                public static string GetDebugView(this Microsoft.Extensions.Configuration.IConfigurationRoot root, System.Func<Microsoft.Extensions.Configuration.ConfigurationDebugViewContext, string> processValue) => throw null;
            }
            public interface IConfiguration
            {
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren();
                Microsoft.Extensions.Primitives.IChangeToken GetReloadToken();
                Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key);
                string this[string key] { get; set; }
            }
            public interface IConfigurationBuilder
            {
                Microsoft.Extensions.Configuration.IConfigurationBuilder Add(Microsoft.Extensions.Configuration.IConfigurationSource source);
                Microsoft.Extensions.Configuration.IConfigurationRoot Build();
                System.Collections.Generic.IDictionary<string, object> Properties { get; }
                System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationSource> Sources { get; }
            }
            public interface IConfigurationManager : Microsoft.Extensions.Configuration.IConfiguration, Microsoft.Extensions.Configuration.IConfigurationBuilder
            {
            }
            public interface IConfigurationProvider
            {
                System.Collections.Generic.IEnumerable<string> GetChildKeys(System.Collections.Generic.IEnumerable<string> earlierKeys, string parentPath);
                Microsoft.Extensions.Primitives.IChangeToken GetReloadToken();
                void Load();
                void Set(string key, string value);
                bool TryGet(string key, out string value);
            }
            public interface IConfigurationRoot : Microsoft.Extensions.Configuration.IConfiguration
            {
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationProvider> Providers { get; }
                void Reload();
            }
            public interface IConfigurationSection : Microsoft.Extensions.Configuration.IConfiguration
            {
                string Key { get; }
                string Path { get; }
                string Value { get; set; }
            }
            public interface IConfigurationSource
            {
                Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder);
            }
        }
    }
}
