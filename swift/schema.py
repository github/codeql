"""
Schema description

This file should be kept simple:
* no flow control
* no aliases
* only class definitions with annotations and `include` calls

For how documentation of generated QL code works, please read schema_documentation.md.
"""

from misc.codegen.lib.schemadefs import *

include("prefix.dbscheme")

@qltest.skip
class Element:
    is_unknown: predicate | cpp.skip

@qltest.collapse_hierarchy
class File(Element):
    name: string
    is_successfully_extracted: predicate | cpp.skip

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
    location: optional[Location] | cpp.skip | doc("location associated with this element in the code")

@qltest.collapse_hierarchy
@qltest.skip
class ErrorElement(Locatable):
    """The superclass of all elements indicating some kind of error."""
    pass

@use_for_null
class UnspecifiedElement(ErrorElement):
    parent: optional[Element]
    property: string
    index: optional[int]
    error: string
    children: list["AstNode"] | child | desc("These will be present only in certain downgraded databases.")

class Comment(Locatable):
    text: string

class Diagnostics(Locatable):
    text: string
    kind: int

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
@ql.hideable
class Type(Element):
    name: string
    canonical_type: "Type" | desc("""
        This is the unique type we get after resolving aliases and desugaring. For example, given
        ```
        typealias MyInt = Int
        ```
        then `[MyInt?]` has the canonical type `Array<Optional<Int>>`.
    """)

@group("decl")
class Decl(AstNode):
    module: "ModuleDecl"
    members: list["Decl"] | child | desc("""
        Prefer to use more specific methods (such as `EnumDecl.getEnumElement`) rather than relying
        on the order of members given by `getMember`. In some cases the order of members may not
        align with expectations, and could change in future releases.
    """)

@group("expr")
@ql.hideable
class Expr(AstNode):
    """The base class for all expressions in Swift."""
    type: optional[Type]

@group("pattern")
@ql.hideable
class Pattern(AstNode):
    type: optional[Type]

@group("stmt")
class Stmt(AstNode):
    pass

@group("decl")
class GenericContext(Element):
    generic_type_params: list["GenericTypeParamDecl"] | child

@qltest.test_with("EnumDecl")
class EnumCaseDecl(Decl):
    elements: list["EnumElementDecl"]

class ExtensionDecl(GenericContext, Decl):
    extended_type_decl: "NominalTypeDecl"
    protocols: list["ProtocolDecl"]

class IfConfigDecl(Decl):
    active_elements: list[AstNode]

class ImportDecl(Decl):
    is_exported: predicate
    imported_module: optional["ModuleDecl"]
    declarations: list["ValueDecl"]

@qltest.skip
class MissingMemberDecl(Decl):
    """A placeholder for missing declarations that can arise on object deserialization."""
    name: string

class OperatorDecl(Decl):
    name: string

class PatternBindingDecl(Decl):
    inits: list[optional[Expr]] | child
    patterns: list[Pattern] | child

class PoundDiagnosticDecl(Decl):
    """ A diagnostic directive, which is either `#error` or `#warning`."""
    kind: int | desc("""This is 1 for `#error` and 2 for `#warning`.""") | ql.internal
    message: "StringLiteralExpr" | child

class PrecedenceGroupDecl(Decl):
    pass

class TopLevelCodeDecl(Decl):
    body: "BraceStmt" | child

class ValueDecl(Decl):
    interface_type: Type

class AbstractStorageDecl(ValueDecl):
    accessors: list["Accessor"] | child

class VarDecl(AbstractStorageDecl):
    """
    A declaration of a variable such as
    * a local variable in a function:
    ```
    func foo() {
      var x = 42  // <-
      let y = "hello"  // <-
      ...
    }
    ```
    * a member of a `struct` or `class`:
    ```
    struct S {
      var size : Int  // <-
    }
    ```
    * ...
    """
    name: string
    type: Type
    attached_property_wrapper_type: optional[Type]
    parent_pattern: optional[Pattern]
    parent_initializer: optional[Expr]
    property_wrapper_backing_var_binding: optional[PatternBindingDecl] | child | desc("""
        This is the synthesized binding introducing the property wrapper backing variable for this
        variable, if any. See `getPropertyWrapperBackingVar`.
    """)
    property_wrapper_backing_var: optional["VarDecl"] | child | desc("""
        This is the compiler synthesized variable holding the property wrapper for this variable, if any.

        For a property wrapper like
        ```
        @propertyWrapper struct MyWrapper { ... }

        struct S {
          @MyWrapper var x : Int = 42
        }
        ```
        the compiler synthesizes a variable in `S` along the lines of
        ```
          var _x = MyWrapper(wrappedValue: 42)
        ```
        This predicate returns such variable declaration.
    """)
    property_wrapper_projection_var_binding: optional[PatternBindingDecl] | child | desc("""
        This is the synthesized binding introducing the property wrapper projection variable for this
        variable, if any. See `getPropertyWrapperProjectionVar`.
    """)
    property_wrapper_projection_var: optional["VarDecl"] | child | desc("""
        If this variable has a property wrapper with a projected value, this is the corresponding
        synthesized variable holding that projected value, accessible with this variable's name
        prefixed with `$`.

        For a property wrapper like
        ```
        @propertyWrapper struct MyWrapper {
          var projectedValue : Bool
          ...
        }

        struct S {
          @MyWrapper var x : Int = 42
        }
        ```
        ```
        the compiler synthesizes a variable in `S` along the lines of
        ```
          var $x : Bool { ... }
        ```
        This predicate returns such variable declaration.
    """)

class ParamDecl(VarDecl):
    is_inout: predicate | doc("this is an `inout` parameter")
    property_wrapper_local_wrapped_var_binding: optional[PatternBindingDecl] | child | desc("""
        This is the synthesized binding introducing the property wrapper local wrapped projection
        variable for this variable, if any.
    """)
    property_wrapper_local_wrapped_var: optional["VarDecl"] | child | desc("""
        This is the synthesized local wrapped value, shadowing this parameter declaration in case it
        has a property wrapper.
    """)

class Callable(AstNode):
    name: optional[string] | doc("name of this callable") | desc("The name includes argument "
        "labels of the callable, for example `myFunction(arg:)`.")
    self_param: optional[ParamDecl] | child
    params: list[ParamDecl] | child
    body: optional["BraceStmt"] | child | desc("The body is absent within protocol declarations.")
    captures: list["CapturedDecl"] | child

@group("decl")
class Function(GenericContext, ValueDecl, Callable):
    pass

@qltest.test_with("EnumDecl")
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
    inherited_types: list[Type] | desc("""
        This only returns the types effectively appearing in the declaration. In particular it
        will not resolve `TypeAliasDecl`s or consider base types added by extensions.
    """)

class AbstractTypeParamDecl(TypeDecl):
    pass

@group("decl")
class Initializer(Function):
    pass

@group("decl")
class Deinitializer(Function):
    pass

@ql.internal
@group("decl")
class AccessorOrNamedFunction(Function):
    pass

class GenericTypeDecl(GenericContext, TypeDecl):
    pass

class ModuleDecl(TypeDecl):
    is_builtin_module: predicate | doc("this module is the built-in one")
    is_system_module: predicate | doc("this module is a system one")
    imported_modules: set["ModuleDecl"]
    exported_modules: set["ModuleDecl"]

class SubscriptDecl(AbstractStorageDecl, GenericContext):
    params: list[ParamDecl] | child
    element_type: Type
    element_type: Type

@group("decl")
class Accessor(AccessorOrNamedFunction):
    is_getter: predicate | doc('this accessor is a getter')
    is_setter: predicate | doc('this accessor is a setter')
    is_will_set: predicate | doc('this accessor is a `willSet`, called before the property is set')
    is_did_set: predicate | doc('this accessor is a `didSet`, called after the property is set')
    is_read: predicate | doc('this accessor is a `_read` coroutine, yielding a borrowed value of the property')
    is_modify: predicate | doc('this accessor is a `_modify` coroutine, yielding an inout value of the property')
    is_unsafe_address: predicate | doc('this accessor is an `unsafeAddress` immutable addressor')
    is_unsafe_mutable_address: predicate | doc('this accessor is an `unsafeMutableAddress` mutable addressor')

class AssociatedTypeDecl(AbstractTypeParamDecl):
    pass

@group("decl")
class NamedFunction(AccessorOrNamedFunction):
    pass

class ConcreteVarDecl(VarDecl):
    introducer_int: int | doc("introducer enumeration value") | desc("""
        This is 0 if the variable was introduced with `let` and 1 if it was introduced with `var`.
    """)

class GenericTypeParamDecl(AbstractTypeParamDecl):
    pass

class NominalTypeDecl(GenericTypeDecl):
    type: Type

class OpaqueTypeDecl(GenericTypeDecl):
    """
    A declaration of an opaque type, that is formally equivalent to a given type but abstracts it
    away.

    Such a declaration is implicitly given when a declaration is written with an opaque result type,
    for example
    ```
    func opaque() -> some SignedInteger { return 1 }
    ```
    See https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html.
    """
    naming_declaration: ValueDecl
    opaque_generic_params: list["GenericTypeParamType"]
    opaque_generic_params: list["GenericTypeParamType"]

class TypeAliasDecl(GenericTypeDecl):
    """
    A declaration of a type alias to another type. For example:
    ```
    typealias MyInt = Int
    ```
    """
    aliased_type: Type | doc("aliased type on the right-hand side of this type alias declaration") | desc("""
        For example the aliased type of `MyInt` in the following code is `Int`:
        ```
        typealias MyInt = Int
        ```
    """)

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

class ClosureExpr(Expr, Callable):
    pass

class AnyTryExpr(Expr):
    sub_expr: Expr | child

class AppliedPropertyWrapperExpr(Expr):
    """An implicit application of a property wrapper on the argument of a call."""
    kind: int | desc("This is 1 for a wrapped value and 2 for a projected one.")
    value: Expr | child | desc("The value on which the wrapper is applied.")
    param: ParamDecl | doc("parameter declaration owning this wrapper application")

class ApplyExpr(Expr):
    function: Expr | child | doc("function being applied")
    arguments: list[Argument] | child | doc("arguments passed to the applied function")

class AssignExpr(Expr):
    dest: Expr | child
    source: Expr | child

class BindOptionalExpr(Expr):
    sub_expr: Expr | child

class CapturedDecl(Decl):
    decl: ValueDecl | doc("the declaration captured by the parent closure")
    is_direct: predicate
    is_escaping: predicate

class CaptureListExpr(Expr):
    binding_decls: list[PatternBindingDecl] | child
    variables: list[VarDecl] | child | synth | desc("""
        These are the variables introduced by this capture in the closure's scope, not the captured ones.
    """)
    closure_body: "ClosureExpr" | child

class CollectionExpr(Expr):
    pass

class DeclRefExpr(Expr):
    decl: Decl
    replacement_types: list[Type]
    has_direct_to_storage_semantics: predicate
    has_direct_to_implementation_semantics: predicate
    has_ordinary_semantics: predicate
    has_distributed_thunk_semantics: predicate

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

class EnumIsCaseExpr(Expr):
    sub_expr: Expr | child
    element: EnumElementDecl

@qltest.skip
class ErrorExpr(Expr, ErrorElement):
    pass

class ExplicitCastExpr(Expr):
    sub_expr: Expr | child

class ForceValueExpr(Expr):
    sub_expr: Expr | child

@qltest.collapse_hierarchy
class IdentityExpr(Expr):
    sub_expr: Expr | child

class IfExpr(Expr):
    condition: Expr | child
    then_expr: Expr | child
    else_expr: Expr | child

@qltest.collapse_hierarchy
class ImplicitConversionExpr(Expr):
    sub_expr: Expr | child

class InOutExpr(Expr):
    sub_expr: Expr | child

class KeyPathApplicationExpr(Expr):
    base: Expr | child
    key_path: Expr | child

class KeyPathDotExpr(Expr):
    pass

class KeyPathComponent(AstNode):
    """
    A component of a `KeyPathExpr`.
    """
    kind: int | doc("kind of key path component") | desc("""
        INTERNAL: Do not use.

        This is 3 for properties, 4 for array and dictionary subscripts, 5 for optional forcing
        (`!`), 6 for optional chaining (`?`), 7 for implicit optional wrapping, 8 for `self`,
        and 9 for tuple element indexing.

        The following values should not appear: 0 for invalid components, 1 for unresolved
        properties, 2 for unresolved subscripts, 10 for #keyPath dictionary keys, and 11 for
        implicit IDE code completion data.
    """)
    subscript_arguments : list[Argument] | child | doc(
        "arguments to an array or dictionary subscript expression")
    tuple_index : optional[int]
    decl_ref : optional[ValueDecl] | doc("property or subscript operator")
    component_type : Type | doc("return type of this component application") | desc("""
        An optional-chaining component has a non-optional type to feed into the rest of the key
        path; an optional-wrapping component is inserted if required to produce an optional type
        as the final output.
    """)


class KeyPathExpr(Expr):
    """
    A key-path expression.
    """
    root: optional["TypeRepr"] | child
    components: list[KeyPathComponent] | child

class LazyInitializationExpr(Expr):
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
    method: Function

class OneWayExpr(Expr):
    sub_expr: Expr | child

class OpaqueValueExpr(Expr):
    pass

class OpenExistentialExpr(Expr):
    """ An implicit expression created by the compiler when a method is called on a protocol. For example in
    ```
    protocol P {
      func foo() -> Int
    }
    func bar(x: P) -> Int {
      return x.foo()
    }
    `x.foo()` is actually wrapped in an `OpenExistentialExpr` that "opens" `x` replacing it in its subexpression with
    an `OpaqueValueExpr`.
    ```
    """
    sub_expr: Expr | child | desc("""
        This wrapped subexpression is where the opaque value and the dynamic type under the protocol type may be used.""")
    existential: Expr | child | doc("protocol-typed expression opened by this expression")
    opaque_expr: OpaqueValueExpr | doc("opaque value expression embedded within `getSubExpr()`")

class OptionalEvaluationExpr(Expr):
    sub_expr: Expr | child

class OtherInitializerRefExpr(Expr):
    initializer: Initializer

class PropertyWrapperValuePlaceholderExpr(Expr):
    """
    A placeholder substituting property initializations with `=` when the property has a property
    wrapper with an initializer.
    """
    wrapped_value: optional[Expr]
    placeholder: OpaqueValueExpr

class RebindSelfInInitializerExpr(Expr):
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
class UnresolvedDeclRefExpr(Expr, ErrorElement):
    name: optional[string]
class UnresolvedDotExpr(Expr, ErrorElement):
    base: Expr | child
    name: string
class UnresolvedMemberExpr(Expr, ErrorElement):
    name: string
class UnresolvedPatternExpr(Expr, ErrorElement):
    sub_pattern: Pattern | child
class UnresolvedSpecializeExpr(Expr, ErrorElement):
    sub_expr: Expr | child

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

class AutoClosureExpr(ClosureExpr):
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

class ExplicitClosureExpr(ClosureExpr):
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

@qltest.collapse_hierarchy
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
    has_distributed_thunk_semantics: predicate

class MetatypeConversionExpr(ImplicitConversionExpr):
    pass

class NilLiteralExpr(LiteralExpr):
    pass

class ObjectLiteralExpr(LiteralExpr):
    """
    An instance of `#fileLiteral`, `#imageLiteral` or `#colorLiteral` expressions, which are used in playgrounds.
    """
    kind: int | desc("""This is 0 for `#fileLiteral`, 1 for `#imageLiteral` and 2 for `#colorLiteral`.""")
    arguments: list[Argument] | child

class OptionalTryExpr(AnyTryExpr):
    pass

class OverloadedDeclRefExpr(Expr, ErrorElement):
    """
    An ambiguous expression that might refer to multiple declarations. This will be present only
    for failing compilations.
    """
    possible_declarations: list[ValueDecl]

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

@ql.default_doc_name("regular expression")
class RegexLiteralExpr(LiteralExpr):
    """A regular expression literal which is checked at compile time, for example `/a(a|b)*b/`."""
    pattern: string
    version: int | doc(
        "version of the internal regular expression language being used by Swift")


@ql.internal
class SelfApplyExpr(ApplyExpr):
    """
    An internal raw instance of method lookups like `x.foo` in `x.foo()`.
    This is completely replaced by the synthesized type `MethodLookupExpr`.
    """
    base: Expr

class StringToPointerExpr(ImplicitConversionExpr):
    pass

class SubscriptExpr(LookupExpr):
    arguments: list[Argument] | child
    has_direct_to_storage_semantics: predicate
    has_direct_to_implementation_semantics: predicate
    has_ordinary_semantics: predicate
    has_distributed_thunk_semantics: predicate

class TryExpr(AnyTryExpr):
    pass

class UnderlyingToOpaqueExpr(ImplicitConversionExpr):
    pass

class UnevaluatedInstanceExpr(ImplicitConversionExpr):
    pass
class UnresolvedMemberChainResultExpr(IdentityExpr, ErrorElement):
    pass
class UnresolvedTypeConversionExpr(ImplicitConversionExpr, ErrorElement):
    pass
class BooleanLiteralExpr(BuiltinLiteralExpr):
    value: boolean

class ConditionalCheckedCastExpr(CheckedCastExpr):
    pass

@ql.internal
class InitializerRefCallExpr(SelfApplyExpr):
    pass

@ql.internal
class DotSyntaxCallExpr(SelfApplyExpr):
    pass

@synth.from_class(SelfApplyExpr)
class MethodLookupExpr(LookupExpr):
    method_ref: Expr | child | doc("the underlying method declaration reference expression")

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
    var_decl: VarDecl

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
@qltest.test_with("SwitchStmt")
class CaseLabelItem(AstNode):
    pattern: Pattern | child
    guard: optional[Expr] | child

class AvailabilitySpec(AstNode):
    """
    An availability spec, that is, part of an `AvailabilityInfo` condition. For example `iOS 12` and `*` in:
    ```
    if #available(iOS 12, *)
    ```
    """
    pass

class PlatformVersionAvailabilitySpec(AvailabilitySpec):
    """
    An availability spec based on platform and version, for example `macOS 12` or `watchOS 14`
    """
    platform: string
    version: string

class OtherAvailabilitySpec(AvailabilitySpec):
    """
    A wildcard availability spec `*`
    """
    pass

class AvailabilityInfo(AstNode):
    """
    An availability condition of an `if`, `while`, or `guard` statements.

    Examples:
    ```
    if #available(iOS 12, *) {
      // Runs on iOS 12 and above
    } else {
      // Runs only anything below iOS 12
    }
    if #unavailable(macOS 10.14, *) {
      // Runs only on macOS 10 and below
    }
    ```
    """
    is_unavailable: predicate | doc("it is #unavailable as opposed to #available")
    specs: list[AvailabilitySpec] | child

@group("stmt")
class ConditionElement(AstNode):
    boolean: optional[Expr] | child
    pattern: optional[Pattern] | child
    initializer: optional[Expr] | child
    availability: optional[AvailabilityInfo] | child

@group("stmt")
class StmtCondition(AstNode):
    elements: list[ConditionElement] | child

class BraceStmt(Stmt):
    variables: list[VarDecl] | synth | child | doc("variable declared in the scope of this brace statement")
    elements: list[AstNode] | child

class BreakStmt(Stmt):
    target_name: optional[string]
    target: optional[Stmt]

@qltest.test_with("SwitchStmt")
class CaseStmt(Stmt):
    labels: list[CaseLabelItem] | child
    variables: list[VarDecl] | child
    body: Stmt | child

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
    condition: Expr
    message: string

class ReturnStmt(Stmt):
    result: optional[Expr] | child

class ThrowStmt(Stmt):
    sub_expr: Expr | child

class YieldStmt(Stmt):
    results: list[Expr] | child

@qltest.test_with('SingleValueStmtExpr')
class ThenStmt(Stmt):
    """ A statement implicitly wrapping values to be used in branches of if/switch expressions. For example in:
    ```
    let rank = switch value {
        case 0..<0x80: 1
        case 0x80..<0x0800: 2
        default: 3
    }
    ```
    the literal expressions `1`, `2` and `3` are wrapped in `ThenStmt`.
    """
    result: Expr | child

class DoCatchStmt(LabeledStmt):
    body: Stmt | child
    catches: list[CaseStmt] | child

class DoStmt(LabeledStmt):
    body: BraceStmt | child

class ForEachStmt(LabeledStmt):
    variables: list[VarDecl] | child
    pattern: Pattern | child
    where: optional[Expr] | child
    iteratorVar: optional[PatternBindingDecl] | child
    nextCall: optional[Expr] | child
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

@ql.default_doc_name("function type")
class AnyFunctionType(Type):
    result: Type
    param_types: list[Type]
    is_throwing: predicate | doc("this type refers to a throwing function")
    is_async: predicate | doc("this type refers to an `async` function")

class AnyGenericType(Type):
    parent: optional[Type]
    declaration: GenericTypeDecl

class AnyMetatypeType(Type):
    pass

@qltest.collapse_hierarchy
class BuiltinType(Type):
    pass

class DependentMemberType(Type):
    base_type: Type
    associated_type_decl: AssociatedTypeDecl

class DynamicSelfType(Type):
    static_self_type: Type
class ErrorType(Type, ErrorElement):
    pass

class ExistentialType(Type):
    constraint: Type

class InOutType(Type):
    object_type: Type

class LValueType(Type):
    object_type: Type

class ModuleType(Type):
    module: ModuleDecl

class ProtocolCompositionType(Type):
    members: list[Type]

class ReferenceStorageType(Type):
    referent_type: Type

class SubstitutableType(Type):
    pass

class SugarType(Type):
    pass

class TupleType(Type):
    types: list[Type]
    names: list[optional[string]]
class UnresolvedType(Type, ErrorElement):
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
    """ The type of a generic function with type parameters """
    generic_params: list["GenericTypeParamType"] | doc("type {parameters} of this generic type")

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
    """An opaque type, that is a type formally equivalent to an underlying type but abstracting it away.

    See https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html."""
    declaration: OpaqueTypeDecl

class PrimaryArchetypeType(ArchetypeType):
    pass

class LocalArchetypeType(ArchetypeType):
    pass

class OpenedArchetypeType(LocalArchetypeType):
    pass

@qltest.test_with("PackType")
class ElementArchetypeType(LocalArchetypeType):
    """
    An archetype type of PackElementType.
    """
    pass

@qltest.test_with("PackType")
class PackArchetypeType(ArchetypeType):
    """
    An archetype type of PackType.
    """
    pass

class PackType(Type):
    """
    An actual type of a pack expression at the instatiation point.

    In the following example, PackType will appear around `makeTuple` call site as `Pack{String, Int}`:
    ```
    func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) { ... }
    makeTuple("A", 2)
    ```

    More details:
    https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
    """
    elements: list[Type]

@qltest.test_with(PackType)
class PackExpansionType(Type):
    """
    A type of PackExpansionExpr, see PackExpansionExpr for more information.
    """
    pattern_type: Type
    count_type: Type

@qltest.test_with(PackType)
class PackElementType(Type):
    """
    A type of PackElementExpr, see PackElementExpr for more information.
    """
    pack_type: Type

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

class ParameterizedProtocolType(Type):
    """
    A sugar type of the form `P<X>` with `P` a protocol.

    If `P` has primary associated type `A`, then `T: P<X>` is a shortcut for `T: P where T.A == X`.
    """
    base: ProtocolType
    args: list[Type]

class AbiSafeConversionExpr(ImplicitConversionExpr):
    pass


class SingleValueStmtExpr(Expr):
    """
    An expression that wraps a statement which produces a single value.
    """
    stmt: Stmt | child

class PackExpansionExpr(Expr):
    """
    A pack expansion expression.

    In the following example, `repeat each t` on the second line is the pack expansion expression:
    ```
    func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
      return (repeat each t)
    }
    ```

    More details:
    https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
    """
    pattern_expr: Expr | child

@qltest.test_with(PackExpansionExpr)
class PackElementExpr(Expr):
    """
    A pack element expression is a child of PackExpansionExpr.

    In the following example, `each t` on the second line is the pack element expression:
    ```
    func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
      return (repeat each t)
    }
    ```

    More details:
    https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
    """
    sub_expr: Expr | child

@qltest.test_with(PackExpansionExpr)
class MaterializePackExpr(Expr):
    """
    An expression that materializes a pack during expansion. Appears around PackExpansionExpr.

    More details:
    https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
    """
    sub_expr: Expr | child

class CopyExpr(Expr):
    """
    An expression that forces value to be copied. In the example below, `copy` marks the copy expression:

    ```
    let y = ...
    let x = copy y
    ```
    """
    sub_expr: Expr | child

@qltest.test_with(CopyExpr)
class ConsumeExpr(Expr):
    """
    An expression that forces value to be moved. In the example below, `consume` marks the move expression:

    ```
    let y = ...
    let x = consume y
    ```
    """
    sub_expr: Expr | child

class BorrowExpr(IdentityExpr):
    """
    An expression that marks value as borrowed. In the example below, `_borrow` marks the borrow expression:

    ```
    let y = ...
    let x = _borrow y
    ```
    """
    pass

@qltest.test_with('MacroDecl')
class MacroRole(AstNode):
    """
    The role of a macro, for example #freestanding(declaration) or @attached(member).
    """
    kind: int | doc("kind of this macro role (declaration, expression, member, etc.)") | ql.internal
    macro_syntax: int | doc("#freestanding or @attached") | ql.internal
    conformances: list[TypeExpr] | doc("conformances of this macro role")
    names: list[string] | doc("names of this macro role")

class MacroDecl(GenericContext, ValueDecl):
    """
    A declaration of a macro. Some examples:

    ```
    @freestanding(declaration)
    macro A() = #externalMacro(module: "A", type: "A")
    @freestanding(expression)
    macro B() = Builtin.B
    @attached(member)
    macro C() = C.C
    ```
    """
    name: string | doc("name of this macro")
    parameters: list[ParamDecl] | doc("parameters of this macro")
    roles: list[MacroRole] | doc("roles of this macro")
    pass

class DiscardStmt(Stmt):
    """
    A statement that takes a non-copyable value and destructs its members/fields.

    The only valid syntax:
    ```
    destruct self
    ```
    """
    sub_expr: Expr | child
