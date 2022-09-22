"""
Schema description

This file should be kept simple:
* no flow control
* no aliases
* only class definitions with annotations and `include` calls
"""

from swift.codegen.lib.schema.defs import *

include("prefix.dbscheme")

@qltest.skip
class Element:
    is_unknown: predicate | cpp.skip

@qltest.skip
@qltest.collapse_hierarchy
class UnresolvedElement(Element):
    pass

@qltest.collapse_hierarchy
class File(Element):
    name: string

@qltest.skip
@qltest.collapse_hierarchy
class Location(Element):
    file: File
    start_line: int
    start_column: int
    end_line: int
    end_column: int

@qltest.skip
class Locatable(Element):
    location: optional[Location] | cpp.skip

class Comment(Locatable):
    text: string

class DbFile(File):
    pass

class DbLocation(Location):
    pass

@synth.on_arguments()
class UnknownFile(File):
    pass

@synth.on_arguments()
class UnknownLocation(Location):
    pass

class AstNode(Locatable):
    pass

@group("type")
class Type(Element):
    name: string
    canonical_type: "Type"

@group("decl")
class Decl(AstNode):
    module: "ModuleDecl"

@group("expr")
class Expr(AstNode):
    type: optional[Type]

@group("pattern")
class Pattern(AstNode):
    pass

@group("stmt")
class Stmt(AstNode):
    pass

@group("decl")
class GenericContext(Element):
    generic_type_params: list["GenericTypeParamDecl"] | child

@group("decl")
class IterableDeclContext(Element):
    members: list[Decl] | child

class EnumCaseDecl(Decl):
    elements: list["EnumElementDecl"]

class ExtensionDecl(GenericContext, IterableDeclContext, Decl):
    extended_type_decl: "NominalTypeDecl"

class IfConfigDecl(Decl):
    active_elements: list[AstNode]

class ImportDecl(Decl):
    is_exported: predicate
    imported_module: optional["ModuleDecl"]
    declarations: list["ValueDecl"]

class MissingMemberDecl(Decl):
    pass

class OperatorDecl(Decl):
    name: string

class PatternBindingDecl(Decl):
    inits: list[optional[Expr]] | child
    patterns: list[Pattern] | child

class PoundDiagnosticDecl(Decl):
    pass

class PrecedenceGroupDecl(Decl):
    pass

class TopLevelCodeDecl(Decl):
    body: "BraceStmt" | child

class ValueDecl(Decl):
    interface_type: Type

class AbstractStorageDecl(ValueDecl):
    accessor_decls: list["AccessorDecl"] | child

class VarDecl(AbstractStorageDecl):
    name: string
    type: Type
    attached_property_wrapper_type: optional[Type]
    parent_pattern: optional[Pattern]
    parent_initializer: optional[Expr]

class ParamDecl(VarDecl):
    is_inout: predicate

class Callable(Element):
    self_param: optional[ParamDecl] | child
    params: list[ParamDecl] | child
    body: optional["BraceStmt"] | child

class AbstractFunctionDecl(GenericContext, ValueDecl, Callable):
    name: string

class EnumElementDecl(ValueDecl):
    name: string
    params: list[ParamDecl] | child

class InfixOperatorDecl(OperatorDecl):
    precedence_group: optional[PrecedenceGroupDecl]

class PostfixOperatorDecl(OperatorDecl):
    pass

class PrefixOperatorDecl(OperatorDecl):
    pass

class TypeDecl(ValueDecl):
    name: string
    base_types: list[Type]

class AbstractTypeParamDecl(TypeDecl):
    pass

class ConstructorDecl(AbstractFunctionDecl):
    pass

class DestructorDecl(AbstractFunctionDecl):
    pass

class FuncDecl(AbstractFunctionDecl):
    pass

class GenericTypeDecl(GenericContext, TypeDecl):
    pass

class ModuleDecl(TypeDecl):
    is_builtin_module: predicate
    is_system_module: predicate
    imported_modules: list["ModuleDecl"]
    exported_modules: list["ModuleDecl"]

class SubscriptDecl(AbstractStorageDecl, GenericContext):
    params: list[ParamDecl] | child
    element_type: Type
    element_type: Type

class AccessorDecl(FuncDecl):
    is_getter: predicate
    is_setter: predicate
    is_will_set: predicate
    is_did_set: predicate

class AssociatedTypeDecl(AbstractTypeParamDecl):
    pass

class ConcreteFuncDecl(FuncDecl):
    pass

class ConcreteVarDecl(VarDecl):
    introducer_int: int

class GenericTypeParamDecl(AbstractTypeParamDecl):
    pass

class NominalTypeDecl(GenericTypeDecl, IterableDeclContext):
    type: Type

class OpaqueTypeDecl(GenericTypeDecl):
    pass

class TypeAliasDecl(GenericTypeDecl):
    pass

class ClassDecl(NominalTypeDecl):
    pass

class EnumDecl(NominalTypeDecl):
    pass

class ProtocolDecl(NominalTypeDecl):
    pass

class StructDecl(NominalTypeDecl):
    pass

@group("expr")
class Argument(Locatable):
    label: string
    expr: Expr | child

class AbstractClosureExpr(Expr, Callable):
    pass

class AnyTryExpr(Expr):
    sub_expr: Expr | child

class AppliedPropertyWrapperExpr(Expr):
    pass

class ApplyExpr(Expr):
    function: Expr | child
    arguments: list[Argument] | child

class ArrowExpr(Expr):
    pass

class AssignExpr(Expr):
    dest: Expr | child
    source: Expr | child

class BindOptionalExpr(Expr):
    sub_expr: Expr | child

class CaptureListExpr(Expr):
    binding_decls: list[PatternBindingDecl] | child
    closure_body: "ClosureExpr" | child

class CodeCompletionExpr(Expr):
    pass

class CollectionExpr(Expr):
    pass

class DeclRefExpr(Expr):
    decl: Decl
    replacement_types: list[Type]
    has_direct_to_storage_semantics: predicate
    has_direct_to_implementation_semantics: predicate
    has_ordinary_semantics: predicate

class DefaultArgumentExpr(Expr):
    param_decl: ParamDecl
    param_index: int
    caller_side_default: optional[Expr]

class DiscardAssignmentExpr(Expr):
    pass

class DotSyntaxBaseIgnoredExpr(Expr):
    qualifier: Expr | child
    sub_expr: Expr | child

class DynamicTypeExpr(Expr):
    base: Expr | child

class EditorPlaceholderExpr(Expr):
    pass

class EnumIsCaseExpr(Expr):
    sub_expr: Expr | child
    element: EnumElementDecl

@qltest.skip
class ErrorExpr(Expr):
    pass

class ExplicitCastExpr(Expr):
    sub_expr: Expr | child

class ForceValueExpr(Expr):
    sub_expr: Expr | child

class IdentityExpr(Expr):
    sub_expr: Expr | child

class IfExpr(Expr):
    condition: Expr | child
    then_expr: Expr | child
    else_expr: Expr | child

class ImplicitConversionExpr(Expr):
    sub_expr: Expr | child

class InOutExpr(Expr):
    sub_expr: Expr | child

class KeyPathApplicationExpr(Expr):
    base: Expr | child
    key_path: Expr | child

class KeyPathDotExpr(Expr):
    pass

class KeyPathExpr(Expr):
    root: optional["TypeRepr"] | child
    parsed_path: optional[Expr] | child

class LazyInitializerExpr(Expr):
    sub_expr: Expr | child

class LiteralExpr(Expr):
    pass

class LookupExpr(Expr):
    base: Expr | child
    member: optional[Decl]

class MakeTemporarilyEscapableExpr(Expr):
    escaping_closure: "OpaqueValueExpr" | child
    nonescaping_closure: Expr | child
    sub_expr: Expr | child

@qltest.skip
class ObjCSelectorExpr(Expr):
    sub_expr: Expr | child
    method: AbstractFunctionDecl

class OneWayExpr(Expr):
    sub_expr: Expr | child

class OpaqueValueExpr(Expr):
    pass

class OpenExistentialExpr(Expr):
    sub_expr: Expr | child
    existential: Expr | child
    opaque_expr: OpaqueValueExpr | child

class OptionalEvaluationExpr(Expr):
    sub_expr: Expr | child

class OtherConstructorDeclRefExpr(Expr):
    constructor_decl: ConstructorDecl

class OverloadSetRefExpr(Expr):
    pass

class PropertyWrapperValuePlaceholderExpr(Expr):
    pass

class RebindSelfInConstructorExpr(Expr):
    sub_expr: Expr | child
    self: VarDecl

@qltest.skip
class SequenceExpr(Expr):
    elements: list[Expr] | child

class SuperRefExpr(Expr):
    self: VarDecl

class TapExpr(Expr):
    sub_expr: optional[Expr] | child
    body: "BraceStmt" | child
    var: VarDecl

class TupleElementExpr(Expr):
    sub_expr: Expr | child
    index: int

class TupleExpr(Expr):
    elements: list[Expr] | child

class TypeExpr(Expr):
    type_repr: optional["TypeRepr"] | child

class UnresolvedDeclRefExpr(Expr, UnresolvedElement):
    name: optional[string]

class UnresolvedDotExpr(Expr, UnresolvedElement):
    base: Expr | child
    name: string

class UnresolvedMemberExpr(Expr, UnresolvedElement):
    name: string

class UnresolvedPatternExpr(Expr, UnresolvedElement):
    sub_pattern: Pattern | child

class UnresolvedSpecializeExpr(Expr, UnresolvedElement):
    pass

class VarargExpansionExpr(Expr):
    sub_expr: Expr | child

class AnyHashableErasureExpr(ImplicitConversionExpr):
    pass

class ArchetypeToSuperExpr(ImplicitConversionExpr):
    pass

class ArrayExpr(CollectionExpr):
    elements: list[Expr] | child

class ArrayToPointerExpr(ImplicitConversionExpr):
    pass

class AutoClosureExpr(AbstractClosureExpr):
    pass

class AwaitExpr(IdentityExpr):
    pass

class BinaryExpr(ApplyExpr):
    pass

@qltest.skip
class BridgeFromObjCExpr(ImplicitConversionExpr):
    pass

@qltest.skip
class BridgeToObjCExpr(ImplicitConversionExpr):
    pass

class BuiltinLiteralExpr(LiteralExpr):
    pass

class CallExpr(ApplyExpr):
    pass

class CheckedCastExpr(ExplicitCastExpr):
    pass

class ClassMetatypeToObjectExpr(ImplicitConversionExpr):
    pass

class ClosureExpr(AbstractClosureExpr):
    pass

class CoerceExpr(ExplicitCastExpr):
    pass

class CollectionUpcastConversionExpr(ImplicitConversionExpr):
    pass

@qltest.skip
class ConditionalBridgeFromObjCExpr(ImplicitConversionExpr):
    pass

class CovariantFunctionConversionExpr(ImplicitConversionExpr):
    pass

class CovariantReturnConversionExpr(ImplicitConversionExpr):
    pass

class DerivedToBaseExpr(ImplicitConversionExpr):
    pass

class DestructureTupleExpr(ImplicitConversionExpr):
    pass

class DictionaryExpr(CollectionExpr):
    elements: list[Expr] | child

class DifferentiableFunctionExpr(ImplicitConversionExpr):
    pass

class DifferentiableFunctionExtractOriginalExpr(ImplicitConversionExpr):
    pass

class DotSelfExpr(IdentityExpr):
    pass

class DynamicLookupExpr(LookupExpr):
    pass

class ErasureExpr(ImplicitConversionExpr):
    pass

class ExistentialMetatypeToObjectExpr(ImplicitConversionExpr):
    pass

class ForceTryExpr(AnyTryExpr):
    pass

class ForeignObjectConversionExpr(ImplicitConversionExpr):
    pass

class FunctionConversionExpr(ImplicitConversionExpr):
    pass

class InOutToPointerExpr(ImplicitConversionExpr):
    pass

class InjectIntoOptionalExpr(ImplicitConversionExpr):
    pass

class InterpolatedStringLiteralExpr(LiteralExpr):
    interpolation_expr: optional[OpaqueValueExpr]
    interpolation_count_expr: optional[Expr] | child
    literal_capacity_expr: optional[Expr] | child
    appending_expr: optional[TapExpr] | child

class LinearFunctionExpr(ImplicitConversionExpr):
    pass

class LinearFunctionExtractOriginalExpr(ImplicitConversionExpr):
    pass

class LinearToDifferentiableFunctionExpr(ImplicitConversionExpr):
    pass

class LoadExpr(ImplicitConversionExpr):
    pass

class MemberRefExpr(LookupExpr):
    has_direct_to_storage_semantics: predicate
    has_direct_to_implementation_semantics: predicate
    has_ordinary_semantics: predicate

class MetatypeConversionExpr(ImplicitConversionExpr):
    pass

class NilLiteralExpr(LiteralExpr):
    pass

class ObjectLiteralExpr(LiteralExpr):
    pass

class OptionalTryExpr(AnyTryExpr):
    pass

class OverloadedDeclRefExpr(OverloadSetRefExpr):
    pass

class ParenExpr(IdentityExpr):
    pass

class PointerToPointerExpr(ImplicitConversionExpr):
    pass

class PostfixUnaryExpr(ApplyExpr):
    pass

class PrefixUnaryExpr(ApplyExpr):
    pass

class ProtocolMetatypeToObjectExpr(ImplicitConversionExpr):
    pass

class RegexLiteralExpr(LiteralExpr):
    pass

class SelfApplyExpr(ApplyExpr):
    base: Expr

class StringToPointerExpr(ImplicitConversionExpr):
    pass

class SubscriptExpr(LookupExpr):
    arguments: list[Argument] | child
    has_direct_to_storage_semantics: predicate
    has_direct_to_implementation_semantics: predicate
    has_ordinary_semantics: predicate

class TryExpr(AnyTryExpr):
    pass

class UnderlyingToOpaqueExpr(ImplicitConversionExpr):
    pass

class UnevaluatedInstanceExpr(ImplicitConversionExpr):
    pass

class UnresolvedMemberChainResultExpr(IdentityExpr, UnresolvedElement):
    pass

class UnresolvedTypeConversionExpr(ImplicitConversionExpr, UnresolvedElement):
    pass

class BooleanLiteralExpr(BuiltinLiteralExpr):
    value: boolean

class ConditionalCheckedCastExpr(CheckedCastExpr):
    pass

class ConstructorRefCallExpr(SelfApplyExpr):
    pass

class DotSyntaxCallExpr(SelfApplyExpr):
    pass

@synth.from_class(DotSyntaxCallExpr)
class MethodRefExpr(LookupExpr):
    pass

class DynamicMemberRefExpr(DynamicLookupExpr):
    pass

class DynamicSubscriptExpr(DynamicLookupExpr):
    pass

class ForcedCheckedCastExpr(CheckedCastExpr):
    pass

class IsExpr(CheckedCastExpr):
    pass

class MagicIdentifierLiteralExpr(BuiltinLiteralExpr):
    kind: string

class NumberLiteralExpr(BuiltinLiteralExpr):
    pass

class StringLiteralExpr(BuiltinLiteralExpr):
    value: string

class FloatLiteralExpr(NumberLiteralExpr):
    string_value: string

class IntegerLiteralExpr(NumberLiteralExpr):
    string_value: string

class PackExpr(Expr):
    pass

class ReifyPackExpr(ImplicitConversionExpr):
    pass

class AnyPattern(Pattern):
    pass

class BindingPattern(Pattern):
    sub_pattern: Pattern | child

class BoolPattern(Pattern):
    value: boolean

class EnumElementPattern(Pattern):
    element: EnumElementDecl
    sub_pattern: optional[Pattern] | child

class ExprPattern(Pattern):
    sub_expr: Expr | child

class IsPattern(Pattern):
    cast_type_repr: optional["TypeRepr"] | child
    sub_pattern: optional[Pattern] | child

class NamedPattern(Pattern):
    name: string

class OptionalSomePattern(Pattern):
    sub_pattern: Pattern | child

class ParenPattern(Pattern):
    sub_pattern: Pattern | child

class TuplePattern(Pattern):
    elements: list[Pattern] | child

class TypedPattern(Pattern):
    sub_pattern: Pattern | child
    type_repr: optional["TypeRepr"] | child

@group("stmt")
class CaseLabelItem(AstNode):
    pattern: Pattern | child
    guard: optional[Expr] | child

@group("stmt")
class ConditionElement(AstNode):
    boolean: optional[Expr] | child
    pattern: optional[Pattern] | child
    initializer: optional[Expr] | child

@group("stmt")
class StmtCondition(AstNode):
    elements: list[ConditionElement] | child

class BraceStmt(Stmt):
    elements: list[AstNode] | child

class BreakStmt(Stmt):
    target_name: optional[string]
    target: optional[Stmt]

class CaseStmt(Stmt):
    body: Stmt | child
    labels: list[CaseLabelItem] | child
    variables: list[VarDecl]

class ContinueStmt(Stmt):
    target_name: optional[string]
    target: optional[Stmt]

class DeferStmt(Stmt):
    body: BraceStmt | child

class FailStmt(Stmt):
    pass

class FallthroughStmt(Stmt):
    fallthrough_source: CaseStmt
    fallthrough_dest: CaseStmt

class LabeledStmt(Stmt):
    label: optional[string]

class PoundAssertStmt(Stmt):
    pass

class ReturnStmt(Stmt):
    result: optional[Expr] | child

class ThrowStmt(Stmt):
    sub_expr: Expr | child

class YieldStmt(Stmt):
    results: list[Expr] | child

class DoCatchStmt(LabeledStmt):
    body: Stmt | child
    catches: list[CaseStmt] | child

class DoStmt(LabeledStmt):
    body: BraceStmt | child

class ForEachStmt(LabeledStmt):
    pattern: Pattern | child
    sequence: Expr | child
    where: optional[Expr] | child
    body: BraceStmt | child

class LabeledConditionalStmt(LabeledStmt):
    condition: StmtCondition | child

class RepeatWhileStmt(LabeledStmt):
    condition: Expr | child
    body: Stmt | child

class SwitchStmt(LabeledStmt):
    expr: Expr | child
    cases: list[CaseStmt] | child

class GuardStmt(LabeledConditionalStmt):
    body: BraceStmt | child

class IfStmt(LabeledConditionalStmt):
    then: Stmt | child
    else_: optional[Stmt] | child

class WhileStmt(LabeledConditionalStmt):
    body: Stmt | child

@group("type")
class TypeRepr(AstNode):
    type: Type

class AnyFunctionType(Type):
    result: Type
    param_types: list[Type]
    param_labels: list[string]
    is_throwing: predicate
    is_async: predicate

class AnyGenericType(Type):
    parent: optional[Type]
    declaration: Decl

class AnyMetatypeType(Type):
    pass

@qltest.collapse_hierarchy
class BuiltinType(Type):
    pass

class DependentMemberType(Type):
    baseType: Type
    associated_type_decl: AssociatedTypeDecl

class DynamicSelfType(Type):
    static_self_type: Type

class ErrorType(Type):
    pass

class ExistentialType(Type):
    constraint: Type

class InOutType(Type):
    object_type: Type

class LValueType(Type):
    object_type: Type

class ModuleType(Type):
    module: ModuleDecl

class PlaceholderType(Type):
    pass

class ProtocolCompositionType(Type):
    members: list[Type]

class ReferenceStorageType(Type):
    referent_type: Type

class SilBlockStorageType(Type):
    pass

class SilBoxType(Type):
    pass

class SilFunctionType(Type):
    pass

class SilTokenType(Type):
    pass

class SubstitutableType(Type):
    pass

class SugarType(Type):
    pass

class TupleType(Type):
    types: list[Type]
    names: list[string]

class TypeVariableType(Type):
    pass

class UnresolvedType(Type, UnresolvedElement):
    pass

class AnyBuiltinIntegerType(BuiltinType):
    pass

class ArchetypeType(SubstitutableType):
    interface_type: Type
    superclass: optional[Type]
    protocols: list[ProtocolDecl]

class BuiltinBridgeObjectType(BuiltinType):
    pass

class BuiltinDefaultActorStorageType(BuiltinType):
    pass

class BuiltinExecutorType(BuiltinType):
    pass

class BuiltinFloatType(BuiltinType):
    pass

class BuiltinJobType(BuiltinType):
    pass

class BuiltinNativeObjectType(BuiltinType):
    pass

class BuiltinRawPointerType(BuiltinType):
    pass

class BuiltinRawUnsafeContinuationType(BuiltinType):
    pass

class BuiltinUnsafeValueBufferType(BuiltinType):
    pass

class BuiltinVectorType(BuiltinType):
    pass

class ExistentialMetatypeType(AnyMetatypeType):
    pass

class FunctionType(AnyFunctionType):
    pass

class GenericFunctionType(AnyFunctionType):
    generic_params: list["GenericTypeParamType"]

class GenericTypeParamType(SubstitutableType):
    pass

class MetatypeType(AnyMetatypeType):
    pass

class NominalOrBoundGenericNominalType(AnyGenericType):
    pass

class ParenType(SugarType):
    type: Type

class SyntaxSugarType(SugarType):
    pass

class TypeAliasType(SugarType):
    decl: TypeAliasDecl

class UnboundGenericType(AnyGenericType):
    pass

class UnmanagedStorageType(ReferenceStorageType):
    pass

class UnownedStorageType(ReferenceStorageType):
    pass

class WeakStorageType(ReferenceStorageType):
    pass

class BoundGenericType(NominalOrBoundGenericNominalType):
    arg_types: list[Type]

class BuiltinIntegerLiteralType(AnyBuiltinIntegerType):
    pass

@qltest.uncollapse_hierarchy
class BuiltinIntegerType(AnyBuiltinIntegerType):
    width: optional[int]

class DictionaryType(SyntaxSugarType):
    key_type: Type
    value_type: Type

class NominalType(NominalOrBoundGenericNominalType):
    pass

class OpaqueTypeArchetypeType(ArchetypeType):
    pass

class OpenedArchetypeType(ArchetypeType):
    pass

class PrimaryArchetypeType(ArchetypeType):
    pass

class SequenceArchetypeType(ArchetypeType):
    pass

class UnarySyntaxSugarType(SyntaxSugarType):
    base_type: Type

class ArraySliceType(UnarySyntaxSugarType):
    pass

class BoundGenericClassType(BoundGenericType):
    pass

class BoundGenericEnumType(BoundGenericType):
    pass

class BoundGenericStructType(BoundGenericType):
    pass

class ClassType(NominalType):
    pass

class EnumType(NominalType):
    pass

class OptionalType(UnarySyntaxSugarType):
    pass

class ProtocolType(NominalType):
    pass

class StructType(NominalType):
    pass

class VariadicSequenceType(UnarySyntaxSugarType):
    pass

class PackType(Type):
    pass

class PackExpansionType(Type):
    pass

class ParameterizedProtocolType(Type):
    pass
