// This file contains auto-generated code.
// Generated from `Microsoft.Interop.JavaScript.JSImportGenerator, Version=7.0.8.36312, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Interop
    {
        public class GeneratorDiagnostics : Microsoft.Interop.IGeneratorDiagnostics
        {
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ConfigurationValueNotSupported;
            public GeneratorDiagnostics() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.Diagnostic> Diagnostics { get => throw null; }
            public class Ids
            {
                public const string ConfigurationNotSupported = default;
                public Ids() => throw null;
                public const string InvalidJSExportAttributeUsage = default;
                public const string InvalidJSImportAttributeUsage = default;
                public const string JSExportRequiresAllowUnsafeBlocks = default;
                public const string JSImportRequiresAllowUnsafeBlocks = default;
                public const string Prefix = default;
                public const string TypeNotSupported = default;
            }
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidExportAttributedMethodContainingTypeMissingModifiers;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidExportAttributedMethodSignature;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidImportAttributedMethodContainingTypeMissingModifiers;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidImportAttributedMethodSignature;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor JSExportRequiresAllowUnsafeBlocks;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor JSImportRequiresAllowUnsafeBlocks;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallingAttributeConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ParameterConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ParameterTypeNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ParameterTypeNotSupportedWithDetails;
            public void ReportConfigurationNotSupported(Microsoft.CodeAnalysis.AttributeData attributeData, string configurationName, string unsupportedValue = default(string)) => throw null;
            public void ReportInvalidMarshallingAttributeInfo(Microsoft.CodeAnalysis.AttributeData attributeData, string reasonResourceName, params string[] reasonArgs) => throw null;
            public void ReportMarshallingNotSupported(Microsoft.Interop.MethodSignatureDiagnosticLocations diagnosticLocations, Microsoft.Interop.TypePositionInfo info, string notSupportedDetails, System.Collections.Immutable.ImmutableDictionary<string, string> diagnosticProperties) => throw null;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnTypeNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnTypeNotSupportedWithDetails;
        }
        namespace JavaScript
        {
            public sealed class JSExportGenerator : Microsoft.CodeAnalysis.IIncrementalGenerator
            {
                public JSExportGenerator() => throw null;
                public void Initialize(Microsoft.CodeAnalysis.IncrementalGeneratorInitializationContext context) => throw null;
                public static class StepNames
                {
                    public const string CalculateStubInformation = default;
                    public const string GenerateSingleStub = default;
                }
            }
            public sealed class JSImportGenerator : Microsoft.CodeAnalysis.IIncrementalGenerator
            {
                public JSImportGenerator() => throw null;
                public void Initialize(Microsoft.CodeAnalysis.IncrementalGeneratorInitializationContext context) => throw null;
                public static class StepNames
                {
                    public const string CalculateStubInformation = default;
                    public const string GenerateSingleStub = default;
                }
            }
            public sealed class JSMarshallingAttributeInfoParser
            {
                public JSMarshallingAttributeInfoParser(Microsoft.CodeAnalysis.Compilation compilation, Microsoft.Interop.IGeneratorDiagnostics diagnostics, Microsoft.CodeAnalysis.ISymbol contextSymbol) => throw null;
                public Microsoft.Interop.MarshallingInfo ParseMarshallingInfo(Microsoft.CodeAnalysis.ITypeSymbol managedType, System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.AttributeData> useSiteAttributes, Microsoft.Interop.MarshallingInfo inner) => throw null;
            }
            public static class OptionsHelper
            {
                public const string EnableJSExportOption = default;
                public const string EnableJSImportOption = default;
            }
        }
        public sealed class MethodSignatureDiagnosticLocations : System.IEquatable<Microsoft.Interop.MethodSignatureDiagnosticLocations>
        {
            public Microsoft.Interop.MethodSignatureDiagnosticLocations<Clone>$() => throw null;
public MethodSignatureDiagnosticLocations(string MethodIdentifier, System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.Location> ManagedParameterLocations, Microsoft.CodeAnalysis.Location FallbackLocation) => throw null;
            public MethodSignatureDiagnosticLocations(Microsoft.CodeAnalysis.CSharp.Syntax.MethodDeclarationSyntax syntax) => throw null;
            public void Deconstruct(out string MethodIdentifier, out System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.Location> ManagedParameterLocations, out Microsoft.CodeAnalysis.Location FallbackLocation) => throw null;
            public bool Equals(Microsoft.Interop.MethodSignatureDiagnosticLocations other) => throw null;
            public override bool Equals(object obj) => throw null;
            public Microsoft.CodeAnalysis.Location FallbackLocation { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.Location> ManagedParameterLocations { get => throw null; set { } }
            public string MethodIdentifier { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.MethodSignatureDiagnosticLocations left, Microsoft.Interop.MethodSignatureDiagnosticLocations right) => throw null;
            public static bool operator !=(Microsoft.Interop.MethodSignatureDiagnosticLocations left, Microsoft.Interop.MethodSignatureDiagnosticLocations right) => throw null;
            public override string ToString() => throw null;
        }
    }
}
