// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
            // Generated from `Microsoft.AspNetCore.Components.BindInputElementAttribute` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BindInputElementAttribute : System.Attribute
            {
                public BindInputElementAttribute(string type, string suffix, string valueAttribute, string changeAttribute, bool isInvariantCulture, string format) => throw null;
                public string ChangeAttribute { get => throw null; }
                public string Format { get => throw null; }
                public bool IsInvariantCulture { get => throw null; }
                public string Suffix { get => throw null; }
                public string Type { get => throw null; }
                public string ValueAttribute { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Components.ElementReferenceExtensions` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ElementReferenceExtensions
            {
                public static System.Threading.Tasks.ValueTask FocusAsync(this Microsoft.AspNetCore.Components.ElementReference elementReference) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Components.WebElementReferenceContext` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WebElementReferenceContext : Microsoft.AspNetCore.Components.ElementReferenceContext
            {
                public WebElementReferenceContext(Microsoft.JSInterop.IJSRuntime jsRuntime) => throw null;
            }

            namespace Forms
            {
                // Generated from `Microsoft.AspNetCore.Components.Forms.BrowserFileExtensions` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class BrowserFileExtensions
                {
                    public static System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Forms.IBrowserFile> RequestImageFileAsync(this Microsoft.AspNetCore.Components.Forms.IBrowserFile browserFile, string format, int maxWith, int maxHeight) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.EditContextFieldClassExtensions` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class EditContextFieldClassExtensions
                {
                    public static string FieldCssClass<TField>(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, System.Linq.Expressions.Expression<System.Func<TField>> accessor) => throw null;
                    public static string FieldCssClass(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public static void SetFieldCssClassProvider(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldCssClassProvider fieldCssClassProvider) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.EditForm` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EditForm : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Forms.EditContext> ChildContent { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.Forms.EditContext EditContext { get => throw null; set => throw null; }
                    public EditForm() => throw null;
                    public object Model { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.EditContext> OnInvalidSubmit { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.EditContext> OnSubmit { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.EditContext> OnValidSubmit { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.FieldCssClassProvider` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FieldCssClassProvider
                {
                    public FieldCssClassProvider() => throw null;
                    public virtual string GetFieldCssClass(Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.IBrowserFile` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IBrowserFile
                {
                    string ContentType { get; }
                    System.DateTimeOffset LastModified { get; }
                    string Name { get; }
                    System.IO.Stream OpenReadStream(System.Int64 maxAllowedSize = default(System.Int64), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Int64 Size { get; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.IInputFileJsCallbacks` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IInputFileJsCallbacks
                {
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputBase<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class InputBase<TValue> : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected string CssClass { get => throw null; }
                    protected TValue CurrentValue { get => throw null; set => throw null; }
                    protected string CurrentValueAsString { get => throw null; set => throw null; }
                    public string DisplayName { get => throw null; set => throw null; }
                    void System.IDisposable.Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    protected Microsoft.AspNetCore.Components.Forms.EditContext EditContext { get => throw null; set => throw null; }
                    protected internal Microsoft.AspNetCore.Components.Forms.FieldIdentifier FieldIdentifier { get => throw null; set => throw null; }
                    protected virtual string FormatValueAsString(TValue value) => throw null;
                    protected InputBase() => throw null;
                    public override System.Threading.Tasks.Task SetParametersAsync(Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                    protected abstract bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage);
                    public TValue Value { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.EventCallback<TValue> ValueChanged { get => throw null; set => throw null; }
                    public System.Linq.Expressions.Expression<System.Func<TValue>> ValueExpression { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputCheckbox` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputCheckbox : Microsoft.AspNetCore.Components.Forms.InputBase<bool>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputCheckbox() => throw null;
                    protected override bool TryParseValueFromString(string value, out bool result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputDate<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputDate<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    protected override string FormatValueAsString(TValue value) => throw null;
                    public InputDate() => throw null;
                    public string ParsingErrorMessage { get => throw null; set => throw null; }
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputFile` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputFile : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    public InputFile() => throw null;
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.InputFileChangeEventArgs> OnChange { get => throw null; set => throw null; }
                    protected override void OnInitialized() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputFileChangeEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputFileChangeEventArgs : System.EventArgs
                {
                    public Microsoft.AspNetCore.Components.Forms.IBrowserFile File { get => throw null; }
                    public int FileCount { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Components.Forms.IBrowserFile> GetMultipleFiles(int maximumFileCount = default(int)) => throw null;
                    public InputFileChangeEventArgs(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Components.Forms.IBrowserFile> files) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputNumber<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputNumber<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    protected override string FormatValueAsString(TValue value) => throw null;
                    public InputNumber() => throw null;
                    public string ParsingErrorMessage { get => throw null; set => throw null; }
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputRadio<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputRadio<TValue> : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputRadio() => throw null;
                    public string Name { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    public TValue Value { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputRadioGroup<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputRadioGroup<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    public InputRadioGroup() => throw null;
                    public string Name { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputSelect<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputSelect<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    public InputSelect() => throw null;
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputText` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputText : Microsoft.AspNetCore.Components.Forms.InputBase<string>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputText() => throw null;
                    protected override bool TryParseValueFromString(string value, out string result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.InputTextArea` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputTextArea : Microsoft.AspNetCore.Components.Forms.InputBase<string>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputTextArea() => throw null;
                    protected override bool TryParseValueFromString(string value, out string result, out string validationErrorMessage) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.RemoteBrowserFileStreamOptions` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RemoteBrowserFileStreamOptions
                {
                    public int MaxBufferSize { get => throw null; set => throw null; }
                    public int MaxSegmentSize { get => throw null; set => throw null; }
                    public RemoteBrowserFileStreamOptions() => throw null;
                    public System.TimeSpan SegmentFetchTimeout { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.ValidationMessage<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ValidationMessage<TValue> : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public System.Linq.Expressions.Expression<System.Func<TValue>> For { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    public ValidationMessage() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Forms.ValidationSummary` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ValidationSummary : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public object Model { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    public ValidationSummary() => throw null;
                }

            }
            namespace RenderTree
            {
                // Generated from `Microsoft.AspNetCore.Components.RenderTree.WebEventDescriptor` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class WebEventDescriptor
                {
                    public int BrowserRendererId { get => throw null; set => throw null; }
                    public string EventArgsType { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.RenderTree.EventFieldInfo EventFieldInfo { get => throw null; set => throw null; }
                    public System.UInt64 EventHandlerId { get => throw null; set => throw null; }
                    public WebEventDescriptor() => throw null;
                }

            }
            namespace Routing
            {
                // Generated from `Microsoft.AspNetCore.Components.Routing.NavLink` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NavLink : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public string ActiveClass { get => throw null; set => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    protected string CssClass { get => throw null; set => throw null; }
                    public void Dispose() => throw null;
                    public Microsoft.AspNetCore.Components.Routing.NavLinkMatch Match { get => throw null; set => throw null; }
                    public NavLink() => throw null;
                    protected override void OnInitialized() => throw null;
                    protected override void OnParametersSet() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Routing.NavLinkMatch` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum NavLinkMatch
                {
                    All,
                    Prefix,
                }

            }
            namespace Web
            {
                // Generated from `Microsoft.AspNetCore.Components.Web.BindAttributes` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class BindAttributes
                {
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.ClipboardEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ClipboardEventArgs : System.EventArgs
                {
                    public ClipboardEventArgs() => throw null;
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.DataTransfer` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DataTransfer
                {
                    public DataTransfer() => throw null;
                    public string DropEffect { get => throw null; set => throw null; }
                    public string EffectAllowed { get => throw null; set => throw null; }
                    public string[] Files { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.Web.DataTransferItem[] Items { get => throw null; set => throw null; }
                    public string[] Types { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.DataTransferItem` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DataTransferItem
                {
                    public DataTransferItem() => throw null;
                    public string Kind { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.DragEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DragEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public Microsoft.AspNetCore.Components.Web.DataTransfer DataTransfer { get => throw null; set => throw null; }
                    public DragEventArgs() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.ErrorEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ErrorEventArgs : System.EventArgs
                {
                    public int Colno { get => throw null; set => throw null; }
                    public ErrorEventArgs() => throw null;
                    public string Filename { get => throw null; set => throw null; }
                    public int Lineno { get => throw null; set => throw null; }
                    public string Message { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.EventHandlers` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class EventHandlers
                {
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.FocusEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FocusEventArgs : System.EventArgs
                {
                    public FocusEventArgs() => throw null;
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.KeyboardEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class KeyboardEventArgs : System.EventArgs
                {
                    public bool AltKey { get => throw null; set => throw null; }
                    public string Code { get => throw null; set => throw null; }
                    public bool CtrlKey { get => throw null; set => throw null; }
                    public string Key { get => throw null; set => throw null; }
                    public KeyboardEventArgs() => throw null;
                    public float Location { get => throw null; set => throw null; }
                    public bool MetaKey { get => throw null; set => throw null; }
                    public bool Repeat { get => throw null; set => throw null; }
                    public bool ShiftKey { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.MouseEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MouseEventArgs : System.EventArgs
                {
                    public bool AltKey { get => throw null; set => throw null; }
                    public System.Int64 Button { get => throw null; set => throw null; }
                    public System.Int64 Buttons { get => throw null; set => throw null; }
                    public double ClientX { get => throw null; set => throw null; }
                    public double ClientY { get => throw null; set => throw null; }
                    public bool CtrlKey { get => throw null; set => throw null; }
                    public System.Int64 Detail { get => throw null; set => throw null; }
                    public bool MetaKey { get => throw null; set => throw null; }
                    public MouseEventArgs() => throw null;
                    public double OffsetX { get => throw null; set => throw null; }
                    public double OffsetY { get => throw null; set => throw null; }
                    public double ScreenX { get => throw null; set => throw null; }
                    public double ScreenY { get => throw null; set => throw null; }
                    public bool ShiftKey { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.PointerEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PointerEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public float Height { get => throw null; set => throw null; }
                    public bool IsPrimary { get => throw null; set => throw null; }
                    public PointerEventArgs() => throw null;
                    public System.Int64 PointerId { get => throw null; set => throw null; }
                    public string PointerType { get => throw null; set => throw null; }
                    public float Pressure { get => throw null; set => throw null; }
                    public float TiltX { get => throw null; set => throw null; }
                    public float TiltY { get => throw null; set => throw null; }
                    public float Width { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.ProgressEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ProgressEventArgs : System.EventArgs
                {
                    public bool LengthComputable { get => throw null; set => throw null; }
                    public System.Int64 Loaded { get => throw null; set => throw null; }
                    public ProgressEventArgs() => throw null;
                    public System.Int64 Total { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.TouchEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TouchEventArgs : System.EventArgs
                {
                    public bool AltKey { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.Web.TouchPoint[] ChangedTouches { get => throw null; set => throw null; }
                    public bool CtrlKey { get => throw null; set => throw null; }
                    public System.Int64 Detail { get => throw null; set => throw null; }
                    public bool MetaKey { get => throw null; set => throw null; }
                    public bool ShiftKey { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.Web.TouchPoint[] TargetTouches { get => throw null; set => throw null; }
                    public TouchEventArgs() => throw null;
                    public Microsoft.AspNetCore.Components.Web.TouchPoint[] Touches { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.TouchPoint` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TouchPoint
                {
                    public double ClientX { get => throw null; set => throw null; }
                    public double ClientY { get => throw null; set => throw null; }
                    public System.Int64 Identifier { get => throw null; set => throw null; }
                    public double PageX { get => throw null; set => throw null; }
                    public double PageY { get => throw null; set => throw null; }
                    public double ScreenX { get => throw null; set => throw null; }
                    public double ScreenY { get => throw null; set => throw null; }
                    public TouchPoint() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.WebEventCallbackFactoryEventArgsExtensions` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class WebEventCallbackFactoryEventArgsExtensions
                {
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.WheelEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.WheelEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.WheelEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.WheelEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.TouchEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.TouchEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.TouchEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.TouchEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ProgressEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.PointerEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.PointerEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.PointerEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.PointerEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.MouseEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.MouseEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.MouseEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.MouseEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.FocusEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.FocusEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.FocusEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.FocusEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ErrorEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.DragEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.DragEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.DragEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.DragEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> callback) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.WebRenderTreeBuilderExtensions` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class WebRenderTreeBuilderExtensions
                {
                    public static void AddEventPreventDefaultAttribute(this Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder, int sequence, string eventName, bool value) => throw null;
                    public static void AddEventStopPropagationAttribute(this Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder, int sequence, string eventName, bool value) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Components.Web.WheelEventArgs` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class WheelEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public System.Int64 DeltaMode { get => throw null; set => throw null; }
                    public double DeltaX { get => throw null; set => throw null; }
                    public double DeltaY { get => throw null; set => throw null; }
                    public double DeltaZ { get => throw null; set => throw null; }
                    public WheelEventArgs() => throw null;
                }

                namespace Virtualization
                {
                    // Generated from `Microsoft.AspNetCore.Components.Web.Virtualization.IVirtualizeJsCallbacks` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    internal interface IVirtualizeJsCallbacks
                    {
                    }

                    // Generated from `Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderDelegate<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public delegate System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderResult<TItem>> ItemsProviderDelegate<TItem>(Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderRequest request);

                    // Generated from `Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderRequest` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct ItemsProviderRequest
                    {
                        public System.Threading.CancellationToken CancellationToken { get => throw null; }
                        public int Count { get => throw null; }
                        public ItemsProviderRequest(int startIndex, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                        // Stub generator skipped constructor 
                        public int StartIndex { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderResult<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct ItemsProviderResult<TItem>
                    {
                        public System.Collections.Generic.IEnumerable<TItem> Items { get => throw null; }
                        public ItemsProviderResult(System.Collections.Generic.IEnumerable<TItem> items, int totalItemCount) => throw null;
                        // Stub generator skipped constructor 
                        public int TotalItemCount { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Components.Web.Virtualization.PlaceholderContext` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct PlaceholderContext
                    {
                        public int Index { get => throw null; }
                        public PlaceholderContext(int index, float size = default(float)) => throw null;
                        // Stub generator skipped constructor 
                        public float Size { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Components.Web.Virtualization.Virtualize<>` in `Microsoft.AspNetCore.Components.Web, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class Virtualize<TItem> : Microsoft.AspNetCore.Components.ComponentBase, System.IAsyncDisposable
                    {
                        protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                        public Microsoft.AspNetCore.Components.RenderFragment<TItem> ChildContent { get => throw null; set => throw null; }
                        public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                        public Microsoft.AspNetCore.Components.RenderFragment<TItem> ItemContent { get => throw null; set => throw null; }
                        public float ItemSize { get => throw null; set => throw null; }
                        public System.Collections.Generic.ICollection<TItem> Items { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderDelegate<TItem> ItemsProvider { get => throw null; set => throw null; }
                        protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                        protected override void OnParametersSet() => throw null;
                        public int OverscanCount { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Web.Virtualization.PlaceholderContext> Placeholder { get => throw null; set => throw null; }
                        public System.Threading.Tasks.Task RefreshDataAsync() => throw null;
                        public Virtualize() => throw null;
                    }

                }
            }
        }
    }
}
