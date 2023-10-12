// This file contains auto-generated code.
// Generated from `Microsoft.Interop.SourceGeneration, Version=7.0.8.36312, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Interop
    {
        public class AttributedMarshallingModelGeneratorFactory : Microsoft.Interop.IMarshallingGeneratorFactory
        {
            public Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public AttributedMarshallingModelGeneratorFactory(Microsoft.Interop.IMarshallingGeneratorFactory innerMarshallingGenerator, Microsoft.Interop.AttributedMarshallingModelOptions options) => throw null;
            public AttributedMarshallingModelGeneratorFactory(Microsoft.Interop.IMarshallingGeneratorFactory innerMarshallingGenerator, Microsoft.Interop.IMarshallingGeneratorFactory elementMarshallingGenerator, Microsoft.Interop.AttributedMarshallingModelOptions options) => throw null;
        }
        public struct AttributedMarshallingModelOptions : System.IEquatable<Microsoft.Interop.AttributedMarshallingModelOptions>
        {
            public AttributedMarshallingModelOptions(bool RuntimeMarshallingDisabled, Microsoft.Interop.MarshalMode InMode, Microsoft.Interop.MarshalMode RefMode, Microsoft.Interop.MarshalMode OutMode) => throw null;
            public void Deconstruct(out bool RuntimeMarshallingDisabled, out Microsoft.Interop.MarshalMode InMode, out Microsoft.Interop.MarshalMode RefMode, out Microsoft.Interop.MarshalMode OutMode) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.AttributedMarshallingModelOptions other) => throw null;
            public override int GetHashCode() => throw null;
            public Microsoft.Interop.MarshalMode InMode { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.AttributedMarshallingModelOptions left, Microsoft.Interop.AttributedMarshallingModelOptions right) => throw null;
            public static bool operator !=(Microsoft.Interop.AttributedMarshallingModelOptions left, Microsoft.Interop.AttributedMarshallingModelOptions right) => throw null;
            public Microsoft.Interop.MarshalMode OutMode { get => throw null; set { } }
            public Microsoft.Interop.MarshalMode RefMode { get => throw null; set { } }
            public bool RuntimeMarshallingDisabled { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public sealed class BlittableMarshaller : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            public BlittableMarshaller() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public abstract class BoolMarshallerBase : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            protected BoolMarshallerBase(Microsoft.CodeAnalysis.CSharp.Syntax.PredefinedTypeSyntax nativeType, int trueValue, int falseValue, bool compareToTrue) => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public struct BoundGenerator : System.IEquatable<Microsoft.Interop.BoundGenerator>
        {
            public BoundGenerator(Microsoft.Interop.TypePositionInfo TypeInfo, Microsoft.Interop.IMarshallingGenerator Generator) => throw null;
            public void Deconstruct(out Microsoft.Interop.TypePositionInfo TypeInfo, out Microsoft.Interop.IMarshallingGenerator Generator) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.BoundGenerator other) => throw null;
            public Microsoft.Interop.IMarshallingGenerator Generator { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.BoundGenerator left, Microsoft.Interop.BoundGenerator right) => throw null;
            public static bool operator !=(Microsoft.Interop.BoundGenerator left, Microsoft.Interop.BoundGenerator right) => throw null;
            public override string ToString() => throw null;
            public Microsoft.Interop.TypePositionInfo TypeInfo { get => throw null; set { } }
        }
        public class BoundGenerators
        {
            public System.Collections.Immutable.ImmutableArray<Microsoft.Interop.BoundGenerator> AllMarshallers { get => throw null; }
            public BoundGenerators(System.Collections.Immutable.ImmutableArray<Microsoft.Interop.TypePositionInfo> elementTypeInfo, System.Func<Microsoft.Interop.TypePositionInfo, Microsoft.Interop.IMarshallingGenerator> generatorFactoryCallback) => throw null;
            public (Microsoft.CodeAnalysis.CSharp.Syntax.ParameterListSyntax ParameterList, Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax ReturnType, Microsoft.CodeAnalysis.CSharp.Syntax.AttributeListSyntax ReturnTypeAttributes) GenerateTargetMethodSignatureData() => throw null;
            public bool IsManagedVoidReturn { get => throw null; }
            public bool ManagedNativeSameReturn { get => throw null; }
            public Microsoft.Interop.BoundGenerator ManagedReturnMarshaller { get => throw null; }
            public System.Collections.Immutable.ImmutableArray<Microsoft.Interop.BoundGenerator> NativeParameterMarshallers { get => throw null; }
            public Microsoft.Interop.BoundGenerator NativeReturnMarshaller { get => throw null; }
        }
        public sealed class ByteBoolMarshaller : Microsoft.Interop.BoolMarshallerBase
        {
            public ByteBoolMarshaller(bool signed) : base(default(Microsoft.CodeAnalysis.CSharp.Syntax.PredefinedTypeSyntax), default(int), default(int), default(bool)) => throw null;
        }
        [System.Flags]
        public enum ByValueContentsMarshalKind
        {
            Default = 0,
            In = 1,
            Out = 2,
            InOut = 3,
        }
        public class ByValueContentsMarshalKindValidator : Microsoft.Interop.IMarshallingGeneratorFactory
        {
            public Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public ByValueContentsMarshalKindValidator(Microsoft.Interop.IMarshallingGeneratorFactory inner) => throw null;
        }
        public enum CharEncoding
        {
            Undefined = 0,
            Utf8 = 1,
            Utf16 = 2,
            Custom = 3,
        }
        public sealed class CharMarshallingGeneratorFactory : Microsoft.Interop.IMarshallingGeneratorFactory
        {
            public Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public CharMarshallingGeneratorFactory(Microsoft.Interop.IMarshallingGeneratorFactory inner, bool useBlittableMarshallerForUtf16) => throw null;
        }
        public static partial class CompilationExtensions
        {
            public static Microsoft.Interop.StubEnvironment CreateStubEnvironment(this Microsoft.CodeAnalysis.Compilation compilation) => throw null;
        }
        public sealed class ConstSizeCountInfo : Microsoft.Interop.CountInfo, System.IEquatable<Microsoft.Interop.ConstSizeCountInfo>
        {
            public override Microsoft.Interop.CountInfo<Clone>$() => throw null;
public ConstSizeCountInfo(int Size) : base(default(Microsoft.Interop.CountInfo)) => throw null;
            public void Deconstruct(out int Size) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.CountInfo other) => throw null;
            public bool Equals(Microsoft.Interop.ConstSizeCountInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.ConstSizeCountInfo left, Microsoft.Interop.ConstSizeCountInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.ConstSizeCountInfo left, Microsoft.Interop.ConstSizeCountInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public int Size { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public struct ContainingSyntax : System.IEquatable<Microsoft.Interop.ContainingSyntax>
        {
            public ContainingSyntax(Microsoft.CodeAnalysis.SyntaxTokenList Modifiers, Microsoft.CodeAnalysis.CSharp.SyntaxKind TypeKind, Microsoft.CodeAnalysis.SyntaxToken Identifier, Microsoft.CodeAnalysis.CSharp.Syntax.TypeParameterListSyntax TypeParameters) => throw null;
            public void Deconstruct(out Microsoft.CodeAnalysis.SyntaxTokenList Modifiers, out Microsoft.CodeAnalysis.CSharp.SyntaxKind TypeKind, out Microsoft.CodeAnalysis.SyntaxToken Identifier, out Microsoft.CodeAnalysis.CSharp.Syntax.TypeParameterListSyntax TypeParameters) => throw null;
            public bool Equals(Microsoft.Interop.ContainingSyntax other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public Microsoft.CodeAnalysis.SyntaxToken Identifier { get => throw null; set { } }
            public Microsoft.CodeAnalysis.SyntaxTokenList Modifiers { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.ContainingSyntax left, Microsoft.Interop.ContainingSyntax right) => throw null;
            public static bool operator !=(Microsoft.Interop.ContainingSyntax left, Microsoft.Interop.ContainingSyntax right) => throw null;
            public override string ToString() => throw null;
            public Microsoft.CodeAnalysis.CSharp.SyntaxKind TypeKind { get => throw null; set { } }
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeParameterListSyntax TypeParameters { get => throw null; set { } }
        }
        public sealed class ContainingSyntaxContext : System.IEquatable<Microsoft.Interop.ContainingSyntaxContext>
        {
            public Microsoft.Interop.ContainingSyntaxContext<Clone>$() => throw null;
public Microsoft.Interop.ContainingSyntaxContext AddContainingSyntax(Microsoft.Interop.ContainingSyntax nestedType) => throw null;
            public string ContainingNamespace { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.Interop.ContainingSyntax> ContainingSyntax { get => throw null; set { } }
            public ContainingSyntaxContext(System.Collections.Immutable.ImmutableArray<Microsoft.Interop.ContainingSyntax> ContainingSyntax, string ContainingNamespace) => throw null;
            public ContainingSyntaxContext(Microsoft.CodeAnalysis.CSharp.Syntax.MemberDeclarationSyntax memberDeclaration) => throw null;
            public void Deconstruct(out System.Collections.Immutable.ImmutableArray<Microsoft.Interop.ContainingSyntax> ContainingSyntax, out string ContainingNamespace) => throw null;
            public bool Equals(Microsoft.Interop.ContainingSyntaxContext other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.ContainingSyntaxContext left, Microsoft.Interop.ContainingSyntaxContext right) => throw null;
            public static bool operator !=(Microsoft.Interop.ContainingSyntaxContext left, Microsoft.Interop.ContainingSyntaxContext right) => throw null;
            public override string ToString() => throw null;
            public Microsoft.CodeAnalysis.CSharp.Syntax.MemberDeclarationSyntax WrapMemberInContainingSyntaxWithUnsafeModifier(Microsoft.CodeAnalysis.CSharp.Syntax.MemberDeclarationSyntax member) => throw null;
        }
        public sealed class CountElementCountInfo : Microsoft.Interop.CountInfo, System.IEquatable<Microsoft.Interop.CountElementCountInfo>
        {
            public override Microsoft.Interop.CountInfo<Clone>$() => throw null;
public CountElementCountInfo(Microsoft.Interop.TypePositionInfo ElementInfo) : base(default(Microsoft.Interop.CountInfo)) => throw null;
            public void Deconstruct(out Microsoft.Interop.TypePositionInfo ElementInfo) => throw null;
            public Microsoft.Interop.TypePositionInfo ElementInfo { get => throw null; set { } }
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.CountInfo other) => throw null;
            public bool Equals(Microsoft.Interop.CountElementCountInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.CountElementCountInfo left, Microsoft.Interop.CountElementCountInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.CountElementCountInfo left, Microsoft.Interop.CountElementCountInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public const string ReturnValueElementName = default;
            public override string ToString() => throw null;
        }
        public abstract class CountInfo : System.IEquatable<Microsoft.Interop.CountInfo>
        {
            public abstract Microsoft.Interop.CountInfo<Clone>$();
protected CountInfo(Microsoft.Interop.CountInfo original) => throw null;
            protected virtual System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public virtual bool Equals(Microsoft.Interop.CountInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.CountInfo left, Microsoft.Interop.CountInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.CountInfo left, Microsoft.Interop.CountInfo right) => throw null;
            protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public struct CustomTypeMarshallerData : System.IEquatable<Microsoft.Interop.CustomTypeMarshallerData>
        {
            public Microsoft.Interop.ManagedTypeInfo BufferElementType { get => throw null; set { } }
            public Microsoft.Interop.MarshallingInfo CollectionElementMarshallingInfo { get => throw null; set { } }
            public Microsoft.Interop.ManagedTypeInfo CollectionElementType { get => throw null; set { } }
            public CustomTypeMarshallerData(Microsoft.Interop.ManagedTypeInfo MarshallerType, Microsoft.Interop.ManagedTypeInfo NativeType, bool HasState, Microsoft.Interop.MarshallerShape Shape, bool IsStrictlyBlittable, Microsoft.Interop.ManagedTypeInfo BufferElementType, Microsoft.Interop.ManagedTypeInfo CollectionElementType, Microsoft.Interop.MarshallingInfo CollectionElementMarshallingInfo) => throw null;
            public void Deconstruct(out Microsoft.Interop.ManagedTypeInfo MarshallerType, out Microsoft.Interop.ManagedTypeInfo NativeType, out bool HasState, out Microsoft.Interop.MarshallerShape Shape, out bool IsStrictlyBlittable, out Microsoft.Interop.ManagedTypeInfo BufferElementType, out Microsoft.Interop.ManagedTypeInfo CollectionElementType, out Microsoft.Interop.MarshallingInfo CollectionElementMarshallingInfo) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.CustomTypeMarshallerData other) => throw null;
            public override int GetHashCode() => throw null;
            public bool HasState { get => throw null; set { } }
            public bool IsStrictlyBlittable { get => throw null; set { } }
            public Microsoft.Interop.ManagedTypeInfo MarshallerType { get => throw null; set { } }
            public Microsoft.Interop.ManagedTypeInfo NativeType { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.CustomTypeMarshallerData left, Microsoft.Interop.CustomTypeMarshallerData right) => throw null;
            public static bool operator !=(Microsoft.Interop.CustomTypeMarshallerData left, Microsoft.Interop.CustomTypeMarshallerData right) => throw null;
            public Microsoft.Interop.MarshallerShape Shape { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public struct CustomTypeMarshallers : System.IEquatable<Microsoft.Interop.CustomTypeMarshallers>
        {
            public CustomTypeMarshallers(System.Collections.Immutable.ImmutableDictionary<Microsoft.Interop.MarshalMode, Microsoft.Interop.CustomTypeMarshallerData> Modes) => throw null;
            public void Deconstruct(out System.Collections.Immutable.ImmutableDictionary<Microsoft.Interop.MarshalMode, Microsoft.Interop.CustomTypeMarshallerData> Modes) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.CustomTypeMarshallers other) => throw null;
            public override int GetHashCode() => throw null;
            public Microsoft.Interop.CustomTypeMarshallerData GetModeOrDefault(Microsoft.Interop.MarshalMode mode) => throw null;
            public bool IsDefinedOrDefault(Microsoft.Interop.MarshalMode mode) => throw null;
            public System.Collections.Immutable.ImmutableDictionary<Microsoft.Interop.MarshalMode, Microsoft.Interop.CustomTypeMarshallerData> Modes { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.CustomTypeMarshallers left, Microsoft.Interop.CustomTypeMarshallers right) => throw null;
            public static bool operator !=(Microsoft.Interop.CustomTypeMarshallers left, Microsoft.Interop.CustomTypeMarshallers right) => throw null;
            public override string ToString() => throw null;
            public bool TryGetModeOrDefault(Microsoft.Interop.MarshalMode mode, out Microsoft.Interop.CustomTypeMarshallerData data) => throw null;
        }
        [System.Flags]
        public enum CustomTypeMarshallingDirection
        {
            None = 0,
            In = 1,
            Out = 2,
            Ref = 3,
        }
        public sealed class DefaultMarshallingInfo : System.IEquatable<Microsoft.Interop.DefaultMarshallingInfo>
        {
            public Microsoft.Interop.DefaultMarshallingInfo<Clone>$() => throw null;
public Microsoft.Interop.CharEncoding CharEncoding { get => throw null; set { } }
            public DefaultMarshallingInfo(Microsoft.Interop.CharEncoding CharEncoding, Microsoft.CodeAnalysis.INamedTypeSymbol StringMarshallingCustomType) => throw null;
            public void Deconstruct(out Microsoft.Interop.CharEncoding CharEncoding, out Microsoft.CodeAnalysis.INamedTypeSymbol StringMarshallingCustomType) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.DefaultMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.DefaultMarshallingInfo left, Microsoft.Interop.DefaultMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.DefaultMarshallingInfo left, Microsoft.Interop.DefaultMarshallingInfo right) => throw null;
            public Microsoft.CodeAnalysis.INamedTypeSymbol StringMarshallingCustomType { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public sealed class DelegateMarshaller : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            public DelegateMarshaller() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public sealed class DelegateTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.DelegateTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public DelegateTypeInfo(string FullTypeName, string DiagnosticFormattedName) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.DelegateTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.DelegateTypeInfo left, Microsoft.Interop.DelegateTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.DelegateTypeInfo left, Microsoft.Interop.DelegateTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public static partial class DiagnosticExtensions
        {
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this Microsoft.CodeAnalysis.ISymbol symbol, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this Microsoft.CodeAnalysis.ISymbol symbol, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, System.Collections.Immutable.ImmutableDictionary<string, string> properties, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this Microsoft.CodeAnalysis.AttributeData attributeData, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this Microsoft.CodeAnalysis.AttributeData attributeData, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, System.Collections.Immutable.ImmutableDictionary<string, string> properties, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.Location> locations, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.Location> locations, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, System.Collections.Immutable.ImmutableDictionary<string, string> properties, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this Microsoft.CodeAnalysis.Location location, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, params object[] args) => throw null;
            public static Microsoft.CodeAnalysis.Diagnostic CreateDiagnostic(this Microsoft.CodeAnalysis.Location location, Microsoft.CodeAnalysis.DiagnosticDescriptor descriptor, System.Collections.Immutable.ImmutableDictionary<string, string> properties, params object[] args) => throw null;
        }
        public sealed class EnumTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.EnumTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public EnumTypeInfo(string FullTypeName, string DiagnosticFormattedName, Microsoft.CodeAnalysis.SpecialType UnderlyingType) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName, out Microsoft.CodeAnalysis.SpecialType UnderlyingType) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.EnumTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.EnumTypeInfo left, Microsoft.Interop.EnumTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.EnumTypeInfo left, Microsoft.Interop.EnumTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
            public Microsoft.CodeAnalysis.SpecialType UnderlyingType { get => throw null; set { } }
        }
        public sealed class Forwarder : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Forwarder() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public struct GeneratedStatements
        {
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Cleanup { get => throw null; set { } }
            public static Microsoft.Interop.GeneratedStatements Create(Microsoft.Interop.BoundGenerators marshallers, Microsoft.Interop.StubCodeContext context, Microsoft.CodeAnalysis.CSharp.Syntax.ExpressionSyntax expressionToInvoke) => throw null;
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> GuaranteedUnmarshal { get => throw null; set { } }
            public Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax InvokeStatement { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Marshal { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> NotifyForSuccessfulInvoke { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.FixedStatementSyntax> Pin { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> PinnedMarshal { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Setup { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Unmarshal { get => throw null; set { } }
        }
        public class GeneratorDiagnosticProperties
        {
            public const string AddDisableRuntimeMarshallingAttribute = default;
            public GeneratorDiagnosticProperties() => throw null;
        }
        public interface IGeneratorDiagnostics
        {
            void ReportConfigurationNotSupported(Microsoft.CodeAnalysis.AttributeData attributeData, string configurationName, string unsupportedValue);
            void ReportInvalidMarshallingAttributeInfo(Microsoft.CodeAnalysis.AttributeData attributeData, string reasonResourceName, params string[] reasonArgs);
        }
        public static partial class IGeneratorDiagnosticsExtensions
        {
            public static void ReportConfigurationNotSupported(this Microsoft.Interop.IGeneratorDiagnostics diagnostics, Microsoft.CodeAnalysis.AttributeData attributeData, string configurationName) => throw null;
        }
        public interface IMarshallingGenerator
        {
            Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info);
            System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context);
            Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info);
            Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context);
            bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version);
            bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context);
            bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context);
        }
        public interface IMarshallingGeneratorFactory
        {
            Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context);
        }
        public static partial class IncrementalGeneratorInitializationContextExtensions
        {
            public static Microsoft.CodeAnalysis.IncrementalValueProvider<Microsoft.Interop.StubEnvironment> CreateStubEnvironmentProvider(this Microsoft.CodeAnalysis.IncrementalGeneratorInitializationContext context) => throw null;
            public static void RegisterConcatenatedSyntaxOutputs<TNode>(this Microsoft.CodeAnalysis.IncrementalGeneratorInitializationContext context, Microsoft.CodeAnalysis.IncrementalValuesProvider<TNode> nodes, string fileName) where TNode : Microsoft.CodeAnalysis.SyntaxNode => throw null;
            public static void RegisterDiagnostics(this Microsoft.CodeAnalysis.IncrementalGeneratorInitializationContext context, Microsoft.CodeAnalysis.IncrementalValuesProvider<Microsoft.CodeAnalysis.Diagnostic> diagnostics) => throw null;
        }
        public class InteropAttributeData : System.IEquatable<Microsoft.Interop.InteropAttributeData>
        {
            public virtual Microsoft.Interop.InteropAttributeData<Clone>$() => throw null;
protected InteropAttributeData(Microsoft.Interop.InteropAttributeData original) => throw null;
            public InteropAttributeData() => throw null;
            protected virtual System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public virtual bool Equals(Microsoft.Interop.InteropAttributeData other) => throw null;
            public override int GetHashCode() => throw null;
            public Microsoft.Interop.InteropAttributeMember IsUserDefined { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.InteropAttributeData left, Microsoft.Interop.InteropAttributeData right) => throw null;
            public static bool operator !=(Microsoft.Interop.InteropAttributeData left, Microsoft.Interop.InteropAttributeData right) => throw null;
            protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public bool SetLastError { get => throw null; set { } }
            public Microsoft.Interop.StringMarshalling StringMarshalling { get => throw null; set { } }
            public Microsoft.CodeAnalysis.INamedTypeSymbol StringMarshallingCustomType { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public static partial class InteropAttributeDataExtensions
        {
            public static T WithValuesFromNamedArguments<T>(this T t, System.Collections.Immutable.ImmutableDictionary<string, Microsoft.CodeAnalysis.TypedConstant> namedArguments) where T : Microsoft.Interop.InteropAttributeData => throw null;
        }
        [System.Flags]
        public enum InteropAttributeMember
        {
            None = 0,
            SetLastError = 1,
            StringMarshalling = 2,
            StringMarshallingCustomType = 4,
            All = -1,
        }
        public struct InteropGenerationOptions : System.IEquatable<Microsoft.Interop.InteropGenerationOptions>
        {
            public InteropGenerationOptions(bool UseMarshalType) => throw null;
            public void Deconstruct(out bool UseMarshalType) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.InteropGenerationOptions other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.InteropGenerationOptions left, Microsoft.Interop.InteropGenerationOptions right) => throw null;
            public static bool operator !=(Microsoft.Interop.InteropGenerationOptions left, Microsoft.Interop.InteropGenerationOptions right) => throw null;
            public override string ToString() => throw null;
            public bool UseMarshalType { get => throw null; set { } }
        }
        public sealed class ManagedToNativeStubCodeContext : Microsoft.Interop.StubCodeContext, System.IEquatable<Microsoft.Interop.ManagedToNativeStubCodeContext>
        {
            public override Microsoft.Interop.StubCodeContext<Clone>$() => throw null;
public override bool AdditionalTemporaryStateLivesAcrossStages { get => throw null; }
            public ManagedToNativeStubCodeContext(Microsoft.Interop.StubEnvironment environment, string returnIdentifier, string nativeReturnIdentifier) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.StubCodeContext other) => throw null;
            public bool Equals(Microsoft.Interop.ManagedToNativeStubCodeContext other) => throw null;
            public override int GetHashCode() => throw null;
            public override (string managed, string native) GetIdentifiers(Microsoft.Interop.TypePositionInfo info) => throw null;
            public override (Microsoft.Interop.TargetFramework framework, System.Version version) GetTargetFramework() => throw null;
            public static bool operator ==(Microsoft.Interop.ManagedToNativeStubCodeContext left, Microsoft.Interop.ManagedToNativeStubCodeContext right) => throw null;
            public static bool operator !=(Microsoft.Interop.ManagedToNativeStubCodeContext left, Microsoft.Interop.ManagedToNativeStubCodeContext right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override bool SingleFrameSpansNativeContext { get => throw null; }
            public override string ToString() => throw null;
        }
        public abstract class ManagedTypeInfo : System.IEquatable<Microsoft.Interop.ManagedTypeInfo>
        {
            public abstract Microsoft.Interop.ManagedTypeInfo<Clone>$();
public static Microsoft.Interop.ManagedTypeInfo CreateTypeInfoForTypeSymbol(Microsoft.CodeAnalysis.ITypeSymbol type) => throw null;
            protected ManagedTypeInfo(string FullTypeName, string DiagnosticFormattedName) => throw null;
            protected ManagedTypeInfo(Microsoft.Interop.ManagedTypeInfo original) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName) => throw null;
            public string DiagnosticFormattedName { get => throw null; set { } }
            protected virtual System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public virtual bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public string FullTypeName { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.ManagedTypeInfo left, Microsoft.Interop.ManagedTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.ManagedTypeInfo left, Microsoft.Interop.ManagedTypeInfo right) => throw null;
            protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax Syntax { get => throw null; }
            public override string ToString() => throw null;
        }
        public static class ManualTypeMarshallingHelper
        {
            public static bool HasEntryPointMarshallerAttribute(Microsoft.CodeAnalysis.ITypeSymbol entryPointType) => throw null;
            public static bool IsLinearCollectionEntryPoint(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType) => throw null;
            public static class MarshalUsingProperties
            {
                public const string ConstantElementCount = default;
                public const string CountElementName = default;
                public const string ElementIndirectionDepth = default;
            }
            public static bool ModeUsesManagedToUnmanagedShape(Microsoft.Interop.MarshalMode mode) => throw null;
            public static bool ModeUsesUnmanagedToManagedShape(Microsoft.Interop.MarshalMode mode) => throw null;
            public static Microsoft.CodeAnalysis.ITypeSymbol ReplaceGenericPlaceholderInType(Microsoft.CodeAnalysis.ITypeSymbol managedType, Microsoft.CodeAnalysis.INamedTypeSymbol entryType, Microsoft.CodeAnalysis.Compilation compilation) => throw null;
            public static bool TryGetLinearCollectionMarshallersFromEntryType(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol managedType, Microsoft.CodeAnalysis.Compilation compilation, System.Func<Microsoft.CodeAnalysis.ITypeSymbol, Microsoft.Interop.MarshallingInfo> getMarshallingInfo, out Microsoft.Interop.CustomTypeMarshallers? marshallers) => throw null;
            public static bool TryGetLinearCollectionMarshallersFromEntryType(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol managedType, Microsoft.CodeAnalysis.Compilation compilation, System.Func<Microsoft.CodeAnalysis.ITypeSymbol, Microsoft.Interop.MarshallingInfo> getMarshallingInfo, System.Action<Microsoft.CodeAnalysis.INamedTypeSymbol, Microsoft.CodeAnalysis.INamedTypeSymbol> onArityMismatch, out Microsoft.Interop.CustomTypeMarshallers? marshallers) => throw null;
            public static bool TryGetMarshallersFromEntryTypeIgnoringElements(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol managedType, Microsoft.CodeAnalysis.Compilation compilation, System.Action<Microsoft.CodeAnalysis.INamedTypeSymbol, Microsoft.CodeAnalysis.INamedTypeSymbol> onArityMismatch, out Microsoft.Interop.CustomTypeMarshallers? marshallers) => throw null;
            public static bool TryGetValueMarshallersFromEntryType(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol managedType, Microsoft.CodeAnalysis.Compilation compilation, out Microsoft.Interop.CustomTypeMarshallers? marshallers) => throw null;
            public static bool TryGetValueMarshallersFromEntryType(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol managedType, Microsoft.CodeAnalysis.Compilation compilation, System.Action<Microsoft.CodeAnalysis.INamedTypeSymbol, Microsoft.CodeAnalysis.INamedTypeSymbol> onArityMismatch, out Microsoft.Interop.CustomTypeMarshallers? marshallers) => throw null;
            public static bool TryResolveEntryPointType(Microsoft.CodeAnalysis.INamedTypeSymbol managedType, Microsoft.CodeAnalysis.ITypeSymbol typeInAttribute, bool isLinearCollectionMarshalling, System.Action<Microsoft.CodeAnalysis.INamedTypeSymbol, Microsoft.CodeAnalysis.INamedTypeSymbol> onArityMismatch, out Microsoft.CodeAnalysis.ITypeSymbol entryPoint) => throw null;
            public static bool TryResolveManagedType(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol typeInAttribute, bool isLinearCollectionMarshalling, System.Action<Microsoft.CodeAnalysis.INamedTypeSymbol, Microsoft.CodeAnalysis.INamedTypeSymbol> onArityMismatch, out Microsoft.CodeAnalysis.ITypeSymbol managed) => throw null;
            public static bool TryResolveMarshallerType(Microsoft.CodeAnalysis.INamedTypeSymbol entryPointType, Microsoft.CodeAnalysis.ITypeSymbol typeInAttribute, System.Action<Microsoft.CodeAnalysis.INamedTypeSymbol, Microsoft.CodeAnalysis.INamedTypeSymbol> onArityMismatch, out Microsoft.CodeAnalysis.ITypeSymbol marshallerType) => throw null;
        }
        public sealed class MarshalAsInfo : Microsoft.Interop.MarshallingInfoStringSupport, System.IEquatable<Microsoft.Interop.MarshalAsInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public MarshalAsInfo(System.Runtime.InteropServices.UnmanagedType UnmanagedType, Microsoft.Interop.CharEncoding CharEncoding) : base(default(Microsoft.Interop.CharEncoding)) => throw null;
            public void Deconstruct(out System.Runtime.InteropServices.UnmanagedType UnmanagedType, out Microsoft.Interop.CharEncoding CharEncoding) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfoStringSupport other) => throw null;
            public bool Equals(Microsoft.Interop.MarshalAsInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.MarshalAsInfo left, Microsoft.Interop.MarshalAsInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.MarshalAsInfo left, Microsoft.Interop.MarshalAsInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
            public System.Runtime.InteropServices.UnmanagedType UnmanagedType { get => throw null; set { } }
        }
        public sealed class MarshalAsMarshallingGeneratorFactory : Microsoft.Interop.IMarshallingGeneratorFactory
        {
            public Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public MarshalAsMarshallingGeneratorFactory(Microsoft.Interop.InteropGenerationOptions options, Microsoft.Interop.IMarshallingGeneratorFactory inner) => throw null;
        }
        public static class MarshallerHelpers
        {
            public static Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax CreateClearLastSystemErrorStatement(int errorCode) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax CreateGetLastSystemErrorStatement(string lastErrorIdentifier) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax CreateSetLastPInvokeErrorStatement(string lastErrorIdentifier) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.LocalDeclarationStatementSyntax Declare(Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax typeSyntax, string identifier, bool initializeToDefault) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.LocalDeclarationStatementSyntax Declare(Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax typeSyntax, string identifier, Microsoft.CodeAnalysis.CSharp.Syntax.ExpressionSyntax initializer) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax GetCompatibleGenericTypeParameterSyntax(this Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax type) => throw null;
            public static System.Collections.Generic.IEnumerable<Microsoft.Interop.TypePositionInfo> GetDependentElementsOfMarshallingInfo(Microsoft.Interop.MarshallingInfo elementMarshallingInfo) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.ForStatementSyntax GetForLoop(Microsoft.CodeAnalysis.CSharp.Syntax.ExpressionSyntax lengthExpression, string indexerIdentifier) => throw null;
            public static string GetLastIndexMarshalledIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static string GetManagedSpanIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static string GetMarshallerIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static string GetNativeSpanIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static string GetNumElementsIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static Microsoft.CodeAnalysis.RefKind GetRefKindForByValueContentsKind(this Microsoft.Interop.ByValueContentsMarshalKind byValue) => throw null;
            public static System.Collections.Generic.IEnumerable<T> GetTopologicallySortedElements<T, U>(System.Collections.Generic.ICollection<T> elements, System.Func<T, U> keyFn, System.Func<T, System.Collections.Generic.IEnumerable<U>> getDependentIndicesFn) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax SkipInitOrDefaultInit(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static readonly Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax SystemIntPtrType;
        }
        [System.Flags]
        public enum MarshallerShape
        {
            None = 0,
            ToUnmanaged = 1,
            CallerAllocatedBuffer = 2,
            StatelessPinnableReference = 4,
            StatefulPinnableReference = 8,
            ToManaged = 16,
            GuaranteedUnmarshal = 32,
            Free = 64,
            OnInvoked = 128,
        }
        public sealed class MarshallingAttributeInfoParser
        {
            public MarshallingAttributeInfoParser(Microsoft.CodeAnalysis.Compilation compilation, Microsoft.Interop.IGeneratorDiagnostics diagnostics, Microsoft.Interop.DefaultMarshallingInfo defaultInfo, Microsoft.CodeAnalysis.ISymbol contextSymbol) => throw null;
            public Microsoft.Interop.MarshallingInfo ParseMarshallingInfo(Microsoft.CodeAnalysis.ITypeSymbol managedType, System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.AttributeData> useSiteAttributes) => throw null;
        }
        public static partial class MarshallingGeneratorExtensions
        {
            public static Microsoft.CodeAnalysis.CSharp.Syntax.ArgumentSyntax AsArgument(this Microsoft.Interop.IMarshallingGenerator generator, Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.ParameterSyntax AsParameter(this Microsoft.Interop.IMarshallingGenerator generator, Microsoft.Interop.TypePositionInfo info) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsReturnType(this Microsoft.Interop.IMarshallingGenerator generator, Microsoft.Interop.TypePositionInfo info) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.AttributeListSyntax GenerateAttributesForReturnType(this Microsoft.Interop.IMarshallingGenerator generator, Microsoft.Interop.TypePositionInfo info) => throw null;
        }
        public struct MarshallingGeneratorFactoryKey<T> : System.IEquatable<Microsoft.Interop.MarshallingGeneratorFactoryKey<T>> where T : System.IEquatable<T>
        {
            public bool Equals(Microsoft.Interop.MarshallingGeneratorFactoryKey<T> other) => throw null;
            public override bool Equals(object obj) => throw null;
            public Microsoft.Interop.IMarshallingGeneratorFactory GeneratorFactory { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public T Key { get => throw null; set { } }
        }
        public static class MarshallingGeneratorFactoryKey
        {
            public static Microsoft.Interop.MarshallingGeneratorFactoryKey<T> Create<T>(T key, Microsoft.Interop.IMarshallingGeneratorFactory factory) where T : System.IEquatable<T> => throw null;
        }
        public abstract class MarshallingInfo : System.IEquatable<Microsoft.Interop.MarshallingInfo>
        {
            public abstract Microsoft.Interop.MarshallingInfo<Clone>$();
protected MarshallingInfo() => throw null;
            protected MarshallingInfo(Microsoft.Interop.MarshallingInfo original) => throw null;
            protected virtual System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public virtual bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.MarshallingInfo left, Microsoft.Interop.MarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.MarshallingInfo left, Microsoft.Interop.MarshallingInfo right) => throw null;
            protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public class MarshallingInfoStringSupport : Microsoft.Interop.MarshallingInfo, System.IEquatable<Microsoft.Interop.MarshallingInfoStringSupport>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public Microsoft.Interop.CharEncoding CharEncoding { get => throw null; set { } }
            public MarshallingInfoStringSupport(Microsoft.Interop.CharEncoding CharEncoding) => throw null;
            protected MarshallingInfoStringSupport(Microsoft.Interop.MarshallingInfoStringSupport original) => throw null;
            public void Deconstruct(out Microsoft.Interop.CharEncoding CharEncoding) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public virtual bool Equals(Microsoft.Interop.MarshallingInfoStringSupport other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.MarshallingInfoStringSupport left, Microsoft.Interop.MarshallingInfoStringSupport right) => throw null;
            public static bool operator !=(Microsoft.Interop.MarshallingInfoStringSupport left, Microsoft.Interop.MarshallingInfoStringSupport right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class MarshallingNotSupportedException : System.Exception
        {
            public MarshallingNotSupportedException(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public System.Collections.Immutable.ImmutableDictionary<string, string> DiagnosticProperties { get => throw null; set { } }
            public string NotSupportedDetails { get => throw null; set { } }
            public Microsoft.Interop.StubCodeContext StubCodeContext { get => throw null; }
            public Microsoft.Interop.TypePositionInfo TypePositionInfo { get => throw null; }
        }
        public enum MarshalMode
        {
            Default = 0,
            ManagedToUnmanagedIn = 1,
            ManagedToUnmanagedRef = 2,
            ManagedToUnmanagedOut = 3,
            UnmanagedToManagedIn = 4,
            UnmanagedToManagedRef = 5,
            UnmanagedToManagedOut = 6,
            ElementIn = 7,
            ElementRef = 8,
            ElementOut = 9,
        }
        public sealed class MissingSupportCollectionMarshallingInfo : Microsoft.Interop.MissingSupportMarshallingInfo, System.IEquatable<Microsoft.Interop.MissingSupportCollectionMarshallingInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public Microsoft.Interop.CountInfo CountInfo { get => throw null; set { } }
            public MissingSupportCollectionMarshallingInfo(Microsoft.Interop.CountInfo CountInfo, Microsoft.Interop.MarshallingInfo ElementMarshallingInfo) => throw null;
            public void Deconstruct(out Microsoft.Interop.CountInfo CountInfo, out Microsoft.Interop.MarshallingInfo ElementMarshallingInfo) => throw null;
            public Microsoft.Interop.MarshallingInfo ElementMarshallingInfo { get => throw null; set { } }
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MissingSupportMarshallingInfo other) => throw null;
            public bool Equals(Microsoft.Interop.MissingSupportCollectionMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.MissingSupportCollectionMarshallingInfo left, Microsoft.Interop.MissingSupportCollectionMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.MissingSupportCollectionMarshallingInfo left, Microsoft.Interop.MissingSupportCollectionMarshallingInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public class MissingSupportMarshallingInfo : Microsoft.Interop.MarshallingInfo, System.IEquatable<Microsoft.Interop.MissingSupportMarshallingInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
protected MissingSupportMarshallingInfo(Microsoft.Interop.MissingSupportMarshallingInfo original) => throw null;
            public MissingSupportMarshallingInfo() => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public virtual bool Equals(Microsoft.Interop.MissingSupportMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.MissingSupportMarshallingInfo left, Microsoft.Interop.MissingSupportMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.MissingSupportMarshallingInfo left, Microsoft.Interop.MissingSupportMarshallingInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class NativeLinearCollectionMarshallingInfo : Microsoft.Interop.NativeMarshallingAttributeInfo, System.IEquatable<Microsoft.Interop.NativeLinearCollectionMarshallingInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public NativeLinearCollectionMarshallingInfo(Microsoft.Interop.ManagedTypeInfo EntryPointType, Microsoft.Interop.CustomTypeMarshallers Marshallers, Microsoft.Interop.CountInfo ElementCountInfo, Microsoft.Interop.ManagedTypeInfo PlaceholderTypeParameter) : base(default(Microsoft.Interop.NativeMarshallingAttributeInfo)) => throw null;
            public void Deconstruct(out Microsoft.Interop.ManagedTypeInfo EntryPointType, out Microsoft.Interop.CustomTypeMarshallers Marshallers, out Microsoft.Interop.CountInfo ElementCountInfo, out Microsoft.Interop.ManagedTypeInfo PlaceholderTypeParameter) => throw null;
            public Microsoft.Interop.CountInfo ElementCountInfo { get => throw null; set { } }
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.NativeMarshallingAttributeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.NativeLinearCollectionMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.NativeLinearCollectionMarshallingInfo left, Microsoft.Interop.NativeLinearCollectionMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.NativeLinearCollectionMarshallingInfo left, Microsoft.Interop.NativeLinearCollectionMarshallingInfo right) => throw null;
            public Microsoft.Interop.ManagedTypeInfo PlaceholderTypeParameter { get => throw null; set { } }
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public class NativeMarshallingAttributeInfo : Microsoft.Interop.MarshallingInfo, System.IEquatable<Microsoft.Interop.NativeMarshallingAttributeInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public NativeMarshallingAttributeInfo(Microsoft.Interop.ManagedTypeInfo EntryPointType, Microsoft.Interop.CustomTypeMarshallers Marshallers) => throw null;
            protected NativeMarshallingAttributeInfo(Microsoft.Interop.NativeMarshallingAttributeInfo original) => throw null;
            public void Deconstruct(out Microsoft.Interop.ManagedTypeInfo EntryPointType, out Microsoft.Interop.CustomTypeMarshallers Marshallers) => throw null;
            public Microsoft.Interop.ManagedTypeInfo EntryPointType { get => throw null; set { } }
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public virtual bool Equals(Microsoft.Interop.NativeMarshallingAttributeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public Microsoft.Interop.CustomTypeMarshallers Marshallers { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.NativeMarshallingAttributeInfo left, Microsoft.Interop.NativeMarshallingAttributeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.NativeMarshallingAttributeInfo left, Microsoft.Interop.NativeMarshallingAttributeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class NoCountInfo : Microsoft.Interop.CountInfo, System.IEquatable<Microsoft.Interop.NoCountInfo>
        {
            public override Microsoft.Interop.CountInfo<Clone>$() => throw null;
protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.CountInfo other) => throw null;
            public bool Equals(Microsoft.Interop.NoCountInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static readonly Microsoft.Interop.NoCountInfo Instance;
            public static bool operator ==(Microsoft.Interop.NoCountInfo left, Microsoft.Interop.NoCountInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.NoCountInfo left, Microsoft.Interop.NoCountInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
            internal NoCountInfo() : base(default(Microsoft.Interop.CountInfo)) { }
        }
        public sealed class NoMarshallingInfo : Microsoft.Interop.MarshallingInfo, System.IEquatable<Microsoft.Interop.NoMarshallingInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public bool Equals(Microsoft.Interop.NoMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static readonly Microsoft.Interop.MarshallingInfo Instance;
            public static bool operator ==(Microsoft.Interop.NoMarshallingInfo left, Microsoft.Interop.NoMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.NoMarshallingInfo left, Microsoft.Interop.NoMarshallingInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class NoMarshallingInfoErrorMarshallingFactory : Microsoft.Interop.IMarshallingGeneratorFactory
        {
            public Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public NoMarshallingInfoErrorMarshallingFactory(Microsoft.Interop.IMarshallingGeneratorFactory inner) => throw null;
            public System.Collections.Immutable.ImmutableDictionary<Microsoft.Interop.ManagedTypeInfo, string> CustomTypeToErrorMessageMap { get => throw null; }
        }
        public sealed class PointerTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.PointerTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public PointerTypeInfo(string FullTypeName, string DiagnosticFormattedName, bool IsFunctionPointer) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName, out bool IsFunctionPointer) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.PointerTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsFunctionPointer { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.PointerTypeInfo left, Microsoft.Interop.PointerTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.PointerTypeInfo left, Microsoft.Interop.PointerTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class ReferenceTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.ReferenceTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public ReferenceTypeInfo(string FullTypeName, string DiagnosticFormattedName) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.ReferenceTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.ReferenceTypeInfo left, Microsoft.Interop.ReferenceTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.ReferenceTypeInfo left, Microsoft.Interop.ReferenceTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class SafeHandleMarshaller : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            public SafeHandleMarshaller() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public sealed class SafeHandleMarshallingInfo : Microsoft.Interop.MarshallingInfo, System.IEquatable<Microsoft.Interop.SafeHandleMarshallingInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public bool AccessibleDefaultConstructor { get => throw null; set { } }
            public SafeHandleMarshallingInfo(bool AccessibleDefaultConstructor, bool IsAbstract) => throw null;
            public void Deconstruct(out bool AccessibleDefaultConstructor, out bool IsAbstract) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public bool Equals(Microsoft.Interop.SafeHandleMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsAbstract { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.SafeHandleMarshallingInfo left, Microsoft.Interop.SafeHandleMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.SafeHandleMarshallingInfo left, Microsoft.Interop.SafeHandleMarshallingInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public static class ShapeMemberNames
        {
            public const string BufferSize = default;
            public const string Free = default;
            public const string GetPinnableReference = default;
            public static class LinearCollection
            {
                public static class Stateful
                {
                    public const string Free = default;
                    public const string FromManaged = default;
                    public const string FromUnmanaged = default;
                    public const string GetManagedValuesDestination = default;
                    public const string GetManagedValuesSource = default;
                    public const string GetUnmanagedValuesDestination = default;
                    public const string GetUnmanagedValuesSource = default;
                    public const string OnInvoked = default;
                    public const string ToManaged = default;
                    public const string ToManagedFinally = default;
                    public const string ToUnmanaged = default;
                }
                public static class Stateless
                {
                    public const string AllocateContainerForManagedElements = default;
                    public const string AllocateContainerForManagedElementsFinally = default;
                    public const string AllocateContainerForUnmanagedElements = default;
                    public const string GetManagedValuesDestination = default;
                    public const string GetManagedValuesSource = default;
                    public const string GetUnmanagedValuesDestination = default;
                    public const string GetUnmanagedValuesSource = default;
                }
            }
            public static class Value
            {
                public static class Stateful
                {
                    public const string Free = default;
                    public const string FromManaged = default;
                    public const string FromUnmanaged = default;
                    public const string OnInvoked = default;
                    public const string ToManaged = default;
                    public const string ToManagedFinally = default;
                    public const string ToUnmanaged = default;
                }
                public static class Stateless
                {
                    public const string ConvertToManaged = default;
                    public const string ConvertToManagedFinally = default;
                    public const string ConvertToUnmanaged = default;
                }
            }
        }
        public enum SignatureBehavior
        {
            ManagedTypeAndAttributes = 0,
            NativeType = 1,
            PointerToNativeType = 2,
        }
        public sealed class SignatureContext : System.IEquatable<Microsoft.Interop.SignatureContext>
        {
            public Microsoft.Interop.SignatureContext<Clone>$() => throw null;
public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.AttributeListSyntax> AdditionalAttributes { get => throw null; set { } }
            public static Microsoft.Interop.SignatureContext Create(Microsoft.CodeAnalysis.IMethodSymbol method, Microsoft.Interop.InteropAttributeData interopAttributeData, Microsoft.Interop.StubEnvironment env, Microsoft.Interop.IGeneratorDiagnostics diagnostics, System.Reflection.Assembly generatorInfoAssembly) => throw null;
            public System.Collections.Immutable.ImmutableArray<Microsoft.Interop.TypePositionInfo> ElementTypeInformation { get => throw null; set { } }
            public bool Equals(Microsoft.Interop.SignatureContext other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.SignatureContext left, Microsoft.Interop.SignatureContext right) => throw null;
            public static bool operator !=(Microsoft.Interop.SignatureContext left, Microsoft.Interop.SignatureContext right) => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.ParameterSyntax> StubParameters { get => throw null; }
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax StubReturnType { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public sealed class SizeAndParamIndexInfo : Microsoft.Interop.CountInfo, System.IEquatable<Microsoft.Interop.SizeAndParamIndexInfo>
        {
            public override Microsoft.Interop.CountInfo<Clone>$() => throw null;
public int ConstSize { get => throw null; set { } }
            public SizeAndParamIndexInfo(int ConstSize, Microsoft.Interop.TypePositionInfo ParamAtIndex) : base(default(Microsoft.Interop.CountInfo)) => throw null;
            public void Deconstruct(out int ConstSize, out Microsoft.Interop.TypePositionInfo ParamAtIndex) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.CountInfo other) => throw null;
            public bool Equals(Microsoft.Interop.SizeAndParamIndexInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.SizeAndParamIndexInfo left, Microsoft.Interop.SizeAndParamIndexInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.SizeAndParamIndexInfo left, Microsoft.Interop.SizeAndParamIndexInfo right) => throw null;
            public Microsoft.Interop.TypePositionInfo ParamAtIndex { get => throw null; set { } }
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
            public static readonly Microsoft.Interop.SizeAndParamIndexInfo Unspecified;
            public const int UnspecifiedConstSize = -1;
            public const Microsoft.Interop.TypePositionInfo UnspecifiedParam = default;
        }
        public sealed class SpecialTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.SpecialTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public static readonly Microsoft.Interop.SpecialTypeInfo Boolean;
            public static readonly Microsoft.Interop.SpecialTypeInfo Byte;
            public SpecialTypeInfo(string FullTypeName, string DiagnosticFormattedName, Microsoft.CodeAnalysis.SpecialType SpecialType) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName, out Microsoft.CodeAnalysis.SpecialType SpecialType) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public bool Equals(Microsoft.Interop.SpecialTypeInfo other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static readonly Microsoft.Interop.SpecialTypeInfo Int32;
            public static bool operator ==(Microsoft.Interop.SpecialTypeInfo left, Microsoft.Interop.SpecialTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.SpecialTypeInfo left, Microsoft.Interop.SpecialTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public Microsoft.CodeAnalysis.SpecialType SpecialType { get => throw null; set { } }
            public static readonly Microsoft.Interop.SpecialTypeInfo String;
            public override string ToString() => throw null;
            public static readonly Microsoft.Interop.SpecialTypeInfo Void;
        }
        public static class StatefulMarshallerShapeHelper
        {
            public static System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.IMethodSymbol> GetFromUnmanagedMethodCandidates(Microsoft.CodeAnalysis.ITypeSymbol type) => throw null;
            public static (Microsoft.Interop.MarshallerShape shape, Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods methods) GetShapeForType(Microsoft.CodeAnalysis.ITypeSymbol marshallerType, Microsoft.CodeAnalysis.ITypeSymbol managedType, bool isLinearCollectionMarshaller, Microsoft.CodeAnalysis.Compilation compilation) => throw null;
            public class MarshallerMethods : System.IEquatable<Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods>
            {
                public virtual Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods<Clone>$() => throw null;
protected MarshallerMethods(Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods original) => throw null;
                public MarshallerMethods() => throw null;
                protected virtual System.Type EqualityContract { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public virtual bool Equals(Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods other) => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol Free { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol FromManaged { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol FromManagedWithBuffer { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol FromUnmanaged { get => throw null; set { } }
                public override int GetHashCode() => throw null;
                public bool IsShapeMethod(Microsoft.CodeAnalysis.IMethodSymbol method) => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol ManagedValuesDestination { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol ManagedValuesSource { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol OnInvoked { get => throw null; set { } }
                public static bool operator ==(Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods left, Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods right) => throw null;
                public static bool operator !=(Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods left, Microsoft.Interop.StatefulMarshallerShapeHelper.MarshallerMethods right) => throw null;
                protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol StatefulGetPinnableReference { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol StatelessGetPinnableReference { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol ToManaged { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol ToManagedGuaranteed { get => throw null; set { } }
                public override string ToString() => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol ToUnmanaged { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol UnmanagedValuesDestination { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol UnmanagedValuesSource { get => throw null; set { } }
            }
        }
        public static class StatelessMarshallerShapeHelper
        {
            public static (Microsoft.Interop.MarshallerShape, Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods) GetShapeForType(Microsoft.CodeAnalysis.ITypeSymbol marshallerType, Microsoft.CodeAnalysis.ITypeSymbol managedType, bool isLinearCollectionMarshaller, Microsoft.CodeAnalysis.Compilation compilation) => throw null;
            public class MarshallerMethods : System.IEquatable<Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods>
            {
                public virtual Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods<Clone>$() => throw null;
protected MarshallerMethods(Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods original) => throw null;
                public MarshallerMethods() => throw null;
                protected virtual System.Type EqualityContract { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public virtual bool Equals(Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods other) => throw null;
                public override int GetHashCode() => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol ManagedValuesDestination { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol ManagedValuesSource { get => throw null; set { } }
                public static bool operator ==(Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods left, Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods right) => throw null;
                public static bool operator !=(Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods left, Microsoft.Interop.StatelessMarshallerShapeHelper.MarshallerMethods right) => throw null;
                protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol ToManaged { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol ToManagedFinally { get => throw null; set { } }
                public override string ToString() => throw null;
                public Microsoft.CodeAnalysis.IMethodSymbol ToUnmanaged { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol ToUnmanagedWithBuffer { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol UnmanagedValuesDestination { get => throw null; set { } }
                public Microsoft.CodeAnalysis.IMethodSymbol UnmanagedValuesSource { get => throw null; set { } }
            }
        }
        public sealed class StaticPinnableManagedValueMarshaller : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            public StaticPinnableManagedValueMarshaller(Microsoft.Interop.IMarshallingGenerator innerMarshallingGenerator, Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax getPinnableReferenceType) => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public enum StringMarshalling
        {
            Custom = 0,
            Utf8 = 1,
            Utf16 = 2,
        }
        public abstract class StubCodeContext : System.IEquatable<Microsoft.Interop.StubCodeContext>
        {
            public abstract Microsoft.Interop.StubCodeContext<Clone>$();
public abstract bool AdditionalTemporaryStateLivesAcrossStages { get; }
            protected StubCodeContext(Microsoft.Interop.StubCodeContext original) => throw null;
            protected StubCodeContext() => throw null;
            public Microsoft.Interop.StubCodeContext.Stage CurrentStage { get => throw null; set { } }
            public Microsoft.Interop.CustomTypeMarshallingDirection Direction { get => throw null; set { } }
            protected virtual System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public virtual bool Equals(Microsoft.Interop.StubCodeContext other) => throw null;
            public const string GeneratedNativeIdentifierSuffix = default;
            public virtual string GetAdditionalIdentifier(Microsoft.Interop.TypePositionInfo info, string name) => throw null;
            public override int GetHashCode() => throw null;
            public virtual (string managed, string native) GetIdentifiers(Microsoft.Interop.TypePositionInfo info) => throw null;
            public abstract (Microsoft.Interop.TargetFramework framework, System.Version version) GetTargetFramework();
            public static bool operator ==(Microsoft.Interop.StubCodeContext left, Microsoft.Interop.StubCodeContext right) => throw null;
            public static bool operator !=(Microsoft.Interop.StubCodeContext left, Microsoft.Interop.StubCodeContext right) => throw null;
            public Microsoft.Interop.StubCodeContext ParentContext { get => throw null; set { } }
            protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public abstract bool SingleFrameSpansNativeContext { get; }
            public enum Stage
            {
                Invalid = 0,
                Setup = 1,
                Marshal = 2,
                Pin = 3,
                PinnedMarshal = 4,
                Invoke = 5,
                UnmarshalCapture = 6,
                Unmarshal = 7,
                NotifyForSuccessfulInvoke = 8,
                Cleanup = 9,
                GuaranteedUnmarshal = 10,
            }
            public override string ToString() => throw null;
        }
        public sealed class StubEnvironment : System.IEquatable<Microsoft.Interop.StubEnvironment>
        {
            public Microsoft.Interop.StubEnvironment<Clone>$() => throw null;
public static bool AreCompilationSettingsEqual(Microsoft.Interop.StubEnvironment env1, Microsoft.Interop.StubEnvironment env2) => throw null;
            public Microsoft.CodeAnalysis.Compilation Compilation { get => throw null; set { } }
            public StubEnvironment(Microsoft.CodeAnalysis.Compilation Compilation, Microsoft.Interop.TargetFramework TargetFramework, System.Version TargetFrameworkVersion, bool ModuleSkipLocalsInit) => throw null;
            public void Deconstruct(out Microsoft.CodeAnalysis.Compilation Compilation, out Microsoft.Interop.TargetFramework TargetFramework, out System.Version TargetFrameworkVersion, out bool ModuleSkipLocalsInit) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.StubEnvironment other) => throw null;
            public override int GetHashCode() => throw null;
            public bool ModuleSkipLocalsInit { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.StubEnvironment left, Microsoft.Interop.StubEnvironment right) => throw null;
            public static bool operator !=(Microsoft.Interop.StubEnvironment left, Microsoft.Interop.StubEnvironment right) => throw null;
            public Microsoft.Interop.TargetFramework TargetFramework { get => throw null; set { } }
            public System.Version TargetFrameworkVersion { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public sealed class SyntaxEquivalentComparer : System.Collections.Generic.IEqualityComparer<Microsoft.CodeAnalysis.SyntaxNode>, System.Collections.Generic.IEqualityComparer<Microsoft.CodeAnalysis.SyntaxToken>
        {
            public bool Equals(Microsoft.CodeAnalysis.SyntaxNode x, Microsoft.CodeAnalysis.SyntaxNode y) => throw null;
            public bool Equals(Microsoft.CodeAnalysis.SyntaxToken x, Microsoft.CodeAnalysis.SyntaxToken y) => throw null;
            public int GetHashCode(Microsoft.CodeAnalysis.SyntaxNode obj) => throw null;
            public int GetHashCode(Microsoft.CodeAnalysis.SyntaxToken obj) => throw null;
            public static readonly Microsoft.Interop.SyntaxEquivalentComparer Instance;
        }
        public static partial class SyntaxExtensions
        {
            public static Microsoft.CodeAnalysis.SyntaxTokenList AddToModifiers(this Microsoft.CodeAnalysis.SyntaxTokenList modifiers, Microsoft.CodeAnalysis.CSharp.SyntaxKind modifierToAdd) => throw null;
            public static Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax NestFixedStatements(this System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.FixedStatementSyntax> fixedStatements, Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax innerStatement) => throw null;
            public static Microsoft.CodeAnalysis.SyntaxTokenList StripTriviaFromTokens(this Microsoft.CodeAnalysis.SyntaxTokenList tokenList) => throw null;
        }
        public sealed class SzArrayType : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.SzArrayType>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public SzArrayType(Microsoft.Interop.ManagedTypeInfo ElementTypeInfo) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out Microsoft.Interop.ManagedTypeInfo ElementTypeInfo) => throw null;
            public Microsoft.Interop.ManagedTypeInfo ElementTypeInfo { get => throw null; set { } }
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.SzArrayType other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.SzArrayType left, Microsoft.Interop.SzArrayType right) => throw null;
            public static bool operator !=(Microsoft.Interop.SzArrayType left, Microsoft.Interop.SzArrayType right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public enum TargetFramework
        {
            Unknown = 0,
            Framework = 1,
            Core = 2,
            Standard = 3,
            Net = 4,
        }
        public static class TypeNames
        {
            public const string AnsiStringMarshaller = default;
            public const string BStrStringMarshaller = default;
            public const string ContiguousCollectionMarshallerAttribute = default;
            public const string CustomMarshallerAttribute = default;
            public const string CustomMarshallerAttributeGenericPlaceholder = default;
            public const string DefaultDllImportSearchPathsAttribute = default;
            public const string DllImportAttribute = default;
            public const string DllImportSearchPath = default;
            public const string LCIDConversionAttribute = default;
            public const string LibraryImportAttribute = default;
            public static string MarshalEx(Microsoft.Interop.InteropGenerationOptions options) => throw null;
            public const string MarshalUsingAttribute = default;
            public const string NativeMarshallingAttribute = default;
            public const string StringMarshalling = default;
            public const string SuppressGCTransitionAttribute = default;
            public const string System_Activator = default;
            public const string System_CodeDom_Compiler_GeneratedCodeAttribute = default;
            public const string System_IntPtr = default;
            public const string System_ReadOnlySpan = default;
            public const string System_ReadOnlySpan_Metadata = default;
            public const string System_Runtime_CompilerServices_DisableRuntimeMarshallingAttribute = default;
            public const string System_Runtime_CompilerServices_SkipLocalsInitAttribute = default;
            public const string System_Runtime_CompilerServices_Unsafe = default;
            public const string System_Runtime_InteropServices_ArrayMarshaller = default;
            public const string System_Runtime_InteropServices_ArrayMarshaller_Metadata = default;
            public const string System_Runtime_InteropServices_InAttribute = default;
            public const string System_Runtime_InteropServices_Marshal = default;
            public const string System_Runtime_InteropServices_MarshalAsAttribute = default;
            public const string System_Runtime_InteropServices_MemoryMarshal = default;
            public const string System_Runtime_InteropServices_OutAttribute = default;
            public const string System_Runtime_InteropServices_PointerArrayMarshaller = default;
            public const string System_Runtime_InteropServices_PointerArrayMarshaller_Metadata = default;
            public const string System_Runtime_InteropServices_SafeHandle = default;
            public const string System_Runtime_InteropServices_StructLayoutAttribute = default;
            public const string System_Runtime_InteropServices_UnmanagedType = default;
            public const string System_Span = default;
            public const string System_Span_Metadata = default;
            public const string System_Type = default;
            public const string UnmanagedCallConvAttribute = default;
            public const string Utf16StringMarshaller = default;
            public const string Utf8StringMarshaller = default;
        }
        public sealed class TypeParameterTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.TypeParameterTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public TypeParameterTypeInfo(string FullTypeName, string DiagnosticFormattedName) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.TypeParameterTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(Microsoft.Interop.TypeParameterTypeInfo left, Microsoft.Interop.TypeParameterTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.TypeParameterTypeInfo left, Microsoft.Interop.TypeParameterTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class TypePositionInfo : System.IEquatable<Microsoft.Interop.TypePositionInfo>
        {
            public Microsoft.Interop.TypePositionInfo<Clone>$() => throw null;
public Microsoft.Interop.ByValueContentsMarshalKind ByValueContentsMarshalKind { get => throw null; set { } }
            public static Microsoft.Interop.TypePositionInfo CreateForParameter(Microsoft.CodeAnalysis.IParameterSymbol paramSymbol, Microsoft.Interop.MarshallingInfo marshallingInfo, Microsoft.CodeAnalysis.Compilation compilation) => throw null;
            public TypePositionInfo(Microsoft.Interop.ManagedTypeInfo ManagedType, Microsoft.Interop.MarshallingInfo MarshallingAttributeInfo) => throw null;
            public void Deconstruct(out Microsoft.Interop.ManagedTypeInfo ManagedType, out Microsoft.Interop.MarshallingInfo MarshallingAttributeInfo) => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(Microsoft.Interop.TypePositionInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public string InstanceIdentifier { get => throw null; set { } }
            public bool IsByRef { get => throw null; }
            public bool IsManagedReturnPosition { get => throw null; }
            public bool IsNativeReturnPosition { get => throw null; }
            public int ManagedIndex { get => throw null; set { } }
            public Microsoft.Interop.ManagedTypeInfo ManagedType { get => throw null; set { } }
            public Microsoft.Interop.MarshallingInfo MarshallingAttributeInfo { get => throw null; set { } }
            public int NativeIndex { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.TypePositionInfo left, Microsoft.Interop.TypePositionInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.TypePositionInfo left, Microsoft.Interop.TypePositionInfo right) => throw null;
            public Microsoft.CodeAnalysis.RefKind RefKind { get => throw null; set { } }
            public Microsoft.CodeAnalysis.CSharp.SyntaxKind RefKindSyntax { get => throw null; set { } }
            public const int ReturnIndex = -2147483647;
            public override string ToString() => throw null;
            public const int UnsetIndex = -2147483648;
        }
        public static partial class TypeSymbolExtensions
        {
            public static Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsTypeSyntax(this Microsoft.CodeAnalysis.ITypeSymbol type) => throw null;
            public static (System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.ITypeSymbol> TypeArguments, System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.NullableAnnotation> TypeArgumentNullableAnnotations) GetAllTypeArgumentsIncludingInContainingTypes(this Microsoft.CodeAnalysis.INamedTypeSymbol genericType) => throw null;
            public static bool IsAlwaysBlittable(this Microsoft.CodeAnalysis.SpecialType type) => throw null;
            public static bool IsConsideredBlittable(this Microsoft.CodeAnalysis.ITypeSymbol type) => throw null;
            public static bool IsConstructedFromEqualTypes(this Microsoft.CodeAnalysis.ITypeSymbol type, Microsoft.CodeAnalysis.ITypeSymbol other) => throw null;
            public static bool IsIntegralType(this Microsoft.CodeAnalysis.SpecialType type) => throw null;
            public static bool IsStrictlyBlittable(this Microsoft.CodeAnalysis.ITypeSymbol type) => throw null;
            public static Microsoft.CodeAnalysis.INamedTypeSymbol ResolveUnboundConstructedTypeToConstructedType(this Microsoft.CodeAnalysis.INamedTypeSymbol unboundConstructedType, Microsoft.CodeAnalysis.INamedTypeSymbol instantiatedTemplateType, out int numOriginalTypeArgumentsSubstituted, out int extraTypeArgumentsInTemplate) => throw null;
        }
        public sealed class UnmanagedBlittableMarshallingInfo : Microsoft.Interop.MarshallingInfo, System.IEquatable<Microsoft.Interop.UnmanagedBlittableMarshallingInfo>
        {
            public override Microsoft.Interop.MarshallingInfo<Clone>$() => throw null;
public UnmanagedBlittableMarshallingInfo(bool IsStrictlyBlittable) => throw null;
            public void Deconstruct(out bool IsStrictlyBlittable) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.MarshallingInfo other) => throw null;
            public bool Equals(Microsoft.Interop.UnmanagedBlittableMarshallingInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsStrictlyBlittable { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.UnmanagedBlittableMarshallingInfo left, Microsoft.Interop.UnmanagedBlittableMarshallingInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.UnmanagedBlittableMarshallingInfo left, Microsoft.Interop.UnmanagedBlittableMarshallingInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public sealed class UnsupportedMarshallingFactory : Microsoft.Interop.IMarshallingGeneratorFactory
        {
            public Microsoft.Interop.IMarshallingGenerator Create(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public UnsupportedMarshallingFactory() => throw null;
        }
        public sealed class Utf16CharMarshaller : Microsoft.Interop.IMarshallingGenerator
        {
            public Microsoft.CodeAnalysis.CSharp.Syntax.TypeSyntax AsNativeType(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Utf16CharMarshaller() => throw null;
            public System.Collections.Generic.IEnumerable<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Generate(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public Microsoft.Interop.SignatureBehavior GetNativeSignatureBehavior(Microsoft.Interop.TypePositionInfo info) => throw null;
            public Microsoft.Interop.ValueBoundaryBehavior GetValueBoundaryBehavior(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool IsSupported(Microsoft.Interop.TargetFramework target, System.Version version) => throw null;
            public bool SupportsByValueMarshalKind(Microsoft.Interop.ByValueContentsMarshalKind marshalKind, Microsoft.Interop.StubCodeContext context) => throw null;
            public bool UsesNativeIdentifier(Microsoft.Interop.TypePositionInfo info, Microsoft.Interop.StubCodeContext context) => throw null;
        }
        public enum ValueBoundaryBehavior
        {
            ManagedIdentifier = 0,
            NativeIdentifier = 1,
            AddressOfNativeIdentifier = 2,
            CastNativeIdentifier = 3,
        }
        public sealed class ValueTypeInfo : Microsoft.Interop.ManagedTypeInfo, System.IEquatable<Microsoft.Interop.ValueTypeInfo>
        {
            public override Microsoft.Interop.ManagedTypeInfo<Clone>$() => throw null;
public ValueTypeInfo(string FullTypeName, string DiagnosticFormattedName, bool IsByRefLike) : base(default(Microsoft.Interop.ManagedTypeInfo)) => throw null;
            public void Deconstruct(out string FullTypeName, out string DiagnosticFormattedName, out bool IsByRefLike) => throw null;
            protected override System.Type EqualityContract { get => throw null; }
            public override bool Equals(object obj) => throw null;
            public override sealed bool Equals(Microsoft.Interop.ManagedTypeInfo other) => throw null;
            public bool Equals(Microsoft.Interop.ValueTypeInfo other) => throw null;
            public override int GetHashCode() => throw null;
            public bool IsByRefLike { get => throw null; set { } }
            public static bool operator ==(Microsoft.Interop.ValueTypeInfo left, Microsoft.Interop.ValueTypeInfo right) => throw null;
            public static bool operator !=(Microsoft.Interop.ValueTypeInfo left, Microsoft.Interop.ValueTypeInfo right) => throw null;
            protected override bool PrintMembers(System.Text.StringBuilder builder) => throw null;
            public override string ToString() => throw null;
        }
        public struct VariableDeclarations
        {
            public static Microsoft.Interop.VariableDeclarations GenerateDeclarationsForManagedToNative(Microsoft.Interop.BoundGenerators marshallers, Microsoft.Interop.StubCodeContext context, bool initializeDeclarations) => throw null;
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.StatementSyntax> Initializations { get => throw null; set { } }
            public System.Collections.Immutable.ImmutableArray<Microsoft.CodeAnalysis.CSharp.Syntax.LocalDeclarationStatementSyntax> Variables { get => throw null; set { } }
        }
        public sealed class VariantBoolMarshaller : Microsoft.Interop.BoolMarshallerBase
        {
            public VariantBoolMarshaller() : base(default(Microsoft.CodeAnalysis.CSharp.Syntax.PredefinedTypeSyntax), default(int), default(int), default(bool)) => throw null;
        }
        public sealed class WinBoolMarshaller : Microsoft.Interop.BoolMarshallerBase
        {
            public WinBoolMarshaller(bool signed) : base(default(Microsoft.CodeAnalysis.CSharp.Syntax.PredefinedTypeSyntax), default(int), default(int), default(bool)) => throw null;
        }
    }
}
