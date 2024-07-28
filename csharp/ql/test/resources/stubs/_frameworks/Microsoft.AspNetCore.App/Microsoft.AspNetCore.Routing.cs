// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Routing, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class EndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Map(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapDelete(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapDelete(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapGet(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapGet(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.RouteGroupBuilder MapGroup(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string prefix) => throw null;
                public static Microsoft.AspNetCore.Routing.RouteGroupBuilder MapGroup(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Routing.Patterns.RoutePattern prefix) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapMethods(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Collections.Generic.IEnumerable<string> httpMethods, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapMethods(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Collections.Generic.IEnumerable<string> httpMethods, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPatch(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapPatch(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPost(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapPost(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapPut(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder MapPut(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler) => throw null;
            }
            public static partial class EndpointRoutingApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseEndpoints(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, System.Action<Microsoft.AspNetCore.Routing.IEndpointRouteBuilder> configure) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouting(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }
            public static partial class FallbackEndpointRouteBuilderExtensions
            {
                public static readonly string DefaultPattern;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallback(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
            }
            public static partial class MapRouteRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults, object constraints) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string template, object defaults, object constraints, object dataTokens) => throw null;
            }
            public sealed class RouteHandlerBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public RouteHandlerBuilder(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Builder.IEndpointConventionBuilder> endpointConventionBuilders) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
            }
            public class RouterMiddleware
            {
                public RouterMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Routing.IRouter router) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
            }
            public static partial class RouteShortCircuitEndpointConventionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder ShortCircuit(this Microsoft.AspNetCore.Builder.IEndpointConventionBuilder builder, int? statusCode = default(int?)) => throw null;
            }
            public static partial class RoutingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouter(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Routing.IRouter router) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRouter(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> action) => throw null;
            }
            public static partial class RoutingEndpointConventionBuilderExtensions
            {
                public static TBuilder DisableAntiforgery<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder RequireHost<TBuilder>(this TBuilder builder, params string[] hosts) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithDisplayName<TBuilder>(this TBuilder builder, string displayName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithDisplayName<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Builder.EndpointBuilder, string> func) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithFormMappingOptions<TBuilder>(this TBuilder builder, int? maxCollectionSize = default(int?), int? maxRecursionDepth = default(int?), int? maxKeySize = default(int?)) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithFormOptions<TBuilder>(this TBuilder builder, bool? bufferBody = default(bool?), int? memoryBufferThreshold = default(int?), long? bufferBodyLengthLimit = default(long?), int? valueCountLimit = default(int?), int? keyLengthLimit = default(int?), int? valueLengthLimit = default(int?), int? multipartBoundaryLengthLimit = default(int?), int? multipartHeadersCountLimit = default(int?), int? multipartHeadersLengthLimit = default(int?), long? multipartBodyLengthLimit = default(long?)) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithGroupName<TBuilder>(this TBuilder builder, string endpointGroupName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithMetadata<TBuilder>(this TBuilder builder, params object[] items) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithName<TBuilder>(this TBuilder builder, string endpointName) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithOrder<TBuilder>(this TBuilder builder, int order) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }
        }
        namespace Http
        {
            public static partial class EndpointFilterExtensions
            {
                public static TBuilder AddEndpointFilter<TBuilder>(this TBuilder builder, Microsoft.AspNetCore.Http.IEndpointFilter filter) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder AddEndpointFilter<TBuilder, TFilterType>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder where TFilterType : Microsoft.AspNetCore.Http.IEndpointFilter => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder AddEndpointFilter<TFilterType>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder) where TFilterType : Microsoft.AspNetCore.Http.IEndpointFilter => throw null;
                public static Microsoft.AspNetCore.Routing.RouteGroupBuilder AddEndpointFilter<TFilterType>(this Microsoft.AspNetCore.Routing.RouteGroupBuilder builder) where TFilterType : Microsoft.AspNetCore.Http.IEndpointFilter => throw null;
                public static TBuilder AddEndpointFilter<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Http.EndpointFilterInvocationContext, Microsoft.AspNetCore.Http.EndpointFilterDelegate, System.Threading.Tasks.ValueTask<object>> routeHandlerFilter) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder AddEndpointFilterFactory<TBuilder>(this TBuilder builder, System.Func<Microsoft.AspNetCore.Http.EndpointFilterFactoryContext, Microsoft.AspNetCore.Http.EndpointFilterDelegate, Microsoft.AspNetCore.Http.EndpointFilterDelegate> filterFactory) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }
            public static partial class OpenApiRouteHandlerBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts<TRequest>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts<TRequest>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, bool isOptional, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, System.Type requestType, string contentType, params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Accepts(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, System.Type requestType, bool isOptional, string contentType, params string[] additionalContentTypes) => throw null;
                public static TBuilder ExcludeFromDescription<TBuilder>(this TBuilder builder) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder ExcludeFromDescription(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Produces<TResponse>(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode = default(int), string contentType = default(string), params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Produces(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode, System.Type responseType = default(System.Type), string contentType = default(string), params string[] additionalContentTypes) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder ProducesProblem(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode, string contentType = default(string)) => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder ProducesValidationProblem(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, int statusCode = default(int), string contentType = default(string)) => throw null;
                public static TBuilder WithDescription<TBuilder>(this TBuilder builder, string description) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithSummary<TBuilder>(this TBuilder builder, string summary) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static TBuilder WithTags<TBuilder>(this TBuilder builder, params string[] tags) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder WithTags(this Microsoft.AspNetCore.Builder.RouteHandlerBuilder builder, params string[] tags) => throw null;
            }
        }
        namespace Routing
        {
            public sealed class CompositeEndpointDataSource : Microsoft.AspNetCore.Routing.EndpointDataSource, System.IDisposable
            {
                public CompositeEndpointDataSource(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.EndpointDataSource> endpointDataSources) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.EndpointDataSource> DataSources { get => throw null; }
                public void Dispose() => throw null;
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                public override Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
                public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> GetGroupedEndpoints(Microsoft.AspNetCore.Routing.RouteGroupContext context) => throw null;
            }
            namespace Constraints
            {
                public class AlphaRouteConstraint : Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint
                {
                    public AlphaRouteConstraint() : base(default(System.Text.RegularExpressions.Regex)) => throw null;
                }
                public class BoolRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public BoolRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class CompositeRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; }
                    public CompositeRouteConstraint(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> constraints) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class DateTimeRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public DateTimeRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class DecimalRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public DecimalRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class DoubleRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public DoubleRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class FileNameRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public FileNameRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class FloatRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public FloatRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class GuidRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
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
                public class IntRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public IntRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class LengthRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public LengthRouteConstraint(int length) => throw null;
                    public LengthRouteConstraint(int minLength, int maxLength) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public int MaxLength { get => throw null; }
                    public int MinLength { get => throw null; }
                }
                public class LongRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public LongRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class MaxLengthRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public MaxLengthRouteConstraint(int maxLength) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public int MaxLength { get => throw null; }
                }
                public class MaxRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public MaxRouteConstraint(long max) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public long Max { get => throw null; }
                }
                public class MinLengthRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public MinLengthRouteConstraint(int minLength) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public int MinLength { get => throw null; }
                }
                public class MinRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public MinRouteConstraint(long min) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public long Min { get => throw null; }
                }
                public class NonFileNameRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public NonFileNameRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class OptionalRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public OptionalRouteConstraint(Microsoft.AspNetCore.Routing.IRouteConstraint innerConstraint) => throw null;
                    public Microsoft.AspNetCore.Routing.IRouteConstraint InnerConstraint { get => throw null; }
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }
                public class RangeRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public RangeRouteConstraint(long min, long max) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                    public long Max { get => throw null; }
                    public long Min { get => throw null; }
                }
                public class RegexInlineRouteConstraint : Microsoft.AspNetCore.Routing.Constraints.RegexRouteConstraint
                {
                    public RegexInlineRouteConstraint(string regexPattern) : base(default(System.Text.RegularExpressions.Regex)) => throw null;
                }
                public class RegexRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public System.Text.RegularExpressions.Regex Constraint { get => throw null; }
                    public RegexRouteConstraint(System.Text.RegularExpressions.Regex regex) => throw null;
                    public RegexRouteConstraint(string regexPattern) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
                public class RequiredRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public RequiredRouteConstraint() => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }
                public class StringRouteConstraint : Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy, Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public StringRouteConstraint(string value) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IParameterLiteralNodeMatchingPolicy.MatchesLiteral(string parameterName, string literal) => throw null;
                }
            }
            public sealed class DataTokensMetadata : Microsoft.AspNetCore.Routing.IDataTokensMetadata
            {
                public DataTokensMetadata(System.Collections.Generic.IReadOnlyDictionary<string, object> dataTokens) => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, object> DataTokens { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class DefaultEndpointDataSource : Microsoft.AspNetCore.Routing.EndpointDataSource
            {
                public DefaultEndpointDataSource(params Microsoft.AspNetCore.Http.Endpoint[] endpoints) => throw null;
                public DefaultEndpointDataSource(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
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
            [System.AttributeUsage((System.AttributeTargets)4164, Inherited = false, AllowMultiple = false)]
            public sealed class EndpointGroupNameAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IEndpointGroupNameMetadata
            {
                public EndpointGroupNameAttribute(string endpointGroupName) => throw null;
                public string EndpointGroupName { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)4160, Inherited = false, AllowMultiple = false)]
            public sealed class EndpointNameAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IEndpointNameMetadata
            {
                public EndpointNameAttribute(string endpointName) => throw null;
                public string EndpointName { get => throw null; }
            }
            public class EndpointNameMetadata : Microsoft.AspNetCore.Routing.IEndpointNameMetadata
            {
                public EndpointNameMetadata(string endpointName) => throw null;
                public string EndpointName { get => throw null; }
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4164, AllowMultiple = false, Inherited = true)]
            public sealed class ExcludeFromDescriptionAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IExcludeFromDescriptionMetadata
            {
                public ExcludeFromDescriptionAttribute() => throw null;
                public bool ExcludeFromDescription { get => throw null; }
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = false)]
            public sealed class HostAttribute : System.Attribute, Microsoft.AspNetCore.Routing.IHostMetadata
            {
                public HostAttribute(string host) => throw null;
                public HostAttribute(params string[] hosts) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> Hosts { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class HttpMethodMetadata : Microsoft.AspNetCore.Routing.IHttpMethodMetadata
            {
                public bool AcceptCorsPreflight { get => throw null; set { } }
                public HttpMethodMetadata(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                public HttpMethodMetadata(System.Collections.Generic.IEnumerable<string> httpMethods, bool acceptCorsPreflight) => throw null;
                public System.Collections.Generic.IReadOnlyList<string> HttpMethods { get => throw null; }
                public override string ToString() => throw null;
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
                virtual bool AcceptCorsPreflight { get => throw null; set { } }
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
            public static class InlineRouteParameterParser
            {
                public static Microsoft.AspNetCore.Routing.Template.TemplatePart ParseRouteParameter(string routeParameter) => throw null;
            }
            namespace Internal
            {
                public class DfaGraphWriter
                {
                    public DfaGraphWriter(System.IServiceProvider services) => throw null;
                    public void Write(Microsoft.AspNetCore.Routing.EndpointDataSource dataSource, System.IO.TextWriter writer) => throw null;
                }
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
            public static partial class LinkGeneratorEndpointNameAddressExtensions
            {
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, object values, Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, object values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, object values, string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByName(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string endpointName, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }
            public static partial class LinkGeneratorRouteValuesAddressExtensions
            {
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, object values, Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, object values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, object values, string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByRouteValues(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }
            public abstract class LinkParser
            {
                protected LinkParser() => throw null;
                public abstract Microsoft.AspNetCore.Routing.RouteValueDictionary ParsePathByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Http.PathString path);
            }
            public static partial class LinkParserEndpointNameAddressExtensions
            {
                public static Microsoft.AspNetCore.Routing.RouteValueDictionary ParsePathByEndpointName(this Microsoft.AspNetCore.Routing.LinkParser parser, string endpointName, Microsoft.AspNetCore.Http.PathString path) => throw null;
            }
            public abstract class MatcherPolicy
            {
                protected static bool ContainsDynamicEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                protected MatcherPolicy() => throw null;
                public abstract int Order { get; }
            }
            namespace Matching
            {
                public sealed class CandidateSet
                {
                    public int Count { get => throw null; }
                    public CandidateSet(Microsoft.AspNetCore.Http.Endpoint[] endpoints, Microsoft.AspNetCore.Routing.RouteValueDictionary[] values, int[] scores) => throw null;
                    public void ExpandEndpoint(int index, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints, System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> comparer) => throw null;
                    public bool IsValidCandidate(int index) => throw null;
                    public void ReplaceEndpoint(int index, Microsoft.AspNetCore.Http.Endpoint endpoint, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    public void SetValidity(int index, bool value) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.CandidateState this[int index] { get => throw null; }
                }
                public struct CandidateState
                {
                    public Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; }
                    public int Score { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; }
                }
                public sealed class EndpointMetadataComparer : System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint>
                {
                    int System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint>.Compare(Microsoft.AspNetCore.Http.Endpoint x, Microsoft.AspNetCore.Http.Endpoint y) => throw null;
                }
                public abstract class EndpointMetadataComparer<TMetadata> : System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> where TMetadata : class
                {
                    public int Compare(Microsoft.AspNetCore.Http.Endpoint x, Microsoft.AspNetCore.Http.Endpoint y) => throw null;
                    protected virtual int CompareMetadata(TMetadata x, TMetadata y) => throw null;
                    protected EndpointMetadataComparer() => throw null;
                    public static readonly Microsoft.AspNetCore.Routing.Matching.EndpointMetadataComparer<TMetadata> Default;
                    protected virtual TMetadata GetMetadata(Microsoft.AspNetCore.Http.Endpoint endpoint) => throw null;
                }
                public abstract class EndpointSelector
                {
                    protected EndpointSelector() => throw null;
                    public abstract System.Threading.Tasks.Task SelectAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates);
                }
                public sealed class HostMatcherPolicy : Microsoft.AspNetCore.Routing.MatcherPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy, Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy
                {
                    bool Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges) => throw null;
                    public System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get => throw null; }
                    public HostMatcherPolicy() => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public override int Order { get => throw null; }
                }
                public sealed class HttpMethodMatcherPolicy : Microsoft.AspNetCore.Routing.MatcherPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointComparerPolicy, Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy, Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy
                {
                    bool Microsoft.AspNetCore.Routing.Matching.INodeBuilderPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    bool Microsoft.AspNetCore.Routing.Matching.IEndpointSelectorPolicy.AppliesToEndpoints(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Threading.Tasks.Task ApplyAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.Matching.CandidateSet candidates) => throw null;
                    public Microsoft.AspNetCore.Routing.Matching.PolicyJumpTable BuildJumpTable(int exitDestination, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyJumpTableEdge> edges) => throw null;
                    public System.Collections.Generic.IComparer<Microsoft.AspNetCore.Http.Endpoint> Comparer { get => throw null; }
                    public HttpMethodMatcherPolicy() => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Matching.PolicyNodeEdge> GetEdges(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
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
                    protected PolicyJumpTable() => throw null;
                    public abstract int GetDestination(Microsoft.AspNetCore.Http.HttpContext httpContext);
                }
                public struct PolicyJumpTableEdge
                {
                    public PolicyJumpTableEdge(object state, int destination) => throw null;
                    public int Destination { get => throw null; }
                    public object State { get => throw null; }
                }
                public struct PolicyNodeEdge
                {
                    public PolicyNodeEdge(object state, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> Endpoints { get => throw null; }
                    public object State { get => throw null; }
                }
            }
            public abstract class ParameterPolicyFactory
            {
                public abstract Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, string inlineText);
                public abstract Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, Microsoft.AspNetCore.Routing.IParameterPolicy parameterPolicy);
                public Microsoft.AspNetCore.Routing.IParameterPolicy Create(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart parameter, Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference reference) => throw null;
                protected ParameterPolicyFactory() => throw null;
            }
            namespace Patterns
            {
                public sealed class RoutePattern
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Defaults { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart GetParameter(string name) => throw null;
                    public decimal InboundPrecedence { get => throw null; }
                    public decimal OutboundPrecedence { get => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference>> ParameterPolicies { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPart> Parameters { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> PathSegments { get => throw null; }
                    public string RawText { get => throw null; }
                    public static readonly object RequiredValueAny;
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> RequiredValues { get => throw null; }
                }
                public sealed class RoutePatternException : System.Exception
                {
                    public RoutePatternException(string pattern, string message) => throw null;
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public string Pattern { get => throw null; }
                }
                public static class RoutePatternFactory
                {
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Combine(Microsoft.AspNetCore.Routing.Patterns.RoutePattern left, Microsoft.AspNetCore.Routing.Patterns.RoutePattern right) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(object constraint) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference Constraint(Microsoft.AspNetCore.Routing.IRouteConstraint constraint) => throw null;
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
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, object defaults, object parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, object defaults, object parameterPolicies, object requiredValues) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Parse(string pattern, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, Microsoft.AspNetCore.Routing.RouteValueDictionary requiredValues) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(object defaults, object parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, object defaults, object parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment> segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(object defaults, object parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, object defaults, object parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePattern Pattern(string rawText, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, Microsoft.AspNetCore.Routing.RouteValueDictionary parameterPolicies, params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment[] segments) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment Segment(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart> parts) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment Segment(params Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart[] parts) => throw null;
                    public static Microsoft.AspNetCore.Routing.Patterns.RoutePatternSeparatorPart SeparatorPart(string content) => throw null;
                }
                public sealed class RoutePatternLiteralPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public string Content { get => throw null; }
                }
                public enum RoutePatternParameterKind
                {
                    Standard = 0,
                    Optional = 1,
                    CatchAll = 2,
                }
                public sealed class RoutePatternParameterPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public object Default { get => throw null; }
                    public bool EncodeSlashes { get => throw null; }
                    public bool IsCatchAll { get => throw null; }
                    public bool IsOptional { get => throw null; }
                    public string Name { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterKind ParameterKind { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference> ParameterPolicies { get => throw null; }
                }
                public sealed class RoutePatternParameterPolicyReference
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
                }
                public enum RoutePatternPartKind
                {
                    Literal = 0,
                    Parameter = 1,
                    Separator = 2,
                }
                public sealed class RoutePatternPathSegment
                {
                    public bool IsSimple { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart> Parts { get => throw null; }
                }
                public sealed class RoutePatternSeparatorPart : Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart
                {
                    public string Content { get => throw null; }
                }
                public abstract class RoutePatternTransformer
                {
                    protected RoutePatternTransformer() => throw null;
                    public abstract Microsoft.AspNetCore.Routing.Patterns.RoutePattern SubstituteRequiredValues(Microsoft.AspNetCore.Routing.Patterns.RoutePattern original, object requiredValues);
                    public virtual Microsoft.AspNetCore.Routing.Patterns.RoutePattern SubstituteRequiredValues(Microsoft.AspNetCore.Routing.Patterns.RoutePattern original, Microsoft.AspNetCore.Routing.RouteValueDictionary requiredValues) => throw null;
                }
            }
            public static partial class RequestDelegateRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapDelete(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapDelete(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapGet(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapGet(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareDelete(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareGet(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewarePost(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewarePut(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapMiddlewareVerb(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string verb, string template, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> action) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPost(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPost(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPut(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapPut(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapVerb(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string verb, string template, System.Func<Microsoft.AspNetCore.Http.HttpRequest, Microsoft.AspNetCore.Http.HttpResponse, Microsoft.AspNetCore.Routing.RouteData, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapVerb(this Microsoft.AspNetCore.Routing.IRouteBuilder builder, string verb, string template, Microsoft.AspNetCore.Http.RequestDelegate handler) => throw null;
            }
            public class Route : Microsoft.AspNetCore.Routing.RouteBase
            {
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeTemplate, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                public Route(Microsoft.AspNetCore.Routing.IRouter target, string routeName, string routeTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver) : base(default(string), default(string), default(Microsoft.AspNetCore.Routing.IInlineConstraintResolver), default(Microsoft.AspNetCore.Routing.RouteValueDictionary), default(System.Collections.Generic.IDictionary<string, object>), default(Microsoft.AspNetCore.Routing.RouteValueDictionary)) => throw null;
                protected override System.Threading.Tasks.Task OnRouteMatched(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                protected override Microsoft.AspNetCore.Routing.VirtualPathData OnVirtualPathGenerated(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public string RouteTemplate { get => throw null; }
            }
            public abstract class RouteBase : Microsoft.AspNetCore.Routing.INamedRouter, Microsoft.AspNetCore.Routing.IRouter
            {
                protected virtual Microsoft.AspNetCore.Routing.IInlineConstraintResolver ConstraintResolver { get => throw null; set { } }
                public virtual System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set { } }
                public RouteBase(string template, string name, Microsoft.AspNetCore.Routing.IInlineConstraintResolver constraintResolver, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults, System.Collections.Generic.IDictionary<string, object> constraints, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens) => throw null;
                public virtual Microsoft.AspNetCore.Routing.RouteValueDictionary DataTokens { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; set { } }
                protected static System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> GetConstraints(Microsoft.AspNetCore.Routing.IInlineConstraintResolver inlineConstraintResolver, Microsoft.AspNetCore.Routing.Template.RouteTemplate parsedTemplate, System.Collections.Generic.IDictionary<string, object> constraints) => throw null;
                protected static Microsoft.AspNetCore.Routing.RouteValueDictionary GetDefaults(Microsoft.AspNetCore.Routing.Template.RouteTemplate parsedTemplate, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults) => throw null;
                public virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public virtual string Name { get => throw null; set { } }
                protected abstract System.Threading.Tasks.Task OnRouteMatched(Microsoft.AspNetCore.Routing.RouteContext context);
                protected abstract Microsoft.AspNetCore.Routing.VirtualPathData OnVirtualPathGenerated(Microsoft.AspNetCore.Routing.VirtualPathContext context);
                public virtual Microsoft.AspNetCore.Routing.Template.RouteTemplate ParsedTemplate { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public override string ToString() => throw null;
            }
            public class RouteBuilder : Microsoft.AspNetCore.Routing.IRouteBuilder
            {
                public Microsoft.AspNetCore.Builder.IApplicationBuilder ApplicationBuilder { get => throw null; }
                public Microsoft.AspNetCore.Routing.IRouter Build() => throw null;
                public RouteBuilder(Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder) => throw null;
                public RouteBuilder(Microsoft.AspNetCore.Builder.IApplicationBuilder applicationBuilder, Microsoft.AspNetCore.Routing.IRouter defaultHandler) => throw null;
                public Microsoft.AspNetCore.Routing.IRouter DefaultHandler { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routes { get => throw null; }
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }
            public class RouteCollection : Microsoft.AspNetCore.Routing.IRouteCollection, Microsoft.AspNetCore.Routing.IRouter
            {
                public void Add(Microsoft.AspNetCore.Routing.IRouter router) => throw null;
                public int Count { get => throw null; }
                public RouteCollection() => throw null;
                public virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public virtual System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
                public Microsoft.AspNetCore.Routing.IRouter this[int index] { get => throw null; }
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
            public sealed class RouteEndpoint : Microsoft.AspNetCore.Http.Endpoint
            {
                public RouteEndpoint(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Routing.Patterns.RoutePattern routePattern, int order, Microsoft.AspNetCore.Http.EndpointMetadataCollection metadata, string displayName) : base(default(Microsoft.AspNetCore.Http.RequestDelegate), default(Microsoft.AspNetCore.Http.EndpointMetadataCollection), default(string)) => throw null;
                public int Order { get => throw null; }
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern RoutePattern { get => throw null; }
            }
            public sealed class RouteEndpointBuilder : Microsoft.AspNetCore.Builder.EndpointBuilder
            {
                public override Microsoft.AspNetCore.Http.Endpoint Build() => throw null;
                public RouteEndpointBuilder(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate, Microsoft.AspNetCore.Routing.Patterns.RoutePattern routePattern, int order) => throw null;
                public int Order { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern RoutePattern { get => throw null; set { } }
            }
            public sealed class RouteGroupBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder, Microsoft.AspNetCore.Routing.IEndpointRouteBuilder
            {
                void Microsoft.AspNetCore.Builder.IEndpointConventionBuilder.Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                Microsoft.AspNetCore.Builder.IApplicationBuilder Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.CreateApplicationBuilder() => throw null;
                System.Collections.Generic.ICollection<Microsoft.AspNetCore.Routing.EndpointDataSource> Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.DataSources { get => throw null; }
                void Microsoft.AspNetCore.Builder.IEndpointConventionBuilder.Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
                System.IServiceProvider Microsoft.AspNetCore.Routing.IEndpointRouteBuilder.ServiceProvider { get => throw null; }
            }
            public sealed class RouteGroupContext
            {
                public System.IServiceProvider ApplicationServices { get => throw null; set { } }
                public System.Collections.Generic.IReadOnlyList<System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder>> Conventions { get => throw null; set { } }
                public RouteGroupContext() => throw null;
                public System.Collections.Generic.IReadOnlyList<System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder>> FinallyConventions { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.Patterns.RoutePattern Prefix { get => throw null; set { } }
            }
            public class RouteHandler : Microsoft.AspNetCore.Routing.IRouteHandler, Microsoft.AspNetCore.Routing.IRouter
            {
                public RouteHandler(Microsoft.AspNetCore.Http.RequestDelegate requestDelegate) => throw null;
                public Microsoft.AspNetCore.Http.RequestDelegate GetRequestHandler(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                public Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context) => throw null;
                public System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context) => throw null;
            }
            public sealed class RouteHandlerOptions
            {
                public RouteHandlerOptions() => throw null;
                public bool ThrowOnBadRequest { get => throw null; set { } }
            }
            public static class RouteHandlerServices
            {
                public static Microsoft.AspNetCore.Builder.RouteHandlerBuilder Map(Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Delegate handler, System.Collections.Generic.IEnumerable<string> httpMethods, System.Func<System.Reflection.MethodInfo, Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions, Microsoft.AspNetCore.Http.RequestDelegateMetadataResult> populateMetadata, System.Func<System.Delegate, Microsoft.AspNetCore.Http.RequestDelegateFactoryOptions, Microsoft.AspNetCore.Http.RequestDelegateMetadataResult, Microsoft.AspNetCore.Http.RequestDelegateResult> createRequestDelegate) => throw null;
            }
            public sealed class RouteNameMetadata : Microsoft.AspNetCore.Routing.IRouteNameMetadata
            {
                public RouteNameMetadata(string routeName) => throw null;
                public string RouteName { get => throw null; }
                public override string ToString() => throw null;
            }
            public class RouteOptions
            {
                public bool AppendTrailingSlash { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, System.Type> ConstraintMap { get => throw null; set { } }
                public RouteOptions() => throw null;
                public bool LowercaseQueryStrings { get => throw null; set { } }
                public bool LowercaseUrls { get => throw null; set { } }
                public void SetParameterPolicy<T>(string token) where T : Microsoft.AspNetCore.Routing.IParameterPolicy => throw null;
                public void SetParameterPolicy(string token, System.Type type) => throw null;
                public bool SuppressCheckForUnhandledSecurityMetadata { get => throw null; set { } }
            }
            public static partial class RouteShortCircuitEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapShortCircuit(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder builder, int statusCode, params string[] routePrefixes) => throw null;
            }
            public class RouteValueEqualityComparer : System.Collections.Generic.IEqualityComparer<object>
            {
                public RouteValueEqualityComparer() => throw null;
                public static readonly Microsoft.AspNetCore.Routing.RouteValueEqualityComparer Default;
                public bool Equals(object x, object y) => throw null;
                public int GetHashCode(object obj) => throw null;
            }
            public class RouteValuesAddress
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; set { } }
                public RouteValuesAddress() => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary ExplicitValues { get => throw null; set { } }
                public string RouteName { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public class RoutingFeature : Microsoft.AspNetCore.Routing.IRoutingFeature
            {
                public RoutingFeature() => throw null;
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set { } }
            }
            public sealed class SuppressLinkGenerationMetadata : Microsoft.AspNetCore.Routing.ISuppressLinkGenerationMetadata
            {
                public SuppressLinkGenerationMetadata() => throw null;
                public bool SuppressLinkGeneration { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class SuppressMatchingMetadata : Microsoft.AspNetCore.Routing.ISuppressMatchingMetadata
            {
                public SuppressMatchingMetadata() => throw null;
                public bool SuppressMatching { get => throw null; }
                public override string ToString() => throw null;
            }
            namespace Template
            {
                public class InlineConstraint
                {
                    public string Constraint { get => throw null; }
                    public InlineConstraint(string constraint) => throw null;
                    public InlineConstraint(Microsoft.AspNetCore.Routing.Patterns.RoutePatternParameterPolicyReference other) => throw null;
                }
                public static class RoutePrecedence
                {
                    public static decimal ComputeInbound(Microsoft.AspNetCore.Routing.Template.RouteTemplate template) => throw null;
                    public static decimal ComputeOutbound(Microsoft.AspNetCore.Routing.Template.RouteTemplate template) => throw null;
                }
                public class RouteTemplate
                {
                    public RouteTemplate(Microsoft.AspNetCore.Routing.Patterns.RoutePattern other) => throw null;
                    public RouteTemplate(string template, System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Template.TemplateSegment> segments) => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplatePart GetParameter(string name) => throw null;
                    public Microsoft.AspNetCore.Routing.Template.TemplateSegment GetSegment(int index) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.Template.TemplatePart> Parameters { get => throw null; }
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
                    public abstract Microsoft.AspNetCore.Routing.Template.TemplateBinder Create(Microsoft.AspNetCore.Routing.Template.RouteTemplate template, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults);
                    public abstract Microsoft.AspNetCore.Routing.Template.TemplateBinder Create(Microsoft.AspNetCore.Routing.Patterns.RoutePattern pattern);
                    protected TemplateBinderFactory() => throw null;
                }
                public class TemplateMatcher
                {
                    public TemplateMatcher(Microsoft.AspNetCore.Routing.Template.RouteTemplate template, Microsoft.AspNetCore.Routing.RouteValueDictionary defaults) => throw null;
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate Template { get => throw null; }
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
                    public TemplatePart() => throw null;
                    public TemplatePart(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart other) => throw null;
                    public object DefaultValue { get => throw null; }
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.Template.InlineConstraint> InlineConstraints { get => throw null; }
                    public bool IsCatchAll { get => throw null; }
                    public bool IsLiteral { get => throw null; }
                    public bool IsOptional { get => throw null; }
                    public bool IsOptionalSeperator { get => throw null; set { } }
                    public bool IsParameter { get => throw null; }
                    public string Name { get => throw null; }
                    public string Text { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPart ToRoutePatternPart() => throw null;
                }
                public class TemplateSegment
                {
                    public TemplateSegment() => throw null;
                    public TemplateSegment(Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment other) => throw null;
                    public bool IsSimple { get => throw null; }
                    public System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Template.TemplatePart> Parts { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Patterns.RoutePatternPathSegment ToRoutePatternPathSegment() => throw null;
                }
                public class TemplateValuesResult
                {
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary AcceptedValues { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary CombinedValues { get => throw null; set { } }
                    public TemplateValuesResult() => throw null;
                }
            }
            namespace Tree
            {
                public class InboundMatch
                {
                    public InboundMatch() => throw null;
                    public Microsoft.AspNetCore.Routing.Tree.InboundRouteEntry Entry { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.Template.TemplateMatcher TemplateMatcher { get => throw null; set { } }
                }
                public class InboundRouteEntry
                {
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set { } }
                    public InboundRouteEntry() => throw null;
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.IRouter Handler { get => throw null; set { } }
                    public int Order { get => throw null; set { } }
                    public decimal Precedence { get => throw null; set { } }
                    public string RouteName { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate RouteTemplate { get => throw null; set { } }
                }
                public class OutboundMatch
                {
                    public OutboundMatch() => throw null;
                    public Microsoft.AspNetCore.Routing.Tree.OutboundRouteEntry Entry { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.Template.TemplateBinder TemplateBinder { get => throw null; set { } }
                }
                public class OutboundRouteEntry
                {
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set { } }
                    public OutboundRouteEntry() => throw null;
                    public object Data { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary Defaults { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.IRouter Handler { get => throw null; set { } }
                    public int Order { get => throw null; set { } }
                    public decimal Precedence { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RequiredLinkValues { get => throw null; set { } }
                    public string RouteName { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.Template.RouteTemplate RouteTemplate { get => throw null; set { } }
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
                    public static readonly string RouteGroupKey;
                    public int Version { get => throw null; }
                }
                public class UrlMatchingNode
                {
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode CatchAlls { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode ConstrainedCatchAlls { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode ConstrainedParameters { get => throw null; set { } }
                    public UrlMatchingNode(int length) => throw null;
                    public int Depth { get => throw null; }
                    public bool IsCatchAll { get => throw null; set { } }
                    public System.Collections.Generic.Dictionary<string, Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode> Literals { get => throw null; }
                    public System.Collections.Generic.List<Microsoft.AspNetCore.Routing.Tree.InboundMatch> Matches { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode Parameters { get => throw null; set { } }
                }
                public class UrlMatchingTree
                {
                    public UrlMatchingTree(int order) => throw null;
                    public int Order { get => throw null; }
                    public Microsoft.AspNetCore.Routing.Tree.UrlMatchingNode Root { get => throw null; }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class RoutingServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRouting(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRouting(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Routing.RouteOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRoutingCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }
        }
    }
}
