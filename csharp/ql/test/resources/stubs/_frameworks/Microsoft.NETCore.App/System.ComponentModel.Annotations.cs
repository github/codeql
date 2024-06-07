// This file contains auto-generated code.
// Generated from `System.ComponentModel.Annotations, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace ComponentModel
    {
        namespace DataAnnotations
        {
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class AllowedValuesAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public AllowedValuesAttribute(params object[] values) => throw null;
                public override bool IsValid(object value) => throw null;
                public object[] Values { get => throw null; }
            }
            public class AssociatedMetadataTypeTypeDescriptionProvider : System.ComponentModel.TypeDescriptionProvider
            {
                public AssociatedMetadataTypeTypeDescriptionProvider(System.Type type) => throw null;
                public AssociatedMetadataTypeTypeDescriptionProvider(System.Type type, System.Type associatedMetadataType) => throw null;
                public override System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(System.Type objectType, object instance) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false, Inherited = true)]
            public sealed class AssociationAttribute : System.Attribute
            {
                public AssociationAttribute(string name, string thisKey, string otherKey) => throw null;
                public bool IsForeignKey { get => throw null; set { } }
                public string Name { get => throw null; }
                public string OtherKey { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> OtherKeyMembers { get => throw null; }
                public string ThisKey { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> ThisKeyMembers { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class Base64StringAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public Base64StringAttribute() => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false)]
            public class CompareAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public CompareAttribute(string otherProperty) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                protected override System.ComponentModel.DataAnnotations.ValidationResult IsValid(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public string OtherProperty { get => throw null; }
                public string OtherPropertyDisplayName { get => throw null; }
                public override bool RequiresValidationContext { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false, Inherited = true)]
            public sealed class ConcurrencyCheckAttribute : System.Attribute
            {
                public ConcurrencyCheckAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public sealed class CreditCardAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public CreditCardAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2500, AllowMultiple = true)]
            public sealed class CustomValidationAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public CustomValidationAttribute(System.Type validatorType, string method) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                protected override System.ComponentModel.DataAnnotations.ValidationResult IsValid(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public string Method { get => throw null; }
                public System.Type ValidatorType { get => throw null; }
            }
            public enum DataType
            {
                Custom = 0,
                DateTime = 1,
                Date = 2,
                Time = 3,
                Duration = 4,
                PhoneNumber = 5,
                Currency = 6,
                Text = 7,
                Html = 8,
                MultilineText = 9,
                EmailAddress = 10,
                Password = 11,
                Url = 12,
                ImageUrl = 13,
                CreditCard = 14,
                PostalCode = 15,
                Upload = 16,
            }
            [System.AttributeUsage((System.AttributeTargets)2496, AllowMultiple = false)]
            public class DataTypeAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public DataTypeAttribute(System.ComponentModel.DataAnnotations.DataType dataType) => throw null;
                public DataTypeAttribute(string customDataType) => throw null;
                public string CustomDataType { get => throw null; }
                public System.ComponentModel.DataAnnotations.DataType DataType { get => throw null; }
                public System.ComponentModel.DataAnnotations.DisplayFormatAttribute DisplayFormat { get => throw null; set { } }
                public virtual string GetDataTypeName() => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class DeniedValuesAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public DeniedValuesAttribute(params object[] values) => throw null;
                public override bool IsValid(object value) => throw null;
                public object[] Values { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2500, AllowMultiple = false)]
            public sealed class DisplayAttribute : System.Attribute
            {
                public bool AutoGenerateField { get => throw null; set { } }
                public bool AutoGenerateFilter { get => throw null; set { } }
                public DisplayAttribute() => throw null;
                public string Description { get => throw null; set { } }
                public bool? GetAutoGenerateField() => throw null;
                public bool? GetAutoGenerateFilter() => throw null;
                public string GetDescription() => throw null;
                public string GetGroupName() => throw null;
                public string GetName() => throw null;
                public int? GetOrder() => throw null;
                public string GetPrompt() => throw null;
                public string GetShortName() => throw null;
                public string GroupName { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public int Order { get => throw null; set { } }
                public string Prompt { get => throw null; set { } }
                public System.Type ResourceType { get => throw null; set { } }
                public string ShortName { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)4, Inherited = true, AllowMultiple = false)]
            public class DisplayColumnAttribute : System.Attribute
            {
                public DisplayColumnAttribute(string displayColumn) => throw null;
                public DisplayColumnAttribute(string displayColumn, string sortColumn) => throw null;
                public DisplayColumnAttribute(string displayColumn, string sortColumn, bool sortDescending) => throw null;
                public string DisplayColumn { get => throw null; }
                public string SortColumn { get => throw null; }
                public bool SortDescending { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
            public class DisplayFormatAttribute : System.Attribute
            {
                public bool ApplyFormatInEditMode { get => throw null; set { } }
                public bool ConvertEmptyStringToNull { get => throw null; set { } }
                public DisplayFormatAttribute() => throw null;
                public string DataFormatString { get => throw null; set { } }
                public string GetNullDisplayText() => throw null;
                public bool HtmlEncode { get => throw null; set { } }
                public string NullDisplayText { get => throw null; set { } }
                public System.Type NullDisplayTextResourceType { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false, Inherited = true)]
            public sealed class EditableAttribute : System.Attribute
            {
                public bool AllowEdit { get => throw null; }
                public bool AllowInitialValue { get => throw null; set { } }
                public EditableAttribute(bool allowEdit) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public sealed class EmailAddressAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public EmailAddressAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2496, AllowMultiple = false)]
            public sealed class EnumDataTypeAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public EnumDataTypeAttribute(System.Type enumType) : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public System.Type EnumType { get => throw null; }
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public sealed class FileExtensionsAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public FileExtensionsAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public string Extensions { get => throw null; set { } }
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
            public sealed class FilterUIHintAttribute : System.Attribute
            {
                public System.Collections.Generic.IDictionary<string, object> ControlParameters { get => throw null; }
                public FilterUIHintAttribute(string filterUIHint) => throw null;
                public FilterUIHintAttribute(string filterUIHint, string presentationLayer) => throw null;
                public FilterUIHintAttribute(string filterUIHint, string presentationLayer, params object[] controlParameters) => throw null;
                public override bool Equals(object obj) => throw null;
                public string FilterUIHint { get => throw null; }
                public override int GetHashCode() => throw null;
                public string PresentationLayer { get => throw null; }
            }
            public interface IValidatableObject
            {
                System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationResult> Validate(System.ComponentModel.DataAnnotations.ValidationContext validationContext);
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false, Inherited = true)]
            public sealed class KeyAttribute : System.Attribute
            {
                public KeyAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class LengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public LengthAttribute(int minimumLength, int maximumLength) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int MaximumLength { get => throw null; }
                public int MinimumLength { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class MaxLengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public MaxLengthAttribute() => throw null;
                public MaxLengthAttribute(int length) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int Length { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
            public sealed class MetadataTypeAttribute : System.Attribute
            {
                public MetadataTypeAttribute(System.Type metadataClassType) => throw null;
                public System.Type MetadataClassType { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class MinLengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public MinLengthAttribute(int length) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int Length { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public sealed class PhoneAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public PhoneAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class RangeAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public bool ConvertValueInInvariantCulture { get => throw null; set { } }
                public RangeAttribute(double minimum, double maximum) => throw null;
                public RangeAttribute(int minimum, int maximum) => throw null;
                public RangeAttribute(System.Type type, string minimum, string maximum) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public object Maximum { get => throw null; }
                public bool MaximumIsExclusive { get => throw null; set { } }
                public object Minimum { get => throw null; }
                public bool MinimumIsExclusive { get => throw null; set { } }
                public System.Type OperandType { get => throw null; }
                public bool ParseLimitsInInvariantCulture { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class RegularExpressionAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public RegularExpressionAttribute(string pattern) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public System.TimeSpan MatchTimeout { get => throw null; }
                public int MatchTimeoutInMilliseconds { get => throw null; set { } }
                public string Pattern { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class RequiredAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public bool AllowEmptyStrings { get => throw null; set { } }
                public RequiredAttribute() => throw null;
                public override bool IsValid(object value) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
            public class ScaffoldColumnAttribute : System.Attribute
            {
                public ScaffoldColumnAttribute(bool scaffold) => throw null;
                public bool Scaffold { get => throw null; }
            }
            namespace Schema
            {
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public class ColumnAttribute : System.Attribute
                {
                    public ColumnAttribute() => throw null;
                    public ColumnAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                    public int Order { get => throw null; set { } }
                    public string TypeName { get => throw null; set { } }
                }
                [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
                public class ComplexTypeAttribute : System.Attribute
                {
                    public ComplexTypeAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public class DatabaseGeneratedAttribute : System.Attribute
                {
                    public DatabaseGeneratedAttribute(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption databaseGeneratedOption) => throw null;
                    public System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption DatabaseGeneratedOption { get => throw null; }
                }
                public enum DatabaseGeneratedOption
                {
                    None = 0,
                    Identity = 1,
                    Computed = 2,
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public class ForeignKeyAttribute : System.Attribute
                {
                    public ForeignKeyAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false)]
                public class InversePropertyAttribute : System.Attribute
                {
                    public InversePropertyAttribute(string property) => throw null;
                    public string Property { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)388, AllowMultiple = false)]
                public class NotMappedAttribute : System.Attribute
                {
                    public NotMappedAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
                public class TableAttribute : System.Attribute
                {
                    public TableAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                    public string Schema { get => throw null; set { } }
                }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public class StringLengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public StringLengthAttribute(int maximumLength) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int MaximumLength { get => throw null; }
                public int MinimumLength { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = false, Inherited = true)]
            public sealed class TimestampAttribute : System.Attribute
            {
                public TimestampAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)384, AllowMultiple = true)]
            public class UIHintAttribute : System.Attribute
            {
                public System.Collections.Generic.IDictionary<string, object> ControlParameters { get => throw null; }
                public UIHintAttribute(string uiHint) => throw null;
                public UIHintAttribute(string uiHint, string presentationLayer) => throw null;
                public UIHintAttribute(string uiHint, string presentationLayer, params object[] controlParameters) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string PresentationLayer { get => throw null; }
                public string UIHint { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)2432, AllowMultiple = false)]
            public sealed class UrlAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public UrlAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override bool IsValid(object value) => throw null;
            }
            public abstract class ValidationAttribute : System.Attribute
            {
                protected ValidationAttribute() => throw null;
                protected ValidationAttribute(System.Func<string> errorMessageAccessor) => throw null;
                protected ValidationAttribute(string errorMessage) => throw null;
                public string ErrorMessage { get => throw null; set { } }
                public string ErrorMessageResourceName { get => throw null; set { } }
                public System.Type ErrorMessageResourceType { get => throw null; set { } }
                protected string ErrorMessageString { get => throw null; }
                public virtual string FormatErrorMessage(string name) => throw null;
                public System.ComponentModel.DataAnnotations.ValidationResult GetValidationResult(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public virtual bool IsValid(object value) => throw null;
                protected virtual System.ComponentModel.DataAnnotations.ValidationResult IsValid(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public virtual bool RequiresValidationContext { get => throw null; }
                public void Validate(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public void Validate(object value, string name) => throw null;
            }
            public sealed class ValidationContext : System.IServiceProvider
            {
                public ValidationContext(object instance) => throw null;
                public ValidationContext(object instance, System.Collections.Generic.IDictionary<object, object> items) => throw null;
                public ValidationContext(object instance, System.IServiceProvider serviceProvider, System.Collections.Generic.IDictionary<object, object> items) => throw null;
                public string DisplayName { get => throw null; set { } }
                public object GetService(System.Type serviceType) => throw null;
                public void InitializeServiceProvider(System.Func<System.Type, object> serviceProvider) => throw null;
                public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                public string MemberName { get => throw null; set { } }
                public object ObjectInstance { get => throw null; }
                public System.Type ObjectType { get => throw null; }
            }
            public class ValidationException : System.Exception
            {
                public ValidationException() => throw null;
                public ValidationException(System.ComponentModel.DataAnnotations.ValidationResult validationResult, System.ComponentModel.DataAnnotations.ValidationAttribute validatingAttribute, object value) => throw null;
                protected ValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public ValidationException(string message) => throw null;
                public ValidationException(string errorMessage, System.ComponentModel.DataAnnotations.ValidationAttribute validatingAttribute, object value) => throw null;
                public ValidationException(string message, System.Exception innerException) => throw null;
                public System.ComponentModel.DataAnnotations.ValidationAttribute ValidationAttribute { get => throw null; }
                public System.ComponentModel.DataAnnotations.ValidationResult ValidationResult { get => throw null; }
                public object Value { get => throw null; }
            }
            public class ValidationResult
            {
                protected ValidationResult(System.ComponentModel.DataAnnotations.ValidationResult validationResult) => throw null;
                public ValidationResult(string errorMessage) => throw null;
                public ValidationResult(string errorMessage, System.Collections.Generic.IEnumerable<string> memberNames) => throw null;
                public string ErrorMessage { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> MemberNames { get => throw null; }
                public static readonly System.ComponentModel.DataAnnotations.ValidationResult Success;
                public override string ToString() => throw null;
            }
            public static class Validator
            {
                public static bool TryValidateObject(object instance, System.ComponentModel.DataAnnotations.ValidationContext validationContext, System.Collections.Generic.ICollection<System.ComponentModel.DataAnnotations.ValidationResult> validationResults) => throw null;
                public static bool TryValidateObject(object instance, System.ComponentModel.DataAnnotations.ValidationContext validationContext, System.Collections.Generic.ICollection<System.ComponentModel.DataAnnotations.ValidationResult> validationResults, bool validateAllProperties) => throw null;
                public static bool TryValidateProperty(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext, System.Collections.Generic.ICollection<System.ComponentModel.DataAnnotations.ValidationResult> validationResults) => throw null;
                public static bool TryValidateValue(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext, System.Collections.Generic.ICollection<System.ComponentModel.DataAnnotations.ValidationResult> validationResults, System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationAttribute> validationAttributes) => throw null;
                public static void ValidateObject(object instance, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public static void ValidateObject(object instance, System.ComponentModel.DataAnnotations.ValidationContext validationContext, bool validateAllProperties) => throw null;
                public static void ValidateProperty(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public static void ValidateValue(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext, System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationAttribute> validationAttributes) => throw null;
            }
        }
    }
}
