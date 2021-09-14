using System;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.CookiePolicy;

namespace Microsoft.AspNetCore.Builder
{
    public interface IApplicationBuilder
    {
        IApplicationBuilder Use(Func<RequestDelegate, RequestDelegate> middleware);
    }

    public class CookiePolicyOptions
    {
        public HttpOnlyPolicy HttpOnly
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public Action<AppendCookieContext> OnAppendCookie
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public Action<DeleteCookieContext> OnDeleteCookie
        {
            get
            {
                throw null;
            }
            set
            {
            }
        }

        public CookieSecurePolicy Secure
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

    public static class CookiePolicyAppBuilderExtensions
    {
        public static IApplicationBuilder UseCookiePolicy(this IApplicationBuilder app)
        {
            throw null;
        }

        public static IApplicationBuilder UseCookiePolicy(this IApplicationBuilder app, CookiePolicyOptions options)
        {
            throw null;
        }
    }

    public class SessionOptions
    {
        public CookieBuilder Cookie
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