namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// A source file reference in a PDB file.
    /// </summary>
    public interface ISourceFile
    {
        string Path { get; }

        /// <summary>
        /// The contents of the file.
        /// This property is needed in case the contents
        /// of the file are embedded in the PDB instead of being on the filesystem.
        ///
        /// null if the contents are unavailable.
        /// E.g. if the PDB file exists but the corresponding source files are missing.
        /// </summary>
        string? Contents { get; }
    }
}
