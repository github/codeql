// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Localization, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class LocalizationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLocalization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLocalization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> setupAction) => throw null;
            }
        }
        namespace Localization
        {
            public interface IResourceNamesCache
            {
                System.Collections.Generic.IList<string> GetOrAdd(string name, System.Func<string, System.Collections.Generic.IList<string>> valueFactory);
            }
            public class LocalizationOptions
            {
                public LocalizationOptions() => throw null;
                public string ResourcesPath { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = false, Inherited = false)]
            public class ResourceLocationAttribute : System.Attribute
            {
                public ResourceLocationAttribute(string resourceLocation) => throw null;
                public string ResourceLocation { get => throw null; }
            }
            public class ResourceManagerStringLocalizer : Microsoft.Extensions.Localization.IStringLocalizer
            {
                public ResourceManagerStringLocalizer(System.Resources.ResourceManager resourceManager, System.Reflection.Assembly resourceAssembly, string baseName, Microsoft.Extensions.Localization.IResourceNamesCache resourceNamesCache, Microsoft.Extensions.Logging.ILogger logger) => throw null;
                public virtual System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                protected System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures, System.Globalization.CultureInfo culture) => throw null;
                protected string GetStringSafely(string name, System.Globalization.CultureInfo culture) => throw null;
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name] { get => throw null; }
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name, params object[] arguments] { get => throw null; }
            }
            public class ResourceManagerStringLocalizerFactory : Microsoft.Extensions.Localization.IStringLocalizerFactory
            {
                public Microsoft.Extensions.Localization.IStringLocalizer Create(System.Type resourceSource) => throw null;
                public Microsoft.Extensions.Localization.IStringLocalizer Create(string baseName, string location) => throw null;
                protected virtual Microsoft.Extensions.Localization.ResourceManagerStringLocalizer CreateResourceManagerStringLocalizer(System.Reflection.Assembly assembly, string baseName) => throw null;
                public ResourceManagerStringLocalizerFactory(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                protected virtual Microsoft.Extensions.Localization.ResourceLocationAttribute GetResourceLocationAttribute(System.Reflection.Assembly assembly) => throw null;
                protected virtual string GetResourcePrefix(System.Reflection.TypeInfo typeInfo) => throw null;
                protected virtual string GetResourcePrefix(System.Reflection.TypeInfo typeInfo, string baseNamespace, string resourcesRelativePath) => throw null;
                protected virtual string GetResourcePrefix(string baseResourceName, string baseNamespace) => throw null;
                protected virtual string GetResourcePrefix(string location, string baseName, string resourceLocation) => throw null;
                protected virtual Microsoft.Extensions.Localization.RootNamespaceAttribute GetRootNamespaceAttribute(System.Reflection.Assembly assembly) => throw null;
            }
            public class ResourceNamesCache : Microsoft.Extensions.Localization.IResourceNamesCache
            {
                public ResourceNamesCache() => throw null;
                public System.Collections.Generic.IList<string> GetOrAdd(string name, System.Func<string, System.Collections.Generic.IList<string>> valueFactory) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = false, Inherited = false)]
            public class RootNamespaceAttribute : System.Attribute
            {
                public RootNamespaceAttribute(string rootNamespace) => throw null;
                public string RootNamespace { get => throw null; }
            }
        }
    }
}
