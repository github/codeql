// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.ChainedBuilderExtensions` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ChainedBuilderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddConfiguration(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, Microsoft.Extensions.Configuration.IConfiguration config, bool shouldDisposeConfiguration) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddConfiguration(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ChainedConfigurationProvider` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ChainedConfigurationProvider : System.IDisposable, Microsoft.Extensions.Configuration.IConfigurationProvider
            {
                public ChainedConfigurationProvider(Microsoft.Extensions.Configuration.ChainedConfigurationSource source) => throw null;
                public void Dispose() => throw null;
                public System.Collections.Generic.IEnumerable<string> GetChildKeys(System.Collections.Generic.IEnumerable<string> earlierKeys, string parentPath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public void Load() => throw null;
                public void Set(string key, string value) => throw null;
                public bool TryGet(string key, out string value) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ChainedConfigurationSource` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ChainedConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
            {
                public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                public ChainedConfigurationSource() => throw null;
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set => throw null; }
                public bool ShouldDisposeConfiguration { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationBuilder` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigurationBuilder : Microsoft.Extensions.Configuration.IConfigurationBuilder
            {
                public Microsoft.Extensions.Configuration.IConfigurationBuilder Add(Microsoft.Extensions.Configuration.IConfigurationSource source) => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationRoot Build() => throw null;
                public ConfigurationBuilder() => throw null;
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationSource> Sources { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationKeyComparer` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigurationKeyComparer : System.Collections.Generic.IComparer<string>
            {
                public int Compare(string x, string y) => throw null;
                public ConfigurationKeyComparer() => throw null;
                public static Microsoft.Extensions.Configuration.ConfigurationKeyComparer Instance { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationProvider` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ConfigurationProvider : Microsoft.Extensions.Configuration.IConfigurationProvider
            {
                protected ConfigurationProvider() => throw null;
                protected System.Collections.Generic.IDictionary<string, string> Data { get => throw null; set => throw null; }
                public virtual System.Collections.Generic.IEnumerable<string> GetChildKeys(System.Collections.Generic.IEnumerable<string> earlierKeys, string parentPath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public virtual void Load() => throw null;
                protected void OnReload() => throw null;
                public virtual void Set(string key, string value) => throw null;
                public override string ToString() => throw null;
                public virtual bool TryGet(string key, out string value) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationReloadToken` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigurationReloadToken : Microsoft.Extensions.Primitives.IChangeToken
            {
                public bool ActiveChangeCallbacks { get => throw null; }
                public ConfigurationReloadToken() => throw null;
                public bool HasChanged { get => throw null; }
                public void OnReload() => throw null;
                public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationRoot` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigurationRoot : System.IDisposable, Microsoft.Extensions.Configuration.IConfigurationRoot, Microsoft.Extensions.Configuration.IConfiguration
            {
                public ConfigurationRoot(System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationProvider> providers) => throw null;
                public void Dispose() => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren() => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key) => throw null;
                public string this[string key] { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationProvider> Providers { get => throw null; }
                public void Reload() => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationSection` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigurationSection : Microsoft.Extensions.Configuration.IConfigurationSection, Microsoft.Extensions.Configuration.IConfiguration
            {
                public ConfigurationSection(Microsoft.Extensions.Configuration.IConfigurationRoot root, string path) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren() => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key) => throw null;
                public string this[string key] { get => throw null; set => throw null; }
                public string Key { get => throw null; }
                public string Path { get => throw null; }
                public string Value { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.Extensions.Configuration.MemoryConfigurationBuilderExtensions` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MemoryConfigurationBuilderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddInMemoryCollection(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> initialData) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddInMemoryCollection(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.StreamConfigurationProvider` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class StreamConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider
            {
                public override void Load() => throw null;
                public abstract void Load(System.IO.Stream stream);
                public Microsoft.Extensions.Configuration.StreamConfigurationSource Source { get => throw null; }
                public StreamConfigurationProvider(Microsoft.Extensions.Configuration.StreamConfigurationSource source) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.StreamConfigurationSource` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class StreamConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
            {
                public abstract Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder);
                public System.IO.Stream Stream { get => throw null; set => throw null; }
                protected StreamConfigurationSource() => throw null;
            }

            namespace Memory
            {
                // Generated from `Microsoft.Extensions.Configuration.Memory.MemoryConfigurationProvider` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>
                {
                    public void Add(string key, string value) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public MemoryConfigurationProvider(Microsoft.Extensions.Configuration.Memory.MemoryConfigurationSource source) => throw null;
                }

                // Generated from `Microsoft.Extensions.Configuration.Memory.MemoryConfigurationSource` in `Microsoft.Extensions.Configuration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MemoryConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> InitialData { get => throw null; set => throw null; }
                    public MemoryConfigurationSource() => throw null;
                }

            }
        }
    }
}
