using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;

namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// A reader of PDB information using System.Reflection.Metadata.
    /// This is cross platform, and the future of PDB.
    ///
    /// PDB information can be in a separate PDB file, or embedded in the DLL.
    /// </summary>
    internal sealed class MetadataPdbReader : IPdb
    {
        private class SourceFile : ISourceFile
        {
            public SourceFile(MetadataReader reader, DocumentHandle handle)
            {
                var doc = reader.GetDocument(handle);
                Path = reader.GetString(doc.Name);
            }

            public string Path { get; private set; }

            public string? Contents => File.Exists(Path) ? File.ReadAllText(Path, System.Text.Encoding.Default) : null;
        }

        // Turns out to be very important to keep the MetadataReaderProvider live
        // or the reader will crash.
        private readonly MetadataReaderProvider provider;
        private readonly MetadataReader reader;

        public MetadataPdbReader(MetadataReaderProvider provider)
        {
            this.provider = provider;
            reader = provider.GetMetadataReader();
        }

        public IEnumerable<ISourceFile> SourceFiles => reader.Documents.Select(handle => new SourceFile(reader, handle));

        public Method? GetMethod(MethodDebugInformationHandle handle)
        {
            var debugInfo = reader.GetMethodDebugInformation(handle);

            var sequencePoints = debugInfo.GetSequencePoints()
                .Where(p => !p.Document.IsNil && !p.IsHidden)
                .Select(p => new SequencePoint(p.Offset, new Location(
                    new SourceFile(reader, p.Document), p.StartLine, p.StartColumn, p.EndLine, p.EndColumn)))
                .Where(p => p.Location.File.Path is not null)
                .ToArray();

            return sequencePoints.Any() ? new Method(sequencePoints) : null;
        }

        public static MetadataPdbReader? CreateFromAssembly(string assemblyPath, PEReader peReader)
        {
            var provider = peReader
                .ReadDebugDirectory()
                .Where(d => d.Type == DebugDirectoryEntryType.EmbeddedPortablePdb)
                .Select(dirEntry => peReader.ReadEmbeddedPortablePdbDebugDirectoryData(dirEntry))
                .FirstOrDefault();

            if (provider is not null)
            {
                return new MetadataPdbReader(provider);
            }

            try
            {
                if (peReader.TryOpenAssociatedPortablePdb(
                    assemblyPath,
                    s => new FileStream(s, FileMode.Open, FileAccess.Read, FileShare.Read),
                    out provider,
                    out _))
                {
                    return new MetadataPdbReader(provider!);
                }
            }

            catch (BadImageFormatException)
            {
                // Something is wrong with the file.
            }
            catch (FileNotFoundException)
            {
                // The PDB file was not found.
            }
            return null;
        }

        public void Dispose()
        {
            provider.Dispose();
        }
    }
}
