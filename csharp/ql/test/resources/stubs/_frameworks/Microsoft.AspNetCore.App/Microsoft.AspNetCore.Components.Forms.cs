// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Forms, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
            namespace Forms
            {
                public class DataAnnotationsValidator : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public DataAnnotationsValidator() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    protected override void OnInitialized() => throw null;
                    protected override void OnParametersSet() => throw null;
                }
                public sealed class EditContext
                {
                    public EditContext(object model) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.FieldIdentifier Field(string fieldName) => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetValidationMessages() => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetValidationMessages(Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public System.Collections.Generic.IEnumerable<string> GetValidationMessages(System.Linq.Expressions.Expression<System.Func<object>> accessor) => throw null;
                    public bool IsModified() => throw null;
                    public bool IsModified(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public bool IsModified(System.Linq.Expressions.Expression<System.Func<object>> accessor) => throw null;
                    public bool IsValid(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public bool IsValid(System.Linq.Expressions.Expression<System.Func<object>> accessor) => throw null;
                    public void MarkAsUnmodified(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public void MarkAsUnmodified() => throw null;
                    public object Model { get => throw null; }
                    public void NotifyFieldChanged(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public void NotifyValidationStateChanged() => throw null;
                    public event System.EventHandler<Microsoft.AspNetCore.Components.Forms.FieldChangedEventArgs> OnFieldChanged;
                    public event System.EventHandler<Microsoft.AspNetCore.Components.Forms.ValidationRequestedEventArgs> OnValidationRequested;
                    public event System.EventHandler<Microsoft.AspNetCore.Components.Forms.ValidationStateChangedEventArgs> OnValidationStateChanged;
                    public Microsoft.AspNetCore.Components.Forms.EditContextProperties Properties { get => throw null; }
                    public bool ShouldUseFieldIdentifiers { get => throw null; set { } }
                    public bool Validate() => throw null;
                }
                public static partial class EditContextDataAnnotationsExtensions
                {
                    public static Microsoft.AspNetCore.Components.Forms.EditContext AddDataAnnotationsValidation(this Microsoft.AspNetCore.Components.Forms.EditContext editContext) => throw null;
                    public static System.IDisposable EnableDataAnnotationsValidation(this Microsoft.AspNetCore.Components.Forms.EditContext editContext) => throw null;
                    public static System.IDisposable EnableDataAnnotationsValidation(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, System.IServiceProvider serviceProvider) => throw null;
                }
                public sealed class EditContextProperties
                {
                    public EditContextProperties() => throw null;
                    public bool Remove(object key) => throw null;
                    public object this[object key] { get => throw null; set { } }
                    public bool TryGetValue(object key, out object value) => throw null;
                }
                public sealed class FieldChangedEventArgs : System.EventArgs
                {
                    public FieldChangedEventArgs(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.FieldIdentifier FieldIdentifier { get => throw null; }
                }
                public struct FieldIdentifier : System.IEquatable<Microsoft.AspNetCore.Components.Forms.FieldIdentifier>
                {
                    public static Microsoft.AspNetCore.Components.Forms.FieldIdentifier Create<TField>(System.Linq.Expressions.Expression<System.Func<TField>> accessor) => throw null;
                    public FieldIdentifier(object model, string fieldName) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Components.Forms.FieldIdentifier otherIdentifier) => throw null;
                    public string FieldName { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public object Model { get => throw null; }
                }
                public sealed class ValidationMessageStore
                {
                    public void Add(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier, string message) => throw null;
                    public void Add(System.Linq.Expressions.Expression<System.Func<object>> accessor, string message) => throw null;
                    public void Add(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier, System.Collections.Generic.IEnumerable<string> messages) => throw null;
                    public void Add(System.Linq.Expressions.Expression<System.Func<object>> accessor, System.Collections.Generic.IEnumerable<string> messages) => throw null;
                    public void Clear() => throw null;
                    public void Clear(System.Linq.Expressions.Expression<System.Func<object>> accessor) => throw null;
                    public void Clear(in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public ValidationMessageStore(Microsoft.AspNetCore.Components.Forms.EditContext editContext) => throw null;
                    public System.Collections.Generic.IEnumerable<string> this[Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier] { get => throw null; }
                    public System.Collections.Generic.IEnumerable<string> this[System.Linq.Expressions.Expression<System.Func<object>> accessor] { get => throw null; }
                }
                public sealed class ValidationRequestedEventArgs : System.EventArgs
                {
                    public ValidationRequestedEventArgs() => throw null;
                    public static readonly Microsoft.AspNetCore.Components.Forms.ValidationRequestedEventArgs Empty;
                }
                public sealed class ValidationStateChangedEventArgs : System.EventArgs
                {
                    public ValidationStateChangedEventArgs() => throw null;
                    public static readonly Microsoft.AspNetCore.Components.Forms.ValidationStateChangedEventArgs Empty;
                }
            }
        }
    }
}
