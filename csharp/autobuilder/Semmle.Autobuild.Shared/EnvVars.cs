using Semmle.Util;

namespace Semmle.Autobuild.Shared
{
    public static class EnvVars
    {
        public const string Platform = "CODEQL_PLATFORM";
        public static string Root(Language language) => $"CODEQL_EXTRACTOR_{language.UpperCaseName}_ROOT";
        public static string TrapDir(Language language) => $"CODEQL_EXTRACTOR_{language.UpperCaseName}_TRAP_DIR";
        public static string SourceArchiveDir(Language language) => $"CODEQL_EXTRACTOR_{language.UpperCaseName}_SOURCE_ARCHIVE_DIR";
        public static string DiagnosticDir(Language language) => $"CODEQL_EXTRACTOR_{language.UpperCaseName}_DIAGNOSTIC_DIR";
    }
}
