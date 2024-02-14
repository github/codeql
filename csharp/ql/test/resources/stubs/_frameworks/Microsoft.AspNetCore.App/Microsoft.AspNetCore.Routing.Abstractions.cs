// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Routing.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Routing
        {
            public interface IOutboundParameterTransformer : Microsoft.AspNetCore.Routing.IParameterPolicy
            {
                string TransformOutbound(object value);
            }
            public interface IParameterPolicy
            {
            }
            public interface IRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy
            {
                bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection);
            }
            public interface IRouteHandler
            {
                Microsoft.AspNetCore.Http.RequestDelegate GetRequestHandler(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData);
            }
            public interface IRouter
            {
                Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context);
                System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context);
            }
            public interface IRoutingFeature
            {
                Microsoft.AspNetCore.Routing.RouteData RouteData { get; set; }
            }
            public abstract class LinkGenerator
            {
                protected LinkGenerator() => throw null;
                public abstract string GetPathByAddress<TAddress>(Microsoft.AspNetCore.Http.HttpContext httpContext, TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                public abstract string GetPathByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                public abstract string GetUriByAddress<TAddress>(Microsoft.AspNetCore.Http.HttpContext httpContext, TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                public abstract string GetUriByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
            }
            public class LinkOptions
            {
                public bool? AppendTrailingSlash { get => throw null; set { } }
                public LinkOptions() => throw null;
                public bool? LowercaseQueryStrings { get => throw null; set { } }
                public bool? LowercaseUrls { get => throw null; set { } }
            }
            public class RouteContext
            {
                public RouteContext(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public Microsoft.AspNetCore.Http.RequestDelegate Handler { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set { } }
            }
            public class RouteData
            {
                public RouteData() => throw null;
                public RouteData(Microsoft.AspNetCore.Routing.RouteData other) => throw null;
                public RouteData(Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary DataTokens { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteData.RouteDataSnapshot PushState(Microsoft.AspNetCore.Routing.IRouter router, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens) => throw null;
                public struct RouteDataSnapshot
                {
                    public RouteDataSnapshot(Microsoft.AspNetCore.Routing.RouteData routeData, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> routers, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    public void Restore() => throw null;
                }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routers { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; }
            }
            public enum RouteDirection
            {
                IncomingRequest = 0,
                UrlGeneration = 1,
            }
            public static partial class RoutingHttpContextExtensions
            {
                public static Microsoft.AspNetCore.Routing.RouteData GetRouteData(this Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public static object GetRouteValue(this Microsoft.AspNetCore.Http.HttpContext httpContext, string key) => throw null;
            }
            public class VirtualPathContext
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; }
                public VirtualPathContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                public VirtualPathContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string routeName) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public string RouteName { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; set { } }
            }
            public class VirtualPathData
            {
                public VirtualPathData(Microsoft.AspNetCore.Routing.IRouter router, string virtualPath) => throw null;
                public VirtualPathData(Microsoft.AspNetCore.Routing.IRouter router, string virtualPath, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary DataTokens { get => throw null; }
                public Microsoft.AspNetCore.Routing.IRouter Router { get => throw null; set { } }
                public string VirtualPath { get => throw null; set { } }
            }
        }
    }
}
