using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Semmle.Util;
using Semmle.Util.Logging;
using Newtonsoft.Json;
using System.Linq;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class DependabotProxy : IDependabotProxy
    {
        /// <summary>
        /// Represents configurations for package registries.
        /// </summary>
        /// <param name="Type">The type of package registry.</param>
        /// <param name="URL">The URL of the package registry.</param>
        public record class RegistryConfig(string Type, string URL);

        public string Address { get; }

        public HashSet<string> RegistryURLs { get; } = [];

        public string? CertificatePath { get; private set; }

        public X509Certificate2? Certificate { get; private set; }

        private DependabotProxy(IDependabotProxyConfiguration config, ILogger logger, TemporaryDirectory tempWorkingDirectory)
        {
            Address = $"http://{config.Host}:{config.Port}";

            if (!string.IsNullOrWhiteSpace(config.Certificate))
            {
                var certDirPath = new DirectoryInfo(Path.Join(tempWorkingDirectory.DirInfo.FullName, ".dependabot-proxy"));
                Directory.CreateDirectory(certDirPath.FullName);

                CertificatePath = Path.Join(certDirPath.FullName, "proxy.crt");
                var certFile = new FileInfo(CertificatePath);

                using var writer = certFile.CreateText();
                writer.Write(config.Certificate);
                writer.Close();

                logger.LogInfo($"Stored Dependabot proxy certificate at {CertificatePath}");

                Certificate = X509Certificate2.CreateFromPem(config.Certificate);
            }

            if (!string.IsNullOrWhiteSpace(config.RegistryURLs))
            {
                try
                {
                    var array = JsonConvert.DeserializeObject<List<RegistryConfig>>(config.RegistryURLs);
                    if (array is not null)
                    {
                        foreach (RegistryConfig registry in array)
                        {
                            // The array contains all configured private registries, not just ones for C#.
                            // We ignore the non-C# ones here.
                            if (!registry.Type.Equals("nuget_feed"))
                            {
                                logger.LogDebug($"Ignoring registry at '{registry.URL}' since it is not of type 'nuget_feed'.");
                                continue;
                            }

                            logger.LogInfo($"Found private registry at '{registry.URL}'");
                            RegistryURLs.Add(registry.URL);
                        }
                    }
                }
                catch (JsonException ex)
                {
                    logger.LogError($"Unable to parse '{EnvironmentVariableNames.ProxyURLs}': {ex.Message}");
                }
            }
        }

        internal static IDependabotProxy? Make(ILogger logger, IDiagnosticsWriter diagnosticsWriter, TemporaryDirectory tempWorkingDirectory)
        {
            // Setting HTTP(S)_PROXY and SSL_CERT_FILE have no effect on Windows or macOS,
            // but we would still end up using the Dependabot proxy to check for feed reachability.
            // This would result in us discovering that the feeds are reachable, but `dotnet` would
            // fail to connect to them. To prevent this from happening, we do not initialise an
            // instance of `DependabotProxy` on those platforms.
            if (SystemBuildActions.Instance.IsWindows() || SystemBuildActions.Instance.IsMacOs())
            {
                return null;
            }

            return MakeAux(new DependabotProxyConfiguration(), logger, diagnosticsWriter, tempWorkingDirectory);
        }

        internal static IDependabotProxy? MakeAux(
            IDependabotProxyConfiguration proxyConfig, ILogger logger, IDiagnosticsWriter diagnosticsWriter, TemporaryDirectory tempWorkingDirectory)
        {
            if (string.IsNullOrWhiteSpace(proxyConfig.Host) || string.IsNullOrWhiteSpace(proxyConfig.Port))
            {
                logger.LogInfo("No Dependabot proxy credentials are configured.");
                return null;
            }

            var result = new DependabotProxy(proxyConfig, logger, tempWorkingDirectory);
            logger.LogInfo($"Dependabot proxy configured at {result.Address}");

            // Emit a diagnostic for the discovered private registries, so that it is easy
            // for users to see that they were picked up.
            if (result.RegistryURLs.Count > 0)
            {
                diagnosticsWriter.AddEntry(new DiagnosticMessage(
                    Language.CSharp,
                    "buildless/analysis-using-private-registries",
                    severity: DiagnosticMessage.TspSeverity.Note,
                    visibility: new DiagnosticMessage.TspVisibility(true, true, true),
                    name: "C# extraction used private package registries",
                    markdownMessage: string.Format(
                        "C# was extracted using the following private package registries:\n\n{0}\n",
                        string.Join("\n", result.RegistryURLs.Select(url => string.Format("- `{0}`", url)))
                    )
                ));
            }

            return result;
        }

        public void Dispose()
        {
            Certificate?.Dispose();
        }
    }
}
