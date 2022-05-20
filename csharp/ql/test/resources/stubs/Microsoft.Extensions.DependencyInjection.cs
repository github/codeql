using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace Microsoft.Extensions.DependencyInjection
{
    public interface IServiceCollection
    {
    }

    public static class OptionsServiceCollectionExtensions
    {
        public static IServiceCollection Configure<TOptions>(this IServiceCollection services, Action<TOptions> configureOptions) where TOptions : class
        {
            throw null;
        }
    }

    public static class AuthenticationServiceCollectionExtensions
    {
        public static AuthenticationBuilder AddAuthentication(this IServiceCollection services)
        {
            throw null;
        }
    }

    public static class CookieExtensions
    {
        public static AuthenticationBuilder AddCookie(this AuthenticationBuilder builder, Action<CookieAuthenticationOptions> configureOptions)
        {
            throw null;
        }
    }

    public static class SessionServiceCollectionExtensions
    {
        public static IServiceCollection AddSession(this IServiceCollection services)
        {
            throw null;
        }

        public static IServiceCollection AddSession(this IServiceCollection services, Action<SessionOptions> configure)
        {
            throw null;
        }
    }
}