using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Semmle.Util;
using Semmle.Util.Logging;
using Newtonsoft.Json;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class DependabotProxy : IDisposable
    {
        /// <summary>
        /// Represents configurations for package registries.
        /// </summary>
        public struct RegistryConfig
        {
            /// <summary>
            /// The type of package registry.
            /// </summary>
            public string Type { get; set; }
            /// <summary>
            /// The URL of the package registry.
            /// </summary>
            public string URL { get; set; }
        }

        private readonly string host;
        private readonly string port;

        /// <summary>
        /// The full address of the Dependabot proxy, if available.
        /// </summary>
        internal string Address { get; }
        /// <summary>
        /// The URLs of package registries that are configured for the proxy.
        /// </summary>
        internal HashSet<string> RegistryURLs { get; }
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

            // Try to obtain the list of private registry URLs.
            var registryURLs = Environment.GetEnvironmentVariable(EnvironmentVariableNames.ProxyURLs);

            if (!string.IsNullOrWhiteSpace(registryURLs))
            {
                try
                {
                    // The value of the environment variable should be a JSON array of objects, such as:
                    // [ { "type": "nuget_feed", "url": "https://nuget.pkg.github.com/org/index.json" } ]
                    var array = JsonConvert.DeserializeObject<List<RegistryConfig>>(registryURLs);
                    if (array != null)
                    {
                        foreach (RegistryConfig config in array)
                        {
                            // The array contains all configured private registries, not just ones for C#.
                            // We ignore the non-C# ones here.
                            if (!config.Type.Equals("nuget_feed"))
                            {
                                logger.LogDebug($"Ignoring registry at '{config.URL}' since it is not of type 'nuget_feed'.");
                                continue;
                            }

                            logger.LogInfo($"Found private registry at '{config.URL}'");
                            result.RegistryURLs.Add(config.URL);
                        }
                    }
                }
                catch (JsonException ex)
                {
                    logger.LogError($"Unable to parse '{EnvironmentVariableNames.ProxyURLs}': {ex.Message}");
                }
            }

            return result;
        }

        private DependabotProxy(string host, string port)
        {
            this.host = host;
            this.port = port;
            this.Address = $"http://{this.host}:{this.port}";
            this.RegistryURLs = new HashSet<string>();
        }

        public void Dispose()
        {
            this.Certificate?.Dispose();
        }
    }
}
