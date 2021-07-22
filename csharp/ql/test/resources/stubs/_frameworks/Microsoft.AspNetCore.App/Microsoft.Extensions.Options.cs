// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.OptionsServiceCollectionExtensions` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class OptionsServiceCollectionExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> AddOptions<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> AddOptions<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureAll<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureOptions<TConfigureOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TConfigureOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object configureInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type configureType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection PostConfigure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection PostConfigure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection PostConfigureAll<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
            }

        }
        namespace Options
        {
            // Generated from `Microsoft.Extensions.Options.ConfigureNamedOptions<,,,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> : Microsoft.Extensions.Options.IConfigureOptions<TOptions>, Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions> where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> Action { get => throw null; }
                public void Configure(TOptions options) => throw null;
                public virtual void Configure(string name, TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, TDep5 dependency5, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public TDep5 Dependency5 { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureNamedOptions<,,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2, TDep3, TDep4> : Microsoft.Extensions.Options.IConfigureOptions<TOptions>, Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions> where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> Action { get => throw null; }
                public void Configure(TOptions options) => throw null;
                public virtual void Configure(string name, TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureNamedOptions<,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2, TDep3> : Microsoft.Extensions.Options.IConfigureOptions<TOptions>, Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions> where TDep1 : class where TDep2 : class where TDep3 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3> Action { get => throw null; }
                public void Configure(TOptions options) => throw null;
                public virtual void Configure(string name, TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency, TDep2 dependency2, TDep3 dependency3, System.Action<TOptions, TDep1, TDep2, TDep3> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureNamedOptions<,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2> : Microsoft.Extensions.Options.IConfigureOptions<TOptions>, Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions> where TDep1 : class where TDep2 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2> Action { get => throw null; }
                public void Configure(TOptions options) => throw null;
                public virtual void Configure(string name, TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency, TDep2 dependency2, System.Action<TOptions, TDep1, TDep2> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureNamedOptions<,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureNamedOptions<TOptions, TDep> : Microsoft.Extensions.Options.IConfigureOptions<TOptions>, Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions> where TDep : class where TOptions : class
            {
                public System.Action<TOptions, TDep> Action { get => throw null; }
                public void Configure(TOptions options) => throw null;
                public virtual void Configure(string name, TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep dependency, System.Action<TOptions, TDep> action) => throw null;
                public TDep Dependency { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureNamedOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureNamedOptions<TOptions> : Microsoft.Extensions.Options.IConfigureOptions<TOptions>, Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions> where TOptions : class
            {
                public System.Action<TOptions> Action { get => throw null; }
                public void Configure(TOptions options) => throw null;
                public virtual void Configure(string name, TOptions options) => throw null;
                public ConfigureNamedOptions(string name, System.Action<TOptions> action) => throw null;
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ConfigureOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConfigureOptions<TOptions> : Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class
            {
                public System.Action<TOptions> Action { get => throw null; }
                public virtual void Configure(TOptions options) => throw null;
                public ConfigureOptions(System.Action<TOptions> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.IConfigureNamedOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigureNamedOptions<TOptions> : Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class
            {
                void Configure(string name, TOptions options);
            }

            // Generated from `Microsoft.Extensions.Options.IConfigureOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IConfigureOptions<TOptions> where TOptions : class
            {
                void Configure(TOptions options);
            }

            // Generated from `Microsoft.Extensions.Options.IOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOptions<TOptions> where TOptions : class
            {
                TOptions Value { get; }
            }

            // Generated from `Microsoft.Extensions.Options.IOptionsChangeTokenSource<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOptionsChangeTokenSource<TOptions>
            {
                Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                string Name { get; }
            }

            // Generated from `Microsoft.Extensions.Options.IOptionsFactory<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOptionsFactory<TOptions> where TOptions : class
            {
                TOptions Create(string name);
            }

            // Generated from `Microsoft.Extensions.Options.IOptionsMonitor<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOptionsMonitor<TOptions>
            {
                TOptions CurrentValue { get; }
                TOptions Get(string name);
                System.IDisposable OnChange(System.Action<TOptions, string> listener);
            }

            // Generated from `Microsoft.Extensions.Options.IOptionsMonitorCache<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOptionsMonitorCache<TOptions> where TOptions : class
            {
                void Clear();
                TOptions GetOrAdd(string name, System.Func<TOptions> createOptions);
                bool TryAdd(string name, TOptions options);
                bool TryRemove(string name);
            }

            // Generated from `Microsoft.Extensions.Options.IOptionsSnapshot<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IOptionsSnapshot<TOptions> : Microsoft.Extensions.Options.IOptions<TOptions> where TOptions : class
            {
                TOptions Get(string name);
            }

            // Generated from `Microsoft.Extensions.Options.IPostConfigureOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IPostConfigureOptions<TOptions> where TOptions : class
            {
                void PostConfigure(string name, TOptions options);
            }

            // Generated from `Microsoft.Extensions.Options.IValidateOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IValidateOptions<TOptions> where TOptions : class
            {
                Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options);
            }

            // Generated from `Microsoft.Extensions.Options.Options` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class Options
            {
                public static Microsoft.Extensions.Options.IOptions<TOptions> Create<TOptions>(TOptions options) where TOptions : class => throw null;
                public static string DefaultName;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsBuilder<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsBuilder<TOptions> where TOptions : class
            {
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep>(System.Action<TOptions, TDep> configureOptions) where TDep : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2>(System.Action<TOptions, TDep1, TDep2> configureOptions) where TDep1 : class where TDep2 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2, TDep3>(System.Action<TOptions, TDep1, TDep2, TDep3> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2, TDep3, TDep4>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure(System.Action<TOptions> configureOptions) => throw null;
                public string Name { get => throw null; }
                public OptionsBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep>(System.Action<TOptions, TDep> configureOptions) where TDep : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2>(System.Action<TOptions, TDep1, TDep2> configureOptions) where TDep1 : class where TDep2 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2, TDep3>(System.Action<TOptions, TDep1, TDep2, TDep3> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2, TDep3, TDep4>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure(System.Action<TOptions> configureOptions) => throw null;
                public Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get => throw null; }
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep>(System.Func<TOptions, TDep, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep>(System.Func<TOptions, TDep, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2>(System.Func<TOptions, TDep1, TDep2, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2>(System.Func<TOptions, TDep1, TDep2, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3>(System.Func<TOptions, TDep1, TDep2, TDep3, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3>(System.Func<TOptions, TDep1, TDep2, TDep3, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate(System.Func<TOptions, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate(System.Func<TOptions, bool> validation) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsCache<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsCache<TOptions> : Microsoft.Extensions.Options.IOptionsMonitorCache<TOptions> where TOptions : class
            {
                public void Clear() => throw null;
                public virtual TOptions GetOrAdd(string name, System.Func<TOptions> createOptions) => throw null;
                public OptionsCache() => throw null;
                public virtual bool TryAdd(string name, TOptions options) => throw null;
                public virtual bool TryRemove(string name) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsFactory<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsFactory<TOptions> : Microsoft.Extensions.Options.IOptionsFactory<TOptions> where TOptions : class
            {
                public TOptions Create(string name) => throw null;
                protected virtual TOptions CreateInstance(string name) => throw null;
                public OptionsFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IConfigureOptions<TOptions>> setups, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IPostConfigureOptions<TOptions>> postConfigures, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IValidateOptions<TOptions>> validations) => throw null;
                public OptionsFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IConfigureOptions<TOptions>> setups, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IPostConfigureOptions<TOptions>> postConfigures) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsManager<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsManager<TOptions> : Microsoft.Extensions.Options.IOptionsSnapshot<TOptions>, Microsoft.Extensions.Options.IOptions<TOptions> where TOptions : class
            {
                public virtual TOptions Get(string name) => throw null;
                public OptionsManager(Microsoft.Extensions.Options.IOptionsFactory<TOptions> factory) => throw null;
                public TOptions Value { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.OptionsMonitor<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsMonitor<TOptions> : System.IDisposable, Microsoft.Extensions.Options.IOptionsMonitor<TOptions> where TOptions : class
            {
                public TOptions CurrentValue { get => throw null; }
                public void Dispose() => throw null;
                public virtual TOptions Get(string name) => throw null;
                public System.IDisposable OnChange(System.Action<TOptions, string> listener) => throw null;
                public OptionsMonitor(Microsoft.Extensions.Options.IOptionsFactory<TOptions> factory, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IOptionsChangeTokenSource<TOptions>> sources, Microsoft.Extensions.Options.IOptionsMonitorCache<TOptions> cache) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsMonitorExtensions` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class OptionsMonitorExtensions
            {
                public static System.IDisposable OnChange<TOptions>(this Microsoft.Extensions.Options.IOptionsMonitor<TOptions> monitor, System.Action<TOptions> listener) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsValidationException` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsValidationException : System.Exception
            {
                public System.Collections.Generic.IEnumerable<string> Failures { get => throw null; }
                public override string Message { get => throw null; }
                public string OptionsName { get => throw null; }
                public System.Type OptionsType { get => throw null; }
                public OptionsValidationException(string optionsName, System.Type optionsType, System.Collections.Generic.IEnumerable<string> failureMessages) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.OptionsWrapper<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OptionsWrapper<TOptions> : Microsoft.Extensions.Options.IOptions<TOptions> where TOptions : class
            {
                public OptionsWrapper(TOptions options) => throw null;
                public TOptions Value { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.PostConfigureOptions<,,,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PostConfigureOptions<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> Action { get => throw null; }
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public TDep5 Dependency5 { get => throw null; }
                public string Name { get => throw null; }
                public void PostConfigure(TOptions options) => throw null;
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public PostConfigureOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, TDep5 dependency5, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.PostConfigureOptions<,,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PostConfigureOptions<TOptions, TDep1, TDep2, TDep3, TDep4> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> Action { get => throw null; }
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public string Name { get => throw null; }
                public void PostConfigure(TOptions options) => throw null;
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public PostConfigureOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.PostConfigureOptions<,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PostConfigureOptions<TOptions, TDep1, TDep2, TDep3> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TDep1 : class where TDep2 : class where TDep3 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3> Action { get => throw null; }
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public string Name { get => throw null; }
                public void PostConfigure(TOptions options) => throw null;
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public PostConfigureOptions(string name, TDep1 dependency, TDep2 dependency2, TDep3 dependency3, System.Action<TOptions, TDep1, TDep2, TDep3> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.PostConfigureOptions<,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PostConfigureOptions<TOptions, TDep1, TDep2> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TDep1 : class where TDep2 : class where TOptions : class
            {
                public System.Action<TOptions, TDep1, TDep2> Action { get => throw null; }
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public string Name { get => throw null; }
                public void PostConfigure(TOptions options) => throw null;
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public PostConfigureOptions(string name, TDep1 dependency, TDep2 dependency2, System.Action<TOptions, TDep1, TDep2> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.PostConfigureOptions<,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PostConfigureOptions<TOptions, TDep> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TDep : class where TOptions : class
            {
                public System.Action<TOptions, TDep> Action { get => throw null; }
                public TDep Dependency { get => throw null; }
                public string Name { get => throw null; }
                public void PostConfigure(TOptions options) => throw null;
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public PostConfigureOptions(string name, TDep dependency, System.Action<TOptions, TDep> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.PostConfigureOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PostConfigureOptions<TOptions> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class
            {
                public System.Action<TOptions> Action { get => throw null; }
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public PostConfigureOptions(string name, System.Action<TOptions> action) => throw null;
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptions<,,,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptions<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public TDep5 Dependency5 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, TDep5 dependency5, System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> validation, string failureMessage) => throw null;
                public System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> Validation { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptions<,,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptions<TOptions, TDep1, TDep2, TDep3, TDep4> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> validation, string failureMessage) => throw null;
                public System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> Validation { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptions<,,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptions<TOptions, TDep1, TDep2, TDep3> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, System.Func<TOptions, TDep1, TDep2, TDep3, bool> validation, string failureMessage) => throw null;
                public System.Func<TOptions, TDep1, TDep2, TDep3, bool> Validation { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptions<,,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptions<TOptions, TDep1, TDep2> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, System.Func<TOptions, TDep1, TDep2, bool> validation, string failureMessage) => throw null;
                public System.Func<TOptions, TDep1, TDep2, bool> Validation { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptions<,>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptions<TOptions, TDep> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public TDep Dependency { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public ValidateOptions(string name, TDep dependency, System.Func<TOptions, TDep, bool> validation, string failureMessage) => throw null;
                public System.Func<TOptions, TDep, bool> Validation { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptions<>` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptions<TOptions> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public ValidateOptions(string name, System.Func<TOptions, bool> validation, string failureMessage) => throw null;
                public System.Func<TOptions, bool> Validation { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.Options.ValidateOptionsResult` in `Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidateOptionsResult
            {
                public static Microsoft.Extensions.Options.ValidateOptionsResult Fail(string failureMessage) => throw null;
                public static Microsoft.Extensions.Options.ValidateOptionsResult Fail(System.Collections.Generic.IEnumerable<string> failures) => throw null;
                public bool Failed { get => throw null; set => throw null; }
                public string FailureMessage { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<string> Failures { get => throw null; set => throw null; }
                public static Microsoft.Extensions.Options.ValidateOptionsResult Skip;
                public bool Skipped { get => throw null; set => throw null; }
                public bool Succeeded { get => throw null; set => throw null; }
                public static Microsoft.Extensions.Options.ValidateOptionsResult Success;
                public ValidateOptionsResult() => throw null;
            }

        }
    }
}
namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'DynamicallyAccessedMemberTypes' is not stubbed in this assembly 'Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

            /* Duplicate type 'DynamicallyAccessedMembersAttribute' is not stubbed in this assembly 'Microsoft.Extensions.Options, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
}
