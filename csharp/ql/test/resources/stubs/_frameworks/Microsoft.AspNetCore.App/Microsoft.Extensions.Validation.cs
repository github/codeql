// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Validation, Version=10.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class ValidationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddValidation(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Validation.ValidationOptions> configureOptions = default(System.Action<Microsoft.Extensions.Validation.ValidationOptions>)) => throw null;
            }
        }
        namespace Validation
        {
            public interface IValidatableInfo
            {
                System.Threading.Tasks.Task ValidateAsync(object value, Microsoft.Extensions.Validation.ValidateContext context, System.Threading.CancellationToken cancellationToken);
            }
            public interface IValidatableInfoResolver
            {
                bool TryGetValidatableParameterInfo(System.Reflection.ParameterInfo parameterInfo, out Microsoft.Extensions.Validation.IValidatableInfo validatableInfo);
                bool TryGetValidatableTypeInfo(System.Type type, out Microsoft.Extensions.Validation.IValidatableInfo validatableInfo);
            }
            [System.AttributeUsage((System.AttributeTargets)2180, AllowMultiple = false, Inherited = true)]
            public sealed class SkipValidationAttribute : System.Attribute
            {
                public SkipValidationAttribute() => throw null;
            }
            public abstract class ValidatableParameterInfo : Microsoft.Extensions.Validation.IValidatableInfo
            {
                protected ValidatableParameterInfo(System.Type parameterType, string name, string displayName) => throw null;
                protected abstract System.ComponentModel.DataAnnotations.ValidationAttribute[] GetValidationAttributes();
                public virtual System.Threading.Tasks.Task ValidateAsync(object value, Microsoft.Extensions.Validation.ValidateContext context, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public abstract class ValidatablePropertyInfo : Microsoft.Extensions.Validation.IValidatableInfo
            {
                protected ValidatablePropertyInfo(System.Type declaringType, System.Type propertyType, string name, string displayName) => throw null;
                protected abstract System.ComponentModel.DataAnnotations.ValidationAttribute[] GetValidationAttributes();
                public virtual System.Threading.Tasks.Task ValidateAsync(object value, Microsoft.Extensions.Validation.ValidateContext context, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4)]
            public sealed class ValidatableTypeAttribute : System.Attribute
            {
                public ValidatableTypeAttribute() => throw null;
            }
            public abstract class ValidatableTypeInfo : Microsoft.Extensions.Validation.IValidatableInfo
            {
                protected ValidatableTypeInfo(System.Type type, System.Collections.Generic.IReadOnlyList<Microsoft.Extensions.Validation.ValidatablePropertyInfo> members) => throw null;
                protected abstract System.ComponentModel.DataAnnotations.ValidationAttribute[] GetValidationAttributes();
                public virtual System.Threading.Tasks.Task ValidateAsync(object value, Microsoft.Extensions.Validation.ValidateContext context, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public sealed class ValidateContext
            {
                public ValidateContext() => throw null;
                public int CurrentDepth { get => throw null; set { } }
                public string CurrentValidationPath { get => throw null; set { } }
                public event System.Action<Microsoft.Extensions.Validation.ValidationErrorContext> OnValidationError;
                public System.ComponentModel.DataAnnotations.ValidationContext ValidationContext { get => throw null; set { } }
                public System.Collections.Generic.Dictionary<string, string[]> ValidationErrors { get => throw null; set { } }
                public Microsoft.Extensions.Validation.ValidationOptions ValidationOptions { get => throw null; set { } }
            }
            public struct ValidationErrorContext
            {
                public object Container { get => throw null; set { } }
                public System.Collections.Generic.IReadOnlyList<string> Errors { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public string Path { get => throw null; set { } }
            }
            public class ValidationOptions
            {
                public ValidationOptions() => throw null;
                public int MaxDepth { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.Extensions.Validation.IValidatableInfoResolver> Resolvers { get => throw null; }
                public bool TryGetValidatableParameterInfo(System.Reflection.ParameterInfo parameterInfo, out Microsoft.Extensions.Validation.IValidatableInfo validatableInfo) => throw null;
                public bool TryGetValidatableTypeInfo(System.Type type, out Microsoft.Extensions.Validation.IValidatableInfo validatableTypeInfo) => throw null;
            }
        }
    }
}
