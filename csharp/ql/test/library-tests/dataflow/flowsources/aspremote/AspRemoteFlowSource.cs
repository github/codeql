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
        private string backing;
        private List<string> items = new List<string>();

        public string Backed // Considered tainted. Accessors wrap a backing field.
        {
            get { if (backing == null) backing = ""; return backing; }
            set { backing = value ?? throw new ArgumentNullException(); }
        }

        public List<string> ItemsOnlyGet => items; // Considered tainted. Get-only collection.
        public List<string> ItemsAutoOnlyGet { get; } = new List<string>(); // Considered tainted. Get-only collection.
        public string BackedOnlyGet => backing; // Not considered tainted as there is no setter.
        public List<string> ItemsCopy => new List<string>(items); // Not considered tainted as the getter computes a value.
        public string Computed // Not considered tainted as the getter computes a value.
        {
            get { return backing + "x"; }
            set { backing = value; }
        }
        public const string Constant = "x"; // Not considered tainted as it is a constant.
        public short Number { get; set; } // Considered tainted. `short.MaxValue` is not.
    }

    public class FieldBase
    {
        protected string shared;
    }

    public class InheritedField : FieldBase
    {
        public string Prop { get { return shared; } set { shared = value; } } // Considered tainted. Backing field is declared on a base type.
        public string[] NamesOnlyGet { get; } = new[] { "fixed" }; // Not considered tainted. Binding cannot modify a get-only array.
    }

    public class FlowProps
    {
        private string f;
        public string Discard { get { return ""; } set { } } // Not considered tainted. Ignores the value.
        public string Coalesce { get { return f ?? ""; } set { f = value; } } // Considered tainted.
        public string Cast { get { return f; } set { f = (string)(object)value; } } // Considered tainted.
        public string Ignore { get { return f; } set { f = "x"; } } // Not considered tainted. Setter ignores the value.
    }

    public class TestController : Controller
    {
        public object MyAction(PlainDataModel plain, DerivedModel derived, FlowProps fp, InheritedField inh)
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
