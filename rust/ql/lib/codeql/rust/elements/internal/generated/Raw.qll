/**
 * INTERNAL: Do not use.
 * This module holds thin fully generated class definitions around DB entities.
 */
module Raw {
  /**
   * INTERNAL: Do not use.
   */
  class Element extends @element {
    string toString() { none() }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Locatable extends @locatable, Element { }

  /**
   * INTERNAL: Do not use.
   * The base class marking everything that was not properly extracted for some reason, such as:
   * * syntax errors
   * * insufficient context information
   * * yet unimplemented parts of the extractor
   */
  class Unextracted extends @unextracted, Element { }

  /**
   * INTERNAL: Do not use.
   */
  class AstNode extends @ast_node, Locatable { }

  /**
   * INTERNAL: Do not use.
   * The base class marking errors during parsing or resolution.
   */
  class Missing extends @missing, Unextracted { }

  /**
   * INTERNAL: Do not use.
   * The base class for unimplemented nodes. This is used to mark nodes that are not yet extracted.
   */
  class Unimplemented extends @unimplemented, Unextracted { }

  /**
   * INTERNAL: Do not use.
   * The base class for declarations.
   */
  class Declaration extends @declaration, AstNode { }

  /**
   * INTERNAL: Do not use.
   * The base class for expressions.
   */
  class Expr extends @expr, AstNode { }

  /**
   * INTERNAL: Do not use.
   * The base class for generic arguments.
   * ```rust
   * x.foo::<u32, u64>(42);
   * ```
   */
  class GenericArgList extends @generic_arg_list, AstNode, Unimplemented {
    override string toString() { result = "GenericArgList" }
  }

  /**
   * INTERNAL: Do not use.
   * A label. For example:
   * ```rust
   * 'label: loop {
   *     println!("Hello, world (once)!");
   *     break 'label;
   * };
   * ```
   */
  class Label extends @label, AstNode {
    override string toString() { result = "Label" }

    /**
     * Gets the name of this label.
     */
    string getName() { labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A match arm. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * };
   * ```
   * ```rust
   * match x {
   *     Some(y) if y != 0 => 1 / y,
   *     _ => 0,
   * };
   * ```
   */
  class MatchArm extends @match_arm, AstNode {
    override string toString() { result = "MatchArm" }

    /**
     * Gets the pat of this match arm.
     */
    Pat getPat() { match_arms(this, result, _) }

    /**
     * Gets the guard of this match arm, if it exists.
     */
    Expr getGuard() { match_arm_guards(this, result) }

    /**
     * Gets the expression of this match arm.
     */
    Expr getExpr() { match_arms(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for patterns.
   */
  class Pat extends @pat, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A path. For example:
   * ```rust
   * foo::bar;
   * ```
   */
  class Path extends @path, AstNode, Unimplemented {
    override string toString() { result = "Path" }
  }

  /**
   * INTERNAL: Do not use.
   * A field in a record expression. For example `a: 1` in:
   * ```rust
   * Foo { a: 1, b: 2 };
   * ```
   */
  class RecordExprField extends @record_expr_field, AstNode {
    override string toString() { result = "RecordExprField" }

    /**
     * Gets the name of this record expression field.
     */
    string getName() { record_expr_fields(this, result, _) }

    /**
     * Gets the expression of this record expression field.
     */
    Expr getExpr() { record_expr_fields(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A field in a record pattern. For example `a: 1` in:
   * ```rust
   * let Foo { a: 1, b: 2 } = foo;
   * ```
   */
  class RecordPatField extends @record_pat_field, AstNode {
    override string toString() { result = "RecordPatField" }

    /**
     * Gets the name of this record pat field.
     */
    string getName() { record_pat_fields(this, result, _) }

    /**
     * Gets the pat of this record pat field.
     */
    Pat getPat() { record_pat_fields(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for statements.
   */
  class Stmt extends @stmt, AstNode { }

  /**
   * INTERNAL: Do not use.
   * The base class for type references.
   * ```rust
   * let x: i32;
   * let y: Vec<i32>;
   * let z: Option<i32>;
   * ```
   */
  class TypeRef extends @type_ref, AstNode, Unimplemented {
    override string toString() { result = "TypeRef" }
  }

  /**
   * INTERNAL: Do not use.
   * An array expression. For example:
   * ```rust
   * [1, 2, 3];
   * [1; 10];
   * ```
   */
  class ArrayExpr extends @array_expr, Expr { }

  /**
   * INTERNAL: Do not use.
   * An inline assembly expression. For example:
   * ```rust
   * unsafe {
   *     builtin # asm(_);
   * }
   * ```
   */
  class AsmExpr extends @asm_expr, Expr {
    override string toString() { result = "AsmExpr" }

    /**
     * Gets the expression of this asm expression.
     */
    Expr getExpr() { asm_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An `await` expression. For example:
   * ```rust
   * async {
   *     let x = foo().await;
   *     x
   * }
   * ```
   */
  class AwaitExpr extends @await_expr, Expr {
    override string toString() { result = "AwaitExpr" }

    /**
     * Gets the expression of this await expression.
     */
    Expr getExpr() { await_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A `become` expression. For example:
   * ```rust
   * fn fact_a(n: i32, a: i32) -> i32 {
   *      if n == 0 {
   *          a
   *      } else {
   *          become fact_a(n - 1, n * a)
   *      }
   * }
   * ```
   */
  class BecomeExpr extends @become_expr, Expr {
    override string toString() { result = "BecomeExpr" }

    /**
     * Gets the expression of this become expression.
     */
    Expr getExpr() { become_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A binary operation expression. For example:
   * ```rust
   * x + y;
   * x && y;
   * x <= y;
   * x = y;
   * x += y;
   * ```
   */
  class BinaryExpr extends @binary_expr, Expr {
    override string toString() { result = "BinaryExpr" }

    /**
     * Gets the lhs of this binary expression.
     */
    Expr getLhs() { binary_exprs(this, result, _) }

    /**
     * Gets the rhs of this binary expression.
     */
    Expr getRhs() { binary_exprs(this, _, result) }

    /**
     * Gets the op of this binary expression, if it exists.
     */
    string getOp() { binary_expr_ops(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BlockExprBase extends @block_expr_base, Expr {
    /**
     * Gets the `index`th statement of this block expression base (0-based).
     */
    Stmt getStatement(int index) { block_expr_base_statements(this, index, result) }

    /**
     * Gets the tail of this block expression base, if it exists.
     */
    Expr getTail() { block_expr_base_tails(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A box expression. For example:
   * ```rust
   * let x = #[rustc_box] Box::new(42);
   * ```
   */
  class BoxExpr extends @box_expr, Expr {
    override string toString() { result = "BoxExpr" }

    /**
     * Gets the expression of this box expression.
     */
    Expr getExpr() { box_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A box pattern. For example:
   * ```rust
   * match x {
   *     box Option::Some(y) => y,
   *     box Option::None => 0,
   * };
   * ```
   */
  class BoxPat extends @box_pat, Pat {
    override string toString() { result = "BoxPat" }

    /**
     * Gets the inner of this box pat.
     */
    Pat getInner() { box_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A break expression. For example:
   * ```rust
   * loop {
   *     if not_ready() {
   *         break;
   *      }
   * }
   * ```
   * ```rust
   * let x = 'label: loop {
   *     if done() {
   *         break 'label 42;
   *     }
   * };
   * ```
   */
  class BreakExpr extends @break_expr, Expr {
    override string toString() { result = "BreakExpr" }

    /**
     * Gets the expression of this break expression, if it exists.
     */
    Expr getExpr() { break_expr_exprs(this, result) }

    /**
     * Gets the label of this break expression, if it exists.
     */
    Label getLabel() { break_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A function call expression. For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * foo(1) = 4;
   * ```
   */
  class CallExpr extends @call_expr, Expr {
    override string toString() { result = "CallExpr" }

    /**
     * Gets the callee of this call expression.
     */
    Expr getCallee() { call_exprs(this, result) }

    /**
     * Gets the `index`th argument of this call expression (0-based).
     */
    Expr getArg(int index) { call_expr_args(this, index, result) }

    /**
     * Holds if this call expression is assignee expression.
     */
    predicate isAssigneeExpr() { call_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A cast expression. For example:
   * ```rust
   * value as u64;
   * ```
   */
  class CastExpr extends @cast_expr, Expr {
    override string toString() { result = "CastExpr" }

    /**
     * Gets the expression of this cast expression.
     */
    Expr getExpr() { cast_exprs(this, result, _) }

    /**
     * Gets the type of this cast expression.
     */
    TypeRef getType() { cast_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A closure expression. For example:
   * ```rust
   * |x| x + 1;
   * move |x: i32| -> i32 { x + 1 };
   * async |x: i32, y| x + y;
   *  #[coroutine]
   * |x| yield x;
   *  #[coroutine]
   *  static |x| yield x;
   * ```
   */
  class ClosureExpr extends @closure_expr, Expr {
    override string toString() { result = "ClosureExpr" }

    /**
     * Gets the `index`th argument of this closure expression (0-based).
     */
    Pat getArg(int index) { closure_expr_args(this, index, result) }

    /**
     * Gets the `index`th argument type of this closure expression (0-based), if it exists.
     */
    TypeRef getArgType(int index) { closure_expr_arg_types(this, index, result) }

    /**
     * Gets the ret type of this closure expression, if it exists.
     */
    TypeRef getRetType() { closure_expr_ret_types(this, result) }

    /**
     * Gets the body of this closure expression.
     */
    Expr getBody() { closure_exprs(this, result, _) }

    /**
     * Gets the closure kind of this closure expression.
     */
    string getClosureKind() { closure_exprs(this, _, result) }

    /**
     * Holds if this closure expression is move.
     */
    predicate isMove() { closure_expr_is_move(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A const block pattern. For example:
   * ```rust
   * match x {
   *     const { 1 + 2 + 3 } => "ok",
   *     _ => "fail",
   * };
   * ```
   */
  class ConstBlockPat extends @const_block_pat, Pat {
    override string toString() { result = "ConstBlockPat" }

    /**
     * Gets the expression of this const block pat.
     */
    Expr getExpr() { const_block_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A `const` block expression. For example:
   * ```rust
   * if const { SRC::IS_ZST || DEST::IS_ZST || mem::align_of::<SRC>() != mem::align_of::<DEST>() } {
   *     return false;
   * }
   * ```
   */
  class ConstExpr extends @const_expr, Expr {
    override string toString() { result = "ConstExpr" }

    /**
     * Gets the expression of this const expression.
     */
    Expr getExpr() { const_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A continue expression. For example:
   * ```rust
   * loop {
   *     if not_ready() {
   *         continue;
   *     }
   * }
   * ```
   * ```rust
   * 'label: loop {
   *     if not_ready() {
   *         continue 'label;
   *     }
   * }
   * ```
   */
  class ContinueExpr extends @continue_expr, Expr {
    override string toString() { result = "ContinueExpr" }

    /**
     * Gets the label of this continue expression, if it exists.
     */
    Label getLabel() { continue_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An expression statement. For example:
   * ```rust
   * start();
   * finish()
   * use std::env;
   * ```
   */
  class ExprStmt extends @expr_stmt, Stmt {
    override string toString() { result = "ExprStmt" }

    /**
     * Gets the expression of this expression statement.
     */
    Expr getExpr() { expr_stmts(this, result) }

    /**
     * Holds if this expression statement has semicolon.
     */
    predicate hasSemicolon() { expr_stmt_has_semicolon(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A field access expression. For example:
   * ```rust
   * x.foo
   * ```
   */
  class FieldExpr extends @field_expr, Expr {
    override string toString() { result = "FieldExpr" }

    /**
     * Gets the expression of this field expression.
     */
    Expr getExpr() { field_exprs(this, result, _) }

    /**
     * Gets the name of this field expression.
     */
    string getName() { field_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A function declaration. For example
   * ```rust
   * fn foo(x: u32) -> u64 {(x + 1).into()}
   * ```
   * A function declaration within a trait might not have a body:
   * ```rust
   * trait Trait {
   *     fn bar();
   * }
   * ```
   */
  class Function extends @function, Declaration {
    override string toString() { result = "Function" }

    /**
     * Gets the name of this function.
     */
    string getName() { functions(this, result, _) }

    /**
     * Gets the body of this function.
     */
    Expr getBody() { functions(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A binding pattern. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * };
   * ```
   * ```rust
   * match x {
   *     y@Option::Some(_) => y,
   *     Option::None => 0,
   * };
   * ```
   */
  class IdentPat extends @ident_pat, Pat {
    override string toString() { result = "IdentPat" }

    /**
     * Gets the binding of this ident pat.
     */
    string getBindingId() { ident_pats(this, result) }

    /**
     * Gets the subpat of this ident pat, if it exists.
     */
    Pat getSubpat() { ident_pat_subpats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An `if` expression. For example:
   * ```rust
   * if x == 42 {
   *     println!("that's the answer");
   * }
   * ```
   * ```rust
   * let y = if x > 0 {
   *     1
   * } else {
   *     0
   * }
   * ```
   */
  class IfExpr extends @if_expr, Expr {
    override string toString() { result = "IfExpr" }

    /**
     * Gets the condition of this if expression.
     */
    Expr getCondition() { if_exprs(this, result, _) }

    /**
     * Gets the then of this if expression.
     */
    Expr getThen() { if_exprs(this, _, result) }

    /**
     * Gets the else of this if expression, if it exists.
     */
    Expr getElse() { if_expr_elses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An index expression. For example:
   * ```rust
   * list[42];
   * list[42] = 1;
   * ```
   */
  class IndexExpr extends @index_expr, Expr {
    override string toString() { result = "IndexExpr" }

    /**
     * Gets the base of this index expression.
     */
    Expr getBase() { index_exprs(this, result, _) }

    /**
     * Gets the index of this index expression.
     */
    Expr getIndex() { index_exprs(this, _, result) }

    /**
     * Holds if this index expression is assignee expression.
     */
    predicate isAssigneeExpr() { index_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   * An item statement. For example:
   * ```rust
   * fn print_hello() {
   *     println!("Hello, world!");
   * }
   * print_hello();
   * ```
   */
  class ItemStmt extends @item_stmt, Stmt {
    override string toString() { result = "ItemStmt" }
  }

  /**
   * INTERNAL: Do not use.
   * A `let` expression. For example:
   * ```rust
   * if let Some(x) = maybe_some {
   *     println!("{}", x);
   * }
   * ```
   */
  class LetExpr extends @let_expr, Expr {
    override string toString() { result = "LetExpr" }

    /**
     * Gets the pat of this let expression.
     */
    Pat getPat() { let_exprs(this, result, _) }

    /**
     * Gets the expression of this let expression.
     */
    Expr getExpr() { let_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A let statement. For example:
   * ```rust
   * let x = 42;
   * let x: i32 = 42;
   * let x: i32;
   * let x;
   * let (x, y) = (1, 2);
   * let Some(x) = std::env::var("FOO") else {
   *     return;
   * };
   * ```
   */
  class LetStmt extends @let_stmt, Stmt {
    override string toString() { result = "LetStmt" }

    /**
     * Gets the pat of this let statement.
     */
    Pat getPat() { let_stmts(this, result) }

    /**
     * Gets the type of this let statement, if it exists.
     */
    TypeRef getType() { let_stmt_types(this, result) }

    /**
     * Gets the initializer of this let statement, if it exists.
     */
    Expr getInitializer() { let_stmt_initializers(this, result) }

    /**
     * Gets the else of this let statement, if it exists.
     */
    Expr getElse() { let_stmt_elses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A literal expression. For example:
   * ```rust
   * 42;
   * 42.0;
   * "Hello, world!";
   * b"Hello, world!";
   * 'x';
   * b'x';
   * r"Hello, world!";
   * true;
   * ```
   */
  class LiteralExpr extends @literal_expr, Expr {
    override string toString() { result = "LiteralExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * A literal pattern. For example:
   * ```rust
   * match x {
   *     42 => "ok",
   *     _ => "fail",
   * }
   * ```
   */
  class LiteralPat extends @literal_pat, Pat {
    override string toString() { result = "LiteralPat" }

    /**
     * Gets the expression of this literal pat.
     */
    Expr getExpr() { literal_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A loop expression. For example:
   * ```rust
   * loop {
   *     println!("Hello, world (again)!");
   * };
   * ```
   * ```rust
   * 'label: loop {
   *     println!("Hello, world (once)!");
   *     break 'label;
   * };
   * ```
   * ```rust
   * let mut x = 0;
   * loop {
   *     if x < 10 {
   *         x += 1;
   *     } else {
   *         break;
   *     }
   * };
   * ```
   */
  class LoopExpr extends @loop_expr, Expr {
    override string toString() { result = "LoopExpr" }

    /**
     * Gets the body of this loop expression.
     */
    Expr getBody() { loop_exprs(this, result) }

    /**
     * Gets the label of this loop expression, if it exists.
     */
    Label getLabel() { loop_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A match expression. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * }
   * ```
   * ```rust
   * match x {
   *     Some(y) if y != 0 => 1 / y,
   *     _ => 0,
   * }
   * ```
   */
  class MatchExpr extends @match_expr, Expr {
    override string toString() { result = "MatchExpr" }

    /**
     * Gets the expression of this match expression.
     */
    Expr getExpr() { match_exprs(this, result) }

    /**
     * Gets the `index`th branch of this match expression (0-based).
     */
    MatchArm getBranch(int index) { match_expr_branches(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A method call expression. For example:
   * ```rust
   * x.foo(42);
   * x.foo::<u32, u64>(42);
   * ```
   */
  class MethodCallExpr extends @method_call_expr, Expr {
    override string toString() { result = "MethodCallExpr" }

    /**
     * Gets the receiver of this method call expression.
     */
    Expr getReceiver() { method_call_exprs(this, result, _) }

    /**
     * Gets the method name of this method call expression.
     */
    string getMethodName() { method_call_exprs(this, _, result) }

    /**
     * Gets the `index`th argument of this method call expression (0-based).
     */
    Expr getArg(int index) { method_call_expr_args(this, index, result) }

    /**
     * Gets the generic arguments of this method call expression, if it exists.
     */
    GenericArgList getGenericArgs() { method_call_expr_generic_args(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A missing expression, used as a placeholder for incomplete syntax.
   *
   * ```rust
   * let x = non_existing_macro!();
   * ```
   */
  class MissingExpr extends @missing_expr, Expr, Missing {
    override string toString() { result = "MissingExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * A missing pattern, used as a place holder for incomplete syntax.
   * ```rust
   * match Some(42) {
   *     .. => "bad use of .. syntax",
   * };
   * ```
   */
  class MissingPat extends @missing_pat, Pat, Missing {
    override string toString() { result = "MissingPat" }
  }

  /**
   * INTERNAL: Do not use.
   * A module declaration. For example:
   * ```rust
   * mod foo;
   * ```
   * ```rust
   * mod bar {
   *     pub fn baz() {}
   * }
   * ```
   */
  class Module extends @module, Declaration {
    override string toString() { result = "Module" }

    /**
     * Gets the `index`th declaration of this module (0-based).
     */
    Declaration getDeclaration(int index) { module_declarations(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   *  An `offset_of` expression. For example:
   * ```rust
   * builtin # offset_of(Struct, field);
   * ```
   */
  class OffsetOfExpr extends @offset_of_expr, Expr {
    override string toString() { result = "OffsetOfExpr" }

    /**
     * Gets the container of this offset of expression.
     */
    TypeRef getContainer() { offset_of_exprs(this, result) }

    /**
     * Gets the `index`th field of this offset of expression (0-based).
     */
    string getField(int index) { offset_of_expr_fields(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An or pattern. For example:
   * ```rust
   * match x {
   *     Option::Some(y) | Option::None => 0,
   * }
   * ```
   */
  class OrPat extends @or_pat, Pat {
    override string toString() { result = "OrPat" }

    /**
     * Gets the `index`th argument of this or pat (0-based).
     */
    Pat getArg(int index) { or_pat_args(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A path expression. For example:
   * ```rust
   * let x = variable;
   * let x = foo::bar;
   * let y = <T>::foo;
   * let z = <TypeRef as Trait>::foo;
   * ```
   */
  class PathExpr extends @path_expr, Expr {
    override string toString() { result = "PathExpr" }

    /**
     * Gets the path of this path expression.
     */
    Path getPath() { path_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A path pattern. For example:
   * ```rust
   * match x {
   *     Foo::Bar => "ok",
   *     _ => "fail",
   * }
   * ```
   */
  class PathPat extends @path_pat, Pat {
    override string toString() { result = "PathPat" }

    /**
     * Gets the path of this path pat.
     */
    Path getPath() { path_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A unary operation expression. For example:
   * ```rust
   * let x = -42
   * let y = !true
   * let z = *ptr
   * ```
   */
  class PrefixExpr extends @prefix_expr, Expr {
    override string toString() { result = "PrefixExpr" }

    /**
     * Gets the expression of this prefix expression.
     */
    Expr getExpr() { prefix_exprs(this, result, _) }

    /**
     * Gets the op of this prefix expression.
     */
    string getOp() { prefix_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A range expression. For example:
   * ```rust
   * let x = 1..=10;
   * let x = 1..10;
   * let x = 10..;
   * let x = ..10;
   * let x = ..=10;
   * let x = ..;
   * ```
   */
  class RangeExpr extends @range_expr, Expr {
    override string toString() { result = "RangeExpr" }

    /**
     * Gets the lhs of this range expression, if it exists.
     */
    Expr getLhs() { range_expr_lhs(this, result) }

    /**
     * Gets the rhs of this range expression, if it exists.
     */
    Expr getRhs() { range_expr_rhs(this, result) }

    /**
     * Holds if this range expression is inclusive.
     */
    predicate isInclusive() { range_expr_is_inclusive(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A range pattern. For example:
   * ```rust
   * match x {
   *     ..15 => "too cold",
   *     16..=25 => "just right",
   *     26.. => "too hot",
   * }
   * ```
   */
  class RangePat extends @range_pat, Pat {
    override string toString() { result = "RangePat" }

    /**
     * Gets the start of this range pat, if it exists.
     */
    Pat getStart() { range_pat_starts(this, result) }

    /**
     * Gets the end of this range pat, if it exists.
     */
    Pat getEnd() { range_pat_ends(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A record expression. For example:
   * ```rust
   * let first = Foo { a: 1, b: 2 };
   * let second = Foo { a: 2, ..first };
   * Foo { a: 1, b: 2 }[2] = 10;
   * Foo { .. } = second;
   * ```
   */
  class RecordExpr extends @record_expr, Expr {
    override string toString() { result = "RecordExpr" }

    /**
     * Gets the path of this record expression, if it exists.
     */
    Path getPath() { record_expr_paths(this, result) }

    /**
     * Gets the `index`th fld of this record expression (0-based).
     */
    RecordExprField getFld(int index) { record_expr_flds(this, index, result) }

    /**
     * Gets the spread of this record expression, if it exists.
     */
    Expr getSpread() { record_expr_spreads(this, result) }

    /**
     * Holds if this record expression has ellipsis.
     */
    predicate hasEllipsis() { record_expr_has_ellipsis(this) }

    /**
     * Holds if this record expression is assignee expression.
     */
    predicate isAssigneeExpr() { record_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A record pattern. For example:
   * ```rust
   * match x {
   *     Foo { a: 1, b: 2 } => "ok",
   *     Foo { .. } => "fail",
   * }
   * ```
   */
  class RecordPat extends @record_pat, Pat {
    override string toString() { result = "RecordPat" }

    /**
     * Gets the path of this record pat, if it exists.
     */
    Path getPath() { record_pat_paths(this, result) }

    /**
     * Gets the `index`th fld of this record pat (0-based).
     */
    RecordPatField getFld(int index) { record_pat_flds(this, index, result) }

    /**
     * Holds if this record pat has ellipsis.
     */
    predicate hasEllipsis() { record_pat_has_ellipsis(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A reference expression. For example:
   * ```rust
   *     let ref_const = &foo;
   *     let ref_mut = &mut foo;
   *     let raw_const: &mut i32 = &raw const foo;
   *     let raw_mut: &mut i32 = &raw mut foo;
   * ```
   */
  class RefExpr extends @ref_expr, Expr {
    override string toString() { result = "RefExpr" }

    /**
     * Gets the expression of this reference expression.
     */
    Expr getExpr() { ref_exprs(this, result) }

    /**
     * Holds if this reference expression is raw.
     */
    predicate isRaw() { ref_expr_is_raw(this) }

    /**
     * Holds if this reference expression is mut.
     */
    predicate isMut() { ref_expr_is_mut(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A reference pattern. For example:
   * ```rust
   * match x {
   *     &mut Option::Some(y) => y,
   *     &Option::None => 0,
   * };
   * ```
   */
  class RefPat extends @ref_pat, Pat {
    override string toString() { result = "RefPat" }

    /**
     * Gets the pat of this reference pat.
     */
    Pat getPat() { ref_pats(this, result) }

    /**
     * Holds if this reference pat is mut.
     */
    predicate isMut() { ref_pat_is_mut(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A return expression. For example:
   * ```rust
   * fn some_value() -> i32 {
   *     return 42;
   * }
   * ```
   * ```rust
   * fn no_value() -> () {
   *     return;
   * }
   * ```
   */
  class ReturnExpr extends @return_expr, Expr {
    override string toString() { result = "ReturnExpr" }

    /**
     * Gets the expression of this return expression, if it exists.
     */
    Expr getExpr() { return_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A slice pattern. For example:
   * ```rust
   * match x {
   *     [1, 2, 3, 4, 5] => "ok",
   *     [1, 2, ..] => "fail",
   *     [x, y, .., z, 7] => "fail",
   * }
   * ```
   */
  class SlicePat extends @slice_pat, Pat {
    override string toString() { result = "SlicePat" }

    /**
     * Gets the `index`th prefix of this slice pat (0-based).
     */
    Pat getPrefix(int index) { slice_pat_prefixes(this, index, result) }

    /**
     * Gets the slice of this slice pat, if it exists.
     */
    Pat getSlice() { slice_pat_slice(this, result) }

    /**
     * Gets the `index`th suffix of this slice pat (0-based).
     */
    Pat getSuffix(int index) { slice_pat_suffixes(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A tuple expression. For example:
   * ```rust
   * (1, "one");
   * (2, "two")[0] = 3;
   * ```
   */
  class TupleExpr extends @tuple_expr, Expr {
    override string toString() { result = "TupleExpr" }

    /**
     * Gets the `index`th expression of this tuple expression (0-based).
     */
    Expr getExpr(int index) { tuple_expr_exprs(this, index, result) }

    /**
     * Holds if this tuple expression is assignee expression.
     */
    predicate isAssigneeExpr() { tuple_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A tuple pattern. For example:
   * ```rust
   * let (x, y) = (1, 2);
   * let (a, b, ..,  z) = (1, 2, 3, 4, 5);
   * ```
   */
  class TuplePat extends @tuple_pat, Pat {
    override string toString() { result = "TuplePat" }

    /**
     * Gets the `index`th argument of this tuple pat (0-based).
     */
    Pat getArg(int index) { tuple_pat_args(this, index, result) }

    /**
     * Gets the ellipsis index of this tuple pat, if it exists.
     */
    int getEllipsisIndex() { tuple_pat_ellipsis_indices(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A tuple struct pattern. For example:
   * ```rust
   * match x {
   *     Tuple("a", 1, 2, 3) => "great",
   *     Tuple(.., 3) => "fine",
   *     Tuple(..) => "fail",
   * };
   * ```
   */
  class TupleStructPat extends @tuple_struct_pat, Pat {
    override string toString() { result = "TupleStructPat" }

    /**
     * Gets the path of this tuple struct pat, if it exists.
     */
    Path getPath() { tuple_struct_pat_paths(this, result) }

    /**
     * Gets the `index`th argument of this tuple struct pat (0-based).
     */
    Pat getArg(int index) { tuple_struct_pat_args(this, index, result) }

    /**
     * Gets the ellipsis index of this tuple struct pat, if it exists.
     */
    int getEllipsisIndex() { tuple_struct_pat_ellipsis_indices(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An underscore expression. For example:
   * ```rust
   * _ = 42;
   * ```
   */
  class UnderscoreExpr extends @underscore_expr, Expr {
    override string toString() { result = "UnderscoreExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * A declaration that is not yet extracted.
   */
  class UnimplementedDeclaration extends @unimplemented_declaration, Declaration, Unimplemented {
    override string toString() { result = "UnimplementedDeclaration" }
  }

  /**
   * INTERNAL: Do not use.
   * A wildcard pattern. For example:
   * ```rust
   * let _ = 42;
   * ```
   */
  class WildcardPat extends @wildcard_pat, Pat {
    override string toString() { result = "WildcardPat" }
  }

  /**
   * INTERNAL: Do not use.
   * A `yeet` expression. For example:
   * ```rust
   * if x < size {
   *    do yeet "index out of bounds";
   * }
   * ```
   */
  class YeetExpr extends @yeet_expr, Expr {
    override string toString() { result = "YeetExpr" }

    /**
     * Gets the expression of this yeet expression, if it exists.
     */
    Expr getExpr() { yeet_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A `yield` expression. For example:
   * ```rust
   * let one = #[coroutine]
   *     || {
   *         yield 1;
   *     };
   * ```
   */
  class YieldExpr extends @yield_expr, Expr {
    override string toString() { result = "YieldExpr" }

    /**
     * Gets the expression of this yield expression, if it exists.
     */
    Expr getExpr() { yield_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An async block expression. For example:
   * ```rust
   * async {
   *    let x = 42;
   *    x
   * }.await
   * ```
   */
  class AsyncBlockExpr extends @async_block_expr, BlockExprBase {
    override string toString() { result = "AsyncBlockExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * A block expression. For example:
   * ```rust
   * {
   *     let x = 42;
   * }
   * ```
   * ```rust
   * 'label: {
   *     let x = 42;
   *     x
   * }
   * ```
   */
  class BlockExpr extends @block_expr, BlockExprBase {
    override string toString() { result = "BlockExpr" }

    /**
     * Gets the label of this block expression, if it exists.
     */
    Label getLabel() { block_expr_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An element list expression. For example:
   * ```rust
   * [1, 2, 3, 4, 5];
   * [1, 2, 3, 4, 5][0] = 6;
   * ```
   */
  class ElementListExpr extends @element_list_expr, ArrayExpr {
    override string toString() { result = "ElementListExpr" }

    /**
     * Gets the `index`th element of this element list expression (0-based).
     */
    Expr getElement(int index) { element_list_expr_elements(this, index, result) }

    /**
     * Holds if this element list expression is assignee expression.
     */
    predicate isAssigneeExpr() { element_list_expr_is_assignee_expr(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A repeat expression. For example:
   * ```rust
   * [1; 10];
   * ```
   */
  class RepeatExpr extends @repeat_expr, ArrayExpr {
    override string toString() { result = "RepeatExpr" }

    /**
     * Gets the initializer of this repeat expression.
     */
    Expr getInitializer() { repeat_exprs(this, result, _) }

    /**
     * Gets the repeat of this repeat expression.
     */
    Expr getRepeat() { repeat_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An unsafe block expression. For example:
   * ```rust
   * let layout = unsafe {
   *     let x = 42;
   *     Layout::from_size_align_unchecked(size, align)
   * };
   * ```
   */
  class UnsafeBlockExpr extends @unsafe_block_expr, BlockExprBase {
    override string toString() { result = "UnsafeBlockExpr" }
  }
}
