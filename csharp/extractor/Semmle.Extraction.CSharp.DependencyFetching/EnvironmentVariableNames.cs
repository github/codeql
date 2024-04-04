namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class EnvironmentVariableNames
    {
        /// <summary>
        /// Controls whether to generate source files from Asp.Net Core views (`.cshtml`, `.razor`).
        /// </summary>
        public const string WebViewGeneration = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_EXTRACT_WEB_VIEWS";

        /// <summary>
        /// Specifies the location of .Net framework references added to the compilation.
        /// </summary>
        public const string DotnetFrameworkReferences = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_DOTNET_FRAMEWORK_REFERENCES";

        /// <summary>
        /// Controls whether to use framework dependencies from subfolders.
        /// </summary>
        public const string DotnetFrameworkReferencesUseSubfolders = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_DOTNET_FRAMEWORK_REFERENCES_USE_SUBFOLDERS";

        /// <summary>
        /// Controls whether to check the responsiveness of NuGet feeds.
        /// </summary>
        public const string CheckNugetFeedResponsiveness = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK";

        /// <summary>
        /// Specifies the NuGet feeds to exclude from the responsiveness check.
        /// </summary>
        public const string ExcludedNugetFeedsFromResponsivenessCheck = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_EXCLUDED_FROM_CHECK";

        /// <summary>
        /// Specifies the location of the diagnostic directory.
        /// </summary>
        public const string DiagnosticDir = "CODEQL_EXTRACTOR_CSHARP_DIAGNOSTIC_DIR";
    }
}
