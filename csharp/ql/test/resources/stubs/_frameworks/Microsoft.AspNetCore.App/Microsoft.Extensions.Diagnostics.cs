// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Diagnostics, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class MetricsServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddMetrics(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddMetrics(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder> configure) => throw null;
            }
        }
        namespace Diagnostics
        {
            namespace Metrics
            {
                namespace Configuration
                {
                    public interface IMetricListenerConfigurationFactory
                    {
                        Microsoft.Extensions.Configuration.IConfiguration GetConfiguration(string listenerName);
                    }
                }
                public static class ConsoleMetrics
                {
                    public static string DebugListenerName { get => throw null; }
                }
                public static partial class MetricsBuilderConfigurationExtensions
                {
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder AddConfiguration(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                }
                public static partial class MetricsBuilderConsoleExtensions
                {
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder AddDebugConsole(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder) => throw null;
                }
            }
        }
    }
}
