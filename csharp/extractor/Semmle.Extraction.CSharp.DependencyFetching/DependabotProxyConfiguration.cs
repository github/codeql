using System;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class DependabotProxyConfiguration : IDependabotProxyConfiguration
    {
        public string? Host { get; } = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyHost);

        public string? Port { get; } = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyPort);

        public string? Certificate { get; } = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyCertificate);

        public string? RegistryURLs { get; } = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyURLs);
    }
}
