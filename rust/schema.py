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
class Unimplemented(Element):
    pass


class Declaration(AstNode):
    pass


@qltest.skip
class UnimplementedDeclaration(Declaration, Unimplemented):
    pass


class Module(Declaration):
    """
    A module declaration. For example:
    ```
    mod foo;
    ```
    ```
    mod bar {
        pub fn baz() {}
    }
    ```
    """
    declarations: list[Declaration] | child


class Expr(AstNode):
    """
    The base class for expressions.
    """
    pass


class Pat(AstNode):
    """
    The base class for patterns.
    """
    pass


@rust.doc_test_signature("() -> ()")
class Label(AstNode):
    """
    A label. For example:
    ```
    'label: loop {
        println!("Hello, world (once)!");
        break 'label;
    };
    ```
    """
    name: string


class Stmt(AstNode):
    """
    The base class for statements.
    """
    pass


class TypeRef(AstNode, Unimplemented):
    """
    The base class for type references.
    ```
    let x: i32;
    let y: Vec<i32>;
    let z: Option<i32>;
    ```
    """
    pass


class Path(AstNode, Unimplemented):
    """
    A path. For example:
    ```
    foo::bar;
    ```
    """
    pass


@rust.doc_test_signature("() -> ()")
class GenericArgs(AstNode, Unimplemented):
    """
    The base class for generic arguments.
    ```
    x.foo::<u32, u64>(42);
    ```
    """
    pass


class Function(Declaration):
    """
    A function declaration. For example
    ```
    fn foo(x: u32) -> u64 {(x + 1).into()}
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
    path: Path | child


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
    generic_args: optional[GenericArgs] | child


@rust.doc_test_signature("(x: i32) -> i32")
class MatchArm(AstNode):
    """
    A match arm. For example:
    ```
    match x {
        Some(y) => y,
        None => 0,
    };
    ```
    ```
    match x {
        Some(y) if y != 0 => 1 / y,
        _ => 0,
    };
    ```
    """
    pat: Pat | child
    guard: optional[Expr] | child
    expr: Expr | child


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
    ```
    match x {
        Some(y) if y != 0 => 1 / y,
        _ => 0,
    }
    ```
    """
    expr: Expr | child
    branches: list[MatchArm] | child


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
    path: optional[Path] | child
    fields: list[RecordLitField] | child
    spread: optional[Expr] | child
    has_ellipsis: predicate
    is_assignee_expr: predicate


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


@rust.doc_test_signature("() -> ()")
class BoxExpr(Expr):
    """
    A box expression. For example:
    ```
    let x = #[rustc_box] Box::new(42);
    ```
    """
    expr: Expr | child


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


class ArrayExpr(Expr):
    """
    An array expression. For example:
    ```
    [1, 2, 3];
    [1; 10];
    ```
    """
    pass


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


@rust.doc_test_signature("() -> ()")
class UnderscoreExpr(Expr):
    """
    An underscore expression. For example:
    ```
    _ = 42;
    ```
    """
    pass


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


@rust.doc_test_signature("() -> ()")
class MissingPat(Pat):
    """
    A missing pattern, used as a place holder for incomplete syntax.
    ```
    match Some(42) {
        .. => "ok",
        _ => "fail",
    };
    ```
    """
    pass


@rust.doc_test_signature("() -> ()")
class WildPat(Pat):
    """
    A wildcard pattern. For example:
    ```
    let _ = 42;
    ```
    """
    pass


@rust.doc_test_signature("() -> ()")
class TuplePat(Pat):
    """
    A tuple pattern. For example:
    ```
    let (x, y) = (1, 2);
    let (a, b, ..,  z) = (1, 2, 3, 4, 5);
    ```
    """
    args: list[Pat] | child
    ellipsis_index: optional[int]


@rust.doc_test_signature("() -> ()")
class OrPat(Pat):
    """
    An or pattern. For example:
    ```
    match x {
        Some(y) | None => 0,
    }
    ```
    """
    args: list[Pat] | child


@rust.doc_test_signature("() -> ()")
class RecordFieldPat(AstNode):
    """
    A field in a record pattern. For example `a: 1` in:
    ```
    let Foo { a: 1, b: 2 } = foo;
    ```
    """
    name: string
    pat: Pat | child


@rust.doc_test_signature("() -> ()")
class RecordPat(Pat):
    """
    A record pattern. For example:
    ```
    match x {
        Foo { a: 1, b: 2 } => "ok",
        Foo { .. } => "fail",
    }
    ```
    """

    path: optional[Path] | child
    args: list[RecordFieldPat] | child
    has_ellipsis: predicate


@rust.doc_test_signature("() -> ()")
class RangePat(Pat):
    """
    A range pattern. For example:
    ```
    match x {
        ..15 => "too cold",
        16..=25 => "just right",
        26.. => "too hot",
    }
    ```
    """
    start: optional[Pat] | child
    end: optional[Pat] | child


@rust.doc_test_signature("() -> ()")
class SlicePat(Pat):
    """
    A slice pattern. For example:
    ```
    match x {
        [1, 2, 3, 4, 5] => "ok",
        [1, 2, ..] => "fail",
        [x, y, .., z, 7] => "fail",
    }
    """
    prefix: list[Pat] | child
    slice: optional[Pat] | child
    suffix: list[Pat] | child


@rust.doc_test_signature("() -> ()")
class PathPat(Pat):
    """
    A path pattern. For example:
    ```
    match x {
        Foo::Bar => "ok",
        _ => "fail",
    }
    ```
    """
    path: Path | child


@rust.doc_test_signature("() -> ()")
class LitPat(Pat):
    """
    A literal pattern. For example:
    ```
    match x {
        42 => "ok",
        _ => "fail",
    }
    ```
    """
    expr: Expr | child


@rust.doc_test_signature("() -> ()")
class BindPat(Pat):
    """
    A binding pattern. For example:
    ```
    match x {
        Some(y) => y,
        None => 0,
    };
    ```
    ```
    match x {
        y@Some(_) => y,
        None => 0,
    };
    ```
    """
    binding_id: string
    subpat: optional[Pat] | child


@rust.doc_test_signature("() -> ()")
class TupleStructPat(Pat):
    """
    A tuple struct pattern. For example:
    ``` 
    match x {
        Tuple("a", 1, 2, 3) => "great",
        Tuple(.., 3) => "fine",
        Tuple(..) => "fail",
    };
    ```
    """
    path: optional[Path] | child
    args: list[Pat] | child
    ellipsis_index: optional[int]


@rust.doc_test_signature("() -> ()")
class RefPat(Pat):
    """
    A reference pattern. For example:
    ```
    match x {
        &mut Some(y) => y,
        &None => 0,
    };
    ```
    """
    pat: Pat | child
    is_mut: predicate


@rust.doc_test_signature("() -> ()")
class BoxPat(Pat):
    """
    A box pattern. For example:
    ```
    match x {
        box Some(y) => y,
        box None => 0,
    };
    ```
    """
    inner: Pat | child


@rust.doc_test_signature("() -> ()")
class ConstBlockPat(Pat):
    """
    A const block pattern. For example:
    ```
    match x {
        const { 1 + 2 + 3 } => "ok",
        _ => "fail",
    };
    ```
    """
    expr: Expr | child
