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

@annotate(Pat)
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

@annotate(Path)
class _:
    """
    A path. For example:
    ```rust
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
    };
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
    ```rust
    let x = 'label: {
        if exit() {
            break 'label 42;
        }
        0;
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
    let x = -42;
    let y = !true;
    let z = *ptr;
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

@annotate(UnderscoreExpr)
class _:
    """
    An underscore expression. For example:
    ```rust
    _ = 42;
    ```
    """

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
    finish();
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
@annotate(ArrayType)
class _:
    """
    A ArrayType. For example:
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
class _:
    """
    A AssocItemList. For example:
    ```rust
    todo!()
    ```
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
@annotate(DynTraitType)
class _:
    """
    A DynTraitType. For example:
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
@annotate(FnPtrType)
class _:
    """
    A FnPtrType. For example:
    ```rust
    todo!()
    ```
    """
@annotate(ForExpr)
class _:
    """
    A ForExpr. For example:
    ```rust
    todo!()
    ```
    """
@annotate(ForType)
class _:
    """
    A ForType. For example:
    ```rust
    todo!()
    ```
    """
@annotate(FormatArgsArg)
class _:
    """
    A FormatArgsArg. For example:
    ```rust
    todo!()
    ```
    """
@annotate(FormatArgsExpr)
class _:
    """
    A FormatArgsExpr. For example:
    ```rust
    todo!()
    ```
    """
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
@annotate(ImplTraitType)
class _:
    """
    A ImplTraitType. For example:
    ```rust
    todo!()
    ```
    """
@annotate(InferType)
class _:
    """
    A InferType. For example:
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
@annotate(MacroCall)
class _:
    """
    A MacroCall. For example:
    ```rust
    todo!()
    ```
    """
@annotate(MacroDef)
class _:
    """
    A MacroDef. For example:
    ```rust
    todo!()
    ```
    """
@annotate(MacroExpr)
class _:
    """
    A MacroExpr. For example:
    ```rust
    todo!()
    ```
    """
@annotate(MacroPat)
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
@annotate(MacroType)
class _:
    """
    A MacroType. For example:
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
@annotate(NeverType)
class _:
    """
    A NeverType. For example:
    ```rust
    todo!()
    ```
    """
@annotate(Param)
class _:
    """
    A Param. For example:
    ```rust
    todo!()
    ```
    """
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
@annotate(ParenType)
class _:
    """
    A ParenType. For example:
    ```rust
    todo!()
    ```
    """
@annotate(PathSegment)
class _:
    """
    A PathSegment. For example:
    ```rust
    todo!()
    ```
    """
@annotate(PathType)
class _:
    """
    A PathType. For example:
    ```rust
    todo!()
    ```
    """
@annotate(PtrType)
class _:
    """
    A PtrType. For example:
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
@annotate(RefType)
class _:
    """
    A RefType. For example:
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
@annotate(RestPat)
class _:
    """
    A RestPat. For example:
    ```rust
    todo!()
    ```
    """
@annotate(RetType)
class _:
    """
    A RetType. For example:
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
@annotate(SelfParam)
class _:
    """
    A SelfParam. For example:
    ```rust
    todo!()
    ```
    """
@annotate(SliceType)
class _:
    """
    A SliceType. For example:
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
class _:
    """
    A Trait. For example:
    ```rust
    todo!()
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
@annotate(TryExpr)
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
@annotate(TupleType)
class _:
    """
    A TupleType. For example:
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
    todo!()
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
@annotate(Variant)
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
@annotate(WhileExpr)
class _:
    """
    A WhileExpr. For example:
    ```rust
    todo!()
    ```
    """
