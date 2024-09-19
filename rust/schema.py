"""
Schema description

This file should be kept simple:
* no flow control
* no aliases
* only class definitions with annotations and `include` calls

For how documentation of generated QL code works, please read `misc/codegen/schema_documentation.md`.
"""

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


class Declaration(AstNode):
    """
    The base class for declarations.
    """
    pass


@qltest.skip
class UnimplementedDeclaration(Declaration, Unimplemented):
    """
    A declaration that is not yet extracted.
    """
    pass


@rust.doc_test_signature(None)
class Module(Declaration):
    """
    A module declaration. For example:
    ```rust
    mod foo;
    ```
    ```rust
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


class Label(AstNode):
    """
    A label. For example:
    ```rust
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
    ```rust
    let x: i32;
    let y: Vec<i32>;
    let z: Option<i32>;
    ```
    """
    pass


class Path(AstNode, Unimplemented):
    """
    A path. For example:
    ```rust
    foo::bar;
    ```
    """
    pass


class GenericArgList(AstNode, Unimplemented):
    """
    The base class for generic arguments.
    ```rust
    x.foo::<u32, u64>(42);
    ```
    """
    pass


@rust.doc_test_signature(None)
class Function(Declaration):
    """
    A function declaration. For example
    ```rust
    fn foo(x: u32) -> u64 {(x + 1).into()}
    ```
    A function declaration within a trait might not have a body:
    ```rust
    trait Trait {
        fn bar();
    }
    ```
    """
    name: string
    body: Expr | child


class MissingExpr(Expr, Missing):
    """
    A missing expression, used as a placeholder for incomplete syntax.

    ```rust
    let x = non_existing_macro!();
    ```
    """
    pass


class PathExpr(Expr):
    """
    A path expression. For example:
    ```rust
    let x = variable;
    let x = foo::bar;
    let y = <T>::foo;
    let z = <TypeRef as Trait>::foo;
    ```
    """
    path: Path | child


class IfExpr(Expr):
    """
    An `if` expression. For example:
    ```rust
    if x == 42 {
        println!("that's the answer");
    }
    ```
    ```rust
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
    ```rust
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


class BlockExpr(BlockExprBase):
    """
    A block expression. For example:
    ```rust
    {
        let x = 42;
    }
    ```
    ```rust
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
    ```rust
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
    ```rust
    if const { SRC::IS_ZST || DEST::IS_ZST || mem::align_of::<SRC>() != mem::align_of::<DEST>() } {
        return false;
    }
    ```
    """
    expr: Expr | child


class UnsafeBlockExpr(BlockExprBase):
    """
    An unsafe block expression. For example:
    ```rust
    let layout = unsafe {
        let x = 42;
        Layout::from_size_align_unchecked(size, align)
    };
    ```
    """
    pass


class LoopExpr(Expr):
    """
    A loop expression. For example:
    ```rust
    loop {
        println!("Hello, world (again)!");
    };
    ```
    ```rust
    'label: loop {
        println!("Hello, world (once)!");
        break 'label;
    };
    ```
    ```rust
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


class CallExpr(Expr):
    """
    A function call expression. For example:
    ```rust
    foo(42);
    foo::<u32, u64>(42);
    foo[0](42);
    foo(1) = 4;
    ```
    """
    callee: Expr | child
    args: list[Expr] | child
    is_assignee_expr: predicate


class MethodCallExpr(Expr):
    """
    A method call expression. For example:
    ```rust
    x.foo(42);
    x.foo::<u32, u64>(42);
    ```
    """
    receiver: Expr | child
    method_name: string
    args: list[Expr] | child
    generic_args: optional[GenericArgList] | child


@rust.doc_test_signature("(x: i32) -> i32")
class MatchArm(AstNode):
    """
    A match arm. For example:
    ```rust
    match x {
        Option::Some(y) => y,
        Option::None => 0,
    };
    ```
    ```rust
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
    ```rust
    match x {
        Option::Some(y) => y,
        Option::None => 0,
    }
    ```
    ```rust
    match x {
        Some(y) if y != 0 => 1 / y,
        _ => 0,
    }
    ```
    """
    expr: Expr | child
    branches: list[MatchArm] | child


class ContinueExpr(Expr):
    """
    A continue expression. For example:
    ```rust
    loop {
        if not_ready() {
            continue;
        }
    }
    ```
    ```rust
    'label: loop {
        if not_ready() {
            continue 'label;
        }
    }
    ```
    """
    label: optional[Label] | child


class BreakExpr(Expr):
    """
    A break expression. For example:
    ```rust
    loop {
        if not_ready() {
            break;
         }
    }
    ```
    ```rust
    let x = 'label: loop {
        if done() {
            break 'label 42;
        }
    };
    ```
  """
    expr: optional[Expr] | child
    label: optional[Label] | child


@rust.doc_test_signature(None)
class ReturnExpr(Expr):
    """
    A return expression. For example:
    ```rust
    fn some_value() -> i32 {
        return 42;
    }
    ```
    ```rust
    fn no_value() -> () {
        return;
    }
    ```
    """
    expr: optional[Expr] | child


@rust.doc_test_signature(None)
class BecomeExpr(Expr):
    """
    A `become` expression. For example:
    ```rust
    fn fact_a(n: i32, a: i32) -> i32 {
         if n == 0 {
             a
         } else {
             become fact_a(n - 1, n * a)
         }
    }
    ```
    """
    expr: Expr | child


class YieldExpr(Expr):
    """
    A `yield` expression. For example:
    ```rust
    let one = #[coroutine]
        || {
            yield 1;
        };
    ```
    """
    expr: optional[Expr] | child


class YeetExpr(Expr):
    """
    A `yeet` expression. For example:
    ```rust
    if x < size {
       do yeet "index out of bounds";
    }
    ```
    """
    expr: optional[Expr] | child


class RecordExprField(AstNode):
    """
    A field in a record expression. For example `a: 1` in:
    ```rust
    Foo { a: 1, b: 2 };
    ```
    """
    name: string
    expr: Expr | child


class RecordExpr(Expr):
    """
    A record expression. For example:
    ```rust
    let first = Foo { a: 1, b: 2 };
    let second = Foo { a: 2, ..first };
    Foo { a: 1, b: 2 }[2] = 10;
    Foo { .. } = second;
    ```
    """
    path: optional[Path] | child
    flds: list[RecordExprField] | child
    spread: optional[Expr] | child
    has_ellipsis: predicate
    is_assignee_expr: predicate


class FieldExpr(Expr):
    """
    A field access expression. For example:
    ```rust
    x.foo
    ```
    """
    expr: Expr | child
    name: string


class AwaitExpr(Expr):
    """
    An `await` expression. For example:
    ```rust
    async {
        let x = foo().await;
        x
    }
    ```
    """
    expr: Expr | child


class CastExpr(Expr):
    """
    A cast expression. For example:
    ```rust
    value as u64;
    ```
    """
    expr: Expr | child
    type: TypeRef | child


class RefExpr(Expr):
    """
    A reference expression. For example:
    ```rust
        let ref_const = &foo;
        let ref_mut = &mut foo;
        let raw_const: &mut i32 = &raw const foo;
        let raw_mut: &mut i32 = &raw mut foo;
    ```
    """
    expr: Expr | child
    is_raw: predicate
    is_mut: predicate


class BoxExpr(Expr):
    """
    A box expression. For example:
    ```rust
    let x = #[rustc_box] Box::new(42);
    ```
    """
    expr: Expr | child


class PrefixExpr(Expr):
    """
    A unary operation expression. For example:
    ```rust
    let x = -42
    let y = !true
    let z = *ptr
    ```
    """
    expr: Expr | child
    op: string


class BinaryExpr(Expr):
    """
    A binary operation expression. For example:
    ```rust
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


class RangeExpr(Expr):
    """
    A range expression. For example:
    ```rust
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


class IndexExpr(Expr):
    """
    An index expression. For example:
    ```rust
    list[42];
    list[42] = 1;
    ```
    """
    base: Expr | child
    index: Expr | child
    is_assignee_expr: predicate


class ClosureExpr(Expr):
    """
    A closure expression. For example:
    ```rust
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


class TupleExpr(Expr):
    """
    A tuple expression. For example:
    ```rust
    (1, "one");
    (2, "two")[0] = 3;
    ```
    """
    exprs: list[Expr] | child
    is_assignee_expr: predicate


class ArrayExpr(Expr):
    """
    An array expression. For example:
    ```rust
    [1, 2, 3];
    [1; 10];
    ```
    """
    pass


class ElementListExpr(ArrayExpr):
    """
    An element list expression. For example:
    ```rust
    [1, 2, 3, 4, 5];
    [1, 2, 3, 4, 5][0] = 6;
    ```
    """
    elements: list[Expr] | child
    is_assignee_expr: predicate


class RepeatExpr(ArrayExpr):
    """
    A repeat expression. For example:
    ```rust
    [1; 10];
    ```
    """
    initializer: Expr | child
    repeat: Expr | child


class LiteralExpr(Expr):
    """
    A literal expression. For example:
    ```rust
    42;
    42.0;
    "Hello, world!";
    b"Hello, world!";
    'x';
    b'x';
    r"Hello, world!";
    true;
    ```
    """
    pass


class UnderscoreExpr(Expr):
    """
    An underscore expression. For example:
    ```rust
    _ = 42;
    ```
    """
    pass


class OffsetOfExpr(Expr):
    """
     An `offset_of` expression. For example:
    ```rust
    builtin # offset_of(Struct, field);
    ```
    """
    container: TypeRef | child
    fields: list[string]


class AsmExpr(Expr):
    """
    An inline assembly expression. For example:
    ```rust
    unsafe {
        builtin # asm(_);
    }
    ```
    """
    expr: Expr | child


class LetStmt(Stmt):
    """
    A let statement. For example:
    ```rust
    let x = 42;
    let x: i32 = 42;
    let x: i32;
    let x;
    let (x, y) = (1, 2);
    let Some(x) = std::env::var("FOO") else {
        return;
    };
    ```
    """
    pat: Pat | child
    type: optional[TypeRef] | child
    initializer: optional[Expr] | child
    else_: optional[Expr] | child


class ExprStmt(Stmt):
    """
    An expression statement. For example:
    ```rust
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
    ```rust
    fn print_hello() {
        println!("Hello, world!");
    }
    print_hello();
    ```
    """
    pass


class MissingPat(Pat, Missing):
    """
    A missing pattern, used as a place holder for incomplete syntax.
    ```rust
    match Some(42) {
        .. => "bad use of .. syntax",
    };
    ```
    """
    pass


class WildcardPat(Pat):
    """
    A wildcard pattern. For example:
    ```rust
    let _ = 42;
    ```
    """
    pass


class TuplePat(Pat):
    """
    A tuple pattern. For example:
    ```rust
    let (x, y) = (1, 2);
    let (a, b, ..,  z) = (1, 2, 3, 4, 5);
    ```
    """
    args: list[Pat] | child
    ellipsis_index: optional[int]


class OrPat(Pat):
    """
    An or pattern. For example:
    ```rust
    match x {
        Option::Some(y) | Option::None => 0,
    }
    ```
    """
    args: list[Pat] | child


class RecordPatField(AstNode):
    """
    A field in a record pattern. For example `a: 1` in:
    ```rust
    let Foo { a: 1, b: 2 } = foo;
    ```
    """
    name: string
    pat: Pat | child


class RecordPat(Pat):
    """
    A record pattern. For example:
    ```rust
    match x {
        Foo { a: 1, b: 2 } => "ok",
        Foo { .. } => "fail",
    }
    ```
    """

    path: optional[Path] | child
    flds: list[RecordPatField] | child
    has_ellipsis: predicate


class RangePat(Pat):
    """
    A range pattern. For example:
    ```rust
    match x {
        ..15 => "too cold",
        16..=25 => "just right",
        26.. => "too hot",
    }
    ```
    """
    start: optional[Pat] | child
    end: optional[Pat] | child


class SlicePat(Pat):
    """
    A slice pattern. For example:
    ```rust
    match x {
        [1, 2, 3, 4, 5] => "ok",
        [1, 2, ..] => "fail",
        [x, y, .., z, 7] => "fail",
    }
    ```
    """
    prefix: list[Pat] | child
    slice: optional[Pat] | child
    suffix: list[Pat] | child


class PathPat(Pat):
    """
    A path pattern. For example:
    ```rust
    match x {
        Foo::Bar => "ok",
        _ => "fail",
    }
    ```
    """
    path: Path | child


class LiteralPat(Pat):
    """
    A literal pattern. For example:
    ```rust
    match x {
        42 => "ok",
        _ => "fail",
    }
    ```
    """
    expr: Expr | child


class IdentPat(Pat):
    """
    A binding pattern. For example:
    ```rust
    match x {
        Option::Some(y) => y,
        Option::None => 0,
    };
    ```
    ```rust
    match x {
        y@Option::Some(_) => y,
        Option::None => 0,
    };
    ```
    """
    binding_id: string
    subpat: optional[Pat] | child


class TupleStructPat(Pat):
    """
    A tuple struct pattern. For example:
    ```rust
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


class RefPat(Pat):
    """
    A reference pattern. For example:
    ```rust
    match x {
        &mut Option::Some(y) => y,
        &Option::None => 0,
    };
    ```
    """
    pat: Pat | child
    is_mut: predicate


class BoxPat(Pat):
    """
    A box pattern. For example:
    ```rust
    match x {
        box Option::Some(y) => y,
        box Option::None => 0,
    };
    ```
    """
    inner: Pat | child


class ConstBlockPat(Pat):
    """
    A const block pattern. For example:
    ```rust
    match x {
        const { 1 + 2 + 3 } => "ok",
        _ => "fail",
    };
    ```
    """
    expr: Expr | child
