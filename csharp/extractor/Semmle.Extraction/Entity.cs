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
        void WriteId(TextWriter writrapFileter);

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
    /// <typeparam name="Initializer">The type of the initializer.</typeparam>
    public interface ICachedEntityFactory<Initializer, Entity> where Entity : ICachedEntity
    {
        /// <summary>
        /// Initializes the entity, but does not generate any trap code.
        /// </summary>
        Entity Create(Context cx, Initializer init);
    }

    public static class ICachedEntityFactoryExtensions
    {
        public static Entity CreateEntity<Entity, T1, T2>(this ICachedEntityFactory<(T1, T2), Entity> factory, Context cx, T1 t1, T2 t2)
            where Entity : ICachedEntity => factory.CreateEntity2(cx, (t1, t2));

        public static Entity CreateEntity<Entity, T1, T2, T3>(this ICachedEntityFactory<(T1, T2, T3), Entity> factory, Context cx, T1 t1, T2 t2, T3 t3)
            where Entity : ICachedEntity => factory.CreateEntity2(cx, (t1, t2, t3));

        public static Entity CreateEntity<Entity, T1, T2, T3, T4>(this ICachedEntityFactory<(T1, T2, T3, T4), Entity> factory, Context cx, T1 t1, T2 t2, T3 t3, T4 t4)
            where Entity : ICachedEntity => factory.CreateEntity2(cx, (t1, t2, t3, t4));

        /// <summary>
        /// Creates and populates a new entity, or returns the existing one from the cache.
        /// </summary>
        /// <typeparam name="Type">The symbol type used to construct the entity.</typeparam>
        /// <typeparam name="Entity">The type of the entity to create.</typeparam>
        /// <param name="cx">The extractor context.</param>
        /// <param name="factory">The factory used to construct the entity.</param>
        /// <param name="init">The initializer for the entity, which may not be null.</param>
        /// <returns>The entity.</returns>
        public static Entity CreateEntity<Type, Entity>(this ICachedEntityFactory<Type, Entity> factory, Context cx, Type init) where Type : notnull
            where Entity : ICachedEntity => cx.CreateNonNullEntity(factory, init);

        public static Entity CreateNullableEntity<Type, Entity>(this ICachedEntityFactory<Type, Entity> factory, Context cx, Type init)
            where Entity : ICachedEntity => cx.CreateNullableEntity(factory, init);

        /// <summary>
        /// Creates and populates a new entity, but uses a different cache.
        /// </summary>
        /// <typeparam name="Type">The symbol type used to construct the entity.</typeparam>
        /// <typeparam name="Entity">The type of the entity to create.</typeparam>
        /// <param name="cx">The extractor context.</param>
        /// <param name="factory">The factory used to construct the entity.</param>
        /// <param name="init">The initializer for the entity, which may be null.</param>
        /// <returns>The entity.</returns>
        public static Entity CreateEntity2<Type, Entity>(this ICachedEntityFactory<Type, Entity> factory, Context cx, Type init)
            where Entity : ICachedEntity => cx.CreateEntity2(factory, init);

        public static void DefineLabel(this IEntity entity, TextWriter trapFile, IExtractor extractor)
        {
            trapFile.WriteLabel(entity);
            trapFile.Write("=");
            try
            {
                entity.WriteQuotedId(trapFile);
            }
            catch(Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                trapFile.WriteLine("\"");
                extractor.Message(new Message("Unhandled exception generating id", entity.ToString() ?? "", null, ex.StackTrace));
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
            using (var writer = new StringWriter())
            {
                writer.WriteLabel(entity.Label.Value);
                writer.Write('=');
                entity.WriteQuotedId(writer);
                return writer.ToString();
            }
        }

    }
}
