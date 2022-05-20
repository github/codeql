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

        public override void Populate(TextWriter trapFile)
        {
            trapFile.files(this, TransformedPath.Value);

            if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
                trapFile.containerparent(Extraction.Entities.Folder.Create(Context, dir), this);

            var trees = Context.Compilation.SyntaxTrees.Where(t => t.FilePath == originalPath);

            if (trees.Any())
            {
                foreach (var text in trees.Select(tree => tree.GetText()))
                {
                    var rawText = text.ToString() ?? "";
                    var lineCounts = LineCounter.ComputeLineCounts(rawText);
                    if (rawText.Length > 0 && rawText[rawText.Length - 1] != '\n')
                        lineCounts.Total++;

                    trapFile.numlines(this, lineCounts);
                    Context.TrapWriter.Archive(originalPath, TransformedPath, text.Encoding ?? System.Text.Encoding.Default);
                }
            }
            else if (IsPossiblyTextFile())
            {
                try
                {
                    System.Text.Encoding encoding;
                    var lineCount = 0;
                    using (var sr = new StreamReader(originalPath, detectEncodingFromByteOrderMarks: true))
                    {
                        while (sr.ReadLine() is not null)
                        {
                            lineCount++;
                        }
                        encoding = sr.CurrentEncoding;
                    }

                    trapFile.numlines(this, new LineCounts() { Total = lineCount, Code = 0, Comment = 0 });
                    Context.TrapWriter.Archive(originalPath, TransformedPath, encoding ?? System.Text.Encoding.Default);
                }
                catch (Exception exc)
                {
                    Context.ExtractionError($"Couldn't read file: {originalPath}. {exc.Message}", null, null, exc.StackTrace);
                }
            }

            trapFile.file_extraction_mode(this, Context.Extractor.Mode);
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
