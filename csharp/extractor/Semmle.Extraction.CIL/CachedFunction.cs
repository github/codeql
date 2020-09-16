using System;
using System.Collections.Generic;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// A factory and a cache for mapping source entities to target entities.
    /// Could be considered as a memoizer.
    /// </summary>
    /// <typeparam name="SrcType">The type of the source.</typeparam>
    /// <typeparam name="TargetType">The type of the generated object.</typeparam>
    public class CachedFunction<SrcType, TargetType> where SrcType : notnull
    {
        readonly Func<SrcType, TargetType> generator;
        readonly Dictionary<SrcType, TargetType> cache;

        /// <summary>
        /// Initializes the factory with a given mapping.
        /// </summary>
        /// <param name="g">The mapping.</param>
        public CachedFunction(Func<SrcType, TargetType> g)
        {
            generator = g;
            cache = new Dictionary<SrcType, TargetType>();
        }

        /// <summary>
        /// Gets the target for a given source.
        /// Create it if it does not exist.
        /// </summary>
        /// <param name="src">The source object.</param>
        /// <returns>The created object.</returns>
        public TargetType this[SrcType src]
        {
            get
            {
                if (!cache.TryGetValue(src, out TargetType result))
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
    /// <typeparam name="Src1">Source entity type 1.</typeparam>
    /// <typeparam name="Src2">Source entity type 2.</typeparam>
    /// <typeparam name="Target">The target type.</typeparam>
    public class CachedFunction<Src1, Src2, Target>
    {
        readonly CachedFunction<(Src1, Src2), Target> factory;

        /// <summary>
        /// Initializes the factory with a given mapping.
        /// </summary>
        /// <param name="g">The mapping.</param>
        public CachedFunction(Func<Src1, Src2, Target> g)
        {
            factory = new CachedFunction<(Src1, Src2), Target>(p => g(p.Item1, p.Item2));
        }

        public Target this[Src1 s1, Src2 s2] => factory[(s1, s2)];
    }
}
