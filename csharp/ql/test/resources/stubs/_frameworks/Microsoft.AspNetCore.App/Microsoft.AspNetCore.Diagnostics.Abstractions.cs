// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Diagnostics.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Diagnostics
        {
            public class CompilationFailure
            {
                public string CompiledContent { get => throw null; }
                public CompilationFailure(string sourceFilePath, string sourceFileContent, string compiledContent, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.DiagnosticMessage> messages) => throw null;
                public CompilationFailure(string sourceFilePath, string sourceFileContent, string compiledContent, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.DiagnosticMessage> messages, string failureSummary) => throw null;
                public string FailureSummary { get => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.DiagnosticMessage> Messages { get => throw null; }
                public string SourceFileContent { get => throw null; }
                public string SourceFilePath { get => throw null; }
            }
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
            public class ErrorContext
            {
                public ErrorContext(Microsoft.AspNetCore.Http.HttpContext httpContext, System.Exception exception) => throw null;
                public System.Exception Exception { get => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
            }
            public interface ICompilationException
            {
                System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.CompilationFailure> CompilationFailures { get; }
            }
            public interface IDeveloperPageExceptionFilter
            {
                System.Threading.Tasks.Task HandleExceptionAsync(Microsoft.AspNetCore.Diagnostics.ErrorContext errorContext, System.Func<Microsoft.AspNetCore.Diagnostics.ErrorContext, System.Threading.Tasks.Task> next);
            }
            public interface IExceptionHandlerFeature
            {
                virtual Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; }
                System.Exception Error { get; }
                virtual string Path { get => throw null; }
                virtual Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
            }
            public interface IExceptionHandlerPathFeature : Microsoft.AspNetCore.Diagnostics.IExceptionHandlerFeature
            {
                virtual string Path { get => throw null; }
            }
            public interface IStatusCodePagesFeature
            {
                bool Enabled { get; set; }
            }
            public interface IStatusCodeReExecuteFeature
            {
                virtual Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; }
                string OriginalPath { get; set; }
                string OriginalPathBase { get; set; }
                string OriginalQueryString { get; set; }
                virtual int OriginalStatusCode { get => throw null; }
                virtual Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; }
            }
        }
    }
}
