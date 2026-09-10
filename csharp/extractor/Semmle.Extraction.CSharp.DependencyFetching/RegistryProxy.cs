using System;
using System.Collections.Immutable;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Semmle.Util;
using Semmle.Util.Logging;
using Newtonsoft.Json;
using System.Linq;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class RegistryProxy : IRegistryProxy
    {
        /// <summary>
        /// Represents configurations for package registries.
        /// </summary>
        public class RegistryConfig
        {
            /// <summary>
            /// The type of the package registry.
            /// </summary>
            public string? Type { get; init; }

            /// <summary>
            /// The URL of the package registry.
            /// </summary>
            public string? Url { get; init; }

            /// <summary>
            /// A boolean indicating whether this registry replaces the base registry.
            /// </summary>
            [JsonProperty("replaces-base")]
            public bool ReplacesBase { get; init; } = false;
        };

        public string Address { get; }

        /// <summary>
        /// A dictionary mapping registry URLs to a boolean indicating whether they replace the base registry.
        /// </summary>
        private readonly Dictionary<string, bool> registryMapping = [];

        private ImmutableHashSet<string>? registryURLs;
        /// <summary>
        /// Gets the set of registry URLs that have been configured as part of the organization-level
        /// private registry configuration. This includes all registries, regardless of whether they replace
        /// the default feeds.
        /// </summary>
        public ImmutableHashSet<string> RegistryURLs =>
            registryURLs ??= registryMapping.Keys.ToImmutableHashSet();

        private ImmutableHashSet<string>? registryBaseURLs;
        /// <summary>
        /// Gets the set of registry URLs that have been configured as part of the organization-level
        /// private registry configuration and that replace the default registry. This is a subset of
        /// <see cref="RegistryURLs"/>.
        /// If non-empty, the set should be used as a replacement for the default registry during
        /// package resolution.
        /// </summary>
        public ImmutableHashSet<string> RegistryBaseURLs =>
            registryBaseURLs ??= registryMapping.Where(kvp => kvp.Value).Select(kvp => kvp.Key).ToImmutableHashSet();

        public string? CertificatePath { get; private set; }

        public X509Certificate2? Certificate { get; private set; }

        private RegistryProxy(IRegistryProxyConfiguration config, ILogger logger, TemporaryDirectory tempWorkingDirectory)
        {
            Address = $"http://{config.Host}:{config.Port}";

            if (!string.IsNullOrWhiteSpace(config.Certificate))
            {
                var certDirPath = new DirectoryInfo(Path.Join(tempWorkingDirectory.DirInfo.FullName, ".registry-proxy"));
                Directory.CreateDirectory(certDirPath.FullName);

                CertificatePath = Path.Join(certDirPath.FullName, "proxy.crt");
                var certFile = new FileInfo(CertificatePath);

                using var writer = certFile.CreateText();
                writer.Write(config.Certificate);
                writer.Close();

                logger.LogInfo($"Stored Registry proxy certificate at {CertificatePath}");

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
                            if (string.IsNullOrWhiteSpace(registry.Url))
                            {
                                logger.LogError("Ignoring registry with empty URL.");
                                continue;
                            }

                            if (string.IsNullOrWhiteSpace(registry.Type))
                            {
                                logger.LogError($"Ignoring registry at '{registry.Url}' since it has no type.");
                                continue;
                            }

                            // The array contains all configured private registries, not just ones for C#.
                            // We ignore the non-C# ones here.
                            if (!registry.Type.Equals("nuget_feed"))
                            {
                                logger.LogDebug($"Ignoring registry at '{registry.Url}' since it is not of type 'nuget_feed'.");
                                continue;
                            }

                            logger.LogInfo($"Found private registry at '{registry.Url}'");
                            registryMapping.AddOrUpdateToLatest(registry.Url, registry.ReplacesBase);
                        }
                    }
                }
                catch (JsonException ex)
                {
                    logger.LogError($"Unable to parse '{EnvironmentVariableNames.ProxyURLs}': {ex.Message}");
                }
            }
        }

        internal static IRegistryProxy? Make(ILogger logger, IDiagnosticsWriter diagnosticsWriter, TemporaryDirectory tempWorkingDirectory)
        {
            // Setting HTTP(S)_PROXY and SSL_CERT_FILE have no effect on Windows or macOS,
            // but we would still end up using the Registry proxy to check for feed reachability.
            // This would result in us discovering that the feeds are reachable, but `dotnet` would
            // fail to connect to them. To prevent this from happening, we do not initialise an
            // instance of `RegistryProxy` on those platforms.
            if (SystemBuildActions.Instance.IsWindows() || SystemBuildActions.Instance.IsMacOs())
            {
                return null;
            }

            return Make(new RegistryProxyConfiguration(), logger, diagnosticsWriter, tempWorkingDirectory);
        }

        /// <summary>
        /// Creates an instance of the Registry proxy using the specified configuration.
        /// Returns null if the proxy cannot be created.
        /// This overload is exposed primarily to enable platform-independent unit testing.
        /// </summary>
        internal static IRegistryProxy? Make(
            IRegistryProxyConfiguration proxyConfig, ILogger logger, IDiagnosticsWriter diagnosticsWriter, TemporaryDirectory tempWorkingDirectory)
        {
            if (string.IsNullOrWhiteSpace(proxyConfig.Host) || string.IsNullOrWhiteSpace(proxyConfig.Port))
            {
                logger.LogDebug("No Registry proxy credentials are configured.");
                return null;
            }

            var result = new RegistryProxy(proxyConfig, logger, tempWorkingDirectory);
            logger.LogInfo($"Registry proxy configured at {result.Address}");

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
