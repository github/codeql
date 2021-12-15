using System;
using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// A cached entity that is shared across a compilation, and which will
    /// be put into a dedicated, shared TRAP file.
    ///
    /// Current examples are files and folders.
    ///
    /// Shared entities are populated after all other entities have been populated.
    /// </summary>
    public interface ICachedEntityShared : IEntity
    {
        /// <summary>
        /// Define the label of this entity for use in the shared TRAP file.
        ///
        /// Unlike `DefineLabel`, this method is invoked when populating the shared
        /// TRAP file.
        ///
        /// Since the TRAP file is shared, we cannot access it directly, but instead
        /// via a callback that ensures appropriate locking.
        /// </summary>
        void DefineLabelShared(Action<Action<TextWriter>> withTrapFile, Extractor extractor);

        /// <summary>
        /// Populate this entity in the shared TRAP file.
        ///
        /// Unlike `Populate`, this method is invoked when populating the shared
        /// TRAP file.
        ///
        /// Since the TRAP file is shared, we cannot access it directly, but instead
        /// via a callback that ensures appropriate locking.
        /// </summary>
        void PopulateShared(Action<Action<TextWriter>> withTrapFile);
    }

    public abstract class CachedEntityShared<TSymbol> : CachedEntity<TSymbol>, ICachedEntityShared where TSymbol : notnull
    {
        protected CachedEntityShared(Context context, TSymbol symbol) : base(context, symbol)
        {
        }

        public sealed override void Populate(TextWriter trapFile)
        {
            // Register the entity for later population in the shared TRAP file
            Context.RegisterSharedEntity(this);
        }

        void ICachedEntityShared.DefineLabelShared(Action<Action<TextWriter>> withTrapFile, Extractor extractor)
        {
            withTrapFile(trapFile => base.DefineLabel(trapFile, extractor));
        }

        public abstract void PopulateShared(Action<Action<TextWriter>> withTrapFile);
    }
}
