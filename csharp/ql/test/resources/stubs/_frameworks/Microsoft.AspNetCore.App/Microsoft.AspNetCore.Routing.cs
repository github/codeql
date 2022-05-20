// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.EndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapDelete(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapGet(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapMethods(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Collections.Generic.IEnumerable<string> httpMethods, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPost(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPut(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.EndpointRoutingApplicationBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class EndpointRoutingApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseEndpoints(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, System.Action<Microsoft.AspNetCore.Routing.IEndpointRouteBuilder> configure) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouting(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.FallbackEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class FallbackEndpointRouteBuilderExtensions
            {
                public static string DefaultPattern;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.MapRouteRouteBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MapRouteRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults, object constraints, object dataTokens) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults, object constraints) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.RouterMiddleware` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouterMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public RouterMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Routing.IRouter router) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.RoutingBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RoutingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouter(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouter(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Routing.IRouter router) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.RoutingEndpointConventionBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RoutingEndpointConventionBuilderExtensions
            {
                public static TBuilder RequireHost<TBuilder>(this TBuilder builder, params string[] hosts) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithDisplayName<TBuilder>(this TBuilder builder, string displayName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithDisplayName<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Builder.EndpointBuilder, string> func) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithMetadata<TBuilder>(this TBuilder builder, params object[] items) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }

        }
        namespace Routing
        {
            // Generated from `Microsoft.AspNetCore.Routing.CompositeEndpointDataSource` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CompositeEndpointDataSource : Microsoft.AspNetCore.Routing.EndpointDataSource
            {
                public CompositeEndpointDataSource(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.EndpointDataSource> endpointDataSources) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.EndpointDataSource> DataSources { get => throw null; }
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                public override Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.DataTokensMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DataTokensMetadata : Microsoft.AspNetCore.Routing.IDataTokensMetadata
            {
                public System.Collections.Generic.IReadOnlyDictionary<string, object> DataTokens { get => throw null; }
                public DataTokensMetadata(System.Collections.Generic.IReadOnlyDictionary<string, object> dataTokens) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.DefaultEndpointDataSource` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultEndpointDataSource : Microsoft.AspNetCore.Routing.EndpointDataSource
            {
                public DefaultEndpointDataSource(params Microsoft.AspNetCore.Http.Endpoint[] endpoints) => throw null;
                public DefaultEndpointDataSource(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                public override Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.DefaultInlineConstraintResolver` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultInlineConstraintResolver : Microsoft.AspNetCore.Routing.IInlineConstraintResolver
            {
                public DefaultInlineConstraintResolver(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Routing.RouteOptions> routeOptions, System.IServiceProvider serviceProvider) => throw null;
                public virtual Microsoft.AspNetCore.Routing.IRouteConstraint ResolveConstraint(string inlineConstraint) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.EndpointDataSource` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class EndpointDataSource
            {
                protected EndpointDataSource() => throw null;
                public abstract System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get; }
                public abstract Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
            }

            // Generated from `Microsoft.AspNetCore.Routing.EndpointNameMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class EndpointNameMetadata : Microsoft.AspNetCore.Routing.IEndpointNameMetadata
            {
                public string EndpointName { get => throw null; }
                public EndpointNameMetadata(string endpointName) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.HostAttribute` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HostAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IHostMetadata
            {
                public HostAttribute(string host) => throw null;
                public HostAttribute(params string[] hosts) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> Hosts { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.HttpMethodMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpMethodMetadata : Microsoft.AspNetCore.Routing.IHttpMethodMetadata
            {
                public bool AcceptCorsPreflight { get => throw null; }
                public HttpMethodMetadata(System.Collections.Generic.IEnumerable<string> httpMethods, bool acceptCorsPreflight) => throw null;
                public HttpMethodMetadata(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> HttpMethods { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IDataTokensMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDataTokensMetadata
            {
                System.Collections.Generic.IReadOnlyDictionary<string, object> DataTokens { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IDynamicEndpointMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDynamicEndpointMetadata
            {
                bool IsDynamic { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IEndpointAddressScheme<>` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IEndpointAddressScheme<TAddress>
            {
                System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.Endpoint> FindEndpoints(TAddress address);
            }

            // Generated from `Microsoft.AspNetCore.Routing.IEndpointNameMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IEndpointNameMetadata
            {
                string EndpointName { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IEndpointRouteBuilder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IEndpointRouteBuilder
            {
                Microsoft.AspNetCore.Builder.IApplicationBuilder CreateApplicationBuilder();
                System.Collections.Generic.ICollection<Microsoft.AspNetCore.Routing.EndpointDataSource> DataSources { get; }
                System.IServiceProvider ServiceProvider { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IHostMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHostMetadata
            {
                System.Collections.Generic.IReadOnlyList<string> Hosts { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IHttpMethodMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHttpMethodMetadata
            {
                bool AcceptCorsPreflight { get; }
                System.Collections.Generic.IReadOnlyList<string> HttpMethods { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IInlineConstraintResolver` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IInlineConstraintResolver
            {
                Microsoft.AspNetCore.Routing.IRouteConstraint ResolveConstraint(string inlineConstraint);
            }

            // Generated from `Microsoft.AspNetCore.Routing.INamedRouter` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface INamedRouter : Microsoft.AspNetCore.Routing.IRouter
            {
                string Name { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRouteBuilder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRouteBuilder
            {
                Microsoft.AspNetCore.Builder.IApplicationBuilder ApplicationBuilder { get; }
                Microsoft.AspNetCore.Routing.IRouter Build();
                Microsoft.AspNetCore.Routing.IRouter DefaultHandler { get; set; }
                System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routes { get; }
                System.IServiceProvider ServiceProvider { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRouteCollection` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRouteCollection : Microsoft.AspNetCore.Routing.IRouter
            {
                void Add(Microsoft.AspNetCore.Routing.IRouter router);
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRouteNameMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRouteNameMetadata
            {
                string RouteName { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.ISuppressLinkGenerationMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISuppressLinkGenerationMetadata
            {
                bool SuppressLinkGeneration { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.ISuppressMatchingMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISuppressMatchingMetadata
            {
                bool SuppressMatching { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.InlineRouteParameterParser` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class InlineRouteParameterParser
            {
                public static Microsoft.AspNetCore.Routing.Template.TemplatePart ParseRouteParameter(string routeParameter) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.LinkGeneratorEndpointNameAddressExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LinkGeneratorEndpointNameAddressExtensions
            {
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, object values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, object values, Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, object values, string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.LinkGeneratorRouteValuesAddressExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LinkGeneratorRouteValuesAddressExtensions
            {
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, object values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, object values, Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, object values, string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.LinkParser` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class LinkParser
            {
                protected LinkParser() => throw null;
                public abstract Microsoft.AspNetCore.Routing.RouteValueDictionary ParsePathByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Http.PathString path);
            }

            // Generated from `Microsoft.AspNetCore.Routing.LinkParserEndpointNameAddressExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class LinkParserEndpointNameAddressExtensions
            {
                public static Microsoft.AspNetCore.Routing.RouteValueDictionary ParsePathByEndpointName(this Microsoft.AspNetCore.Routing.LinkParser parser, string endpointName, Microsoft.AspNetCore.Http.PathString path) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.MatcherPolicy` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class MatcherPolicy
            {
                protected static bool ContainsDynamicEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                protected MatcherPolicy() => throw null;
                public abstract int Order { get; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.ParameterPolicyFactory` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ParameterPolicyFactory
            {
                public abstract Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, string inlineText);
                public abstract Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, Microsoft.AspNetCore.Routing.IParameterPolicy parameterPolicy);
                public Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference reference) => throw null;
                protected ParameterPolicyFactory() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RequestDelegateRouteBuilderExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

            // Generated from `Microsoft.AspNetCore.Routing.Route` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class Route : Microsoft.AspNetCore.Routing.RouteBase
            {
                protected override System.Threading.Tasks.Task OnRouteMatched(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                protected override Microsoft.AspNetCore.Routing.VirtualPathData OnVirtualPathGenerated(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeTemplate, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeName, string routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public string RouteTemplate { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteBase` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class RouteBase : Microsoft.AspNetCore.Routing.IRouter, Microsoft.AspNetCore.Routing.INamedRouter
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

            // Generated from `Microsoft.AspNetCore.Routing.RouteBuilder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteBuilder : Microsoft.AspNetCore.Routing.IRouteBuilder
            {
                public Microsoft.AspNetCore.Builder.IApplicationBuilder ApplicationBuilder { get => throw null; }
                public Microsoft.AspNetCore.Routing.IRouter Build() => throw null;
                public Microsoft.AspNetCore.Routing.IRouter DefaultHandler { get => throw null; set => throw null; }
                public RouteBuilder(Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder, Microsoft.AspNetCore.Routing.IRouter defaultHandler) => throw null;
                public RouteBuilder(Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder) => throw null;
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routes { get => throw null; }
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteCollection` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteCollection : Microsoft.AspNetCore.Routing.IRouter, Microsoft.AspNetCore.Routing.IRouteCollection
            {
                public void Add(Microsoft.AspNetCore.Routing.IRouter router) => throw null;
                public int Count { get => throw null; }
                public virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public Microsoft.AspNetCore.Routing.IRouter this[int index] { get => throw null; }
                public virtual System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public RouteCollection() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteConstraintBuilder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteConstraintBuilder
            {
                public void AddConstraint(string key, object value) => throw null;
                public void AddResolvedConstraint(string key, string constraintText) => throw null;
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Build() => throw null;
                public RouteConstraintBuilder(Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver, string displayName) => throw null;
                public void SetOptional(string key) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteConstraintMatcher` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RouteConstraintMatcher
            {
                public static bool Match(System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary routeValues, Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, Microsoft.AspNetCore.Routing.RouteDirection routeDirection, Microsoft.Extensions.Logging.ILogger logger) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteCreationException` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteCreationException : System.Exception
            {
                public RouteCreationException(string message, System.Exception innerException) => throw null;
                public RouteCreationException(string message) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteEndpoint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteEndpoint : Microsoft.AspNetCore.Http.Endpoint
            {
                public int Order { get => throw null; }
                public RouteEndpoint(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Routing.Patterns.RoutePattern routePattern, int order, Microsoft.AspNetCore.Http.EndpointMetadataCollection metadata, string displayName) : base(default(Microsoft.AspNetCore.Http.RequestDelegate), default(Microsoft.AspNetCore.Http.EndpointMetadataCollection), default(string)) => throw null;
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern RoutePattern { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteEndpointBuilder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteEndpointBuilder : Microsoft.AspNetCore.Builder.EndpointBuilder
            {
                public override Microsoft.AspNetCore.Http.Endpoint Build() => throw null;
                public int Order { get => throw null; set => throw null; }
                public RouteEndpointBuilder(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Routing.Patterns.RoutePattern routePattern, int order) => throw null;
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern RoutePattern { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteHandler` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteHandler : Microsoft.AspNetCore.Routing.IRouter, Microsoft.AspNetCore.Routing.IRouteHandler
            {
                public Microsoft.AspNetCore.Http.RequestDelegate GetRequestHandler(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                public Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public RouteHandler(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteNameMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteNameMetadata : Microsoft.AspNetCore.Routing.IRouteNameMetadata
            {
                public string RouteName { get => throw null; }
                public RouteNameMetadata(string routeName) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteOptions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteOptions
            {
                public bool AppendTrailingSlash { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, System.Type> ConstraintMap { get => throw null; set => throw null; }
                public bool LowercaseQueryStrings { get => throw null; set => throw null; }
                public bool LowercaseUrls { get => throw null; set => throw null; }
                public RouteOptions() => throw null;
                public bool SuppressCheckForUnhandledSecurityMetadata { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteValueEqualityComparer` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteValueEqualityComparer : System.Collections.Generic.IEqualityComparer<object>
            {
                public static Microsoft.AspNetCore.Routing.RouteValueEqualityComparer Default;
                public bool Equals(object x, object y) => throw null;
                public int GetHashCode(object obj) => throw null;
                public RouteValueEqualityComparer() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteValuesAddress` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteValuesAddress
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary ExplicitValues { get => throw null; set => throw null; }
                public string RouteName { get => throw null; set => throw null; }
                public RouteValuesAddress() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.RoutingFeature` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RoutingFeature : Microsoft.AspNetCore.Routing.IRoutingFeature
            {
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set => throw null; }
                public RoutingFeature() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.SuppressLinkGenerationMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SuppressLinkGenerationMetadata : Microsoft.AspNetCore.Routing.ISuppressLinkGenerationMetadata
            {
                public bool SuppressLinkGeneration { get => throw null; }
                public SuppressLinkGenerationMetadata() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.SuppressMatchingMetadata` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SuppressMatchingMetadata : Microsoft.AspNetCore.Routing.ISuppressMatchingMetadata
            {
                public bool SuppressMatching { get => throw null; }
                public SuppressMatchingMetadata() => throw null;
            }

            namespace Constraints
            {
                // Generated from `Microsoft.AspNetCore.Routing.Constraints.AlphaRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AlphaRouteConstraint : Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint
                {
                    public AlphaRouteConstraint() : base(default(System.Text.RegularExpressions.Regex)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.BoolRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BoolRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public BoolRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.CompositeRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompositeRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public CompositeRouteConstraint(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> constraints) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.DateTimeRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DateTimeRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public DateTimeRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.DecimalRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DecimalRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public DecimalRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.DoubleRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DoubleRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public DoubleRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.FileNameRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FileNameRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public FileNameRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.FloatRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FloatRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public FloatRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.GuidRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class GuidRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public GuidRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.HttpMethodRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpMethodRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public System.Collections.Generic.IList<string> AllowedMethods { get => throw null; }
                    public HttpMethodRouteConstraint(params string[] allowedMethods) => throw null;
                    public virtual bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.IntRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IntRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public IntRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.LengthRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LengthRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public LengthRouteConstraint(int minLength, int maxLength) => throw null;
                    public LengthRouteConstraint(int length) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public int MaxLength { get => throw null; }
                    public int MinLength { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.LongRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LongRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public LongRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.MaxLengthRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MaxLengthRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public int MaxLength { get => throw null; }
                    public MaxLengthRouteConstraint(int maxLength) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.MaxRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MaxRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public System.Int64 Max { get => throw null; }
                    public MaxRouteConstraint(System.Int64 max) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.MinLengthRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MinLengthRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public int MinLength { get => throw null; }
                    public MinLengthRouteConstraint(int minLength) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.MinRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MinRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public System.Int64 Min { get => throw null; }
                    public MinRouteConstraint(System.Int64 min) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.NonFileNameRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NonFileNameRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public NonFileNameRouteConstraint() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.OptionalRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class OptionalRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public Microsoft.AspNetCore.Routing.IRouteConstraint InnerConstraint { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public OptionalRouteConstraint(Microsoft.AspNetCore.Routing.IRouteConstraint innerConstraint) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.RangeRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RangeRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public System.Int64 Max { get => throw null; }
                    public System.Int64 Min { get => throw null; }
                    public RangeRouteConstraint(System.Int64 min, System.Int64 max) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.RegexInlineRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RegexInlineRouteConstraint : Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint
                {
                    public RegexInlineRouteConstraint(string regexPattern) : base(default(System.Text.RegularExpressions.Regex)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RegexRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public System.Text.RegularExpressions.Regex Constraint { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public RegexRouteConstraint(string regexPattern) => throw null;
                    public RegexRouteConstraint(System.Text.RegularExpressions.Regex regex) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.RequiredRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RequiredRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public RequiredRouteConstraint() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Constraints.StringRouteConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class StringRouteConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    public StringRouteConstraint(string value) => throw null;
                }

            }
            namespace Internal
            {
                // Generated from `Microsoft.AspNetCore.Routing.Internal.DfaGraphWriter` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DfaGraphWriter
                {
                    public DfaGraphWriter(System.IServiceProvider services) => throw null;
                    public void Write(Microsoft.AspNetCore.Routing.EndpointDataSource dataSource, System.IO.TextWriter writer) => throw null;
                }

            }
            namespace Matching
            {
                // Generated from `Microsoft.AspNetCore.Routing.Matching.CandidateSet` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Routing.Matching.CandidateState` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct CandidateState
                {
                    // Stub generator skipped constructor 
                    public Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; }
                    public int Score { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.EndpointMetadataComparer` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EndpointMetadataComparer : System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint>
                {
                    int System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint>.Compare(Microsoft.AspNetCore.Http.Endpoint x, Microsoft.AspNetCore.Http.Endpoint y) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.EndpointMetadataComparer<>` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class EndpointMetadataComparer<TMetadata> : System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> where TMetadata : class
                {
                    public int Compare(Microsoft.AspNetCore.Http.Endpoint x, Microsoft.AspNetCore.Http.Endpoint y) => throw null;
                    protected virtual int CompareMetadata(TMetadata x, TMetadata y) => throw null;
                    public static Microsoft.AspNetCore.Routing.Matching.EndpointMetadataComparer<TMetadata> Default;
                    protected EndpointMetadataComparer() => throw null;
                    protected virtual TMetadata GetMetadata(Microsoft.AspNetCore.Http.Endpoint endpoint) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.EndpointSelector` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class EndpointSelector
                {
                    protected EndpointSelector() => throw null;
                    public abstract System.Threading.Tasks.Task SelectAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates);
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.HostMatcherPolicy` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HostMatcherPolicy : Microsoft.AspNetCore.Routing.MatcherPolicy, Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy
                {
                    bool Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges) => throw null;
                    public System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public HostMatcherPolicy() => throw null;
                    public override int Order { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.HttpMethodMatcherPolicy` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpMethodMatcherPolicy : Microsoft.AspNetCore.Routing.MatcherPolicy, Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy
                {
                    bool Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges) => throw null;
                    public System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public HttpMethodMatcherPolicy() => throw null;
                    public override int Order { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IEndpointComparerPolicy
                {
                    System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IEndpointSelectorPolicy
                {
                    bool AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints);
                    System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates);
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface INodeBuilderPolicy
                {
                    bool AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints);
                    Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges);
                    System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints);
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class PolicyJumpTable
                {
                    public abstract int GetDestination(Microsoft.AspNetCore.Http.HttpContext httpContext);
                    protected PolicyJumpTable() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct PolicyJumpTableEdge
                {
                    public int Destination { get => throw null; }
                    public PolicyJumpTableEdge(object state, int destination) => throw null;
                    // Stub generator skipped constructor 
                    public object State { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct PolicyNodeEdge
                {
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                    public PolicyNodeEdge(object state, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    // Stub generator skipped constructor 
                    public object State { get => throw null; }
                }

            }
            namespace Patterns
            {
                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePattern` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternException` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RoutePatternException : System.Exception
                {
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public string Pattern { get => throw null; }
                    public RoutePatternException(string pattern, string message) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternFactory` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class RoutePatternFactory
                {
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(string constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(object constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(Microsoft.AspNetCore.Routing.IRouteConstraint constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternLiteralPart LiteralPart(string content) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference[] parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference> parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName, object @default) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart ParameterPart(string parameterName) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference ParameterPolicy(string parameterPolicy) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference ParameterPolicy(Microsoft.AspNetCore.Routing.IParameterPolicy parameterPolicy) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, object defaults, object parameterPolicies, object requiredValues) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, object defaults, object parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, object defaults, object parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, object defaults, object parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(object defaults, object parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(object defaults, object parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment Segment(params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart[] parts) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment Segment(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart> parts) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternSeparatorPart SeparatorPart(string content) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternLiteralPart` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RoutePatternLiteralPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public string Content { get => throw null; }
                    internal RoutePatternLiteralPart(string content) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum RoutePatternParameterKind
                {
                    CatchAll,
                    Optional,
                    Standard,
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RoutePatternParameterPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public object Default { get => throw null; }
                    public bool EncodeSlashes { get => throw null; }
                    public bool IsCatchAll { get => throw null; }
                    public bool IsOptional { get => throw null; }
                    public string Name { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind ParameterKind { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference> ParameterPolicies { get => throw null; }
                    internal RoutePatternParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference[] parameterPolicies, bool encodeSlashes) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                    internal RoutePatternParameterPart(string parameterName, object @default, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind parameterKind, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference[] parameterPolicies) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RoutePatternParameterPolicyReference
                {
                    public string Content { get => throw null; }
                    public Microsoft.AspNetCore.Routing.IParameterPolicy ParameterPolicy { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RoutePatternPart
                {
                    public bool IsLiteral { get => throw null; }
                    public bool IsParameter { get => throw null; }
                    public bool IsSeparator { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind PartKind { get => throw null; }
                    protected private RoutePatternPart(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind partKind) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum RoutePatternPartKind
                {
                    Literal,
                    Parameter,
                    Separator,
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RoutePatternPathSegment
                {
                    public bool IsSimple { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart> Parts { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternSeparatorPart` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RoutePatternSeparatorPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public string Content { get => throw null; }
                    internal RoutePatternSeparatorPart(string content) : base(default(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPartKind)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Patterns.RoutePatternTransformer` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RoutePatternTransformer
                {
                    protected RoutePatternTransformer() => throw null;
                    public abstract Microsoft.AspNetCore.Routing.Patterns.RoutePattern SubstituteRequiredValues(Microsoft.AspNetCore.Routing.Patterns.RoutePattern original, object requiredValues);
                }

            }
            namespace Template
            {
                // Generated from `Microsoft.AspNetCore.Routing.Template.InlineConstraint` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InlineConstraint
                {
                    public string Constraint { get => throw null; }
                    public InlineConstraint(string constraint) => throw null;
                    public InlineConstraint(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference other) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.RoutePrecedence` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class RoutePrecedence
                {
                    public static System.Decimal ComputeInbound(Microsoft.AspNetCore.Routing.Template.RouteTemplate template) => throw null;
                    public static System.Decimal ComputeOutbound(Microsoft.AspNetCore.Routing.Template.RouteTemplate template) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.RouteTemplate` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RouteTemplate
                {
                    public Microsoft.AspNetCore.Routing.Template.TemplatePart GetParameter(string name) => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateSegment GetSegment(int index) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Template.TemplatePart> Parameters { get => throw null; }
                    public RouteTemplate(string template, System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Template.TemplateSegment> segments) => throw null;
                    public RouteTemplate(Microsoft.AspNetCore.Routing.Patterns.RoutePattern other) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Template.TemplateSegment> Segments { get => throw null; }
                    public string TemplateText { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePattern ToRoutePattern() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplateBinder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TemplateBinder
                {
                    public string BindValues(Microsoft.AspNetCore.Routing.RouteValueDictionary acceptedValues) => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateValuesResult GetValues(Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    public static bool RoutePartsEqual(object a, object b) => throw null;
                    public bool TryProcessConstraints(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary combinedValues, out string parameterName, out Microsoft.AspNetCore.Routing.IRouteConstraint constraint) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplateBinderFactory` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class TemplateBinderFactory
                {
                    public abstract Microsoft.AspNetCore.Routing.Template.TemplateBinder Create(Microsoft.AspNetCore.Routing.Template.RouteTemplate template, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults);
                    public abstract Microsoft.AspNetCore.Routing.Template.TemplateBinder Create(Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern);
                    protected TemplateBinderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplateMatcher` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TemplateMatcher
                {
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate Template { get => throw null; }
                    public TemplateMatcher(Microsoft.AspNetCore.Routing.Template.RouteTemplate template, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults) => throw null;
                    public bool TryMatch(Microsoft.AspNetCore.Http.PathString path, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplateParser` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class TemplateParser
                {
                    public static Microsoft.AspNetCore.Routing.Template.RouteTemplate Parse(string routeTemplate) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplatePart` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                    public TemplatePart(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart other) => throw null;
                    public TemplatePart() => throw null;
                    public string Text { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart ToRoutePatternPart() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplateSegment` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TemplateSegment
                {
                    public bool IsSimple { get => throw null; }
                    public System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Template.TemplatePart> Parts { get => throw null; }
                    public TemplateSegment(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment other) => throw null;
                    public TemplateSegment() => throw null;
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment ToRoutePatternPathSegment() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Routing.Template.TemplateValuesResult` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TemplateValuesResult
                {
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary AcceptedValues { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary CombinedValues { get => throw null; set => throw null; }
                    public TemplateValuesResult() => throw null;
                }

            }
            namespace Tree
            {
                // Generated from `Microsoft.AspNetCore.Routing.Tree.InboundMatch` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InboundMatch
                {
                    public Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry Entry { get => throw null; set => throw null; }
                    public InboundMatch() => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateMatcher TemplateMatcher { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Routing.Tree.OutboundMatch` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class OutboundMatch
                {
                    public Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry Entry { get => throw null; set => throw null; }
                    public OutboundMatch() => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateBinder TemplateBinder { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Routing.Tree.TreeRouteBuilder` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TreeRouteBuilder
                {
                    public Microsoft.AspNetCore.Routing.Tree.TreeRouter Build(int version) => throw null;
                    public Microsoft.AspNetCore.Routing.Tree.TreeRouter Build() => throw null;
                    public void Clear() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry> InboundEntries { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry MapInbound(Microsoft.AspNetCore.Routing.IRouter handler, Microsoft.AspNetCore.Routing.Template.RouteTemplate routeTemplate, string routeName, int order) => throw null;
                    public Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry MapOutbound(Microsoft.AspNetCore.Routing.IRouter handler, Microsoft.AspNetCore.Routing.Template.RouteTemplate routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary requiredLinkValues, string routeName, int order) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry> OutboundEntries { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Tree.TreeRouter` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TreeRouter : Microsoft.AspNetCore.Routing.IRouter
                {
                    public Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                    public System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                    public static string RouteGroupKey;
                    public int Version { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                // Generated from `Microsoft.AspNetCore.Routing.Tree.UrlMatchingTree` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
            // Generated from `Microsoft.Extensions.DependencyInjection.RoutingServiceCollectionExtensions` in `Microsoft.AspNetCore.Routing, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RoutingServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRouting(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Routing.RouteOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRouting(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
