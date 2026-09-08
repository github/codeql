using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IDependabotProxy : IDisposable
    {
        /// <summary>
        /// The full address of the Dependabot proxy, if available.
        /// </summary>
        string Address { get; }

        /// <summary>
        /// The URLs of package registries that are configured for the proxy.
        /// </summary>
        HashSet<string> RegistryURLs { get; }

        /// <summary>
        /// The path to the temporary file where the certificate is stored.
        /// </summary>
        string? CertificatePath { get; }

        /// <summary>
        /// The certificate used for the Dependabot proxy.
        /// </summary>
        X509Certificate2? Certificate { get; }
    }
}
