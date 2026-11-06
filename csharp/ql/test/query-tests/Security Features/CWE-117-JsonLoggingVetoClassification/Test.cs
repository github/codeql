using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Console;
using Serilog;
using Serilog.Formatting.Json;
using Serilog.Formatting.Compact;

class VetoCases
{
    static ILoggingBuilder escaped;

    public void ConditionalHost(bool json)
    {
        var builder = WebApplication.CreateBuilder();
        if (json)
            builder.Logging.ClearProviders().AddJsonConsole();
    }

    public void WrongReceiver()
    {
        var builder = WebApplication.CreateBuilder();
        var unrelated = new ServiceCollection();
        unrelated.AddLogging(logging => logging.ClearProviders().AddJsonConsole());
    }

    public void SetupAfterBuild()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Build();
        builder.Logging.ClearProviders().AddJsonConsole();
    }

    public void ConditionalCallback(bool clearDefaults)
    {
        var builder = WebApplication.CreateBuilder();
        builder.Services.AddLogging(logging =>
            (clearDefaults ? logging.ClearProviders() : logging).AddJsonConsole());
    }

    public void ConstructorHost()
    {
        var builder = new Microsoft.Extensions.Hosting.HostApplicationBuilder();
        LoggerFactory.Create(logging => logging.AddJsonConsole());
    }

    public void ConditionalHostAlias(bool first)
    {
        var firstBuilder = WebApplication.CreateBuilder();
        var secondBuilder = WebApplication.CreateBuilder();
        var selected = first ? firstBuilder : secondBuilder;
        selected.Logging.ClearProviders().AddJsonConsole();
    }

    public void ConditionalExternalHostAlias(bool local, WebApplicationBuilder external)
    {
        var builder = WebApplication.CreateBuilder();
        var selected = local ? builder : external;
        selected.Logging.ClearProviders().AddJsonConsole();
    }

    public void ConditionalLoggingAlias(bool local, ILoggingBuilder external)
    {
        var builder = WebApplication.CreateBuilder();
        var selected = local ? builder.Logging : external;
        selected.ClearProviders().AddJsonConsole();
    }

    public void ConditionalServicesAlias(bool local, IServiceCollection external)
    {
        var builder = WebApplication.CreateBuilder();
        var selected = local ? builder.Services : external;
        selected.AddLogging(logging => logging.ClearProviders().AddJsonConsole());
    }

    public void SafeStraightLineAliases()
    {
        var builder = WebApplication.CreateBuilder();
        var alias = builder;
        var logging = alias.Logging;
        logging.ClearProviders();
        logging.AddJsonConsole();
    }

    public void BuildThroughConditionalAlias(bool first)
    {
        var firstBuilder = Host.CreateDefaultBuilder();
        var secondBuilder = Host.CreateDefaultBuilder();
        var selected = first ? firstBuilder : secondBuilder;
        var host = selected.Build();
        firstBuilder.ConfigureLogging(logging => logging.ClearProviders().AddJsonConsole());
        secondBuilder.ConfigureLogging(logging => logging.ClearProviders().AddJsonConsole());
    }

    public void ConditionalAliasBuildAfterSetup(bool first)
    {
        var firstBuilder = Host.CreateDefaultBuilder();
        var secondBuilder = Host.CreateDefaultBuilder();
        firstBuilder.ConfigureLogging(logging => logging.ClearProviders().AddJsonConsole());
        secondBuilder.ConfigureLogging(logging => logging.ClearProviders().AddJsonConsole());
        var selected = first ? firstBuilder : secondBuilder;
        var host = selected.Build();
    }

    public void FormatterOverride()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        builder.Services.PostConfigure<ConsoleLoggerOptions>(options => options.FormatterName = "simple");
        builder.Services.Configure<BusinessOptions>(options => options.Name = "allowed");
    }

    public void DirectProviderRegistration()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        builder.Services.TryAddSingleton<ILoggerProvider, Microsoft.Extensions.Logging.Debug.DebugLoggerProvider>();
    }

    public void DescriptorProviderRegistration()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        builder.Services.TryAddEnumerable(
            ServiceDescriptor.Singleton<ILoggerProvider, Microsoft.Extensions.Logging.Debug.DebugLoggerProvider>());
        builder.Services.Replace(
            ServiceDescriptor.Singleton<ILoggerProvider, Microsoft.Extensions.Logging.Debug.DebugLoggerProvider>());
        builder.Services.Add(
            ServiceDescriptor.Singleton<ILoggerProvider, Microsoft.Extensions.Logging.Debug.DebugLoggerProvider>());
    }

    public void UnknownDelegate(Action<ILoggingBuilder> setup)
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        builder.Services.AddLogging(setup);
    }

    public void UnknownMethodGroup()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        builder.Services.AddLogging(ConfigureUnknown);
    }

    static void ConfigureUnknown(ILoggingBuilder logging) => logging.AddConsole();

    public void UnknownExtension()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        builder.Logging.UseMysteryProvider();
    }

    public void Escape()
    {
        LoggerFactory.Create(logging => escaped = logging);
    }

    public void UnsupportedSerilog(IServiceCollection services, IServiceProvider provider)
    {
        new LoggerConfiguration().CreateLogger();
        services.AddSerilog(configuration => configuration
            .WriteTo.Console(new JsonFormatter())
            .WriteTo.Console());
        services.AddSerilog(configuration => configuration.ReadFrom.Services(provider));
        services.AddSerilog(configuration => configuration
            .WriteTo.Async(write => write.Console()));
        services.AddSerilog(configuration => configuration.AuditTo.Console());
    }

    public void UnsafeFormatterArguments(IServiceCollection services, string delimiter)
    {
        services.AddSerilog(configuration => configuration.WriteTo.Console(
            new JsonFormatter(closingDelimiter: delimiter)));
        services.AddSerilog(configuration => configuration.WriteTo.Console(
            new CompactJsonFormatter(valueFormatter: new CustomValueFormatter())));
    }

    public void AlternativeProvider()
    {
        var builder = WebApplication.CreateBuilder();
        builder.Logging.ClearProviders().AddJsonConsole();
        NLog.Extensions.Logging.LoggingBuilderExtensions.AddNLog(builder.Logging);
    }
}

class BusinessOptions { public string Name { get; set; } }

class CustomValueFormatter : JsonValueFormatter { }

static class UnknownLoggingExtensions
{
    public static ILoggingBuilder UseMysteryProvider(this ILoggingBuilder logging) => logging;
}

class CustomLogger : Microsoft.Extensions.Logging.ILogger
{
    public IDisposable BeginScope<TState>(TState state) => null;
    public bool IsEnabled(LogLevel level) => true;
    public void Log<TState>(LogLevel level, EventId id, TState state, Exception exception,
        Func<TState, Exception, string> formatter) => Console.WriteLine(formatter(state, exception));
}

class CustomLoggerConsumers
{
    readonly Microsoft.Extensions.Logging.ILogger injected;
    public CustomLoggerConsumers(Microsoft.Extensions.Logging.ILogger injected) { this.injected = injected; }
    public void Local(string input) { Microsoft.Extensions.Logging.ILogger logger = new CustomLogger(); logger.LogInformation(input); }
    public void Cast(string input) { ((Microsoft.Extensions.Logging.ILogger)new CustomLogger()).LogInformation(input); }
    public void Injected(string input) { injected.LogInformation(input); }
}

namespace NLog.Extensions.Logging
{
    public static class LoggingBuilderExtensions
    {
        public static ILoggingBuilder AddNLog(this ILoggingBuilder logging) => logging;
    }
}
