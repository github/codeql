using System;
using System.Collections.Immutable;
using System.Diagnostics;
using System.Security.Cryptography.X509Certificates;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public interface IRegistryProxy : IDisposable
    {
        /// <summary>
        /// The full address of the registry proxy, if available.
        /// </summary>
        string Address { get; }

        /// <summary>
        /// The URLs of package registries that are configured for the proxy.
        /// </summary>
        ImmutableHashSet<string> RegistryURLs { get; }

        /// <summary>
        /// The URLs of package registries that replace the base registry.
        /// </summary>
        ImmutableHashSet<string> RegistryBaseURLs { get; }

        /// <summary>
        /// The path to the temporary file where the certificate is stored.
        /// </summary>
        string? CertificatePath { get; }

        /// <summary>
        /// The certificate used for the registry proxy.
        /// </summary>
        X509Certificate2? Certificate { get; }

        /// <summary>
        /// Configures the environment variables for a process to use the registry proxy.
        /// </summary>
        /// <param name="pi">The process start info to configure.</param>
        void SetProcessEnvironment(ProcessStartInfo pi);
    }
}
