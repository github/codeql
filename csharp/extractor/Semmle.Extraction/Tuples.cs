using Semmle.Extraction.Entities;
using Semmle.Util;

namespace Semmle.Extraction
{
    /// <summary>
    /// Methods for creating DB tuples.
    /// </summary>
    static class Tuples
    {
        public static void assemblies(this System.IO.TextWriter trapFile, Assembly assembly, File file, string identifier, string name, string version)
        {
            trapFile.BeginTuple("assemblies").Param(assembly).Param(file).Param(identifier).Param(name).Param(version).EndTuple();
        }

        public static void containerparent(this System.IO.TextWriter trapFile, Folder parent, IEntity child)
        {
            trapFile.BeginTuple("containerparent").Param(parent).Param(child).EndTuple();
        }

        public static void extractor_messages(this System.IO.TextWriter trapFile, ExtractionMessage error, Semmle.Util.Logging.Severity severity, string origin, string errorMessage, string entityText, Location location, string stackTrace)
        {
            trapFile.BeginTuple("extractor_messages").Param(error).Param((int)severity).Param(origin).Param(errorMessage).Param(entityText).Param(location).Param(stackTrace).EndTuple();
        }

        internal static void file_extraction_mode(this System.IO.TextWriter trapFile, Entities.File file, int mode)
        {
            trapFile.BeginTuple("file_extraction_mode").Param(file).Param(mode).EndTuple();
        }

        public static void files(this System.IO.TextWriter trapFile, File file, string fullName, string name, string extension)
        {
            trapFile.BeginTuple("files").Param(file).Param(fullName).Param(name).Param(extension).Param(0).EndTuple();
        }

        public static void folders(this System.IO.TextWriter trapFile, Folder folder, string path, string name)
        {
            trapFile.BeginTuple("folders").Param(folder).Param(path).Param(name).EndTuple();
        }

        public static void locations_default(this System.IO.TextWriter trapFile, SourceLocation label, Entities.File file, int startLine, int startCol, int endLine, int endCol)
        {
            trapFile.BeginTuple("locations_default").Param(label).Param(file).Param(startLine).Param(startCol).Param(endLine).Param(endCol).EndTuple();
        }

        public static void numlines(this System.IO.TextWriter trapFile, IEntity label, LineCounts lineCounts)
        {
            trapFile.BeginTuple("numlines").Param(label).Param(lineCounts.Total).Param(lineCounts.Code).Param(lineCounts.Comment).EndTuple();
        }
    }
}
