namespace Microsoft
{
namespace AspNetCore
{
namespace Http
{
// Generated from `Microsoft.AspNetCore.Http.HeaderDictionaryExtensions` in `Microsoft.AspNetCore.Http.Abstractions, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
static public class HeaderDictionaryExtensions
{
    public static void Append(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, Microsoft.Extensions.Primitives.StringValues value) => throw null;
    public static void AppendCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, params string[] values) => throw null;
    public static void SetCommaSeparatedValues(this Microsoft.AspNetCore.Http.IHeaderDictionary headers, string key, params string[] values) => throw null;
}

// Generated from `Microsoft.AspNetCore.Http.HttpResponse` in `Microsoft.AspNetCore.Http.Abstractions, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
abstract public class HttpResponse
{
    public abstract Microsoft.AspNetCore.Http.IHeaderDictionary Headers { get; }
    public virtual void Redirect(string location) => throw null;
}

// Generated from `Microsoft.AspNetCore.Http.IHeaderDictionary` in `Microsoft.AspNetCore.Http.Features, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IHeaderDictionary : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string,Microsoft.Extensions.Primitives.StringValues>>, System.Collections.Generic.IDictionary<string,Microsoft.Extensions.Primitives.StringValues>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string,Microsoft.Extensions.Primitives.StringValues>>
{
    Microsoft.Extensions.Primitives.StringValues this[string key] { get; set; }
}

namespace Headers
{
// Generated from `Microsoft.AspNetCore.Http.Headers.ResponseHeaders` in `Microsoft.AspNetCore.Http.Extensions, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class ResponseHeaders
{
    public ResponseHeaders(Microsoft.AspNetCore.Http.IHeaderDictionary headers) => throw null;
    public System.Uri Location { get => throw null; set => throw null; }
}

}
}
namespace Mvc
{
// Generated from `Microsoft.AspNetCore.Mvc.ActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
abstract public class ActionResult : Microsoft.AspNetCore.Mvc.IActionResult
{
}

// Generated from `Microsoft.AspNetCore.Mvc.ControllerBase` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
abstract public class ControllerBase
{
    public Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
    public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get => throw null; set => throw null; }
    public virtual Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string url) => throw null;
    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName) => throw null;
    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName) => throw null;
}

// Generated from `Microsoft.AspNetCore.Mvc.FromBodyAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class FromBodyAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
{
    public FromBodyAttribute() => throw null;
}

// Generated from `Microsoft.AspNetCore.Mvc.HttpPostAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class HttpPostAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
{
    public HttpPostAttribute() => throw null;
    public HttpPostAttribute(string template) => throw null;
}

// Generated from `Microsoft.AspNetCore.Mvc.HttpPutAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class HttpPutAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
{
    public HttpPutAttribute() => throw null;
    public HttpPutAttribute(string template) => throw null;
}

// Generated from `Microsoft.AspNetCore.Mvc.IActionResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IActionResult
{
}

// Generated from `Microsoft.AspNetCore.Mvc.IUrlHelper` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IUrlHelper
{
    bool IsLocalUrl(string url);
}

// Generated from `Microsoft.AspNetCore.Mvc.RedirectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class RedirectResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
{
}

// Generated from `Microsoft.AspNetCore.Mvc.RedirectToActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class RedirectToActionResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
{
}

// Generated from `Microsoft.AspNetCore.Mvc.RedirectToPageResult` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public class RedirectToPageResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
{
}

namespace ModelBinding
{
// Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IBindingSourceMetadata
{
}

}
namespace Routing
{
// Generated from `Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
abstract public class HttpMethodAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider, Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider
{
}

// Generated from `Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IActionHttpMethodProvider
{
}

// Generated from `Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IRouteTemplateProvider
{
}

}
namespace ViewFeatures
{
// Generated from `Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult` in `Microsoft.AspNetCore.Mvc.Core, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public interface IKeepTempDataResult : Microsoft.AspNetCore.Mvc.IActionResult
{
}

}
}
}
namespace Extensions
{
namespace Primitives
{
// Generated from `Microsoft.Extensions.Primitives.StringValues` in `Microsoft.Extensions.Primitives, Version=2.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
public struct StringValues : System.IEquatable<string[]>, System.IEquatable<string>, System.IEquatable<Microsoft.Extensions.Primitives.StringValues>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<string>, System.Collections.Generic.IReadOnlyCollection<string>, System.Collections.Generic.IList<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.Generic.ICollection<string>
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
    public static implicit operator Microsoft.Extensions.Primitives.StringValues(string value) => throw null;
    void System.Collections.Generic.ICollection<string>.Add(string item) => throw null;
    void System.Collections.Generic.ICollection<string>.Clear() => throw null;
    void System.Collections.Generic.ICollection<string>.CopyTo(string[] array, int arrayIndex) => throw null;
    void System.Collections.Generic.IList<string>.Insert(int index, string item) => throw null;
    void System.Collections.Generic.IList<string>.RemoveAt(int index) => throw null;
    public string this[int i] { get => throw null; set => throw null; }
}

}
}
}
namespace System
{
// Generated from `System.Uri` in `System.Private.Uri, Version=4.0.4.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
public class Uri : System.Runtime.Serialization.ISerializable
{
    public Uri(string uriString) => throw null;
    public override bool Equals(object comparand) => throw null;
    public override int GetHashCode() => throw null;
    public override string ToString() => throw null;
    void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
}

}
