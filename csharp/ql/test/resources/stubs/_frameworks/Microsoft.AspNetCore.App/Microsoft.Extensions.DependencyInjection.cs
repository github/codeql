// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.DependencyInjection, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public class DefaultServiceProviderFactory : Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<Microsoft.Extensions.DependencyInjection.IServiceCollection>
            {
                public Microsoft.Extensions.DependencyInjection.IServiceCollection CreateBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public System.IServiceProvider CreateServiceProvider(Microsoft.Extensions.DependencyInjection.IServiceCollection containerBuilder) => throw null;
                public DefaultServiceProviderFactory() => throw null;
                public DefaultServiceProviderFactory(Microsoft.Extensions.DependencyInjection.ServiceProviderOptions options) => throw null;
            }
            public static partial class ServiceCollectionContainerBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.ServiceProvider BuildServiceProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceProvider BuildServiceProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.DependencyInjection.ServiceProviderOptions options) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceProvider BuildServiceProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, bool validateScopes) => throw null;
            }
            public sealed class ServiceProvider : System.IAsyncDisposable, System.IDisposable, Microsoft.Extensions.DependencyInjection.IKeyedServiceProvider, System.IServiceProvider
            {
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public object GetKeyedService(System.Type serviceType, object serviceKey) => throw null;
                public object GetRequiredKeyedService(System.Type serviceType, object serviceKey) => throw null;
                public object GetService(System.Type serviceType) => throw null;
            }
            public class ServiceProviderOptions
            {
                public ServiceProviderOptions() => throw null;
                public bool ValidateOnBuild { get => throw null; set { } }
                public bool ValidateScopes { get => throw null; set { } }
            }
        }
    }
}
