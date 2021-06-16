// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Diagnostics
        {
            // Generated from `Microsoft.AspNetCore.Diagnostics.CompilationFailure` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CompilationFailure
            {
                public CompilationFailure(string sourceFilePath, string sourceFileContent, string compiledContent, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.DiagnosticMessage> messages, string failureSummary) => throw null;
                public CompilationFailure(string sourceFilePath, string sourceFileContent, string compiledContent, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.DiagnosticMessage> messages) => throw null;
                public string CompiledContent { get => throw null; }
                public string FailureSummary { get => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.DiagnosticMessage> Messages { get => throw null; }
                public string SourceFileContent { get => throw null; }
                public string SourceFilePath { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.DiagnosticMessage` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DiagnosticMessage
            {
                public DiagnosticMessage(string message, string formattedMessage, string filePath, int startLine, int startColumn, int endLine, int endColumn) => throw null;
                public int EndColumn { get => throw null; }
                public int EndLine { get => throw null; }
                public string FormattedMessage { get => throw null; }
                public string Message { get => throw null; }
                public string SourceFilePath { get => throw null; }
                public int StartColumn { get => throw null; }
                public int StartLine { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.ErrorContext` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ErrorContext
            {
                public ErrorContext(Microsoft.AspNetCore.Http.HttpContext httpContext, System.Exception exception) => throw null;
                public System.Exception Exception { get => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.ICompilationException` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ICompilationException
            {
                System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.CompilationFailure> CompilationFailures { get; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.IDeveloperPageExceptionFilter` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDeveloperPageExceptionFilter
            {
                System.Threading.Tasks.Task HandleExceptionAsync(Microsoft.AspNetCore.Diagnostics.ErrorContext errorContext, System.Func<Microsoft.AspNetCore.Diagnostics.ErrorContext, System.Threading.Tasks.Task> next);
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.IExceptionHandlerFeature` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IExceptionHandlerFeature
            {
                System.Exception Error { get; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.IExceptionHandlerPathFeature` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IExceptionHandlerPathFeature : Microsoft.AspNetCore.Diagnostics.IExceptionHandlerFeature
            {
                string Path { get; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.IStatusCodePagesFeature` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IStatusCodePagesFeature
            {
                bool Enabled { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.IStatusCodeReExecuteFeature` in `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IStatusCodeReExecuteFeature
            {
                string OriginalPath { get; set; }
                string OriginalPathBase { get; set; }
                string OriginalQueryString { get; set; }
            }

        }
    }
}
