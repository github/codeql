// This file contains auto-generated code.

namespace System
{
    namespace ComponentModel
    {
        namespace DataAnnotations
        {
            // Generated from `System.ComponentModel.DataAnnotations.AssociatedMetadataTypeTypeDescriptionProvider` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AssociatedMetadataTypeTypeDescriptionProvider : System.ComponentModel.TypeDescriptionProvider
            {
                public AssociatedMetadataTypeTypeDescriptionProvider(System.Type type) => throw null;
                public AssociatedMetadataTypeTypeDescriptionProvider(System.Type type, System.Type associatedMetadataType) => throw null;
                public override System.ComponentModel.ICustomTypeDescriptor GetTypeDescriptor(System.Type objectType, object instance) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.AssociationAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AssociationAttribute : System.Attribute
            {
                public AssociationAttribute(string name, string thisKey, string otherKey) => throw null;
                public bool IsForeignKey { get => throw null; set => throw null; }
                public string Name { get => throw null; }
                public string OtherKey { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> OtherKeyMembers { get => throw null; }
                public string ThisKey { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> ThisKeyMembers { get => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.CompareAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CompareAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public CompareAttribute(string otherProperty) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                protected override System.ComponentModel.DataAnnotations.ValidationResult IsValid(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public string OtherProperty { get => throw null; }
                public string OtherPropertyDisplayName { get => throw null; }
                public override bool RequiresValidationContext { get => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.ConcurrencyCheckAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ConcurrencyCheckAttribute : System.Attribute
            {
                public ConcurrencyCheckAttribute() => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.CreditCardAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CreditCardAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public CreditCardAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override bool IsValid(object value) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.CustomValidationAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CustomValidationAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public CustomValidationAttribute(System.Type validatorType, string method) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                protected override System.ComponentModel.DataAnnotations.ValidationResult IsValid(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public string Method { get => throw null; }
                public System.Type ValidatorType { get => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.DataType` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum DataType
            {
                CreditCard,
                Currency,
                Custom,
                Date,
                DateTime,
                Duration,
                EmailAddress,
                Html,
                ImageUrl,
                MultilineText,
                Password,
                PhoneNumber,
                PostalCode,
                Text,
                Time,
                Upload,
                Url,
            }

            // Generated from `System.ComponentModel.DataAnnotations.DataTypeAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataTypeAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public string CustomDataType { get => throw null; }
                public System.ComponentModel.DataAnnotations.DataType DataType { get => throw null; }
                public DataTypeAttribute(System.ComponentModel.DataAnnotations.DataType dataType) => throw null;
                public DataTypeAttribute(string customDataType) => throw null;
                public System.ComponentModel.DataAnnotations.DisplayFormatAttribute DisplayFormat { get => throw null; set => throw null; }
                public virtual string GetDataTypeName() => throw null;
                public override bool IsValid(object value) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.DisplayAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DisplayAttribute : System.Attribute
            {
                public bool AutoGenerateField { get => throw null; set => throw null; }
                public bool AutoGenerateFilter { get => throw null; set => throw null; }
                public string Description { get => throw null; set => throw null; }
                public DisplayAttribute() => throw null;
                public bool? GetAutoGenerateField() => throw null;
                public bool? GetAutoGenerateFilter() => throw null;
                public string GetDescription() => throw null;
                public string GetGroupName() => throw null;
                public string GetName() => throw null;
                public int? GetOrder() => throw null;
                public string GetPrompt() => throw null;
                public string GetShortName() => throw null;
                public string GroupName { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                public string Prompt { get => throw null; set => throw null; }
                public System.Type ResourceType { get => throw null; set => throw null; }
                public string ShortName { get => throw null; set => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.DisplayColumnAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DisplayColumnAttribute : System.Attribute
            {
                public string DisplayColumn { get => throw null; }
                public DisplayColumnAttribute(string displayColumn) => throw null;
                public DisplayColumnAttribute(string displayColumn, string sortColumn) => throw null;
                public DisplayColumnAttribute(string displayColumn, string sortColumn, bool sortDescending) => throw null;
                public string SortColumn { get => throw null; }
                public bool SortDescending { get => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.DisplayFormatAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DisplayFormatAttribute : System.Attribute
            {
                public bool ApplyFormatInEditMode { get => throw null; set => throw null; }
                public bool ConvertEmptyStringToNull { get => throw null; set => throw null; }
                public string DataFormatString { get => throw null; set => throw null; }
                public DisplayFormatAttribute() => throw null;
                public string GetNullDisplayText() => throw null;
                public bool HtmlEncode { get => throw null; set => throw null; }
                public string NullDisplayText { get => throw null; set => throw null; }
                public System.Type NullDisplayTextResourceType { get => throw null; set => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.EditableAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EditableAttribute : System.Attribute
            {
                public bool AllowEdit { get => throw null; }
                public bool AllowInitialValue { get => throw null; set => throw null; }
                public EditableAttribute(bool allowEdit) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.EmailAddressAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EmailAddressAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public EmailAddressAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override bool IsValid(object value) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.EnumDataTypeAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EnumDataTypeAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public EnumDataTypeAttribute(System.Type enumType) : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public System.Type EnumType { get => throw null; }
                public override bool IsValid(object value) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.FileExtensionsAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FileExtensionsAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public string Extensions { get => throw null; set => throw null; }
                public FileExtensionsAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.FilterUIHintAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FilterUIHintAttribute : System.Attribute
            {
                public System.Collections.Generic.IDictionary<string, object> ControlParameters { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public string FilterUIHint { get => throw null; }
                public FilterUIHintAttribute(string filterUIHint) => throw null;
                public FilterUIHintAttribute(string filterUIHint, string presentationLayer) => throw null;
                public FilterUIHintAttribute(string filterUIHint, string presentationLayer, params object[] controlParameters) => throw null;
                public override int GetHashCode() => throw null;
                public string PresentationLayer { get => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.IValidatableObject` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IValidatableObject
            {
                System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationResult> Validate(System.ComponentModel.DataAnnotations.ValidationContext validationContext);
            }

            // Generated from `System.ComponentModel.DataAnnotations.KeyAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class KeyAttribute : System.Attribute
            {
                public KeyAttribute() => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.MaxLengthAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MaxLengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int Length { get => throw null; }
                public MaxLengthAttribute() => throw null;
                public MaxLengthAttribute(int length) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.MetadataTypeAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MetadataTypeAttribute : System.Attribute
            {
                public System.Type MetadataClassType { get => throw null; }
                public MetadataTypeAttribute(System.Type metadataClassType) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.MinLengthAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MinLengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int Length { get => throw null; }
                public MinLengthAttribute(int length) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.PhoneAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PhoneAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public override bool IsValid(object value) => throw null;
                public PhoneAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.RangeAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RangeAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public bool ConvertValueInInvariantCulture { get => throw null; set => throw null; }
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public object Maximum { get => throw null; }
                public object Minimum { get => throw null; }
                public System.Type OperandType { get => throw null; }
                public bool ParseLimitsInInvariantCulture { get => throw null; set => throw null; }
                public RangeAttribute(System.Type type, string minimum, string maximum) => throw null;
                public RangeAttribute(double minimum, double maximum) => throw null;
                public RangeAttribute(int minimum, int maximum) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.RegularExpressionAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RegularExpressionAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int MatchTimeoutInMilliseconds { get => throw null; set => throw null; }
                public string Pattern { get => throw null; }
                public RegularExpressionAttribute(string pattern) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.RequiredAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RequiredAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public bool AllowEmptyStrings { get => throw null; set => throw null; }
                public override bool IsValid(object value) => throw null;
                public RequiredAttribute() => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.ScaffoldColumnAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ScaffoldColumnAttribute : System.Attribute
            {
                public bool Scaffold { get => throw null; }
                public ScaffoldColumnAttribute(bool scaffold) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.StringLengthAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StringLengthAttribute : System.ComponentModel.DataAnnotations.ValidationAttribute
            {
                public override string FormatErrorMessage(string name) => throw null;
                public override bool IsValid(object value) => throw null;
                public int MaximumLength { get => throw null; }
                public int MinimumLength { get => throw null; set => throw null; }
                public StringLengthAttribute(int maximumLength) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.TimestampAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TimestampAttribute : System.Attribute
            {
                public TimestampAttribute() => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.UIHintAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UIHintAttribute : System.Attribute
            {
                public System.Collections.Generic.IDictionary<string, object> ControlParameters { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string PresentationLayer { get => throw null; }
                public string UIHint { get => throw null; }
                public UIHintAttribute(string uiHint) => throw null;
                public UIHintAttribute(string uiHint, string presentationLayer) => throw null;
                public UIHintAttribute(string uiHint, string presentationLayer, params object[] controlParameters) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.UrlAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class UrlAttribute : System.ComponentModel.DataAnnotations.DataTypeAttribute
            {
                public override bool IsValid(object value) => throw null;
                public UrlAttribute() : base(default(System.ComponentModel.DataAnnotations.DataType)) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.ValidationAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ValidationAttribute : System.Attribute
            {
                public string ErrorMessage { get => throw null; set => throw null; }
                public string ErrorMessageResourceName { get => throw null; set => throw null; }
                public System.Type ErrorMessageResourceType { get => throw null; set => throw null; }
                protected string ErrorMessageString { get => throw null; }
                public virtual string FormatErrorMessage(string name) => throw null;
                public System.ComponentModel.DataAnnotations.ValidationResult GetValidationResult(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public virtual bool IsValid(object value) => throw null;
                protected virtual System.ComponentModel.DataAnnotations.ValidationResult IsValid(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public virtual bool RequiresValidationContext { get => throw null; }
                public void Validate(object value, System.ComponentModel.DataAnnotations.ValidationContext validationContext) => throw null;
                public void Validate(object value, string name) => throw null;
                protected ValidationAttribute() => throw null;
                protected ValidationAttribute(System.Func<string> errorMessageAccessor) => throw null;
                protected ValidationAttribute(string errorMessage) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.ValidationContext` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ValidationContext : System.IServiceProvider
            {
                public string DisplayName { get => throw null; set => throw null; }
                public object GetService(System.Type serviceType) => throw null;
                public void InitializeServiceProvider(System.Func<System.Type, object> serviceProvider) => throw null;
                public System.Collections.Generic.IDictionary<object, object> Items { get => throw null; }
                public string MemberName { get => throw null; set => throw null; }
                public object ObjectInstance { get => throw null; }
                public System.Type ObjectType { get => throw null; }
                public ValidationContext(object instance) => throw null;
                public ValidationContext(object instance, System.Collections.Generic.IDictionary<object, object> items) => throw null;
                public ValidationContext(object instance, System.IServiceProvider serviceProvider, System.Collections.Generic.IDictionary<object, object> items) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.ValidationException` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ValidationException : System.Exception
            {
                public System.ComponentModel.DataAnnotations.ValidationAttribute ValidationAttribute { get => throw null; }
                public ValidationException() => throw null;
                protected ValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public ValidationException(System.ComponentModel.DataAnnotations.ValidationResult validationResult, System.ComponentModel.DataAnnotations.ValidationAttribute validatingAttribute, object value) => throw null;
                public ValidationException(string message) => throw null;
                public ValidationException(string message, System.Exception innerException) => throw null;
                public ValidationException(string errorMessage, System.ComponentModel.DataAnnotations.ValidationAttribute validatingAttribute, object value) => throw null;
                public System.ComponentModel.DataAnnotations.ValidationResult ValidationResult { get => throw null; }
                public object Value { get => throw null; }
            }

            // Generated from `System.ComponentModel.DataAnnotations.ValidationResult` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ValidationResult
            {
                public string ErrorMessage { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<string> MemberNames { get => throw null; }
                public static System.ComponentModel.DataAnnotations.ValidationResult Success;
                public override string ToString() => throw null;
                protected ValidationResult(System.ComponentModel.DataAnnotations.ValidationResult validationResult) => throw null;
                public ValidationResult(string errorMessage) => throw null;
                public ValidationResult(string errorMessage, System.Collections.Generic.IEnumerable<string> memberNames) => throw null;
            }

            // Generated from `System.ComponentModel.DataAnnotations.Validator` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            namespace Schema
            {
                // Generated from `System.ComponentModel.DataAnnotations.Schema.ColumnAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ColumnAttribute : System.Attribute
                {
                    public ColumnAttribute() => throw null;
                    public ColumnAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                    public int Order { get => throw null; set => throw null; }
                    public string TypeName { get => throw null; set => throw null; }
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.ComplexTypeAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ComplexTypeAttribute : System.Attribute
                {
                    public ComplexTypeAttribute() => throw null;
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class DatabaseGeneratedAttribute : System.Attribute
                {
                    public DatabaseGeneratedAttribute(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption databaseGeneratedOption) => throw null;
                    public System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption DatabaseGeneratedOption { get => throw null; }
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum DatabaseGeneratedOption
                {
                    Computed,
                    Identity,
                    None,
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.ForeignKeyAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ForeignKeyAttribute : System.Attribute
                {
                    public ForeignKeyAttribute(string name) => throw null;
                    public string Name { get => throw null; }
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.InversePropertyAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class InversePropertyAttribute : System.Attribute
                {
                    public InversePropertyAttribute(string property) => throw null;
                    public string Property { get => throw null; }
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class NotMappedAttribute : System.Attribute
                {
                    public NotMappedAttribute() => throw null;
                }

                // Generated from `System.ComponentModel.DataAnnotations.Schema.TableAttribute` in `System.ComponentModel.Annotations, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class TableAttribute : System.Attribute
                {
                    public string Name { get => throw null; }
                    public string Schema { get => throw null; set => throw null; }
                    public TableAttribute(string name) => throw null;
                }

            }
        }
    }
}
