// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Analyzers, Version=7.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Components
        {
            namespace Analyzers
            {
                public sealed class ComponentParameterAnalyzer : Microsoft.CodeAnalysis.Diagnostics.DiagnosticAnalyzer
                {
                    public ComponentParameterAnalyzer() => throw null;
                    public override void Initialize(Microsoft.CodeAnalysis.Diagnostics.AnalysisContext context) => throw null;
                    public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.DiagnosticDescriptor> SupportedDiagnostics { get => throw null; }
                }
                public class ComponentParametersShouldBePublicCodeFixProvider : Microsoft.CodeAnalysis.CodeFixes.CodeFixProvider
                {
                    public ComponentParametersShouldBePublicCodeFixProvider() => throw null;
                    public override System.Collections.Immutable.ImmutableArray<string> FixableDiagnosticIds { get => throw null; }
                    public override sealed Microsoft.CodeAnalysis.CodeFixes.FixAllProvider GetFixAllProvider() => throw null;
                    public override sealed System.Threading.Tasks.Task RegisterCodeFixesAsync(Microsoft.CodeAnalysis.CodeFixes.CodeFixContext context) => throw null;
                }
                public class ComponentParameterUsageAnalyzer : Microsoft.CodeAnalysis.Diagnostics.DiagnosticAnalyzer
                {
                    public ComponentParameterUsageAnalyzer() => throw null;
                    public override void Initialize(Microsoft.CodeAnalysis.Diagnostics.AnalysisContext context) => throw null;
                    public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.DiagnosticDescriptor> SupportedDiagnostics { get => throw null; }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace Internal
        {
            public class ComponentInternalUsageDiagnosticAnalyzer : Microsoft.CodeAnalysis.Diagnostics.DiagnosticAnalyzer
            {
                public ComponentInternalUsageDiagnosticAnalyzer() => throw null;
                public override void Initialize(Microsoft.CodeAnalysis.Diagnostics.AnalysisContext context) => throw null;
                public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.DiagnosticDescriptor> SupportedDiagnostics { get => throw null; }
            }
        }
    }
}
