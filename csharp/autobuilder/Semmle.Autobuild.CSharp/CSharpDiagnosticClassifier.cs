using System;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Autobuild.Shared;
using Semmle.Util;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// A diagnostic rule which tries to identify missing Xamarin SDKs.
    /// </summary>
    public class MissingXamarinSdkRule : DiagnosticRule
    {
        public class Result : IDiagnosticsResult
        {
            /// <summary>
            /// The name of the SDK that is missing.
            /// </summary>
            public string SDKName { get; }

            public Result(string sdkName)
            {
                this.SDKName = sdkName;
            }

            public DiagnosticMessage ToDiagnosticMessage<T>(Autobuilder<T> builder) where T : AutobuildOptionsShared
            {
                var diag = builder.MakeDiagnostic(
                    $"missing-xamarin-{this.SDKName.ToLower()}-sdk",
                    $"Missing Xamarin SDK for {this.SDKName}"
                );
                diag.PlaintextMessage = "Please install this SDK before running CodeQL.";

                return diag;
            }
        }

        public MissingXamarinSdkRule() :
            base("MSB4019:[^\"]*\"[^\"]*/Xamarin/(?<sdkName>[^/]*)/Xamarin\\.(\\k<sdkName>)\\.CSharp\\.targets\"")
        {
        }

        public override void Fire(DiagnosticClassifier classifier, Match match)
        {
            if (!match.Groups.TryGetValue("sdkName", out var sdkName))
                throw new ArgumentException("Expected regular expression match to contain sdkName");

            var xamarinResults = classifier.Results.OfType<Result>().Where(result =>
                result.SDKName.Equals(sdkName.Value)
            );

            if (!xamarinResults.Any())
                classifier.Results.Add(new Result(sdkName.Value));
        }
    }

    /// <summary>
    /// Implements a <see cref="DiagnosticClassifier" /> which applies C#-specific rules to
    /// the build output.
    /// </summary>
    public class CSharpDiagnosticClassifier : DiagnosticClassifier
    {
        public CSharpDiagnosticClassifier()
        {
            // add C#-specific rules to this classifier
            this.AddRule(new MissingXamarinSdkRule());
        }
    }
}
