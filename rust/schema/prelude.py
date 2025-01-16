from misc.codegen.lib.schemadefs import *

include("../shared/tree-sitter-extractor/src/generator/prefix.dbscheme")
include("prefix.dbscheme")

File = imported("File", "codeql.files.FileSystem")


@qltest.skip
class Element:
    pass


@qltest.skip
class Locatable(Element):
    pass


@qltest.skip
class AstNode(Locatable):
    pass


@qltest.skip
class Token(AstNode):
    """
    The base class for all tokens.
    """
    pass


class Comment(Token):
    """
    A comment. For example:
    ```rust
    // this is a comment
    /// This is a doc comment
    ```
    """
    parent: AstNode
    text: string


@qltest.skip
class Unextracted(Element):
    """
    The base class marking everything that was not properly extracted for some reason, such as:
    * syntax errors
    * insufficient context information
    * yet unimplemented parts of the extractor
    """
    pass


@qltest.skip
class Missing(Unextracted):
    """
    The base class marking errors during parsing or resolution.
    """


@qltest.skip
class Unimplemented(Unextracted):
    """
    The base class for unimplemented nodes. This is used to mark nodes that are not yet extracted.
    """
    pass


class Callable(AstNode):
    """
    A callable. Either a `Function` or a `ClosureExpr`.
    """
    param_list: optional["ParamList"] | child
    attrs: list["Attr"] | child


class Addressable(AstNode):
    """
    Something that can be addressed by a path.

    TODO: This does not yet include all possible cases.
    """
    extended_canonical_path: optional[string] | desc("""
        Either a canonical path (see https://doc.rust-lang.org/reference/paths.html#canonical-paths),
        or `{<block id>}::name` for addressable items defined in an anonymous block (and only
        addressable there-in).
    """) | rust.detach | ql.internal
    crate_origin: optional[string] | desc(
        "One of `rustc:<name>`, `repo:<repository>:<name>` or `lang:<name>`.") | rust.detach | ql.internal


class Resolvable(AstNode):
    """
    One of `PathExpr`, `RecordExpr`, `PathPat`, `RecordPat`, `TupleStructPat` or `MethodCallExpr`.
    """
    resolved_path: optional[string] | rust.detach | ql.internal
    resolved_crate_origin: optional[string] | rust.detach | ql.internal


class PathAstNode(Resolvable):
    """
    An AST element wrapping a path (`PathExpr`, `RecordExpr`, `PathPat`, `RecordPat`, `TupleStructPat`).
    """
    path: optional["Path"] | child


@qltest.skip
@ql.internal
class ExtractorStep(Element):
    action: string
    file: File
    duration_ms: int


class Type(Element):
    pass


class NeverType(Type):
    pass


class PlaceholderType(Type):
    pass


class TupleType(Type):
    fields: list[Type]


class RawPtrType(Type):
    type: Type
    is_mut: predicate


class ReferenceType(Type):
    type: Type
    lifetime: optional[string]
    is_mut: predicate


class ArrayType(Type):
    type: Type


class SliceType(Type):
    type: Type


class FunctionType(Type):
    self_type: optional[Type]
    params: list[Type]
    ret_type: Type
    is_const: predicate
    is_async: predicate
    is_unsafe: predicate
    has_varargs: predicate


class PathType(Type):
    path: list[string]


class TypeBoundType(Element):
    pass


class TraitTypeBound(TypeBoundType):
    path: list[string]


class LifetimeTypeBound(TypeBoundType):
    name: string


class ForLifetimeTypeBound(TypeBoundType):
    names: list[string]
    path: list[string]


class DynTraitType(Type):
    type_bounds: list[TypeBoundType]


class ImplTraitType(Type):
    type_bounds: list[TypeBoundType]


class ErrorType(Type):
    pass


class ModuleContainer(Element):
    pass


class VariantData(Element):
    types: list[Type]
    fields: list[string]
    is_record: predicate


class TypeItem(Element):
    pass


class StructItem(TypeItem):
    name: string
    content: optional[VariantData]
    is_union: predicate


class EnumVariant(Element):
    name: string
    content: optional[VariantData]


class EnumItem(TypeItem):
    name: string
    variants: list[EnumVariant]


class TraitItem(TypeItem):
    name: string
    method_names: list[string]
    method_types: list[FunctionType]
    # TODO: type alias and constant items


class ValueItem(Element):
    name: string
    type: Type


class ImplItem(Element):
    target_trait: list[string]
    self_ty: Type
    method_names: list[string]
    method_types: list[FunctionType]


class CrateModule(ModuleContainer):
    parent: ModuleContainer
    name: string
    values: list[ValueItem]
    types: list[TypeItem]
    impls: list[ImplItem]


class Crate(ModuleContainer):
    name: optional[string]
    version: optional[string]
    cfg_options: list[string]
    dependencies: list["Crate"]
