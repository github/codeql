from misc.codegen.lib.schemadefs import *

include("../shared/tree-sitter-extractor/src/generator/prefix.dbscheme")
include("prefix.dbscheme")


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
