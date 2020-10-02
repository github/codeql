using System;
using System.Collections.Generic;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// A factory and a cache for mapping source entities to target entities.
    /// Could be considered as a memoizer.
    /// </summary>
    /// <typeparam name="TSrc">The type of the source.</typeparam>
    /// <typeparam name="TTarget">The type of the generated object.</typeparam>
    public class CachedFunction<TSrc, TTarget> where TSrc : notnull
    {
        private readonly Func<TSrc, TTarget> generator;
        private readonly Dictionary<TSrc, TTarget> cache;

        /// <summary>
        /// Initializes the factory with a given mapping.
        /// </summary>
        /// <param name="g">The mapping.</param>
        public CachedFunction(Func<TSrc, TTarget> g)
        {
            generator = g;
            cache = new Dictionary<TSrc, TTarget>();
        }

        /// <summary>
        /// Gets the target for a given source.
        /// Create it if it does not exist.
        /// </summary>
        /// <param name="src">The source object.</param>
        /// <returns>The created object.</returns>
        public TTarget this[TSrc src]
        {
            get
            {
                if (!cache.TryGetValue(src, out var result))
                {
                    result = generator(src);
                    cache[src] = result;
                }
                return result;
            }
        }
    }

    /// <summary>
    /// A factory for mapping a pair of source entities to a target entity.
    /// </summary>
    /// <typeparam name="TSrcEntity1">Source entity type 1.</typeparam>
    /// <typeparam name="TSrcEntity2">Source entity type 2.</typeparam>
    /// <typeparam name="TTarget">The target type.</typeparam>
    public class CachedFunction<TSrcEntity1, TSrcEntity2, TTarget>
    {
        private readonly CachedFunction<(TSrcEntity1, TSrcEntity2), TTarget> factory;

        /// <summary>
        /// Initializes the factory with a given mapping.
        /// </summary>
        /// <param name="g">The mapping.</param>
        public CachedFunction(Func<TSrcEntity1, TSrcEntity2, TTarget> g)
        {
            factory = new CachedFunction<(TSrcEntity1, TSrcEntity2), TTarget>(p => g(p.Item1, p.Item2));
        }

        public TTarget this[TSrcEntity1 s1, TSrcEntity2 s2] => factory[(s1, s2)];
    }
}
