using System;
using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// A cached entity where population shall be postponed to a shared
    /// TRAP file. This allows for entities to not be dupliciated across
    /// multiple TRAP files.
    /// </summary>
    public abstract class CachedEntityShared<TSymbol> : CachedEntity<TSymbol> where TSymbol : notnull
    {
        protected CachedEntityShared(Context context, TSymbol symbol) : base(context, symbol)
        {
        }
    }
}
