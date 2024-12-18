// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Diagnostics.HealthChecks, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class HealthChecksBuilderAddCheckExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck instance, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus, System.Collections.Generic.IEnumerable<string> tags) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck instance, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus = default(Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus?), System.Collections.Generic.IEnumerable<string> tags = default(System.Collections.Generic.IEnumerable<string>), System.TimeSpan? timeout = default(System.TimeSpan?)) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck<T>(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus, System.Collections.Generic.IEnumerable<string> tags) where T : class, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck<T>(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus = default(Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus?), System.Collections.Generic.IEnumerable<string> tags = default(System.Collections.Generic.IEnumerable<string>), System.TimeSpan? timeout = default(System.TimeSpan?)) where T : class, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddTypeActivatedCheck<T>(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, params object[] args) where T : class, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddTypeActivatedCheck<T>(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus, params object[] args) where T : class, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddTypeActivatedCheck<T>(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus, System.Collections.Generic.IEnumerable<string> tags, params object[] args) where T : class, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddTypeActivatedCheck<T>(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus? failureStatus, System.Collections.Generic.IEnumerable<string> tags, System.TimeSpan timeout, params object[] args) where T : class, Microsoft.Extensions.Diagnostics.HealthChecks.IHealthCheck => throw null;
            }
            public static partial class HealthChecksBuilderDelegateExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddAsyncCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<System.Threading.Tasks.Task<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult>> check, System.Collections.Generic.IEnumerable<string> tags) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddAsyncCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<System.Threading.Tasks.Task<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult>> check, System.Collections.Generic.IEnumerable<string> tags = default(System.Collections.Generic.IEnumerable<string>), System.TimeSpan? timeout = default(System.TimeSpan?)) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddAsyncCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<System.Threading.CancellationToken, System.Threading.Tasks.Task<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult>> check, System.Collections.Generic.IEnumerable<string> tags) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddAsyncCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<System.Threading.CancellationToken, System.Threading.Tasks.Task<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult>> check, System.Collections.Generic.IEnumerable<string> tags = default(System.Collections.Generic.IEnumerable<string>), System.TimeSpan? timeout = default(System.TimeSpan?)) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult> check, System.Collections.Generic.IEnumerable<string> tags) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult> check, System.Collections.Generic.IEnumerable<string> tags = default(System.Collections.Generic.IEnumerable<string>), System.TimeSpan? timeout = default(System.TimeSpan?)) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<System.Threading.CancellationToken, Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult> check, System.Collections.Generic.IEnumerable<string> tags) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddCheck(this Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder builder, string name, System.Func<System.Threading.CancellationToken, Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckResult> check, System.Collections.Generic.IEnumerable<string> tags = default(System.Collections.Generic.IEnumerable<string>), System.TimeSpan? timeout = default(System.TimeSpan?)) => throw null;
            }
            public static partial class HealthCheckServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder AddHealthChecks(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }
            public interface IHealthChecksBuilder
            {
                Microsoft.Extensions.DependencyInjection.IHealthChecksBuilder Add(Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckRegistration registration);
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
        }
        namespace Diagnostics
        {
            namespace HealthChecks
            {
                public sealed class HealthCheckPublisherOptions
                {
                    public HealthCheckPublisherOptions() => throw null;
                    public System.TimeSpan Delay { get => throw null; set { } }
                    public System.TimeSpan Period { get => throw null; set { } }
                    public System.Func<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckRegistration, bool> Predicate { get => throw null; set { } }
                    public System.TimeSpan Timeout { get => throw null; set { } }
                }
                public abstract class HealthCheckService
                {
                    public System.Threading.Tasks.Task<Microsoft.Extensions.Diagnostics.HealthChecks.HealthReport> CheckHealthAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.Extensions.Diagnostics.HealthChecks.HealthReport> CheckHealthAsync(System.Func<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckRegistration, bool> predicate, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    protected HealthCheckService() => throw null;
                }
                public sealed class HealthCheckServiceOptions
                {
                    public HealthCheckServiceOptions() => throw null;
                    public System.Collections.Generic.ICollection<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckRegistration> Registrations { get => throw null; }
                }
            }
        }
    }
}
