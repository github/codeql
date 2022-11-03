namespace System
{
namespace Collections
{
namespace Specialized
{
// Generated from `System.Collections.Specialized.NameObjectCollectionBase` in `System.Collections.Specialized, Version=4.1.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
abstract public class NameObjectCollectionBase : System.Runtime.Serialization.ISerializable, System.Runtime.Serialization.IDeserializationCallback, System.Collections.IEnumerable, System.Collections.ICollection
{
    bool System.Collections.ICollection.IsSynchronized { get => throw null; }
    object System.Collections.ICollection.SyncRoot { get => throw null; }
    public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
    public virtual int Count { get => throw null; }
    public virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
    public virtual void OnDeserialization(object sender) => throw null;
    void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
}

// Generated from `System.Collections.Specialized.NameValueCollection` in `System.Collections.Specialized, Version=4.1.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
public class NameValueCollection : System.Collections.Specialized.NameObjectCollectionBase
{
    public string this[string name] { get => throw null; set => throw null; }
}

}
}
namespace IO
{
// Generated from `System.IO.TextWriter` in `System.Runtime.Extensions, Version=4.2.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
abstract public class TextWriter : System.MarshalByRefObject, System.IDisposable
{
    public void Dispose() => throw null;
}

}
namespace Web
{
// Generated from `System.Web.HttpContext` in `System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
public class HttpContext : System.Web.IPrincipalContainer
{
    public System.Web.HttpServerUtility Server { get => throw null; }
    public static System.Web.HttpContext Current { get => throw null; set => throw null; }
}

// Generated from `System.Web.HttpRequestBase` in `System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
abstract public class HttpRequestBase
{
    public virtual System.Collections.Specialized.NameValueCollection QueryString { get => throw null; }
}

// Generated from `System.Web.HttpServerUtility` in `System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
public class HttpServerUtility
{
    public string HtmlEncode(string s) => throw null;
}

// Generated from `System.Web.HttpUtility` in `System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
public class HttpUtility
{
    public static string HtmlEncode(string s) => throw null;
}

// Generated from `System.Web.IHtmlString` in `System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
public interface IHtmlString
{
}

// Generated from `System.Web.IPrincipalContainer` in `System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
interface IPrincipalContainer
{
}

namespace Mvc
{
// Generated from `System.Web.Mvc.HtmlHelper<>` in `System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
public class HtmlHelper<TModel> : System.Web.Mvc.HtmlHelper
{
}

// Generated from `System.Web.Mvc.HtmlHelper` in `System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
public class HtmlHelper
{
    public System.Web.IHtmlString Raw(string value) => throw null;
    public string Encode(string value) => throw null;
}

// Generated from `System.Web.Mvc.IViewDataContainer` in `System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
public interface IViewDataContainer
{
}

// Generated from `System.Web.Mvc.IViewStartPageChild` in `System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
interface IViewStartPageChild
{
}

// Generated from `System.Web.Mvc.WebViewPage<>` in `System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
abstract public class WebViewPage<TModel> : System.Web.Mvc.WebViewPage
{
    public System.Web.Mvc.HtmlHelper<TModel> Html { get => throw null; set => throw null; }
}

// Generated from `System.Web.Mvc.WebViewPage` in `System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
abstract public class WebViewPage : System.Web.WebPages.WebPageBase, System.Web.Mvc.IViewStartPageChild, System.Web.Mvc.IViewDataContainer
{
}

}
namespace WebPages
{
// Generated from `System.Web.WebPages.ITemplateFile` in `System.Web.WebPages, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
public interface ITemplateFile
{
}

// Generated from `System.Web.WebPages.StringExtensions` in `System.Web.WebPages, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
static public class StringExtensions
{
    public static bool IsEmpty(this string value) => throw null;
}

// Generated from `System.Web.WebPages.WebPageBase` in `System.Web.WebPages, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
abstract public class WebPageBase : System.Web.WebPages.WebPageRenderingBase
{
    public System.IO.TextWriter Output { get => throw null; }
    public override dynamic Page { get => throw null; }
    public override string Layout { get => throw null; set => throw null; }
    public override void Write(object value) => throw null;
    public override void WriteLiteral(object value) => throw null;
}

// Generated from `System.Web.WebPages.WebPageExecutingBase` in `System.Web.WebPages, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
abstract public class WebPageExecutingBase
{
    protected void BeginContext(string virtualPath, int startPosition, int length, bool isLiteral) => throw null;
    protected void EndContext(string virtualPath, int startPosition, int length, bool isLiteral) => throw null;
    public abstract void Execute();
    public abstract void Write(object value);
    public abstract void WriteLiteral(object value);
    public static void WriteLiteralTo(System.IO.TextWriter writer, object content) => throw null;
}

// Generated from `System.Web.WebPages.WebPageRenderingBase` in `System.Web.WebPages, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`
abstract public class WebPageRenderingBase : System.Web.WebPages.WebPageExecutingBase, System.Web.WebPages.ITemplateFile
{
    public abstract dynamic Page { get; }
    public abstract string Layout { get; set; }
    public virtual System.Web.HttpRequestBase Request { get => throw null; }
}

}
}
}
