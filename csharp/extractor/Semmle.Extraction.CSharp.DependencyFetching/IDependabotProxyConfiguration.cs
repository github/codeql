using System;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IDependabotProxyConfiguration
    {
        // The host of the Dependabot proxy, if available.
        string? Host { get; }

        // The port of the Dependabot proxy, if available.
        string? Port { get; }

        // The certificate of the Dependabot proxy, if available.
        string? Certificate { get; }

        // The list of package registries that are configured for the proxy, if any.
        // The value of the environment variable should be a JSON array of objects, such as:
        // [ { "type": "nuget_feed", "url": "https://nuget.pkg.github.com/org/index.json" } ]
        string? RegistryURLs { get; }
    }
}
