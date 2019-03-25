using Semmle.Extraction.Entities;
using Semmle.Util;

namespace Semmle.Extraction
{
    /// <summary>
    /// Methods for creating DB tuples.
    /// </summary>
    static class Tuples
    {
        internal static Tuple assemblies(Assembly assembly, File file, string identifier, string name, string version) =>
            new Tuple("assemblies", assembly, file, identifier, name, version);

        internal static Tuple containerparent(Folder parent, IEntity child) =>
            new Tuple("containerparent", parent, child);

        internal static Tuple extraction_messages(ExtractionMessage error, Semmle.Util.Logging.Severity severity, string origin, string errorMessage, string entityText, Location location, string stackTrace) =>
            new Tuple("extraction_messages", error, severity, origin, errorMessage, entityText, location, stackTrace);

        internal static Tuple file_extraction_mode(File file, int mode) =>
            new Tuple("file_extraction_mode", file, mode);

        internal static Tuple files(File file, string fullName, string name, string extension) =>
            new Tuple("files", file, fullName, name, extension, 0);

        internal static Tuple folders(Folder folder, string path, string name) =>
            new Tuple("folders", folder, path, name);

        internal static Tuple locations_default(SourceLocation label, File file, int startLine, int startCol, int endLine, int endCol) =>
            new Tuple("locations_default", label, file, startLine, startCol, endLine, endCol);

        internal static Tuple numlines(IEntity label, LineCounts lineCounts) =>
            new Tuple("numlines", label, lineCounts.Total, lineCounts.Code, lineCounts.Comment);
    }
}
