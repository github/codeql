using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.PortableExecutable;
using Microsoft.DiaSymReader;
using System.Reflection.Metadata.Ecma335;
using System.Reflection.Metadata;
using System.IO;

namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// A PDB reader using Microsoft.DiaSymReader.Native.
    /// This is an unmanaged Windows DLL, which therefore only works on Windows.
    /// </summary>
    internal sealed class NativePdbReader : IPdb
    {
        private sealed class Document : ISourceFile
        {
            private readonly ISymUnmanagedDocument document;

            public Document(ISymUnmanagedDocument doc)
            {
                document = doc;
                contents = new Lazy<string?>(() =>
                {
                    if (document.HasEmbeddedSource(out var isEmbedded) == 0 && isEmbedded)
                    {
                        var rawContents = document.GetEmbeddedSource().ToArray();
                        return System.Text.Encoding.Default.GetString(rawContents);
                    }

                    return File.Exists(Path)
                        ? File.ReadAllText(Path)
                        : null;

                });
            }

            public override bool Equals(object? obj)
            {
                return obj is Document otherDoc && Path.Equals(otherDoc.Path);
            }

            public override int GetHashCode() => Path.GetHashCode();

            public string Path => document.GetName();

            public override string ToString() => Path;

            private readonly Lazy<string?> contents;

            public string? Contents => contents.Value;
        }

        public IEnumerable<ISourceFile> SourceFiles => reader.GetDocuments().Select(d => new Document(d));

        public Method? GetMethod(MethodDebugInformationHandle h)
        {
            var methodToken = MetadataTokens.GetToken(h.ToDefinitionHandle());
            var method = reader.GetMethod(methodToken);
            if (method is not null)
            {
                if (method.GetSequencePointCount(out var count) != 0 || count == 0)
                    return null;

                var s = method.GetSequencePoints()
                    .Where(sp => !sp.IsHidden)
                    .Select(sp => new SequencePoint(sp.Offset, new Location(
                        new Document(sp.Document), sp.StartLine, sp.StartColumn, sp.EndLine, sp.EndColumn)))
                    .ToArray();

                return s.Any() ? new Method(s) : null;
            }
            return null;
        }

        private NativePdbReader(string path)
        {
            pdbStream = new FileStream(path, FileMode.Open);
            var metadataProvider = new MdProvider();
            reader = SymUnmanagedReaderFactory.CreateReader<ISymUnmanagedReader5>(pdbStream, metadataProvider);
        }

        private readonly ISymUnmanagedReader5 reader;
        private readonly FileStream pdbStream;

        public static NativePdbReader? CreateFromAssembly(PEReader peReader)
        {
            // The Native PDB reader uses an unmanaged Windows DLL
            // so only works on Windows.
            if (!Semmle.Util.Win32.IsWindows())
                return null;

            var debugDirectory = peReader.ReadDebugDirectory();

            var path = debugDirectory
                .Where(d => d.Type == DebugDirectoryEntryType.CodeView)
                .Select(peReader.ReadCodeViewDebugDirectoryData)
                .Select(cv => cv.Path)
                .FirstOrDefault(File.Exists);

            if (path is not null)
            {
                return new NativePdbReader(path);
            }

            return null;
        }

        public void Dispose()
        {
            pdbStream.Dispose();
        }
    }
}
