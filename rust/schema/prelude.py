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
    crate_origin: optional[string] | desc("One of `rustc:<name>`, `repo:<repository>:<name>` or `lang:<name>`.") | rust.detach | ql.internal
    canonical_path: optional["CanonicalPath"] | rust.detach | ql.internal

class Resolvable(AstNode):
    """
    One of `PathExpr`, `RecordExpr`, `PathPat`, `RecordPat`, `TupleStructPat` or `MethodCallExpr`.
    """
    resolved_path: optional[string] | rust.detach | ql.internal
    resolved_crate_origin: optional[string] | rust.detach | ql.internal
    resolved_canonical_path: optional["CanonicalPath"] | rust.detach | ql.internal

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

@group("canonical_paths")
@qltest.collapse_hierarchy
@qltest.skip
class CanonicalPathElement(Element):
    """
    The base class for all elements in a canonical path.
    """

class CanonicalPath(CanonicalPathElement):
    """
    The base class for all canonical paths that can be the result of a path resolution.
    """

class Namespace(CanonicalPath):
    """
    A namespace, comprised of a crate root and a possibly empty `::` separated module path.
    """
    root: "CrateRoot"
    path: string

class CrateRoot(CanonicalPathElement):
    """
    The base class for all crate references.
    """

class LangCrateRoot(CrateRoot):
    """
    A reference to a crate in the Rust standard libraries.
    """
    name: string

class RustcCrateRoot(CrateRoot):
    """
    A reference to a crate provided by rustc. TODO: understand where these come from.
    """
    name: string

class RepoCrateRoot(CrateRoot):
    """
    A reference to a crate in the repository.
    """
    # TODO this should be unified with crate identification done to extract dependency definitions
    name: optional[string]
    repo: optional[string]
    source: File

class TypeGenericArg(CanonicalPathElement):
    """
    A generic argument for a type.
    """

class TypeGenericTypeArg(TypeGenericArg):
    """
    A generic argument for a type that is a type.
    """
    path: "TypeCanonicalPath"


class ConstGenericTypeArg(TypeGenericArg):
    """
    A generic argument for a type that is a const.
    """
    value: string


class TypeCanonicalPath(CanonicalPath):
    """
    The base for canonical paths for types.
    """
    pass

class ConcreteTypeCanonicalPath(TypeCanonicalPath):
    """
    A canonical path for an actual type.
    """
    path: "ParametrizedCanonicalPath"

class PlaceholderTypeCanonicalPath(TypeCanonicalPath):
    """
    A placeholder for a type parameter bound in an impl.
    """

class BuiltinTypeCanonicalPath(TypeCanonicalPath):
    """
    A canonical path for a builtin type.
    """
    name: string

class DerivedTypeCanonicalPath(TypeCanonicalPath):
    """
    A derived canonical type, like `[i32; 4]`, `&mut std::string::String` or `(i32, std::string::String)`.
    """
    modifiers: list[string]
    base: list[TypeCanonicalPath]

class ModuleItemCanonicalPath(CanonicalPath):
    """
    A canonical path for an item defined in a module.
    """
    namespace: Namespace
    name: string

class ParametrizedCanonicalPath(CanonicalPath):
    base: ModuleItemCanonicalPath
    generic_args: list[TypeGenericArg]

class TypeItemCanonicalPath(CanonicalPath):
    """
    A canonical path for an item defined in a type or trait.
    """
    parent: ModuleItemCanonicalPath
    name: string

class TraitImplItemCanonicalPath(CanonicalPath):
    """
    A canonical path for an item defined in a trait impl.
    """
    type_path: TypeCanonicalPath
    trait_path: ParametrizedCanonicalPath
    name: string

class TypeImplItemCanonicalPath(CanonicalPath):
    """
    A canonical path for an item defined in a type impl.
    """
    parent: ModuleItemCanonicalPath
    name: string
