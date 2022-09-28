// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            // Generated from `Microsoft.AspNetCore.Http.IResultExtensions` in `Microsoft.AspNetCore.Http.Results, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IResultExtensions
            {
            }

            // Generated from `Microsoft.AspNetCore.Http.Results` in `Microsoft.AspNetCore.Http.Results, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class Results
            {
                public static Microsoft.AspNetCore.Http.IResult Accepted(string uri = default(string), object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult AcceptedAtRoute(string routeName = default(string), object routeValues = default(object), object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult BadRequest(object error = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Bytes(System.Byte[] contents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Conflict(object error = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Content(string content, string contentType = default(string), System.Text.Encoding contentEncoding = default(System.Text.Encoding)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Created(System.Uri uri, object value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Created(string uri, object value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult CreatedAtRoute(string routeName = default(string), object routeValues = default(object), object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResultExtensions Extensions { get => throw null; }
                public static Microsoft.AspNetCore.Http.IResult File(System.Byte[] fileContents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult File(System.IO.Stream fileStream, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult File(string path, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Json(object data, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), string contentType = default(string), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult LocalRedirect(string localUrl, bool permanent = default(bool), bool preserveMethod = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult NoContent() => throw null;
                public static Microsoft.AspNetCore.Http.IResult NotFound(object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Ok(object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Problem(Microsoft.AspNetCore.Mvc.ProblemDetails problemDetails) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Problem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, object> extensions = default(System.Collections.Generic.IDictionary<string, object>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Redirect(string url, bool permanent = default(bool), bool preserveMethod = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult RedirectToRoute(string routeName = default(string), object routeValues = default(object), bool permanent = default(bool), bool preserveMethod = default(bool), string fragment = default(string)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), string authenticationScheme = default(string)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult StatusCode(int statusCode) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Stream(System.IO.Stream stream, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Text(string content, string contentType = default(string), System.Text.Encoding contentEncoding = default(System.Text.Encoding)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Unauthorized() => throw null;
                public static Microsoft.AspNetCore.Http.IResult UnprocessableEntity(object error = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult ValidationProblem(System.Collections.Generic.IDictionary<string, string[]> errors, string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, object> extensions = default(System.Collections.Generic.IDictionary<string, object>)) => throw null;
            }

        }
    }
}
