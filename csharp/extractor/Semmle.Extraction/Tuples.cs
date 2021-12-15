using Semmle.Extraction.Entities;
using Semmle.Util;

namespace Semmle.Extraction
{
    /// <summary>
    /// Methods for creating DB tuples.
    /// </summary>
    public static class Tuples
    {
        public static void containerparent(this System.IO.TextWriter trapFile, Folder parent, IEntity child)
        {
            trapFile.WriteTuple("containerparent", parent, child);
        }

        internal static void extractor_messages(this System.IO.TextWriter trapFile, ExtractionMessage error, Semmle.Util.Logging.Severity severity, string origin, string errorMessage, string entityText, Location location, string stackTrace)
        {
            trapFile.WriteTuple("extractor_messages", error, (int)severity, origin, errorMessage, entityText, location, stackTrace);
        }

        public static void files(this System.IO.TextWriter trapFile, File file, string fullName)
        {
            trapFile.WriteTuple("files", file, fullName);
        }

        internal static void folders(this System.IO.TextWriter trapFile, Folder folder, string path)
        {
            trapFile.WriteTuple("folders", folder, path);
        }

        public static void locations_default(this System.IO.TextWriter trapFile, SourceLocation label, Entities.File file, int startLine, int startCol, int endLine, int endCol)
        {
            trapFile.WriteTuple("locations_default", label, file, startLine, startCol, endLine, endCol);
        }
    }
}
