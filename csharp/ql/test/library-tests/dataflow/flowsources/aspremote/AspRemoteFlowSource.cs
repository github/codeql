using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using System;

namespace Testing
{

    public class ViewModel
    {
        public string RequestId { get; set; } // Considered tainted.
        public object RequestIdField; // Not considered tainted as it is a field.
        public string RequestIdOnlyGet { get; } // Not considered tainted as there is no setter.
        public string RequestIdPrivateSet { get; private set; } // Not considered tainted as it has a private setter.
        public static object RequestIdStatic { get; set; } // Not considered tainted as it is static.
        private string RequestIdPrivate { get; set; } // Not considered tainted as it is private.
    }

    public class TestController : Controller
    {
        public object MyAction(ViewModel viewModel)
        {
            throw null;
        }
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
}
