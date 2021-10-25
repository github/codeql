using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// Any program entity which has a corresponding label in the trap file.
    ///
    /// Entities are divided into two types: normal entities and cached
    /// entities.
    ///
    /// Normal entities implement <see cref="FreshEntity"/> directly, and they
    /// (may) emit contents to the trap file during object construction.
    ///
    /// Cached entities implement <see cref="CachedEntity"/>, and they
    /// emit contents to the trap file when <see cref="CachedEntity.Populate"/>
    /// is called. Caching prevents <see cref="CachedEntity.Populate"/>
    /// from being called on entities that have already been emitted.
    /// </summary>
    public interface IEntity
    {
        /// <summary>
        /// The label of the entity, as it is in the trap file.
        /// For example, "#123".
        /// </summary>
        Label Label { get; set; }

        /// <summary>
        /// Writes the unique identifier of this entitiy to a trap file.
        /// </summary>
        /// <param name="trapFile">The trapfile to write to.</param>
        void WriteId(EscapingTextWriter trapFile);

        /// <summary>
        /// Writes the quoted identifier of this entity,
        /// which could be @"..." or *
        /// </summary>
        /// <param name="trapFile">The trapfile to write to.</param>
        void WriteQuotedId(EscapingTextWriter trapFile);

        /// <summary>
        /// The location for reporting purposes.
        /// </summary>
        Location? ReportingLocation { get; }

        /// <summary>
        /// How the entity handles .push and .pop.
        /// </summary>
        TrapStackBehaviour TrapStackBehaviour { get; }

        void DefineLabel(TextWriter trapFile, Extractor extractor);
    }
}
