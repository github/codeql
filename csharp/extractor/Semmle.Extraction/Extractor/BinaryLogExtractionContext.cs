using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public class BinaryLogExtractionContext : ExtractionContext
    {
        private readonly IEnumerable<SyntaxTree> generatedSyntaxTrees;
        private readonly string compilationIdentifier;
        private readonly string generatedFolderName;

        public BinaryLogExtractionContext(string cwd, string[] args, string outputPath,
            IEnumerable<SyntaxTree> generatedSyntaxTrees, string compilationIdentifier,
            ILogger logger, PathTransformer pathTransformer, bool isQlTest)
            : base(cwd, args, outputPath, [], logger, pathTransformer, ExtractorMode.BinaryLog, isQlTest)
        {
            this.generatedSyntaxTrees = generatedSyntaxTrees;
            this.compilationIdentifier = compilationIdentifier;

            // Compute a unique folder name for the generated files:
            generatedFolderName = "generated";

            if (Directory.Exists(generatedFolderName))
            {
                var counter = 0;
                do
                {
                    generatedFolderName = $"generated{counter++}";
                }
                while (Directory.Exists(generatedFolderName));
            }
        }

        private string? GetAdjustedPath(string path)
        {
            var syntaxTree = generatedSyntaxTrees.FirstOrDefault(t => t.FilePath == path);
            if (syntaxTree is null)
            {
                return null;
            }

            return Path.Join(generatedFolderName, compilationIdentifier, path);
        }

        public static string? GetAdjustedPath(ExtractionContext extractionContext, string sourcePath)
        {
            if (extractionContext.Mode.HasFlag(ExtractorMode.BinaryLog)
                && extractionContext is BinaryLogExtractionContext binaryLogExtractionContext
                && binaryLogExtractionContext.GetAdjustedPath(sourcePath) is string adjustedPath)
            {
                return adjustedPath;
            }

            return null;
        }
    }
}
