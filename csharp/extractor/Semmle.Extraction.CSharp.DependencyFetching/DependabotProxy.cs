using System;
using System.Diagnostics;
using System.IO;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal class DependabotProxy
    {
        private readonly string? host;
        private readonly string? port;
        private readonly FileInfo? certFile;

        /// <summary>
        /// The full address of the Dependabot proxy, if available.
        /// </summary>
        internal readonly string? Address;

        /// <summary>
        /// Gets a value indicating whether a Dependabot proxy is configured.
        /// </summary>
        internal bool IsConfigured => !string.IsNullOrEmpty(this.Address);

        internal DependabotProxy(TemporaryDirectory tempWorkingDirectory)
        {
            // Obtain and store the address of the Dependabot proxy, if available.
            this.host = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyHost);
            this.port = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyPort);

            if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(port))
            {
                return;
            }

            this.Address = $"http://{this.host}:{this.port}";

            // Obtain and store the proxy's certificate, if available.
            var cert = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyCertificate);

            if (string.IsNullOrWhiteSpace(cert))
            {
                return;
            }

            var certDirPath = new DirectoryInfo(Path.Join(tempWorkingDirectory.DirInfo.FullName, ".dependabot-proxy"));
            Directory.CreateDirectory(certDirPath.FullName);

            this.certFile = new FileInfo(Path.Join(certDirPath.FullName, "proxy.crt"));

            using var writer = this.certFile.CreateText();
            writer.Write(cert);
        }

        internal void ApplyProxy(ILogger logger, ProcessStartInfo startInfo)
        {
            // If the proxy isn't configured, we have nothing to do.
            if (!this.IsConfigured) return;

            logger.LogInfo($"Setting up Dependabot proxy at {this.Address}");

            startInfo.EnvironmentVariables["HTTP_PROXY"] = this.Address;
            startInfo.EnvironmentVariables["HTTPS_PROXY"] = this.Address;
            startInfo.EnvironmentVariables["SSL_CERT_FILE"] = this.certFile?.FullName;
        }
    }
}
