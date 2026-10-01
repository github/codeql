using System;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IRegistryProxyConfiguration
    {
        // The host of the registry proxy, if available.
        string? Host { get; }

        // The port of the registry proxy, if available.
        string? Port { get; }

        // The certificate of the registry proxy, if available.
        string? Certificate { get; }

        // The list of package registries that are configured for the registry proxy, if any.
        // The value of the environment variable should be a JSON array of objects, such as:
        // [ { "type": "nuget_feed", "url": "https://nuget.pkg.github.com/org/index.json" } ]
        string? RegistryURLs { get; }
    }
}
