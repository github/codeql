using System.Reflection.PortableExecutable;

namespace Semmle.Extraction.PDB
{
    internal static class PdbReader
    {
        /// <summary>
        /// Returns the PDB information associated with an assembly.
        /// </summary>
        /// <param name="assemblyPath">The path to the assembly.</param>
        /// <param name="peReader">The PE reader for the assembly.</param>
        /// <returns>A PdbReader, or null if no PDB information is available.</returns>
        public static IPdb? Create(string assemblyPath, PEReader peReader)
        {
            return (IPdb?)MetadataPdbReader.CreateFromAssembly(assemblyPath, peReader) ??
                NativePdbReader.CreateFromAssembly(peReader);
        }
    }
}
