namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// A location in source code.
    /// </summary>
    public sealed class Location
    {
        /// <summary>
        /// The file containing the code.
        /// </summary>
        public ISourceFile File { get; }

        /// <summary>
        /// The start line of text within the source file.
        /// </summary>
        public int StartLine { get; }

        /// <summary>
        /// The start column of text within the source file.
        /// </summary>
        public int StartColumn { get; }

        /// <summary>
        /// The end line of text within the source file.
        /// </summary>
        public int EndLine { get; }

        /// <summary>
        /// The end column of text within the source file.
        /// </summary>
        public int EndColumn { get; }

        public override string ToString()
        {
            return string.Format("({0},{1})-({2},{3})", StartLine, StartColumn, EndLine, EndColumn);
        }

        public override bool Equals(object? obj)
        {
            return obj is Location otherLocation &&
                File.Equals(otherLocation.File) &&
                StartLine == otherLocation.StartLine &&
                StartColumn == otherLocation.StartColumn &&
                EndLine == otherLocation.EndLine &&
                EndColumn == otherLocation.EndColumn;
        }

        public override int GetHashCode()
        {
            var h1 = StartLine + 37 * (StartColumn + 51 * (EndLine + 97 * EndColumn));
            return File.GetHashCode() + 17 * h1;
        }

        public Location(ISourceFile file, int startLine, int startCol, int endLine, int endCol)
        {
            File = file;
            StartLine = startLine;
            StartColumn = startCol;
            EndLine = endLine;
            EndColumn = endCol;
        }
    }
}
