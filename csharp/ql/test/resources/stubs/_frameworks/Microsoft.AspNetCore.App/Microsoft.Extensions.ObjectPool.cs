// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace ObjectPool
        {
            // Generated from `Microsoft.Extensions.ObjectPool.DefaultObjectPool<>` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultObjectPool<T> : Microsoft.Extensions.ObjectPool.ObjectPool<T> where T : class
            {
                public DefaultObjectPool(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy, int maximumRetained) => throw null;
                public DefaultObjectPool(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) => throw null;
                public override T Get() => throw null;
                public override void Return(T obj) => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.DefaultObjectPoolProvider` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultObjectPoolProvider : Microsoft.Extensions.ObjectPool.ObjectPoolProvider
            {
                public override Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) where T : class => throw null;
                public DefaultObjectPoolProvider() => throw null;
                public int MaximumRetained { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.Extensions.ObjectPool.DefaultPooledObjectPolicy<>` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultPooledObjectPolicy<T> : Microsoft.Extensions.ObjectPool.PooledObjectPolicy<T> where T : class, new()
            {
                public override T Create() => throw null;
                public DefaultPooledObjectPolicy() => throw null;
                public override bool Return(T obj) => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<>` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IPooledObjectPolicy<T>
            {
                T Create();
                bool Return(T obj);
            }

            // Generated from `Microsoft.Extensions.ObjectPool.LeakTrackingObjectPool<>` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LeakTrackingObjectPool<T> : Microsoft.Extensions.ObjectPool.ObjectPool<T> where T : class
            {
                public override T Get() => throw null;
                public LeakTrackingObjectPool(Microsoft.Extensions.ObjectPool.ObjectPool<T> inner) => throw null;
                public override void Return(T obj) => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.LeakTrackingObjectPoolProvider` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LeakTrackingObjectPoolProvider : Microsoft.Extensions.ObjectPool.ObjectPoolProvider
            {
                public override Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) where T : class => throw null;
                public LeakTrackingObjectPoolProvider(Microsoft.Extensions.ObjectPool.ObjectPoolProvider inner) => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.ObjectPool` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ObjectPool
            {
                public static Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy = default(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T>)) where T : class, new() => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.ObjectPool<>` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ObjectPool<T> where T : class
            {
                public abstract T Get();
                protected ObjectPool() => throw null;
                public abstract void Return(T obj);
            }

            // Generated from `Microsoft.Extensions.ObjectPool.ObjectPoolProvider` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ObjectPoolProvider
            {
                public abstract Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) where T : class;
                public Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>() where T : class, new() => throw null;
                protected ObjectPoolProvider() => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.ObjectPoolProviderExtensions` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ObjectPoolProviderExtensions
            {
                public static Microsoft.Extensions.ObjectPool.ObjectPool<System.Text.StringBuilder> CreateStringBuilderPool(this Microsoft.Extensions.ObjectPool.ObjectPoolProvider provider, int initialCapacity, int maximumRetainedCapacity) => throw null;
                public static Microsoft.Extensions.ObjectPool.ObjectPool<System.Text.StringBuilder> CreateStringBuilderPool(this Microsoft.Extensions.ObjectPool.ObjectPoolProvider provider) => throw null;
            }

            // Generated from `Microsoft.Extensions.ObjectPool.PooledObjectPolicy<>` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class PooledObjectPolicy<T> : Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T>
            {
                public abstract T Create();
                protected PooledObjectPolicy() => throw null;
                public abstract bool Return(T obj);
            }

            // Generated from `Microsoft.Extensions.ObjectPool.StringBuilderPooledObjectPolicy` in `Microsoft.Extensions.ObjectPool, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StringBuilderPooledObjectPolicy : Microsoft.Extensions.ObjectPool.PooledObjectPolicy<System.Text.StringBuilder>
            {
                public override System.Text.StringBuilder Create() => throw null;
                public int InitialCapacity { get => throw null; set => throw null; }
                public int MaximumRetainedCapacity { get => throw null; set => throw null; }
                public override bool Return(System.Text.StringBuilder obj) => throw null;
                public StringBuilderPooledObjectPolicy() => throw null;
            }

        }
    }
}
