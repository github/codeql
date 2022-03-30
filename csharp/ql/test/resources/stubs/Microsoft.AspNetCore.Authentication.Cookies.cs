using Microsoft.AspNetCore.Http;
using System;
using System.Runtime.CompilerServices;
using Microsoft.AspNetCore.Authentication;

namespace Microsoft.AspNetCore.Authentication.Cookies
{
    public class CookieAuthenticationOptions : AuthenticationSchemeOptions
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

        public bool CookieHttpOnly
        {
            get
            {
                return Cookie.HttpOnly;
            }
            set
            {
                Cookie.HttpOnly = value;
            }
        }

        public CookieSecurePolicy CookieSecure
        {
            get
            {
                return Cookie.SecurePolicy;
            }
            set
            {
                Cookie.SecurePolicy = value;
            }
        }

        public CookieAuthenticationOptions()
        {
        }
    }
}