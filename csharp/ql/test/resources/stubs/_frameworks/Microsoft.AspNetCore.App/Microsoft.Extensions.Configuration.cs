// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            public static partial class ChainedBuilderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddConfiguration(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddConfiguration(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, Microsoft.Extensions.Configuration.IConfiguration config, bool shouldDisposeConfiguration) => throw null;
            }
            public class ChainedConfigurationProvider : Microsoft.Extensions.Configuration.IConfigurationProvider, System.IDisposable
            {
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; }
                public ChainedConfigurationProvider(Microsoft.Extensions.Configuration.ChainedConfigurationSource source) => throw null;
                public void Dispose() => throw null;
                public System.Collections.Generic.IEnumerable<string> GetChildKeys(System.Collections.Generic.IEnumerable<string> earlierKeys, string parentPath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public void Load() => throw null;
                public void Set(string key, string value) => throw null;
                public bool TryGet(string key, out string value) => throw null;
            }
            public class ChainedConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
            {
                public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set { } }
                public ChainedConfigurationSource() => throw null;
                public bool ShouldDisposeConfiguration { get => throw null; set { } }
            }
            public class ConfigurationBuilder : Microsoft.Extensions.Configuration.IConfigurationBuilder
            {
                public Microsoft.Extensions.Configuration.IConfigurationBuilder Add(Microsoft.Extensions.Configuration.IConfigurationSource source) => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationRoot Build() => throw null;
                public ConfigurationBuilder() => throw null;
                public System.Collections.Generic.IDictionary<string, object> Properties { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationSource> Sources { get => throw null; }
            }
            public class ConfigurationKeyComparer : System.Collections.Generic.IComparer<string>
            {
                public int Compare(string x, string y) => throw null;
                public ConfigurationKeyComparer() => throw null;
                public static Microsoft.Extensions.Configuration.ConfigurationKeyComparer Instance { get => throw null; }
            }
            public sealed class ConfigurationManager : Microsoft.Extensions.Configuration.IConfiguration, Microsoft.Extensions.Configuration.IConfigurationBuilder, Microsoft.Extensions.Configuration.IConfigurationManager, Microsoft.Extensions.Configuration.IConfigurationRoot, System.IDisposable
            {
                Microsoft.Extensions.Configuration.IConfigurationBuilder Microsoft.Extensions.Configuration.IConfigurationBuilder.Add(Microsoft.Extensions.Configuration.IConfigurationSource source) => throw null;
                Microsoft.Extensions.Configuration.IConfigurationRoot Microsoft.Extensions.Configuration.IConfigurationBuilder.Build() => throw null;
                public ConfigurationManager() => throw null;
                public void Dispose() => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren() => throw null;
                Microsoft.Extensions.Primitives.IChangeToken Microsoft.Extensions.Configuration.IConfiguration.GetReloadToken() => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key) => throw null;
                System.Collections.Generic.IDictionary<string, object> Microsoft.Extensions.Configuration.IConfigurationBuilder.Properties { get => throw null; }
                System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationProvider> Microsoft.Extensions.Configuration.IConfigurationRoot.Providers { get => throw null; }
                void Microsoft.Extensions.Configuration.IConfigurationRoot.Reload() => throw null;
                public System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationSource> Sources { get => throw null; }
                public string this[string key] { get => throw null; set { } }
            }
            public abstract class ConfigurationProvider : Microsoft.Extensions.Configuration.IConfigurationProvider
            {
                protected ConfigurationProvider() => throw null;
                protected System.Collections.Generic.IDictionary<string, string> Data { get => throw null; set { } }
                public virtual System.Collections.Generic.IEnumerable<string> GetChildKeys(System.Collections.Generic.IEnumerable<string> earlierKeys, string parentPath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public virtual void Load() => throw null;
                protected void OnReload() => throw null;
                public virtual void Set(string key, string value) => throw null;
                public override string ToString() => throw null;
                public virtual bool TryGet(string key, out string value) => throw null;
            }
            public class ConfigurationReloadToken : Microsoft.Extensions.Primitives.IChangeToken
            {
                public bool ActiveChangeCallbacks { get => throw null; }
                public ConfigurationReloadToken() => throw null;
                public bool HasChanged { get => throw null; }
                public void OnReload() => throw null;
                public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
            }
            public class ConfigurationRoot : Microsoft.Extensions.Configuration.IConfiguration, Microsoft.Extensions.Configuration.IConfigurationRoot, System.IDisposable
            {
                public ConfigurationRoot(System.Collections.Generic.IList<Microsoft.Extensions.Configuration.IConfigurationProvider> providers) => throw null;
                public void Dispose() => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren() => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationProvider> Providers { get => throw null; }
                public void Reload() => throw null;
                public string this[string key] { get => throw null; set { } }
            }
            public class ConfigurationSection : Microsoft.Extensions.Configuration.IConfiguration, Microsoft.Extensions.Configuration.IConfigurationSection
            {
                public ConfigurationSection(Microsoft.Extensions.Configuration.IConfigurationRoot root, string path) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Configuration.IConfigurationSection> GetChildren() => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetReloadToken() => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationSection GetSection(string key) => throw null;
                public string Key { get => throw null; }
                public string Path { get => throw null; }
                public string this[string key] { get => throw null; set { } }
                public string Value { get => throw null; set { } }
            }
            namespace Memory
            {
                public class MemoryConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable
                {
                    public void Add(string key, string value) => throw null;
                    public MemoryConfigurationProvider(Microsoft.Extensions.Configuration.Memory.MemoryConfigurationSource source) => throw null;
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                }
                public class MemoryConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
                {
                    public Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public MemoryConfigurationSource() => throw null;
                    public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> InitialData { get => throw null; set { } }
                }
            }
            public static partial class MemoryConfigurationBuilderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddInMemoryCollection(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddInMemoryCollection(this Microsoft.Extensions.Configuration.IConfigurationBuilder configurationBuilder, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> initialData) => throw null;
            }
            public abstract class StreamConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider
            {
                public StreamConfigurationProvider(Microsoft.Extensions.Configuration.StreamConfigurationSource source) => throw null;
                public override void Load() => throw null;
                public abstract void Load(System.IO.Stream stream);
                public Microsoft.Extensions.Configuration.StreamConfigurationSource Source { get => throw null; }
            }
            public abstract class StreamConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
            {
                public abstract Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder);
                protected StreamConfigurationSource() => throw null;
                public System.IO.Stream Stream { get => throw null; set { } }
            }
        }
    }
}
