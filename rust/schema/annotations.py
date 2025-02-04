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


@annotate(MethodCallExpr, replace_bases={Expr: CallExprBase}, add_bases=(Resolvable,), cfg=True)
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


@annotate(RecordExprField)
class _:
    """
    A field in a record expression. For example `a: 1` in:
    ```rust
    Foo { a: 1, b: 2 };
    ```
    """


@annotate(RecordExpr, add_bases=(PathAstNode,), cfg=True)
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
    ```
    """


@annotate(TupleExpr, cfg=True)
class _:
    """
    A tuple expression. For example:
    ```rust
    (1, "one");
    (2, "two")[0] = 3;
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
        builtin # asm(_);
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


@annotate(RecordPatField)
class _:
    """
    A field in a record pattern. For example `a: 1` in:
    ```rust
    let Foo { a: 1, b: 2 } = foo;
    ```
    """


@annotate(RecordPat, add_bases=(PathAstNode,), cfg=True)
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
    A Abi. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ArgList)
class _:
    """
    A ArgList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ArrayTypeRepr)
class _:
    """
    A ArrayTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(AssocItem)
class _:
    """
    A AssocItem. For example:
    ```rust
    todo!()
    ```
    """


@annotate(AssocItemList)
@qltest.test_with(Trait)
class _:
    """
    A list of  `AssocItem` elements, as appearing for example in a `Trait`.
    """


@annotate(AssocTypeArg)
class _:
    """
    A AssocTypeArg. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Attr)
class _:
    """
    A Attr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ClosureBinder)
class _:
    """
    A ClosureBinder. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Const)
class _:
    """
    A Const. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ConstArg)
class _:
    """
    A ConstArg. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ConstParam)
class _:
    """
    A ConstParam. For example:
    ```rust
    todo!()
    ```
    """


@annotate(DynTraitTypeRepr)
class _:
    """
    A DynTraitTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Enum)
class _:
    """
    A Enum. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ExternBlock)
class _:
    """
    A ExternBlock. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ExternCrate)
class _:
    """
    A ExternCrate. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ExternItem)
class _:
    """
    A ExternItem. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ExternItemList)
class _:
    """
    A ExternItemList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(FieldList)
class _:
    """
    A FieldList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(FnPtrTypeRepr)
class _:
    """
    A FnPtrTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ForExpr, replace_bases={Expr: LoopingExpr}, cfg=True)
class _:
    """
    A ForExpr. For example:
    ```rust
    todo!()
    ```
    """
    label: drop
    loop_body: drop


@annotate(ForTypeRepr)
class _:
    """
    A ForTypeRepr. For example:
    ```rust
    todo!()
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
    A GenericArg. For example:
    ```rust
    todo!()
    ```
    """


@annotate(GenericParam)
class _:
    """
    A GenericParam. For example:
    ```rust
    todo!()
    ```
    """


@annotate(GenericParamList)
class _:
    """
    A GenericParamList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Impl)
class _:
    """
    A Impl. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ImplTraitTypeRepr)
class _:
    """
    A ImplTraitTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(InferTypeRepr)
class _:
    """
    A InferTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Item)
class _:
    """
    A Item. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ItemList)
class _:
    """
    A ItemList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(LetElse)
class _:
    """
    A LetElse. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Lifetime)
class _:
    """
    A Lifetime. For example:
    ```rust
    todo!()
    ```
    """


@annotate(LifetimeArg)
class _:
    """
    A LifetimeArg. For example:
    ```rust
    todo!()
    ```
    """


@annotate(LifetimeParam)
class _:
    """
    A LifetimeParam. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MacroCall, cfg=True)
class _:
    """
    A MacroCall. For example:
    ```rust
    todo!()
    ```
    """
    expanded: optional[AstNode] | child | rust.detach


@annotate(MacroDef)
class _:
    """
    A MacroDef. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MacroExpr, cfg=True)
class _:
    """
    A MacroExpr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MacroItems)
@rust.doc_test_signature(None)
class _:
    """
    A sequence of items generated by a `MacroCall`. For example:
    ```rust
    mod foo{
        include!("common_definitions.rs");
    }
    ```
    """


@annotate(MacroPat, cfg=True)
class _:
    """
    A MacroPat. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MacroRules)
class _:
    """
    A MacroRules. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MacroStmts)
@rust.doc_test_signature(None)
class _:
    """
    A sequence of statements generated by a `MacroCall`. For example:
    ```rust
    fn main() {
        println!("Hello, world!"); // This macro expands into a list of statements
    }
    ```
    """


@annotate(MacroTypeRepr)
class _:
    """
    A MacroTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MatchArmList)
class _:
    """
    A MatchArmList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(MatchGuard)
class _:
    """
    A MatchGuard. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Meta)
class _:
    """
    A Meta. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Name)
class _:
    """
    A Name. For example:
    ```rust
    todo!()
    ```
    """


@annotate(NameRef)
class _:
    """
    A NameRef. For example:
    ```rust
    todo!()
    ```
    """


@annotate(NeverTypeRepr)
class _:
    """
    A NeverTypeRepr. For example:
    ```rust
    todo!()
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


@annotate(ParamList)
class _:
    """
    A ParamList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ParenExpr)
class _:
    """
    A ParenExpr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ParenPat)
class _:
    """
    A ParenPat. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ParenTypeRepr)
class _:
    """
    A ParenTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(PathSegment)
@qltest.test_with(Path)
class _:
    """
    A path segment, which is one part of a whole path.
    """


@annotate(PathTypeRepr)
@qltest.test_with(Path)
class _:
    """
    A type referring to a path. For example:
    ```rust
    type X = std::collections::HashMap<i32, i32>;
    type Y = X::Item;
    ```
    """


@annotate(PtrTypeRepr)
class _:
    """
    A PtrTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RecordExprFieldList)
class _:
    """
    A RecordExprFieldList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RecordField)
class _:
    """
    A RecordField. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RecordFieldList)
class _:
    """
    A RecordFieldList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RecordPatFieldList)
class _:
    """
    A RecordPatFieldList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RefTypeRepr)
class _:
    """
    A RefTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Rename)
class _:
    """
    A Rename. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RestPat, cfg=True)
class _:
    """
    A RestPat. For example:
    ```rust
    todo!()
    ```
    """


@annotate(RetTypeRepr)
class _:
    """
    A RetTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(ReturnTypeSyntax)
class _:
    """
    A ReturnTypeSyntax. For example:
    ```rust
    todo!()
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
    A SliceTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(SourceFile)
class _:
    """
    A SourceFile. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Static)
class _:
    """
    A Static. For example:
    ```rust
    todo!()
    ```
    """


@annotate(StmtList)
class _:
    """
    A StmtList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Struct)
class _:
    """
    A Struct. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TokenTree)
class _:
    """
    A TokenTree. For example:
    ```rust
    todo!()
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
    A TraitAlias. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TryExpr, cfg=True)
class _:
    """
    A TryExpr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TupleField)
class _:
    """
    A TupleField. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TupleFieldList)
class _:
    """
    A TupleFieldList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TupleTypeRepr)
class _:
    """
    A TupleTypeRepr. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TypeAlias)
class _:
    """
    A TypeAlias. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TypeArg)
class _:
    """
    A TypeArg. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TypeBound)
class _:
    """
    A TypeBound. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TypeBoundList)
class _:
    """
    A TypeBoundList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(TypeParam)
class _:
    """
    A TypeParam. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Union)
class _:
    """
    A Union. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Use)
class _:
    """
    A Use. For example:
    ```rust
    todo!()
    ```
    """


@annotate(UseTree)
class _:
    """
    A UseTree. For example:
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
    A UseTreeList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Variant, replace_bases={AstNode: Addressable})
class _:
    """
    A Variant. For example:
    ```rust
    todo!()
    ```
    """


@annotate(VariantList)
class _:
    """
    A VariantList. For example:
    ```rust
    todo!()
    ```
    """


@annotate(Visibility)
class _:
    """
    A Visibility. For example:
    ```rust
    todo!()
    ```
    """


@annotate(WhereClause)
class _:
    """
    A WhereClause. For example:
    ```rust
    todo!()
    ```
    """


@annotate(WherePred)
class _:
    """
    A WherePred. For example:
    ```rust
    todo!()
    ```
    """


@annotate(WhileExpr, replace_bases={Expr: LoopingExpr}, cfg=True)
class _:
    """
    A WhileExpr. For example:
    ```rust
    todo!()
    ```
    """
    label: drop
    loop_body: drop


@annotate(Function, add_bases=[Callable])
class _:
    param_list: drop
    attrs: drop


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


@annotate(Item, add_bases=(Addressable,))
class _:
    pass
