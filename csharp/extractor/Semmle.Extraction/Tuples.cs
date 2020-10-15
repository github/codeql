using Semmle.Extraction.Entities;
using Semmle.Util;

namespace Semmle.Extraction
{
    /// <summary>
    /// Methods for creating DB tuples.
    /// </summary>
    internal static class Tuples
    {
        public static void assemblies(this System.IO.TextWriter trapFile, Assembly assembly, File file, string identifier, string name, string version)
        {
            trapFile.WriteTuple("assemblies", assembly, file, identifier, name, version);
        }

        public static void containerparent(this System.IO.TextWriter trapFile, Folder parent, IEntity child)
        {
            trapFile.WriteTuple("containerparent", parent, child);
        }

        public static void extractor_messages(this System.IO.TextWriter trapFile, ExtractionMessage error, Semmle.Util.Logging.Severity severity, string origin, string errorMessage, string entityText, Location location, string stackTrace)
        {
            trapFile.WriteTuple("extractor_messages", error, (int)severity, origin, errorMessage, entityText, location, stackTrace);
        }

        internal static void file_extraction_mode(this System.IO.TextWriter trapFile, Entities.File file, int mode)
        {
            trapFile.WriteTuple("file_extraction_mode", file, mode);
        }

        public static void files(this System.IO.TextWriter trapFile, File file, string fullName, string name, string extension)
        {
            trapFile.WriteTuple("files", file, fullName, name, extension, 0);
        }

        public static void folders(this System.IO.TextWriter trapFile, Folder folder, string path, string name)
        {
            trapFile.WriteTuple("folders", folder, path, name);
        }

        public static void locations_default(this System.IO.TextWriter trapFile, SourceLocation label, Entities.File file, int startLine, int startCol, int endLine, int endCol)
        {
            trapFile.WriteTuple("locations_default", label, file, startLine, startCol, endLine, endCol);
        }

        public static void numlines(this System.IO.TextWriter trapFile, IEntity label, LineCounts lineCounts)
        {
            trapFile.WriteTuple("numlines", label, lineCounts.Total, lineCounts.Code, lineCounts.Comment);
        }
    }
}
