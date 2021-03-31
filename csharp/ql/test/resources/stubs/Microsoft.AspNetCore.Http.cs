using System.Threading.Tasks;

namespace Microsoft.AspNetCore.Http
{
    public interface IResponseCookies
    {
        void Append(string key, string value);

        void Append(string key, string value, CookieOptions options);

        void Delete(string key);

        void Delete(string key, CookieOptions options);
    }

    public abstract class HttpResponse
    {
        public abstract IResponseCookies Cookies
        {
            get;
        }
    }
    
    public class CookieOptions
    {
        public bool HttpOnly
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public bool Secure
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }
    }

    public delegate Task RequestDelegate(HttpContext context);

    public abstract class HttpContext
    {
    }

    public enum CookieSecurePolicy
    {
        SameAsRequest,
        Always,
        None
    }

    public class CookieBuilder
    {
        public virtual bool HttpOnly
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public virtual CookieSecurePolicy SecurePolicy
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

    }
}