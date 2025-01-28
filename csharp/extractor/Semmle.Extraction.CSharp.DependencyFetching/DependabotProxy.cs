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
            // Setting HTTP(S)_PROXY and SSL_CERT_FILE have no effect on Windows or macOS,
            // but we would still end up using the Dependabot proxy to check for feed reachability.
            // This would result in us discovering that the feeds are reachable, but `dotnet` would
            // fail to connect to them. To prevent this from happening, we do not initialise an
            // instance of `DependabotProxy` on those platforms.
            if (SystemBuildActions.Instance.IsWindows() || SystemBuildActions.Instance.IsMacOs()) return null;

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
                var certDirPath = new DirectoryInfo(Path.Join(tempWorkingDirectory.DirInfo.FullName, ".dependabot-proxy"));
                Directory.CreateDirectory(certDirPath.FullName);

                result.CertificatePath = Path.Join(certDirPath.FullName, "proxy.crt");
                var certFile = new FileInfo(result.CertificatePath);

                using var writer = certFile.CreateText();
                writer.Write(cert);
                writer.Close();

                logger.LogInfo($"Stored Dependabot proxy certificate at {result.CertificatePath}");

                result.Certificate = X509Certificate2.CreateFromPem(cert);
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
