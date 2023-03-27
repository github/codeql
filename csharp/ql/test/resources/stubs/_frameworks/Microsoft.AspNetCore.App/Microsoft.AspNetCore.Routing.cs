// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Routing, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static class EndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapDelete(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapDelete(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapGet(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapGet(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Routing.RouteGroupBuilder MapGroup(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern prefix) => throw null;
                public static Microsoft.AspNetCore.Routing.RouteGroupBuilder MapGroup(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string prefix) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapMethods(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Collections.Generic.IEnumerable<string> httpMethods, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapMethods(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Collections.Generic.IEnumerable<string> httpMethods, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapPatch(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPatch(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapPost(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPost(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapPut(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPut(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }

            public static class EndpointRoutingApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseEndpoints(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, System.Action<Microsoft.AspNetCore.Routing.IEndpointRouteBuilder> configure) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouting(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }

            public static class FallbackEndpointRouteBuilderExtensions
            {
                public static string DefaultPattern;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }

            public static class MapRouteRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults, object constraints) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults, object constraints, object dataTokens) => throw null;
            }

            public class RouteHandlerBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
                public RouteHandlerBuilder(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Builder.IEndpointConventionBuilder> endpointConventionBuilders) => throw null;
            }

            public class RouterMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public RouterMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Routing.IRouter router) => throw null;
            }

            public static class RoutingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouter(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouter(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Routing.IRouter router) => throw null;
            }

            public static class RoutingEndpointConventionBuilderExtensions
            {
                public static TBuilder RequireHost<TBuilder>(this TBuilder builder, params string[] hosts) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithDisplayName<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Builder.EndpointBuilder, string> func) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithDisplayName<TBuilder>(this TBuilder builder, string displayName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithGroupName<TBuilder>(this TBuilder builder, string endpointGroupName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithMetadata<TBuilder>(this TBuilder builder, params object[] items) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithName<TBuilder>(this TBuilder builder, string endpointName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }

        }
        namespace Http
        {
            public static class EndpointFilterExtensions
            {
                public static TBuilder AddEndpointFilter<TBuilder, TFilterType>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder where TFilterType : Microsoft.AspNetCore.Http.IEndpointFilter => throw null;
                public static TBuilder AddEndpointFilter<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Http.EndpointFilterInvocationContext, Microsoft.AspNetCore.Http.EndpointFilterDelegate, System.Threading.Tasks.ValueTask<object>> routeHandlerFilter) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder AddEndpointFilter<TBuilder>(this TBuilder builder, Microsoft.AspNetCore.Http.IEndpointFilter filter) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static Microsoft.AspNetCore.Routing.RouteGroupBuilder AddEndpointFilter<TFilterType>(this Microsoft.AspNetCore.Routing.RouteGroupBuilder builder) where TFilterType : Microsoft.AspNetCore.Http.IEndpointFilter => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder AddEndpointFilter<TFilterType>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder) where TFilterType : Microsoft.AspNetCore.Http.IEndpointFilter => throw null;
                public static TBuilder AddEndpointFilterFactory<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Http.EndpointFilterFactoryContext, Microsoft.AspNetCore.Http.EndpointFilterDelegate, Microsoft.AspNetCore.Http.EndpointFilterDelegate> filterFactory) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }

            public static class OpenApiRouteHandlerBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, System.Type requestType, bool isOptional, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, System.Type requestType, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts<TRequest>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, bool isOptional, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts<TRequest>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder ExcludeFromDescription(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder) => throw null;
                public static TBuilder ExcludeFromDescription<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Produces(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode, System.Type responseType = default(System.Type), string contentType = default(string), params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Produces<TResponse>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode = default(int), string contentType = default(string), params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder ProducesProblem(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode, string contentType = default(string)) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder ProducesValidationProblem(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode = default(int), string contentType = default(string)) => throw null;
                public static TBuilder WithDescription<TBuilder>(this TBuilder builder, string description) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithSummary<TBuilder>(this TBuilder builder, string summary) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder WithTags(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, params string[] tags) => throw null;
                public static TBuilder WithTags<TBuilder>(this TBuilder builder, params string[] tags) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }

        }
        namespace Routing
        {
            public class CompositeEndpointDataSource : Microsoft.AspNetCore.Routing.EndpointDataSource, System.IDisposable
            {
                public CompositeEndpointDataSource(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.EndpointDataSource> endpointDataSources) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.EndpointDataSource> DataSources { get => throw null; }
                public void Dispose() => throw null;
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                public override Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> GetGroupedEndpoints(Microsoft.AspNetCore.Routing.RouteGroupContext context) => throw null;
            }

            public class DataTokensMetadata : Microsoft.AspNetCore.Routing.IDataTokensMetadata
            {
                public System.Collections.Generic.IReadOnlyDictionary<string, object> DataTokens { get => throw null; }
                public DataTokensMetadata(System.Collections.Generic.IReadOnlyDictionary<string, object> dataTokens) => throw null;
            }

            public class DefaultEndpointDataSource : Microsoft.AspNetCore.Routing.EndpointDataSource
            {
                public DefaultEndpointDataSource(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                public DefaultEndpointDataSource(params Microsoft.AspNetCore.Http.Endpoint[] endpoints) => throw null;
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                public override Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
            }

            public class DefaultInlineConstraintResolver : Microsoft.AspNetCore.Routing.IInlineConstraintResolver
            {
                public DefaultInlineConstraintResolver(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Routing.RouteOptions> routeOptions, System.IServiceProvider serviceProvider) => throw null;
                public virtual Microsoft.AspNetCore.Routing.IRouteConstraint ResolveConstraint(string inlineConstraint) => throw null;
            }

            public abstract class EndpointDataSource
            {
                protected EndpointDataSource() => throw null;
                public abstract System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get; }
                public abstract Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                public virtual System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> GetGroupedEndpoints(Microsoft.AspNetCore.Routing.RouteGroupContext context) => throw null;
            }

            public class EndpointGroupNameAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IEndpointGroupNameMetadata
            {
                public string EndpointGroupName { get => throw null; }
                public EndpointGroupNameAttribute(string endpointGroupName) => throw null;
            }

            public class EndpointNameAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IEndpointNameMetadata
            {
                public string EndpointName { get => throw null; }
                public EndpointNameAttribute(string endpointName) => throw null;
            }

            public class EndpointNameMetadata : Microsoft.AspNetCore.Routing.IEndpointNameMetadata
            {
                public string EndpointName { get => throw null; }
                public EndpointNameMetadata(string endpointName) => throw null;
            }

            public class ExcludeFromDescriptionAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IExcludeFromDescriptionMetadata
            {
                public bool ExcludeFromDescription { get => throw null; }
                public ExcludeFromDescriptionAttribute() => throw null;
            }

            public class HostAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IHostMetadata
            {
                public HostAttribute(params string[] hosts) => throw null;
                public HostAttribute(string host) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> Hosts { get => throw null; }
            }

            public class HttpMethodMetadata : Microsoft.AspNetCore.Routing.IHttpMethodMetadata
            {
                public bool AcceptCorsPreflight { get => throw null; set => throw null; }
                public HttpMethodMetadata(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                public HttpMethodMetadata(System.Collections.Generic.IEnumerable<string> httpMethods, bool acceptCorsPreflight) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> HttpMethods { get => throw null; }
            }

            public interface IDataTokensMetadata
            {
                System.Collections.Generic.IReadOnlyDictionary<string, object> DataTokens { get; }
            }

            public interface IDynamicEndpointMetadata
            {
                bool IsDynamic { get; }
            }

            public interface IEndpointAddressScheme<TAddress>
            {
                System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.Endpoint> FindEndpoints(TAddress address);
            }

            public interface IEndpointGroupNameMetadata
            {
                string EndpointGroupName { get; }
            }

            public interface IEndpointNameMetadata
            {
                string EndpointName { get; }
            }

            public interface IEndpointRouteBuilder
            {
                Microsoft.AspNetCore.Builder.IApplicationBuilder CreateApplicationBuilder();
                System.Collections.Generic.ICollection<Microsoft.AspNetCore.Routing.EndpointDataSource> DataSources { get; }
                System.IServiceProvider ServiceProvider { get; }
            }

            public interface IExcludeFromDescriptionMetadata
            {
                bool ExcludeFromDescription { get; }
            }

            public interface IHostMetadata
            {
                System.Collections.Generic.IReadOnlyList<string> Hosts { get; }
            }

            public interface IHttpMethodMetadata
            {
                bool AcceptCorsPreflight { get => throw null; set => throw null; }
                System.Collections.Generic.IReadOnlyList<string> HttpMethods { get; }
            }

            public interface IInlineConstraintResolver
            {
                Microsoft.AspNetCore.Routing.IRouteConstraint ResolveConstraint(string inlineConstraint);
            }

            public interface INamedRouter : Microsoft.AspNetCore.Routing.IRouter
            {
                string Name { get; }
            }

            public interface IRouteBuilder
            {
                Microsoft.AspNetCore.Builder.IApplicationBuilder ApplicationBuilder { get; }
                Microsoft.AspNetCore.Routing.IRouter Build();
                Microsoft.AspNetCore.Routing.IRouter DefaultHandler { get; set; }
                System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routes { get; }
                System.IServiceProvider ServiceProvider { get; }
            }

            public interface IRouteCollection : Microsoft.AspNetCore.Routing.IRouter
            {
                void Add(Microsoft.AspNetCore.Routing.IRouter router);
            }

            public interface IRouteNameMetadata
            {
                string RouteName { get; }
            }

            public interface ISuppressLinkGenerationMetadata
            {
                bool SuppressLinkGeneration { get; }
            }

            public interface ISuppressMatchingMetadata
            {
                bool SuppressMatching { get; }
            }

            public static class InlineRouteParameterParser
            {
                public static Microsoft.AspNetCore.Routing.Template.TemplatePart ParseRouteParameter(string routeParameter) => throw null;
            }

            public static class LinkGeneratorEndpointNameAddressExtensions
            {
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, object values, Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, object values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, object values, string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }

            public static class LinkGeneratorRouteValuesAddressExtensions
            {
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, object values, Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, object values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, object values, string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }

            public abstract class LinkParser
            {
                protected LinkParser() => throw null;
                public abstract Microsoft.AspNetCore.Routing.RouteValueDictionary ParsePathByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Http.PathString path);
            }

            public static class LinkParserEndpointNameAddressExtensions
            {
                public static Microsoft.AspNetCore.Routing.RouteValueDictionary ParsePathByEndpointName(this Microsoft.AspNetCore.Routing.LinkParser parser, string endpointName, Microsoft.AspNetCore.Http.PathString path) => throw null;
            }

            public abstract class MatcherPolicy
            {
                protected static bool ContainsDynamicEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                protected MatcherPolicy() => throw null;
                public abstract int Order { get; }
            }

            public abstract class ParameterPolicyFactory
            {
                public abstract Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, Microsoft.AspNetCore.Routing.IParameterPolicy parameterPolicy);
                public Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference reference) => throw null;
                public abstract Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, string inlineText);
                protected ParameterPolicyFactory() => throw null;
            }

            public static class RequestDelegateRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapDelete(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapDelete(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapGet(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapGet(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareDelete(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareGet(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewarePost(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewarePut(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareVerb(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string verb, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPost(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPost(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPut(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPut(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapVerb(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string verb, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapVerb(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string verb, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
            }

            public class Route : Microsoft.AspNetCore.Routing.RouteBase
            {
                protected override System.Threading.Tasks.Task OnRouteMatched(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                protected override Microsoft.AspNetCore.Routing.VirtualPathData OnVirtualPathGenerated(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeTemplate, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeName, string routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public string RouteTemplate { get => throw null; }
            }

            public abstract class RouteBase : Microsoft.AspNetCore.Routing.INamedRouter, Microsoft.AspNetCore.Routing.IRouter
            {
                protected virtual Microsoft.AspNetCore.Routing.IInlineConstraintResolver ConstraintResolver { get => throw null; set => throw null; }
                public virtual System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Routing.RouteValueDictionary DataTokens { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; set => throw null; }
                protected static System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> GetConstraints(Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver, Microsoft.AspNetCore.Routing.Template.RouteTemplate parsedTemplate, System.Collections.Generic.IDictionary<string, object> constraints) => throw null;
                protected static Microsoft.AspNetCore.Routing.RouteValueDictionary GetDefaults(Microsoft.AspNetCore.Routing.Template.RouteTemplate parsedTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults) => throw null;
                public virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public virtual string Name { get => throw null; set => throw null; }
                protected abstract System.Threading.Tasks.Task OnRouteMatched(Microsoft.AspNetCore.Routing.RouteContext context);
                protected abstract Microsoft.AspNetCore.Routing.VirtualPathData OnVirtualPathGenerated(Microsoft.AspNetCore.Routing.VirtualPathContext context);
                public virtual Microsoft.AspNetCore.Routing.Template.RouteTemplate ParsedTemplate { get => throw null; set => throw null; }
                public virtual System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public RouteBase(string template, string name, Microsoft.AspNetCore.Routing.IInlineConstraintResolver constraintResolver, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens) => throw null;
                public override string ToString() => throw null;
            }

            public class RouteBuilder : Microsoft.AspNetCore.Routing.IRouteBuilder
            {
                public Microsoft.AspNetCore.Builder.IApplicationBuilder ApplicationBuilder { get => throw null; }
                public Microsoft.AspNetCore.Routing.IRouter Build() => throw null;
                public Microsoft.AspNetCore.Routing.IRouter DefaultHandler { get => throw null; set => throw null; }
                public RouteBuilder(Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder) => throw null;
                public RouteBuilder(Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder, Microsoft.AspNetCore.Routing.IRouter defaultHandler) => throw null;
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routes { get => throw null; }
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }

            public class RouteCollection : Microsoft.AspNetCore.Routing.IRouteCollection, Microsoft.AspNetCore.Routing.IRouter
            {
                public void Add(Microsoft.AspNetCore.Routing.IRouter router) => throw null;
                public int Count { get => throw null; }
                public virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public Microsoft.AspNetCore.Routing.IRouter this[int index] { get => throw null; }
                public virtual System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public RouteCollection() => throw null;
            }

            public class RouteConstraintBuilder
            {
                public void AddConstraint(string key, object value) => throw null;
                public void AddResolvedConstraint(string key, string constraintText) => throw null;
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Build() => throw null;
                public RouteConstraintBuilder(Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver, string displayName) => throw null;
                public void SetOptional(string key) => throw null;
            }

            public static class RouteConstraintMatcher
            {
                public static bool Match(System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary routeValues, Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, Microsoft.AspNetCore.Routing.RouteDirection routeDirection, Microsoft.Extensions.Logging.ILogger logger) => throw null;
            }

            public class RouteCreationException : System.Exception
            {
                public RouteCreationException(string message) => throw null;
                public RouteCreationException(string message, System.Exception innerException) => throw null;
            }

            public class RouteEndpoint : Microsoft.AspNetCore.Http.Endpoint
            {
                public int Order { get => throw null; }
                public RouteEndpoint(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Routing.Patterns.RoutePattern routePattern, int order, Microsoft.AspNetCore.Http.EndpointMetadataCollection metadata, string displayName) : base(default(Microsoft.AspNetCore.Http.RequestDelegate), default(Microsoft.AspNetCore.Http.EndpointMetadataCollection), default(string)) => throw null;
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern RoutePattern { get => throw null; }
            }

            public class RouteEndpointBuilder : Microsoft.AspNetCore.Builder.EndpointBuilder
            {
                public override Microsoft.AspNetCore.Http.Endpoint Build() => throw null;
                public int Order { get => throw null; set => throw null; }
                public RouteEndpointBuilder(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Routing.Patterns.RoutePattern routePattern, int order) => throw null;
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern RoutePattern { get => throw null; set => throw null; }
            }

            public class RouteGroupBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder, Microsoft.AspNetCore.Routing.IEndpointRouteBuilder
            {
                void Microsoft.AspNetCore.Builder.IEndpointConventionBuilder.Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                Microsoft.AspNetCore.Builder.IApplicationBuilder Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.CreateApplicationBuilder() => throw null;
                System.Collections.Generic.ICollection<Microsoft.AspNetCore.Routing.EndpointDataSource> Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.DataSources { get => throw null; }
                void Microsoft.AspNetCore.Builder.IEndpointConventionBuilder.Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
                System.IServiceProvider Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.ServiceProvider { get => throw null; }
            }

            public class RouteGroupContext
            {
                public System.IServiceProvider ApplicationServices { get => throw null; set => throw null; }
                public System.Collections.Generic.IReadOnlyList<System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder>> Conventions { get => throw null; set => throw null; }
                public System.Collections.Generic.IReadOnlyList<System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder>> FinallyConventions { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern Prefix { get => throw null; set => throw null; }
                public RouteGroupContext() => throw null;
            }

            public class RouteHandler : Microsoft.AspNetCore.Routing.IRouteHandler, Microsoft.AspNetCore.Routing.IRouter
            {
                public Microsoft.AspNetCore.Http.RequestDelegate GetRequestHandler(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                public Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public RouteHandler(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }

            public class RouteHandlerOptions
            {
                public RouteHandlerOptions() => throw null;
                public bool ThrowOnBadRequest { get => throw null; set => throw null; }
            }

            public class RouteNameMetadata : Microsoft.AspNetCore.Routing.IRouteNameMetadata
            {
                public string RouteName { get => throw null; }
                public RouteNameMetadata(string routeName) => throw null;
            }

            public class RouteOptions
            {
                public bool AppendTrailingSlash { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, System.Type> ConstraintMap { get => throw null; set => throw null; }
                public bool LowercaseQueryStrings { get => throw null; set => throw null; }
                public bool LowercaseUrls { get => throw null; set => throw null; }
                public RouteOptions() => throw null;
                public void SetParameterPolicy(string token, System.Type type) => throw null;
                public void SetParameterPolicy<T>(string token) where T : Microsoft.AspNetCore.Routing.IParameterPolicy => throw null;
                public bool SuppressCheckForUnhandledSecurityMetadata { get => throw null; set => throw null; }
            }

            public class RouteValueEqualityComparer : System.Collections.Generic.IEqualityComparer<object>
            {
                public static Microsoft.AspNetCore.Routing.RouteValueEqualityComparer Default;
                public bool Equals(object x, object y) => throw null;
                public int GetHashCode(object obj) => throw null;
                public RouteValueEqualityComparer() => throw null;
            }

            public class RouteValuesAddress
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary ExplicitValues { get => throw null; set => throw null; }
                public string RouteName { get => throw null; set => throw null; }
                public RouteValuesAddress() => throw null;
                public override string ToString() => throw null;
            }

            public class RoutingFeature : Microsoft.AspNetCore.Routing.IRoutingFeature
            {
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set => throw null; }
                public RoutingFeature() => throw null;
            }

            public class SuppressLinkGenerationMetadata : Microsoft.AspNetCore.Routing.ISuppressLinkGenerationMetadata
            {
                public bool SuppressLinkGeneration { get => throw null; }
                public SuppressLinkGenerationMetadata() => throw null;
            }

            public class SuppressMatchingMetadata : Microsoft.AspNetCore.Routing.ISuppressMatchingMetadata
            {
                public bool SuppressMatching { get => throw null; }
                public SuppressMatchingMetadata() => throw null;
            }

            namespace Constraints
            {
                public class AlphaRouteConstraint : Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint
                {
                    public AlphaRouteConstraint() : base(default(System.Text.RegularExpressions.Regex)) => throw null;
                }

                public class BoolRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public BoolRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class CompositeRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public CompositeRouteConstraint(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> constraints) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class DateTimeRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public DateTimeRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class DecimalRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public DecimalRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class DoubleRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public DoubleRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class FileNameRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public FileNameRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class FloatRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public FloatRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class GuidRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public GuidRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class HttpMethodRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public System.Collections.Generic.IList<string> AllowedMethods { get => throw null; }
                    public HttpMethodRouteConstraint(params string[] allowedMethods) => throw null;
                    public virtual bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                public class IntRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public IntRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class LengthRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public LengthRouteConstraint(int length) => throw null;
                    public LengthRouteConstraint(int minLength, int maxLength) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public int MaxLength { get => throw null; }
                    public int MinLength { get => throw null; }
                }

                public class LongRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public LongRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }

                public class MaxLengthRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public int MaxLength { get => throw null; }
                    public MaxLengthRouteConstraint(int maxLength) => throw null;
                }

                public class MaxRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public System.Int64 Max { get => throw null; }
                    public MaxRouteConstraint(System.Int64 max) => throw null;
                }

                public class MinLengthRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public int MinLength { get => throw null; }
                    public MinLengthRouteConstraint(int minLength) => throw null;
                }

                public class MinRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public System.Int64 Min { get => throw null; }
                    public MinRouteConstraint(System.Int64 min) => throw null;
                }

                public class NonFileNameRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public NonFileNameRouteConstraint() => throw null;
                }

                public class OptionalRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public Microsoft.AspNetCore.Routing.IRouteConstraint InnerConstraint { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public OptionalRouteConstraint(Microsoft.AspNetCore.Routing.IRouteConstraint innerConstraint) => throw null;
                }

                public class RangeRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public System.Int64 Max { get => throw null; }
                    public System.Int64 Min { get => throw null; }
                    public RangeRouteConstraint(System.Int64 min, System.Int64 max) => throw null;
                }

                public class RegexInlineRouteConstraint : Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint
                {
                    public RegexInlineRouteConstraint(string regexPattern) : base(default(System.Text.RegularExpressions.Regex)) => throw null;
                }

                public class RegexRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public System.Text.RegularExpressions.Regex Constraint { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public RegexRouteConstraint(System.Text.RegularExpressions.Regex regex) => throw null;
                    public RegexRouteConstraint(string regexPattern) => throw null;
                }

                public class RequiredRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public RequiredRouteConstraint() => throw null;
                }

                public class StringRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public StringRouteConstraint(string value) => throw null;
                }

            }
            namespace Internal
            {
                public class DfaGraphWriter
                {
                    public DfaGraphWriter(System.IServiceProvider services) => throw null;
                    public void Write(Microsoft.AspNetCore.Routing.EndpointDataSource dataSource, System.IO.TextWriter writer) => throw null;
                }

            }
            namespace Matching
            {
                public class CandidateSet
                {
                    public CandidateSet(Microsoft.AspNetCore.Http.Endpoint[] endpoints, Microsoft.AspNetCore.Routing.RouteValueDictionary[] values, int[] scores) => throw null;
                    public int Count { get => throw null; }
                    public void ExpandEndpoint(int index, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints, System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> comparer) => throw null;
                    public bool IsValidCandidate(int index) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.CandidateState this[int index] { get => throw null; }
                    public void ReplaceEndpoint(int index, Microsoft.AspNetCore.Http.Endpoint endpoint, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    public void SetValidity(int index, bool value) => throw null;
                }

                public struct CandidateState
                {
                    // Stub generator skipped constructor 
                    public Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; }
                    public int Score { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; set => throw null; }
                }

                public class EndpointMetadataComparer : System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint>
                {
                    int System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint>.Compare(Microsoft.AspNetCore.Http.Endpoint x, Microsoft.AspNetCore.Http.Endpoint y) => throw null;
                }

                public abstract class EndpointMetadataComparer<TMetadata> : System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> where TMetadata : class
                {
                    public int Compare(Microsoft.AspNetCore.Http.Endpoint x, Microsoft.AspNetCore.Http.Endpoint y) => throw null;
                    protected virtual int CompareMetadata(TMetadata x, TMetadata y) => throw null;
                    public static Microsoft.AspNetCore.Routing.Matching.EndpointMetadataComparer<TMetadata> Default;
                    protected EndpointMetadataComparer() => throw null;
                    protected virtual TMetadata GetMetadata(Microsoft.AspNetCore.Http.Endpoint endpoint) => throw null;
                }

                public abstract class EndpointSelector
                {
                    protected EndpointSelector() => throw null;
                    public abstract System.Threading.Tasks.Task SelectAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates);
                }

                public class HostMatcherPolicy : Microsoft.AspNetCore.Routing.MatcherPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy, Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy
                {
                    bool Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges) => throw null;
                    public System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public HostMatcherPolicy() => throw null;
                    public override int Order { get => throw null; }
                }

                public class HttpMethodMatcherPolicy : Microsoft.AspNetCore.Routing.MatcherPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy, Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy
                {
                    bool Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges) => throw null;
                    public System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public HttpMethodMatcherPolicy() => throw null;
                    public override int Order { get => throw null; }
                }

                public interface IEndpointComparerPolicy
                {
                    System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get; }
                }

                public interface IEndpointSelectorPolicy
                {
                    bool AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints);
                    System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates);
                }

                public interface INodeBuilderPolicy
                {
                    bool AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints);
                    Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges);
                    System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints);
                }

                public interface IParameterLiteralNodeMatchingPolicy : Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    bool MatchesLiteral(string parameterName, string literal);
                }

                public abstract class PolicyJumpTable
                {
                    public abstract int GetDestination(Microsoft.AspNetCore.Http.HttpContext httpContext);
                    protected PolicyJumpTable() => throw null;
                }

                public struct PolicyJumpTableEdge
                {
                    public int Destination { get => throw null; }
                    // Stub generator skipped constructor 
                    public PolicyJumpTableEdge(object state, int destination) => throw null;
                    public object State { get => throw null; }
                }

                public struct PolicyNodeEdge
                {
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                    // Stub generator skipped constructor 
                    public PolicyNodeEdge(object state, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public object State { get => throw null; }
                }

            }
            namespace Patterns
            {
                public class RoutePattern
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Defaults { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart GetParameter(string name) => throw null;
                    public System.Decimal InboundPrecedence { get => throw null; }
                    public System.Decimal OutboundPrecedence { get => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference>> ParameterPolicies { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart> Parameters { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> PathSegments { get => throw null; }
                    public string RawText { get => throw null; }
                    public static object RequiredValueAny;
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> RequiredValues { get => throw null; }
                }

                public class RoutePatternException : System.Exception
                {
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public string Pattern { get => throw null; }
                    public RoutePatternException(string pattern, string message) => throw null;
                }

                public static class RoutePatternFactory
                {
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Combine(Microsoft.AspNetCore.Routing.Patterns.RoutePattern left, Microsoft.AspNetCore.Routing.Patterns.RoutePattern right) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(Microsoft.AspNetCore.Routing.IRouteConstraint constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(object constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(string constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternLiteralPart LiteralPart(string content) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference> parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference[] parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference ParameterPolicy(Microsoft.AspNetCore.Routing.IParameterPolicy parameterPolicy) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference ParameterPolicy(string parameterPolicy) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, Microsoft.AspNetCore.Routing.RouteValueDictionary requiredValues) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, object defaults, object parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, object defaults, object parameterPolicies, object requiredValues) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(object defaults, object parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(object defaults, object parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, object defaults, object parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, object defaults, object parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment Segment(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart> parts) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment Segment(params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart[] parts) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternSeparatorPart SeparatorPart(string content) => throw null;
                }

                public class RoutePatternLiteralPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public string Content { get => throw null; }
                    internal RoutePatternLiteralPart(string content) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                }

                public enum RoutePatternParameterKind : int
                {
                    CatchAll = 2,
                    Optional = 1,
                    Standard = 0,
                }

                public class RoutePatternParameterPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public object Default { get => throw null; }
                    public bool EncodeSlashes { get => throw null; }
                    public bool IsCatchAll { get => throw null; }
                    public bool IsOptional { get => throw null; }
                    public string Name { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind ParameterKind { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference> ParameterPolicies { get => throw null; }
                    internal RoutePatternParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference[] parameterPolicies) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                    internal RoutePatternParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference[] parameterPolicies, bool encodeSlashes) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                }

                public class RoutePatternParameterPolicyReference
                {
                    public string Content { get => throw null; }
                    public Microsoft.AspNetCore.Routing.IParameterPolicy ParameterPolicy { get => throw null; }
                }

                public abstract class RoutePatternPart
                {
                    public bool IsLiteral { get => throw null; }
                    public bool IsParameter { get => throw null; }
                    public bool IsSeparator { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind PartKind { get => throw null; }
                    protected private RoutePatternPart(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind partKind) => throw null;
                }

                public enum RoutePatternPartKind : int
                {
                    Literal = 0,
                    Parameter = 1,
                    Separator = 2,
                }

                public class RoutePatternPathSegment
                {
                    public bool IsSimple { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart> Parts { get => throw null; }
                }

                public class RoutePatternSeparatorPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public string Content { get => throw null; }
                    internal RoutePatternSeparatorPart(string content) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                }

                public abstract class RoutePatternTransformer
                {
                    protected RoutePatternTransformer() => throw null;
                    public virtual Microsoft.AspNetCore.Routing.Patterns.RoutePattern SubstituteRequiredValues(Microsoft.AspNetCore.Routing.Patterns.RoutePattern original, Microsoft.AspNetCore.Routing.RouteValueDictionary requiredValues) => throw null;
                    public abstract Microsoft.AspNetCore.Routing.Patterns.RoutePattern SubstituteRequiredValues(Microsoft.AspNetCore.Routing.Patterns.RoutePattern original, object requiredValues);
                }

            }
            namespace Template
            {
                public class InlineConstraint
                {
                    public string Constraint { get => throw null; }
                    public InlineConstraint(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference other) => throw null;
                    public InlineConstraint(string constraint) => throw null;
                }

                public static class RoutePrecedence
                {
                    public static System.Decimal ComputeInbound(Microsoft.AspNetCore.Routing.Template.RouteTemplate template) => throw null;
                    public static System.Decimal ComputeOutbound(Microsoft.AspNetCore.Routing.Template.RouteTemplate template) => throw null;
                }

                public class RouteTemplate
                {
                    public Microsoft.AspNetCore.Routing.Template.TemplatePart GetParameter(string name) => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateSegment GetSegment(int index) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Template.TemplatePart> Parameters { get => throw null; }
                    public RouteTemplate(Microsoft.AspNetCore.Routing.Patterns.RoutePattern other) => throw null;
                    public RouteTemplate(string template, System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Template.TemplateSegment> segments) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Template.TemplateSegment> Segments { get => throw null; }
                    public string TemplateText { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePattern ToRoutePattern() => throw null;
                }

                public class TemplateBinder
                {
                    public string BindValues(Microsoft.AspNetCore.Routing.RouteValueDictionary acceptedValues) => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateValuesResult GetValues(Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    public static bool RoutePartsEqual(object a, object b) => throw null;
                    public bool TryProcessConstraints(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary combinedValues, out string parameterName, out Microsoft.AspNetCore.Routing.IRouteConstraint constraint) => throw null;
                }

                public abstract class TemplateBinderFactory
                {
                    public abstract Microsoft.AspNetCore.Routing.Template.TemplateBinder Create(Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern);
                    public abstract Microsoft.AspNetCore.Routing.Template.TemplateBinder Create(Microsoft.AspNetCore.Routing.Template.RouteTemplate template, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults);
                    protected TemplateBinderFactory() => throw null;
                }

                public class TemplateMatcher
                {
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate Template { get => throw null; }
                    public TemplateMatcher(Microsoft.AspNetCore.Routing.Template.RouteTemplate template, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults) => throw null;
                    public bool TryMatch(Microsoft.AspNetCore.Http.PathString path, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                }

                public static class TemplateParser
                {
                    public static Microsoft.AspNetCore.Routing.Template.RouteTemplate Parse(string routeTemplate) => throw null;
                }

                public class TemplatePart
                {
                    public static Microsoft.AspNetCore.Routing.Template.TemplatePart CreateLiteral(string text) => throw null;
                    public static Microsoft.AspNetCore.Routing.Template.TemplatePart CreateParameter(string name, bool isCatchAll, bool isOptional, object defaultValue, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Template.InlineConstraint> inlineConstraints) => throw null;
                    public object DefaultValue { get => throw null; }
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Template.InlineConstraint> InlineConstraints { get => throw null; }
                    public bool IsCatchAll { get => throw null; }
                    public bool IsLiteral { get => throw null; }
                    public bool IsOptional { get => throw null; }
                    public bool IsOptionalSeperator { get => throw null; set => throw null; }
                    public bool IsParameter { get => throw null; }
                    public string Name { get => throw null; }
                    public TemplatePart() => throw null;
                    public TemplatePart(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart other) => throw null;
                    public string Text { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart ToRoutePatternPart() => throw null;
                }

                public class TemplateSegment
                {
                    public bool IsSimple { get => throw null; }
                    public System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Template.TemplatePart> Parts { get => throw null; }
                    public TemplateSegment() => throw null;
                    public TemplateSegment(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment other) => throw null;
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment ToRoutePatternPathSegment() => throw null;
                }

                public class TemplateValuesResult
                {
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary AcceptedValues { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary CombinedValues { get => throw null; set => throw null; }
                    public TemplateValuesResult() => throw null;
                }

            }
            namespace Tree
            {
                public class InboundMatch
                {
                    public Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry Entry { get => throw null; set => throw null; }
                    public InboundMatch() => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateMatcher TemplateMatcher { get => throw null; set => throw null; }
                }

                public class InboundRouteEntry
                {
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.IRouter Handler { get => throw null; set => throw null; }
                    public InboundRouteEntry() => throw null;
                    public int Order { get => throw null; set => throw null; }
                    public System.Decimal Precedence { get => throw null; set => throw null; }
                    public string RouteName { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate RouteTemplate { get => throw null; set => throw null; }
                }

                public class OutboundMatch
                {
                    public Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry Entry { get => throw null; set => throw null; }
                    public OutboundMatch() => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateBinder TemplateBinder { get => throw null; set => throw null; }
                }

                public class OutboundRouteEntry
                {
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set => throw null; }
                    public object Data { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.IRouter Handler { get => throw null; set => throw null; }
                    public int Order { get => throw null; set => throw null; }
                    public OutboundRouteEntry() => throw null;
                    public System.Decimal Precedence { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RequiredLinkValues { get => throw null; set => throw null; }
                    public string RouteName { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate RouteTemplate { get => throw null; set => throw null; }
                }

                public class TreeRouteBuilder
                {
                    public Microsoft.AspNetCore.Routing.Tree.TreeRouter Build() => throw null;
                    public Microsoft.AspNetCore.Routing.Tree.TreeRouter Build(int version) => throw null;
                    public void Clear() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry> InboundEntries { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry MapInbound(Microsoft.AspNetCore.Routing.IRouter handler, Microsoft.AspNetCore.Routing.Template.RouteTemplate routeTemplate, string routeName, int order) => throw null;
                    public Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry MapOutbound(Microsoft.AspNetCore.Routing.IRouter handler, Microsoft.AspNetCore.Routing.Template.RouteTemplate routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary requiredLinkValues, string routeName, int order) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry> OutboundEntries { get => throw null; }
                }

                public class TreeRouter : Microsoft.AspNetCore.Routing.IRouter
                {
                    public Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                    public System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                    public static string RouteGroupKey;
                    public int Version { get => throw null; }
                }

                public class UrlMatchingNode
                {
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode CatchAlls { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode ConstrainedCatchAlls { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode ConstrainedParameters { get => throw null; set => throw null; }
                    public int Depth { get => throw null; }
                    public bool IsCatchAll { get => throw null; set => throw null; }
                    public System.Collections.Generic.Dictionary<string, Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode> Literals { get => throw null; }
                    public System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Tree.InboundMatch> Matches { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode Parameters { get => throw null; set => throw null; }
                    public UrlMatchingNode(int length) => throw null;
                }

                public class UrlMatchingTree
                {
                    public int Order { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode Root { get => throw null; }
                    public UrlMatchingTree(int order) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class RoutingServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRouting(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRouting(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Routing.RouteOptions> configureOptions) => throw null;
            }

        }
    }
}
