namespace System.Web.Http
{
    public class ApiController
    {
        public Microsoft.AspNetCore.Http.HttpContext Context => null;
        public virtual Microsoft.AspNetCore.Mvc.RedirectResult Redirect(Uri location) => null;
        public virtual Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string location) => null;
        public virtual ResponseMessageResult ResponseMessage(System.Net.Http.HttpResponseMessage response) => null;
        public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues) => null;
        public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; set; }
    }

    public class ResponseMessageResult { }
}
