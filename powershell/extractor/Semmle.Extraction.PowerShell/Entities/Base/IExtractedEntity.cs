using System.Collections.Generic;

namespace Semmle.Extraction.PowerShell.Entities
{
    /// <summary>
    /// An entity which has been extracted.
    /// </summary>
    internal interface IExtractedEntity : IExtractionProduct, IEntity
    {
        /// <summary>
        /// The contents of the entity.
        /// </summary>

        IEnumerable<IExtractionProduct> Contents { get; }
    }
}
