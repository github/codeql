// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.DefaultServiceProviderFactory` in `Microsoft.Extensions.DependencyInjection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultServiceProviderFactory : Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<Microsoft.Extensions.DependencyInjection.IServiceCollection>
            {
                public Microsoft.Extensions.DependencyInjection.IServiceCollection CreateBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public System.IServiceProvider CreateServiceProvider(Microsoft.Extensions.DependencyInjection.IServiceCollection containerBuilder) => throw null;
                public DefaultServiceProviderFactory(Microsoft.Extensions.DependencyInjection.ServiceProviderOptions options) => throw null;
                public DefaultServiceProviderFactory() => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceCollection` in `Microsoft.Extensions.DependencyInjection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ServiceCollection : System.Collections.IEnumerable, System.Collections.Generic.IList<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, Microsoft.Extensions.DependencyInjection.IServiceCollection
            {
                void System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>.Add(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void Clear() => throw null;
                public bool Contains(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void CopyTo(Microsoft.Extensions.DependencyInjection.ServiceDescriptor[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void Insert(int index, Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public bool IsReadOnly { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.ServiceDescriptor this[int index] { get => throw null; set => throw null; }
                public bool Remove(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void RemoveAt(int index) => throw null;
                public ServiceCollection() => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceCollectionContainerBuilderExtensions` in `Microsoft.Extensions.DependencyInjection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ServiceCollectionContainerBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.ServiceProvider BuildServiceProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, bool validateScopes) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceProvider BuildServiceProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.DependencyInjection.ServiceProviderOptions options) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceProvider BuildServiceProvider(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceProvider` in `Microsoft.Extensions.DependencyInjection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ServiceProvider : System.IServiceProvider, System.IDisposable, System.IAsyncDisposable
            {
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public object GetService(System.Type serviceType) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceProviderOptions` in `Microsoft.Extensions.DependencyInjection, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ServiceProviderOptions
            {
                public ServiceProviderOptions() => throw null;
                public bool ValidateOnBuild { get => throw null; set => throw null; }
                public bool ValidateScopes { get => throw null; set => throw null; }
            }

        }
    }
}
