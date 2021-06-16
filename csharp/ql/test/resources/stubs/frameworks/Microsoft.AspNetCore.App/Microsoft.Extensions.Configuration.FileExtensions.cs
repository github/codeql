// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.FileConfigurationExtensions` in `Microsoft.Extensions.Configuration.FileExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class FileConfigurationExtensions
            {
                public static System.Action<Microsoft.Extensions.Configuration.FileLoadExceptionContext> GetFileLoadExceptionHandler(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                public static Microsoft.Extensions.FileProviders.IFileProvider GetFileProvider(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder SetBasePath(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string basePath) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder SetFileLoadExceptionHandler(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.FileLoadExceptionContext> handler) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder SetFileProvider(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, Microsoft.Extensions.FileProviders.IFileProvider fileProvider) => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.FileConfigurationProvider` in `Microsoft.Extensions.Configuration.FileExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class FileConfigurationProvider : Microsoft.Extensions.Configuration.ConfigurationProvider, System.IDisposable
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public FileConfigurationProvider(Microsoft.Extensions.Configuration.FileConfigurationSource source) => throw null;
                public override void Load() => throw null;
                public abstract void Load(System.IO.Stream stream);
                public Microsoft.Extensions.Configuration.FileConfigurationSource Source { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.FileConfigurationSource` in `Microsoft.Extensions.Configuration.FileExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class FileConfigurationSource : Microsoft.Extensions.Configuration.IConfigurationSource
            {
                public abstract Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder);
                public void EnsureDefaults(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                protected FileConfigurationSource() => throw null;
                public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                public System.Action<Microsoft.Extensions.Configuration.FileLoadExceptionContext> OnLoadException { get => throw null; set => throw null; }
                public bool Optional { get => throw null; set => throw null; }
                public string Path { get => throw null; set => throw null; }
                public int ReloadDelay { get => throw null; set => throw null; }
                public bool ReloadOnChange { get => throw null; set => throw null; }
                public void ResolveFileProvider() => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.FileLoadExceptionContext` in `Microsoft.Extensions.Configuration.FileExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileLoadExceptionContext
            {
                public System.Exception Exception { get => throw null; set => throw null; }
                public FileLoadExceptionContext() => throw null;
                public bool Ignore { get => throw null; set => throw null; }
                public Microsoft.Extensions.Configuration.FileConfigurationProvider Provider { get => throw null; set => throw null; }
            }

        }
    }
}
