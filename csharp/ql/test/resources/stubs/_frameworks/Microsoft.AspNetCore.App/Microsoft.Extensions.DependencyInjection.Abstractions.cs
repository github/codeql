// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.ActivatorUtilities` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ActivatorUtilities
            {
                public static Microsoft.Extensions.DependencyInjection.ObjectFactory CreateFactory(System.Type instanceType, System.Type[] argumentTypes) => throw null;
                public static object CreateInstance(System.IServiceProvider provider, System.Type instanceType, params object[] parameters) => throw null;
                public static T CreateInstance<T>(System.IServiceProvider provider, params object[] parameters) => throw null;
                public static object GetServiceOrCreateInstance(System.IServiceProvider provider, System.Type type) => throw null;
                public static T GetServiceOrCreateInstance<T>(System.IServiceProvider provider) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ActivatorUtilitiesConstructorAttribute` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ActivatorUtilitiesConstructorAttribute : System.Attribute
            {
                public ActivatorUtilitiesConstructorAttribute() => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.AsyncServiceScope` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct AsyncServiceScope : Microsoft.Extensions.DependencyInjection.IServiceScope, System.IAsyncDisposable, System.IDisposable
            {
                // Stub generator skipped constructor 
                public AsyncServiceScope(Microsoft.Extensions.DependencyInjection.IServiceScope serviceScope) => throw null;
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IServiceCollection` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IServiceCollection : System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IList<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.IEnumerable
            {
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IServiceProviderFactory<>` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IServiceProviderFactory<TContainerBuilder>
            {
                TContainerBuilder CreateBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services);
                System.IServiceProvider CreateServiceProvider(TContainerBuilder containerBuilder);
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IServiceProviderIsService` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IServiceProviderIsService
            {
                bool IsService(System.Type serviceType);
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IServiceScope` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IServiceScope : System.IDisposable
            {
                System.IServiceProvider ServiceProvider { get; }
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IServiceScopeFactory` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IServiceScopeFactory
            {
                Microsoft.Extensions.DependencyInjection.IServiceScope CreateScope();
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ISupportRequiredService` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISupportRequiredService
            {
                object GetRequiredService(System.Type serviceType);
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ObjectFactory` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public delegate object ObjectFactory(System.IServiceProvider serviceProvider, object[] arguments);

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceCollection` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ServiceCollection : Microsoft.Extensions.DependencyInjection.IServiceCollection, System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IList<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.IEnumerable
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
                public void MakeReadOnly() => throw null;
                public bool Remove(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void RemoveAt(int index) => throw null;
                public ServiceCollection() => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceCollectionServiceExtensions` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ServiceCollectionServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object implementationInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, TService implementationInstance) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceDescriptor` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ServiceDescriptor
            {
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Describe(System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Describe(System.Type serviceType, System.Type implementationType, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public System.Func<System.IServiceProvider, object> ImplementationFactory { get => throw null; }
                public object ImplementationInstance { get => throw null; }
                public System.Type ImplementationType { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.ServiceLifetime Lifetime { get => throw null; }
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped(System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped(System.Type service, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped<TService, TImplementation>() where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped<TService, TImplementation>(System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped<TService>(System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public ServiceDescriptor(System.Type serviceType, System.Func<System.IServiceProvider, object> factory, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public ServiceDescriptor(System.Type serviceType, System.Type implementationType, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public ServiceDescriptor(System.Type serviceType, object instance) => throw null;
                public System.Type ServiceType { get => throw null; }
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton(System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton(System.Type service, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton(System.Type serviceType, object implementationInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService, TImplementation>() where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService, TImplementation>(System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService>(System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService>(TService implementationInstance) where TService : class => throw null;
                public override string ToString() => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient(System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient(System.Type service, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient<TService, TImplementation>() where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient<TService, TImplementation>(System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TImplementation : class, TService where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient<TService>(System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceLifetime` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum ServiceLifetime : int
            {
                Scoped = 1,
                Singleton = 0,
                Transient = 2,
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ServiceProviderServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.AsyncServiceScope CreateAsyncScope(this System.IServiceProvider provider) => throw null;
                public static Microsoft.Extensions.DependencyInjection.AsyncServiceScope CreateAsyncScope(this Microsoft.Extensions.DependencyInjection.IServiceScopeFactory serviceScopeFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceScope CreateScope(this System.IServiceProvider provider) => throw null;
                public static object GetRequiredService(this System.IServiceProvider provider, System.Type serviceType) => throw null;
                public static T GetRequiredService<T>(this System.IServiceProvider provider) => throw null;
                public static T GetService<T>(this System.IServiceProvider provider) => throw null;
                public static System.Collections.Generic.IEnumerable<object> GetServices(this System.IServiceProvider provider, System.Type serviceType) => throw null;
                public static System.Collections.Generic.IEnumerable<T> GetServices<T>(this System.IServiceProvider provider) => throw null;
            }

            namespace Extensions
            {
                // Generated from `Microsoft.Extensions.DependencyInjection.Extensions.ServiceCollectionDescriptorExtensions` in `Microsoft.Extensions.DependencyInjection.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ServiceCollectionDescriptorExtensions
                {
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection Add(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> descriptors) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection Add(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection RemoveAll(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type serviceType) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection RemoveAll<T>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection Replace(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static void TryAdd(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> descriptors) => throw null;
                    public static void TryAdd(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static void TryAddEnumerable(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> descriptors) => throw null;
                    public static void TryAddEnumerable(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static void TryAddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service) => throw null;
                    public static void TryAddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                    public static void TryAddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Type implementationType) => throw null;
                    public static void TryAddScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TImplementation : class, TService where TService : class => throw null;
                    public static void TryAddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class => throw null;
                    public static void TryAddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service) => throw null;
                    public static void TryAddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                    public static void TryAddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Type implementationType) => throw null;
                    public static void TryAddSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TImplementation : class, TService where TService : class => throw null;
                    public static void TryAddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class => throw null;
                    public static void TryAddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, TService instance) where TService : class => throw null;
                    public static void TryAddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service) => throw null;
                    public static void TryAddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                    public static void TryAddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Type implementationType) => throw null;
                    public static void TryAddTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TImplementation : class, TService where TService : class => throw null;
                    public static void TryAddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class => throw null;
                    public static void TryAddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                }

            }
        }
    }
}
