// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.DependencyInjection.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class ActivatorUtilities
            {
                public static Microsoft.Extensions.DependencyInjection.ObjectFactory CreateFactory(System.Type instanceType, System.Type[] argumentTypes) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ObjectFactory<T> CreateFactory<T>(System.Type[] argumentTypes) => throw null;
                public static object CreateInstance(System.IServiceProvider provider, System.Type instanceType, params object[] parameters) => throw null;
                public static T CreateInstance<T>(System.IServiceProvider provider, params object[] parameters) => throw null;
                public static object GetServiceOrCreateInstance(System.IServiceProvider provider, System.Type type) => throw null;
                public static T GetServiceOrCreateInstance<T>(System.IServiceProvider provider) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)32767)]
            public class ActivatorUtilitiesConstructorAttribute : System.Attribute
            {
                public ActivatorUtilitiesConstructorAttribute() => throw null;
            }
            public struct AsyncServiceScope : System.IAsyncDisposable, System.IDisposable, Microsoft.Extensions.DependencyInjection.IServiceScope
            {
                public AsyncServiceScope(Microsoft.Extensions.DependencyInjection.IServiceScope serviceScope) => throw null;
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.IServiceProvider ServiceProvider { get => throw null; }
            }
            namespace Extensions
            {
                public static partial class ServiceCollectionDescriptorExtensions
                {
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection Add(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection Add(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> descriptors) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection RemoveAll(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type serviceType) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection RemoveAll<T>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection RemoveAllKeyed(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type serviceType, object serviceKey) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection RemoveAllKeyed<T>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) => throw null;
                    public static Microsoft.Extensions.DependencyInjection.IServiceCollection Replace(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static void TryAdd(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static void TryAdd(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> descriptors) => throw null;
                    public static void TryAddEnumerable(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.DependencyInjection.ServiceDescriptor descriptor) => throw null;
                    public static void TryAddEnumerable(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> descriptors) => throw null;
                    public static void TryAddKeyedScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey) => throw null;
                    public static void TryAddKeyedScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                    public static void TryAddKeyedScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey, System.Type implementationType) => throw null;
                    public static void TryAddKeyedScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) where TService : class => throw null;
                    public static void TryAddKeyedScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddKeyedScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                    public static void TryAddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey) => throw null;
                    public static void TryAddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                    public static void TryAddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey, System.Type implementationType) => throw null;
                    public static void TryAddKeyedSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) where TService : class => throw null;
                    public static void TryAddKeyedSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddKeyedSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey, TService instance) where TService : class => throw null;
                    public static void TryAddKeyedSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                    public static void TryAddKeyedTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey) => throw null;
                    public static void TryAddKeyedTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                    public static void TryAddKeyedTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, object serviceKey, System.Type implementationType) => throw null;
                    public static void TryAddKeyedTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) where TService : class => throw null;
                    public static void TryAddKeyedTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddKeyedTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                    public static void TryAddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service) => throw null;
                    public static void TryAddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                    public static void TryAddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Type implementationType) => throw null;
                    public static void TryAddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class => throw null;
                    public static void TryAddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class where TImplementation : class, TService => throw null;
                    public static void TryAddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service) => throw null;
                    public static void TryAddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                    public static void TryAddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Type implementationType) => throw null;
                    public static void TryAddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class => throw null;
                    public static void TryAddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, TService instance) where TService : class => throw null;
                    public static void TryAddSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class where TImplementation : class, TService => throw null;
                    public static void TryAddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service) => throw null;
                    public static void TryAddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                    public static void TryAddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection, System.Type service, System.Type implementationType) => throw null;
                    public static void TryAddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class => throw null;
                    public static void TryAddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                    public static void TryAddTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection collection) where TService : class where TImplementation : class, TService => throw null;
                }
            }
            [System.AttributeUsage((System.AttributeTargets)2048)]
            public class FromKeyedServicesAttribute : System.Attribute
            {
                public FromKeyedServicesAttribute(object key) => throw null;
                public object Key { get => throw null; }
            }
            public interface IKeyedServiceProvider : System.IServiceProvider
            {
                object GetKeyedService(System.Type serviceType, object serviceKey);
                object GetRequiredKeyedService(System.Type serviceType, object serviceKey);
            }
            public interface IServiceCollection : System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.IEnumerable, System.Collections.Generic.IList<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>
            {
            }
            public interface IServiceProviderFactory<TContainerBuilder>
            {
                TContainerBuilder CreateBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services);
                System.IServiceProvider CreateServiceProvider(TContainerBuilder containerBuilder);
            }
            public interface IServiceProviderIsKeyedService : Microsoft.Extensions.DependencyInjection.IServiceProviderIsService
            {
                bool IsKeyedService(System.Type serviceType, object serviceKey);
            }
            public interface IServiceProviderIsService
            {
                bool IsService(System.Type serviceType);
            }
            public interface IServiceScope : System.IDisposable
            {
                System.IServiceProvider ServiceProvider { get; }
            }
            public interface IServiceScopeFactory
            {
                Microsoft.Extensions.DependencyInjection.IServiceScope CreateScope();
            }
            public interface ISupportRequiredService
            {
                object GetRequiredService(System.Type serviceType);
            }
            public static class KeyedService
            {
                public static object AnyKey { get => throw null; }
            }
            public delegate object ObjectFactory(System.IServiceProvider serviceProvider, object[] arguments);
            public delegate T ObjectFactory<T>(System.IServiceProvider serviceProvider, object[] arguments);
            public class ServiceCollection : System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.Generic.IEnumerable<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, System.Collections.IEnumerable, System.Collections.Generic.IList<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>, Microsoft.Extensions.DependencyInjection.IServiceCollection
            {
                void System.Collections.Generic.ICollection<Microsoft.Extensions.DependencyInjection.ServiceDescriptor>.Add(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void Clear() => throw null;
                public bool Contains(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void CopyTo(Microsoft.Extensions.DependencyInjection.ServiceDescriptor[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public ServiceCollection() => throw null;
                public System.Collections.Generic.IEnumerator<Microsoft.Extensions.DependencyInjection.ServiceDescriptor> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void Insert(int index, Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public bool IsReadOnly { get => throw null; }
                public void MakeReadOnly() => throw null;
                public bool Remove(Microsoft.Extensions.DependencyInjection.ServiceDescriptor item) => throw null;
                public void RemoveAt(int index) => throw null;
                public Microsoft.Extensions.DependencyInjection.ServiceDescriptor this[int index] { get => throw null; set { } }
            }
            public static partial class ServiceCollectionServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, object implementationInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, TService implementationInstance) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object serviceKey, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddKeyedTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, object serviceKey, System.Func<System.IServiceProvider, object, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddScoped<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, object implementationInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, TService implementationInstance) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddSingleton<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Type serviceType, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddTransient<TService, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
            }
            public class ServiceDescriptor
            {
                public ServiceDescriptor(System.Type serviceType, System.Func<System.IServiceProvider, object> factory, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public ServiceDescriptor(System.Type serviceType, object instance) => throw null;
                public ServiceDescriptor(System.Type serviceType, object serviceKey, System.Func<System.IServiceProvider, object, object> factory, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public ServiceDescriptor(System.Type serviceType, object serviceKey, object instance) => throw null;
                public ServiceDescriptor(System.Type serviceType, object serviceKey, System.Type implementationType, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public ServiceDescriptor(System.Type serviceType, System.Type implementationType, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Describe(System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Describe(System.Type serviceType, System.Type implementationType, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor DescribeKeyed(System.Type serviceType, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor DescribeKeyed(System.Type serviceType, object serviceKey, System.Type implementationType, Microsoft.Extensions.DependencyInjection.ServiceLifetime lifetime) => throw null;
                public System.Func<System.IServiceProvider, object> ImplementationFactory { get => throw null; }
                public object ImplementationInstance { get => throw null; }
                public System.Type ImplementationType { get => throw null; }
                public bool IsKeyedService { get => throw null; }
                public System.Func<System.IServiceProvider, object, object> KeyedImplementationFactory { get => throw null; }
                public object KeyedImplementationInstance { get => throw null; }
                public System.Type KeyedImplementationType { get => throw null; }
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedScoped(System.Type service, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedScoped(System.Type service, object serviceKey, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedScoped<TService>(object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedScoped<TService, TImplementation>(object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedScoped<TService, TImplementation>(object serviceKey, System.Func<System.IServiceProvider, object, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton(System.Type serviceType, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton(System.Type serviceType, object serviceKey, object implementationInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton(System.Type service, object serviceKey, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton<TService>(object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton<TService>(object serviceKey, TService implementationInstance) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton<TService, TImplementation>(object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedSingleton<TService, TImplementation>(object serviceKey, System.Func<System.IServiceProvider, object, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedTransient(System.Type service, object serviceKey, System.Func<System.IServiceProvider, object, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedTransient(System.Type service, object serviceKey, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedTransient<TService>(object serviceKey, System.Func<System.IServiceProvider, object, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedTransient<TService, TImplementation>(object serviceKey) where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor KeyedTransient<TService, TImplementation>(object serviceKey, System.Func<System.IServiceProvider, object, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public Microsoft.Extensions.DependencyInjection.ServiceLifetime Lifetime { get => throw null; }
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped(System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped(System.Type service, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped<TService>(System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped<TService, TImplementation>() where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Scoped<TService, TImplementation>(System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public object ServiceKey { get => throw null; }
                public System.Type ServiceType { get => throw null; }
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton(System.Type serviceType, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton(System.Type serviceType, object implementationInstance) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton(System.Type service, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService>(System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService>(TService implementationInstance) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService, TImplementation>() where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Singleton<TService, TImplementation>(System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
                public override string ToString() => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient(System.Type service, System.Func<System.IServiceProvider, object> implementationFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient(System.Type service, System.Type implementationType) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient<TService>(System.Func<System.IServiceProvider, TService> implementationFactory) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient<TService, TImplementation>() where TService : class where TImplementation : class, TService => throw null;
                public static Microsoft.Extensions.DependencyInjection.ServiceDescriptor Transient<TService, TImplementation>(System.Func<System.IServiceProvider, TImplementation> implementationFactory) where TService : class where TImplementation : class, TService => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2048)]
            public class ServiceKeyAttribute : System.Attribute
            {
                public ServiceKeyAttribute() => throw null;
            }
            public enum ServiceLifetime
            {
                Singleton = 0,
                Scoped = 1,
                Transient = 2,
            }
            public static partial class ServiceProviderKeyedServiceExtensions
            {
                public static T GetKeyedService<T>(this System.IServiceProvider provider, object serviceKey) => throw null;
                public static System.Collections.Generic.IEnumerable<object> GetKeyedServices(this System.IServiceProvider provider, System.Type serviceType, object serviceKey) => throw null;
                public static System.Collections.Generic.IEnumerable<T> GetKeyedServices<T>(this System.IServiceProvider provider, object serviceKey) => throw null;
                public static object GetRequiredKeyedService(this System.IServiceProvider provider, System.Type serviceType, object serviceKey) => throw null;
                public static T GetRequiredKeyedService<T>(this System.IServiceProvider provider, object serviceKey) => throw null;
            }
            public static partial class ServiceProviderServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.AsyncServiceScope CreateAsyncScope(this Microsoft.Extensions.DependencyInjection.IServiceScopeFactory serviceScopeFactory) => throw null;
                public static Microsoft.Extensions.DependencyInjection.AsyncServiceScope CreateAsyncScope(this System.IServiceProvider provider) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceScope CreateScope(this System.IServiceProvider provider) => throw null;
                public static object GetRequiredService(this System.IServiceProvider provider, System.Type serviceType) => throw null;
                public static T GetRequiredService<T>(this System.IServiceProvider provider) => throw null;
                public static T GetService<T>(this System.IServiceProvider provider) => throw null;
                public static System.Collections.Generic.IEnumerable<object> GetServices(this System.IServiceProvider provider, System.Type serviceType) => throw null;
                public static System.Collections.Generic.IEnumerable<T> GetServices<T>(this System.IServiceProvider provider) => throw null;
            }
        }
    }
}
