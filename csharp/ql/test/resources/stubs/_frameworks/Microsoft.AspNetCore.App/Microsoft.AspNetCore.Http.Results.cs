// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Results, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Http
        {
            public interface IResultExtensions
            {
            }

            public static class Results
            {
                public static Microsoft.AspNetCore.Http.IResult Accepted(string uri = default(string), object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Accepted<TValue>(string uri = default(string), TValue value = default(TValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult AcceptedAtRoute(string routeName = default(string), object routeValues = default(object), object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult AcceptedAtRoute<TValue>(string routeName = default(string), object routeValues = default(object), TValue value = default(TValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult BadRequest(object error = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult BadRequest<TValue>(TValue error) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Bytes(System.Byte[] contents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Bytes(System.ReadOnlyMemory<System.Byte> contents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Conflict(object error = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Conflict<TValue>(TValue error) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Content(string content, string contentType = default(string), System.Text.Encoding contentEncoding = default(System.Text.Encoding), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Created(System.Uri uri, object value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Created(string uri, object value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Created<TValue>(System.Uri uri, TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Created<TValue>(string uri, TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult CreatedAtRoute(string routeName = default(string), object routeValues = default(object), object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult CreatedAtRoute<TValue>(string routeName = default(string), object routeValues = default(object), TValue value = default(TValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Empty { get => throw null; }
                public static Microsoft.AspNetCore.Http.IResultExtensions Extensions { get => throw null; }
                public static Microsoft.AspNetCore.Http.IResult File(System.Byte[] fileContents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult File(System.IO.Stream fileStream, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult File(string path, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Json(object data, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), string contentType = default(string), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Json<TValue>(TValue data, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), string contentType = default(string), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult LocalRedirect(string localUrl, bool permanent = default(bool), bool preserveMethod = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult NoContent() => throw null;
                public static Microsoft.AspNetCore.Http.IResult NotFound(object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult NotFound<TValue>(TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Ok(object value = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Ok<TValue>(TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Problem(Microsoft.AspNetCore.Mvc.ProblemDetails problemDetails) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Problem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, object> extensions = default(System.Collections.Generic.IDictionary<string, object>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Redirect(string url, bool permanent = default(bool), bool preserveMethod = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult RedirectToRoute(string routeName = default(string), object routeValues = default(object), bool permanent = default(bool), bool preserveMethod = default(bool), string fragment = default(string)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), string authenticationScheme = default(string)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult StatusCode(int statusCode) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Stream(System.Func<System.IO.Stream, System.Threading.Tasks.Task> streamWriterCallback, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Stream(System.IO.Pipelines.PipeReader pipeReader, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Stream(System.IO.Stream stream, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Text(System.ReadOnlySpan<System.Byte> utf8Content, string contentType = default(string), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Text(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Text(string content, string contentType = default(string), System.Text.Encoding contentEncoding = default(System.Text.Encoding), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult Unauthorized() => throw null;
                public static Microsoft.AspNetCore.Http.IResult UnprocessableEntity(object error = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.IResult UnprocessableEntity<TValue>(TValue error) => throw null;
                public static Microsoft.AspNetCore.Http.IResult ValidationProblem(System.Collections.Generic.IDictionary<string, string[]> errors, string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, object> extensions = default(System.Collections.Generic.IDictionary<string, object>)) => throw null;
            }

            public static class TypedResults
            {
                public static Microsoft.AspNetCore.Http.HttpResults.Accepted Accepted(System.Uri uri) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Accepted Accepted(string uri) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Accepted<TValue> Accepted<TValue>(System.Uri uri, TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Accepted<TValue> Accepted<TValue>(string uri, TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.AcceptedAtRoute AcceptedAtRoute(string routeName = default(string), object routeValues = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.AcceptedAtRoute<TValue> AcceptedAtRoute<TValue>(TValue value, string routeName = default(string), object routeValues = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.BadRequest BadRequest() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.BadRequest<TValue> BadRequest<TValue>(TValue error) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.FileContentHttpResult Bytes(System.Byte[] contents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.FileContentHttpResult Bytes(System.ReadOnlyMemory<System.Byte> contents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ChallengeHttpResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Conflict Conflict() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Conflict<TValue> Conflict<TValue>(TValue error) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ContentHttpResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ContentHttpResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ContentHttpResult Content(string content, string contentType = default(string), System.Text.Encoding contentEncoding = default(System.Text.Encoding), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Created Created(System.Uri uri) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Created Created(string uri) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Created<TValue> Created<TValue>(System.Uri uri, TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Created<TValue> Created<TValue>(string uri, TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.CreatedAtRoute CreatedAtRoute(string routeName = default(string), object routeValues = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.CreatedAtRoute<TValue> CreatedAtRoute<TValue>(TValue value, string routeName = default(string), object routeValues = default(object)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.EmptyHttpResult Empty { get => throw null; }
                public static Microsoft.AspNetCore.Http.HttpResults.FileContentHttpResult File(System.Byte[] fileContents, string contentType = default(string), string fileDownloadName = default(string), bool enableRangeProcessing = default(bool), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.FileStreamHttpResult File(System.IO.Stream fileStream, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.JsonHttpResult<TValue> Json<TValue>(TValue data, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions), string contentType = default(string), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.RedirectHttpResult LocalRedirect(string localUrl, bool permanent = default(bool), bool preserveMethod = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.NoContent NoContent() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.NotFound NotFound() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.NotFound<TValue> NotFound<TValue>(TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Ok Ok() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Ok<TValue> Ok<TValue>(TValue value) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.PhysicalFileHttpResult PhysicalFile(string path, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult Problem(Microsoft.AspNetCore.Mvc.ProblemDetails problemDetails) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ProblemHttpResult Problem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, object> extensions = default(System.Collections.Generic.IDictionary<string, object>)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.RedirectHttpResult Redirect(string url, bool permanent = default(bool), bool preserveMethod = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.RedirectToRouteHttpResult RedirectToRoute(string routeName = default(string), object routeValues = default(object), bool permanent = default(bool), bool preserveMethod = default(bool), string fragment = default(string)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.SignInHttpResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), string authenticationScheme = default(string)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.SignOutHttpResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties = default(Microsoft.AspNetCore.Authentication.AuthenticationProperties), System.Collections.Generic.IList<string> authenticationSchemes = default(System.Collections.Generic.IList<string>)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.StatusCodeHttpResult StatusCode(int statusCode) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.PushStreamHttpResult Stream(System.Func<System.IO.Stream, System.Threading.Tasks.Task> streamWriterCallback, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.FileStreamHttpResult Stream(System.IO.Pipelines.PipeReader pipeReader, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.FileStreamHttpResult Stream(System.IO.Stream stream, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.Utf8ContentHttpResult Text(System.ReadOnlySpan<System.Byte> utf8Content, string contentType = default(string), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ContentHttpResult Text(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ContentHttpResult Text(string content, string contentType = default(string), System.Text.Encoding contentEncoding = default(System.Text.Encoding), int? statusCode = default(int?)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult Unauthorized() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.UnprocessableEntity UnprocessableEntity() => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.UnprocessableEntity<TValue> UnprocessableEntity<TValue>(TValue error) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.ValidationProblem ValidationProblem(System.Collections.Generic.IDictionary<string, string[]> errors, string detail = default(string), string instance = default(string), string title = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, object> extensions = default(System.Collections.Generic.IDictionary<string, object>)) => throw null;
                public static Microsoft.AspNetCore.Http.HttpResults.VirtualFileHttpResult VirtualFile(string path, string contentType = default(string), string fileDownloadName = default(string), System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue), bool enableRangeProcessing = default(bool)) => throw null;
            }

            namespace HttpResults
            {
                public class Accepted : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string Location { get => throw null; }
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class Accepted<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string Location { get => throw null; }
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class AcceptedAtRoute : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public string RouteName { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class AcceptedAtRoute<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public string RouteName { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class BadRequest : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class BadRequest<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class ChallengeHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Collections.Generic.IReadOnlyList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                }

                public class Conflict : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class Conflict<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class ContentHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string ResponseContent { get => throw null; set => throw null; }
                    public int? StatusCode { get => throw null; set => throw null; }
                }

                public class Created : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string Location { get => throw null; }
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class Created<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string Location { get => throw null; }
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class CreatedAtRoute : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public string RouteName { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class CreatedAtRoute<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public string RouteName { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class EmptyHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static Microsoft.AspNetCore.Http.HttpResults.EmptyHttpResult Instance { get => throw null; }
                }

                public class FileContentHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IFileHttpResult, Microsoft.AspNetCore.Http.IResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public bool EnableRangeProcessing { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public System.ReadOnlyMemory<System.Byte> FileContents { get => throw null; set => throw null; }
                    public string FileDownloadName { get => throw null; set => throw null; }
                    public System.Int64? FileLength { get => throw null; set => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                }

                public class FileStreamHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IFileHttpResult, Microsoft.AspNetCore.Http.IResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public bool EnableRangeProcessing { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string FileDownloadName { get => throw null; set => throw null; }
                    public System.Int64? FileLength { get => throw null; set => throw null; }
                    public System.IO.Stream FileStream { get => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                }

                public class ForbidHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Collections.Generic.IReadOnlyList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                }

                public class JsonHttpResult<TValue> : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public System.Text.Json.JsonSerializerOptions JsonSerializerOptions { get => throw null; set => throw null; }
                    public int? StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class NoContent : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class NotFound : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class NotFound<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; set => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class Ok : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class Ok<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class PhysicalFileHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IFileHttpResult, Microsoft.AspNetCore.Http.IResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public bool EnableRangeProcessing { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string FileDownloadName { get => throw null; set => throw null; }
                    public System.Int64? FileLength { get => throw null; set => throw null; }
                    public string FileName { get => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                }

                public class ProblemHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<Microsoft.AspNetCore.Mvc.ProblemDetails>
                {
                    public string ContentType { get => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public Microsoft.AspNetCore.Mvc.ProblemDetails ProblemDetails { get => throw null; }
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                    Microsoft.AspNetCore.Mvc.ProblemDetails Microsoft.AspNetCore.Http.IValueHttpResult<Microsoft.AspNetCore.Mvc.ProblemDetails>.Value { get => throw null; }
                }

                public class PushStreamHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IFileHttpResult, Microsoft.AspNetCore.Http.IResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public bool EnableRangeProcessing { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string FileDownloadName { get => throw null; set => throw null; }
                    public System.Int64? FileLength { get => throw null; set => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                }

                public class RedirectHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public bool AcceptLocalUrlOnly { get => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public bool Permanent { get => throw null; }
                    public bool PreserveMethod { get => throw null; }
                    public string Url { get => throw null; }
                }

                public class RedirectToRouteHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string Fragment { get => throw null; }
                    public bool Permanent { get => throw null; }
                    public bool PreserveMethod { get => throw null; }
                    public string RouteName { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
                }

                public class Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6> : Microsoft.AspNetCore.Http.INestedHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider where TResult1 : Microsoft.AspNetCore.Http.IResult where TResult2 : Microsoft.AspNetCore.Http.IResult where TResult3 : Microsoft.AspNetCore.Http.IResult where TResult4 : Microsoft.AspNetCore.Http.IResult where TResult5 : Microsoft.AspNetCore.Http.IResult where TResult6 : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Http.IResult Result { get => throw null; }
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6>(TResult1 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6>(TResult2 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6>(TResult3 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6>(TResult4 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6>(TResult5 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5, TResult6>(TResult6 result) => throw null;
                }

                public class Results<TResult1, TResult2, TResult3, TResult4, TResult5> : Microsoft.AspNetCore.Http.INestedHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider where TResult1 : Microsoft.AspNetCore.Http.IResult where TResult2 : Microsoft.AspNetCore.Http.IResult where TResult3 : Microsoft.AspNetCore.Http.IResult where TResult4 : Microsoft.AspNetCore.Http.IResult where TResult5 : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Http.IResult Result { get => throw null; }
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5>(TResult1 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5>(TResult2 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5>(TResult3 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5>(TResult4 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4, TResult5>(TResult5 result) => throw null;
                }

                public class Results<TResult1, TResult2, TResult3, TResult4> : Microsoft.AspNetCore.Http.INestedHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider where TResult1 : Microsoft.AspNetCore.Http.IResult where TResult2 : Microsoft.AspNetCore.Http.IResult where TResult3 : Microsoft.AspNetCore.Http.IResult where TResult4 : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Http.IResult Result { get => throw null; }
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4>(TResult1 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4>(TResult2 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4>(TResult3 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3, TResult4>(TResult4 result) => throw null;
                }

                public class Results<TResult1, TResult2, TResult3> : Microsoft.AspNetCore.Http.INestedHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider where TResult1 : Microsoft.AspNetCore.Http.IResult where TResult2 : Microsoft.AspNetCore.Http.IResult where TResult3 : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Http.IResult Result { get => throw null; }
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3>(TResult1 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3>(TResult2 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2, TResult3>(TResult3 result) => throw null;
                }

                public class Results<TResult1, TResult2> : Microsoft.AspNetCore.Http.INestedHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider where TResult1 : Microsoft.AspNetCore.Http.IResult where TResult2 : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Http.IResult Result { get => throw null; }
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2>(TResult1 result) => throw null;
                    public static implicit operator Microsoft.AspNetCore.Http.HttpResults.Results<TResult1, TResult2>(TResult2 result) => throw null;
                }

                public class SignInHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public string AuthenticationScheme { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                }

                public class SignOutHttpResult : Microsoft.AspNetCore.Http.IResult
                {
                    public System.Collections.Generic.IReadOnlyList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                }

                public class StatusCodeHttpResult : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class UnauthorizedHttpResult : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class UnprocessableEntity : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                }

                public class UnprocessableEntity<TValue> : Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<TValue>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    public TValue Value { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                }

                public class Utf8ContentHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public System.ReadOnlyMemory<System.Byte> ResponseContent { get => throw null; set => throw null; }
                    public int? StatusCode { get => throw null; set => throw null; }
                }

                public class ValidationProblem : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IResult, Microsoft.AspNetCore.Http.IStatusCodeHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult, Microsoft.AspNetCore.Http.IValueHttpResult<Microsoft.AspNetCore.Http.HttpValidationProblemDetails>, Microsoft.AspNetCore.Http.Metadata.IEndpointMetadataProvider
                {
                    public string ContentType { get => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public static void PopulateMetadata(System.Reflection.MethodInfo method, Microsoft.AspNetCore.Builder.EndpointBuilder builder) => throw null;
                    public Microsoft.AspNetCore.Http.HttpValidationProblemDetails ProblemDetails { get => throw null; }
                    public int StatusCode { get => throw null; }
                    int? Microsoft.AspNetCore.Http.IStatusCodeHttpResult.StatusCode { get => throw null; }
                    object Microsoft.AspNetCore.Http.IValueHttpResult.Value { get => throw null; }
                    Microsoft.AspNetCore.Http.HttpValidationProblemDetails Microsoft.AspNetCore.Http.IValueHttpResult<Microsoft.AspNetCore.Http.HttpValidationProblemDetails>.Value { get => throw null; }
                }

                public class VirtualFileHttpResult : Microsoft.AspNetCore.Http.IContentTypeHttpResult, Microsoft.AspNetCore.Http.IFileHttpResult, Microsoft.AspNetCore.Http.IResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public bool EnableRangeProcessing { get => throw null; set => throw null; }
                    public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public string FileDownloadName { get => throw null; set => throw null; }
                    public System.Int64? FileLength { get => throw null; set => throw null; }
                    public string FileName { get => throw null; set => throw null; }
                    public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
                }

            }
        }
    }
}
