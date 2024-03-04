// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Endpoints, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class RazorComponentsEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finallyConvention) => throw null;
            }
            public static partial class RazorComponentsEndpointConventionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.RazorComponentsEndpointConventionBuilder AddAdditionalAssemblies(this Microsoft.AspNetCore.Builder.RazorComponentsEndpointConventionBuilder builder, params System.Reflection.Assembly[] assemblies) => throw null;
            }
            public static partial class RazorComponentsEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.RazorComponentsEndpointConventionBuilder MapRazorComponents<TRootComponent>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
            }
        }
        namespace Components
        {
            namespace Endpoints
            {
                public sealed class ComponentTypeMetadata
                {
                    public ComponentTypeMetadata(System.Type componentType) => throw null;
                    public System.Type Type { get => throw null; }
                }
                public interface IComponentPrerenderer
                {
                    Microsoft.AspNetCore.Components.Dispatcher Dispatcher { get; }
                    System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Html.IHtmlAsyncContent> PrerenderComponentAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, System.Type componentType, Microsoft.AspNetCore.Components.IComponentRenderMode renderMode, Microsoft.AspNetCore.Components.ParameterView parameters);
                    System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Html.IHtmlContent> PrerenderPersistedStateAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Components.PersistedStateSerializationMode serializationMode);
                }
                namespace Infrastructure
                {
                    public static class ComponentEndpointConventionBuilderHelper
                    {
                        public static void AddRenderMode(Microsoft.AspNetCore.Builder.RazorComponentsEndpointConventionBuilder builder, Microsoft.AspNetCore.Components.IComponentRenderMode renderMode) => throw null;
                    }
                    public abstract class RenderModeEndpointProvider
                    {
                        protected RenderModeEndpointProvider() => throw null;
                        public abstract System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.RouteEndpointBuilder> GetEndpointBuilders(Microsoft.AspNetCore.Components.IComponentRenderMode renderMode, Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder);
                        public abstract bool Supports(Microsoft.AspNetCore.Components.IComponentRenderMode renderMode);
                    }
                }
                public interface IRazorComponentEndpointInvoker
                {
                    System.Threading.Tasks.Task Render(Microsoft.AspNetCore.Http.HttpContext context);
                }
                public sealed class RazorComponentsServiceOptions
                {
                    public RazorComponentsServiceOptions() => throw null;
                    public bool DetailedErrors { get => throw null; set { } }
                    public int MaxFormMappingCollectionSize { get => throw null; set { } }
                    public int MaxFormMappingErrorCount { get => throw null; set { } }
                    public int MaxFormMappingKeySize { get => throw null; set { } }
                    public int MaxFormMappingRecursionDepth { get => throw null; set { } }
                    public System.TimeSpan TemporaryRedirectionUrlValidityDuration { get => throw null; set { } }
                }
                public sealed class RootComponentMetadata
                {
                    public RootComponentMetadata(System.Type rootComponentType) => throw null;
                    public System.Type Type { get => throw null; }
                }
            }
            public enum PersistedStateSerializationMode
            {
                Infer = 1,
                Server = 2,
                WebAssembly = 3,
            }
        }
        namespace Http
        {
            namespace HttpResults
            {
                public class RazorComponentResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult
                {
                    public System.Type ComponentType { get => throw null; }
                    public string ContentType { get => throw null; set { } }
                    public RazorComponentResult(System.Type componentType) => throw null;
                    public RazorComponentResult(System.Type componentType, object parameters) => throw null;
                    public RazorComponentResult(System.Type componentType, System.Collections.Generic.IReadOnlyDictionary<string, object> parameters) => throw null;
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Parameters { get => throw null; }
                    public bool PreventStreamingRendering { get => throw null; set { } }
                    public int? StatusCode { get => throw null; set { } }
                }
                public class RazorComponentResult<TComponent> : Microsoft.AspNetCore.Http.HttpResults.RazorComponentResult where TComponent : Microsoft.AspNetCore.Components.IComponent
                {
                    public RazorComponentResult() : base(default(System.Type)) => throw null;
                    public RazorComponentResult(object parameters) : base(default(System.Type)) => throw null;
                    public RazorComponentResult(System.Collections.Generic.IReadOnlyDictionary<string, object> parameters) : base(default(System.Type)) => throw null;
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public interface IRazorComponentsBuilder
            {
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
            public static partial class RazorComponentsServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IRazorComponentsBuilder AddRazorComponents(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Components.Endpoints.RazorComponentsServiceOptions> configure = default(System.Action<Microsoft.AspNetCore.Components.Endpoints.RazorComponentsServiceOptions>)) => throw null;
            }
        }
    }
}
