using Microsoft.CodeAnalysis;
using Semmle.Util;
using System;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class File : Extraction.Entities.File
    {
        public override Context Context => (Context)base.Context;

        protected File(Context cx, string path)
            : base(cx, path)
        {
        }

        public sealed override void Populate(TextWriter trapFile)
        {
            Extraction.Entities.Folder? parent = null;
            LineCounts? lineCounts = null;
            System.Text.Encoding? encoding = null;

            if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
                parent = Extraction.Entities.Folder.Create(Context, dir);

            var trees = Context.Compilation.SyntaxTrees.Where(t => t.FilePath == originalPath);

            if (trees.Any())
            {
                foreach (var text in trees.Select(tree => tree.GetText()))
                {
                    var rawText = text.ToString() ?? "";
                    lineCounts = LineCounter.ComputeLineCounts(rawText);
                    if (rawText.Length > 0 && rawText[rawText.Length - 1] != '\n')
                        lineCounts.Total++;
                    encoding = text.Encoding;
                }
            }
            else if (IsPossiblyTextFile())
            {
                try
                {
                    var lineCount = 0;
                    using (var sr = new StreamReader(originalPath, detectEncodingFromByteOrderMarks: true))
                    {
                        while (sr.ReadLine() is not null)
                        {
                            lineCount++;
                        }
                        encoding = sr.CurrentEncoding;
                    }
                    lineCounts = new LineCounts() { Total = lineCount, Code = 0, Comment = 0 };
                }
                catch (Exception exc)
                {
                    Context.ExtractionError($"Couldn't read file: {originalPath}. {exc.Message}", null, null, exc.StackTrace);
                }
            }
            
            // Register the entity for later population in the shared TRAP file
            Context.RegisterSharedEntity(new Shared(originalPath, TransformedPath, parent, lineCounts, encoding));
        }

        private sealed class Shared : EntityShared
        {
            private readonly string originalPath;
            private readonly PathTransformer.ITransformedPath path;
            private readonly Extraction.Entities.Folder? parent;
            private readonly LineCounts? lineCounts;
            private readonly System.Text.Encoding encoding;

            public Shared(string originalPath, PathTransformer.ITransformedPath path, Extraction.Entities.Folder? parent, LineCounts? lineCounts, System.Text.Encoding? encoding)
            {
                this.originalPath = originalPath;
                this.path = path;
                this.parent = parent;
                this.lineCounts = lineCounts;
                this.encoding = encoding ?? System.Text.Encoding.Default;
            }

            public sealed override void PopulateShared(ContextShared cx)
            {
                cx.WithTrapFile(trapFile => trapFile.files(this, path.Value));

                if (parent is not null)
                    cx.WithTrapFile(trapFile => trapFile.containerparent(parent, this));

                if (lineCounts is not null)
                {
                    cx.WithTrapFile(trapFile => trapFile.numlines(this, lineCounts));
                    cx.Archive(originalPath, path, encoding);
                }

                cx.WithTrapFile(trapFile => trapFile.file_extraction_mode(this, cx.Extractor.Standalone ? 1 : 0));
            }

            public override void WriteId(EscapingTextWriter trapFile)
            {
                trapFile.Write(path.DatabaseId);
                trapFile.Write(";sourcefile");
            }

            public sealed override int GetHashCode() => 19 * path.DatabaseId.GetHashCode();

            public sealed override bool Equals(object? obj) =>
                obj is Shared s && path.DatabaseId == s.path.DatabaseId;
        }

        private bool IsPossiblyTextFile()
        {
            var extension = TransformedPath.Extension.ToLowerInvariant();
            return !extension.Equals("dll") && !extension.Equals("exe");
        }

        public static File Create(Context cx, string path) => FileFactory.Instance.CreateEntity(cx, (typeof(File), path), path);

        private class FileFactory : CachedEntityFactory<string, File>
        {
            public static FileFactory Instance { get; } = new FileFactory();

            public override File Create(Context cx, string init) => new File(cx, init);
        }
    }
}
