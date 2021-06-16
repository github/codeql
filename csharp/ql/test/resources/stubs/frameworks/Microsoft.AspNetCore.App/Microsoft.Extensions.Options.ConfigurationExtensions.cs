// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.OptionsBuilderConfigurationExtensions` in `Microsoft.Extensions.Options.ConfigurationExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class OptionsBuilderConfigurationExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> Bind<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> Bind<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder, Microsoft.Extensions.Configuration.IConfiguration config) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> BindConfiguration<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder, string configSectionPath, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder = default(System.Action<Microsoft.Extensions.Configuration.BinderOptions>)) where TOptions : class => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.OptionsConfigurationServiceCollectionExtensions` in `Microsoft.Extensions.Options.ConfigurationExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class OptionsConfigurationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, Microsoft.Extensions.Configuration.IConfiguration config) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config) where TOptions : class => throw null;
            }

        }
        namespace Options
        {
            // Generated from `Microsoft.Extensions.Options.ConfigurationChangeTokenSource<>` in `Microsoft.Extensions.Options.ConfigurationExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigurationChangeTokenSource<TOptions> : Microsoft.Extensions.Options.IOptionsChangeTokenSource<TOptions>
            {
                public ConfigurationChangeTokenSource(string name, Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                public ConfigurationChangeTokenSource(Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureFromConfigurationOptions<>` in `Microsoft.Extensions.Options.ConfigurationExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureFromConfigurationOptions<TOptions> : Microsoft.Extensions.Options.ConfigureOptions<TOptions> where TOptions : class
            {
                public ConfigureFromConfigurationOptions(Microsoft.Extensions.Configuration.IConfiguration config) : base(default(System.Action<TOptions>)) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.NamedConfigureFromConfigurationOptions<>` in `Microsoft.Extensions.Options.ConfigurationExtensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NamedConfigureFromConfigurationOptions<TOptions> : Microsoft.Extensions.Options.ConfigureNamedOptions<TOptions> where TOptions : class
            {
                public NamedConfigureFromConfigurationOptions(string name, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) : base(default(string), default(System.Action<TOptions>)) => throw null;
                public NamedConfigureFromConfigurationOptions(string name, Microsoft.Extensions.Configuration.IConfiguration config) : base(default(string), default(System.Action<TOptions>)) => throw null;
            }

        }
    }
}
