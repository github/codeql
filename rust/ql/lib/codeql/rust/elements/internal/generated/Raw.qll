/**
 * INTERNAL: Do not use.
 * This module holds thin fully generated class definitions around DB entities.
 */
module Raw {
  private import codeql.files.FileSystem

  /**
   * INTERNAL: Do not use.
   */
  class Element extends @element {
    string toString() { none() }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExtractorStep extends @extractor_step, Element {
    override string toString() { result = "ExtractorStep" }

    /**
     * Gets the action of this extractor step.
     */
    string getAction() { extractor_steps(this, result, _) }

    /**
     * Gets the file of this extractor step, if it exists.
     */
    File getFile() { extractor_step_files(this, result) }

    /**
     * Gets the duration ms of this extractor step.
     */
    int getDurationMs() { extractor_steps(this, _, result) }
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
  class Missing extends @missing, Unextracted {
    override string toString() { result = "Missing" }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for unimplemented nodes. This is used to mark nodes that are not yet extracted.
   */
  class Unimplemented extends @unimplemented, Unextracted {
    override string toString() { result = "Unimplemented" }
  }

  /**
   * INTERNAL: Do not use.
   * A Abi. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Abi extends @abi, AstNode {
    override string toString() { result = "Abi" }

    /**
     * Gets the abi string of this abi, if it exists.
     */
    string getAbiString() { abi_abi_strings(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * Something that can be addressed by a path.
   *
   * TODO: This does not yet include all possible cases.
   */
  class Addressable extends @addressable, AstNode {
    /**
     * Gets the extended canonical path of this addressable, if it exists.
     *
     * Either a canonical path (see https://doc.rust-lang.org/reference/paths.html#canonical-paths),
     * or `{<block id>}::name` for addressable items defined in an anonymous block (and only
     * addressable there-in).
     */
    string getExtendedCanonicalPath() { addressable_extended_canonical_paths(this, result) }

    /**
     * Gets the crate origin of this addressable, if it exists.
     *
     * One of `rustc:<name>`, `repo:<repository>:<name>` or `lang:<name>`.
     */
    string getCrateOrigin() { addressable_crate_origins(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ArgList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ArgList extends @arg_list, AstNode {
    override string toString() { result = "ArgList" }

    /**
     * Gets the `index`th argument of this argument list (0-based).
     */
    Expr getArg(int index) { arg_list_args(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmDirSpec extends @asm_dir_spec, AstNode {
    override string toString() { result = "AsmDirSpec" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmOperand extends @asm_operand, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class AsmOperandExpr extends @asm_operand_expr, AstNode {
    override string toString() { result = "AsmOperandExpr" }

    /**
     * Gets the in expression of this asm operand expression, if it exists.
     */
    Expr getInExpr() { asm_operand_expr_in_exprs(this, result) }

    /**
     * Gets the out expression of this asm operand expression, if it exists.
     */
    Expr getOutExpr() { asm_operand_expr_out_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmOption extends @asm_option, AstNode {
    override string toString() { result = "AsmOption" }

    /**
     * Holds if this asm option is raw.
     */
    predicate isRaw() { asm_option_is_raw(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmPiece extends @asm_piece, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class AsmRegSpec extends @asm_reg_spec, AstNode {
    override string toString() { result = "AsmRegSpec" }

    /**
     * Gets the name reference of this asm reg spec, if it exists.
     */
    NameRef getNameRef() { asm_reg_spec_name_refs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A AssocItem. For example:
   * ```rust
   * todo!()
   * ```
   */
  class AssocItem extends @assoc_item, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A list of  `AssocItem` elements, as appearing for example in a `Trait`.
   */
  class AssocItemList extends @assoc_item_list, AstNode {
    override string toString() { result = "AssocItemList" }

    /**
     * Gets the `index`th assoc item of this assoc item list (0-based).
     */
    AssocItem getAssocItem(int index) { assoc_item_list_assoc_items(this, index, result) }

    /**
     * Gets the `index`th attr of this assoc item list (0-based).
     */
    Attr getAttr(int index) { assoc_item_list_attrs(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Attr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Attr extends @attr, AstNode {
    override string toString() { result = "Attr" }

    /**
     * Gets the meta of this attr, if it exists.
     */
    Meta getMeta() { attr_meta(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A callable. Either a `Function` or a `ClosureExpr`.
   */
  class Callable extends @callable, AstNode {
    /**
     * Gets the parameter list of this callable, if it exists.
     */
    ParamList getParamList() { callable_param_lists(this, result) }

    /**
     * Gets the `index`th attr of this callable (0-based).
     */
    Attr getAttr(int index) { callable_attrs(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ClosureBinder. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ClosureBinder extends @closure_binder, AstNode {
    override string toString() { result = "ClosureBinder" }

    /**
     * Gets the generic parameter list of this closure binder, if it exists.
     */
    GenericParamList getGenericParamList() { closure_binder_generic_param_lists(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for expressions.
   */
  class Expr extends @expr, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A ExternItem. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ExternItem extends @extern_item, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A ExternItemList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ExternItemList extends @extern_item_list, AstNode {
    override string toString() { result = "ExternItemList" }

    /**
     * Gets the `index`th attr of this extern item list (0-based).
     */
    Attr getAttr(int index) { extern_item_list_attrs(this, index, result) }

    /**
     * Gets the `index`th extern item of this extern item list (0-based).
     */
    ExternItem getExternItem(int index) { extern_item_list_extern_items(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A FieldList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class FieldList extends @field_list, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A FormatArgsArg. For example the `"world"` in:
   * ```rust
   * format_args!("Hello, {}!", "world")
   * ```
   */
  class FormatArgsArg extends @format_args_arg, AstNode {
    override string toString() { result = "FormatArgsArg" }

    /**
     * Gets the expression of this format arguments argument, if it exists.
     */
    Expr getExpr() { format_args_arg_exprs(this, result) }

    /**
     * Gets the name of this format arguments argument, if it exists.
     */
    Name getName() { format_args_arg_names(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A GenericArg. For example:
   * ```rust
   * todo!()
   * ```
   */
  class GenericArg extends @generic_arg, AstNode { }

  /**
   * INTERNAL: Do not use.
   * The base class for generic arguments.
   * ```rust
   * x.foo::<u32, u64>(42);
   * ```
   */
  class GenericArgList extends @generic_arg_list, AstNode {
    override string toString() { result = "GenericArgList" }

    /**
     * Gets the `index`th generic argument of this generic argument list (0-based).
     */
    GenericArg getGenericArg(int index) { generic_arg_list_generic_args(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A GenericParam. For example:
   * ```rust
   * todo!()
   * ```
   */
  class GenericParam extends @generic_param, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A GenericParamList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class GenericParamList extends @generic_param_list, AstNode {
    override string toString() { result = "GenericParamList" }

    /**
     * Gets the `index`th generic parameter of this generic parameter list (0-based).
     */
    GenericParam getGenericParam(int index) {
      generic_param_list_generic_params(this, index, result)
    }
  }

  /**
   * INTERNAL: Do not use.
   * A ItemList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ItemList extends @item_list, AstNode {
    override string toString() { result = "ItemList" }

    /**
     * Gets the `index`th attr of this item list (0-based).
     */
    Attr getAttr(int index) { item_list_attrs(this, index, result) }

    /**
     * Gets the `index`th item of this item list (0-based).
     */
    Item getItem(int index) { item_list_items(this, index, result) }
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
     * Gets the lifetime of this label, if it exists.
     */
    Lifetime getLifetime() { label_lifetimes(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A LetElse. For example:
   * ```rust
   * todo!()
   * ```
   */
  class LetElse extends @let_else, AstNode {
    override string toString() { result = "LetElse" }

    /**
     * Gets the block expression of this let else, if it exists.
     */
    BlockExpr getBlockExpr() { let_else_block_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A sequence of items generated by a `MacroCall`. For example:
   * ```rust
   * mod foo{
   *     include!("common_definitions.rs");
   * }
   * ```
   */
  class MacroItems extends @macro_items, AstNode {
    override string toString() { result = "MacroItems" }

    /**
     * Gets the `index`th item of this macro items (0-based).
     */
    Item getItem(int index) { macro_items_items(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A sequence of statements generated by a `MacroCall`. For example:
   * ```rust
   * fn main() {
   *     println!("Hello, world!"); // This macro expands into a list of statements
   * }
   * ```
   */
  class MacroStmts extends @macro_stmts, AstNode {
    override string toString() { result = "MacroStmts" }

    /**
     * Gets the expression of this macro statements, if it exists.
     */
    Expr getExpr() { macro_stmts_exprs(this, result) }

    /**
     * Gets the `index`th statement of this macro statements (0-based).
     */
    Stmt getStatement(int index) { macro_stmts_statements(this, index, result) }
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
     * Gets the `index`th attr of this match arm (0-based).
     */
    Attr getAttr(int index) { match_arm_attrs(this, index, result) }

    /**
     * Gets the expression of this match arm, if it exists.
     */
    Expr getExpr() { match_arm_exprs(this, result) }

    /**
     * Gets the guard of this match arm, if it exists.
     */
    MatchGuard getGuard() { match_arm_guards(this, result) }

    /**
     * Gets the pattern of this match arm, if it exists.
     */
    Pat getPat() { match_arm_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MatchArmList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MatchArmList extends @match_arm_list, AstNode {
    override string toString() { result = "MatchArmList" }

    /**
     * Gets the `index`th arm of this match arm list (0-based).
     */
    MatchArm getArm(int index) { match_arm_list_arms(this, index, result) }

    /**
     * Gets the `index`th attr of this match arm list (0-based).
     */
    Attr getAttr(int index) { match_arm_list_attrs(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MatchGuard. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MatchGuard extends @match_guard, AstNode {
    override string toString() { result = "MatchGuard" }

    /**
     * Gets the condition of this match guard, if it exists.
     */
    Expr getCondition() { match_guard_conditions(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Meta. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Meta extends @meta, AstNode {
    override string toString() { result = "Meta" }

    /**
     * Gets the expression of this meta, if it exists.
     */
    Expr getExpr() { meta_exprs(this, result) }

    /**
     * Holds if this meta is unsafe.
     */
    predicate isUnsafe() { meta_is_unsafe(this) }

    /**
     * Gets the path of this meta, if it exists.
     */
    Path getPath() { meta_paths(this, result) }

    /**
     * Gets the token tree of this meta, if it exists.
     */
    TokenTree getTokenTree() { meta_token_trees(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Name. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Name extends @name, AstNode {
    override string toString() { result = "Name" }

    /**
     * Gets the text of this name, if it exists.
     */
    string getText() { name_texts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A normal parameter, `Param`, or a self parameter `SelfParam`.
   */
  class ParamBase extends @param_base, AstNode {
    /**
     * Gets the `index`th attr of this parameter base (0-based).
     */
    Attr getAttr(int index) { param_base_attrs(this, index, result) }

    /**
     * Gets the type representation of this parameter base, if it exists.
     */
    TypeRepr getTypeRepr() { param_base_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ParamList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParamList extends @param_list, AstNode {
    override string toString() { result = "ParamList" }

    /**
     * Gets the `index`th parameter of this parameter list (0-based).
     */
    Param getParam(int index) { param_list_params(this, index, result) }

    /**
     * Gets the self parameter of this parameter list, if it exists.
     */
    SelfParam getSelfParam() { param_list_self_params(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ParenthesizedArgList extends @parenthesized_arg_list, AstNode {
    override string toString() { result = "ParenthesizedArgList" }

    /**
     * Gets the `index`th type argument of this parenthesized argument list (0-based).
     */
    TypeArg getTypeArg(int index) { parenthesized_arg_list_type_args(this, index, result) }
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
   * use some_crate::some_module::some_item;
   * foo::bar;
   * ```
   */
  class Path extends @path, AstNode {
    override string toString() { result = "Path" }

    /**
     * Gets the qualifier of this path, if it exists.
     */
    Path getQualifier() { path_qualifiers(this, result) }

    /**
     * Gets the part of this path, if it exists.
     */
    PathSegment getPart() { path_parts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A path segment, which is one part of a whole path.
   */
  class PathSegment extends @path_segment, AstNode {
    override string toString() { result = "PathSegment" }

    /**
     * Gets the generic argument list of this path segment, if it exists.
     */
    GenericArgList getGenericArgList() { path_segment_generic_arg_lists(this, result) }

    /**
     * Gets the name reference of this path segment, if it exists.
     */
    NameRef getNameRef() { path_segment_name_refs(this, result) }

    /**
     * Gets the parenthesized argument list of this path segment, if it exists.
     */
    ParenthesizedArgList getParenthesizedArgList() {
      path_segment_parenthesized_arg_lists(this, result)
    }

    /**
     * Gets the path type of this path segment, if it exists.
     */
    PathTypeRepr getPathType() { path_segment_path_types(this, result) }

    /**
     * Gets the ret type of this path segment, if it exists.
     */
    RetTypeRepr getRetType() { path_segment_ret_types(this, result) }

    /**
     * Gets the return type syntax of this path segment, if it exists.
     */
    ReturnTypeSyntax getReturnTypeSyntax() { path_segment_return_type_syntaxes(this, result) }

    /**
     * Gets the type representation of this path segment, if it exists.
     */
    TypeRepr getTypeRepr() { path_segment_type_reprs(this, result) }
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
     * Gets the `index`th attr of this record expression field (0-based).
     */
    Attr getAttr(int index) { record_expr_field_attrs(this, index, result) }

    /**
     * Gets the expression of this record expression field, if it exists.
     */
    Expr getExpr() { record_expr_field_exprs(this, result) }

    /**
     * Gets the name reference of this record expression field, if it exists.
     */
    NameRef getNameRef() { record_expr_field_name_refs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RecordExprFieldList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RecordExprFieldList extends @record_expr_field_list, AstNode {
    override string toString() { result = "RecordExprFieldList" }

    /**
     * Gets the `index`th attr of this record expression field list (0-based).
     */
    Attr getAttr(int index) { record_expr_field_list_attrs(this, index, result) }

    /**
     * Gets the `index`th field of this record expression field list (0-based).
     */
    RecordExprField getField(int index) { record_expr_field_list_fields(this, index, result) }

    /**
     * Gets the spread of this record expression field list, if it exists.
     */
    Expr getSpread() { record_expr_field_list_spreads(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RecordField. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RecordField extends @record_field, AstNode {
    override string toString() { result = "RecordField" }

    /**
     * Gets the `index`th attr of this record field (0-based).
     */
    Attr getAttr(int index) { record_field_attrs(this, index, result) }

    /**
     * Gets the name of this record field, if it exists.
     */
    Name getName() { record_field_names(this, result) }

    /**
     * Gets the type representation of this record field, if it exists.
     */
    TypeRepr getTypeRepr() { record_field_type_reprs(this, result) }

    /**
     * Gets the visibility of this record field, if it exists.
     */
    Visibility getVisibility() { record_field_visibilities(this, result) }
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
     * Gets the `index`th attr of this record pattern field (0-based).
     */
    Attr getAttr(int index) { record_pat_field_attrs(this, index, result) }

    /**
     * Gets the name reference of this record pattern field, if it exists.
     */
    NameRef getNameRef() { record_pat_field_name_refs(this, result) }

    /**
     * Gets the pattern of this record pattern field, if it exists.
     */
    Pat getPat() { record_pat_field_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RecordPatFieldList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RecordPatFieldList extends @record_pat_field_list, AstNode {
    override string toString() { result = "RecordPatFieldList" }

    /**
     * Gets the `index`th field of this record pattern field list (0-based).
     */
    RecordPatField getField(int index) { record_pat_field_list_fields(this, index, result) }

    /**
     * Gets the rest pattern of this record pattern field list, if it exists.
     */
    RestPat getRestPat() { record_pat_field_list_rest_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Rename. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Rename extends @rename, AstNode {
    override string toString() { result = "Rename" }

    /**
     * Gets the name of this rename, if it exists.
     */
    Name getName() { rename_names(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * One of `PathExpr`, `RecordExpr`, `PathPat`, `RecordPat`, `TupleStructPat` or `MethodCallExpr`.
   */
  class Resolvable extends @resolvable, AstNode {
    /**
     * Gets the resolved path of this resolvable, if it exists.
     */
    string getResolvedPath() { resolvable_resolved_paths(this, result) }

    /**
     * Gets the resolved crate origin of this resolvable, if it exists.
     */
    string getResolvedCrateOrigin() { resolvable_resolved_crate_origins(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RetTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RetTypeRepr extends @ret_type_repr, AstNode {
    override string toString() { result = "RetTypeRepr" }

    /**
     * Gets the type representation of this ret type representation, if it exists.
     */
    TypeRepr getTypeRepr() { ret_type_repr_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ReturnTypeSyntax. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ReturnTypeSyntax extends @return_type_syntax, AstNode {
    override string toString() { result = "ReturnTypeSyntax" }
  }

  /**
   * INTERNAL: Do not use.
   * A SourceFile. For example:
   * ```rust
   * todo!()
   * ```
   */
  class SourceFile extends @source_file, AstNode {
    override string toString() { result = "SourceFile" }

    /**
     * Gets the `index`th attr of this source file (0-based).
     */
    Attr getAttr(int index) { source_file_attrs(this, index, result) }

    /**
     * Gets the `index`th item of this source file (0-based).
     */
    Item getItem(int index) { source_file_items(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for statements.
   */
  class Stmt extends @stmt, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A StmtList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class StmtList extends @stmt_list, AstNode {
    override string toString() { result = "StmtList" }

    /**
     * Gets the `index`th attr of this statement list (0-based).
     */
    Attr getAttr(int index) { stmt_list_attrs(this, index, result) }

    /**
     * Gets the `index`th statement of this statement list (0-based).
     */
    Stmt getStatement(int index) { stmt_list_statements(this, index, result) }

    /**
     * Gets the tail expression of this statement list, if it exists.
     */
    Expr getTailExpr() { stmt_list_tail_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for all tokens.
   */
  class Token extends @token, AstNode { }

  /**
   * INTERNAL: Do not use.
   * A TokenTree. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TokenTree extends @token_tree, AstNode {
    override string toString() { result = "TokenTree" }
  }

  /**
   * INTERNAL: Do not use.
   * A TupleField. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TupleField extends @tuple_field, AstNode {
    override string toString() { result = "TupleField" }

    /**
     * Gets the `index`th attr of this tuple field (0-based).
     */
    Attr getAttr(int index) { tuple_field_attrs(this, index, result) }

    /**
     * Gets the type representation of this tuple field, if it exists.
     */
    TypeRepr getTypeRepr() { tuple_field_type_reprs(this, result) }

    /**
     * Gets the visibility of this tuple field, if it exists.
     */
    Visibility getVisibility() { tuple_field_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TypeBound. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TypeBound extends @type_bound, AstNode {
    override string toString() { result = "TypeBound" }

    /**
     * Holds if this type bound is async.
     */
    predicate isAsync() { type_bound_is_async(this) }

    /**
     * Holds if this type bound is const.
     */
    predicate isConst() { type_bound_is_const(this) }

    /**
     * Gets the lifetime of this type bound, if it exists.
     */
    Lifetime getLifetime() { type_bound_lifetimes(this, result) }

    /**
     * Gets the type representation of this type bound, if it exists.
     */
    TypeRepr getTypeRepr() { type_bound_type_reprs(this, result) }

    /**
     * Gets the use bound generic arguments of this type bound, if it exists.
     */
    UseBoundGenericArgs getUseBoundGenericArgs() { type_bound_use_bound_generic_args(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TypeBoundList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TypeBoundList extends @type_bound_list, AstNode {
    override string toString() { result = "TypeBoundList" }

    /**
     * Gets the `index`th bound of this type bound list (0-based).
     */
    TypeBound getBound(int index) { type_bound_list_bounds(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for type references.
   * ```rust
   * let x: i32;
   * let y: Vec<i32>;
   * let z: Option<i32>;
   * ```
   */
  class TypeRepr extends @type_repr, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class UseBoundGenericArg extends @use_bound_generic_arg, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class UseBoundGenericArgs extends @use_bound_generic_args, AstNode {
    override string toString() { result = "UseBoundGenericArgs" }

    /**
     * Gets the `index`th use bound generic argument of this use bound generic arguments (0-based).
     */
    UseBoundGenericArg getUseBoundGenericArg(int index) {
      use_bound_generic_args_use_bound_generic_args(this, index, result)
    }
  }

  /**
   * INTERNAL: Do not use.
   * A UseTree. For example:
   * ```rust
   * use std::collections::HashMap;
   * use std::collections::*;
   * use std::collections::HashMap as MyHashMap;
   * use std::collections::{self, HashMap, HashSet};
   * ```
   */
  class UseTree extends @use_tree, AstNode {
    override string toString() { result = "UseTree" }

    /**
     * Holds if this use tree is glob.
     */
    predicate isGlob() { use_tree_is_glob(this) }

    /**
     * Gets the path of this use tree, if it exists.
     */
    Path getPath() { use_tree_paths(this, result) }

    /**
     * Gets the rename of this use tree, if it exists.
     */
    Rename getRename() { use_tree_renames(this, result) }

    /**
     * Gets the use tree list of this use tree, if it exists.
     */
    UseTreeList getUseTreeList() { use_tree_use_tree_lists(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A UseTreeList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class UseTreeList extends @use_tree_list, AstNode {
    override string toString() { result = "UseTreeList" }

    /**
     * Gets the `index`th use tree of this use tree list (0-based).
     */
    UseTree getUseTree(int index) { use_tree_list_use_trees(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A VariantList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class VariantList extends @variant_list, AstNode {
    override string toString() { result = "VariantList" }

    /**
     * Gets the `index`th variant of this variant list (0-based).
     */
    Variant getVariant(int index) { variant_list_variants(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Visibility. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Visibility extends @visibility, AstNode {
    override string toString() { result = "Visibility" }

    /**
     * Gets the path of this visibility, if it exists.
     */
    Path getPath() { visibility_paths(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A WhereClause. For example:
   * ```rust
   * todo!()
   * ```
   */
  class WhereClause extends @where_clause, AstNode {
    override string toString() { result = "WhereClause" }

    /**
     * Gets the `index`th predicate of this where clause (0-based).
     */
    WherePred getPredicate(int index) { where_clause_predicates(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A WherePred. For example:
   * ```rust
   * todo!()
   * ```
   */
  class WherePred extends @where_pred, AstNode {
    override string toString() { result = "WherePred" }

    /**
     * Gets the generic parameter list of this where pred, if it exists.
     */
    GenericParamList getGenericParamList() { where_pred_generic_param_lists(this, result) }

    /**
     * Gets the lifetime of this where pred, if it exists.
     */
    Lifetime getLifetime() { where_pred_lifetimes(this, result) }

    /**
     * Gets the type representation of this where pred, if it exists.
     */
    TypeRepr getTypeRepr() { where_pred_type_reprs(this, result) }

    /**
     * Gets the type bound list of this where pred, if it exists.
     */
    TypeBoundList getTypeBoundList() { where_pred_type_bound_lists(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArrayExprInternal extends @array_expr_internal, Expr {
    override string toString() { result = "ArrayExprInternal" }

    /**
     * Gets the `index`th attr of this array expression internal (0-based).
     */
    Attr getAttr(int index) { array_expr_internal_attrs(this, index, result) }

    /**
     * Gets the `index`th expression of this array expression internal (0-based).
     */
    Expr getExpr(int index) { array_expr_internal_exprs(this, index, result) }

    /**
     * Holds if this array expression internal is semicolon.
     */
    predicate isSemicolon() { array_expr_internal_is_semicolon(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A ArrayTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ArrayTypeRepr extends @array_type_repr, TypeRepr {
    override string toString() { result = "ArrayTypeRepr" }

    /**
     * Gets the const argument of this array type representation, if it exists.
     */
    ConstArg getConstArg() { array_type_repr_const_args(this, result) }

    /**
     * Gets the element type representation of this array type representation, if it exists.
     */
    TypeRepr getElementTypeRepr() { array_type_repr_element_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmClobberAbi extends @asm_clobber_abi, AsmPiece {
    override string toString() { result = "AsmClobberAbi" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmConst extends @asm_const, AsmOperand {
    override string toString() { result = "AsmConst" }

    /**
     * Gets the expression of this asm const, if it exists.
     */
    Expr getExpr() { asm_const_exprs(this, result) }

    /**
     * Holds if this asm const is const.
     */
    predicate isConst() { asm_const_is_const(this) }
  }

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
     * Gets the `index`th asm piece of this asm expression (0-based).
     */
    AsmPiece getAsmPiece(int index) { asm_expr_asm_pieces(this, index, result) }

    /**
     * Gets the `index`th attr of this asm expression (0-based).
     */
    Attr getAttr(int index) { asm_expr_attrs(this, index, result) }

    /**
     * Gets the `index`th template of this asm expression (0-based).
     */
    Expr getTemplate(int index) { asm_expr_templates(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmLabel extends @asm_label, AsmOperand {
    override string toString() { result = "AsmLabel" }

    /**
     * Gets the block expression of this asm label, if it exists.
     */
    BlockExpr getBlockExpr() { asm_label_block_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmOperandNamed extends @asm_operand_named, AsmPiece {
    override string toString() { result = "AsmOperandNamed" }

    /**
     * Gets the asm operand of this asm operand named, if it exists.
     */
    AsmOperand getAsmOperand() { asm_operand_named_asm_operands(this, result) }

    /**
     * Gets the name of this asm operand named, if it exists.
     */
    Name getName() { asm_operand_named_names(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmOptionsList extends @asm_options_list, AsmPiece {
    override string toString() { result = "AsmOptionsList" }

    /**
     * Gets the `index`th asm option of this asm options list (0-based).
     */
    AsmOption getAsmOption(int index) { asm_options_list_asm_options(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmRegOperand extends @asm_reg_operand, AsmOperand {
    override string toString() { result = "AsmRegOperand" }

    /**
     * Gets the asm dir spec of this asm reg operand, if it exists.
     */
    AsmDirSpec getAsmDirSpec() { asm_reg_operand_asm_dir_specs(this, result) }

    /**
     * Gets the asm operand expression of this asm reg operand, if it exists.
     */
    AsmOperandExpr getAsmOperandExpr() { asm_reg_operand_asm_operand_exprs(this, result) }

    /**
     * Gets the asm reg spec of this asm reg operand, if it exists.
     */
    AsmRegSpec getAsmRegSpec() { asm_reg_operand_asm_reg_specs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AsmSym extends @asm_sym, AsmOperand {
    override string toString() { result = "AsmSym" }

    /**
     * Gets the path of this asm sym, if it exists.
     */
    Path getPath() { asm_sym_paths(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A AssocTypeArg. For example:
   * ```rust
   * todo!()
   * ```
   */
  class AssocTypeArg extends @assoc_type_arg, GenericArg {
    override string toString() { result = "AssocTypeArg" }

    /**
     * Gets the const argument of this assoc type argument, if it exists.
     */
    ConstArg getConstArg() { assoc_type_arg_const_args(this, result) }

    /**
     * Gets the generic argument list of this assoc type argument, if it exists.
     */
    GenericArgList getGenericArgList() { assoc_type_arg_generic_arg_lists(this, result) }

    /**
     * Gets the name reference of this assoc type argument, if it exists.
     */
    NameRef getNameRef() { assoc_type_arg_name_refs(this, result) }

    /**
     * Gets the parameter list of this assoc type argument, if it exists.
     */
    ParamList getParamList() { assoc_type_arg_param_lists(this, result) }

    /**
     * Gets the ret type of this assoc type argument, if it exists.
     */
    RetTypeRepr getRetType() { assoc_type_arg_ret_types(this, result) }

    /**
     * Gets the return type syntax of this assoc type argument, if it exists.
     */
    ReturnTypeSyntax getReturnTypeSyntax() { assoc_type_arg_return_type_syntaxes(this, result) }

    /**
     * Gets the type representation of this assoc type argument, if it exists.
     */
    TypeRepr getTypeRepr() { assoc_type_arg_type_reprs(this, result) }

    /**
     * Gets the type bound list of this assoc type argument, if it exists.
     */
    TypeBoundList getTypeBoundList() { assoc_type_arg_type_bound_lists(this, result) }
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
     * Gets the `index`th attr of this await expression (0-based).
     */
    Attr getAttr(int index) { await_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this await expression, if it exists.
     */
    Expr getExpr() { await_expr_exprs(this, result) }
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
     * Gets the `index`th attr of this become expression (0-based).
     */
    Attr getAttr(int index) { become_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this become expression, if it exists.
     */
    Expr getExpr() { become_expr_exprs(this, result) }
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
     * Gets the `index`th attr of this binary expression (0-based).
     */
    Attr getAttr(int index) { binary_expr_attrs(this, index, result) }

    /**
     * Gets the lhs of this binary expression, if it exists.
     */
    Expr getLhs() { binary_expr_lhs(this, result) }

    /**
     * Gets the operator name of this binary expression, if it exists.
     */
    string getOperatorName() { binary_expr_operator_names(this, result) }

    /**
     * Gets the rhs of this binary expression, if it exists.
     */
    Expr getRhs() { binary_expr_rhs(this, result) }
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
     * Gets the pattern of this box pattern, if it exists.
     */
    Pat getPat() { box_pat_pats(this, result) }
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
   * ```rust
   * let x = 'label: {
   *     if exit() {
   *         break 'label 42;
   *     }
   *     0;
   * };
   * ```
   */
  class BreakExpr extends @break_expr, Expr {
    override string toString() { result = "BreakExpr" }

    /**
     * Gets the `index`th attr of this break expression (0-based).
     */
    Attr getAttr(int index) { break_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this break expression, if it exists.
     */
    Expr getExpr() { break_expr_exprs(this, result) }

    /**
     * Gets the lifetime of this break expression, if it exists.
     */
    Lifetime getLifetime() { break_expr_lifetimes(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A function or method call expression. See `CallExpr` and `MethodCallExpr` for further details.
   */
  class CallExprBase extends @call_expr_base, Expr {
    /**
     * Gets the argument list of this call expression base, if it exists.
     */
    ArgList getArgList() { call_expr_base_arg_lists(this, result) }

    /**
     * Gets the `index`th attr of this call expression base (0-based).
     */
    Attr getAttr(int index) { call_expr_base_attrs(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A type cast expression. For example:
   * ```rust
   * value as u64;
   * ```
   */
  class CastExpr extends @cast_expr, Expr {
    override string toString() { result = "CastExpr" }

    /**
     * Gets the `index`th attr of this cast expression (0-based).
     */
    Attr getAttr(int index) { cast_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this cast expression, if it exists.
     */
    Expr getExpr() { cast_expr_exprs(this, result) }

    /**
     * Gets the type representation of this cast expression, if it exists.
     */
    TypeRepr getTypeRepr() { cast_expr_type_reprs(this, result) }
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
  class ClosureExpr extends @closure_expr, Expr, Callable {
    override string toString() { result = "ClosureExpr" }

    /**
     * Gets the body of this closure expression, if it exists.
     */
    Expr getBody() { closure_expr_bodies(this, result) }

    /**
     * Gets the closure binder of this closure expression, if it exists.
     */
    ClosureBinder getClosureBinder() { closure_expr_closure_binders(this, result) }

    /**
     * Holds if this closure expression is async.
     */
    predicate isAsync() { closure_expr_is_async(this) }

    /**
     * Holds if this closure expression is const.
     */
    predicate isConst() { closure_expr_is_const(this) }

    /**
     * Holds if this closure expression is gen.
     */
    predicate isGen() { closure_expr_is_gen(this) }

    /**
     * Holds if this closure expression is move.
     */
    predicate isMove() { closure_expr_is_move(this) }

    /**
     * Holds if this closure expression is static.
     */
    predicate isStatic() { closure_expr_is_static(this) }

    /**
     * Gets the ret type of this closure expression, if it exists.
     */
    RetTypeRepr getRetType() { closure_expr_ret_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A comment. For example:
   * ```rust
   * // this is a comment
   * /// This is a doc comment
   * ```
   */
  class Comment extends @comment, Token {
    override string toString() { result = "Comment" }

    /**
     * Gets the parent of this comment.
     */
    AstNode getParent() { comments(this, result, _) }

    /**
     * Gets the text of this comment.
     */
    string getText() { comments(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ConstArg. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ConstArg extends @const_arg, GenericArg {
    override string toString() { result = "ConstArg" }

    /**
     * Gets the expression of this const argument, if it exists.
     */
    Expr getExpr() { const_arg_exprs(this, result) }
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
     * Gets the block expression of this const block pattern, if it exists.
     */
    BlockExpr getBlockExpr() { const_block_pat_block_exprs(this, result) }

    /**
     * Holds if this const block pattern is const.
     */
    predicate isConst() { const_block_pat_is_const(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A ConstParam. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ConstParam extends @const_param, GenericParam {
    override string toString() { result = "ConstParam" }

    /**
     * Gets the `index`th attr of this const parameter (0-based).
     */
    Attr getAttr(int index) { const_param_attrs(this, index, result) }

    /**
     * Gets the default val of this const parameter, if it exists.
     */
    ConstArg getDefaultVal() { const_param_default_vals(this, result) }

    /**
     * Holds if this const parameter is const.
     */
    predicate isConst() { const_param_is_const(this) }

    /**
     * Gets the name of this const parameter, if it exists.
     */
    Name getName() { const_param_names(this, result) }

    /**
     * Gets the type representation of this const parameter, if it exists.
     */
    TypeRepr getTypeRepr() { const_param_type_reprs(this, result) }
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
     * Gets the `index`th attr of this continue expression (0-based).
     */
    Attr getAttr(int index) { continue_expr_attrs(this, index, result) }

    /**
     * Gets the lifetime of this continue expression, if it exists.
     */
    Lifetime getLifetime() { continue_expr_lifetimes(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A DynTraitTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class DynTraitTypeRepr extends @dyn_trait_type_repr, TypeRepr {
    override string toString() { result = "DynTraitTypeRepr" }

    /**
     * Gets the type bound list of this dyn trait type representation, if it exists.
     */
    TypeBoundList getTypeBoundList() { dyn_trait_type_repr_type_bound_lists(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An expression statement. For example:
   * ```rust
   * start();
   * finish();
   * use std::env;
   * ```
   */
  class ExprStmt extends @expr_stmt, Stmt {
    override string toString() { result = "ExprStmt" }

    /**
     * Gets the expression of this expression statement, if it exists.
     */
    Expr getExpr() { expr_stmt_exprs(this, result) }
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
     * Gets the `index`th attr of this field expression (0-based).
     */
    Attr getAttr(int index) { field_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this field expression, if it exists.
     */
    Expr getExpr() { field_expr_exprs(this, result) }

    /**
     * Gets the name reference of this field expression, if it exists.
     */
    NameRef getNameRef() { field_expr_name_refs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A FnPtrTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class FnPtrTypeRepr extends @fn_ptr_type_repr, TypeRepr {
    override string toString() { result = "FnPtrTypeRepr" }

    /**
     * Gets the abi of this fn ptr type representation, if it exists.
     */
    Abi getAbi() { fn_ptr_type_repr_abis(this, result) }

    /**
     * Holds if this fn ptr type representation is async.
     */
    predicate isAsync() { fn_ptr_type_repr_is_async(this) }

    /**
     * Holds if this fn ptr type representation is const.
     */
    predicate isConst() { fn_ptr_type_repr_is_const(this) }

    /**
     * Holds if this fn ptr type representation is unsafe.
     */
    predicate isUnsafe() { fn_ptr_type_repr_is_unsafe(this) }

    /**
     * Gets the parameter list of this fn ptr type representation, if it exists.
     */
    ParamList getParamList() { fn_ptr_type_repr_param_lists(this, result) }

    /**
     * Gets the ret type of this fn ptr type representation, if it exists.
     */
    RetTypeRepr getRetType() { fn_ptr_type_repr_ret_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ForTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ForTypeRepr extends @for_type_repr, TypeRepr {
    override string toString() { result = "ForTypeRepr" }

    /**
     * Gets the generic parameter list of this for type representation, if it exists.
     */
    GenericParamList getGenericParamList() { for_type_repr_generic_param_lists(this, result) }

    /**
     * Gets the type representation of this for type representation, if it exists.
     */
    TypeRepr getTypeRepr() { for_type_repr_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A FormatArgsExpr. For example:
   * ```rust
   * format_args!("no args");
   * format_args!("{} foo {:?}", 1, 2);
   * format_args!("{b} foo {a:?}", a=1, b=2);
   * let (x, y) = (1, 42);
   * format_args!("{x}, {y}");
   * ```
   */
  class FormatArgsExpr extends @format_args_expr, Expr {
    override string toString() { result = "FormatArgsExpr" }

    /**
     * Gets the `index`th argument of this format arguments expression (0-based).
     */
    FormatArgsArg getArg(int index) { format_args_expr_args(this, index, result) }

    /**
     * Gets the `index`th attr of this format arguments expression (0-based).
     */
    Attr getAttr(int index) { format_args_expr_attrs(this, index, result) }

    /**
     * Gets the template of this format arguments expression, if it exists.
     */
    Expr getTemplate() { format_args_expr_templates(this, result) }
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
     * Gets the `index`th attr of this ident pattern (0-based).
     */
    Attr getAttr(int index) { ident_pat_attrs(this, index, result) }

    /**
     * Holds if this ident pattern is mut.
     */
    predicate isMut() { ident_pat_is_mut(this) }

    /**
     * Holds if this ident pattern is reference.
     */
    predicate isRef() { ident_pat_is_ref(this) }

    /**
     * Gets the name of this ident pattern, if it exists.
     */
    Name getName() { ident_pat_names(this, result) }

    /**
     * Gets the pattern of this ident pattern, if it exists.
     */
    Pat getPat() { ident_pat_pats(this, result) }
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
   * };
   * ```
   */
  class IfExpr extends @if_expr, Expr {
    override string toString() { result = "IfExpr" }

    /**
     * Gets the `index`th attr of this if expression (0-based).
     */
    Attr getAttr(int index) { if_expr_attrs(this, index, result) }

    /**
     * Gets the condition of this if expression, if it exists.
     */
    Expr getCondition() { if_expr_conditions(this, result) }

    /**
     * Gets the else of this if expression, if it exists.
     */
    Expr getElse() { if_expr_elses(this, result) }

    /**
     * Gets the then of this if expression, if it exists.
     */
    BlockExpr getThen() { if_expr_thens(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ImplTraitTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ImplTraitTypeRepr extends @impl_trait_type_repr, TypeRepr {
    override string toString() { result = "ImplTraitTypeRepr" }

    /**
     * Gets the type bound list of this impl trait type representation, if it exists.
     */
    TypeBoundList getTypeBoundList() { impl_trait_type_repr_type_bound_lists(this, result) }
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
     * Gets the `index`th attr of this index expression (0-based).
     */
    Attr getAttr(int index) { index_expr_attrs(this, index, result) }

    /**
     * Gets the base of this index expression, if it exists.
     */
    Expr getBase() { index_expr_bases(this, result) }

    /**
     * Gets the index of this index expression, if it exists.
     */
    Expr getIndex() { index_expr_indices(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A InferTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class InferTypeRepr extends @infer_type_repr, TypeRepr {
    override string toString() { result = "InferTypeRepr" }
  }

  /**
   * INTERNAL: Do not use.
   * A Item. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Item extends @item, Stmt, Addressable { }

  /**
   * INTERNAL: Do not use.
   * The base class for expressions that can be labeled (`LoopExpr`, `ForExpr`, `WhileExpr` or `BlockExpr`).
   */
  class LabelableExpr extends @labelable_expr, Expr {
    /**
     * Gets the label of this labelable expression, if it exists.
     */
    Label getLabel() { labelable_expr_labels(this, result) }
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
     * Gets the `index`th attr of this let expression (0-based).
     */
    Attr getAttr(int index) { let_expr_attrs(this, index, result) }

    /**
     * Gets the scrutinee of this let expression, if it exists.
     */
    Expr getScrutinee() { let_expr_scrutinees(this, result) }

    /**
     * Gets the pattern of this let expression, if it exists.
     */
    Pat getPat() { let_expr_pats(this, result) }
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
     * Gets the `index`th attr of this let statement (0-based).
     */
    Attr getAttr(int index) { let_stmt_attrs(this, index, result) }

    /**
     * Gets the initializer of this let statement, if it exists.
     */
    Expr getInitializer() { let_stmt_initializers(this, result) }

    /**
     * Gets the let else of this let statement, if it exists.
     */
    LetElse getLetElse() { let_stmt_let_elses(this, result) }

    /**
     * Gets the pattern of this let statement, if it exists.
     */
    Pat getPat() { let_stmt_pats(this, result) }

    /**
     * Gets the type representation of this let statement, if it exists.
     */
    TypeRepr getTypeRepr() { let_stmt_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Lifetime. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Lifetime extends @lifetime, UseBoundGenericArg {
    override string toString() { result = "Lifetime" }

    /**
     * Gets the text of this lifetime, if it exists.
     */
    string getText() { lifetime_texts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A LifetimeArg. For example:
   * ```rust
   * todo!()
   * ```
   */
  class LifetimeArg extends @lifetime_arg, GenericArg {
    override string toString() { result = "LifetimeArg" }

    /**
     * Gets the lifetime of this lifetime argument, if it exists.
     */
    Lifetime getLifetime() { lifetime_arg_lifetimes(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A LifetimeParam. For example:
   * ```rust
   * todo!()
   * ```
   */
  class LifetimeParam extends @lifetime_param, GenericParam {
    override string toString() { result = "LifetimeParam" }

    /**
     * Gets the `index`th attr of this lifetime parameter (0-based).
     */
    Attr getAttr(int index) { lifetime_param_attrs(this, index, result) }

    /**
     * Gets the lifetime of this lifetime parameter, if it exists.
     */
    Lifetime getLifetime() { lifetime_param_lifetimes(this, result) }

    /**
     * Gets the type bound list of this lifetime parameter, if it exists.
     */
    TypeBoundList getTypeBoundList() { lifetime_param_type_bound_lists(this, result) }
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

    /**
     * Gets the `index`th attr of this literal expression (0-based).
     */
    Attr getAttr(int index) { literal_expr_attrs(this, index, result) }

    /**
     * Gets the text value of this literal expression, if it exists.
     */
    string getTextValue() { literal_expr_text_values(this, result) }
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
     * Gets the literal of this literal pattern, if it exists.
     */
    LiteralExpr getLiteral() { literal_pat_literals(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MacroExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroExpr extends @macro_expr, Expr {
    override string toString() { result = "MacroExpr" }

    /**
     * Gets the macro call of this macro expression, if it exists.
     */
    MacroCall getMacroCall() { macro_expr_macro_calls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MacroPat. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroPat extends @macro_pat, Pat {
    override string toString() { result = "MacroPat" }

    /**
     * Gets the macro call of this macro pattern, if it exists.
     */
    MacroCall getMacroCall() { macro_pat_macro_calls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MacroTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroTypeRepr extends @macro_type_repr, TypeRepr {
    override string toString() { result = "MacroTypeRepr" }

    /**
     * Gets the macro call of this macro type representation, if it exists.
     */
    MacroCall getMacroCall() { macro_type_repr_macro_calls(this, result) }
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
     * Gets the `index`th attr of this match expression (0-based).
     */
    Attr getAttr(int index) { match_expr_attrs(this, index, result) }

    /**
     * Gets the scrutinee (the expression being matched) of this match expression, if it exists.
     */
    Expr getScrutinee() { match_expr_scrutinees(this, result) }

    /**
     * Gets the match arm list of this match expression, if it exists.
     */
    MatchArmList getMatchArmList() { match_expr_match_arm_lists(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A NameRef. For example:
   * ```rust
   * todo!()
   * ```
   */
  class NameRef extends @name_ref, UseBoundGenericArg {
    override string toString() { result = "NameRef" }

    /**
     * Gets the text of this name reference, if it exists.
     */
    string getText() { name_ref_texts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A NeverTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class NeverTypeRepr extends @never_type_repr, TypeRepr {
    override string toString() { result = "NeverTypeRepr" }
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
     * Gets the `index`th attr of this offset of expression (0-based).
     */
    Attr getAttr(int index) { offset_of_expr_attrs(this, index, result) }

    /**
     * Gets the `index`th field of this offset of expression (0-based).
     */
    NameRef getField(int index) { offset_of_expr_fields(this, index, result) }

    /**
     * Gets the type representation of this offset of expression, if it exists.
     */
    TypeRepr getTypeRepr() { offset_of_expr_type_reprs(this, result) }
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
     * Gets the `index`th pattern of this or pattern (0-based).
     */
    Pat getPat(int index) { or_pat_pats(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A parameter in a function or method. For example `x` in:
   * ```rust
   * fn new(x: T) -> Foo<T> {
   *   // ...
   * }
   * ```
   */
  class Param extends @param, ParamBase {
    override string toString() { result = "Param" }

    /**
     * Gets the pattern of this parameter, if it exists.
     */
    Pat getPat() { param_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ParenExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenExpr extends @paren_expr, Expr {
    override string toString() { result = "ParenExpr" }

    /**
     * Gets the `index`th attr of this paren expression (0-based).
     */
    Attr getAttr(int index) { paren_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this paren expression, if it exists.
     */
    Expr getExpr() { paren_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ParenPat. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenPat extends @paren_pat, Pat {
    override string toString() { result = "ParenPat" }

    /**
     * Gets the pattern of this paren pattern, if it exists.
     */
    Pat getPat() { paren_pat_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ParenTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenTypeRepr extends @paren_type_repr, TypeRepr {
    override string toString() { result = "ParenTypeRepr" }

    /**
     * Gets the type representation of this paren type representation, if it exists.
     */
    TypeRepr getTypeRepr() { paren_type_repr_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An AST element wrapping a path (`PathExpr`, `RecordExpr`, `PathPat`, `RecordPat`, `TupleStructPat`).
   */
  class PathAstNode extends @path_ast_node, Resolvable {
    /**
     * Gets the path of this path ast node, if it exists.
     */
    Path getPath() { path_ast_node_paths(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A path expression or a variable access in a formatting template. See `PathExpr` and `FormatTemplateVariableAccess` for further details.
   */
  class PathExprBase extends @path_expr_base, Expr { }

  /**
   * INTERNAL: Do not use.
   * A type referring to a path. For example:
   * ```rust
   * type X = std::collections::HashMap<i32, i32>;
   * type Y = X::Item;
   * ```
   */
  class PathTypeRepr extends @path_type_repr, TypeRepr {
    override string toString() { result = "PathTypeRepr" }

    /**
     * Gets the path of this path type representation, if it exists.
     */
    Path getPath() { path_type_repr_paths(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A unary operation expression. For example:
   * ```rust
   * let x = -42;
   * let y = !true;
   * let z = *ptr;
   * ```
   */
  class PrefixExpr extends @prefix_expr, Expr {
    override string toString() { result = "PrefixExpr" }

    /**
     * Gets the `index`th attr of this prefix expression (0-based).
     */
    Attr getAttr(int index) { prefix_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this prefix expression, if it exists.
     */
    Expr getExpr() { prefix_expr_exprs(this, result) }

    /**
     * Gets the operator name of this prefix expression, if it exists.
     */
    string getOperatorName() { prefix_expr_operator_names(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A PtrTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class PtrTypeRepr extends @ptr_type_repr, TypeRepr {
    override string toString() { result = "PtrTypeRepr" }

    /**
     * Holds if this ptr type representation is const.
     */
    predicate isConst() { ptr_type_repr_is_const(this) }

    /**
     * Holds if this ptr type representation is mut.
     */
    predicate isMut() { ptr_type_repr_is_mut(this) }

    /**
     * Gets the type representation of this ptr type representation, if it exists.
     */
    TypeRepr getTypeRepr() { ptr_type_repr_type_reprs(this, result) }
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
     * Gets the `index`th attr of this range expression (0-based).
     */
    Attr getAttr(int index) { range_expr_attrs(this, index, result) }

    /**
     * Gets the end of this range expression, if it exists.
     */
    Expr getEnd() { range_expr_ends(this, result) }

    /**
     * Gets the operator name of this range expression, if it exists.
     */
    string getOperatorName() { range_expr_operator_names(this, result) }

    /**
     * Gets the start of this range expression, if it exists.
     */
    Expr getStart() { range_expr_starts(this, result) }
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
     * Gets the end of this range pattern, if it exists.
     */
    Pat getEnd() { range_pat_ends(this, result) }

    /**
     * Gets the operator name of this range pattern, if it exists.
     */
    string getOperatorName() { range_pat_operator_names(this, result) }

    /**
     * Gets the start of this range pattern, if it exists.
     */
    Pat getStart() { range_pat_starts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RecordFieldList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RecordFieldList extends @record_field_list, FieldList {
    override string toString() { result = "RecordFieldList" }

    /**
     * Gets the `index`th field of this record field list (0-based).
     */
    RecordField getField(int index) { record_field_list_fields(this, index, result) }
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
     * Gets the `index`th attr of this reference expression (0-based).
     */
    Attr getAttr(int index) { ref_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this reference expression, if it exists.
     */
    Expr getExpr() { ref_expr_exprs(this, result) }

    /**
     * Holds if this reference expression is const.
     */
    predicate isConst() { ref_expr_is_const(this) }

    /**
     * Holds if this reference expression is mut.
     */
    predicate isMut() { ref_expr_is_mut(this) }

    /**
     * Holds if this reference expression is raw.
     */
    predicate isRaw() { ref_expr_is_raw(this) }
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
     * Holds if this reference pattern is mut.
     */
    predicate isMut() { ref_pat_is_mut(this) }

    /**
     * Gets the pattern of this reference pattern, if it exists.
     */
    Pat getPat() { ref_pat_pats(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RefTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RefTypeRepr extends @ref_type_repr, TypeRepr {
    override string toString() { result = "RefTypeRepr" }

    /**
     * Holds if this reference type representation is mut.
     */
    predicate isMut() { ref_type_repr_is_mut(this) }

    /**
     * Gets the lifetime of this reference type representation, if it exists.
     */
    Lifetime getLifetime() { ref_type_repr_lifetimes(this, result) }

    /**
     * Gets the type representation of this reference type representation, if it exists.
     */
    TypeRepr getTypeRepr() { ref_type_repr_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A RestPat. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RestPat extends @rest_pat, Pat {
    override string toString() { result = "RestPat" }

    /**
     * Gets the `index`th attr of this rest pattern (0-based).
     */
    Attr getAttr(int index) { rest_pat_attrs(this, index, result) }
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
     * Gets the `index`th attr of this return expression (0-based).
     */
    Attr getAttr(int index) { return_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this return expression, if it exists.
     */
    Expr getExpr() { return_expr_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A `self` parameter. For example `self` in:
   * ```rust
   * struct X;
   * impl X {
   *   fn one(&self) {}
   *   fn two(&mut self) {}
   *   fn three(self) {}
   *   fn four(mut self) {}
   *   fn five<'a>(&'a self) {}
   * }
   * ```
   */
  class SelfParam extends @self_param, ParamBase {
    override string toString() { result = "SelfParam" }

    /**
     * Holds if this self parameter is reference.
     */
    predicate isRef() { self_param_is_ref(this) }

    /**
     * Holds if this self parameter is mut.
     */
    predicate isMut() { self_param_is_mut(this) }

    /**
     * Gets the lifetime of this self parameter, if it exists.
     */
    Lifetime getLifetime() { self_param_lifetimes(this, result) }

    /**
     * Gets the name of this self parameter, if it exists.
     */
    Name getName() { self_param_names(this, result) }
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
     * Gets the `index`th pattern of this slice pattern (0-based).
     */
    Pat getPat(int index) { slice_pat_pats(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A SliceTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class SliceTypeRepr extends @slice_type_repr, TypeRepr {
    override string toString() { result = "SliceTypeRepr" }

    /**
     * Gets the type representation of this slice type representation, if it exists.
     */
    TypeRepr getTypeRepr() { slice_type_repr_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TryExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TryExpr extends @try_expr, Expr {
    override string toString() { result = "TryExpr" }

    /**
     * Gets the `index`th attr of this try expression (0-based).
     */
    Attr getAttr(int index) { try_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this try expression, if it exists.
     */
    Expr getExpr() { try_expr_exprs(this, result) }
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
     * Gets the `index`th attr of this tuple expression (0-based).
     */
    Attr getAttr(int index) { tuple_expr_attrs(this, index, result) }

    /**
     * Gets the `index`th field of this tuple expression (0-based).
     */
    Expr getField(int index) { tuple_expr_fields(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TupleFieldList. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TupleFieldList extends @tuple_field_list, FieldList {
    override string toString() { result = "TupleFieldList" }

    /**
     * Gets the `index`th field of this tuple field list (0-based).
     */
    TupleField getField(int index) { tuple_field_list_fields(this, index, result) }
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
     * Gets the `index`th field of this tuple pattern (0-based).
     */
    Pat getField(int index) { tuple_pat_fields(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TupleTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TupleTypeRepr extends @tuple_type_repr, TypeRepr {
    override string toString() { result = "TupleTypeRepr" }

    /**
     * Gets the `index`th field of this tuple type representation (0-based).
     */
    TypeRepr getField(int index) { tuple_type_repr_fields(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TypeArg. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TypeArg extends @type_arg, GenericArg {
    override string toString() { result = "TypeArg" }

    /**
     * Gets the type representation of this type argument, if it exists.
     */
    TypeRepr getTypeRepr() { type_arg_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TypeParam. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TypeParam extends @type_param, GenericParam {
    override string toString() { result = "TypeParam" }

    /**
     * Gets the `index`th attr of this type parameter (0-based).
     */
    Attr getAttr(int index) { type_param_attrs(this, index, result) }

    /**
     * Gets the default type of this type parameter, if it exists.
     */
    TypeRepr getDefaultType() { type_param_default_types(this, result) }

    /**
     * Gets the name of this type parameter, if it exists.
     */
    Name getName() { type_param_names(this, result) }

    /**
     * Gets the type bound list of this type parameter, if it exists.
     */
    TypeBoundList getTypeBoundList() { type_param_type_bound_lists(this, result) }
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

    /**
     * Gets the `index`th attr of this underscore expression (0-based).
     */
    Attr getAttr(int index) { underscore_expr_attrs(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Variant. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Variant extends @variant, Addressable {
    override string toString() { result = "Variant" }

    /**
     * Gets the `index`th attr of this variant (0-based).
     */
    Attr getAttr(int index) { variant_attrs(this, index, result) }

    /**
     * Gets the expression of this variant, if it exists.
     */
    Expr getExpr() { variant_exprs(this, result) }

    /**
     * Gets the field list of this variant, if it exists.
     */
    FieldList getFieldList() { variant_field_lists(this, result) }

    /**
     * Gets the name of this variant, if it exists.
     */
    Name getName() { variant_names(this, result) }

    /**
     * Gets the visibility of this variant, if it exists.
     */
    Visibility getVisibility() { variant_visibilities(this, result) }
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
     * Gets the `index`th attr of this yeet expression (0-based).
     */
    Attr getAttr(int index) { yeet_expr_attrs(this, index, result) }

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
     * Gets the `index`th attr of this yield expression (0-based).
     */
    Attr getAttr(int index) { yield_expr_attrs(this, index, result) }

    /**
     * Gets the expression of this yield expression, if it exists.
     */
    Expr getExpr() { yield_expr_exprs(this, result) }
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
  class BlockExpr extends @block_expr, LabelableExpr {
    override string toString() { result = "BlockExpr" }

    /**
     * Gets the `index`th attr of this block expression (0-based).
     */
    Attr getAttr(int index) { block_expr_attrs(this, index, result) }

    /**
     * Holds if this block expression is async.
     */
    predicate isAsync() { block_expr_is_async(this) }

    /**
     * Holds if this block expression is const.
     */
    predicate isConst() { block_expr_is_const(this) }

    /**
     * Holds if this block expression is gen.
     */
    predicate isGen() { block_expr_is_gen(this) }

    /**
     * Holds if this block expression is move.
     */
    predicate isMove() { block_expr_is_move(this) }

    /**
     * Holds if this block expression is try.
     */
    predicate isTry() { block_expr_is_try(this) }

    /**
     * Holds if this block expression is unsafe.
     */
    predicate isUnsafe() { block_expr_is_unsafe(this) }

    /**
     * Gets the statement list of this block expression, if it exists.
     */
    StmtList getStmtList() { block_expr_stmt_lists(this, result) }
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
  class CallExpr extends @call_expr, CallExprBase {
    override string toString() { result = "CallExpr" }

    /**
     * Gets the function of this call expression, if it exists.
     */
    Expr getFunction() { call_expr_functions(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Const. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Const extends @const, AssocItem, Item {
    override string toString() { result = "Const" }

    /**
     * Gets the `index`th attr of this const (0-based).
     */
    Attr getAttr(int index) { const_attrs(this, index, result) }

    /**
     * Gets the body of this const, if it exists.
     */
    Expr getBody() { const_bodies(this, result) }

    /**
     * Holds if this const is const.
     */
    predicate isConst() { const_is_const(this) }

    /**
     * Holds if this const is default.
     */
    predicate isDefault() { const_is_default(this) }

    /**
     * Gets the name of this const, if it exists.
     */
    Name getName() { const_names(this, result) }

    /**
     * Gets the type representation of this const, if it exists.
     */
    TypeRepr getTypeRepr() { const_type_reprs(this, result) }

    /**
     * Gets the visibility of this const, if it exists.
     */
    Visibility getVisibility() { const_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Enum. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Enum extends @enum, Item {
    override string toString() { result = "Enum" }

    /**
     * Gets the `index`th attr of this enum (0-based).
     */
    Attr getAttr(int index) { enum_attrs(this, index, result) }

    /**
     * Gets the generic parameter list of this enum, if it exists.
     */
    GenericParamList getGenericParamList() { enum_generic_param_lists(this, result) }

    /**
     * Gets the name of this enum, if it exists.
     */
    Name getName() { enum_names(this, result) }

    /**
     * Gets the variant list of this enum, if it exists.
     */
    VariantList getVariantList() { enum_variant_lists(this, result) }

    /**
     * Gets the visibility of this enum, if it exists.
     */
    Visibility getVisibility() { enum_visibilities(this, result) }

    /**
     * Gets the where clause of this enum, if it exists.
     */
    WhereClause getWhereClause() { enum_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ExternBlock. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ExternBlock extends @extern_block, Item {
    override string toString() { result = "ExternBlock" }

    /**
     * Gets the abi of this extern block, if it exists.
     */
    Abi getAbi() { extern_block_abis(this, result) }

    /**
     * Gets the `index`th attr of this extern block (0-based).
     */
    Attr getAttr(int index) { extern_block_attrs(this, index, result) }

    /**
     * Gets the extern item list of this extern block, if it exists.
     */
    ExternItemList getExternItemList() { extern_block_extern_item_lists(this, result) }

    /**
     * Holds if this extern block is unsafe.
     */
    predicate isUnsafe() { extern_block_is_unsafe(this) }
  }

  /**
   * INTERNAL: Do not use.
   * A ExternCrate. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ExternCrate extends @extern_crate, Item {
    override string toString() { result = "ExternCrate" }

    /**
     * Gets the `index`th attr of this extern crate (0-based).
     */
    Attr getAttr(int index) { extern_crate_attrs(this, index, result) }

    /**
     * Gets the name reference of this extern crate, if it exists.
     */
    NameRef getNameRef() { extern_crate_name_refs(this, result) }

    /**
     * Gets the rename of this extern crate, if it exists.
     */
    Rename getRename() { extern_crate_renames(this, result) }

    /**
     * Gets the visibility of this extern crate, if it exists.
     */
    Visibility getVisibility() { extern_crate_visibilities(this, result) }
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
  class Function extends @function, AssocItem, ExternItem, Item, Callable {
    override string toString() { result = "Function" }

    /**
     * Gets the abi of this function, if it exists.
     */
    Abi getAbi() { function_abis(this, result) }

    /**
     * Gets the body of this function, if it exists.
     */
    BlockExpr getBody() { function_bodies(this, result) }

    /**
     * Gets the generic parameter list of this function, if it exists.
     */
    GenericParamList getGenericParamList() { function_generic_param_lists(this, result) }

    /**
     * Holds if this function is async.
     */
    predicate isAsync() { function_is_async(this) }

    /**
     * Holds if this function is const.
     */
    predicate isConst() { function_is_const(this) }

    /**
     * Holds if this function is default.
     */
    predicate isDefault() { function_is_default(this) }

    /**
     * Holds if this function is gen.
     */
    predicate isGen() { function_is_gen(this) }

    /**
     * Holds if this function is unsafe.
     */
    predicate isUnsafe() { function_is_unsafe(this) }

    /**
     * Gets the name of this function, if it exists.
     */
    Name getName() { function_names(this, result) }

    /**
     * Gets the ret type of this function, if it exists.
     */
    RetTypeRepr getRetType() { function_ret_types(this, result) }

    /**
     * Gets the visibility of this function, if it exists.
     */
    Visibility getVisibility() { function_visibilities(this, result) }

    /**
     * Gets the where clause of this function, if it exists.
     */
    WhereClause getWhereClause() { function_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Impl. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Impl extends @impl, Item {
    override string toString() { result = "Impl" }

    /**
     * Gets the assoc item list of this impl, if it exists.
     */
    AssocItemList getAssocItemList() { impl_assoc_item_lists(this, result) }

    /**
     * Gets the `index`th attr of this impl (0-based).
     */
    Attr getAttr(int index) { impl_attrs(this, index, result) }

    /**
     * Gets the generic parameter list of this impl, if it exists.
     */
    GenericParamList getGenericParamList() { impl_generic_param_lists(this, result) }

    /**
     * Holds if this impl is const.
     */
    predicate isConst() { impl_is_const(this) }

    /**
     * Holds if this impl is default.
     */
    predicate isDefault() { impl_is_default(this) }

    /**
     * Holds if this impl is unsafe.
     */
    predicate isUnsafe() { impl_is_unsafe(this) }

    /**
     * Gets the self ty of this impl, if it exists.
     */
    TypeRepr getSelfTy() { impl_self_ties(this, result) }

    /**
     * Gets the trait of this impl, if it exists.
     */
    TypeRepr getTrait() { impl_traits(this, result) }

    /**
     * Gets the visibility of this impl, if it exists.
     */
    Visibility getVisibility() { impl_visibilities(this, result) }

    /**
     * Gets the where clause of this impl, if it exists.
     */
    WhereClause getWhereClause() { impl_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The base class for expressions that loop (`LoopExpr`, `ForExpr` or `WhileExpr`).
   */
  class LoopingExpr extends @looping_expr, LabelableExpr {
    /**
     * Gets the loop body of this looping expression, if it exists.
     */
    BlockExpr getLoopBody() { looping_expr_loop_bodies(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MacroCall. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroCall extends @macro_call, AssocItem, ExternItem, Item {
    override string toString() { result = "MacroCall" }

    /**
     * Gets the `index`th attr of this macro call (0-based).
     */
    Attr getAttr(int index) { macro_call_attrs(this, index, result) }

    /**
     * Gets the path of this macro call, if it exists.
     */
    Path getPath() { macro_call_paths(this, result) }

    /**
     * Gets the token tree of this macro call, if it exists.
     */
    TokenTree getTokenTree() { macro_call_token_trees(this, result) }

    /**
     * Gets the expanded of this macro call, if it exists.
     */
    AstNode getExpanded() { macro_call_expandeds(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MacroDef. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroDef extends @macro_def, Item {
    override string toString() { result = "MacroDef" }

    /**
     * Gets the arguments of this macro def, if it exists.
     */
    TokenTree getArgs() { macro_def_args(this, result) }

    /**
     * Gets the `index`th attr of this macro def (0-based).
     */
    Attr getAttr(int index) { macro_def_attrs(this, index, result) }

    /**
     * Gets the body of this macro def, if it exists.
     */
    TokenTree getBody() { macro_def_bodies(this, result) }

    /**
     * Gets the name of this macro def, if it exists.
     */
    Name getName() { macro_def_names(this, result) }

    /**
     * Gets the visibility of this macro def, if it exists.
     */
    Visibility getVisibility() { macro_def_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A MacroRules. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroRules extends @macro_rules, Item {
    override string toString() { result = "MacroRules" }

    /**
     * Gets the `index`th attr of this macro rules (0-based).
     */
    Attr getAttr(int index) { macro_rules_attrs(this, index, result) }

    /**
     * Gets the name of this macro rules, if it exists.
     */
    Name getName() { macro_rules_names(this, result) }

    /**
     * Gets the token tree of this macro rules, if it exists.
     */
    TokenTree getTokenTree() { macro_rules_token_trees(this, result) }

    /**
     * Gets the visibility of this macro rules, if it exists.
     */
    Visibility getVisibility() { macro_rules_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A method call expression. For example:
   * ```rust
   * x.foo(42);
   * x.foo::<u32, u64>(42);
   * ```
   */
  class MethodCallExpr extends @method_call_expr, CallExprBase, Resolvable {
    override string toString() { result = "MethodCallExpr" }

    /**
     * Gets the generic argument list of this method call expression, if it exists.
     */
    GenericArgList getGenericArgList() { method_call_expr_generic_arg_lists(this, result) }

    /**
     * Gets the name reference of this method call expression, if it exists.
     */
    NameRef getNameRef() { method_call_expr_name_refs(this, result) }

    /**
     * Gets the receiver of this method call expression, if it exists.
     */
    Expr getReceiver() { method_call_expr_receivers(this, result) }
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
  class Module extends @module, Item {
    override string toString() { result = "Module" }

    /**
     * Gets the `index`th attr of this module (0-based).
     */
    Attr getAttr(int index) { module_attrs(this, index, result) }

    /**
     * Gets the item list of this module, if it exists.
     */
    ItemList getItemList() { module_item_lists(this, result) }

    /**
     * Gets the name of this module, if it exists.
     */
    Name getName() { module_names(this, result) }

    /**
     * Gets the visibility of this module, if it exists.
     */
    Visibility getVisibility() { module_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A path expression. For example:
   * ```rust
   * let x = variable;
   * let x = foo::bar;
   * let y = <T>::foo;
   * let z = <TypeRepr as Trait>::foo;
   * ```
   */
  class PathExpr extends @path_expr, PathExprBase, PathAstNode {
    override string toString() { result = "PathExpr" }

    /**
     * Gets the `index`th attr of this path expression (0-based).
     */
    Attr getAttr(int index) { path_expr_attrs(this, index, result) }
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
  class PathPat extends @path_pat, Pat, PathAstNode {
    override string toString() { result = "PathPat" }
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
  class RecordExpr extends @record_expr, Expr, PathAstNode {
    override string toString() { result = "RecordExpr" }

    /**
     * Gets the record expression field list of this record expression, if it exists.
     */
    RecordExprFieldList getRecordExprFieldList() {
      record_expr_record_expr_field_lists(this, result)
    }
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
  class RecordPat extends @record_pat, Pat, PathAstNode {
    override string toString() { result = "RecordPat" }

    /**
     * Gets the record pattern field list of this record pattern, if it exists.
     */
    RecordPatFieldList getRecordPatFieldList() { record_pat_record_pat_field_lists(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Static. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Static extends @static, ExternItem, Item {
    override string toString() { result = "Static" }

    /**
     * Gets the `index`th attr of this static (0-based).
     */
    Attr getAttr(int index) { static_attrs(this, index, result) }

    /**
     * Gets the body of this static, if it exists.
     */
    Expr getBody() { static_bodies(this, result) }

    /**
     * Holds if this static is mut.
     */
    predicate isMut() { static_is_mut(this) }

    /**
     * Holds if this static is static.
     */
    predicate isStatic() { static_is_static(this) }

    /**
     * Holds if this static is unsafe.
     */
    predicate isUnsafe() { static_is_unsafe(this) }

    /**
     * Gets the name of this static, if it exists.
     */
    Name getName() { static_names(this, result) }

    /**
     * Gets the type representation of this static, if it exists.
     */
    TypeRepr getTypeRepr() { static_type_reprs(this, result) }

    /**
     * Gets the visibility of this static, if it exists.
     */
    Visibility getVisibility() { static_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Struct. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Struct extends @struct, Item {
    override string toString() { result = "Struct" }

    /**
     * Gets the `index`th attr of this struct (0-based).
     */
    Attr getAttr(int index) { struct_attrs(this, index, result) }

    /**
     * Gets the field list of this struct, if it exists.
     */
    FieldList getFieldList() { struct_field_lists(this, result) }

    /**
     * Gets the generic parameter list of this struct, if it exists.
     */
    GenericParamList getGenericParamList() { struct_generic_param_lists(this, result) }

    /**
     * Gets the name of this struct, if it exists.
     */
    Name getName() { struct_names(this, result) }

    /**
     * Gets the visibility of this struct, if it exists.
     */
    Visibility getVisibility() { struct_visibilities(this, result) }

    /**
     * Gets the where clause of this struct, if it exists.
     */
    WhereClause getWhereClause() { struct_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Trait. For example:
   * ```
   * trait Frobinizable {
   *   type Frobinator;
   *   type Result: Copy;
   *   fn frobinize_with(&mut self, frobinator: &Self::Frobinator) -> Result;
   * }
   *
   * pub trait Foo<T: Frobinizable> where T::Frobinator: Eq {}
   * ```
   */
  class Trait extends @trait, Item {
    override string toString() { result = "Trait" }

    /**
     * Gets the assoc item list of this trait, if it exists.
     */
    AssocItemList getAssocItemList() { trait_assoc_item_lists(this, result) }

    /**
     * Gets the `index`th attr of this trait (0-based).
     */
    Attr getAttr(int index) { trait_attrs(this, index, result) }

    /**
     * Gets the generic parameter list of this trait, if it exists.
     */
    GenericParamList getGenericParamList() { trait_generic_param_lists(this, result) }

    /**
     * Holds if this trait is auto.
     */
    predicate isAuto() { trait_is_auto(this) }

    /**
     * Holds if this trait is unsafe.
     */
    predicate isUnsafe() { trait_is_unsafe(this) }

    /**
     * Gets the name of this trait, if it exists.
     */
    Name getName() { trait_names(this, result) }

    /**
     * Gets the type bound list of this trait, if it exists.
     */
    TypeBoundList getTypeBoundList() { trait_type_bound_lists(this, result) }

    /**
     * Gets the visibility of this trait, if it exists.
     */
    Visibility getVisibility() { trait_visibilities(this, result) }

    /**
     * Gets the where clause of this trait, if it exists.
     */
    WhereClause getWhereClause() { trait_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TraitAlias. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TraitAlias extends @trait_alias, Item {
    override string toString() { result = "TraitAlias" }

    /**
     * Gets the `index`th attr of this trait alias (0-based).
     */
    Attr getAttr(int index) { trait_alias_attrs(this, index, result) }

    /**
     * Gets the generic parameter list of this trait alias, if it exists.
     */
    GenericParamList getGenericParamList() { trait_alias_generic_param_lists(this, result) }

    /**
     * Gets the name of this trait alias, if it exists.
     */
    Name getName() { trait_alias_names(this, result) }

    /**
     * Gets the type bound list of this trait alias, if it exists.
     */
    TypeBoundList getTypeBoundList() { trait_alias_type_bound_lists(this, result) }

    /**
     * Gets the visibility of this trait alias, if it exists.
     */
    Visibility getVisibility() { trait_alias_visibilities(this, result) }

    /**
     * Gets the where clause of this trait alias, if it exists.
     */
    WhereClause getWhereClause() { trait_alias_where_clauses(this, result) }
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
  class TupleStructPat extends @tuple_struct_pat, Pat, PathAstNode {
    override string toString() { result = "TupleStructPat" }

    /**
     * Gets the `index`th field of this tuple struct pattern (0-based).
     */
    Pat getField(int index) { tuple_struct_pat_fields(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A TypeAlias. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TypeAlias extends @type_alias, AssocItem, ExternItem, Item {
    override string toString() { result = "TypeAlias" }

    /**
     * Gets the `index`th attr of this type alias (0-based).
     */
    Attr getAttr(int index) { type_alias_attrs(this, index, result) }

    /**
     * Gets the generic parameter list of this type alias, if it exists.
     */
    GenericParamList getGenericParamList() { type_alias_generic_param_lists(this, result) }

    /**
     * Holds if this type alias is default.
     */
    predicate isDefault() { type_alias_is_default(this) }

    /**
     * Gets the name of this type alias, if it exists.
     */
    Name getName() { type_alias_names(this, result) }

    /**
     * Gets the type representation of this type alias, if it exists.
     */
    TypeRepr getTypeRepr() { type_alias_type_reprs(this, result) }

    /**
     * Gets the type bound list of this type alias, if it exists.
     */
    TypeBoundList getTypeBoundList() { type_alias_type_bound_lists(this, result) }

    /**
     * Gets the visibility of this type alias, if it exists.
     */
    Visibility getVisibility() { type_alias_visibilities(this, result) }

    /**
     * Gets the where clause of this type alias, if it exists.
     */
    WhereClause getWhereClause() { type_alias_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Union. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Union extends @union, Item {
    override string toString() { result = "Union" }

    /**
     * Gets the `index`th attr of this union (0-based).
     */
    Attr getAttr(int index) { union_attrs(this, index, result) }

    /**
     * Gets the generic parameter list of this union, if it exists.
     */
    GenericParamList getGenericParamList() { union_generic_param_lists(this, result) }

    /**
     * Gets the name of this union, if it exists.
     */
    Name getName() { union_names(this, result) }

    /**
     * Gets the record field list of this union, if it exists.
     */
    RecordFieldList getRecordFieldList() { union_record_field_lists(this, result) }

    /**
     * Gets the visibility of this union, if it exists.
     */
    Visibility getVisibility() { union_visibilities(this, result) }

    /**
     * Gets the where clause of this union, if it exists.
     */
    WhereClause getWhereClause() { union_where_clauses(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A Use. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Use extends @use, Item {
    override string toString() { result = "Use" }

    /**
     * Gets the `index`th attr of this use (0-based).
     */
    Attr getAttr(int index) { use_attrs(this, index, result) }

    /**
     * Gets the use tree of this use, if it exists.
     */
    UseTree getUseTree() { use_use_trees(this, result) }

    /**
     * Gets the visibility of this use, if it exists.
     */
    Visibility getVisibility() { use_visibilities(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A ForExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ForExpr extends @for_expr, LoopingExpr {
    override string toString() { result = "ForExpr" }

    /**
     * Gets the `index`th attr of this for expression (0-based).
     */
    Attr getAttr(int index) { for_expr_attrs(this, index, result) }

    /**
     * Gets the iterable of this for expression, if it exists.
     */
    Expr getIterable() { for_expr_iterables(this, result) }

    /**
     * Gets the pattern of this for expression, if it exists.
     */
    Pat getPat() { for_expr_pats(this, result) }
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
  class LoopExpr extends @loop_expr, LoopingExpr {
    override string toString() { result = "LoopExpr" }

    /**
     * Gets the `index`th attr of this loop expression (0-based).
     */
    Attr getAttr(int index) { loop_expr_attrs(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A WhileExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class WhileExpr extends @while_expr, LoopingExpr {
    override string toString() { result = "WhileExpr" }

    /**
     * Gets the `index`th attr of this while expression (0-based).
     */
    Attr getAttr(int index) { while_expr_attrs(this, index, result) }

    /**
     * Gets the condition of this while expression, if it exists.
     */
    Expr getCondition() { while_expr_conditions(this, result) }
  }
}
