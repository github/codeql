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


class Expr(AstNode):
    pass


@qltest.collapse_hierarchy
class Pat(AstNode):
    pass


@qltest.skip
class Label(AstNode):
    name: string


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


@rust.doc_test_signature("() -> ()")
class MissingExpr(Expr):
    """
    A missing expression, used as a place holder for incomplete syntax, as well as bodies of functions that are defined externally.

    ```
    let x = non_existing_macro!();
    ```
    """
    pass


#     Path(Path),

@rust.doc_test_signature("() -> ()")
class PathExpr(Expr):
    """
    A path expression. For example:
    ```
    let x = variable;
    let x = foo::bar;
    let y = <T>::foo;
    let z = <Type as Trait>::foo;
    ```
    """
    path: Unimplemented | child

#     If {
#         condition: ExprId,
#         then_branch: ExprId,
#         else_branch: Option<ExprId>,
#     },


@rust.doc_test_signature("() -> ()")
class IfExpr(Expr):
    """
    An `if` expression. For example:
    ```
    if x == 42 {
        println!("that's the answer");
    }
    ```
    ```
    let y = if x > 0 {
        1
    } else {
        0
    }
    ```
    """
    condition: Expr | child
    then: Expr | child
    else_: optional[Expr] | child

#     Let {
#         pat: PatId,
#         expr: ExprId,
#     },


@rust.doc_test_signature("(maybe_some: Option<String>) -> ()")
class LetExpr(Expr):
    """
    A `let` expression. For example:
    ```
    if let Some(x) = maybe_some {
        println!("{}", x);
    }
    ```
    """
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


@rust.doc_test_signature("() -> ()")
class BlockExpr(BlockExprBase):
    """
    A block expression. For example:
    ```
    {
        let x = 42;
    }
    ```
    ```
    'label: {
        let x = 42;
        x
    }
    ```
    """
    label: optional[Label] | child

#     Async {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#     },


@rust.doc_test_signature("() -> i32")
class AsyncBlockExpr(BlockExprBase):
    """
    An async block expression. For example:
    ```
    async {
       let x = 42;
       x
    }.await
    ```
    """
    pass


@rust.doc_test_signature("() -> bool")
class ConstExpr(Expr):
    """
    A `const` block expression. For example:
    ```
    if const { SRC::IS_ZST || DEST::IS_ZST || mem::align_of::<SRC>() != mem::align_of::<DEST>() } {
        return false;
    }
    ```
    """
    expr: Expr | child

#     // FIXME: Fold this into Block with an unsafe flag?
#     Unsafe {
#         id: Option<BlockId>,
#         statements: Box<[Stmt]>,
#         tail: Option<ExprId>,
#     },


@rust.doc_test_signature("() -> ()")
class UnsafeBlockExpr(BlockExprBase):
    """
    An unsafe block expression. For example:
    ```
    let layout = unsafe {
        let x = 42;
        Layout::from_size_align_unchecked(size, align)
    };
    ```
    """
    pass

#     Loop {
#         body: ExprId,
#         label: Option<LabelId>,
#     },


@rust.doc_test_signature("() -> ()")
class LoopExpr(Expr):
    """
    A loop expression. For example:
    ```
    loop {
        println!("Hello, world (again)!");
    };
    ```
    ```
    'label: loop {
        println!("Hello, world (once)!");
        break 'label;
    };
    ```
    ```
    let mut x = 0;
    loop {
        if x < 10 {
            x += 1;
        } else {
            break;
        }
    };
    ```
    """
    body: Expr | child
    label: optional[Label] | child

#     Call {
#         callee: ExprId,
#         args: Box<[ExprId]>,
#         is_assignee_expr: bool,
#     },


@rust.doc_test_signature("() -> ()")
class CallExpr(Expr):
    """
    A function call expression. For example:
    ```
    foo(42);
    foo::<u32, u64>(42);
    foo[0](42);
    foo(1) = 4;
    ```
    """
    callee: Expr | child
    args: list[Expr] | child
    is_assignee_expr: predicate

#     MethodCall {
#         receiver: ExprId,
#         method_name: Name,
#         args: Box<[ExprId]>,
#         generic_args: Option<Box<GenericArgs>>,
#     },


@rust.doc_test_signature("() -> ()")
class MethodCallExpr(Expr):
    """
    A method call expression. For example:
    ```
    x.foo(42);
    x.foo::<u32, u64>(42);
    """
    receiver: Expr | child
    method_name: string
    args: list[Expr] | child
    generic_args: optional[Unimplemented] | child

# pub struct MatchArm {
#     pub pat: PatId,
#     pub guard: Option<ExprId>,
#     pub expr: ExprId,
# }


@rust.doc_test_signature("(x: i32) -> i32")
class MatchArm(AstNode):
    """
    A match arm. For example:
    ```
    match x {
        Some(y) => y,
        None => 0,
    }
    ```
    ```
    match x {
        Some(y) if y != 0 => 1 / y,
        _ => 0,
    }
    ```
    """
    pat: Pat | child
    guard: optional[Expr] | child
    expr: Expr | child
#     Match {
#         expr: ExprId,
#         arms: Box<[MatchArm]>,
#     },


@rust.doc_test_signature("(x: i32) -> i32")
class MatchExpr(Expr):
    """
    A match expression. For example:
    ```
    match x {
        Some(y) => y,
        None => 0,
    }
    ```
    match x {
        Some(y) if y != 0 => 1 / y,
        _ => 0,
    }
    ```
    """
    expr: Expr | child
    branches: list[MatchArm] | child

#     Continue {
#         label: Option<LabelId>,
#     },


@rust.doc_test_signature("() -> ()")
class ContinueExpr(Expr):
    """
    A continue expression. For example:
    ```
    loop {
        if not_ready() {
            continue;
        }
    }
    ```
    ```
    'label: loop {
        if not_ready() {
            continue 'label;
        }
    }
    ```
    """
    label: optional[Label] | child

#     Break {
#         expr: Option<ExprId>,
#         label: Option<LabelId>,
#     },


@rust.doc_test_signature("() -> ()")
class BreakExpr(Expr):
    """
    A break expression. For example:
    ```
    loop {
        if not_ready() {
            break;
         }
    }
    ```
    ```
    let x = 'label: loop {
        if done() {
            break 'label 42;
        }
    };
    ```
  """
    expr: optional[Expr] | child
    label: optional[Label] | child


#     Return {
#         expr: Option<ExprId>,
#     },

class ReturnExpr(Expr):
    """
    A return expression. For example:
    ```
    fn some_value() -> i32 {
        return 42;
    }
    ```
    ```
    fn no_value() -> () {
        return;
    }
    ```
    """
    expr: optional[Expr] | child
#     Become {
#         expr: ExprId,
#     },


class BecomeExpr(Expr):
    """
    A `become` expression. For example:
    ```
    fn fact_a(n: i32, a: i32) -> i32 {
         if n == 0 {
             a
         } else {
             become fact_a(n - 1, n * a)
         }
     }    ```
     """
    expr: Expr | child
#     Yield {
#         expr: Option<ExprId>,
#     },


@rust.doc_test_signature("() -> ()")
class YieldExpr(Expr):
    """
    A `yield` expression. For example:
    ```
    let one = #[coroutine]
        || {
            yield 1;
        };
    ```
    """
    expr: optional[Expr] | child

#     Yeet {
#         expr: Option<ExprId>,
#     },


@rust.doc_test_signature("() -> ()")
class YeetExpr(Expr):
    """
    A `yeet` expression. For example:
    ```
    if x < size {
       do yeet "index out of bounds";
    }
    ```
    """
    expr: optional[Expr] | child
#     RecordLit {
#         path: Option<Box<Path>>,
#         fields: Box<[RecordLitField]>,
#         spread: Option<ExprId>,
#         ellipsis: bool,
#         is_assignee_expr: bool,
#     },


@rust.doc_test_signature("() -> ()")
class RecordLitField(AstNode):
    """
    A field in a record literal. For example `a: 1` in:
    ```
    Foo { a: 1, b: 2 };
    ```
    """
    name: string
    expr: Expr | child


@rust.doc_test_signature("() -> ()")
class RecordLitExpr(Expr):
    """
    A record literal expression. For example:
    ```
    let first = Foo { a: 1, b: 2 };
    let second = Foo { a: 2, ..first };
    Foo { a: 1, b: 2 }[2] = 10;
    Foo { .. } = second;
    ```
    """
    path: optional[Unimplemented] | child
    fields: list[RecordLitField] | child
    spread: optional[Expr] | child
    has_ellipsis: predicate
    is_assignee_expr: predicate


#     Field {
#         expr: ExprId,
#         name: Name,
#     },
@rust.doc_test_signature("() -> ()")
class FieldExpr(Expr):
    """
    A field access expression. For example:
    ```
    x.foo
    ```
    """
    expr: Expr | child
    name: string

#     Await {
#         expr: ExprId,
#     },


@rust.doc_test_signature("() -> ()")
class AwaitExpr(Expr):
    """
    An `await` expression. For example:
    ```
    async {
        let x = foo().await;
        x
    }
    ```
    """
    expr: Expr | child

#     Cast {
#         expr: ExprId,
#         type_ref: Interned<TypeRef>,
#     },


@rust.doc_test_signature("() -> ()")
class CastExpr(Expr):
    """
    A cast expression. For example:
    ```
    value as u64;
    ```
    """
    expr: Expr | child
    type_ref: TypeRef | child
#     Ref {
#         expr: ExprId,
#         rawness: Rawness,
#         mutability: Mutability,
#     },


@rust.doc_test_signature("() -> ()")
class RefExpr(Expr):
    """
    A reference expression. For example:
    ```
        let ref_const = &foo;
        let ref_mut = &mut foo;
        let raw_const: &mut i32 = &raw const foo;
        let raw_mut: &mut i32 = &raw mut foo;
    ```
    """
    expr: Expr | child
    is_raw: predicate
    is_mut: predicate
#     Box {
#         expr: ExprId,
#     },


@rust.doc_test_signature("() -> ()")
class BoxExpr(Expr):
    """
    A box expression. For example:
    ```
    let x = #[rustc_box] Box::new(42);
    ```
    """
    expr: Expr | child
#     UnaryOp {
#         expr: ExprId,
#         op: UnaryOp,
#     },


@rust.doc_test_signature("() -> ()")
class UnaryOpExpr(Expr):
    """
    A unary operation expression. For example:
    ```
    let x = -42
    let y = !true
    let z = *ptr
    ```
    """
    expr: Expr | child
    op: string


#     BinaryOp {
#         lhs: ExprId,
#         rhs: ExprId,
#         op: Option<BinaryOp>,
#     },
@rust.doc_test_signature("() -> ()")
class BinaryOpExpr(Expr):
    """
    A binary operation expression. For example:
    ```
    x + y;
    x && y;
    x <= y;
    x = y;
    x += y;
    ```
    """
    lhs: Expr | child
    rhs: Expr | child
    op: optional[string]


#     Range {
#         lhs: Option<ExprId>,
#         rhs: Option<ExprId>,
#         range_type: RangeOp,
#     },


@rust.doc_test_signature("() -> ()")
class RangeExpr(Expr):
    """
    A range expression. For example:
    ```
    let x = 1..=10;
    let x = 1..10;
    let x = 10..;
    let x = ..10;
    let x = ..=10;
    let x = ..;
    ```
    """
    lhs: optional[Expr] | child
    rhs: optional[Expr] | child
    is_inclusive: predicate

#     Index {
#         base: ExprId,
#         index: ExprId,
#         is_assignee_expr: bool,
#     },


@rust.doc_test_signature("() -> ()")
class IndexExpr(Expr):
    """
    An index expression. For example:
    ```
    list[42];
    list[42] = 1;
    ```
    """
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


@rust.doc_test_signature("() -> ()")
class ClosureExpr(Expr):
    """
    A closure expression. For example:
    ```
    |x| x + 1;
    move |x: i32| -> i32 { x + 1 };
    async |x: i32, y| x + y;
     #[coroutine]
    |x| yield x;
     #[coroutine]
     static |x| yield x;
    ```
    """
    args: list[Pat] | child
    arg_types: list[optional[TypeRef]] | child
    ret_type: optional[TypeRef] | child
    body: Expr | child
    closure_kind: string
    is_move: predicate
#     Tuple {
#         exprs: Box<[ExprId]>,
#         is_assignee_expr: bool,
#     },


@rust.doc_test_signature("() -> ()")
class TupleExpr(Expr):
    """
    A tuple expression. For example:
    ```
    (1, "one");
    (2, "two")[0] = 3;
    ```
    """
    exprs: list[Expr] | child
    is_assignee_expr: predicate

#     Array(Array),


class ArrayExpr(Expr):
    """
    An array expression. For example:
    ```
    [1, 2, 3];
    [1; 10];
    ```
    """
    pass
#     Literal(Literal),

# ElementList { elements: Box<[ExprId]>, is_assignee_expr: bool },


@rust.doc_test_signature("() -> ()")
class ElementListExpr(ArrayExpr):
    """
    An element list expression. For example:
    ```
    [1, 2, 3, 4, 5];
    [1, 2, 3, 4, 5][0] = 6;
    ```
    """
    elements: list[Expr] | child
    is_assignee_expr: predicate

# Repeat { initializer: ExprId, repeat: ExprId },


@rust.doc_test_signature("() -> ()")
class RepeatExpr(ArrayExpr):
    """
    A repeat expression. For example:
    ```
    [1; 10];
    """
    initializer: Expr | child
    repeat: Expr | child


@rust.doc_test_signature("() -> ()")
class LiteralExpr(Expr):
    """
    A literal expression. For example:
    ```
    42;
    42.0;
    "Hello, world!";
    b"Hello, world!";
    'x';
    b'x';
    r"Hello, world!";
    true;
    """
    pass
#     Underscore,


@rust.doc_test_signature("() -> ()")
class UnderscoreExpr(Expr):
    """
    An underscore expression. For example:
    ```
    _ = 42;
    ```
    """
    pass
#     OffsetOf(OffsetOf),


@rust.doc_test_signature("() -> ()")
class OffsetOfExpr(Expr):
    """
     An `offset_of` expression. For example:
    ```
    builtin # offset_of(Struct, field);
    ```
    """
    container: TypeRef | child
    fields: list[string]

#     InlineAsm(InlineAsm),


@rust.doc_test_signature("() -> ()")
class InlineAsmExpr(Expr):
    """
    An inline assembly expression. For example:
    ```
    unsafe {
        builtin # asm(_);
    }
    ```
    """
    expr: Expr | child


#    Let {
#         pat: PatId,
#         type_ref: Option<Interned<TypeRef>>,
#         initializer: Option<ExprId>,
#         else_branch: Option<ExprId>,
#     },

@rust.doc_test_signature("() -> ()")
class LetStmt(Stmt):
    """
    A let statement. For example:
    ``` 
    let x = 42;
    let x: i32 = 42;
    let x: i32;
    let x;
    let (x, y) = (1, 2);
    let Some(x) = std::env::var("FOO") else {
        return;
    };

    """
    pat: Pat | child
    type_ref: optional[TypeRef] | child
    initializer: optional[Expr] | child
    else_: optional[Expr] | child
#     Expr {
#         expr: ExprId,
#         has_semi: bool,
#     },


@rust.doc_test_signature("() -> ()")
class ExprStmt(Stmt):
    """
    An expression statement. For example:
    ```
    start();
    finish()
    use std::env;
    ```
    """
    expr: Expr | child
    has_semicolon: predicate

#     // At the moment, we only use this to figure out if a return expression
#     // is really the last statement of a block. See #16566
#     Item,


# At the HIR-level, we don't have items, only some markers without location indicating where they used to be.
@qltest.skip
class ItemStmt(Stmt):
    """
    An item statement. For example:
    ```
    fn print_hello() {
        println!("Hello, world!");
    }
    print_hello();
    ```
    """
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


class RecordFieldPat(AstNode):
    name: string
    pat: Pat | child

# Record { path: Option<Box<Path>>, args: Box<[RecordFieldPat]>, ellipsis: bool },


class RecordPat(Pat):
    path: optional[Unimplemented] | child
    args: list[RecordFieldPat] | child
    has_ellipsis: predicate

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
    path: Unimplemented | child

    # Lit(ExprId),


class LitPat(Pat):
    expr: Expr | child

    # Bind { id: BindingId, subpat: Option<PatId> },


class BindPat(Pat):
    binding_id: string
    subpat: optional[Pat] | child

    # TupleStruct { path: Option<Box<Path>>, args: Box<[PatId]>, ellipsis: Option<u32> },


class TupleStructPat(Pat):
    path: optional[Unimplemented] | child
    args: list[Pat] | child
    ellipsis_index: optional[int]

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
