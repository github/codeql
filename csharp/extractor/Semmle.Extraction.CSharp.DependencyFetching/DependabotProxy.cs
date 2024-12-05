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
        private readonly string host;
        private readonly string port;

        /// <summary>
        /// The full address of the Dependabot proxy, if available.
        /// </summary>
        internal string Address { get; }
        /// <summary>
        /// The path to the temporary file where the certificate is stored.
        /// </summary>
        internal string? CertificatePath { get; private set; }
        /// <summary>
        /// The certificate used for the Dependabot proxy.
        /// </summary>
        internal X509Certificate2? Certificate { get; private set; }

        internal static DependabotProxy? GetDependabotProxy(ILogger logger, TemporaryDirectory tempWorkingDirectory)
        {
            // Obtain and store the address of the Dependabot proxy, if available.
            var host = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyHost);
            var port = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyPort);

            if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(port))
            {
                logger.LogInfo("No Dependabot proxy credentials are configured.");
                return null;
            }

            var result = new DependabotProxy(host, port);
            logger.LogInfo($"Dependabot proxy configured at {result.Address}");

            // Obtain and store the proxy's certificate, if available.
            var cert = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyCertificate);

            if (!string.IsNullOrWhiteSpace(cert))
            {
                logger.LogInfo("No certificate configured for Dependabot proxy.");

                var certDirPath = new DirectoryInfo(Path.Join(tempWorkingDirectory.DirInfo.FullName, ".dependabot-proxy"));
                Directory.CreateDirectory(certDirPath.FullName);

                result.CertificatePath = Path.Join(certDirPath.FullName, "proxy.crt");
                var certFile = new FileInfo(result.CertificatePath);

                using var writer = certFile.CreateText();
                writer.Write(cert);

                logger.LogInfo($"Stored Dependabot proxy certificate at {result.CertificatePath}");

                result.Certificate = new X509Certificate2(result.CertificatePath);
            }

            return result;
        }

        private DependabotProxy(string host, string port)
        {
            this.host = host;
            this.port = port;
            this.Address = $"http://{this.host}:{this.port}";
        }

        public void Dispose()
        {
            this.Certificate?.Dispose();
        }
    }
}
