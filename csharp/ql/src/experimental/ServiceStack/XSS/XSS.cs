using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ServiceStack;
using ServiceStack.Web;
using SqlServer.ServiceModel;

namespace SqlServer.ServiceInterface
{
    public class MyServices : Service
    {
        // public object Any(Hello request)
        // {
        //     return new HelloResponse { Result = "Hello, {0}!".Fmt(request.Name) };
        // }

        //5. Using a Request or Response Filter
        [AddHeader(ContentType = "text/plain")]
        [AddHeader(ContentDisposition = "attachment; filename=hello.txt")]
        public string Get(Hello request)
        {
            return $"Hello, {request.Name}!";
        }

        //6. Returning responses in a decorated HttpResult
        public object Any(Hello request)
        {
          return new HttpResult($"Hello, {request.Name}!") {
            ContentType = MimeTypes.PlainText,
            Headers = {
              [HttpHeaders.ContentDisposition] = "attachment; filename=\"hello.txt\""
            }
          };
        }
    }
}