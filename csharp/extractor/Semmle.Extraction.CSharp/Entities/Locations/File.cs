using System;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    public class File : CachedEntity<string>
    {
        protected readonly string originalPath;
        private readonly Lazy<PathTransformer.ITransformedPath> transformedPathLazy;
        protected PathTransformer.ITransformedPath TransformedPath => transformedPathLazy.Value;
        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        public override bool NeedsPopulation => true;

        protected File(Context cx, string path)
            : base(cx, path)
        {
            originalPath = path;
            var adjustedPath = BinaryLogExtractionContext.GetAdjustedPath(Context.ExtractionContext, originalPath) ?? path;
            transformedPathLazy = new Lazy<PathTransformer.ITransformedPath>(() => Context.ExtractionContext.PathTransformer.Transform(adjustedPath));
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
            trapFile.Write(";sourcefile");
        }


        public override void Populate(TextWriter trapFile)
        {
            trapFile.files(this, TransformedPath.Value);

            if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
                trapFile.containerparent(Folder.Create(Context, dir), this);

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
                    if (BinaryLogExtractionContext.GetAdjustedPath(Context.ExtractionContext, originalPath) is not null)
                    {
                        Context.TrapWriter.ArchiveContent(rawText, TransformedPath);
                    }
                    else
                    {
                        Context.TrapWriter.Archive(originalPath, TransformedPath, text.Encoding ?? System.Text.Encoding.Default);
                    }
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
                    Context.ExtractionError($"Couldn't read file: {originalPath}. {exc.Message}", null, null, exc.StackTrace, Semmle.Util.Logging.Severity.Warning);
                }
            }

            trapFile.file_extraction_mode(this, Context.ExtractionContext.Mode);
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
