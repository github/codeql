// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Options.ConfigurationExtensions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class OptionsBuilderConfigurationExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> Bind<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder, Microsoft.Extensions.Configuration.IConfiguration config) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> Bind<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> BindConfiguration<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder, string configSectionPath, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder = default(System.Action<Microsoft.Extensions.Configuration.BinderOptions>)) where TOptions : class => throw null;
            }
            public static partial class OptionsConfigurationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, Microsoft.Extensions.Configuration.IConfiguration config) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) where TOptions : class => throw null;
            }
        }
        namespace Options
        {
            public class ConfigurationChangeTokenSource<TOptions> : Microsoft.Extensions.Options.IOptionsChangeTokenSource<TOptions>
            {
                public ConfigurationChangeTokenSource(Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                public ConfigurationChangeTokenSource(string name, Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken GetChangeToken() => throw null;
                public string Name { get => throw null; }
            }
            public class ConfigureFromConfigurationOptions<TOptions> : Microsoft.Extensions.Options.ConfigureOptions<TOptions> where TOptions : class
            {
                public ConfigureFromConfigurationOptions(Microsoft.Extensions.Configuration.IConfiguration config) : base(default(System.Action<TOptions>)) => throw null;
            }
            public class NamedConfigureFromConfigurationOptions<TOptions> : Microsoft.Extensions.Options.ConfigureNamedOptions<TOptions> where TOptions : class
            {
                public NamedConfigureFromConfigurationOptions(string name, Microsoft.Extensions.Configuration.IConfiguration config) : base(default(string), default(System.Action<TOptions>)) => throw null;
                public NamedConfigureFromConfigurationOptions(string name, Microsoft.Extensions.Configuration.IConfiguration config, System.Action<Microsoft.Extensions.Configuration.BinderOptions> configureBinder) : base(default(string), default(System.Action<TOptions>)) => throw null;
            }
        }
    }
}
