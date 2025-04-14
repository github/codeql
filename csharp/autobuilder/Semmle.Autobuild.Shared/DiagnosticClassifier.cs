using System.Collections.Generic;
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

    public class DiagnosticClassifier
    {
        private readonly List<DiagnosticRule> rules;
        public List<IDiagnosticsResult> Results { get; }

        public DiagnosticClassifier()
        {
            this.rules = new List<DiagnosticRule>();
            this.Results = new List<IDiagnosticsResult>();
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
