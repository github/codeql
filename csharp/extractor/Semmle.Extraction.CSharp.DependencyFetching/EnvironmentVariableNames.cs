namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal static class EnvironmentVariableNames
    {
        /// <summary>
        /// Controls whether to generate source files from resources (`.resx`).
        /// </summary>
        public const string ResourceGeneration = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_EXTRACT_RESOURCES";

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
        /// Specifies the NuGet feeds to exclude from the responsiveness check. The value is a space-separated list of feed URLs.
        /// </summary>
        public const string ExcludedNugetFeedsFromResponsivenessCheck = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_EXCLUDED";

        /// <summary>
        /// Specifies the timeout (as an integer) in milliseconds for the initial check of NuGet feeds responsiveness. The value is then doubled for each subsequent check.
        /// </summary>
        public const string NugetFeedResponsivenessInitialTimeout = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_TIMEOUT";

        /// <summary>
        /// Specifies the timeout (as an integer) in milliseconds for the initial check of fallback NuGet feeds responsiveness. The value is then doubled for each subsequent check.
        /// This is primarily used in testing.
        /// </summary>
        internal const string NugetFeedResponsivenessInitialTimeoutForFallback = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_TIMEOUT";

        /// <summary>
        /// Specifies how many requests to make to the NuGet feeds to check their responsiveness.
        /// </summary>
        public const string NugetFeedResponsivenessRequestCount = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_LIMIT";

        /// <summary>
        /// Specifies how many requests to make to the fallback NuGet feeds to check their responsiveness.
        /// This is primarily used in testing.
        /// </summary>
        internal const string NugetFeedResponsivenessRequestCountForFallback = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_CHECK_FALLBACK_LIMIT";

        /// <summary>
        /// Specifies the NuGet feeds to use for fallback Nuget dependency fetching. The value is a space-separated list of feed URLs.
        /// The default value is `https://api.nuget.org/v3/index.json`.
        /// </summary>
        public const string FallbackNugetFeeds = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_FALLBACK";

        /// <summary>
        /// Controls whether to include NuGet feeds from nuget.config files in the fallback restore logic.
        /// </summary>
        public const string AddNugetConfigFeedsToFallback = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_FEEDS_FALLBACK_INCLUDE_NUGET_CONFIG_FEEDS";

        /// <summary>
        /// Specifies the path to the nuget executable to be used for package restoration.
        /// </summary>
        public const string NugetExePath = "CODEQL_EXTRACTOR_CSHARP_BUILDLESS_NUGET_PATH";

        /// <summary>
        /// Specifies the location of the diagnostic directory.
        /// </summary>
        public const string DiagnosticDir = "CODEQL_EXTRACTOR_CSHARP_DIAGNOSTIC_DIR";

        /// <summary>
        /// Specifies the hostname of the Dependabot proxy.
        /// </summary>
        public const string ProxyHost = "CODEQL_PROXY_HOST";

        /// <summary>
        /// Specifies the hostname of the Dependabot proxy.
        /// </summary>
        public const string ProxyPort = "CODEQL_PROXY_PORT";

        /// <summary>
        /// Contains the certificate used by the Dependabot proxy.
        /// </summary>
        public const string ProxyCertificate = "CODEQL_PROXY_CA_CERTIFICATE";
    }
}
