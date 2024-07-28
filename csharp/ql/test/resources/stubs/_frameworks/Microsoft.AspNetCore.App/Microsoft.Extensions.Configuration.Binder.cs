// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.Binder, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            public class BinderOptions
            {
                public bool BindNonPublicProperties { get => throw null; set { } }
                public BinderOptions() => throw null;
                public bool ErrorOnUnknownConfiguration { get => throw null; set { } }
            }
            public static class ConfigurationBinder
            {
                public static void Bind(this Microsoft.Extensions.Configuration.IConfiguration configuration, object instance) => throw null;
                public static void Bind(this Microsoft.Extensions.Configuration.IConfiguration configuration, object instance, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureOptions) => throw null;
                public static void Bind(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key, object instance) => throw null;
                public static object Get(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type) => throw null;
                public static object Get(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureOptions) => throw null;
                public static T Get<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                public static T Get<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureOptions) => throw null;
                public static object GetValue(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type, string key) => throw null;
                public static object GetValue(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type, string key, object defaultValue) => throw null;
                public static T GetValue<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key) => throw null;
                public static T GetValue<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key, T defaultValue) => throw null;
            }
        }
    }
}
