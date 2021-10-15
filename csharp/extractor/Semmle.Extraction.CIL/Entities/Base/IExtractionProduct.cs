namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// Something that is extracted from an entity.
    /// </summary>
    ///
    /// <remarks>
    /// The extraction algorithm proceeds as follows:
    /// - Construct entity
    /// - Call Extract()
    /// - IExtractedEntity check if already extracted
    /// - Enumerate Contents to produce more extraction products
    /// - Extract these until there is nothing left to extract
    /// </remarks>
    internal interface IExtractionProduct
    {
        /// <summary>
        /// Perform further extraction/population of this item as necessary.
        /// </summary>
        ///
        /// <param name="cx">The extraction context.</param>
        void Extract(Context cx);
    }
}
