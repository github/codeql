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


class Declaration(Locatable):
    pass


class Module(Declaration):
    # TODO name
    declarations: list[Declaration] | child


@qltest.collapse_hierarchy
class Expr(Locatable):
    pass


@qltest.collapse_hierarchy
class Pat(Locatable):
    pass


@qltest.collapse_hierarchy
class Stmt(Locatable):
    pass


@qltest.collapse_hierarchy
class TypeRef(Locatable):
    # TODO
    pass


class Function(Declaration):
    name: string
    body: Expr


#     Missing,
class MissingExpr(Expr):
    pass

#     Path(Path),


class Path(Expr):
    # TODO
    pass

#     If {
#         condition: ExprId,
#         then_branch: ExprId,
#         else_branch: Option<ExprId>,
#     },


class If(Expr):
    condition: Expr
    then_branch: Expr
    else_branch: optional[Expr]

#     Let {
#         pat: PatId,
#         expr: ExprId,
#     },


class Let(Expr):
    pat: Pat
    expr: Expr

#     Block {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#         label: Option<LabelId>,
#     },


class Block(Expr):
    statements: list[Stmt]
    tail: optional[Expr]
    label: optional[string]

#     Async {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#     },


class Async(Block):
    pass

#     Const(ConstBlockId),


class Const(Expr):
    pass

#     // FIXME: Fold this into Block with an unsafe flag?
#     Unsafe {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#     },


class Unsafe(Block):
    pass

#     Loop {
#         body: ExprId,
#         label: Option<LabelId>,
#     },


class Loop(Expr):
    body: Expr
    label: optional[string]

#     Call {
#         callee: ExprId,
#         args: Box<[ExprId]>,
#         is_assignee_expr: bool,
#     },


class Call(Expr):
    callee: Expr
    args: list[Expr]
    is_assignee_expr: predicate

#     MethodCall {
#         receiver: ExprId,
#         method_name: Name,
#         args: Box<[ExprId]>,
#         generic_args: Option<Box<GenericArgs>>,
#     },


class MethodCall(Expr):
    receiver: Expr
    method_name: string
    args: list[Expr]
    # TODO
    # generic_args: optional[GenericArgs]

# pub struct MatchArm {
#     pub pat: PatId,
#     pub guard: Option<ExprId>,
#     pub expr: ExprId,
# }


@qltest.skip
class MatchArm(Locatable):
    pat: Pat
    guard: optional[Expr]
    expr: Expr
#     Match {
#         expr: ExprId,
#         arms: Box<[MatchArm]>,
#     },


class Match(Expr):
    expr: Expr
    branches: list[MatchArm]

#     Continue {
#         label: Option<LabelId>,
#     },


class Continue(Expr):
    label: optional[string]

#     Break {
#         expr: Option<ExprId>,
#         label: Option<LabelId>,
#     },


class Break(Expr):
    expr: optional[Expr]
    label: optional[string]


#     Return {
#         expr: Option<ExprId>,
#     },

class Return(Expr):
    expr: optional[Expr]
#     Become {
#         expr: ExprId,
#     },


class Become(Expr):
    expr: Expr
#     Yield {
#         expr: Option<ExprId>,
#     },


class Yield(Expr):
    expr: optional[Expr]

#     Yeet {
#         expr: Option<ExprId>,
#     },


class Yeet(Expr):
    expr: optional[Expr]
#     RecordLit {
#         path: Option<Box<Path>>,
#         fields: Box<[RecordLitField]>,
#         spread: Option<ExprId>,
#         ellipsis: bool,
#         is_assignee_expr: bool,
#     },


class RecordLit(Expr):
    # TODO
    pass


#     Field {
#         expr: ExprId,
#         name: Name,
#     },

class Field(Expr):
    expr: Expr
    name: string

#     Await {
#         expr: ExprId,
#     },


class Await(Expr):
    expr: Expr

#     Cast {
#         expr: ExprId,
#         type_ref: Interned<TypeRef>,
#     },


class Cast(Expr):
    expr: Expr
    type_ref: TypeRef
#     Ref {
#         expr: ExprId,
#         rawness: Rawness,
#         mutability: Mutability,
#     },


class Ref(Expr):
    expr: Expr
    is_raw: predicate
    is_mut: predicate
#     Box {
#         expr: ExprId,
#     },


class Box(Expr):
    expr: Expr
#     UnaryOp {
#         expr: ExprId,
#         op: UnaryOp,
#     },


class UnaryExpr(Expr):
    expr: Expr
    op: string


#     BinaryOp {
#         lhs: ExprId,
#         rhs: ExprId,
#         op: Option<BinaryOp>,
#     },


class BinaryOp(Expr):
    lhs: Expr
    rhs: Expr
    op: optional[string]


#     Range {
#         lhs: Option<ExprId>,
#         rhs: Option<ExprId>,
#         range_type: RangeOp,
#     },


class Range(Expr):
    lhs: optional[Expr]
    rhs: optional[Expr]
    is_inclusive: predicate

#     Index {
#         base: ExprId,
#         index: ExprId,
#         is_assignee_expr: bool,
#     },


class Index(Expr):
    base: Expr
    index: Expr
    is_assignee_expr: predicate

#     Closure {
#         args: Box<[PatId]>,
#         arg_types: Box<[Option<Interned<TypeRef>>]>,
#         ret_type: Option<Interned<TypeRef>>,
#         body: ExprId,
#         closure_kind: ClosureKind,
#         capture_by: CaptureBy,
#     },


class Closure(Expr):
    args: list[Pat]
    arg_types: list[TypeRef]
    ret_type: optional[TypeRef]
    body: Expr
    # TODO
    # closure_kind: ClosureKind
    is_move: predicate
#     Tuple {
#         exprs: Box<[ExprId]>,
#         is_assignee_expr: bool,
#     },


class Tuple(Expr):
    exprs: list[Expr]
    is_assignee_expr: predicate

#     Array(Array),


class Array(Expr):
    pass
#     Literal(Literal),


class Literal(Expr):
    pass
#     Underscore,


class Underscore(Expr):
    pass
#     OffsetOf(OffsetOf),


class OffsetOf(Expr):
    pass
#     InlineAsm(InlineAsm),


class InlineAsm(Expr):
    pass


#    Let {
#         pat: PatId,
#         type_ref: Option<Interned<TypeRef>>,
#         initializer: Option<ExprId>,
#         else_branch: Option<ExprId>,
#     },

class IfLet(Stmt):
    pat: Pat
    type_ref: optional[TypeRef]
    initializer: optional[Expr]
    else_branch: optional[Expr]
#     Expr {
#         expr: ExprId,
#         has_semi: bool,
#     },


class ExprStmt(Stmt):
    expr: Expr
    has_semi: predicate

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
    args: list[Pat]
    ellipsis: optional[int]

    # Or(Box<[PatId]>),


class OrPat(Pat):
    args: list[Pat]
    # Record { path: Option<Box<Path>>, args: Box<[RecordFieldPat]>, ellipsis: bool },


class RecordPat(Pat):
    # TODO
    pass

    # Range { start: Option<Box<LiteralOrConst>>, end: Option<Box<LiteralOrConst>> },


class RangePat(Pat):
    start: optional[Pat]
    end: optional[Pat]
    # Slice { prefix: Box<[PatId]>, slice: Option<PatId>, suffix: Box<[PatId]> },


class SlicePat(Pat):
    prefix: list[Pat]
    # Path(Box<Path>),


class PathPat(Pat):
    pass
    # Lit(ExprId),


class LitPat(Pat):
    expr: Expr

    # Bind { id: BindingId, subpat: Option<PatId> },


class BindPat(Pat):
    binding_id: string
    subpat: optional[Pat]

    # TupleStruct { path: Option<Box<Path>>, args: Box<[PatId]>, ellipsis: Option<u32> },


class TupleStructPat(Pat):
    # TODO
    pass

    # Ref { pat: PatId, mutability: Mutability },


class RefPat(Pat):
    pat: Pat
    is_mut: predicate

    # Box { inner: PatId },


class BoxPat(Pat):
    inner: Pat
    # ConstBlock(ExprId),


class ConstBlockPat(Pat):
    expr: Expr
