namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Html
        {
            // Generated from `Microsoft.AspNetCore.Html.HtmlString` in `Microsoft.AspNetCore.Html.Abstractions, Version=1.1.2.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HtmlString : Microsoft.AspNetCore.Html.IHtmlContent
            {
                public HtmlString(string value) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Html.IHtmlContent` in `Microsoft.AspNetCore.Html.Abstractions, Version=1.1.2.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHtmlContent
            {
            }

        }
        namespace Http
        {
            // Generated from `Microsoft.AspNetCore.Http.HttpRequest` in `Microsoft.AspNetCore.Http.Abstractions, Version=1.1.2.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            abstract public class HttpRequest
            {
                public abstract Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
                public abstract Microsoft.AspNetCore.Http.IQueryCollection Query { get; set; }
                public abstract Microsoft.AspNetCore.Http.QueryString QueryString { get; set; }
                public abstract string ContentType { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.IHeaderDictionary` in `Microsoft.AspNetCore.Http.Features, Version=1.1.2.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHeaderDictionary : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
            {
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Http.IQueryCollection` in `Microsoft.AspNetCore.Http.Features, Version=1.1.2.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IQueryCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.Extensions.Primitives.StringValues>>
            {
                Microsoft.Extensions.Primitives.StringValues this[string key] { get; }
                bool TryGetValue(string key, out Microsoft.Extensions.Primitives.StringValues value);
            }

            // Generated from `Microsoft.AspNetCore.Http.QueryString` in `Microsoft.AspNetCore.Http.Abstractions, Version=1.1.2.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct QueryString : System.IEquatable<Microsoft.AspNetCore.Http.QueryString>
            {
                public bool Equals(Microsoft.AspNetCore.Http.QueryString other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public string Value { get => throw null; }
            }

        }
        namespace Mvc
        {
            // Generated from `Microsoft.AspNetCore.Mvc.ActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            abstract public class ActionResult : Microsoft.AspNetCore.Mvc.IActionResult
            {
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ControllerBase` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            abstract public class ControllerBase
            {
                public Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.Controller` in `Microsoft.AspNetCore.Mvc.ViewFeatures, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            abstract public class Controller : Microsoft.AspNetCore.Mvc.ControllerBase, System.IDisposable, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncActionFilter, Microsoft.AspNetCore.Mvc.Filters.IActionFilter
            {
                public virtual Microsoft.AspNetCore.Mvc.ViewResult View(object model) => throw null;
                public void Dispose() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromQueryAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromQueryAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public FromQueryAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpPostAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpPostAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPostAttribute() => throw null;
                public HttpPostAttribute(string template) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.IActionResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IActionResult
            {
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ValidateAntiForgeryTokenAttribute` in `Microsoft.AspNetCore.Mvc.ViewFeatures, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateAntiForgeryTokenAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public ValidateAntiForgeryTokenAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ViewResult` in `Microsoft.AspNetCore.Mvc.ViewFeatures, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ViewResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                public ViewResult() => throw null;
            }

            namespace Filters
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IActionFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncActionFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncActionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IFilterFactory` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterFactory : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IOrderedFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

            }
            namespace ModelBinding
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IBindingSourceMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IModelNameProvider
                {
                }

            }
            namespace Routing
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                abstract public class HttpMethodAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider, Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionHttpMethodProvider
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRouteTemplateProvider
                {
                }

            }
            namespace ViewFeatures
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary` in `Microsoft.AspNetCore.Mvc.ViewFeatures, Version=1.1.3.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ViewDataDictionary : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.Generic.ICollection<object> Values { get => throw null; }
                    public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                    public bool Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                    public bool ContainsKey(string key) => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public bool Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                    public bool Remove(string key) => throw null;
                    public bool TryGetValue(string key, out object value) => throw null;
                    public int Count { get => throw null; }
                    public object this[string index] { get => throw null; set => throw null; }
                    public void Add(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                    public void Add(string key, object value) => throw null;
                    public void Clear() => throw null;
                    public void CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace Primitives
        {
            // Generated from `Microsoft.Extensions.Primitives.StringValues` in `Microsoft.Extensions.Primitives, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct StringValues : System.IEquatable<string[]>, System.IEquatable<string>, System.IEquatable<Microsoft.Extensions.Primitives.StringValues>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<string>, System.Collections.Generic.IReadOnlyCollection<string>,
                System.Collections.Generic.IList<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.Generic.ICollection<string>
            {
                System.Collections.Generic.IEnumerator<string> System.Collections.Generic.IEnumerable<string>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.Generic.ICollection<string>.Contains(string item) => throw null;
                bool System.Collections.Generic.ICollection<string>.IsReadOnly { get => throw null; }
                bool System.Collections.Generic.ICollection<string>.Remove(string item) => throw null;
                int System.Collections.Generic.IList<string>.IndexOf(string item) => throw null;
                public bool Equals(Microsoft.Extensions.Primitives.StringValues other) => throw null;
                public bool Equals(string other) => throw null;
                public bool Equals(string[] other) => throw null;
                public int Count { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public static implicit operator string(Microsoft.Extensions.Primitives.StringValues values) => throw null;
                public string this[int index] { get => throw null; set => throw null; }
                public string[] ToArray() => throw null;
                void System.Collections.Generic.ICollection<string>.Add(string item) => throw null;
                void System.Collections.Generic.ICollection<string>.Clear() => throw null;
                void System.Collections.Generic.ICollection<string>.CopyTo(string[] array, int arrayIndex) => throw null;
                void System.Collections.Generic.IList<string>.Insert(int index, string item) => throw null;
                void System.Collections.Generic.IList<string>.RemoveAt(int index) => throw null;
            }

        }
    }
}
namespace System
{
    namespace Linq
    {
        // Generated from `System.Linq.Enumerable` in `System.Linq, Version=4.2.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        static public class Enumerable
        {
            public static TSource First<TSource>(this System.Collections.Generic.IEnumerable<TSource> source) => throw null;
        }

    }
}
