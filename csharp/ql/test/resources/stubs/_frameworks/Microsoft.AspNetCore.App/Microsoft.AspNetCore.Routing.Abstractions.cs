// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Routing
        {
            // Generated from `Microsoft.AspNetCore.Routing.IOutboundParameterTransformer` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOutboundParameterTransformer : Microsoft.AspNetCore.Routing.IParameterPolicy
            {
                string TransformOutbound(object value);
            }

            // Generated from `Microsoft.AspNetCore.Routing.IParameterPolicy` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IParameterPolicy
            {
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRouteConstraint` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRouteConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy
            {
                bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection);
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRouteHandler` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRouteHandler
            {
                Microsoft.AspNetCore.Http.RequestDelegate GetRequestHandler(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData);
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRouter` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRouter
            {
                Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPath(Microsoft.AspNetCore.Routing.VirtualPathContext context);
                System.Threading.Tasks.Task RouteAsync(Microsoft.AspNetCore.Routing.RouteContext context);
            }

            // Generated from `Microsoft.AspNetCore.Routing.IRoutingFeature` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRoutingFeature
            {
                Microsoft.AspNetCore.Routing.RouteData RouteData { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.LinkGenerator` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class LinkGenerator
            {
                public abstract string GetPathByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                public abstract string GetPathByAddress<TAddress>(Microsoft.AspNetCore.Http.HttpContext httpContext, TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                public abstract string GetUriByAddress<TAddress>(TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                public abstract string GetUriByAddress<TAddress>(Microsoft.AspNetCore.Http.HttpContext httpContext, TAddress address, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues = default(Microsoft.AspNetCore.Routing.RouteValueDictionary), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions));
                protected LinkGenerator() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.LinkOptions` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LinkOptions
            {
                public bool? AppendTrailingSlash { get => throw null; set => throw null; }
                public LinkOptions() => throw null;
                public bool? LowercaseQueryStrings { get => throw null; set => throw null; }
                public bool? LowercaseUrls { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteContext` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteContext
            {
                public Microsoft.AspNetCore.Http.RequestDelegate Handler { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public RouteContext(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteData` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteData
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary DataTokens { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteData.RouteDataSnapshot PushState(Microsoft.AspNetCore.Routing.IRouter router, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens) => throw null;
                public RouteData(Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                public RouteData(Microsoft.AspNetCore.Routing.RouteData other) => throw null;
                public RouteData() => throw null;
                // Generated from `Microsoft.AspNetCore.Routing.RouteData+RouteDataSnapshot` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct RouteDataSnapshot
                {
                    public void Restore() => throw null;
                    public RouteDataSnapshot(Microsoft.AspNetCore.Routing.RouteData routeData, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens, System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> routers, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    // Stub generator skipped constructor 
                }


                public System.Collections.Generic.IList<Microsoft.AspNetCore.Routing.IRouter> Routers { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Routing.RouteDirection` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum RouteDirection
            {
                IncomingRequest,
                UrlGeneration,
            }

            // Generated from `Microsoft.AspNetCore.Routing.RoutingHttpContextExtensions` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RoutingHttpContextExtensions
            {
                public static Microsoft.AspNetCore.Routing.RouteData GetRouteData(this Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public static object GetRouteValue(this Microsoft.AspNetCore.Http.HttpContext httpContext, string key) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.VirtualPathContext` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class VirtualPathContext
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public string RouteName { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary Values { get => throw null; set => throw null; }
                public VirtualPathContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues, Microsoft.AspNetCore.Routing.RouteValueDictionary values, string routeName) => throw null;
                public VirtualPathContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary ambientValues, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.VirtualPathData` in `Microsoft.AspNetCore.Routing.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class VirtualPathData
            {
                public Microsoft.AspNetCore.Routing.RouteValueDictionary DataTokens { get => throw null; }
                public Microsoft.AspNetCore.Routing.IRouter Router { get => throw null; set => throw null; }
                public string VirtualPath { get => throw null; set => throw null; }
                public VirtualPathData(Microsoft.AspNetCore.Routing.IRouter router, string virtualPath, Microsoft.AspNetCore.Routing.RouteValueDictionary dataTokens) => throw null;
                public VirtualPathData(Microsoft.AspNetCore.Routing.IRouter router, string virtualPath) => throw null;
            }

        }
    }
}
