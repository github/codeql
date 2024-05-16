// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.ObjectPool, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace ObjectPool
        {
            public class DefaultObjectPool<T> : Microsoft.Extensions.ObjectPool.ObjectPool<T> where T : class
            {
                public DefaultObjectPool(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) => throw null;
                public DefaultObjectPool(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy, int maximumRetained) => throw null;
                public override T Get() => throw null;
                public override void Return(T obj) => throw null;
            }
            public class DefaultObjectPoolProvider : Microsoft.Extensions.ObjectPool.ObjectPoolProvider
            {
                public override Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) where T : class => throw null;
                public DefaultObjectPoolProvider() => throw null;
                public int MaximumRetained { get => throw null; set { } }
            }
            public class DefaultPooledObjectPolicy<T> : Microsoft.Extensions.ObjectPool.PooledObjectPolicy<T> where T : class, new()
            {
                public override T Create() => throw null;
                public DefaultPooledObjectPolicy() => throw null;
                public override bool Return(T obj) => throw null;
            }
            public interface IPooledObjectPolicy<T>
            {
                T Create();
                bool Return(T obj);
            }
            public interface IResettable
            {
                bool TryReset();
            }
            public class LeakTrackingObjectPool<T> : Microsoft.Extensions.ObjectPool.ObjectPool<T> where T : class
            {
                public LeakTrackingObjectPool(Microsoft.Extensions.ObjectPool.ObjectPool<T> inner) => throw null;
                public override T Get() => throw null;
                public override void Return(T obj) => throw null;
            }
            public class LeakTrackingObjectPoolProvider : Microsoft.Extensions.ObjectPool.ObjectPoolProvider
            {
                public override Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) where T : class => throw null;
                public LeakTrackingObjectPoolProvider(Microsoft.Extensions.ObjectPool.ObjectPoolProvider inner) => throw null;
            }
            public abstract class ObjectPool<T> where T : class
            {
                protected ObjectPool() => throw null;
                public abstract T Get();
                public abstract void Return(T obj);
            }
            public static class ObjectPool
            {
                public static Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy = default(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T>)) where T : class, new() => throw null;
            }
            public abstract class ObjectPoolProvider
            {
                public Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>() where T : class, new() => throw null;
                public abstract Microsoft.Extensions.ObjectPool.ObjectPool<T> Create<T>(Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T> policy) where T : class;
                protected ObjectPoolProvider() => throw null;
            }
            public static partial class ObjectPoolProviderExtensions
            {
                public static Microsoft.Extensions.ObjectPool.ObjectPool<System.Text.StringBuilder> CreateStringBuilderPool(this Microsoft.Extensions.ObjectPool.ObjectPoolProvider provider) => throw null;
                public static Microsoft.Extensions.ObjectPool.ObjectPool<System.Text.StringBuilder> CreateStringBuilderPool(this Microsoft.Extensions.ObjectPool.ObjectPoolProvider provider, int initialCapacity, int maximumRetainedCapacity) => throw null;
            }
            public abstract class PooledObjectPolicy<T> : Microsoft.Extensions.ObjectPool.IPooledObjectPolicy<T>
            {
                public abstract T Create();
                protected PooledObjectPolicy() => throw null;
                public abstract bool Return(T obj);
            }
            public class StringBuilderPooledObjectPolicy : Microsoft.Extensions.ObjectPool.PooledObjectPolicy<System.Text.StringBuilder>
            {
                public override System.Text.StringBuilder Create() => throw null;
                public StringBuilderPooledObjectPolicy() => throw null;
                public int InitialCapacity { get => throw null; set { } }
                public int MaximumRetainedCapacity { get => throw null; set { } }
                public override bool Return(System.Text.StringBuilder obj) => throw null;
            }
        }
    }
}
