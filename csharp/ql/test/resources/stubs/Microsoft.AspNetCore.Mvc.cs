using Microsoft.AspNetCore.Http;

namespace Microsoft.AspNetCore.Mvc
{
    public abstract class Controller
    {
        public HttpResponse Response
        {
            get
            {
                throw null;
            }
        }
    }
}