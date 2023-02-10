
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace Semmle.Util
{
    /// <summary>
    /// Represents diagnostic messages for the tool status page.
    /// </summary>
    public class DiagnosticMessage
    {
        /// <summary>
        /// Represents sources of diagnostic messages.
        /// </summary>
        public class TspSource
        {
            /// <summary>
            /// An identifier under which it makes sense to group this diagnostic message.
            /// This is used to build the SARIF reporting descriptor object.
            /// </summary>
            public string Id { get; }
            /// <summary>
            /// Display name for the ID. This is used to build the SARIF reporting descriptor object.
            /// </summary>
            public string Name { get; }
            /// <summary>
            /// Name of the CodeQL extractor. This is used to identify which tool component the reporting descriptor object should be nested under in SARIF.
            /// </summary>
            public string? ExtractorName { get; set; }

            public TspSource(string id, string name)
            {
                Id = id;
                Name = name;
            }
        }

        /// <summary>
        /// Enumerates severity levels for diagnostics.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter), typeof(CamelCaseNamingStrategy))]
        public enum TspSeverity
        {
            Note,
            Warning,
            Error
        }

        public class TspVisibility
        {
            /// <summary>
            /// True if the message should be displayed on the status page (defaults to false).
            /// </summary>
            public bool? StatusPage { get; set; }
            /// <summary>
            /// True if the message should be counted in the diagnostics summary table printed by
            /// <c>codeql database analyze</c> (defaults to false).
            /// </summary>
            public bool? CLISummaryTable { get; set; }
            /// <summary>
            /// True if the message should be sent to telemetry (defaults to false).
            /// </summary>
            public bool? Telemetry { get; set; }
        }

        public class TspLocation
        {
            /// <summary>
            /// Path to the affected file if appropriate, relative to the source root.
            /// </summary>
            public string? File { get; set; }
            public int? StartLine { get; set; }
            public int? StartColumn { get; set; }
            public int? EndLine { get; set; }
            public int? EndColumn { get; set; }
        }

        /// <summary>
        /// ISO 8601 timestamp.
        /// </summary>
        public string Timestamp { get; set; }
        /// <summary>
        /// The source of the diagnostic message.
        /// </summary>
        public TspSource Source { get; set; }
        /// <summary>
        /// GitHub flavored Markdown formatted message. Should include inline links to any help pages.
        /// </summary>
        public string? MarkdownMessage { get; set; }
        /// <summary>
        /// Plain text message. Used by components where the string processing needed to support
        /// Markdown is cumbersome.
        /// </summary>
        public string? PlaintextMessage { get; set; }
        /// <summary>
        /// List of help links intended to supplement <see cref="PlaintextMessage" />.
        /// </summary>
        public List<string> HelpLinks { get; }
        /// <summary>
        /// SARIF severity.
        /// </summary>
        public TspSeverity? Severity { get; set; }
        /// <summary>
        /// If true, then this message won't be presented to users.
        /// </summary>
        public bool Internal { get; set; }
        /// <summary>
        ///
        /// </summary>
        public TspVisibility Visibility { get; }
        public TspLocation Location { get; }
        /// <summary>
        /// Structured metadata about the diagnostic message.
        /// </summary>
        public Dictionary<string, object> Attributes { get; }

        public DiagnosticMessage(TspSource source)
        {
            Timestamp = DateTime.UtcNow.ToString("o", CultureInfo.InvariantCulture);
            Source = source;
            HelpLinks = new List<string>();
            Visibility = new TspVisibility();
            Location = new TspLocation();
            Attributes = new Dictionary<string, object>();
        }
    }

    /// <summary>
    /// A wrapper around an underlying <see cref="StreamWriter" /> which allows
    /// <see cref="DiagnosticMessage" /> objects to be serialized to it.
    /// </summary>
    public sealed class DiagnosticsStream : IDisposable
    {
        private readonly JsonSerializer serializer;
        private readonly StreamWriter writer;

        /// <summary>
        /// Initialises a new <see cref="DiagnosticsStream" /> for a file at <paramref name="path" />.
        /// </summary>
        /// <param name="path">The path to the file that should be created.</param>
        /// <returns>
        /// A <see cref="DiagnosticsStream" /> object which allows diagnostics to be
        /// written to a file at <paramname name="path" />.
        /// </returns>
        public static DiagnosticsStream ForFile(string path)
        {
            var stream = File.CreateText(path);
            return new DiagnosticsStream(stream);
        }

        public DiagnosticsStream(StreamWriter streamWriter)
        {
            var contractResolver = new DefaultContractResolver
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            };

            serializer = new JsonSerializer
            {
                ContractResolver = contractResolver
            };

            writer = streamWriter;
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
