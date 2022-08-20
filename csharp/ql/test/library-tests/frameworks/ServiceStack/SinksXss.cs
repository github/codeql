using System.Collections.Generic;
using System.Linq;
using ServiceStack;
using System.Threading.Tasks;
using System;

namespace ServiceStackTest
{
    public class XssServices : Service
    {
        public object Get(Request1 request)
        {
            return "<script>";
        }

        public object Post(Request1 request) => "<script>";

        private void SomeMethod()
        {
            var s = new HttpResult("", "");  // not a sink
        }

        public object Delete(Request1 req) => req; // not a sink

        public object Put(Request1 req) => new HttpResult("", "");
    }
}
