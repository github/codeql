using System;
using System.Collections.Generic;
using System.Globalization;
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
            public string? ExtractorName { get; }

            public TspSource(string id, string name, string? extractorName = null)
            {
                Id = id;
                Name = name;
                ExtractorName = extractorName;
            }
        }

        /// <summary>
        /// Enumerates severity levels for diagnostics.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter), typeof(CamelCaseNamingStrategy))]
        public enum TspSeverity
        {
            Unknown,
            Note,
            Warning,
            Error
        }

        /// <summary>
        /// Stores flags indicating where the diagnostic should be displayed.
        /// </summary>
        public class TspVisibility
        {
            /// <summary>
            /// A read-only instance of <see cref="TspVisibility" /> which indicates that the
            /// diagnostic should be used in all supported locations.
            /// </summary>
            public static readonly TspVisibility All = new(true, true, true);

            /// <summary>
            /// True if the message should be displayed on the status page (defaults to false).
            /// </summary>
            public bool? StatusPage { get; }
            /// <summary>
            /// True if the message should be counted in the diagnostics summary table printed by
            /// <c>codeql database analyze</c> (defaults to false).
            /// </summary>
            public bool? CLISummaryTable { get; }
            /// <summary>
            /// True if the message should be sent to telemetry (defaults to false).
            /// </summary>
            public bool? Telemetry { get; }

            public TspVisibility(bool? statusPage = null, bool? cliSummaryTable = null, bool? telemetry = null)
            {
                this.StatusPage = statusPage;
                this.CLISummaryTable = cliSummaryTable;
                this.Telemetry = telemetry;
            }
        }

        /// <summary>
        /// Represents source code locations for diagnostic messages.
        /// </summary>
        public class TspLocation
        {
            /// <summary>
            /// Path to the affected file if appropriate, relative to the source root.
            /// </summary>
            public string? File { get; }
            /// <summary>
            /// The line where the range to which the diagnostic relates to starts.
            /// </summary>
            public int? StartLine { get; }
            /// <summary>
            /// The column where the range to which the diagnostic relates to starts.
            /// </summary>
            public int? StartColumn { get; }
            /// <summary>
            /// The line where the range to which the diagnostic relates to ends.
            /// </summary>
            public int? EndLine { get; }
            /// <summary>
            /// The column where the range to which the diagnostic relates to ends.
            /// </summary>
            public int? EndColumn { get; }

            public TspLocation(string? file = null, int? startLine = null, int? startColumn = null, int? endLine = null, int? endColumn = null)
            {
                this.File = file;
                this.StartLine = startLine;
                this.StartColumn = startColumn;
                this.EndLine = endLine;
                this.EndColumn = endColumn;
            }
        }

        /// <summary>
        /// ISO 8601 timestamp.
        /// </summary>
        public string Timestamp { get; }
        /// <summary>
        /// The source of the diagnostic message.
        /// </summary>
        public TspSource Source { get; }
        /// <summary>
        /// GitHub flavored Markdown formatted message. Should include inline links to any help pages.
        /// </summary>
        public string? MarkdownMessage { get; }
        /// <summary>
        /// Plain text message. Used by components where the string processing needed to support
        /// Markdown is cumbersome.
        /// </summary>
        public string? PlaintextMessage { get; }
        /// <summary>
        /// List of help links intended to supplement <see cref="PlaintextMessage" />.
        /// </summary>
        public List<string> HelpLinks { get; }
        /// <summary>
        /// SARIF severity.
        /// </summary>
        public TspSeverity? Severity { get; }
        /// <summary>
        /// If true, then this message won't be presented to users.
        /// </summary>
        public bool Internal { get; }
        public TspVisibility Visibility { get; }
        public TspLocation? Location { get; }
        /// <summary>
        /// Structured metadata about the diagnostic message.
        /// </summary>
        public Dictionary<string, object> Attributes { get; }

        public DiagnosticMessage(
            Language language, string id, string name, string? markdownMessage = null, string? plaintextMessage = null,
            TspVisibility? visibility = null, TspLocation? location = null, TspSeverity? severity = TspSeverity.Error,
            DateTime? timestamp = null, bool? intrnl = null
        )
        {
            this.Source = new TspSource(
                id: $"{language.UpperCaseName.ToLower()}/autobuilder/{id}",
                name: name,
                extractorName: language.UpperCaseName.ToLower()
            );
            this.Timestamp = (timestamp ?? DateTime.UtcNow).ToString("o", CultureInfo.InvariantCulture);
            this.HelpLinks = new List<string>();
            this.Attributes = new Dictionary<string, object>();
            this.Severity = severity;
            this.Visibility = visibility ?? TspVisibility.All;
            this.Location = location;
            this.Internal = intrnl ?? false;
            this.MarkdownMessage = markdownMessage;
            this.PlaintextMessage = plaintextMessage;
        }
    }
}
