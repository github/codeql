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

        public static void locations_mapped(this System.IO.TextWriter trapFile, SourceLocation l1, Location l2)
        {
            trapFile.WriteTuple("locations_mapped", l1, l2);
        }
    }
}
