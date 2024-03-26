using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Direct results result from the successful application of a <see cref="DiagnosticRule" />,
    /// which can later be converted to a corresponding <see cref="DiagnosticMessage" />.
    /// </summary>
    public interface IDiagnosticsResult
    {
        /// <summary>
        /// Produces a <see cref="DiagnosticMessage" /> corresponding to this result.
        /// </summary>
        /// <param name="builder">
        /// The autobuilder to use for constructing the base <see cref="DiagnosticMessage" />.
        /// </param>
        /// <param name="severity">
        /// An optional severity value which overrides the default severity of the diagnostic.
        /// </param>
        /// <returns>The <see cref="DiagnosticMessage" /> corresponding to this result.</returns>
        DiagnosticMessage ToDiagnosticMessage<T>(Autobuilder<T> builder, DiagnosticMessage.TspSeverity? severity = null) where T : AutobuildOptionsShared;
    }

    public class DiagnosticRule
    {
        /// <summary>
        /// The pattern against which this rule matches build output.
        /// </summary>
        public Regex Pattern { get; }

        /// <summary>
        /// Constructs a diagnostic rule for the given <paramref name="pattern" />.
        /// </summary>
        /// <param name="pattern"></param>
        public DiagnosticRule(Regex pattern)
        {
            this.Pattern = pattern;
        }

        /// <summary>
        /// Constructs a diagnostic rule for the given regular expression <paramref name="pattern" />.
        /// </summary>
        /// <param name="pattern"></param>
        public DiagnosticRule(string pattern)
        {
            this.Pattern = new Regex(pattern, RegexOptions.Compiled);
        }

        /// <summary>
        /// Used by a <see cref="DiagnosticClassifier" /> <paramref name="classifier" /> to
        /// signal that the rule has matched some build output with <paramref name="match" />.
        /// </summary>
        /// <param name="classifier">The classifier which is firing the rule.</param>
        /// <param name="match">The <see cref="Match" /> that resulted from applying the rule.</param>
        public virtual void Fire(DiagnosticClassifier classifier, Match match) { }
    }

    /// <summary>
    /// A <see cref="DiagnosticRule" /> which detects arbitrary build messages from MSBuild, CSC, NETSDK, etc. and
    /// reports them, up to a limit, as telemetry-only diagnostics.
    /// </summary>
    public class BuildMessageRule : DiagnosticRule
    {
        public class Result : IDiagnosticsResult, IEquatable<Result>
        {
            /// <summary>
            /// A value indicating whether this a warning or an error.
            /// </summary>
            public string Type { get; }
            /// <summary>
            /// The source of the message, such as "MSB" or "NETSDK".
            /// </summary>
            public string Source { get; }
            /// <summary>
            /// The numeric id of the message.
            /// </summary>
            public int Code { get; }
            /// <summary>
            /// The message contents.
            /// </summary>
            public string Message { get; }

            public Result(string type, string source, int code, string message)
            {
                this.Type = type;
                this.Source = source;
                this.Code = code;
                this.Message = message;
            }

            public DiagnosticMessage ToDiagnosticMessage<T>(Autobuilder<T> builder, DiagnosticMessage.TspSeverity? severity = null) where T : AutobuildOptionsShared => new(
                builder.Options.Language,
                $"{this.Source.ToLower()}-{this.Code}",
                $"{this.Source.ToUpper()}{this.Code}",
                plaintextMessage: this.Message,
                severity:
                    this.Type.Equals("error") ?
                    DiagnosticMessage.TspSeverity.Error :
                    DiagnosticMessage.TspSeverity.Warning,
                // the messages we capture here are visible in the build log, so there is no need
                // to show them other than in telemetry
                visibility: new(telemetry: true)
            );

            public bool Equals(Result? x)
            {
                return x is not null &&
                    x.Code == this.Code &&
                    x.Type == this.Type &&
                    x.Source == this.Source &&
                    x.Message == this.Message;
            }

            public override bool Equals(object? obj)
            {
                return obj is Result && this.Equals(obj);
            }

            public override int GetHashCode()
            {
                return HashCode.Combine(this.Type, this.Source, this.Code, this.Message);
            }
        }

        /// <summary>
        /// The maximum number of diagnostics we should emit for this rule.
        /// </summary>
        private const int maxDiagnostics = 10;
        /// <summary>
        /// The number of diagnostics this rule has emitted so far.
        /// </summary>
        private int diagnostics = 0;

        public BuildMessageRule() : base("(?<type>error|warning) (?<source>[A-Z]+)(?<code>\\d+): (?<message>.*)") { }

        public override void Fire(DiagnosticClassifier classifier, Match match)
        {
            if (!match.Groups.TryGetValue("type", out var type))
                throw new ArgumentException("Expected regular expression match to contain type");
            if (!match.Groups.TryGetValue("source", out var source))
                throw new ArgumentException("Expected regular expression match to contain source");
            if (!match.Groups.TryGetValue("code", out var codeStr))
                throw new ArgumentException("Expected regular expression match to contain code");
            if (!match.Groups.TryGetValue("message", out var message))
                throw new ArgumentException("Expected regular expression match to contain message");
            if (!int.TryParse(codeStr.Value, out var code))
                throw new ArgumentException("Expected code to be numeric");

            // check that we have not yet exceeded our limit for emitting diagnostics
            if (this.diagnostics < BuildMessageRule.maxDiagnostics)
            {
                var result = new Result(type.Value, source.Value, code, message.Value);

                // add this result if we don't already have an identical one
                if (!classifier.Results.OfType<Result>().Any(d => d.Equals(result)))
                {
                    classifier.Results.Add(result);
                    this.diagnostics++;
                }
            }
        }
    }

    public class DiagnosticClassifier
    {
        private readonly List<DiagnosticRule> rules;
        public readonly List<IDiagnosticsResult> Results;

        public DiagnosticClassifier()
        {
            this.rules = new List<DiagnosticRule>();
            this.Results = new List<IDiagnosticsResult>();

            this.AddRule(new BuildMessageRule());
        }

        /// <summary>
        /// Adds <paramref name="rule" /> to this classifier.
        /// </summary>
        /// <param name="rule">The rule to add.</param>
        protected void AddRule(DiagnosticRule rule)
        {
            this.rules.Add(rule);
        }

        /// <summary>
        /// Applies all of this classifier's rules to <paramref name="line" /> to see which match.
        /// </summary>
        /// <param name="line">The line to which the rules should be applied to.</param>
        public void ClassifyLine(string line)
        {
            this.rules.ForEach(rule =>
            {
                var match = rule.Pattern.Match(line);
                if (match.Success)
                {
                    rule.Fire(this, match);
                }
            });
        }
    }
}
