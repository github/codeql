using Semmle.Extraction.Entities;
using Semmle.Util;

namespace Semmle.Extraction
{
    /// <summary>
    /// Methods for creating DB tuples.
    /// </summary>
    static class Tuples
    {
        public static void assemblies(this TrapWriter writer, Assembly assembly, File file, string identifier, string name, string version)
        {
            writer.Writer.BeginTuple("assemblies").Param(assembly).Param(file).Param(identifier).Param(name).Param(version).EndTuple();
        }

        public static void containerparent(this TrapWriter writer, Folder parent, IEntity child)
        {
            writer.Writer.BeginTuple("containerparent").Param(parent).Param(child).EndTuple();
        }

        public static void extractor_messages(this TrapWriter writer, ExtractionMessage error, Semmle.Util.Logging.Severity severity, string origin, string errorMessage, string entityText, Location location, string stackTrace)
        {
            writer.Writer.BeginTuple("extractor_messages").Param(error).Param((int)severity).Param(origin).Param(errorMessage).Param(entityText).Param(location).Param(stackTrace).EndTuple();
        }

        internal static void file_extraction_mode(this TrapWriter writer, Entities.File file, int mode)
        {
            writer.Writer.BeginTuple("file_extraction_mode").Param(file).Param(mode).EndTuple();
        }

        public static void files(this TrapWriter writer, Entities.File file, string fullName, string name, string extension)
        {
            writer.Writer.BeginTuple("files").Param(file).Param(fullName).Param(name).Param(extension).Param(0).EndTuple();
        }

        public static void folders(this TrapWriter writer, Folder folder, string path, string name)
        {
            writer.Writer.BeginTuple("folders").Param(folder).Param(path).Param(name).EndTuple();
        }

        public static void locations_default(this TrapWriter writer, SourceLocation label, Entities.File file, int startLine, int startCol, int endLine, int endCol)
        {
            writer.Writer.BeginTuple("locations_default").Param(label).Param(file).Param(startLine).Param(startCol).Param(endLine).Param(endCol).EndTuple();
        }

        public static void numlines(this TrapWriter writer, IEntity label, LineCounts lineCounts)
        {
            writer.Writer.BeginTuple("numlines").Param(label).Param(lineCounts.Total).Param(lineCounts.Code).Param(lineCounts.Comment).EndTuple();
        }
    }
}
