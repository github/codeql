using System;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Headers;
using Microsoft.AspNetCore.Mvc;

namespace Testing.Controllers
{
    public class SomeController : ControllerBase
    {
        private static string SomeValue = "HeaderValue";

        [HttpPost]
        public void Post([FromBody] string value) // $ Source=r9 Source=r10 Source=r11 Source=r12 Source=r13 Source=r14 Source=r15
        {
            // BAD: straight up controller redirect
            Redirect(value); // $ Alert=r9 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14 Alert=r15

            // BAD: Setting response headers collection, location = redirect
            Response.Headers["location"] = value; // $ Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14 Alert=r15 Alert=r9

            // GOOD: Setting response header to a constant value
            Response.Headers["location"] = SomeValue;

            // BAD: Setting response headers collection, location = redirect via add method
            Response.Headers.Add("location", value); // $ Alert=r11 Alert=r10 Alert=r12 Alert=r13 Alert=r14 Alert=r15 Alert=r9

            // GOOD: Setting response header to a constant value
            Response.Headers.Add("location", "foo");

            // BAD: redirect via location
            Response.Headers.SetCommaSeparatedValues("location", value); // $ Alert=r12 Alert=r10 Alert=r11 Alert=r13 Alert=r14 Alert=r15 Alert=r9

            // BAD = redirect via setting location value from tainted source
            Response.Headers.Append("location", value); // $ Alert=r13 Alert=r10 Alert=r11 Alert=r12 Alert=r14 Alert=r15 Alert=r9

            // BAD: redirect via setting location header from comma-separated values
            Response.Headers.AppendCommaSeparatedValues("location", value); // $ Alert=r14 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r15 Alert=r9

            // BAD: tainted redirect to Action
            RedirectToActionPermanent("Error" + value); // $ Alert=r15 Alert=r10 Alert=r11 Alert=r12 Alert=r13 Alert=r14 Alert=r9
        }

        // PUT: api/Some/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value) // $ Source=r16 Source=r17 Source=r18
        {

            RedirectToPage(value); // $ Alert=r16 Alert=r17 Alert=r18

            var headers = new ResponseHeaders(Response.Headers);

            // BAD: redirect via header helper class
            headers.Location = new Uri(value); // $ Alert=r17 Alert=r16 Alert=r18

            // BAD: response redirect
            Response.Redirect(value); // $ Alert=r18 Alert=r16 Alert=r17

            // GOOD: whitelisted redirect
            if(Url.IsLocalUrl(value))
                Redirect(value);
        }
    }
}

// original-extractor-options: /r:netstandard.dll /r:${testdir}/../../../../../packages\Microsoft.AspNetCore.Mvc.2.1.0\lib\netstandard2.0\Microsoft.AspNetCore.Mvc.dll /r:${testdir}/../../../../../packages\Microsoft.AspNetCore.Mvc.Core.2.1.0\lib\netstandard2.0\Microsoft.AspNetCore.Mvc.Core.dll /r:${testdir}/../../../../../packages\Microsoft.AspNetCore.Http.Extensions.2.1.0\lib\netstandard2.0\Microsoft.AspNetCore.Http.Extensions.dll /r:${testdir}/../../../../../packages\Microsoft.AspNetCore.Http.Abstractions.2.1.0\lib\netstandard2.0\Microsoft.AspNetCore.Http.Abstractions.dll /r:${testdir}/../../../../../packages\Microsoft.AspNetCore.Mvc.Abstractions.2.1.0\lib\netstandard2.0\Microsoft.AspNetCore.Mvc.Abstractions.dll /r:${testdir}/../../../../../packages\Microsoft.AspNetCore.Http.Features.2.1.0\lib\netstandard2.0\Microsoft.AspNetCore.Http.Features.dll /r:${testdir}/../../../../../packages\Microsoft.Extensions.Primitives.2.1.0\lib\netstandard2.0\Microsoft.Extensions.Primitives.dll /r:System.Private.Uri.dll
