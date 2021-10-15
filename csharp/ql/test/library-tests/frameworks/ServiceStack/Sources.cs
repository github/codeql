using System.Collections.Generic;
using System.Linq;
using ServiceStack;
using System.Threading.Tasks;
using System;

namespace ServiceStackTest
{
    public class MyServices1 : Service
    {
        public object Get(string request) => throw null; // this might not be a remote source
        public object Get(Request1 request) => throw null;
        public object Get(Request2 request) => throw null;
        public object Get(Request3 request) => throw null; // might be a remote source if routes are looked up with Routes.AddFromAssembly
        public object Get(Request4 request)
        {
            Console.WriteLine(request.Nested.Prop1);
            Console.WriteLine(request.Nested.Prop2[0].Prop1);
            throw null;
        }

        public object Post(Request1 request) => throw null;
        public Task<object> PostAsync(Request1 request) => throw null;
        public object Method1(Request1 request) // Not a request method
        {
            Console.WriteLine(request.Field1);
            throw null;
        }

        public object GetJson(Request1 request) => throw null;
    }

    public class MyServices2 : IService
    {
        public object Get(Request1 request) => throw null;
    }

    public class Request1 : IReturn<Response1>
    {
        public string Field1;
    }

    public class Response1
    {
        public string Result { get; set; }
    }

    [Route("/req2/{Prop1}")]
    public class Request2
    {
        public string Prop1 { get; set; }
    }

    public class Request3
    {
        public string Prop1 { get; set; }
    }

    [Route("/req4")]
    public class Request4 : IReturnVoid
    {
        public string Prop1 { get; set; }
        public Nested Nested { get; set; }
    }

    public class Nested
    {
        public string Prop1 { get; set; }
        public List<Element> Prop2 { get; set; }
    }

    public class Element
    {
        public string Prop1 { get; set; }
    }
}
