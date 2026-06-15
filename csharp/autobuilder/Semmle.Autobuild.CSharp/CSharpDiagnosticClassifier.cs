using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// A diagnostic rule which tries to identify missing Xamarin SDKs.
    /// </summary>
    public class MissingXamarinSdkRule : DiagnosticRule
    {
        private const string docsUrl = "https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-xamarin-applications";

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

            public DiagnosticMessage ToDiagnosticMessage<T>(Autobuilder<T> builder, DiagnosticMessage.TspSeverity? severity = null) where T : AutobuildOptionsShared => new(
                builder.Options.Language,
                $"missing-xamarin-{this.SDKName.ToLower()}-sdk",
                $"Missing Xamarin SDK for {this.SDKName}",
                severity: severity ?? DiagnosticMessage.TspSeverity.Error,
                markdownMessage: $"[Configure your workflow]({docsUrl}) for this SDK before running CodeQL."
            );
        }

        public MissingXamarinSdkRule() :
            base("MSB4019:[^\"]*\"[^\"]*Xamarin\\.(?<sdkName>[^\\.]*)\\.CSharp\\.targets\"")
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

    public class MissingProjectFileRule : DiagnosticRule
    {
        private const string runsOnDocsUrl = "https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on";
        private const string checkoutDocsUrl = "https://github.com/actions/checkout#usage";

        public class Result : IDiagnosticsResult
        {
            /// <summary>
            /// A set of missing project files.
            /// </summary>
            public HashSet<string> MissingProjectFiles { get; }

            public Result()
            {
                this.MissingProjectFiles = new HashSet<string>();
            }

            public DiagnosticMessage ToDiagnosticMessage<T>(Autobuilder<T> builder, DiagnosticMessage.TspSeverity? severity = null) where T : AutobuildOptionsShared => new(
                builder.Options.Language,
                "missing-project-files",
                "Missing project files",
                severity: severity ?? DiagnosticMessage.TspSeverity.Warning,
                markdownMessage: $"""
                Some project files were not found when CodeQL built your project:

                {this.MissingProjectFiles.AsEnumerable().Select(p => builder.MakeRelative(p)).ToMarkdownList(MarkdownUtil.CodeFormatter, 5)}

                This may lead to subsequent failures. You can check for common causes for missing project files:

                - Ensure that the project is built using the {runsOnDocsUrl.ToMarkdownLink("intended operating system")} and that filenames on case-sensitive platforms are correctly specified.
                - If your repository uses Git submodules, ensure that those are {checkoutDocsUrl.ToMarkdownLink("checked out")} before the CodeQL Action is run.
                - If you auto-generate some project files as part of your build process, ensure that these are generated before the CodeQL Action is run.
                """
            );
        }

        public MissingProjectFileRule() :
            base("MSB3202: The project file \"(?<projectFile>[^\"]+)\" was not found. \\[(?<location>[^\\]]+)\\]")
        {
        }

        public override void Fire(DiagnosticClassifier classifier, Match match)
        {
            if (!match.Groups.TryGetValue("projectFile", out var projectFile))
                throw new ArgumentException("Expected regular expression match to contain projectFile");
            if (!match.Groups.TryGetValue("location", out _))
                throw new ArgumentException("Expected regular expression match to contain location");

            var result = classifier.Results.OfType<Result>().FirstOrDefault();

            // if we do not yet have a result for this rule, create one and add it to the list
            // of results the classifier knows about
            if (result is null)
            {
                result = new Result();
                classifier.Results.Add(result);
            }

            // then add the missing project file
            result.MissingProjectFiles.Add(projectFile.Value);
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
            this.AddRule(new MissingProjectFileRule());
        }
    }
}
