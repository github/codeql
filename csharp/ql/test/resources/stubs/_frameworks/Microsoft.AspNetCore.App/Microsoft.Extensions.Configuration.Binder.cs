// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            // Generated from `Microsoft.Extensions.Configuration.BinderOptions` in `Microsoft.Extensions.Configuration.Binder, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BinderOptions
            {
                public bool BindNonPublicProperties { get => throw null; set => throw null; }
                public BinderOptions() => throw null;
            }

            // Generated from `Microsoft.Extensions.Configuration.ConfigurationBinder` in `Microsoft.Extensions.Configuration.Binder, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConfigurationBinder
            {
                public static void Bind(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key, object instance) => throw null;
                public static void Bind(this Microsoft.Extensions.Configuration.IConfiguration configuration, object instance, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureOptions) => throw null;
                public static void Bind(this Microsoft.Extensions.Configuration.IConfiguration configuration, object instance) => throw null;
                public static object Get(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureOptions) => throw null;
                public static object Get(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type) => throw null;
                public static T Get<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureOptions) => throw null;
                public static T Get<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                public static object GetValue(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type, string key, object defaultValue) => throw null;
                public static object GetValue(this Microsoft.Extensions.Configuration.IConfiguration configuration, System.Type type, string key) => throw null;
                public static T GetValue<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key, T defaultValue) => throw null;
                public static T GetValue<T>(this Microsoft.Extensions.Configuration.IConfiguration configuration, string key) => throw null;
            }

        }
    }
}
