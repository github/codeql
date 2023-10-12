// This file contains auto-generated code.
// Generated from `Microsoft.Interop.LibraryImportGenerator, Version=7.0.8.36312, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Interop
    {
        namespace Analyzers
        {
            public class AddDisableRuntimeMarshallingAttributeFixer : Microsoft.CodeAnalysis.CodeFixes.CodeFixProvider
            {
                public AddDisableRuntimeMarshallingAttributeFixer() => throw null;
                public override System.Collections.Immutable.ImmutableArray<string> FixableDiagnosticIds { get => throw null; }
                public override Microsoft.CodeAnalysis.CodeFixes.FixAllProvider GetFixAllProvider() => throw null;
                public override System.Threading.Tasks.Task RegisterCodeFixesAsync(Microsoft.CodeAnalysis.CodeFixes.CodeFixContext context) => throw null;
            }
            public class ConvertToLibraryImportAnalyzer : Microsoft.CodeAnalysis.Diagnostics.DiagnosticAnalyzer
            {
                public const string CharSet = default;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ConvertToLibraryImport;
                public ConvertToLibraryImportAnalyzer() => throw null;
                public const string ExactSpelling = default;
                public override void Initialize(Microsoft.CodeAnalysis.Diagnostics.AnalysisContext context) => throw null;
                public const string MayRequireAdditionalWork = default;
                public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.DiagnosticDescriptor> SupportedDiagnostics { get => throw null; }
            }
            public sealed class ConvertToLibraryImportFixer : Microsoft.CodeAnalysis.CodeFixes.CodeFixProvider
            {
                public ConvertToLibraryImportFixer() => throw null;
                public override System.Collections.Immutable.ImmutableArray<string> FixableDiagnosticIds { get => throw null; }
                public override Microsoft.CodeAnalysis.CodeFixes.FixAllProvider GetFixAllProvider() => throw null;
                public override System.Threading.Tasks.Task RegisterCodeFixesAsync(Microsoft.CodeAnalysis.CodeFixes.CodeFixContext context) => throw null;
            }
            public class CustomMarshallerAttributeAnalyzer : Microsoft.CodeAnalysis.Diagnostics.DiagnosticAnalyzer
            {
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor CallerAllocFromManagedMustHaveBufferSizeRule;
                public CustomMarshallerAttributeAnalyzer() => throw null;
                public static class DefaultMarshalModeDiagnostics
                {
                    public static Microsoft.CodeAnalysis.DiagnosticDescriptor GetDefaultMarshalModeDiagnostic(Microsoft.CodeAnalysis.DiagnosticDescriptor errorDescriptor) => throw null;
                }
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ElementMarshallerCannotBeStatefulRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ElementTypesOfReturnTypesMustMatchRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor FirstParameterMustMatchReturnTypeRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor FirstParametersMustMatchRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor FromUnmanagedOverloadsNotSupportedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor GetPinnableReferenceReturnTypeBlittableRule;
                public override void Initialize(Microsoft.CodeAnalysis.Diagnostics.AnalysisContext context) => throw null;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor LinearCollectionInRequiresCollectionMethodsRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor LinearCollectionOutRequiresCollectionMethodsRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ManagedTypeMustBeClosedOrMatchArityRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ManagedTypeMustBeNonNullRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallerTypeMustBeClosedOrMatchArityRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallerTypeMustBeNonNullRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallerTypeMustBeStaticClassOrStructRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallerTypeMustSpecifyManagedTypeRule;
                public static class MissingMemberNames
                {
                    public static System.Collections.Immutable.ImmutableDictionary<string, string> CreateDiagnosticPropertiesForMissingMembersDiagnostic(Microsoft.Interop.MarshalMode mode, params string[] missingMemberNames) => throw null;
                    public static System.Collections.Immutable.ImmutableDictionary<string, string> CreateDiagnosticPropertiesForMissingMembersDiagnostic(Microsoft.Interop.MarshalMode mode, System.Collections.Generic.IEnumerable<string> missingMemberNames) => throw null;
                    public const char Delimiter = default;
                    public const string Key = default;
                    public const string MarshalModeKey = default;
                }
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor OutRequiresToManagedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnTypeMustBeExpectedTypeRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnTypesMustMatchRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatefulMarshallerRequiresFreeRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatefulMarshallerRequiresFromManagedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatefulMarshallerRequiresFromUnmanagedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatefulMarshallerRequiresToManagedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatefulMarshallerRequiresToUnmanagedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessLinearCollectionCallerAllocFromManagedMustHaveBufferSizeRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessLinearCollectionInRequiresCollectionMethodsRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessLinearCollectionOutRequiresCollectionMethodsRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessLinearCollectionRequiresTwoParameterAllocateContainerForManagedElementsRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessLinearCollectionRequiresTwoParameterAllocateContainerForUnmanagedElementsRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessRequiresConvertToManagedRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor StatelessValueInRequiresConvertToUnmanagedRule;
                public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.DiagnosticDescriptor> SupportedDiagnostics { get => throw null; }
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor TypeMustHaveExplicitCastFromVoidPointerRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor UnmanagedTypeMustBeUnmanagedRule;
            }
            public class CustomMarshallerAttributeFixer : Microsoft.CodeAnalysis.CodeFixes.CodeFixProvider
            {
                public CustomMarshallerAttributeFixer() => throw null;
                public override System.Collections.Immutable.ImmutableArray<string> FixableDiagnosticIds { get => throw null; }
                public override Microsoft.CodeAnalysis.CodeFixes.FixAllProvider GetFixAllProvider() => throw null;
                public override System.Threading.Tasks.Task RegisterCodeFixesAsync(Microsoft.CodeAnalysis.CodeFixes.CodeFixContext context) => throw null;
            }
            public struct DiagnosticReporter
            {
                public void CreateAndReportDiagnostic(Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, params object[] messageArgs) => throw null;
                public void CreateAndReportDiagnostic(Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, System.Collections.Immutable.ImmutableDictionary<string, string> properties, params object[] messageArgs) => throw null;
                public static Microsoft.Interop.Analyzers.DiagnosticReporter CreateForLocation(Microsoft.CodeAnalysis.Location location, System.Action<Microsoft.CodeAnalysis.Diagnostic> reportDiagnostic) => throw null;
                public DiagnosticReporter(System.Action<Microsoft.CodeAnalysis.DiagnosticDescriptor, System.Collections.Immutable.ImmutableDictionary<string, string>, object[]> createAndReportDiagnostic) => throw null;
            }
            public class NativeMarshallingAttributeAnalyzer : Microsoft.CodeAnalysis.Diagnostics.DiagnosticAnalyzer
            {
                public NativeMarshallingAttributeAnalyzer() => throw null;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor GenericEntryPointMarshallerTypeMustBeClosedOrMatchArityRule;
                public override void Initialize(Microsoft.CodeAnalysis.Diagnostics.AnalysisContext context) => throw null;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallerEntryPointTypeMustBeNonNullRule;
                public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallerEntryPointTypeMustHaveCustomMarshallerAttributeWithMatchingManagedTypeRule;
                public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.DiagnosticDescriptor> SupportedDiagnostics { get => throw null; }
            }
            public class ShapeBreakingDiagnosticSuppressor : Microsoft.CodeAnalysis.Diagnostics.DiagnosticSuppressor
            {
                public ShapeBreakingDiagnosticSuppressor() => throw null;
                public static readonly Microsoft.CodeAnalysis.SuppressionDescriptor MarkMethodsAsStaticSuppression;
                public override void ReportSuppressions(Microsoft.CodeAnalysis.Diagnostics.SuppressionAnalysisContext context) => throw null;
                public override System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.SuppressionDescriptor> SupportedSuppressions { get => throw null; }
            }
        }
        public class GeneratorDiagnostics : Microsoft.Interop.IGeneratorDiagnostics
        {
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor CannotForwardToDllImport;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ConfigurationValueNotSupported;
            public GeneratorDiagnostics() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.Diagnostic> Diagnostics { get => throw null; }
            public class Ids
            {
                public const string CannotForwardToDllImport = default;
                public const string ConfigurationNotSupported = default;
                public Ids() => throw null;
                public const string InvalidLibraryImportAttributeUsage = default;
                public const string Prefix = default;
                public const string RequiresAllowUnsafeBlocks = default;
                public const string TypeNotSupported = default;
            }
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidAttributedMethodContainingTypeMissingModifiers;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidAttributedMethodSignature;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor InvalidStringMarshallingConfiguration;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor MarshallingAttributeConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ParameterConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ParameterTypeNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ParameterTypeNotSupportedWithDetails;
            public void ReportCannotForwardToDllImport(Microsoft.Interop.MethodSignatureDiagnosticLocations method, string name, string value = default(string)) => throw null;
            public void ReportConfigurationNotSupported(Microsoft.CodeAnalysis.AttributeData attributeData, string configurationName, string unsupportedValue = default(string)) => throw null;
            public void ReportInvalidMarshallingAttributeInfo(Microsoft.CodeAnalysis.AttributeData attributeData, string reasonResourceName, params string[] reasonArgs) => throw null;
            public void ReportInvalidStringMarshallingConfiguration(Microsoft.CodeAnalysis.AttributeData attributeData, string methodName, string detailsMessage) => throw null;
            public void ReportMarshallingNotSupported(Microsoft.Interop.MethodSignatureDiagnosticLocations diagnosticLocations, Microsoft.Interop.TypePositionInfo info, string notSupportedDetails, System.Collections.Immutable.ImmutableDictionary<string, string> diagnosticProperties) => throw null;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor RequiresAllowUnsafeBlocks;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnConfigurationNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnTypeNotSupported;
            public static readonly Microsoft.CodeAnalysis.DiagnosticDescriptor ReturnTypeNotSupportedWithDetails;
        }
        public sealed class LibraryImportGenerator : Microsoft.CodeAnalysis.IIncrementalGenerator
        {
            public LibraryImportGenerator() => throw null;
            public void Initialize(Microsoft.CodeAnalysis.IncrementalGeneratorInitializationContext context) => throw null;
            public static class StepNames
            {
                public const string CalculateStubInformation = default;
                public const string GenerateSingleStub = default;
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
        public static class OptionsHelper
        {
            public const string GenerateForwardersOption = default;
            public const string UseMarshalTypeOption = default;
        }
    }
}
