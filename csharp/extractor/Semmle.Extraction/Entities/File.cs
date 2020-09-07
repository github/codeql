using Semmle.Util;
using System;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.Entities
{
    public class File : CachedEntity<string>
    {
        File(Context cx, string path)
            : base(cx, path)
        {
            OriginalPath = path;
            TransformedPath = Context.Extractor.PathTransformer.Transform(OriginalPath);
        }

        readonly string OriginalPath;
        readonly PathTransformer.ITransformedPath TransformedPath;

        public override bool NeedsPopulation => Context.DefinesFile(OriginalPath) || OriginalPath == Context.Extractor.OutputPath;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.files(this, TransformedPath.Value, TransformedPath.NameWithoutExtension, TransformedPath.Extension);

            if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
                trapFile.containerparent(Folder.Create(Context, dir), this);

            var fromSource = TransformedPath.Extension.ToLowerInvariant().Equals("cs");
            if (fromSource)
            {
                foreach (var text in Context.Compilation.SyntaxTrees.
                    Where(t => t.FilePath == OriginalPath).
                    Select(tree => tree.GetText()))
                {
                    var rawText = text.ToString() ?? "";
                    var lineCounts = LineCounter.ComputeLineCounts(rawText);
                    if (rawText.Length > 0 && rawText[rawText.Length - 1] != '\n') lineCounts.Total++;

                    trapFile.numlines(this, lineCounts);
                    Context.TrapWriter.Archive(OriginalPath, TransformedPath, text.Encoding ?? System.Text.Encoding.Default);
                }
            }

            trapFile.file_extraction_mode(this, Context.Extractor.Standalone ? 1 : 0);
        }

        public override void WriteId(System.IO.TextWriter trapFile)
        {
            trapFile.Write(TransformedPath.DatabaseId);
            trapFile.Write(";sourcefile");
        }

        public static File Create(Context cx, string path) => FileFactory.Instance.CreateEntity(cx, path);

        public static File CreateGenerated(Context cx) => GeneratedFile.Create(cx);

        class GeneratedFile : File
        {
            GeneratedFile(Context cx) : base(cx, "") { }

            public override bool NeedsPopulation => true;

            public override void Populate(TextWriter trapFile)
            {
                trapFile.files(this, "", "", "");
            }

            public override void WriteId(TextWriter trapFile)
            {
                trapFile.Write("GENERATED;sourcefile");
            }

            public static GeneratedFile Create(Context cx) =>
                GeneratedFileFactory.Instance.CreateNullableEntity(cx, null);

            class GeneratedFileFactory : ICachedEntityFactory<string?, GeneratedFile>
            {
                public static readonly GeneratedFileFactory Instance = new GeneratedFileFactory();

                public GeneratedFile Create(Context cx, string? init) => new GeneratedFile(cx);
            }
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

        class FileFactory : ICachedEntityFactory<string, File>
        {
            public static readonly FileFactory Instance = new FileFactory();

            public File Create(Context cx, string init) => new File(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
