using Microsoft.CodeAnalysis;
using System;
using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// Any program entity which has a corresponding label in the trap file.
    ///
    /// Entities are divided into two types: normal entities and cached
    /// entities.
    ///
    /// Normal entities implement <see cref="IEntity"/> directly, and they
    /// (may) emit contents to the trap file during object construction.
    ///
    /// Cached entities implement <see cref="ICachedEntity"/>, and they
    /// emit contents to the trap file when <see cref="ICachedEntity.Populate"/>
    /// is called. Caching prevents <see cref="ICachedEntity.Populate"/>
    /// from being called on entities that have already been emitted.
    /// </summary>
    public interface IEntity
    {
        /// <summary>
        /// The label of the entity, as it is in the trap file.
        /// For example, "#123".
        /// </summary>
        Label Label { set; get; }

        /// <summary>
        /// Writes the unique identifier of this entitiy to a trap file.
        /// </summary>
        /// <param name="trapFile">The trapfile to write to.</param>
        void WriteId(TextWriter trapFile);

        /// <summary>
        /// Writes the quoted identifier of this entity,
        /// which could be @"..." or *
        /// </summary>
        /// <param name="trapFile">The trapfile to write to.</param>
        void WriteQuotedId(TextWriter trapFile);

        /// <summary>
        /// The location for reporting purposes.
        /// </summary>
        Location? ReportingLocation { get; }

        /// <summary>
        /// How the entity handles .push and .pop.
        /// </summary>
        TrapStackBehaviour TrapStackBehaviour { get; }
    }

    /// <summary>
    /// How an entity behaves with respect to .push and .pop
    /// </summary>
    public enum TrapStackBehaviour
    {
        /// <summary>
        /// The entity must not be extracted inside a .push/.pop
        /// </summary>
        NoLabel,

        /// <summary>
        /// The entity defines its own label, creating a .push/.pop
        /// </summary>
        PushesLabel,

        /// <summary>
        /// The entity must be extracted inside a .push/.pop
        /// </summary>
        NeedsLabel,

        /// <summary>
        /// The entity can be extracted inside or outside of a .push/.pop
        /// </summary>
        OptionalLabel
    }

    /// <summary>
    /// A cached entity.
    ///
    /// The <see cref="IEntity.Id"/> property is used as label in caching.
    /// </summary>
    public interface ICachedEntity : IEntity
    {
        /// <summary>
        /// Populates the <see cref="Label"/> field and generates output in the trap file
        /// as required. Is only called when <see cref="NeedsPopulation"/> returns
        /// <code>true</code> and the entity has not already been populated.
        /// </summary>
        void Populate(TextWriter trapFile);

        bool NeedsPopulation { get; }

        object? UnderlyingObject { get; }
    }

    /// <summary>
    /// A factory for creating cached entities.
    /// </summary>
    /// <typeparam name="TInit">The type of the initializer.</typeparam>
    public interface ICachedEntityFactory<in TInit, out TEntity> where TEntity : ICachedEntity
    {
        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        TEntity Create(Context cx, TInit init);
    }

    public static class ICachedEntityFactoryExtensions
    {
        /// <summary>
        /// Creates and populates a new entity, or returns the existing one from the cache,
        /// based on the supplied cache key.
        /// </summary>
        /// <typeparam name="TInit">The type used to construct the entity.</typeparam>
        /// <typeparam name="TEntity">The type of the entity to create.</typeparam>
        /// <param name="factory">The factory used to construct the entity.</param>
        /// <param name="cx">The extractor context.</param>
        /// <param name="cacheKey">The key used for caching.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The entity.</returns>
        public static TEntity CreateEntity<TInit, TEntity>(this ICachedEntityFactory<TInit, TEntity> factory, Context cx, object cacheKey, TInit init)
            where TEntity : ICachedEntity => cx.CreateEntity(factory, cacheKey, init);

        /// <summary>
        /// Creates and populates a new entity from an `ISymbol`, or returns the existing one
        /// from the cache.
        /// </summary>
        /// <typeparam name="TSymbol">The type used to construct the entity.</typeparam>
        /// <typeparam name="TEntity">The type of the entity to create.</typeparam>
        /// <param name="factory">The factory used to construct the entity.</param>
        /// <param name="cx">The extractor context.</param>
        /// <param name="init">The initializer for the entity.</param>
        /// <returns>The entity.</returns>
        public static TEntity CreateEntityFromSymbol<TSymbol, TEntity>(this ICachedEntityFactory<TSymbol, TEntity> factory, Context cx, TSymbol init)
            where TSymbol : ISymbol
            where TEntity : ICachedEntity => cx.CreateEntityFromSymbol(factory, init);

        public static void DefineLabel(this IEntity entity, TextWriter trapFile, IExtractor extractor)
        {
            trapFile.WriteLabel(entity);
            trapFile.Write("=");
            try
            {
                entity.WriteQuotedId(trapFile);
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                trapFile.WriteLine("\"");
                extractor.Message(new Message($"Unhandled exception generating id: {ex.Message}", entity.ToString() ?? "", null, ex.StackTrace));
            }
            trapFile.WriteLine();
        }

        public static void DefineFreshLabel(this IEntity entity, TextWriter trapFile)
        {
            trapFile.WriteLabel(entity);
            trapFile.WriteLine("=*");
        }

        /// <summary>
        /// Generates a debug string for this entity.
        /// </summary>
        /// <param name="entity">The entity to view.</param>
        /// <returns>The debug string.</returns>
        public static string GetDebugLabel(this IEntity entity)
        {
            using var writer = new StringWriter();
            writer.WriteLabel(entity.Label.Value);
            writer.Write('=');
            entity.WriteQuotedId(writer);
            return writer.ToString();
        }

    }
}
