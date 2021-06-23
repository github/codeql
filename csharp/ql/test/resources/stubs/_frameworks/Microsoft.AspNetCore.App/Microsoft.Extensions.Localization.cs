// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.LocalizationServiceCollectionExtensions` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LocalizationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLocalization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddLocalization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
        namespace Localization
        {
            // Generated from `Microsoft.Extensions.Localization.IResourceNamesCache` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IResourceNamesCache
            {
                System.Collections.Generic.IList<string> GetOrAdd(string name, System.Func<string, System.Collections.Generic.IList<string>> valueFactory);
            }

            // Generated from `Microsoft.Extensions.Localization.LocalizationOptions` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LocalizationOptions
            {
                public LocalizationOptions() => throw null;
                public string ResourcesPath { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.Extensions.Localization.ResourceLocationAttribute` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResourceLocationAttribute : System.Attribute
            {
                public string ResourceLocation { get => throw null; }
                public ResourceLocationAttribute(string resourceLocation) => throw null;
            }

            // Generated from `Microsoft.Extensions.Localization.ResourceManagerStringLocalizer` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResourceManagerStringLocalizer : Microsoft.Extensions.Localization.IStringLocalizer
            {
                public virtual System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                protected System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures, System.Globalization.CultureInfo culture) => throw null;
                protected string GetStringSafely(string name, System.Globalization.CultureInfo culture) => throw null;
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name] { get => throw null; }
                public virtual Microsoft.Extensions.Localization.LocalizedString this[string name, params object[] arguments] { get => throw null; }
                public ResourceManagerStringLocalizer(System.Resources.ResourceManager resourceManager, System.Reflection.Assembly resourceAssembly, string baseName, Microsoft.Extensions.Localization.IResourceNamesCache resourceNamesCache, Microsoft.Extensions.Logging.ILogger logger) => throw null;
            }

            // Generated from `Microsoft.Extensions.Localization.ResourceManagerStringLocalizerFactory` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResourceManagerStringLocalizerFactory : Microsoft.Extensions.Localization.IStringLocalizerFactory
            {
                public Microsoft.Extensions.Localization.IStringLocalizer Create(string baseName, string location) => throw null;
                public Microsoft.Extensions.Localization.IStringLocalizer Create(System.Type resourceSource) => throw null;
                protected virtual Microsoft.Extensions.Localization.ResourceManagerStringLocalizer CreateResourceManagerStringLocalizer(System.Reflection.Assembly assembly, string baseName) => throw null;
                protected virtual Microsoft.Extensions.Localization.ResourceLocationAttribute GetResourceLocationAttribute(System.Reflection.Assembly assembly) => throw null;
                protected virtual string GetResourcePrefix(string location, string baseName, string resourceLocation) => throw null;
                protected virtual string GetResourcePrefix(string baseResourceName, string baseNamespace) => throw null;
                protected virtual string GetResourcePrefix(System.Reflection.TypeInfo typeInfo, string baseNamespace, string resourcesRelativePath) => throw null;
                protected virtual string GetResourcePrefix(System.Reflection.TypeInfo typeInfo) => throw null;
                protected virtual Microsoft.Extensions.Localization.RootNamespaceAttribute GetRootNamespaceAttribute(System.Reflection.Assembly assembly) => throw null;
                public ResourceManagerStringLocalizerFactory(Microsoft.Extensions.Options.IOptions<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
            }

            // Generated from `Microsoft.Extensions.Localization.ResourceNamesCache` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResourceNamesCache : Microsoft.Extensions.Localization.IResourceNamesCache
            {
                public System.Collections.Generic.IList<string> GetOrAdd(string name, System.Func<string, System.Collections.Generic.IList<string>> valueFactory) => throw null;
                public ResourceNamesCache() => throw null;
            }

            // Generated from `Microsoft.Extensions.Localization.RootNamespaceAttribute` in `Microsoft.Extensions.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RootNamespaceAttribute : System.Attribute
            {
                public string RootNamespace { get => throw null; }
                public RootNamespaceAttribute(string rootNamespace) => throw null;
            }

        }
    }
}
