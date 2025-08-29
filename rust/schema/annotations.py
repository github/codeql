from misc.codegen.lib.schemadefs import *
from .ast import *


class LabelableExpr(Expr):
    """
    The base class for expressions that can be labeled (`LoopExpr`, `ForExpr`, `WhileExpr` or `BlockExpr`).
    """
    label: optional[Label] | child


class LoopingExpr(LabelableExpr):
    """
    The base class for expressions that loop (`LoopExpr`, `ForExpr` or `WhileExpr`).
    """
    loop_body: optional["BlockExpr"] | child


@annotate(Adt, replace_bases={AstNode: Item})
class _:
    """
    An ADT (Abstract Data Type) definition, such as `Struct`, `Enum`, or `Union`.
    """
    derive_macro_expansions: list[MacroItems] | child | rust.detach


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


@annotate(Expr, cfg=True)
class _:
    """
    The base class for expressions.
    """


@annotate(Pat, cfg=True)
class _:
    """
    The base class for patterns.
    """


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


@annotate(TypeRepr)
class _:
    """
    The base class for type references.
    ```rust
    let x: i32;
    let y: Vec<i32>;
    let z: Option<i32>;
    ```
    """


@annotate(Path)
class _:
    """
    A path. For example:
    ```rust
    use some_crate::some_module::some_item;
    foo::bar;
    ```
    """
    segment: _ | ql.db_table_name("path_segments_") | doc(
        "last segment of this path")


@annotate(GenericArgList)
class _:
    """
    The base class for generic arguments.
    ```rust
    x.foo::<u32, u64>(42);
    ```
    """


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


class PathExprBase(Expr):
    """
    A path expression or a variable access in a formatting template. See `PathExpr` and `FormatTemplateVariableAccess` for further details.
    """


@annotate(PathExpr, replace_bases={Expr: PathExprBase}, add_bases=(PathAstNode,), cfg=True)
@qltest.test_with(Path)
class _:
    """
    A path expression. For example:
    ```rust
    let x = variable;
    let x = foo::bar;
    let y = <T>::foo;
    let z = <TypeRepr as Trait>::foo;
    ```
    """
    path: drop


@annotate(IfExpr, cfg=True)
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
    };
    ```
    """


@annotate(LetExpr, cfg=True)
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


@annotate(BlockExpr, replace_bases={Expr: LabelableExpr}, cfg=True)
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
    label: drop


@annotate(LoopExpr, replace_bases={Expr: LoopingExpr}, cfg=True)
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
    label: drop
    loop_body: drop


class CallExprBase(Expr):
    """
    A function or method call expression. See `CallExpr` and `MethodCallExpr` for further details.
    """
    arg_list: optional["ArgList"] | child
    attrs: list["Attr"] | child
    args: list["Expr"] | synth


@annotate(CallExpr, replace_bases={Expr: CallExprBase}, cfg=True)
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
    arg_list: drop
    attrs: drop


@annotate(MethodCallExpr, replace_bases={Expr: CallExprBase}, cfg=True)
class _:
    """
    A method call expression. For example:
    ```rust
    x.foo(42);
    x.foo::<u32, u64>(42);
    ```
    """
    arg_list: drop
    attrs: drop


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


@annotate(MatchExpr, cfg=True)
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
    scrutinee: _ | doc(
        "scrutinee (the expression being matched) of this match expression")


@annotate(ContinueExpr, cfg=True)
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


@annotate(BreakExpr, cfg=True)
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
    ```rust
    let x = 'label: {
        if exit() {
            break 'label 42;
        }
        0;
    };
    ```
  """


@annotate(ReturnExpr, cfg=True)
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


@annotate(BecomeExpr, cfg=True)
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


@annotate(YieldExpr, cfg=True)
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


@annotate(YeetExpr, cfg=True)
class _:
    """
    A `yeet` expression. For example:
    ```rust
    if x < size {
       do yeet "index out of bounds";
    }
    ```
    """


@annotate(StructExprField)
class _:
    """
    A field in a struct expression. For example `a: 1` in:
    ```rust
    Foo { a: 1, b: 2 };
    ```
    """


@annotate(StructExpr, add_bases=(PathAstNode,), cfg=True)
class _:
    """
    A struct expression. For example:
    ```rust
    let first = Foo { a: 1, b: 2 };
    let second = Foo { a: 2, ..first };
    let n = Foo { a: 1, b: 2 }.b;
    Foo { a: m, .. } = second;
    ```
    """
    path: drop


@annotate(FieldExpr, cfg=True)
class _:
    """
    A field access expression. For example:
    ```rust
    x.foo
    ```
    """


@annotate(AwaitExpr, cfg=True)
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


@annotate(CastExpr, cfg=True)
class _:
    """
    A type cast expression. For example:
    ```rust
    value as u64;
    ```
    """


@annotate(RefExpr, cfg=True)
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


@annotate(PrefixExpr, cfg=True)
class _:
    """
    A unary operation expression. For example:
    ```rust
    let x = -42;
    let y = !true;
    let z = *ptr;
    ```
    """


@annotate(BinaryExpr, cfg=True)
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


@annotate(RangeExpr, cfg=True)
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


@annotate(IndexExpr, cfg=True)
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
    for<T: std::fmt::Debug> |x: T| {
        println!("{:?}", x);
    };
    ```
    """


@annotate(TupleExpr, cfg=True)
class _:
    """
    A tuple expression. For example:
    ```rust
    let tuple = (1, "one");
    let n = (2, "two").0;
    let (a, b) = tuple;
    ```
    """


@annotate(ArrayExprInternal)
@ql.internal
@qltest.skip
class _:
    pass


class ArrayExpr(Expr):
    """
    The base class for array expressions. For example:
    ```rust
    [1, 2, 3];
    [1; 10];
    ```
    """
    exprs: list[Expr] | child
    attrs: list[Attr] | child


@synth.from_class(ArrayExprInternal)
class ArrayListExpr(ArrayExpr):
    """
    An array expression with a list of elements. For example:
    ```rust
    [1, 2, 3];
    ```
    """
    __cfg__ = True


@synth.from_class(ArrayExprInternal)
class ArrayRepeatExpr(ArrayExpr):
    """
    An array expression with a repeat operand and a repeat length. For example:
    ```rust
    [1; 10];
    ```
    """
    __cfg__ = True

    repeat_operand: Expr | child
    repeat_length: Expr | child


@annotate(LiteralExpr, cfg=True)
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


@annotate(UnderscoreExpr, cfg=True)
class _:
    """
    An underscore expression. For example:
    ```rust
    _ = 42;
    ```
    """


@annotate(OffsetOfExpr, cfg=True)
class _:
    """
     An `offset_of` expression. For example:
    ```rust
    builtin # offset_of(Struct, field);
    ```
    """


@annotate(AsmExpr, cfg=True)
class _:
    """
    An inline assembly expression. For example:
    ```rust
    unsafe {
        #[inline(always)]
        builtin # asm("cmp {0}, {1}", in(reg) a, in(reg) b);
    }
    ```
    """


@annotate(LetStmt, cfg=True)
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
    finish();
    use std::env;
    ```
    """


@annotate(WildcardPat, cfg=True)
class _:
    """
    A wildcard pattern. For example:
    ```rust
    let _ = 42;
    ```
    """


@annotate(TuplePat, cfg=True)
class _:
    """
    A tuple pattern. For example:
    ```rust
    let (x, y) = (1, 2);
    let (a, b, ..,  z) = (1, 2, 3, 4, 5);
    ```
    """


@annotate(OrPat, cfg=True)
class _:
    """
    An or pattern. For example:
    ```rust
    match x {
        Option::Some(y) | Option::None => 0,
    }
    ```
    """


@annotate(StructPatField)
class _:
    """
    A field in a struct pattern. For example `a: 1` in:
    ```rust
    let Foo { a: 1, b: 2 } = foo;
    ```
    """


@annotate(StructPat, add_bases=(PathAstNode,), cfg=True)
class _:
    """
    A struct pattern. For example:
    ```rust
    match x {
        Foo { a: 1, b: 2 } => "ok",
        Foo { .. } => "fail",
    }
    ```
    """
    path: drop


@annotate(RangePat, cfg=True)
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


@annotate(SlicePat, cfg=True)
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


@annotate(PathPat, add_bases=(PathAstNode,), cfg=True)
@qltest.test_with(Path)
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
    path: drop


@annotate(LiteralPat, cfg=True)
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


@annotate(IdentPat, cfg=True)
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


@annotate(TupleStructPat, add_bases=(PathAstNode,), cfg=True)
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
    path: drop


@annotate(RefPat, cfg=True)
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


@annotate(BoxPat, cfg=True)
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


@annotate(ConstBlockPat, cfg=True)
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


@annotate(Abi)
class _:
    """
    An ABI specification for an extern function or block.

    For example:
    ```rust
    extern "C" fn foo() {}
    //     ^^^
    ```
    """


@annotate(ArgList)
class _:
    """
    A list of arguments in a function or method call.

    For example:
    ```rust
    foo(1, 2, 3);
    // ^^^^^^^^^
    ```
    """


@annotate(ArrayTypeRepr)
class _:
    """
    An array type representation.

    For example:
    ```rust
    let arr: [i32; 4];
    //       ^^^^^^^^
    ```
    """


@annotate(AssocItem, replace_bases={AstNode: Item})
class _:
    """
    An associated item in a `Trait` or `Impl`.

    For example:
    ```rust
    trait T {fn foo(&self);}
    //       ^^^^^^^^^^^^^
    ```
    """


@annotate(AssocItemList)
@qltest.test_with(Trait)
class _:
    """
    A list of `AssocItem` elements, as appearing in a `Trait` or `Impl`.
    """


@annotate(AssocTypeArg)
class _:
    """
    An associated type argument in a path.

    For example:
    ```rust
    fn process_cloneable<T>(iter: T)
    where
        T: Iterator<Item: Clone>
    //              ^^^^^^^^^^^
    {
        // ...
    }
    ```
    """


@annotate(Attr)
class _:
    """
    An attribute applied to an item.

    For example:
    ```rust
    #[derive(Debug)]
    //^^^^^^^^^^^^^
    struct S;
    ```
    """


@annotate(ForBinder)
class _:
    """
    A for binder, specifying lifetime or type parameters for a closure or a type.

    For example:
    ```rust
    let print_any = for<T: std::fmt::Debug> |x: T| {
    //              ^^^^^^^^^^^^^^^^^^^^^^^
        println!("{:?}", x);
    };

    print_any(42);
    print_any("hello");
    ```
    """


@annotate(Const, replace_bases={Item: None})
class _:
    """
    A constant item declaration.

    For example:
    ```rust
    const X: i32 = 42;
    ```
    """
    has_implementation: predicate | doc("this constant has an implementation") | desc("""
      This is the same as `hasBody` for source code, but for library code (for which we always skip
      the body), this will hold when the body was present in the original code.
    """) | rust.detach


@annotate(ConstArg)
class _:
    """
    A constant argument in a generic argument list.

    For example:
    ```rust
    Foo::<3>
    //    ^
    ```
    """


@annotate(ConstParam)
class _:
    """
    A constant parameter in a generic parameter list.

    For example:
    ```rust
    struct Foo <const N: usize>;
    //          ^^^^^^^^^^^^^^
    ```
    """


@annotate(DynTraitTypeRepr)
class _:
    """
    A dynamic trait object type.

    For example:
    ```rust
    let x: &dyn Debug;
    //      ^^^^^^^^^
    ```
    """


@annotate(Enum, replace_bases={Item: None})  # still an Item via Adt
class _:
    """
    An enum declaration.

    For example:
    ```rust
    enum E {A, B(i32), C {x: i32}}
    ```
    """


@annotate(ExternBlock)
class _:
    """
    An extern block containing foreign function declarations.

    For example:
    ```rust
    extern "C" {
        fn foo();
    }
    ```
    """


@annotate(ExternCrate)
class _:
    """
    An extern crate declaration.

    For example:
    ```rust
    extern crate serde;
    ```
    """


@annotate(ExternItem, replace_bases={AstNode: Item})
class _:
    """
    An item inside an extern block.

    For example:
    ```rust
    extern "C" {
        fn foo();
        static BAR: i32;
    }
    ```
    """


@annotate(ExternItemList)
class _:
    """
    A list of items inside an extern block.

    For example:
    ```rust
    extern "C" {
        fn foo();
        static BAR: i32;
    }
    ```
    """


@annotate(FieldList)
class _:
    """
    A list of fields in a struct or enum variant.

    For example:
    ```rust
    struct S {x: i32, y: i32}
    //       ^^^^^^^^^^^^^^^^
    enum E {A(i32, i32)}
    //     ^^^^^^^^^^^^^
    ```
    """


@annotate(FnPtrTypeRepr)
class _:
    """
    A function pointer type.

    For example:
    ```rust
    let f: fn(i32) -> i32;
    //     ^^^^^^^^^^^^^^
    ```
    """


@annotate(ForExpr, replace_bases={Expr: LoopingExpr}, cfg=True)
class _:
    """
    A for loop expression.

    For example:
    ```rust
    for x in 0..10 {
        println!("{}", x);
    }
    ```
    """
    label: drop
    loop_body: drop


@annotate(ForTypeRepr)
class _:
    """
    A function pointer type with a `for` modifier.

    For example:
    ```rust
    type RefOp<X> = for<'a> fn(&'a X) -> &'a X;
    //              ^^^^^^^^^^^^^^^^^^^^^^^^^^
    ```
    """

@annotate(FormatArgsArg, cfg=True)
@qltest.test_with(FormatArgsExpr)
class _:
    """
    A FormatArgsArg. For example the `"world"` in:
    ```rust
    format_args!("Hello, {}!", "world")
    ```
    """


@annotate(FormatArgsExpr, cfg=True)
class _:
    """
    A FormatArgsExpr. For example:
    ```rust
    format_args!("no args");
    format_args!("{} foo {:?}", 1, 2);
    format_args!("{b} foo {a:?}", a=1, b=2);
    let (x, y) = (1, 42);
    format_args!("{x}, {y}");
    ```
    """
    formats: list["Format"] | child | synth


@annotate(GenericArg)
class _:
    """
    A generic argument in a generic argument list.

    For example:
    ```rust
    Foo:: <u32, 3, 'a>
    //    ^^^^^^^^^^^
    ```
    """


@annotate(GenericParam)
class _:
    """
    A generic parameter in a generic parameter list.

    For example:
    ```rust
    fn foo<T, U>(t: T, u: U) {}
    //     ^  ^
    ```
    """


@annotate(GenericParamList)
class _:
    """
    A list of generic parameters. For example:
    ```rust
    fn f<A, B>(a: A, b: B) {}
    //  ^^^^^^
    type Foo<T1, T2> = (T1, T2);
    //      ^^^^^^^^
    ```
    """


@annotate(Impl)
class _:
    """
    An `impl`` block.

    For example:
    ```rust
    impl MyTrait for MyType {
        fn foo(&self) {}
    }
    ```
    """


@annotate(ImplTraitTypeRepr)
class _:
    """
    An `impl Trait` type.

    For example:
    ```rust
    fn foo() -> impl Iterator<Item = i32> { 0..10 }
    //          ^^^^^^^^^^^^^^^^^^^^^^^^^^
    ```
    """


@annotate(InferTypeRepr)
class _:
    """
    An inferred type (`_`).

    For example:
    ```rust
    let x: _ = 42;
    //     ^
    ```
    """


@annotate(Item, add_bases=(Addressable,))
class _:
    """
    An item such as a function, struct, enum, etc.

    For example:
    ```rust
    fn foo() {}
    struct S;
    enum E {}
    ```
    """
    attribute_macro_expansion: optional[MacroItems] | child | rust.detach


@annotate(ItemList)
class _:
    """
    A list of items in a module or block.

    For example:
    ```rust
    mod m {
        fn foo() {}
        struct S;
    }
    ```
    """


@annotate(LetElse)
class _:
    """
    An else block in a let-else statement.

    For example:
    ```rust
    let Some(x) = opt else {
        return;
    };
    //                ^^^^^^
    ```
    """


@annotate(Lifetime)
class _:
    """
    A lifetime annotation.

    For example:
    ```rust
    fn foo<'a>(x: &'a str) {}
    //     ^^      ^^
    ```
    """


@annotate(LifetimeArg)
class _:
    """
    A lifetime argument in a generic argument list.

    For example:
    ```rust
    let text: Text<'a>;
    //             ^^
    ```
    """


@annotate(LifetimeParam)
class _:
    """
    A lifetime parameter in a generic parameter list.

    For example:
    ```rust
    fn foo<'a>(x: &'a str) {}
    //     ^^
    ```
    """


@annotate(MacroCall, cfg=True, replace_bases={Item: None})
class _:
    """
    A macro invocation.

    For example:
    ```rust
    println!("Hello, world!");
    ```
    """
    macro_call_expansion: optional[AstNode] | child | rust.detach


@annotate(MacroItems)
@rust.doc_test_signature(None)
class _:
    """
    A sequence of items generated by a macro. For example:
    ```rust
    mod foo{
        include!("common_definitions.rs");

        #[an_attribute_macro]
        fn foo() {
            println!("Hello, world!");
        }

        #[derive(Debug)]
        struct Bar;
    }
    ```
    """


@annotate(MacroRules)
class _:
    """
    A macro definition using the `macro_rules!` syntax.
    ```rust
    macro_rules! my_macro {
        () => {
            println!("This is a macro!");
        };
    }
    ```
    """


class MacroBlockExpr(Expr):
    """
    A sequence of statements generated by a `MacroCall`. For example:
    ```rust
    macro_rules! my_macro {
        () => {
            let mut x = 40;
            x += 2;
            x
        };
    }

    my_macro!();  // this macro expands to a sequence of statements (and an expression)
    ```
    """
    __cfg__ = True

    statements: list[Stmt] | child
    tail_expr: optional[Expr] | child


@annotate(MacroTypeRepr)
class _:
    """
    A type produced by a macro.

    For example:
    ```rust
    macro_rules! macro_type {
        () => { i32 };
    }
    type T = macro_type!();
    //       ^^^^^^^^^^^^^
    ```
    """


@annotate(MatchArmList)
class _:
    """
    A list of arms in a match expression.

    For example:
    ```rust
    match x {
        1 => "one",
        2 => "two",
        _ => "other",
    }
    //  ^^^^^^^^^^^
    ```
    """


@annotate(MatchGuard)
class _:
    """
    A guard condition in a match arm.

    For example:
    ```rust
    match x {
        y if y > 0 => "positive",
    //    ^^^^^^^
        _ => "non-positive",
    }
    ```
    """


@annotate(Meta)
class _:
    """
    A meta item in an attribute.

    For example:
    ```rust
    #[unsafe(lint::name = "reason_for_bypass")]
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #[deprecated(since = "1.2.0", note = "Use bar instead", unsafe=true)]
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    fn foo() {
        // ...
    }
    ```
    """


@annotate(Name, cfg=True)
class _:
    """
    An identifier name.

    For example:
    ```rust
    let foo = 1;
    //  ^^^
    ```
    """


@annotate(NameRef)
class _:
    """
    A reference to a name.

    For example:
    ```rust
      foo();
    //^^^
    ```
    """


@annotate(NeverTypeRepr)
class _:
    """
    The never type `!`.

    For example:
    ```rust
    fn foo() -> ! { panic!() }
    //          ^
    ```
    """


class ParamBase(AstNode):
    """
    A normal parameter, `Param`, or a self parameter `SelfParam`.
    """
    attrs: list["Attr"] | child
    type_repr: optional["TypeRepr"] | child


@annotate(ParamBase, cfg=True)
class _:
    pass


@annotate(Param, replace_bases={AstNode: ParamBase}, cfg=True)
class _:
    """
    A parameter in a function or method. For example `x` in:
    ```rust
    fn new(x: T) -> Foo<T> {
      // ...
    }
    ```
    """
    attrs: drop
    type_repr: drop


@annotate(ParenExpr)
class _:
    """
    A parenthesized expression.

    For example:
    ```rust
    (x + y)
    ```
    """


@annotate(ParenPat)
class _:
    """
    A parenthesized pattern.

    For example:
    ```rust
    let (x) = 1;
    //  ^^^
    ```
    """


@annotate(ParenTypeRepr)
class _:
    """
    A parenthesized type.

    For example:
    ```rust
    let x: (i32);
    //     ^^^^^
    ```
    """


@annotate(PathSegment)
@qltest.test_with(Path)
class _:
    """
    A path segment, which is one part of a whole path.
    For example:
    - `HashMap`
    - `HashMap<K, V>`
    - `Fn(i32) -> i32`
    - `widgets(..)`
    - `<T as Iterator>`
    """
    type_repr: optional["TypeRepr"] | child | rust.detach
    trait_type_repr: optional["PathTypeRepr"] | child | rust.detach


@annotate(PathTypeRepr)
@qltest.test_with(Path)
class _:
    """
    A path referring to a type. For example:
    ```rust
    type X = std::collections::HashMap<i32, i32>;
    type Y = X::Item;
    ```
    """


@annotate(PtrTypeRepr)
class _:
    """
    A pointer type.

    For example:
    ```rust
    let p: *const i32;
    let q: *mut i32;
    //     ^^^^^^^^^
    ```
    """


@annotate(StructExprFieldList)
class _:
    """
    A list of fields in a struct expression.

    For example:
    ```rust
    Foo { a: 1, b: 2 }
    //    ^^^^^^^^^^^
    ```
    """


@annotate(StructField)
class _:
    """
    A field in a struct declaration.

    For example:
    ```rust
    struct S { x: i32 }
    //         ^^^^^^^
    ```
    """


@annotate(StructFieldList)
class _:
    """
    A list of fields in a struct declaration.

    For example:
    ```rust
    struct S { x: i32, y: i32 }
    //         ^^^^^^^^^^^^^^^
    ```
    """


@annotate(StructPatFieldList)
class _:
    """
    A list of fields in a struct pattern.

    For example:
    ```rust
    let Foo { a, b } = foo;
    //        ^^^^^
    ```
    """


@annotate(RefTypeRepr)
class _:
    """
    A reference type.

    For example:
    ```rust
    let r: &i32;
    let m: &mut i32;
    //     ^^^^^^^^
    ```
    """


@annotate(Rename)
class _:
    """
    A rename in a use declaration.

    For example:
    ```rust
    use foo as bar;
    //      ^^^^^^
    ```
    """


@annotate(RestPat, cfg=True)
class _:
    """
    A rest pattern (`..`) in a tuple, slice, or struct pattern.

    For example:
    ```rust
    let (a, .., z) = (1, 2, 3);
    //      ^^
    ```
    """


@annotate(RetTypeRepr)
class _:
    """
    A return type in a function signature.

    For example:
    ```rust
    fn foo() -> i32 {}
    //       ^^^^^^
    ```
    """


@annotate(ReturnTypeSyntax)
class _:
    """
    A return type notation `(..)` to reference or bound the type returned by a trait method

    For example:
    ```rust
    struct ReverseWidgets<F: Factory<widgets(..): DoubleEndedIterator>> {
        factory: F,
    }

    impl<F> Factory for ReverseWidgets<F>
    where
      F: Factory<widgets(..): DoubleEndedIterator>,
    {
      fn widgets(&self) -> impl Iterator<Item = Widget> {
        self.factory.widgets().rev()
      }
    }
    ```
    """


@annotate(SelfParam, replace_bases={AstNode: ParamBase}, cfg=True)
@rust.doc_test_signature(None)
class _:
    """
    A `self` parameter. For example `self` in:
    ```rust
    struct X;
    impl X {
      fn one(&self) {}
      fn two(&mut self) {}
      fn three(self) {}
      fn four(mut self) {}
      fn five<'a>(&'a self) {}
    }
    ```
    """
    attrs: drop
    type_repr: drop


@annotate(SliceTypeRepr)
class _:
    """
    A slice type.

    For example:
    ```rust
    let s: &[i32];
    //      ^^^^^
    ```
    """


@annotate(SourceFile)
class _:
    """
    A source file.

    For example:
    ```rust
    // main.rs
    fn main() {}
    ```
    """


@annotate(Static, replace_bases={Item: None})
class _:
    """
    A static item declaration.

    For example:
    ```rust
    static X: i32 = 42;
    ```
    """


@annotate(StmtList)
class _:
    """
    A list of statements in a block.

    For example:
    ```rust
    {
        let x = 1;
        let y = 2;
    }
    //  ^^^^^^^^^
    ```
    """


@annotate(Struct, replace_bases={Item: None})  # still an Item via Adt
class _:
    """
    A Struct. For example:
    ```rust
    struct Point {
        x: i32,
        y: i32,
    }
    ```
    """
    field_list: _ | ql.db_table_name("struct_field_lists_")


@annotate(TokenTree)
class _:
    """
    A token tree in a macro definition or invocation.

    For example:
    ```rust
    println!("{} {}!", "Hello", "world");
    //      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    ```
    ```rust
    macro_rules! foo { ($x:expr) => { $x + 1 }; }
    //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    ```
    """


@annotate(Trait)
@rust.doc_test_signature(None)
class _:
    """
    A Trait. For example:
    ```
    trait Frobinizable {
      type Frobinator;
      type Result: Copy;
      fn frobinize_with(&mut self, frobinator: &Self::Frobinator) -> Result;
    }

    pub trait Foo<T: Frobinizable> where T::Frobinator: Eq {}
    ```
    """


@annotate(TraitAlias)
class _:
    """
    A trait alias.

    For example:
    ```rust
    trait Foo = Bar + Baz;
    ```
    """


@annotate(TryExpr, cfg=True)
class _:
    """
    A try expression using the `?` operator.

    For example:
    ```rust
    let x = foo()?;
    //           ^
    ```
    """


@annotate(TupleField)
class _:
    """
    A field in a tuple struct or tuple enum variant.

    For example:
    ```rust
    struct S(i32, String);
    //       ^^^  ^^^^^^
    ```
    """


@annotate(TupleFieldList)
class _:
    """
    A list of fields in a tuple struct or tuple enum variant.

    For example:
    ```rust
    struct S(i32, String);
    //      ^^^^^^^^^^^^^
    ```
    """


@annotate(TupleTypeRepr)
class _:
    """
    A tuple type.

    For example:
    ```rust
    let t: (i32, String);
    //     ^^^^^^^^^^^^^
    ```
    """


@annotate(TypeAlias, replace_bases={Item: None})
class _:
    """
    A type alias. For example:
    ```rust
    type Point = (u8, u8);

    trait Trait {
        type Output;
    //  ^^^^^^^^^^^
    }
    ```
    """


@annotate(TypeArg)
class _:
    """
    A type argument in a generic argument list.

    For example:
    ```rust
    Foo::<u32>
    //    ^^^
    ```
    """


@annotate(TypeBound)
class _:
    """
    A type bound in a trait or generic parameter.

    For example:
    ```rust
    fn foo<T: Debug>(t: T) {}
    //        ^^^^^
    fn bar(value: impl for<'a> From<&'a str>) {}
    //                 ^^^^^^^^^^^^^^^^^^^^^
    ```
    """


@annotate(TypeBoundList)
class _:
    """
    A list of type bounds.

    For example:
    ```rust
    fn foo<T: Debug + Clone>(t: T) {}
    //        ^^^^^^^^^^^^^
    ```
    """


@annotate(TypeParam)
class _:
    """
    A type parameter in a generic parameter list.

    For example:
    ```rust
    fn foo<T>(t: T) {}
    //     ^
    ```
    """


@annotate(Union, replace_bases={Item: None})  # still an Item via Adt
class _:
    """
    A union declaration.

    For example:
    ```rust
    union U { f1: u32, f2: f32 }
    ```
    """


@annotate(Use)
class _:
    """
    A `use` statement. For example:
    ```rust
    use std::collections::HashMap;
    ```
    """


@annotate(UseTree)
class _:
    """
    A `use` tree, that is, the part after the `use` keyword in a `use` statement. For example:
    ```rust
    use std::collections::HashMap;
    use std::collections::*;
    use std::collections::HashMap as MyHashMap;
    use std::collections::{self, HashMap, HashSet};
    ```
    """


@annotate(UseTreeList)
class _:
    """
    A list of use trees in a use declaration.

    For example:
    ```rust
    use std::{fs, io};
    //       ^^^^^^^^
    ```
    """


@annotate(Variant, replace_bases={AstNode: Addressable})
class _:
    """
    A variant in an enum declaration.

    For example:
    ```rust
    enum E { A, B(i32), C { x: i32 } }
    //       ^  ^^^^^^  ^^^^^^^^^^^^
    ```
    """


@annotate(VariantList)
class _:
    """
    A list of variants in an enum declaration.

    For example:
    ```rust
    enum E { A, B, C }
    //     ^^^^^^^^^^^
    ```
    """


@annotate(Visibility)
class _:
    """
    A visibility modifier.

    For example:
    ```rust
      pub struct S;
    //^^^
    ```
    """


@annotate(WhereClause)
class _:
    """
    A where clause in a generic declaration.

    For example:
    ```rust
    fn foo<T>(t: T) where T: Debug {}
    //              ^^^^^^^^^^^^^^
    ```
    """


@annotate(WherePred)
class _:
    """
    A predicate in a where clause.

    For example:
    ```rust
    fn foo<T, U>(t: T, u: U) where T: Debug, U: Clone {}
    //                             ^^^^^^^^  ^^^^^^^^
    fn bar<T>(value: T) where for<'a> T: From<&'a str> {}
    //                        ^^^^^^^^^^^^^^^^^^^^^^^^
    ```
    """


@annotate(WhileExpr, replace_bases={Expr: LoopingExpr}, cfg=True)
class _:
    """
    A while loop expression.

    For example:
    ```rust
    while x < 10 {
        x += 1;
    }
    ```
    """
    label: drop
    loop_body: drop


@annotate(Function, add_bases=[Callable], replace_bases={Item: None})
class _:
    param_list: drop
    attrs: drop
    has_implementation: predicate | doc("this function has an implementation") | desc("""
      This is the same as `hasBody` for source code, but for library code (for which we always skip
      the body), this will hold when the body was present in the original code.
    """) | rust.detach


@annotate(ClosureExpr, add_bases=[Callable])
class _:
    param_list: drop
    attrs: drop


@synth.on_arguments(parent="FormatArgsExpr", index=int, kind=int)
@qltest.test_with(FormatArgsExpr)
class FormatTemplateVariableAccess(PathExprBase):
    pass


@synth.on_arguments(parent=FormatArgsExpr, index=int, text=string, offset=int)
@qltest.test_with(FormatArgsExpr)
class Format(Locatable):
    """
    A format element in a formatting template. For example the `{}` in:
    ```rust
    println!("Hello {}", "world");
    ```
    or the `{value:#width$.precision$}` in:
    ```rust
    println!("Value {value:#width$.precision$}");
    ```
    """
    parent: FormatArgsExpr
    index: int
    argument_ref: optional["FormatArgument"] | child | desc("""
        For example `name` and `0` in:
        ```rust
        let name = "Alice";
        println!("{name} in wonderland");
        println!("{0} in wonderland", name);
        ```
    """)
    width_argument: optional["FormatArgument"] | child | desc("""
        For example `width` and `1` in:
        ```rust
        let width = 6;
        println!("{:width$}", PI);
        println!("{:1$}", PI, width);
        ```
    """)
    precision_argument: optional["FormatArgument"] | child | desc("""
        For example `prec` and `1` in:
        ```rust
        let prec = 6;
        println!("{:.prec$}", PI);
        println!("{:.1$}", PI, prec);
        ```
    """)


@synth.on_arguments(parent=FormatArgsExpr, index=int, kind=int, name=string, positional=boolean, offset=int)
@qltest.test_with(FormatArgsExpr)
class FormatArgument(Locatable):
    """
    An argument in a format element in a formatting template. For example the `width`, `precision`, and `value` in:
    ```rust
    println!("Value {value:#width$.precision$}");
    ```
    or the `0`, `1` and `2` in:
    ```rust
    println!("Value {0:#1$.2$}", value, width, precision);
    ```
    """
    parent: Format
    variable: optional[FormatTemplateVariableAccess] | child


@annotate(MacroDef)
class _:
    """
    A Rust 2.0 style declarative macro definition.

    For example:
    ```rust
    pub macro vec_of_two($element:expr) {
        vec![$element, $element]
    }
    ```
    """


@annotate(MacroExpr, cfg=True)
class _:
    """
    A macro expression, representing the invocation of a macro that produces an expression.

    For example:
    ```rust
    let y = vec![1, 2, 3];
    ```
    """


@annotate(MacroPat, cfg=True)
class _:
    """
    A macro pattern, representing the invocation of a macro that produces a pattern.

    For example:
    ```rust
    macro_rules! my_macro {
        () => {
            Ok(_)
        };
    }
    match x {
        my_macro!() => "matched",
    //  ^^^^^^^^^^^
        _ => "not matched",
    }
    ```
    """


@annotate(ParamList)
class _:
    """
    A list of parameters in a function, method, or closure declaration.

    For example:
    ```rust
    fn foo(x: i32, y: i32) {}
    //      ^^^^^^^^^^^^^
    ```
    """


@annotate(AsmDirSpec)
class _:
    """
    An inline assembly direction specifier.

    For example:
    ```rust
    use core::arch::asm;
    asm!("mov {input:x}, {input:x}", output = out(reg) x, input = in(reg) y);
    //                                        ^^^                 ^^
    ```
    """


@annotate(AsmOperandExpr)
class _:
    """
    An operand expression in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("mov {0}, {1}", out(reg) x, in(reg) y);
    //                            ^          ^
    ```
    """


@annotate(AsmOption)
class _:
    """
    An option in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("", options(nostack, nomem));
    //              ^^^^^^^^^^^^^^^^
    ```
    """


@annotate(AsmRegSpec)
class _:
    """
    A register specification in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("mov {0}, {1}", out("eax") x, in(EBX) y);
    //                        ^^^         ^^^
    ```
    """


@annotate(AsmClobberAbi)
class _:
    """
    A clobbered ABI in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("", clobber_abi("C"));
    //       ^^^^^^^^^^^^^^^^
    ```
    """


@annotate(AsmConst)
class _:
    """
    A constant operand in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("mov eax, {const}", const 42);
    //                       ^^^^^^^
    ```
    """


@annotate(AsmLabel)
class _:
    """
    A label in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!(
        "jmp {}",
        label { println!("Jumped from asm!"); }
    //  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    );
    ```
    """


@annotate(AsmOperandNamed)
class _:
    """
    A named operand in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("mov {0:x}, {input:x}", out(reg) x, input = in(reg) y);
    //                           ^^^^^^^^^^^ ^^^^^^^^^^^^^^^^^
    ```
    """


@annotate(AsmOptionsList)
class _:
    """
    A list of options in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("", options(nostack, nomem));
    //              ^^^^^^^^^^^^^^^^
    ```
    """


@annotate(AsmRegOperand)
class _:
    """
    A register operand in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("mov {0}, {1}", out(reg) x, in(reg) y);
    //                            ^         ^
    ```
    """


@annotate(AsmSym)
class _:
    """
    A symbol operand in an inline assembly block.

    For example:
    ```rust
    use core::arch::asm;
    asm!("call {sym}", sym = sym my_function);
    //                 ^^^^^^^^^^^^^^^^^^^^^^
    ```
    """


@annotate(UseBoundGenericArgs)
class _:
    """
    A use<..> bound to control which generic parameters are captured by an impl Trait return type.

    For example:
    ```rust
    pub fn hello<'a, T, const N: usize>() -> impl Sized + use<'a, T, N> {}
    //                                                        ^^^^^^^^
    ```
    """


@annotate(ParenthesizedArgList)
class _:
    """
    A parenthesized argument list as used in function traits.

    For example:
    ```rust
    fn call_with_42<F>(f: F) -> i32
    where
        F: Fn(i32, String) -> i32,
    //        ^^^^^^^^^^^
    {
        f(42, "Don't panic".to_string())
    }
    ```
    """
