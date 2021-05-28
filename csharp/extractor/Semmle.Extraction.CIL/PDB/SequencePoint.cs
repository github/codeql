namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// A sequencepoint is a marker in the source code where you can put a breakpoint, and
    /// maps instructions to source code.
    /// </summary>
    public struct SequencePoint
    {
        /// <summary>
        /// The byte-offset of the instruction.
        /// </summary>
        public int Offset { get; }

        /// <summary>
        /// The source location of the instruction.
        /// </summary>
        public Location Location { get; }

        public override string ToString()
        {
            return string.Format("{0} = {1}", Offset, Location);
        }

        public SequencePoint(int offset, Location location)
        {
            Offset = offset;
            Location = location;
        }
    }
}
