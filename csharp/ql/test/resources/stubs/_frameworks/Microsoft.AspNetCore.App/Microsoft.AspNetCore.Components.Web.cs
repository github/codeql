// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Web, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
            public sealed class BindInputElementAttribute : System.Attribute
            {
                public string ChangeAttribute { get => throw null; }
                public BindInputElementAttribute(string type, string suffix, string valueAttribute, string changeAttribute, bool isInvariantCulture, string format) => throw null;
                public string Format { get => throw null; }
                public bool IsInvariantCulture { get => throw null; }
                public string Suffix { get => throw null; }
                public string Type { get => throw null; }
                public string ValueAttribute { get => throw null; }
            }
            public static partial class ElementReferenceExtensions
            {
                public static System.Threading.Tasks.ValueTask FocusAsync(this Microsoft.AspNetCore.Components.ElementReference elementReference) => throw null;
                public static System.Threading.Tasks.ValueTask FocusAsync(this Microsoft.AspNetCore.Components.ElementReference elementReference, bool preventScroll) => throw null;
            }
            namespace Forms
            {
                public class AntiforgeryRequestToken
                {
                    public AntiforgeryRequestToken(string value, string formFieldName) => throw null;
                    public string FormFieldName { get => throw null; }
                    public string Value { get => throw null; }
                }
                public abstract class AntiforgeryStateProvider
                {
                    protected AntiforgeryStateProvider() => throw null;
                    public abstract Microsoft.AspNetCore.Components.Forms.AntiforgeryRequestToken GetAntiforgeryToken();
                }
                public class AntiforgeryToken : Microsoft.AspNetCore.Components.IComponent
                {
                    void Microsoft.AspNetCore.Components.IComponent.Attach(Microsoft.AspNetCore.Components.RenderHandle renderHandle) => throw null;
                    public AntiforgeryToken() => throw null;
                    System.Threading.Tasks.Task Microsoft.AspNetCore.Components.IComponent.SetParametersAsync(Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                }
                public static partial class BrowserFileExtensions
                {
                    public static System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Forms.IBrowserFile> RequestImageFileAsync(this Microsoft.AspNetCore.Components.Forms.IBrowserFile browserFile, string format, int maxWidth, int maxHeight) => throw null;
                }
                public static partial class EditContextFieldClassExtensions
                {
                    public static string FieldCssClass<TField>(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, System.Linq.Expressions.Expression<System.Func<TField>> accessor) => throw null;
                    public static string FieldCssClass(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                    public static void SetFieldCssClassProvider(this Microsoft.AspNetCore.Components.Forms.EditContext editContext, Microsoft.AspNetCore.Components.Forms.FieldCssClassProvider fieldCssClassProvider) => throw null;
                }
                public class EditForm : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Forms.EditContext> ChildContent { get => throw null; set { } }
                    public EditForm() => throw null;
                    public Microsoft.AspNetCore.Components.Forms.EditContext EditContext { get => throw null; set { } }
                    public bool Enhance { get => throw null; set { } }
                    public string FormName { get => throw null; set { } }
                    public object Model { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.EditContext> OnInvalidSubmit { get => throw null; set { } }
                    protected override void OnParametersSet() => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.EditContext> OnSubmit { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.EditContext> OnValidSubmit { get => throw null; set { } }
                }
                public abstract class Editor<T> : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected Editor() => throw null;
                    protected string NameFor(System.Linq.Expressions.LambdaExpression expression) => throw null;
                    protected override void OnParametersSet() => throw null;
                    public T Value { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.EventCallback<T> ValueChanged { get => throw null; set { } }
                    public System.Linq.Expressions.Expression<System.Func<T>> ValueExpression { get => throw null; set { } }
                }
                public class FieldCssClassProvider
                {
                    public FieldCssClassProvider() => throw null;
                    public virtual string GetFieldCssClass(Microsoft.AspNetCore.Components.Forms.EditContext editContext, in Microsoft.AspNetCore.Components.Forms.FieldIdentifier fieldIdentifier) => throw null;
                }
                public sealed class FormMappingContext
                {
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Components.Forms.Mapping.FormMappingError> GetAllErrors() => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Components.Forms.Mapping.FormMappingError> GetAllErrors(string formName) => throw null;
                    public string GetAttemptedValue(string key) => throw null;
                    public string GetAttemptedValue(string formName, string key) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.Mapping.FormMappingError GetErrors(string key) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.Mapping.FormMappingError GetErrors(string formName, string key) => throw null;
                    public string MappingScopeName { get => throw null; }
                }
                public sealed class FormMappingScope : Microsoft.AspNetCore.Components.IComponent
                {
                    void Microsoft.AspNetCore.Components.IComponent.Attach(Microsoft.AspNetCore.Components.RenderHandle renderHandle) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Forms.FormMappingContext> ChildContent { get => throw null; set { } }
                    public FormMappingScope() => throw null;
                    public string Name { get => throw null; set { } }
                    System.Threading.Tasks.Task Microsoft.AspNetCore.Components.IComponent.SetParametersAsync(Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                }
                public interface IBrowserFile
                {
                    string ContentType { get; }
                    System.DateTimeOffset LastModified { get; }
                    string Name { get; }
                    System.IO.Stream OpenReadStream(long maxAllowedSize = default(long), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    long Size { get; }
                }
                public abstract class InputBase<TValue> : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected string CssClass { get => throw null; }
                    protected InputBase() => throw null;
                    protected TValue CurrentValue { get => throw null; set { } }
                    protected string CurrentValueAsString { get => throw null; set { } }
                    public string DisplayName { get => throw null; set { } }
                    protected virtual void Dispose(bool disposing) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    protected Microsoft.AspNetCore.Components.Forms.EditContext EditContext { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Components.Forms.FieldIdentifier FieldIdentifier { get => throw null; set { } }
                    protected virtual string FormatValueAsString(TValue value) => throw null;
                    protected string NameAttributeValue { get => throw null; }
                    public override System.Threading.Tasks.Task SetParametersAsync(Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                    protected abstract bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage);
                    public TValue Value { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.EventCallback<TValue> ValueChanged { get => throw null; set { } }
                    public System.Linq.Expressions.Expression<System.Func<TValue>> ValueExpression { get => throw null; set { } }
                }
                public class InputCheckbox : Microsoft.AspNetCore.Components.Forms.InputBase<bool>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputCheckbox() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override bool TryParseValueFromString(string value, out bool result, out string validationErrorMessage) => throw null;
                }
                public class InputDate<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputDate() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override string FormatValueAsString(TValue value) => throw null;
                    protected override void OnParametersSet() => throw null;
                    public string ParsingErrorMessage { get => throw null; set { } }
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.InputDateType Type { get => throw null; set { } }
                }
                public enum InputDateType
                {
                    Date = 0,
                    DateTimeLocal = 1,
                    Month = 2,
                    Time = 3,
                }
                public class InputFile : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputFile() => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Forms.InputFileChangeEventArgs> OnChange { get => throw null; set { } }
                }
                public sealed class InputFileChangeEventArgs : System.EventArgs
                {
                    public InputFileChangeEventArgs(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Components.Forms.IBrowserFile> files) => throw null;
                    public Microsoft.AspNetCore.Components.Forms.IBrowserFile File { get => throw null; }
                    public int FileCount { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Components.Forms.IBrowserFile> GetMultipleFiles(int maximumFileCount = default(int)) => throw null;
                }
                public class InputNumber<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputNumber() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override string FormatValueAsString(TValue value) => throw null;
                    public string ParsingErrorMessage { get => throw null; set { } }
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }
                public class InputRadio<TValue> : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputRadio() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    public string Name { get => throw null; set { } }
                    protected override void OnParametersSet() => throw null;
                    public TValue Value { get => throw null; set { } }
                }
                public class InputRadioGroup<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set { } }
                    public InputRadioGroup() => throw null;
                    public string Name { get => throw null; set { } }
                    protected override void OnParametersSet() => throw null;
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }
                public class InputSelect<TValue> : Microsoft.AspNetCore.Components.Forms.InputBase<TValue>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set { } }
                    public InputSelect() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override string FormatValueAsString(TValue value) => throw null;
                    protected override bool TryParseValueFromString(string value, out TValue result, out string validationErrorMessage) => throw null;
                }
                public class InputText : Microsoft.AspNetCore.Components.Forms.InputBase<string>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputText() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override bool TryParseValueFromString(string value, out string result, out string validationErrorMessage) => throw null;
                }
                public class InputTextArea : Microsoft.AspNetCore.Components.Forms.InputBase<string>
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public InputTextArea() => throw null;
                    public Microsoft.AspNetCore.Components.ElementReference? Element { get => throw null; set { } }
                    protected override bool TryParseValueFromString(string value, out string result, out string validationErrorMessage) => throw null;
                }
                namespace Mapping
                {
                    public sealed class FormMappingError
                    {
                        public string AttemptedValue { get => throw null; }
                        public object Container { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<System.FormattableString> ErrorMessages { get => throw null; }
                        public string Name { get => throw null; }
                        public string Path { get => throw null; }
                    }
                    public sealed class FormValueMappingContext
                    {
                        public string AcceptFormName { get => throw null; }
                        public string AcceptMappingScopeName { get => throw null; }
                        public System.Action<string, object> MapErrorToContainer { get => throw null; set { } }
                        public System.Action<string, System.FormattableString, string> OnError { get => throw null; set { } }
                        public string ParameterName { get => throw null; }
                        public object Result { get => throw null; }
                        public void SetResult(object result) => throw null;
                        public System.Type ValueType { get => throw null; }
                    }
                    public interface IFormValueMapper
                    {
                        bool CanMap(System.Type valueType, string scopeName, string formName);
                        void Map(Microsoft.AspNetCore.Components.Forms.Mapping.FormValueMappingContext context);
                    }
                    public static partial class SupplyParameterFromFormServiceCollectionExtensions
                    {
                        public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSupplyValueFromFormProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection serviceCollection) => throw null;
                    }
                }
                public class RemoteBrowserFileStreamOptions
                {
                    public RemoteBrowserFileStreamOptions() => throw null;
                    public int MaxBufferSize { get => throw null; set { } }
                    public int MaxSegmentSize { get => throw null; set { } }
                    public System.TimeSpan SegmentFetchTimeout { get => throw null; set { } }
                }
                public class ValidationMessage<TValue> : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public ValidationMessage() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    public System.Linq.Expressions.Expression<System.Func<TValue>> For { get => throw null; set { } }
                    protected override void OnParametersSet() => throw null;
                }
                public class ValidationSummary : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public ValidationSummary() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    public object Model { get => throw null; set { } }
                    protected override void OnParametersSet() => throw null;
                }
            }
            namespace HtmlRendering
            {
                namespace Infrastructure
                {
                    public class StaticHtmlRenderer : Microsoft.AspNetCore.Components.RenderTree.Renderer
                    {
                        public Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent BeginRenderingComponent(System.Type componentType, Microsoft.AspNetCore.Components.ParameterView initialParameters) => throw null;
                        public Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent BeginRenderingComponent(Microsoft.AspNetCore.Components.IComponent component, Microsoft.AspNetCore.Components.ParameterView initialParameters) => throw null;
                        public StaticHtmlRenderer(System.IServiceProvider serviceProvider, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(System.IServiceProvider), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public override Microsoft.AspNetCore.Components.Dispatcher Dispatcher { get => throw null; }
                        protected override void HandleException(System.Exception exception) => throw null;
                        protected virtual void RenderChildComponent(System.IO.TextWriter output, ref Microsoft.AspNetCore.Components.RenderTree.RenderTreeFrame componentFrame) => throw null;
                        protected bool TryCreateScopeQualifiedEventName(int componentId, string assignedEventName, out string scopeQualifiedEventName) => throw null;
                        protected override System.Threading.Tasks.Task UpdateDisplayAsync(in Microsoft.AspNetCore.Components.RenderTree.RenderBatch renderBatch) => throw null;
                        protected virtual void WriteComponentHtml(int componentId, System.IO.TextWriter output) => throw null;
                    }
                }
            }
            namespace RenderTree
            {
                public sealed class WebEventDescriptor
                {
                    public WebEventDescriptor() => throw null;
                    public Microsoft.AspNetCore.Components.RenderTree.EventFieldInfo EventFieldInfo { get => throw null; set { } }
                    public ulong EventHandlerId { get => throw null; set { } }
                    public string EventName { get => throw null; set { } }
                }
                public abstract class WebRenderer : Microsoft.AspNetCore.Components.RenderTree.Renderer
                {
                    protected int AddRootComponent(System.Type componentType, string domElementSelector) => throw null;
                    protected abstract void AttachRootComponentToBrowser(int componentId, string domElementSelector);
                    public WebRenderer(System.IServiceProvider serviceProvider, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, System.Text.Json.JsonSerializerOptions jsonOptions, Microsoft.AspNetCore.Components.Web.Infrastructure.JSComponentInterop jsComponentInterop) : base(default(System.IServiceProvider), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    protected override void Dispose(bool disposing) => throw null;
                    protected virtual int GetWebRendererId() => throw null;
                    protected int RendererId { get => throw null; set { } }
                }
            }
            namespace Routing
            {
                public class FocusOnNavigate : Microsoft.AspNetCore.Components.ComponentBase
                {
                    public FocusOnNavigate() => throw null;
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                    protected override void OnParametersSet() => throw null;
                    public Microsoft.AspNetCore.Components.RouteData RouteData { get => throw null; set { } }
                    public string Selector { get => throw null; set { } }
                }
                public sealed class NavigationLock : System.IAsyncDisposable, Microsoft.AspNetCore.Components.IComponent, Microsoft.AspNetCore.Components.IHandleAfterRender
                {
                    void Microsoft.AspNetCore.Components.IComponent.Attach(Microsoft.AspNetCore.Components.RenderHandle renderHandle) => throw null;
                    public bool ConfirmExternalNavigation { get => throw null; set { } }
                    public NavigationLock() => throw null;
                    System.Threading.Tasks.ValueTask System.IAsyncDisposable.DisposeAsync() => throw null;
                    System.Threading.Tasks.Task Microsoft.AspNetCore.Components.IHandleAfterRender.OnAfterRenderAsync() => throw null;
                    public Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Routing.LocationChangingContext> OnBeforeInternalNavigation { get => throw null; set { } }
                    System.Threading.Tasks.Task Microsoft.AspNetCore.Components.IComponent.SetParametersAsync(Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                }
                public class NavLink : Microsoft.AspNetCore.Components.ComponentBase, System.IDisposable
                {
                    public string ActiveClass { get => throw null; set { } }
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> AdditionalAttributes { get => throw null; set { } }
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set { } }
                    protected string CssClass { get => throw null; set { } }
                    public NavLink() => throw null;
                    public void Dispose() => throw null;
                    public Microsoft.AspNetCore.Components.Routing.NavLinkMatch Match { get => throw null; set { } }
                    protected override void OnInitialized() => throw null;
                    protected override void OnParametersSet() => throw null;
                }
                public enum NavLinkMatch
                {
                    Prefix = 0,
                    All = 1,
                }
            }
            [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
            public sealed class SupplyParameterFromFormAttribute : Microsoft.AspNetCore.Components.CascadingParameterAttributeBase
            {
                public SupplyParameterFromFormAttribute() => throw null;
                public string FormName { get => throw null; set { } }
                public string Name { get => throw null; set { } }
            }
            namespace Web
            {
                public static class BindAttributes
                {
                }
                public class ClipboardEventArgs : System.EventArgs
                {
                    public ClipboardEventArgs() => throw null;
                    public string Type { get => throw null; set { } }
                }
                public class DataTransfer
                {
                    public DataTransfer() => throw null;
                    public string DropEffect { get => throw null; set { } }
                    public string EffectAllowed { get => throw null; set { } }
                    public string[] Files { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.Web.DataTransferItem[] Items { get => throw null; set { } }
                    public string[] Types { get => throw null; set { } }
                }
                public class DataTransferItem
                {
                    public DataTransferItem() => throw null;
                    public string Kind { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                }
                public class DragEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public DragEventArgs() => throw null;
                    public Microsoft.AspNetCore.Components.Web.DataTransfer DataTransfer { get => throw null; set { } }
                }
                public class ErrorBoundary : Microsoft.AspNetCore.Components.ErrorBoundaryBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public ErrorBoundary() => throw null;
                    protected override System.Threading.Tasks.Task OnErrorAsync(System.Exception exception) => throw null;
                }
                public class ErrorEventArgs : System.EventArgs
                {
                    public int Colno { get => throw null; set { } }
                    public ErrorEventArgs() => throw null;
                    public string Filename { get => throw null; set { } }
                    public int Lineno { get => throw null; set { } }
                    public string Message { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                }
                public static class EventHandlers
                {
                }
                public class FocusEventArgs : System.EventArgs
                {
                    public FocusEventArgs() => throw null;
                    public string Type { get => throw null; set { } }
                }
                public sealed class HeadContent : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set { } }
                    public HeadContent() => throw null;
                }
                public sealed class HeadOutlet : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public HeadOutlet() => throw null;
                    protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                }
                public sealed class HtmlRenderer : System.IAsyncDisposable, System.IDisposable
                {
                    public Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent BeginRenderingComponent<TComponent>() where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent BeginRenderingComponent<TComponent>(Microsoft.AspNetCore.Components.ParameterView parameters) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent BeginRenderingComponent(System.Type componentType) => throw null;
                    public Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent BeginRenderingComponent(System.Type componentType, Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                    public HtmlRenderer(System.IServiceProvider services, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public Microsoft.AspNetCore.Components.Dispatcher Dispatcher { get => throw null; }
                    public void Dispose() => throw null;
                    public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent> RenderComponentAsync<TComponent>() where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent> RenderComponentAsync(System.Type componentType) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent> RenderComponentAsync<TComponent>(Microsoft.AspNetCore.Components.ParameterView parameters) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Web.HtmlRendering.HtmlRootComponent> RenderComponentAsync(System.Type componentType, Microsoft.AspNetCore.Components.ParameterView parameters) => throw null;
                }
                namespace HtmlRendering
                {
                    public struct HtmlRootComponent
                    {
                        public System.Threading.Tasks.Task QuiescenceTask { get => throw null; }
                        public string ToHtmlString() => throw null;
                        public void WriteHtmlTo(System.IO.TextWriter output) => throw null;
                    }
                }
                public interface IErrorBoundaryLogger
                {
                    System.Threading.Tasks.ValueTask LogErrorAsync(System.Exception exception);
                }
                public interface IJSComponentConfiguration
                {
                    Microsoft.AspNetCore.Components.Web.JSComponentConfigurationStore JSComponents { get; }
                }
                namespace Infrastructure
                {
                    public class JSComponentInterop
                    {
                        protected virtual int AddRootComponent(string identifier, string domElementSelector) => throw null;
                        public JSComponentInterop(Microsoft.AspNetCore.Components.Web.JSComponentConfigurationStore configuration) => throw null;
                        protected virtual void RemoveRootComponent(int componentId) => throw null;
                        protected void SetRootComponentParameters(int componentId, int parameterCount, System.Text.Json.JsonElement parametersJson, System.Text.Json.JsonSerializerOptions jsonOptions) => throw null;
                    }
                }
                public class InteractiveAutoRenderMode : Microsoft.AspNetCore.Components.IComponentRenderMode
                {
                    public InteractiveAutoRenderMode() => throw null;
                    public InteractiveAutoRenderMode(bool prerender) => throw null;
                    public bool Prerender { get => throw null; }
                }
                public class InteractiveServerRenderMode : Microsoft.AspNetCore.Components.IComponentRenderMode
                {
                    public InteractiveServerRenderMode() => throw null;
                    public InteractiveServerRenderMode(bool prerender) => throw null;
                    public bool Prerender { get => throw null; }
                }
                public class InteractiveWebAssemblyRenderMode : Microsoft.AspNetCore.Components.IComponentRenderMode
                {
                    public InteractiveWebAssemblyRenderMode() => throw null;
                    public InteractiveWebAssemblyRenderMode(bool prerender) => throw null;
                    public bool Prerender { get => throw null; }
                }
                public static partial class JSComponentConfigurationExtensions
                {
                    public static void RegisterForJavaScript<TComponent>(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, string identifier) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public static void RegisterForJavaScript<TComponent>(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, string identifier, string javaScriptInitializer) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public static void RegisterForJavaScript(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, System.Type componentType, string identifier) => throw null;
                    public static void RegisterForJavaScript(this Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration configuration, System.Type componentType, string identifier, string javaScriptInitializer) => throw null;
                }
                public sealed class JSComponentConfigurationStore
                {
                    public JSComponentConfigurationStore() => throw null;
                }
                public class KeyboardEventArgs : System.EventArgs
                {
                    public bool AltKey { get => throw null; set { } }
                    public string Code { get => throw null; set { } }
                    public KeyboardEventArgs() => throw null;
                    public bool CtrlKey { get => throw null; set { } }
                    public string Key { get => throw null; set { } }
                    public float Location { get => throw null; set { } }
                    public bool MetaKey { get => throw null; set { } }
                    public bool Repeat { get => throw null; set { } }
                    public bool ShiftKey { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                }
                public class MouseEventArgs : System.EventArgs
                {
                    public bool AltKey { get => throw null; set { } }
                    public long Button { get => throw null; set { } }
                    public long Buttons { get => throw null; set { } }
                    public double ClientX { get => throw null; set { } }
                    public double ClientY { get => throw null; set { } }
                    public MouseEventArgs() => throw null;
                    public bool CtrlKey { get => throw null; set { } }
                    public long Detail { get => throw null; set { } }
                    public bool MetaKey { get => throw null; set { } }
                    public double MovementX { get => throw null; set { } }
                    public double MovementY { get => throw null; set { } }
                    public double OffsetX { get => throw null; set { } }
                    public double OffsetY { get => throw null; set { } }
                    public double PageX { get => throw null; set { } }
                    public double PageY { get => throw null; set { } }
                    public double ScreenX { get => throw null; set { } }
                    public double ScreenY { get => throw null; set { } }
                    public bool ShiftKey { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                }
                public sealed class PageTitle : Microsoft.AspNetCore.Components.ComponentBase
                {
                    protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Components.RenderFragment ChildContent { get => throw null; set { } }
                    public PageTitle() => throw null;
                }
                public class PointerEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public PointerEventArgs() => throw null;
                    public float Height { get => throw null; set { } }
                    public bool IsPrimary { get => throw null; set { } }
                    public long PointerId { get => throw null; set { } }
                    public string PointerType { get => throw null; set { } }
                    public float Pressure { get => throw null; set { } }
                    public float TiltX { get => throw null; set { } }
                    public float TiltY { get => throw null; set { } }
                    public float Width { get => throw null; set { } }
                }
                public class ProgressEventArgs : System.EventArgs
                {
                    public ProgressEventArgs() => throw null;
                    public bool LengthComputable { get => throw null; set { } }
                    public long Loaded { get => throw null; set { } }
                    public long Total { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                }
                public static class RenderMode
                {
                    public static Microsoft.AspNetCore.Components.Web.InteractiveAutoRenderMode InteractiveAuto { get => throw null; }
                    public static Microsoft.AspNetCore.Components.Web.InteractiveServerRenderMode InteractiveServer { get => throw null; }
                    public static Microsoft.AspNetCore.Components.Web.InteractiveWebAssemblyRenderMode InteractiveWebAssembly { get => throw null; }
                }
                public class TouchEventArgs : System.EventArgs
                {
                    public bool AltKey { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.Web.TouchPoint[] ChangedTouches { get => throw null; set { } }
                    public TouchEventArgs() => throw null;
                    public bool CtrlKey { get => throw null; set { } }
                    public long Detail { get => throw null; set { } }
                    public bool MetaKey { get => throw null; set { } }
                    public bool ShiftKey { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.Web.TouchPoint[] TargetTouches { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.Web.TouchPoint[] Touches { get => throw null; set { } }
                    public string Type { get => throw null; set { } }
                }
                public class TouchPoint
                {
                    public double ClientX { get => throw null; set { } }
                    public double ClientY { get => throw null; set { } }
                    public TouchPoint() => throw null;
                    public long Identifier { get => throw null; set { } }
                    public double PageX { get => throw null; set { } }
                    public double PageY { get => throw null; set { } }
                    public double ScreenX { get => throw null; set { } }
                    public double ScreenY { get => throw null; set { } }
                }
                namespace Virtualization
                {
                    public delegate System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderResult<TItem>> ItemsProviderDelegate<TItem>(Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderRequest request);
                    public struct ItemsProviderRequest
                    {
                        public System.Threading.CancellationToken CancellationToken { get => throw null; }
                        public int Count { get => throw null; }
                        public ItemsProviderRequest(int startIndex, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                        public int StartIndex { get => throw null; }
                    }
                    public struct ItemsProviderResult<TItem>
                    {
                        public ItemsProviderResult(System.Collections.Generic.IEnumerable<TItem> items, int totalItemCount) => throw null;
                        public System.Collections.Generic.IEnumerable<TItem> Items { get => throw null; }
                        public int TotalItemCount { get => throw null; }
                    }
                    public struct PlaceholderContext
                    {
                        public PlaceholderContext(int index, float size = default(float)) => throw null;
                        public int Index { get => throw null; }
                        public float Size { get => throw null; }
                    }
                    public sealed class Virtualize<TItem> : Microsoft.AspNetCore.Components.ComponentBase, System.IAsyncDisposable
                    {
                        protected override void BuildRenderTree(Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder) => throw null;
                        public Microsoft.AspNetCore.Components.RenderFragment<TItem> ChildContent { get => throw null; set { } }
                        public Virtualize() => throw null;
                        public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                        public Microsoft.AspNetCore.Components.RenderFragment EmptyContent { get => throw null; set { } }
                        public Microsoft.AspNetCore.Components.RenderFragment<TItem> ItemContent { get => throw null; set { } }
                        public System.Collections.Generic.ICollection<TItem> Items { get => throw null; set { } }
                        public float ItemSize { get => throw null; set { } }
                        public Microsoft.AspNetCore.Components.Web.Virtualization.ItemsProviderDelegate<TItem> ItemsProvider { get => throw null; set { } }
                        protected override System.Threading.Tasks.Task OnAfterRenderAsync(bool firstRender) => throw null;
                        protected override void OnParametersSet() => throw null;
                        public int OverscanCount { get => throw null; set { } }
                        public Microsoft.AspNetCore.Components.RenderFragment<Microsoft.AspNetCore.Components.Web.Virtualization.PlaceholderContext> Placeholder { get => throw null; set { } }
                        public System.Threading.Tasks.Task RefreshDataAsync() => throw null;
                        public string SpacerElement { get => throw null; set { } }
                    }
                }
                public static partial class WebEventCallbackFactoryEventArgsExtensions
                {
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ClipboardEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.DragEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.DragEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.DragEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.DragEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ErrorEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ErrorEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.FocusEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.FocusEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.FocusEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.FocusEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.KeyboardEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.MouseEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.MouseEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.MouseEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.MouseEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.PointerEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.PointerEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.PointerEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.PointerEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.ProgressEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.ProgressEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.TouchEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.TouchEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.TouchEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.TouchEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.WheelEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Action<Microsoft.AspNetCore.Components.Web.WheelEventArgs> callback) => throw null;
                    public static Microsoft.AspNetCore.Components.EventCallback<Microsoft.AspNetCore.Components.Web.WheelEventArgs> Create(this Microsoft.AspNetCore.Components.EventCallbackFactory factory, object receiver, System.Func<Microsoft.AspNetCore.Components.Web.WheelEventArgs, System.Threading.Tasks.Task> callback) => throw null;
                }
                public static partial class WebRenderTreeBuilderExtensions
                {
                    public static void AddEventPreventDefaultAttribute(this Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder, int sequence, string eventName, bool value) => throw null;
                    public static void AddEventStopPropagationAttribute(this Microsoft.AspNetCore.Components.Rendering.RenderTreeBuilder builder, int sequence, string eventName, bool value) => throw null;
                }
                public class WheelEventArgs : Microsoft.AspNetCore.Components.Web.MouseEventArgs
                {
                    public WheelEventArgs() => throw null;
                    public long DeltaMode { get => throw null; set { } }
                    public double DeltaX { get => throw null; set { } }
                    public double DeltaY { get => throw null; set { } }
                    public double DeltaZ { get => throw null; set { } }
                }
            }
            public class WebElementReferenceContext : Microsoft.AspNetCore.Components.ElementReferenceContext
            {
                public WebElementReferenceContext(Microsoft.JSInterop.IJSRuntime jsRuntime) => throw null;
            }
        }
    }
}
