using System.Collections.Generic;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A CIL instruction.
    /// </summary>
    internal interface IInstruction : IExtractedEntity
    {
        /// <summary>
        /// Gets the extraction products for branches.
        /// </summary>
        /// <param name="jump_table">The map from offset to instruction.</param>
        /// <returns>The extraction products.</returns>
        IEnumerable<IExtractionProduct> JumpContents(Dictionary<int, IInstruction> jump_table);
    }
}
