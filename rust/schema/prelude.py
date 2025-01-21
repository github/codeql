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
    file: optional[File]
    duration_ms: int
