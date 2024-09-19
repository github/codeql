from misc.codegen.lib.schemadefs import *
from .ast import *


@annotate(Module)
@rust.doc_test_signature(None)
class _:
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


@annotate(Expr)
class _:
    """
    The base class for expressions.
    """
    pass


@annotate(Pat)
class _:
    """
    The base class for patterns.
    """
    pass


@annotate(Label)
class _:
    """
    A label. For example:
    ```rust
    'label: loop {
        println!("Hello, world (once)!");
        break 'label;
    };
    ```
    """


@annotate(Stmt)
class _:
    """
    The base class for statements.
    """
    pass


@annotate(TypeRef)
class _:
    """
    The base class for type references.
    ```rust
    let x: i32;
    let y: Vec<i32>;
    let z: Option<i32>;
    ```
    """
    pass


@annotate(Path)
class _:
    """
    A path. For example:
    ```rust
    foo::bar;
    ```
    """
    pass


@annotate(GenericArgList)
class _:
    """
    The base class for generic arguments.
    ```rust
    x.foo::<u32, u64>(42);
    ```
    """
    pass


@annotate(Function)
@rust.doc_test_signature(None)
class _:
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


@annotate(PathExpr)
class _:
    """
    A path expression. For example:
    ```rust
    let x = variable;
    let x = foo::bar;
    let y = <T>::foo;
    let z = <TypeRef as Trait>::foo;
    ```
    """


@annotate(IfExpr)
class _:
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


@annotate(LetExpr)
@rust.doc_test_signature("(maybe_some: Option<String>) -> ()")
class _:
    """
    A `let` expression. For example:
    ```rust
    if let Some(x) = maybe_some {
        println!("{}", x);
    }
    ```
    """


@annotate(BlockExpr)
class _:
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


# @annotate(ConstExpr)
# @rust.doc_test_signature("() -> bool")
# class _:
#     """
#     A `const` block expression. For example:
#     ```rust
#     if const { SRC::IS_ZST || DEST::IS_ZST || mem::align_of::<SRC>() != mem::align_of::<DEST>() } {
#         return false;
#     }
#     ```
#     """


@annotate(LoopExpr)
class _:
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


@annotate(CallExpr)
class _:
    """
    A function call expression. For example:
    ```rust
    foo(42);
    foo::<u32, u64>(42);
    foo[0](42);
    foo(1) = 4;
    ```
    """


@annotate(MethodCallExpr)
class _:
    """
    A method call expression. For example:
    ```rust
    x.foo(42);
    x.foo::<u32, u64>(42);
    ```
    """


@annotate(MatchArm)
@rust.doc_test_signature("(x: i32) -> i32")
class _:
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


@annotate(MatchExpr)
@rust.doc_test_signature("(x: i32) -> i32")
class _:
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


@annotate(ContinueExpr)
class _:
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


@annotate(BreakExpr)
class _:
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


@annotate(ReturnExpr)
@rust.doc_test_signature(None)
class _:
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


@annotate(BecomeExpr)
@rust.doc_test_signature(None)
class _:
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


@annotate(YieldExpr)
class _:
    """
    A `yield` expression. For example:
    ```rust
    let one = #[coroutine]
        || {
            yield 1;
        };
    ```
    """


@annotate(YeetExpr)
class _:
    """
    A `yeet` expression. For example:
    ```rust
    if x < size {
       do yeet "index out of bounds";
    }
    ```
    """


@annotate(RecordExprField)
class _:
    """
    A field in a record expression. For example `a: 1` in:
    ```rust
    Foo { a: 1, b: 2 };
    ```
    """


@annotate(RecordExpr)
class _:
    """
    A record expression. For example:
    ```rust
    let first = Foo { a: 1, b: 2 };
    let second = Foo { a: 2, ..first };
    Foo { a: 1, b: 2 }[2] = 10;
    Foo { .. } = second;
    ```
    """


@annotate(FieldExpr)
class _:
    """
    A field access expression. For example:
    ```rust
    x.foo
    ```
    """


@annotate(AwaitExpr)
class _:
    """
    An `await` expression. For example:
    ```rust
    async {
        let x = foo().await;
        x
    }
    ```
    """


@annotate(CastExpr)
class _:
    """
    A cast expression. For example:
    ```rust
    value as u64;
    ```
    """


@annotate(RefExpr)
class _:
    """
    A reference expression. For example:
    ```rust
        let ref_const = &foo;
        let ref_mut = &mut foo;
        let raw_const: &mut i32 = &raw const foo;
        let raw_mut: &mut i32 = &raw mut foo;
    ```
    """


@annotate(PrefixExpr)
class _:
    """
    A unary operation expression. For example:
    ```rust
    let x = -42
    let y = !true
    let z = *ptr
    ```
    """


@annotate(BinaryExpr)
class _:
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


@annotate(RangeExpr)
class _:
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


@annotate(IndexExpr)
class _:
    """
    An index expression. For example:
    ```rust
    list[42];
    list[42] = 1;
    ```
    """


@annotate(ClosureExpr)
class _:
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


@annotate(TupleExpr)
class _:
    """
    A tuple expression. For example:
    ```rust
    (1, "one");
    (2, "two")[0] = 3;
    ```
    """


@annotate(ArrayExpr)
class _:
    """
    An array expression. For example:
    ```rust
    [1, 2, 3];
    [1; 10];
    ```
    """
    pass


# @annotate(ElementListExpr)
# class _:
#     """
#     An element list expression. For example:
#     ```rust
#     [1, 2, 3, 4, 5];
#     [1, 2, 3, 4, 5][0] = 6;
#     ```
#     """


# @annotate(RepeatExpr)
# class _:
#     """
#     A repeat expression. For example:
#     ```rust
#     [1; 10];
#     ```
#     """


@annotate(LiteralExpr)
class _:
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


@annotate(UnderscoreExpr)
class _:
    """
    An underscore expression. For example:
    ```rust
    _ = 42;
    ```
    """
    pass


@annotate(OffsetOfExpr)
class _:
    """
     An `offset_of` expression. For example:
    ```rust
    builtin # offset_of(Struct, field);
    ```
    """


@annotate(AsmExpr)
class _:
    """
    An inline assembly expression. For example:
    ```rust
    unsafe {
        builtin # asm(_);
    }
    ```
    """


@annotate(LetStmt)
class _:
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


@annotate(ExprStmt)
class _:
    """
    An expression statement. For example:
    ```rust
    start();
    finish()
    use std::env;
    ```
    """


@annotate(WildcardPat)
class _:
    """
    A wildcard pattern. For example:
    ```rust
    let _ = 42;
    ```
    """
    pass


@annotate(TuplePat)
class _:
    """
    A tuple pattern. For example:
    ```rust
    let (x, y) = (1, 2);
    let (a, b, ..,  z) = (1, 2, 3, 4, 5);
    ```
    """


@annotate(OrPat)
class _:
    """
    An or pattern. For example:
    ```rust
    match x {
        Option::Some(y) | Option::None => 0,
    }
    ```
    """


@annotate(RecordPatField)
class _:
    """
    A field in a record pattern. For example `a: 1` in:
    ```rust
    let Foo { a: 1, b: 2 } = foo;
    ```
    """


@annotate(RecordPat)
class _:
    """
    A record pattern. For example:
    ```rust
    match x {
        Foo { a: 1, b: 2 } => "ok",
        Foo { .. } => "fail",
    }
    ```
    """


@annotate(RangePat)
class _:
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


@annotate(SlicePat)
class _:
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


@annotate(PathPat)
class _:
    """
    A path pattern. For example:
    ```rust
    match x {
        Foo::Bar => "ok",
        _ => "fail",
    }
    ```
    """


@annotate(LiteralPat)
class _:
    """
    A literal pattern. For example:
    ```rust
    match x {
        42 => "ok",
        _ => "fail",
    }
    ```
    """


@annotate(IdentPat)
class _:
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


@annotate(TupleStructPat)
class _:
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


@annotate(RefPat)
class _:
    """
    A reference pattern. For example:
    ```rust
    match x {
        &mut Option::Some(y) => y,
        &Option::None => 0,
    };
    ```
    """


@annotate(BoxPat)
class _:
    """
    A box pattern. For example:
    ```rust
    match x {
        box Option::Some(y) => y,
        box Option::None => 0,
    };
    ```
    """


@annotate(ConstBlockPat)
class _:
    """
    A const block pattern. For example:
    ```rust
    match x {
        const { 1 + 2 + 3 } => "ok",
        _ => "fail",
    };
    ```
    """
