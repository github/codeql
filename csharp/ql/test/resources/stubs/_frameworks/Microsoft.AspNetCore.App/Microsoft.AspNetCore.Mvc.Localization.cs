// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace Localization
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Localization.HtmlLocalizer` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlLocalizer : Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer
                {
                    public virtual System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                    public virtual Microsoft.Extensions.Localization.LocalizedString GetString(string name, params object[] arguments) => throw null;
                    public virtual Microsoft.Extensions.Localization.LocalizedString GetString(string name) => throw null;
                    public HtmlLocalizer(Microsoft.Extensions.Localization.IStringLocalizer localizer) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string name] { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string name, params object[] arguments] { get => throw null; }
                    protected virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString ToHtmlString(Microsoft.Extensions.Localization.LocalizedString result, object[] arguments) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString ToHtmlString(Microsoft.Extensions.Localization.LocalizedString result) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.HtmlLocalizer<>` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlLocalizer<TResource> : Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer<TResource>, Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer
                {
                    public virtual System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                    public virtual Microsoft.Extensions.Localization.LocalizedString GetString(string name, params object[] arguments) => throw null;
                    public virtual Microsoft.Extensions.Localization.LocalizedString GetString(string name) => throw null;
                    public HtmlLocalizer(Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizerFactory factory) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string name] { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string name, params object[] arguments] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.HtmlLocalizerExtensions` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HtmlLocalizerExtensions
                {
                    public static System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(this Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer htmlLocalizer) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString GetHtml(this Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer htmlLocalizer, string name, params object[] arguments) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString GetHtml(this Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer htmlLocalizer, string name) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.HtmlLocalizerFactory` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HtmlLocalizerFactory : Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizerFactory
                {
                    public virtual Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer Create(string baseName, string location) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer Create(System.Type resourceSource) => throw null;
                    public HtmlLocalizerFactory(Microsoft.Extensions.Localization.IStringLocalizerFactory localizerFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHtmlLocalizer
                {
                    System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures);
                    Microsoft.Extensions.Localization.LocalizedString GetString(string name, params object[] arguments);
                    Microsoft.Extensions.Localization.LocalizedString GetString(string name);
                    Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string name] { get; }
                    Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string name, params object[] arguments] { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer<>` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHtmlLocalizer<TResource> : Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizerFactory` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHtmlLocalizerFactory
                {
                    Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer Create(string baseName, string location);
                    Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer Create(System.Type resourceSource);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.IViewLocalizer` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IViewLocalizer : Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LocalizedHtmlString : Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public bool IsResourceNotFound { get => throw null; }
                    public LocalizedHtmlString(string name, string value, bool isResourceNotFound, params object[] arguments) => throw null;
                    public LocalizedHtmlString(string name, string value, bool isResourceNotFound) => throw null;
                    public LocalizedHtmlString(string name, string value) => throw null;
                    public string Name { get => throw null; }
                    public string Value { get => throw null; }
                    public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Localization.ViewLocalizer` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ViewLocalizer : Microsoft.AspNetCore.Mvc.ViewFeatures.IViewContextAware, Microsoft.AspNetCore.Mvc.Localization.IViewLocalizer, Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizer
                {
                    public void Contextualize(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.Extensions.Localization.LocalizedString> GetAllStrings(bool includeParentCultures) => throw null;
                    public Microsoft.Extensions.Localization.LocalizedString GetString(string name, params object[] values) => throw null;
                    public Microsoft.Extensions.Localization.LocalizedString GetString(string name) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string key] { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.Localization.LocalizedHtmlString this[string key, params object[] arguments] { get => throw null; }
                    public ViewLocalizer(Microsoft.AspNetCore.Mvc.Localization.IHtmlLocalizerFactory localizerFactory, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.MvcLocalizationMvcBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcLocalizationMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcLocalizationMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcLocalizationMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> localizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> dataAnnotationsLocalizationOptionsSetupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format, System.Action<Microsoft.Extensions.Localization.LocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddViewLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
            }

        }
    }
}
