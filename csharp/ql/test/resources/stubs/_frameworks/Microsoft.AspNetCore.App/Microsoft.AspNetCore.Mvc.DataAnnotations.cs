// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.DataAnnotations, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace DataAnnotations
            {
                public abstract class AttributeAdapterBase<TAttribute> : Microsoft.AspNetCore.Mvc.DataAnnotations.ValidationAttributeAdapter<TAttribute>, Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator where TAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
                {
                    public AttributeAdapterBase(TAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) : base(default(TAttribute), default(Microsoft.Extensions.Localization.IStringLocalizer)) => throw null;
                    public abstract string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase validationContext);
                }
                public interface IAttributeAdapter : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator
                {
                    string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase validationContext);
                }
                public interface IValidationAttributeAdapterProvider
                {
                    Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter GetAttributeAdapter(System.ComponentModel.DataAnnotations.ValidationAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer);
                }
                public class MvcDataAnnotationsLocalizationOptions : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>, System.Collections.IEnumerable
                {
                    public MvcDataAnnotationsLocalizationOptions() => throw null;
                    public System.Func<System.Type, Microsoft.Extensions.Localization.IStringLocalizerFactory, Microsoft.Extensions.Localization.IStringLocalizer> DataAnnotationLocalizerProvider;
                    System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                }
                public sealed class RequiredAttributeAdapter : Microsoft.AspNetCore.Mvc.DataAnnotations.AttributeAdapterBase<System.ComponentModel.DataAnnotations.RequiredAttribute>
                {
                    public override void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context) => throw null;
                    public RequiredAttributeAdapter(System.ComponentModel.DataAnnotations.RequiredAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) : base(default(System.ComponentModel.DataAnnotations.RequiredAttribute), default(Microsoft.Extensions.Localization.IStringLocalizer)) => throw null;
                    public override string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase validationContext) => throw null;
                }
                public abstract class ValidationAttributeAdapter<TAttribute> : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator where TAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
                {
                    public abstract void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context);
                    public TAttribute Attribute { get => throw null; }
                    public ValidationAttributeAdapter(TAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) => throw null;
                    protected virtual string GetErrorMessage(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, params object[] arguments) => throw null;
                    protected static bool MergeAttribute(System.Collections.Generic.IDictionary<string, string> attributes, string key, string value) => throw null;
                }
                public class ValidationAttributeAdapterProvider : Microsoft.AspNetCore.Mvc.DataAnnotations.IValidationAttributeAdapterProvider
                {
                    public ValidationAttributeAdapterProvider() => throw null;
                    public Microsoft.AspNetCore.Mvc.DataAnnotations.IAttributeAdapter GetAttributeAdapter(System.ComponentModel.DataAnnotations.ValidationAttribute attribute, Microsoft.Extensions.Localization.IStringLocalizer stringLocalizer) => throw null;
                }
                public abstract class ValidationProviderAttribute : System.Attribute
                {
                    protected ValidationProviderAttribute() => throw null;
                    public abstract System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationAttribute> GetValidationAttributes();
                }
            }
            [System.AttributeUsage((System.AttributeTargets)132, AllowMultiple = false, Inherited = true)]
            public sealed class HiddenInputAttribute : System.Attribute
            {
                public HiddenInputAttribute() => throw null;
                public bool DisplayValue { get => throw null; set { } }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class MvcDataAnnotationsMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> setupAction) => throw null;
            }
            public static partial class MvcDataAnnotationsMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddDataAnnotations(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddDataAnnotationsLocalization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.DataAnnotations.MvcDataAnnotationsLocalizationOptions> setupAction) => throw null;
            }
        }
    }
}
