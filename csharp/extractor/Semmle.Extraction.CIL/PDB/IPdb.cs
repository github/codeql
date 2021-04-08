using System;
using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// Wrapper for reading PDB files.
    /// This is needed because there are different libraries for dealing with
    /// different types of PDB file, even though they share the same file extension.
    /// </summary>
    public interface IPdb : IDisposable
    {
        /// <summary>
        /// Gets all source files in this PDB.
        /// </summary>
        IEnumerable<ISourceFile> SourceFiles { get; }

        /// <summary>
        /// Look up a method from a given handle.
        /// </summary>
        /// <param name="methodHandle">The handle to query.</param>
        /// <returns>The method information, or null if the method does not have debug information.</returns>
        Method? GetMethod(MethodDebugInformationHandle methodHandle);
    }
}
