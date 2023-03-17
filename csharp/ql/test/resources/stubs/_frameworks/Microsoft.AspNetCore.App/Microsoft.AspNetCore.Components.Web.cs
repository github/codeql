// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Web, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
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

            public static class ElementReferenceExtensions
            {
                public static System.Threading.Tasks.ValueTask FocusAsync(this Microsoft.AspNetCore.Components.ElementReference elementReference) => throw null;
                public static System.Threading.Tasks.ValueTask FocusAsync(this Microsoft.AspNetCore.Components.ElementReference elementReference, bool preventScroll) => throw null;
            }

            public class WebElementReferenceContext : Microsoft.AspNetCore.Components.ElementReferenceContext
            {
                public WebElementReferenceContext(Microsoft.JSInterop.IJSRuntime jsRuntime) => throw null;
            }

            namespace Forms
            {
                public static class BrowserFileExtensions
                {
                    public static System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Forms.IBrowserFile> RequestImageFileAsync(this Microsoft.AspNetCore.Components.Forms.IBrowserFile browserFile, string format, int maxWidth, int maxHeight) => throw null;
                }

                public static class EditContextFieldClassExtensions
                {
                    public static string FieldCssClass(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public static string FieldCssClass<TField>(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, System.Linq.Expressions.Expression<System.Func<TField>> accessor) => throw null;
                    public static void SetFieldCssClassProvider(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldCssClassProvider fieldCssClassProvider) => throw null;
                }

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

                public class FieldCssClassProvider
                {
                    public FieldCssClassProvider() => throw null;
                    public virtual string GetFieldCssClass(Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                }

                public interface IBrowserFile
                {
                    string ContentType { get; }
                    System.DateTimeOffset LastModified { get; }
                    string Name { get; }
                    System.IO.Stream OpenReadStream(System.Int64 maxAllowedSize = default(System.Int64), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Int64 Size { get; }
                }

                internal interface IInputFileJsCallbacks
                {
                }

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

                public class InputCheckbox : Microsoft.AspNetCore.Components.Forms.InputBase<bool>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    public InputCheckbox() => throw null;
                    protected override bool TryParseValueFromString(string value, out bool result, out string validationErrorMessage) => throw null;
                }

                public class InputDate<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    protected override string FormatValueAsString(TValue value) => throw null;
                    public InputDate() => throw null;
                    protected override void OnParametersSet() => throw null;
                    public string ParsingErrorMessage { get => throw null; set => throw null; }
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.InputDateType Type { get => throw null; set => throw null; }
                }

                public enum InputDateType : int
                {
                    Date = 0,
                    DateTimeLocal = 1,
                    Month = 2,
                    Time = 3,
                }

                public class InputFile : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    public InputFile() => throw null;
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.InputFileChangeEventArgs> OnChange { get => throw null; set => throw null; }
                    protected override void OnInitialized() => throw null;
                }

                public class InputFileChangeEventArgs : System.EventArgs
                {
                    public Microsoft.AspNetCore.Components.Forms.IBrowserFile File { get => throw null; }
                    public int FileCount { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Components.Forms.IBrowserFile> GetMultipleFiles(int maximumFileCount = default(int)) => throw null;
                    public InputFileChangeEventArgs(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Components.Forms.IBrowserFile> files) => throw null;
                }

                public class InputNumber<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    protected override string FormatValueAsString(TValue value) => throw null;
                    public InputNumber() => throw null;
                    public string ParsingErrorMessage { get => throw null; set => throw null; }
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                public class InputRadio<TValue> : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set => throw null; }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    public InputRadio() => throw null;
                    public string Name { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    public TValue Value { get => throw null; set => throw null; }
                }

                public class InputRadioGroup<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    public InputRadioGroup() => throw null;
                    public string Name { get => throw null; set => throw null; }
                    protected override void OnParametersSet() => throw null;
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                public class InputSelect<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    protected override string FormatValueAsString(TValue value) => throw null;
                    public InputSelect() => throw null;
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }

                public class InputText : Microsoft.AspNetCore.Components.Forms.InputBase<string>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    public InputText() => throw null;
                    protected override bool TryParseValueFromString(string value, out string result, out string validationErrorMessage) => throw null;
                }

                public class InputTextArea : Microsoft.AspNetCore.Components.Forms.InputBase<string>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set => throw null; }
                    public InputTextArea() => throw null;
                    protected override bool TryParseValueFromString(string value, out string result, out string validationErrorMessage) => throw null;
                }

                public class RemoteBrowserFileStreamOptions
                {
                    public int MaxBufferSize { get => throw null; set => throw null; }
                    public int MaxSegmentSize { get => throw null; set => throw null; }
                    public RemoteBrowserFileStreamOptions() => throw null;
                    public System.TimeSpan SegmentFetchTimeout { get => throw null; set => throw null; }
                }

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
                public class WebEventDescriptor
                {
                    public Microsoft.AspNetCore.Components.RenderTree.EventFieldInfo EventFieldInfo { get => throw null; set => throw null; }
                    public System.UInt64 EventHandlerId { get => throw null; set => throw null; }
                    public string EventName { get => throw null; set => throw null; }
                    public WebEventDescriptor() => throw null;
                }

                public abstract class WebRenderer : Microsoft.AspNetCore.Components.RenderTree.Renderer
                {
                    protected internal int AddRootComponent(System.Type componentType, string domElementSelector) => throw null;
                    protected abstract void AttachRootComponentToBrowser(int componentId, string domElementSelector);
                    protected override void Dispose(bool disposing) => throw null;
                    protected int RendererId { get => throw null; set => throw null; }
                    public WebRenderer(System.IServiceProvider serviceProvider, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, System.Text.Json.JsonSerializerOptions jsonOptions, Microsoft.AspNetCore.Components.Web.Infrastructure.JSComponentInterop jsComponentInterop) : base(default(System.IServiceProvider), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                }

            }
            namespace Routing
            {
                public class FocusOnNavigate : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public FocusOnNavigate() => throw null;
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                    protected override void OnParametersSet() => throw null;
                    public Microsoft.AspNetCore.Components.RouteData RouteData { get => throw null; set => throw null; }
                    public string Selector { get => throw null; set => throw null; }
                }

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

                public enum NavLinkMatch : int
                {
                    All = 1,
                    Prefix = 0,
                }

                public class NavigationLock : Microsoft.AspNetCore.Components.IComponent, Microsoft.AspNetCore.Components.IHandleAfterRender, System.IAsyncDisposable
                {
                    void Microsoft.AspNetCore.Components.IComponent.Attach(Microsoft.AspNetCore.Components.RenderHandle renderHandle) => throw null;
                    public bool ConfirmExternalNavigation { get => throw null; set => throw null; }
                    System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
                    public NavigationLock() => throw null;
                    System.Threading.Tasks.Task Microsoft.AspNetCore.Components.IHandleAfterRender.OnAfterRenderAsync() => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Routing.LocationChangingContext> OnBeforeInternalNavigation { get => throw null; set => throw null; }
                    System.Threading.Tasks.Task Microsoft.AspNetCore.Components.IComponent.SetParametersAsync(Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                }

            }
            namespace Web
            {
                public static class BindAttributes
                {
                }

                public class ClipboardEventArgs : System.EventArgs
                {
                    public ClipboardEventArgs() => throw null;
                    public string Type { get => throw null; set => throw null; }
                }

                public class DataTransfer
                {
                    public DataTransfer() => throw null;
                    public string DropEffect { get => throw null; set => throw null; }
                    public string EffectAllowed { get => throw null; set => throw null; }
                    public string[] Files { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Components.Web.DataTransferItem[] Items { get => throw null; set => throw null; }
                    public string[] Types { get => throw null; set => throw null; }
                }

                public class DataTransferItem
                {
                    public DataTransferItem() => throw null;
                    public string Kind { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                public class DragEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public Microsoft.AspNetCore.Components.Web.DataTransfer DataTransfer { get => throw null; set => throw null; }
                    public DragEventArgs() => throw null;
                }

                public class ErrorBoundary : Microsoft.AspNetCore.Components.ErrorBoundaryBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public ErrorBoundary() => throw null;
                    protected override System.Threading.Tasks.Task OnErrorAsync(System.Exception exception) => throw null;
                }

                public class ErrorEventArgs : System.EventArgs
                {
                    public int Colno { get => throw null; set => throw null; }
                    public ErrorEventArgs() => throw null;
                    public string Filename { get => throw null; set => throw null; }
                    public int Lineno { get => throw null; set => throw null; }
                    public string Message { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                public static class EventHandlers
                {
                }

                public class FocusEventArgs : System.EventArgs
                {
                    public FocusEventArgs() => throw null;
                    public string Type { get => throw null; set => throw null; }
                }

                public class HeadContent : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    public HeadContent() => throw null;
                }

                public class HeadOutlet : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public HeadOutlet() => throw null;
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                }

                public interface IErrorBoundaryLogger
                {
                    System.Threading.Tasks.ValueTask LogErrorAsync(System.Exception exception);
                }

                public interface IJSComponentConfiguration
                {
                    Microsoft.AspNetCore.Components.Web.JSComponentConfigurationStore JSComponents { get; }
                }

                public static class JSComponentConfigurationExtensions
                {
                    public static void RegisterForJavaScript(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, System.Type componentType, string identifier) => throw null;
                    public static void RegisterForJavaScript(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, System.Type componentType, string identifier, string javaScriptInitializer) => throw null;
                    public static void RegisterForJavaScript<TComponent>(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, string identifier) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public static void RegisterForJavaScript<TComponent>(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, string identifier, string javaScriptInitializer) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                }

                public class JSComponentConfigurationStore
                {
                    public JSComponentConfigurationStore() => throw null;
                }

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
                    public double MovementX { get => throw null; set => throw null; }
                    public double MovementY { get => throw null; set => throw null; }
                    public double OffsetX { get => throw null; set => throw null; }
                    public double OffsetY { get => throw null; set => throw null; }
                    public double PageX { get => throw null; set => throw null; }
                    public double PageY { get => throw null; set => throw null; }
                    public double ScreenX { get => throw null; set => throw null; }
                    public double ScreenY { get => throw null; set => throw null; }
                    public bool ShiftKey { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

                public class PageTitle : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set => throw null; }
                    public PageTitle() => throw null;
                }

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

                public class ProgressEventArgs : System.EventArgs
                {
                    public bool LengthComputable { get => throw null; set => throw null; }
                    public System.Int64 Loaded { get => throw null; set => throw null; }
                    public ProgressEventArgs() => throw null;
                    public System.Int64 Total { get => throw null; set => throw null; }
                    public string Type { get => throw null; set => throw null; }
                }

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

                public static class WebEventCallbackFactoryEventArgsExtensions
                {
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.DragEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.DragEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.FocusEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.FocusEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.MouseEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.MouseEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.PointerEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.PointerEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.TouchEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.TouchEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.WheelEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.WheelEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.DragEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.DragEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ErrorEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.FocusEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.FocusEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.MouseEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.MouseEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.PointerEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.PointerEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ProgressEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.TouchEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.TouchEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.WheelEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.WheelEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                }

                public static class WebRenderTreeBuilderExtensions
                {
                    public static void AddEventPreventDefaultAttribute(this Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder, int sequence, string eventName, bool value) => throw null;
                    public static void AddEventStopPropagationAttribute(this Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder, int sequence, string eventName, bool value) => throw null;
                }

                public class WheelEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public System.Int64 DeltaMode { get => throw null; set => throw null; }
                    public double DeltaX { get => throw null; set => throw null; }
                    public double DeltaY { get => throw null; set => throw null; }
                    public double DeltaZ { get => throw null; set => throw null; }
                    public WheelEventArgs() => throw null;
                }

                namespace Infrastructure
                {
                    public class JSComponentInterop
                    {
                        protected internal virtual int AddRootComponent(string identifier, string domElementSelector) => throw null;
                        public JSComponentInterop(Microsoft.AspNetCore.Components.Web.JSComponentConfigurationStore configuration) => throw null;
                        protected internal virtual void RemoveRootComponent(int componentId) => throw null;
                        protected internal void SetRootComponentParameters(int componentId, int parameterCount, System.Text.Json.JsonElement parametersJson, System.Text.Json.JsonSerializerOptions jsonOptions) => throw null;
                    }

                }
                namespace Virtualization
                {
                    internal interface IVirtualizeJsCallbacks
                    {
                    }

                    public delegate System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderResult<TItem>> ItemsProviderDelegate<TItem>(Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderRequest request);

                    public struct ItemsProviderRequest
                    {
                        public System.Threading.CancellationToken CancellationToken { get => throw null; }
                        public int Count { get => throw null; }
                        // Stub generator skipped constructor 
                        public ItemsProviderRequest(int startIndex, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                        public int StartIndex { get => throw null; }
                    }

                    public struct ItemsProviderResult<TItem>
                    {
                        public System.Collections.Generic.IEnumerable<TItem> Items { get => throw null; }
                        // Stub generator skipped constructor 
                        public ItemsProviderResult(System.Collections.Generic.IEnumerable<TItem> items, int totalItemCount) => throw null;
                        public int TotalItemCount { get => throw null; }
                    }

                    public struct PlaceholderContext
                    {
                        public int Index { get => throw null; }
                        // Stub generator skipped constructor 
                        public PlaceholderContext(int index, float size = default(float)) => throw null;
                        public float Size { get => throw null; }
                    }

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
                        public string SpacerElement { get => throw null; set => throw null; }
                        public Virtualize() => throw null;
                    }

                }
            }
        }
    }
}
