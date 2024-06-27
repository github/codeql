// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Options, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class OptionsBuilderExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> ValidateOnStart<TOptions>(this Microsoft.Extensions.Options.OptionsBuilder<TOptions> optionsBuilder) where TOptions : class => throw null;
            }
            public static partial class OptionsServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> AddOptions<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> AddOptions<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> AddOptionsWithValidateOnStart<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name = default(string)) where TOptions : class => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<TOptions> AddOptionsWithValidateOnStart<TOptions, TValidateOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name = default(string)) where TOptions : class where TValidateOptions : class, Microsoft.Extensions.Options.IValidateOptions<TOptions> => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection Configure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureAll<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object configureInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureOptions(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type configureType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureOptions<TConfigureOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TConfigureOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection PostConfigure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection PostConfigure<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection PostConfigureAll<TOptions>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<TOptions> configureOptions) where TOptions : class => throw null;
            }
        }
        namespace Options
        {
            public class ConfigureNamedOptions<TOptions> : Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions>, Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class
            {
                public System.Action<TOptions> Action { get => throw null; }
                public virtual void Configure(string name, TOptions options) => throw null;
                public void Configure(TOptions options) => throw null;
                public ConfigureNamedOptions(string name, System.Action<TOptions> action) => throw null;
                public string Name { get => throw null; }
            }
            public class ConfigureNamedOptions<TOptions, TDep> : Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions>, Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class where TDep : class
            {
                public System.Action<TOptions, TDep> Action { get => throw null; }
                public virtual void Configure(string name, TOptions options) => throw null;
                public void Configure(TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep dependency, System.Action<TOptions, TDep> action) => throw null;
                public TDep Dependency { get => throw null; }
                public string Name { get => throw null; }
            }
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2> : Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions>, Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class
            {
                public System.Action<TOptions, TDep1, TDep2> Action { get => throw null; }
                public virtual void Configure(string name, TOptions options) => throw null;
                public void Configure(TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency, TDep2 dependency2, System.Action<TOptions, TDep1, TDep2> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public string Name { get => throw null; }
            }
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2, TDep3> : Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions>, Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class where TDep3 : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3> Action { get => throw null; }
                public virtual void Configure(string name, TOptions options) => throw null;
                public void Configure(TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency, TDep2 dependency2, TDep3 dependency3, System.Action<TOptions, TDep1, TDep2, TDep3> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public string Name { get => throw null; }
            }
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2, TDep3, TDep4> : Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions>, Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> Action { get => throw null; }
                public virtual void Configure(string name, TOptions options) => throw null;
                public void Configure(TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public string Name { get => throw null; }
            }
            public class ConfigureNamedOptions<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> : Microsoft.Extensions.Options.IConfigureNamedOptions<TOptions>, Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> Action { get => throw null; }
                public virtual void Configure(string name, TOptions options) => throw null;
                public void Configure(TOptions options) => throw null;
                public ConfigureNamedOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, TDep5 dependency5, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public TDep5 Dependency5 { get => throw null; }
                public string Name { get => throw null; }
            }
            public class ConfigureOptions<TOptions> : Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class
            {
                public System.Action<TOptions> Action { get => throw null; }
                public virtual void Configure(TOptions options) => throw null;
                public ConfigureOptions(System.Action<TOptions> action) => throw null;
            }
            public interface IConfigureNamedOptions<TOptions> : Microsoft.Extensions.Options.IConfigureOptions<TOptions> where TOptions : class
            {
                void Configure(string name, TOptions options);
            }
            public interface IConfigureOptions<TOptions> where TOptions : class
            {
                void Configure(TOptions options);
            }
            public interface IOptions<TOptions> where TOptions : class
            {
                TOptions Value { get; }
            }
            public interface IOptionsChangeTokenSource<TOptions>
            {
                Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                string Name { get; }
            }
            public interface IOptionsFactory<TOptions> where TOptions : class
            {
                TOptions Create(string name);
            }
            public interface IOptionsMonitor<TOptions>
            {
                TOptions CurrentValue { get; }
                TOptions Get(string name);
                System.IDisposable OnChange(System.Action<TOptions, string> listener);
            }
            public interface IOptionsMonitorCache<TOptions> where TOptions : class
            {
                void Clear();
                TOptions GetOrAdd(string name, System.Func<TOptions> createOptions);
                bool TryAdd(string name, TOptions options);
                bool TryRemove(string name);
            }
            public interface IOptionsSnapshot<TOptions> : Microsoft.Extensions.Options.IOptions<TOptions> where TOptions : class
            {
                TOptions Get(string name);
            }
            public interface IPostConfigureOptions<TOptions> where TOptions : class
            {
                void PostConfigure(string name, TOptions options);
            }
            public interface IStartupValidator
            {
                void Validate();
            }
            public interface IValidateOptions<TOptions> where TOptions : class
            {
                Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options);
            }
            public static class Options
            {
                public static Microsoft.Extensions.Options.IOptions<TOptions> Create<TOptions>(TOptions options) where TOptions : class => throw null;
                public static readonly string DefaultName;
            }
            public class OptionsBuilder<TOptions> where TOptions : class
            {
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure(System.Action<TOptions> configureOptions) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep>(System.Action<TOptions, TDep> configureOptions) where TDep : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2>(System.Action<TOptions, TDep1, TDep2> configureOptions) where TDep1 : class where TDep2 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2, TDep3>(System.Action<TOptions, TDep1, TDep2, TDep3> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2, TDep3, TDep4>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Configure<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class => throw null;
                public OptionsBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) => throw null;
                public string Name { get => throw null; }
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure(System.Action<TOptions> configureOptions) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep>(System.Action<TOptions, TDep> configureOptions) where TDep : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2>(System.Action<TOptions, TDep1, TDep2> configureOptions) where TDep1 : class where TDep2 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2, TDep3>(System.Action<TOptions, TDep1, TDep2, TDep3> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2, TDep3, TDep4>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> PostConfigure<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> configureOptions) where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class => throw null;
                public Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get => throw null; }
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate(System.Func<TOptions, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate(System.Func<TOptions, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep>(System.Func<TOptions, TDep, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep>(System.Func<TOptions, TDep, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2>(System.Func<TOptions, TDep1, TDep2, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2>(System.Func<TOptions, TDep1, TDep2, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3>(System.Func<TOptions, TDep1, TDep2, TDep3, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3>(System.Func<TOptions, TDep1, TDep2, TDep3, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> validation, string failureMessage) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> validation) => throw null;
                public virtual Microsoft.Extensions.Options.OptionsBuilder<TOptions> Validate<TDep1, TDep2, TDep3, TDep4, TDep5>(System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> validation, string failureMessage) => throw null;
            }
            public class OptionsCache<TOptions> : Microsoft.Extensions.Options.IOptionsMonitorCache<TOptions> where TOptions : class
            {
                public void Clear() => throw null;
                public OptionsCache() => throw null;
                public virtual TOptions GetOrAdd(string name, System.Func<TOptions> createOptions) => throw null;
                public virtual bool TryAdd(string name, TOptions options) => throw null;
                public virtual bool TryRemove(string name) => throw null;
            }
            public class OptionsFactory<TOptions> : Microsoft.Extensions.Options.IOptionsFactory<TOptions> where TOptions : class
            {
                public TOptions Create(string name) => throw null;
                protected virtual TOptions CreateInstance(string name) => throw null;
                public OptionsFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IConfigureOptions<TOptions>> setups, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IPostConfigureOptions<TOptions>> postConfigures) => throw null;
                public OptionsFactory(System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IConfigureOptions<TOptions>> setups, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IPostConfigureOptions<TOptions>> postConfigures, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IValidateOptions<TOptions>> validations) => throw null;
            }
            public class OptionsManager<TOptions> : Microsoft.Extensions.Options.IOptions<TOptions>, Microsoft.Extensions.Options.IOptionsSnapshot<TOptions> where TOptions : class
            {
                public OptionsManager(Microsoft.Extensions.Options.IOptionsFactory<TOptions> factory) => throw null;
                public virtual TOptions Get(string name) => throw null;
                public TOptions Value { get => throw null; }
            }
            public class OptionsMonitor<TOptions> : System.IDisposable, Microsoft.Extensions.Options.IOptionsMonitor<TOptions> where TOptions : class
            {
                public OptionsMonitor(Microsoft.Extensions.Options.IOptionsFactory<TOptions> factory, System.Collections.Generic.IEnumerable<Microsoft.Extensions.Options.IOptionsChangeTokenSource<TOptions>> sources, Microsoft.Extensions.Options.IOptionsMonitorCache<TOptions> cache) => throw null;
                public TOptions CurrentValue { get => throw null; }
                public void Dispose() => throw null;
                public virtual TOptions Get(string name) => throw null;
                public System.IDisposable OnChange(System.Action<TOptions, string> listener) => throw null;
            }
            public static partial class OptionsMonitorExtensions
            {
                public static System.IDisposable OnChange<TOptions>(this Microsoft.Extensions.Options.IOptionsMonitor<TOptions> monitor, System.Action<TOptions> listener) => throw null;
            }
            public class OptionsValidationException : System.Exception
            {
                public OptionsValidationException(string optionsName, System.Type optionsType, System.Collections.Generic.IEnumerable<string> failureMessages) => throw null;
                public System.Collections.Generic.IEnumerable<string> Failures { get => throw null; }
                public override string Message { get => throw null; }
                public string OptionsName { get => throw null; }
                public System.Type OptionsType { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)12)]
            public sealed class OptionsValidatorAttribute : System.Attribute
            {
                public OptionsValidatorAttribute() => throw null;
            }
            public class OptionsWrapper<TOptions> : Microsoft.Extensions.Options.IOptions<TOptions> where TOptions : class
            {
                public OptionsWrapper(TOptions options) => throw null;
                public TOptions Value { get => throw null; }
            }
            public class PostConfigureOptions<TOptions> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class
            {
                public System.Action<TOptions> Action { get => throw null; }
                public PostConfigureOptions(string name, System.Action<TOptions> action) => throw null;
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
            }
            public class PostConfigureOptions<TOptions, TDep> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class where TDep : class
            {
                public System.Action<TOptions, TDep> Action { get => throw null; }
                public PostConfigureOptions(string name, TDep dependency, System.Action<TOptions, TDep> action) => throw null;
                public TDep Dependency { get => throw null; }
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public void PostConfigure(TOptions options) => throw null;
            }
            public class PostConfigureOptions<TOptions, TDep1, TDep2> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class
            {
                public System.Action<TOptions, TDep1, TDep2> Action { get => throw null; }
                public PostConfigureOptions(string name, TDep1 dependency, TDep2 dependency2, System.Action<TOptions, TDep1, TDep2> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public void PostConfigure(TOptions options) => throw null;
            }
            public class PostConfigureOptions<TOptions, TDep1, TDep2, TDep3> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class where TDep3 : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3> Action { get => throw null; }
                public PostConfigureOptions(string name, TDep1 dependency, TDep2 dependency2, TDep3 dependency3, System.Action<TOptions, TDep1, TDep2, TDep3> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public void PostConfigure(TOptions options) => throw null;
            }
            public class PostConfigureOptions<TOptions, TDep1, TDep2, TDep3, TDep4> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> Action { get => throw null; }
                public PostConfigureOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public void PostConfigure(TOptions options) => throw null;
            }
            public class PostConfigureOptions<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class where TDep1 : class where TDep2 : class where TDep3 : class where TDep4 : class where TDep5 : class
            {
                public System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> Action { get => throw null; }
                public PostConfigureOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, TDep5 dependency5, System.Action<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> action) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public TDep5 Dependency5 { get => throw null; }
                public string Name { get => throw null; }
                public virtual void PostConfigure(string name, TOptions options) => throw null;
                public void PostConfigure(TOptions options) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)384)]
            public sealed class ValidateEnumeratedItemsAttribute : System.Attribute
            {
                public ValidateEnumeratedItemsAttribute() => throw null;
                public ValidateEnumeratedItemsAttribute(System.Type validator) => throw null;
                public System.Type Validator { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)384)]
            public sealed class ValidateObjectMembersAttribute : System.Attribute
            {
                public ValidateObjectMembersAttribute() => throw null;
                public ValidateObjectMembersAttribute(System.Type validator) => throw null;
                public System.Type Validator { get => throw null; }
            }
            public class ValidateOptions<TOptions> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public ValidateOptions(string name, System.Func<TOptions, bool> validation, string failureMessage) => throw null;
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public System.Func<TOptions, bool> Validation { get => throw null; }
            }
            public class ValidateOptions<TOptions, TDep> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public ValidateOptions(string name, TDep dependency, System.Func<TOptions, TDep, bool> validation, string failureMessage) => throw null;
                public TDep Dependency { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public System.Func<TOptions, TDep, bool> Validation { get => throw null; }
            }
            public class ValidateOptions<TOptions, TDep1, TDep2> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, System.Func<TOptions, TDep1, TDep2, bool> validation, string failureMessage) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public System.Func<TOptions, TDep1, TDep2, bool> Validation { get => throw null; }
            }
            public class ValidateOptions<TOptions, TDep1, TDep2, TDep3> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, System.Func<TOptions, TDep1, TDep2, TDep3, bool> validation, string failureMessage) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public System.Func<TOptions, TDep1, TDep2, TDep3, bool> Validation { get => throw null; }
            }
            public class ValidateOptions<TOptions, TDep1, TDep2, TDep3, TDep4> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> validation, string failureMessage) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, bool> Validation { get => throw null; }
            }
            public class ValidateOptions<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5> : Microsoft.Extensions.Options.IValidateOptions<TOptions> where TOptions : class
            {
                public ValidateOptions(string name, TDep1 dependency1, TDep2 dependency2, TDep3 dependency3, TDep4 dependency4, TDep5 dependency5, System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> validation, string failureMessage) => throw null;
                public TDep1 Dependency1 { get => throw null; }
                public TDep2 Dependency2 { get => throw null; }
                public TDep3 Dependency3 { get => throw null; }
                public TDep4 Dependency4 { get => throw null; }
                public TDep5 Dependency5 { get => throw null; }
                public string FailureMessage { get => throw null; }
                public string Name { get => throw null; }
                public Microsoft.Extensions.Options.ValidateOptionsResult Validate(string name, TOptions options) => throw null;
                public System.Func<TOptions, TDep1, TDep2, TDep3, TDep4, TDep5, bool> Validation { get => throw null; }
            }
            public class ValidateOptionsResult
            {
                public ValidateOptionsResult() => throw null;
                public static Microsoft.Extensions.Options.ValidateOptionsResult Fail(System.Collections.Generic.IEnumerable<string> failures) => throw null;
                public static Microsoft.Extensions.Options.ValidateOptionsResult Fail(string failureMessage) => throw null;
                public bool Failed { get => throw null; set { } }
                public string FailureMessage { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> Failures { get => throw null; set { } }
                public static readonly Microsoft.Extensions.Options.ValidateOptionsResult Skip;
                public bool Skipped { get => throw null; set { } }
                public bool Succeeded { get => throw null; set { } }
                public static readonly Microsoft.Extensions.Options.ValidateOptionsResult Success;
            }
            public class ValidateOptionsResultBuilder
            {
                public void AddError(string error, string propertyName = default(string)) => throw null;
                public void AddResult(Microsoft.Extensions.Options.ValidateOptionsResult result) => throw null;
                public void AddResult(System.ComponentModel.DataAnnotations.ValidationResult result) => throw null;
                public void AddResults(System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.ValidationResult> results) => throw null;
                public Microsoft.Extensions.Options.ValidateOptionsResult Build() => throw null;
                public void Clear() => throw null;
                public ValidateOptionsResultBuilder() => throw null;
            }
        }
    }
}
