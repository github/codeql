using System;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Semmle.Util
{
    /// <summary>
    /// A wrapper around an underlying <see cref="StreamWriter" /> which allows
    /// <see cref="DiagnosticMessage" /> objects to be serialized to it.
    /// </summary>
    public sealed class DiagnosticsStream : IDiagnosticsWriter
    {
        private readonly JsonSerializer serializer;
        private readonly StreamWriter writer;

        /// <summary>
        /// Initialises a new <see cref="DiagnosticsStream" /> for a file at <paramref name="path" />.
        /// </summary>
        /// <param name="path">The path to the file that should be created.</param>
        public DiagnosticsStream(string path)
        {
            this.writer = File.CreateText(path);

            var contractResolver = new DefaultContractResolver
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            };

            serializer = new JsonSerializer
            {
                ContractResolver = contractResolver,
                NullValueHandling = NullValueHandling.Ignore
            };
        }

        /// <summary>
        /// Adds <paramref name="message" /> as a new diagnostics entry.
        /// </summary>
        /// <param name="message">The diagnostics entry to add.</param>
        public void AddEntry(DiagnosticMessage message)
        {
            serializer.Serialize(writer, message);
            writer.Flush();
        }

        /// <summary>
        /// Releases all resources used by the <see cref="DiagnosticsStream" /> object.
        /// </summary>
        public void Dispose()
        {
            writer.Dispose();
        }
    }
}
