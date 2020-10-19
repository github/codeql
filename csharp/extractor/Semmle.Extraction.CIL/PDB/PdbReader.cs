using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;

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

    public interface IMethod
    {
        IEnumerable<SequencePoint> SequencePoints { get; }
        Location Location { get; }
    }

    internal class Method : IMethod
    {
        public IEnumerable<SequencePoint> SequencePoints { get; }

        public Method(IEnumerable<SequencePoint> sequencePoints)
        {
            SequencePoints = sequencePoints;
        }

        public Location Location => SequencePoints.First().Location;
    }

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
        IMethod? GetMethod(MethodDebugInformationHandle methodHandle);
    }

    internal class PdbReader
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
