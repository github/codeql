"""
Schema description

This file should be kept simple:
* no flow control
* no aliases
* only class definitions with annotations and `include` calls

For how documentation of generated QL code works, please read `misc/codegen/schema_documentation.md`.
"""

from misc.codegen.lib.schemadefs import *

include("prefix.dbscheme")


@qltest.skip
class Element:
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


@qltest.skip
class Locatable(Element):
    location: optional[Location]


@qltest.skip
class AstNode(Locatable):
    pass


@qltest.skip
class Unimplemented(AstNode):
    pass


class Declaration(AstNode):
    pass


class Module(Declaration):
    # TODO name
    declarations: list[Declaration] | child


@qltest.collapse_hierarchy
class Expr(AstNode):
    pass


@qltest.collapse_hierarchy
class Pat(AstNode):
    pass


@qltest.skip
class Label(AstNode):
    name: string


@qltest.collapse_hierarchy
class Stmt(AstNode):
    pass


@qltest.collapse_hierarchy
class TypeRef(AstNode):
    # TODO
    pass


class Function(Declaration):
    """
    A function declaration. For example
    ```
    fn foo(x: u32) -> u64 { (x + 1).into() }
    ```
    A function declaration within a trait might not have a body:
    ```
    trait Trait {
        fn bar();
    }
    ```
    """
    name: string
    body: Expr | child


#     Missing,
class MissingExpr(Expr):
    pass

#     Path(Path),


class PathExpr(Expr):
    # TODO
    pass

#     If {
#         condition: ExprId,
#         then_branch: ExprId,
#         else_branch: Option<ExprId>,
#     },


class IfExpr(Expr):
    condition: Expr | child
    then: Expr | child
    else_: optional[Expr] | child

#     Let {
#         pat: PatId,
#         expr: ExprId,
#     },


class LetExpr(Expr):
    pat: Pat | child
    expr: Expr | child

#     Block {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#         label: Option<LabelId>,
#     },


class BlockExprBase(Expr):
    statements: list[Stmt] | child
    tail: optional[Expr] | child


class BlockExpr(BlockExprBase):
    label: optional[Label] | child

#     Async {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#     },


class AsyncBlockExpr(BlockExprBase):
    pass

#     Const(ConstBlockId),


class ConstExpr(Expr):
    pass

#     // FIXME: Fold this into Block with an unsafe flag?
#     Unsafe {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#     },


class UnsafeBlockExpr(BlockExprBase):
    pass

#     Loop {
#         body: ExprId,
#         label: Option<LabelId>,
#     },


class LoopExpr(Expr):
    body: Expr | child
    label: optional[Label] | child

#     Call {
#         callee: ExprId,
#         args: Box<[ExprId]>,
#         is_assignee_expr: bool,
#     },


class CallExpr(Expr):
    callee: Expr | child
    args: list[Expr] | child
    is_assignee_expr: predicate

#     MethodCall {
#         receiver: ExprId,
#         method_name: Name,
#         args: Box<[ExprId]>,
#         generic_args: Option<Box<GenericArgs>>,
#     },


class MethodCallExpr(Expr):
    receiver: Expr | child
    method_name: string
    args: list[Expr] | child
    # TODO
    # generic_args: optional[GenericArgs]

# pub struct MatchArm {
#     pub pat: PatId,
#     pub guard: Option<ExprId>,
#     pub expr: ExprId,
# }


@qltest.skip
class MatchArm(AstNode):
    pat: Pat | child
    guard: optional[Expr] | child
    expr: Expr | child
#     Match {
#         expr: ExprId,
#         arms: Box<[MatchArm]>,
#     },


class MatchExpr(Expr):
    expr: Expr | child
    branches: list[MatchArm] | child

#     Continue {
#         label: Option<LabelId>,
#     },


class ContinueExpr(Expr):
    label: optional[Label] | child

#     Break {
#         expr: Option<ExprId>,
#         label: Option<LabelId>,
#     },


class BreakExpr(Expr):
    expr: optional[Expr] | child
    label: optional[Label] | child


#     Return {
#         expr: Option<ExprId>,
#     },

class ReturnExpr(Expr):
    expr: optional[Expr] | child
#     Become {
#         expr: ExprId,
#     },


class BecomeExpr(Expr):
    expr: Expr | child
#     Yield {
#         expr: Option<ExprId>,
#     },


class YieldExpr(Expr):
    expr: optional[Expr] | child

#     Yeet {
#         expr: Option<ExprId>,
#     },


class YeetExpr(Expr):
    expr: optional[Expr] | child
#     RecordLit {
#         path: Option<Box<Path>>,
#         fields: Box<[RecordLitField]>,
#         spread: Option<ExprId>,
#         ellipsis: bool,
#         is_assignee_expr: bool,
#     },


class RecordLitExpr(Expr):
    # TODO
    pass


#     Field {
#         expr: ExprId,
#         name: Name,
#     },

class FieldExpr(Expr):
    expr: Expr | child
    name: string

#     Await {
#         expr: ExprId,
#     },


class AwaitExpr(Expr):
    expr: Expr | child

#     Cast {
#         expr: ExprId,
#         type_ref: Interned<TypeRef>,
#     },


class CastExpr(Expr):
    expr: Expr | child
    type_ref: TypeRef | child
#     Ref {
#         expr: ExprId,
#         rawness: Rawness,
#         mutability: Mutability,
#     },


class RefExpr(Expr):
    expr: Expr | child
    is_raw: predicate
    is_mut: predicate
#     Box {
#         expr: ExprId,
#     },


class BoxExpr(Expr):
    expr: Expr | child
#     UnaryOp {
#         expr: ExprId,
#         op: UnaryOp,
#     },


class UnaryOpExpr(Expr):
    expr: Expr | child
    op: string


#     BinaryOp {
#         lhs: ExprId,
#         rhs: ExprId,
#         op: Option<BinaryOp>,
#     },


class BinaryOpExpr(Expr):
    lhs: Expr | child
    rhs: Expr | child
    op: optional[string]


#     Range {
#         lhs: Option<ExprId>,
#         rhs: Option<ExprId>,
#         range_type: RangeOp,
#     },


class RangeExpr(Expr):
    lhs: optional[Expr] | child
    rhs: optional[Expr] | child
    is_inclusive: predicate

#     Index {
#         base: ExprId,
#         index: ExprId,
#         is_assignee_expr: bool,
#     },


class IndexExpr(Expr):
    base: Expr | child
    index: Expr | child
    is_assignee_expr: predicate

#     Closure {
#         args: Box<[PatId]>,
#         arg_types: Box<[Option<Interned<TypeRef>>]>,
#         ret_type: Option<Interned<TypeRef>>,
#         body: ExprId,
#         closure_kind: ClosureKind,
#         capture_by: CaptureBy,
#     },


class ClosureExpr(Expr):
    args: list[Pat] | child
    arg_types: list[optional[TypeRef]] | child
    ret_type: optional[TypeRef] | child
    body: Expr | child
    # TODO
    # closure_kind: ClosureKind
    is_move: predicate
#     Tuple {
#         exprs: Box<[ExprId]>,
#         is_assignee_expr: bool,
#     },


class TupleExpr(Expr):
    exprs: list[Expr] | child
    is_assignee_expr: predicate

#     Array(Array),


class ArrayExpr(Expr):
    pass
#     Literal(Literal),

# ElementList { elements: Box<[ExprId]>, is_assignee_expr: bool },


class ElementListExpr(ArrayExpr):
    elements: list[Expr] | child
    is_assignee_expr: predicate

# Repeat { initializer: ExprId, repeat: ExprId },


class RepeatExpr(ArrayExpr):
    initializer: Expr | child
    repeat: Expr | child


class LiteralExpr(Expr):
    pass
#     Underscore,


class UnderscoreExpr(Expr):
    pass
#     OffsetOf(OffsetOf),


class OffsetOfExpr(Expr):
    container: TypeRef | child
    fields: list[string]

#     InlineAsm(InlineAsm),


class InlineAsmExpr(Expr):
    expr: Expr | child


#    Let {
#         pat: PatId,
#         type_ref: Option<Interned<TypeRef>>,
#         initializer: Option<ExprId>,
#         else_branch: Option<ExprId>,
#     },

class LetStmt(Stmt):
    pat: Pat | child
    type_ref: optional[TypeRef] | child
    initializer: optional[Expr] | child
    else_: optional[Expr] | child
#     Expr {
#         expr: ExprId,
#         has_semi: bool,
#     },


class ExprStmt(Stmt):
    expr: Expr | child
    has_semicolon: predicate

#     // At the moment, we only use this to figure out if a return expression
#     // is really the last statement of a block. See #16566
#     Item,


class ItemStmt(Stmt):
    pass

    # Missing,


class MissingPat(Pat):
    pass
    # Wild,


class WildPat(Pat):
    pass
    # Tuple { args: Box<[PatId]>, ellipsis: Option<u32> },


class TuplePat(Pat):
    args: list[Pat] | child
    ellipsis_index: optional[int]

    # Or(Box<[PatId]>),


class OrPat(Pat):
    args: list[Pat] | child
    # Record { path: Option<Box<Path>>, args: Box<[RecordFieldPat]>, ellipsis: bool },


class RecordPat(Pat):
    # TODO
    pass

    # Range { start: Option<Box<LiteralOrConst>>, end: Option<Box<LiteralOrConst>> },


class RangePat(Pat):
    start: optional[Pat] | child
    end: optional[Pat] | child
    # Slice { prefix: Box<[PatId]>, slice: Option<PatId>, suffix: Box<[PatId]> },


class SlicePat(Pat):
    prefix: list[Pat] | child
    slice: optional[Pat] | child
    suffix: list[Pat] | child
    # Path(Box<Path>),


class PathPat(Pat):
    pass
    # Lit(ExprId),


class LitPat(Pat):
    expr: Expr | child

    # Bind { id: BindingId, subpat: Option<PatId> },


class BindPat(Pat):
    binding_id: string
    subpat: optional[Pat] | child

    # TupleStruct { path: Option<Box<Path>>, args: Box<[PatId]>, ellipsis: Option<u32> },


class TupleStructPat(Pat):
    # TODO
    pass

    # Ref { pat: PatId, mutability: Mutability },


class RefPat(Pat):
    pat: Pat | child
    is_mut: predicate

    # Box { inner: PatId },


class BoxPat(Pat):
    inner: Pat | child
    # ConstBlock(ExprId),


class ConstBlockPat(Pat):
    expr: Expr | child
