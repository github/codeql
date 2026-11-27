using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;

namespace Testing
{

    public class ViewModel
    {
        public string RequestId { get; set; } // Considered tainted.
        public object RequestIdField; // Considered tainted.
        public string RequestIdOnlyGet { get; } // Not considered tainted as there is no setter.
        public string RequestIdPrivateSet { get; private set; } // Not considered tainted as it has a private setter.
        public static object RequestIdStatic { get; set; } // Not considered tainted as it is static.
        private string RequestIdPrivate { get; set; } // Not considered tainted as it is private.
    }

    public class BaseModel
    {
        public string BaseProp { get; set; } // Considered tainted, as it is inherited by `DerivedModel`.
    }

    public class DerivedModel : BaseModel { }

    public class PlainDataModel
    {
        private string backing; // Considered tainted. The setter of `Backed` assigns `value` to it.
        private List<string> items = new List<string>(); // Considered tainted. Returned by the get-only collection `ItemsOnlyGet`.

        public string Backed // Taint flows out of the getter from `backing`.
        {
            get { if (backing == null) backing = ""; return backing; }
            set { backing = value ?? throw new ArgumentNullException(); }
        }

        public List<string> ItemsOnlyGet => items; // Taint flows out of the getter from `items`.
        public List<string> ItemsAutoOnlyGet { get; } = new List<string>(); // Considered tainted. Get-only collection.
        public string BackedOnlyGet => backing; // Taint flows out of the getter from `backing`, which is tainted.
        public List<string> ItemsCopy => new List<string>(items); // Not itself a candidate. Taint of `items` flows through the copy.
        public string Computed // Not itself a candidate. Taint of `backing` flows through the concatenation.
        {
            get { return backing + "x"; }
            set { backing = value; }
        }
        public const string Constant = "x"; // Not considered tainted as it is a constant.
        public short Number { get; set; } // Considered tainted. `short.MaxValue` is not.
    }

    public class FieldBase
    {
        protected string shared; // Not considered tainted. Only private fields are candidates, even if a setter assigns `value` to it.
    }

    public class InheritedField : FieldBase
    {
        public string Prop { get { return shared; } set { shared = value; } } // Not considered tainted. Its backing field `shared` is protected, not private.
        public string[] NamesOnlyGet { get; } = new[] { "fixed" }; // Not considered tainted. Binding cannot modify a get-only array.
    }

    public class FlowProps
    {
        private string f; // Considered tainted. The setters of `Coalesce` and `Cast` assign `value` to it.
        public string Discard { get { return ""; } set { } } // Not considered tainted. Ignores the value.
        public string Coalesce { get { return f ?? ""; } set { f = value; } } // Taint flows out of the getter from `f`.
        public string Cast { get { return f; } set { f = (string)(object)value; } } // Taint flows out of the getter from `f`.
        public string Ignore { get { return f; } set { f = "x"; } } // Setter ignores the value, so it does not make `f` tainted.
        private object o; // Considered tainted. The setter of `AsCast` assigns `value` to it.
        public string AsCast { get { return o as string; } set { o = value; } } // Considered tainted.
        private List<string> lazy; // Considered tainted. Returned by the get-only collection `LazyItems`.
        public List<string> LazyItems => lazy ??= new List<string>(); // Taint flows out of the getter from `lazy`.
        private string ow; // Considered tainted. The setter of `Overwrite` assigns `value` to it.
        public string Overwrite { get { ow = "safe"; return ow; } set { ow = value; } } // The getter overwrites `ow` before returning it, so data flow stops taint there.
        private string other; // Not considered tainted. The setter writes to another instance.
        public string OtherReceiver { get { return this.other; } set { new FlowProps().other = value; } } // Setter does not write to this instance's `other`.
    }

    public class GenericModel<T>
    {
        private List<T> items = new List<T>(); // Considered tainted. Returned by the get-only collection `ItemsPlain`.
        public List<T> ItemsCopy => new List<T>(items); // Not itself a candidate. Taint of `items` flows through the copy.
        public List<T> ItemsPlain => items; // Taint flows out of the getter from `items`.
    }

    public class AttributedModel
    {
        private string AutoBacking { get; set; }
        public string ViaAutoProp { set { AutoBacking = value; } } // Setter assigns `value` to the private auto-implemented property `AutoBacking`, which is considered tainted.
        private string unmarked; // Not considered tainted. Not assigned from a setter.
        private string guarded; // Considered tainted. The guarded setter of `Guarded` assigns `value` to it.
        public string Guarded { get { return guarded; } set { if (value == null) throw new ArgumentNullException(); guarded = value; } } // Taint flows out of the getter from `guarded`.
    }

    public class TestController : Controller
    {
        public object MyAction(PlainDataModel plain, DerivedModel derived, FlowProps fp, InheritedField inh, AttributedModel attributed)
        {
            throw null;
        }

        public object MyAction(ViewModel viewModel)
        {
            throw null;
        }

        public void BindingSources(
            string ordinary,
            [FromQuery] string fromQuery,
            [FromBody] string fromBody,
            [FromRoute] string fromRoute,
            [FromHeader] string fromHeader,
            [FromServices] IRequestService fromServices,
            [CustomFromServices] IRequestService customFromServices,
            [FromKeyedServices("cache")] IRequestService fromKeyedServices,
            [CustomFromKeyedServices] IRequestService customFromKeyedServices)
        { }
    }

    public interface IRequestService { }

    public sealed class CustomFromServicesAttribute : FromServicesAttribute { }

    public sealed class CustomFromKeyedServicesAttribute : FromKeyedServicesAttribute
    {
        public CustomFromKeyedServicesAttribute() : base("custom") { }
    }

    public class Item
    {
        public string Tainted { get; set; }
    }

    public class AspRoutingEndpoints
    {
        public delegate void MapGetHandler(string param);

        public void HandlerMethod(string param) { }

        public void M1(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            var app = builder.Build();

            // The delegate parameters are considered flow sources.
            app.MapGet("/api/redirect/{newUrl}", (string newUrl) => { });
            app.MapGet("/{myApi}/redirect/{myUrl}", (string myApi, string myUrl) => { });

            Action<string> handler = (string lambdaParam) => { };
            app.MapGet("/api/redirect/{lambdaParam}", handler);

            MapGetHandler handler2 = HandlerMethod;
            app.MapGet("/api/redirect/{mapGetParam}", handler2);

            app.MapPost("/api/redirect/{mapPostParam}", (string mapPostParam) => { });
            app.MapPut("/api/redirect/{mapPutParam}", (string mapPutParam) => { });
            app.MapDelete("/api/redirect/{mapDeleteParam}", (string mapDeleteParam) => { });

            app.MapPost("/items", (Item item) => { });

            app.Run();
        }
    }

    public abstract class AbstractTestController : Controller
    {
        public void MyActionMethod(string param) { }
    }

    // Razor Page handler tests
    public class MyPageModel : Microsoft.AspNetCore.Mvc.RazorPages.PageModel
    {
        // Handler method parameters are remote flow sources
        public void OnGet(string id) { }

        public void OnPost(string command, int count) { }

        public void OnPostAsync(string data) { }

        public void OnPut(string value) { }

        public void OnDelete(string itemId) { }

        // Not a handler method — does not start with "On", so not a flow source
        public void GetUser(string userId) { }

        // Excluded by [NonHandler] attribute, so not a flow source
        [Microsoft.AspNetCore.Mvc.RazorPages.NonHandlerAttribute]
        public void OnGetNonHandler(string param) { }
    }

    // Subclass of a PageModel subclass
    public class DerivedPageModel : MyPageModel
    {
        public void OnPost(string derivedParam) { }
    }
}
