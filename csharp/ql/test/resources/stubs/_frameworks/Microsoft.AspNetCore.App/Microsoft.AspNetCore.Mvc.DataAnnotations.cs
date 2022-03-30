// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            // Generated from `Microsoft.AspNetCore.Mvc.HiddenInputAttribute` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HiddenInputAttribute : System.Attribute
            {
                public bool DisplayValue { get => throw null; set => throw null; }
                public HiddenInputAttribute() => throw null;
            }

            namespace DataAnnotations
            {
                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.AttributeAdapterBase<>` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class AttributeAdapterBase<TAttribute> : Microsoft.AspNetCore.Mvc.DataAnnotations.ValidationAttributeAdapter<TAttribute>, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator, Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter where TAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
                {
                    public AttributeAdapterBase(TAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) : base(default(TAttribute), default(Microsoft.Extensions.Localization.IStringLocalizer)) => throw null;
                    public abstract string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase validationContext);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAttributeAdapter : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator
                {
                    string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase validationContext);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.IValidationAttributeAdapterProvider` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IValidationAttributeAdapterProvider
                {
                    Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter GetAttributeAdapter(System.ComponentModel.DataAnnotations.ValidationAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MvcDataAnnotationsLocalizationOptions : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>
                {
                    public System.Func<System.Type, Microsoft.Extensions.Localization.IStringLocalizerFactory, Microsoft.Extensions.Localization.IStringLocalizer> DataAnnotationLocalizerProvider;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                    public MvcDataAnnotationsLocalizationOptions() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.RequiredAttributeAdapter` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RequiredAttributeAdapter : Microsoft.AspNetCore.Mvc.DataAnnotations.AttributeAdapterBase<System.ComponentModel.DataAnnotations.RequiredAttribute>
                {
                    public override void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context) => throw null;
                    public override string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase validationContext) => throw null;
                    public RequiredAttributeAdapter(System.ComponentModel.DataAnnotations.RequiredAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) : base(default(System.ComponentModel.DataAnnotations.RequiredAttribute), default(Microsoft.Extensions.Localization.IStringLocalizer)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.ValidationAttributeAdapter<>` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ValidationAttributeAdapter<TAttribute> : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator where TAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
                {
                    public abstract void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context);
                    public TAttribute Attribute { get => throw null; }
                    protected virtual string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, params object[] arguments) => throw null;
                    protected static bool MergeAttribute(System.Collections.Generic.IDictionary<string, string> attributes, string key, string value) => throw null;
                    public ValidationAttributeAdapter(TAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.ValidationAttributeAdapterProvider` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ValidationAttributeAdapterProvider : Microsoft.AspNetCore.Mvc.DataAnnotations.IValidationAttributeAdapterProvider
                {
                    public Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter GetAttributeAdapter(System.ComponentModel.DataAnnotations.ValidationAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) => throw null;
                    public ValidationAttributeAdapterProvider() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations.ValidationProviderAttribute` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ValidationProviderAttribute : System.Attribute
                {
                    public abstract System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationAttribute> GetValidationAttributes();
                    protected ValidationProviderAttribute() => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.MvcDataAnnotationsMvcBuilderExtensions` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcDataAnnotationsMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcDataAnnotationsMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcDataAnnotationsMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddDataAnnotations(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
            }

        }
    }
}
