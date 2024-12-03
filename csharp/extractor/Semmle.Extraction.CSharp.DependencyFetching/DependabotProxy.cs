using System;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class DependabotProxy : IDisposable
    {
        private readonly string? host;
        private readonly string? port;
        private readonly FileInfo? certFile;

        /// <summary>
        /// The full address of the Dependabot proxy, if available.
        /// </summary>
        internal readonly string? Address;
        /// <summary>
        /// The path to the temporary file where the certificate is stored.
        /// </summary>
        internal readonly string? CertificatePath;
        /// <summary>
        /// The certificate used for the Dependabot proxy.
        /// </summary>
        internal readonly X509Certificate2? Certificate;

        /// <summary>
        /// Gets a value indicating whether a Dependabot proxy is configured.
        /// </summary>
        internal bool IsConfigured => !string.IsNullOrEmpty(this.Address);

        internal DependabotProxy(ILogger logger, TemporaryDirectory tempWorkingDirectory)
        {
            // Obtain and store the address of the Dependabot proxy, if available.
            this.host = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyHost);
            this.port = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyPort);

            if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(port))
            {
                logger.LogInfo("No Dependabot proxy credentials are configured.");
                return;
            }

            this.Address = $"http://{this.host}:{this.port}";
            logger.LogInfo($"Dependabot proxy configured at {this.Address}");

            // Obtain and store the proxy's certificate, if available.
            var cert = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyCertificate);

            if (string.IsNullOrWhiteSpace(cert))
            {
                logger.LogInfo("No certificate configured for Dependabot proxy.");
                return;
            }

            var certDirPath = new DirectoryInfo(Path.Join(tempWorkingDirectory.DirInfo.FullName, ".dependabot-proxy"));
            Directory.CreateDirectory(certDirPath.FullName);

            this.CertificatePath = Path.Join(certDirPath.FullName, "proxy.crt");
            this.certFile = new FileInfo(this.CertificatePath);

            using var writer = this.certFile.CreateText();
            writer.Write(cert);

            logger.LogInfo($"Stored Dependabot proxy certificate at {this.CertificatePath}");

            this.Certificate = new X509Certificate2(this.CertificatePath);
        }

        internal void ApplyProxy(ILogger logger, ProcessStartInfo startInfo)
        {
            // If the proxy isn't configured, we have nothing to do.
            if (!this.IsConfigured) return;

            logger.LogInfo($"Setting up Dependabot proxy at {this.Address}");

            startInfo.EnvironmentVariables.Add("HTTP_PROXY", this.Address);
            startInfo.EnvironmentVariables.Add("HTTPS_PROXY", this.Address);
            startInfo.EnvironmentVariables.Add("SSL_CERT_FILE", this.certFile?.FullName);
        }

        public void Dispose()
        {
            if (this.Certificate != null)
            {
                this.Certificate.Dispose();
            }
        }
    }
}
