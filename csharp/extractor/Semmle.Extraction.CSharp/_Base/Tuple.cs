using System.IO;

namespace Semmle.Extraction
{
    /// <summary>
    /// A tuple represents a string of the form "a(b,c,d)".
    /// </summary>
    public struct Tuple : ITrapEmitter
    {
        private readonly string name;
        private readonly object[] args;

        public Tuple(string name, params object[] args)
        {
            this.name = name;
            this.args = args;
        }

        /// <summary>
        /// Constructs a unique string for this tuple.
        /// </summary>
        /// <param name="trapFile">The trap file to write to.</param>
        public void EmitTrap(TextWriter trapFile)
        {
            trapFile.WriteTuple(name, args);
        }

        public override string ToString()
        {
            // Only implemented for debugging purposes
            using var writer = new StringWriter();
            EmitTrap(writer);
            return writer.ToString();
        }
    }
}
