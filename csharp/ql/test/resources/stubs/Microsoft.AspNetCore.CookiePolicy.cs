using Microsoft.AspNetCore.Http;

namespace Microsoft.AspNetCore.CookiePolicy
{
    public enum HttpOnlyPolicy
    {
        None,
        Always
    }

    public class AppendCookieContext
    {
        public HttpContext Context
        {
            get
            {
                throw null;
            }
        }

        public string CookieName
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public CookieOptions CookieOptions
        {
            get
            {
                throw null;
            }
        }

        public string CookieValue
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public bool HasConsent
        {
            get
            {
                throw null;
            }
        }

        public bool IsConsentNeeded
        {
            get
            {
                throw null;
            }
        }

        public bool IssueCookie
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public AppendCookieContext(HttpContext context, CookieOptions options, string name, string value)
        {
        }
    }

    public class DeleteCookieContext
    {
        public HttpContext Context
        {
            get
            {
                throw null;
            }
        }

        public string CookieName
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public CookieOptions CookieOptions
        {
            get
            {
                throw null;
            }
        }

        public bool HasConsent
        {
            get
            {
                throw null;
            }
        }

        public bool IsConsentNeeded
        {
            get
            {
                throw null;
            }
        }

        public bool IssueCookie
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public DeleteCookieContext(HttpContext context, CookieOptions options, string name)
        {
        }
    }
}