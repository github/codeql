/**
 * Provides functionality for resolving paths, using the predicate `resolvePath`.
 *
 * Path resolution needs to happen before variable resolution, because otherwise
 * we cannot know whether an identifier pattern binds a new variable or whether it
 * refers to a constructor or constant:
 *
 * ```rust
 * let x = ...; // `x` is only a variable if it does not resolve to a constructor/constant
 * ```
 *
 * Even though variable names typically start with a lowercase letter and constructors
 * with an uppercase letter, this is not enforced by the Rust language.
 *
 * Variables may shadow declarations, so variable resolution also needs to affect
 * path resolution:
 *
 * ```rust
 * fn foo() {}        // (1)
 *
 * fn bar() {
 *     let f = foo;   // `foo` here refers to (1) via path resolution
 *     let foo = f(); // (2)
 *     foo            // `foo` here refers to (2) via variable resolution
 * }
 * ```
 *
 * So it may seem that path resolution and variable resolution must happen in mutual
 * recursion, but we would like to keep the inherently global path resolution logic
 * separate from the inherently local variable resolution logic. We achieve this by
 *
 * - First computing global path resolution, where variable shadowing is ignored,
 *   exposed as the internal predicate `resolvePathIgnoreVariableShadowing`.
 * - `resolvePathIgnoreVariableShadowing` is sufficient to determine whether an
 *   identifier pattern resolves to a constructor/constant, since if it does, it cannot
 *   be shadowed by a variable. We expose this as the predicate `identPatIsResolvable`.
 * - Variable resolution can then be computed as a local property, using only the
 *   global information from `identPatIsResolvable`.
 * - Finally, path resolution can be computed by restricting
 *   `resolvePathIgnoreVariableShadowing` to paths that are not resolvable via
 *   variable resolution.
 */

private import rust
private import codeql.rust.elements.internal.generated.ParentChild
private import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl
private import codeql.rust.internal.CachedStages
private import codeql.rust.frameworks.stdlib.Builtins as Builtins
private import codeql.util.Option

private newtype TNamespace =
  TTypeNamespace() or
  TValueNamespace() or
  TMacroNamespace()

/**
 * A namespace.
 *
 * Either the _value_ namespace, the _type_ namespace, or the _macro_ namespace,
 * see https://doc.rust-lang.org/reference/names/namespaces.html.
 */
final class Namespace extends TNamespace {
  /** Holds if this is the value namespace. */
  predicate isValue() { this = TValueNamespace() }

  /** Holds if this is the type namespace. */
  predicate isType() { this = TTypeNamespace() }

  /** Holds if this is the macro namespace. */
  predicate isMacro() { this = TMacroNamespace() }

  /** Gets a textual representation of this namespace. */
  string toString() {
    this.isValue() and result = "value"
    or
    this.isType() and result = "type"
    or
    this.isMacro() and result = "macro"
  }
}

private newtype TSuccessorKind =
  TInternal() or
  TExternal() or
  TBoth()

/** A successor kind. */
class SuccessorKind extends TSuccessorKind {
  predicate isInternal() { this = TInternal() }

  predicate isExternal() { this = TExternal() }

  predicate isBoth() { this = TBoth() }

  predicate isInternalOrBoth() { this.isInternal() or this.isBoth() }

  predicate isExternalOrBoth() { this.isExternal() or this.isBoth() }

  string toString() {
    this.isInternal() and result = "internal"
    or
    this.isExternal() and result = "external"
    or
    this.isBoth() and result = "both"
  }
}

pragma[nomagic]
private ItemNode getAChildSuccessor0(ItemNode item, string name, SuccessorKind kind) {
  item = result.getImmediateParent() and
  name = result.getName() and
  // Associated items in `impl` and `trait` blocks are handled elsewhere
  not (item instanceof ImplOrTraitItemNode and result instanceof AssocItem) and
  // type parameters are only available inside the declaring item
  if result instanceof TypeParam
  then kind.isInternal()
  else
    if result.isPublic() or item instanceof SourceFile
    then kind.isBoth()
    else kind.isInternal()
  or
  // `Self` has scoping rules similar to type parameters and can be considered
  // an implicit type parameter child of the introducing item.
  // - https://doc.rust-lang.org/stable/reference/paths.html#r-paths.qualifiers.type-self
  // - https://doc.rust-lang.org/stable/reference/names/scopes.html#r-names.scopes.self
  (item instanceof TypeItemTypeItemNode or item instanceof ImplOrTraitItemNode) and
  name = "Self" and
  kind.isInternal() and
  result = item
}

pragma[nomagic]
private NamedItemNode getANamedNonModuleChildSuccessor(
  ItemNode item, string name, Namespace ns, int startline, int startcolumn, int endline,
  int endcolumn
) {
  result.getLocation().hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
  result = getAChildSuccessor0(item, name, _) and
  ns = result.getNamespace() and
  not result instanceof ModuleItemNode
}

pragma[nomagic]
private ItemNode getAChildSuccessor(ItemNode item, string name, SuccessorKind kind) {
  result = getAChildSuccessor0(item, name, kind) and
  // In valid Rust code, there cannot be multiple children with the same name and namespace,
  // but to safeguard against combinatorial explosions in invalid code, we always pick the
  // last child, except for modules, where we take the union.
  (
    not result instanceof NamedItemNode
    or
    result instanceof ModuleItemNode
    or
    exists(Namespace ns |
      result =
        max(NamedItemNode i, int startline, int startcolumn, int endline, int endcolumn |
          i =
            getANamedNonModuleChildSuccessor(item, name, ns, startline, startcolumn, endline,
              endcolumn)
        |
          i order by startline, startcolumn, endline, endcolumn
        )
    )
  )
}

private module UseOption = Option<Use>;

private class UseOption = UseOption::Option;

/**
 * An item that may be referred to by a path, and which is a node in
 * the _item graph_.
 *
 * The item graph is a labeled directed graph, where an edge
 *
 * ```
 * item1 --name,kind--> item2
 * ```
 *
 * means that:
 *
 * - `item2` is available _inside_ the scope of `item1` under the name `name`,
 *   when `kind` is either `internal` or `both`, and
 *
 * - `item2` is available _externally_ from `item1` under the name `name`, when
 *   `kind` is either `external` or `both`.
 *
 * For example, if we have
 *
 * ```rust
 * pub mod m1 {
 *     pub mod m2 { }
 * }
 * ```
 *
 * then there is an edge `mod m1 --m2,both--> mod m2`.
 *
 * Associated items are example of externally visible items (inside the
 * declaring item they must be `Self` prefixed), while type parameters are
 * examples of internally visible items. For example, for
 *
 * ```rust
 * mod m {
 *     pub trait<T> Trait {
 *         fn foo(&self) -> T;
 *     }
 * }
 * ```
 *
 * we have the following edges
 *
 * ```
 * mod m       --Trait,both-->    trait Trait
 * trait Trait --foo,external --> fn foo
 * trait Trait --T,internal -->   T
 * ```
 *
 * Source files are also considered nodes in the item graph, and for
 * each source file `f` there is an edge `f --name,both--> item` when `f`
 * declares `item` with the name `name`.
 *
 * For imports like
 *
 * ```rust
 * mod m1 {
 *     mod m2;
 *     use m2::foo;
 * }
 * ```
 *
 * we first generate an edge `mod m2 --name,kind--> f::item`, where `item` is
 * any item (named `name`) inside the imported source file `f`, and `kind` is
 * either `external` or `both`. Using this edge, `m2::foo` can resolve to
 * `f::foo`, which results in the edge `use m2 --foo,internal--> f::foo`
 * (would have been `external` if it was `pub use m2::foo`). Lastly, all edges
 * out of `use` nodes are lifted to predecessors in the graph, so we get
 * an edge `mod m1 --foo,internal--> f::foo`.
 *
 *
 * References:
 * - https://doc.rust-lang.org/reference/items/modules.html
 * - https://doc.rust-lang.org/reference/names/scopes.html
 * - https://doc.rust-lang.org/reference/paths.html
 * - https://doc.rust-lang.org/reference/visibility-and-privacy.html
 * - https://doc.rust-lang.org/reference/names/namespaces.html
 */
abstract class ItemNode extends Locatable {
  ItemNode() { not this.(Item).hasAttributeMacroExpansion() }

  /** Gets the (original) name of this item. */
  abstract string getName();

  /** Gets the namespace that this item belongs to, if any. */
  abstract Namespace getNamespace();

  /** Gets the visibility of this item, if any. */
  abstract Visibility getVisibility();

  abstract Attr getAnAttr();

  pragma[nomagic]
  final Attr getAttr(string name) {
    result = this.getAnAttr() and
    result.getMeta().getPath().(PathExt).isUnqualified(name)
  }

  final predicate hasAttr(string name) { exists(this.getAttr(name)) }

  /**
   * Holds if this item is public.
   *
   * This is the case when this item either has `pub` visibility (but is not
   * a `use`; a `use` itself is not visible from the outside), or when this
   * item is a variant.
   */
  predicate isPublic() {
    exists(this.getVisibility()) and
    not this instanceof Use
    or
    this instanceof Variant
    or
    this instanceof MacroItemNode
  }

  /** Gets the `i`th type parameter of this item, if any. */
  abstract TypeParam getTypeParam(int i);

  /** Gets an element that has this item as immediately enclosing item. */
  pragma[nomagic]
  Element getADescendant() {
    getImmediateParent(result) = this
    or
    exists(Element mid |
      mid = this.getADescendant() and
      getImmediateParent(result) = mid and
      not mid instanceof ItemNode
    )
  }

  /** Gets the immediately enclosing item of this item, if any. */
  pragma[nomagic]
  ItemNode getImmediateParent() { this = result.getADescendant() }

  /** Gets a child item of this item, if any. */
  ItemNode getAChild() { this = result.getImmediateParent() }

  /** Gets the immediately enclosing module (or source file) of this item. */
  pragma[nomagic]
  ModuleLikeNode getImmediateParentModule() {
    this = result.getAnItemInScope()
    or
    result = this.(SourceFileItemNode).getSuper()
  }

  /**
   * Gets a successor named `name` of the given `kind`, if any.
   *
   * `useOpt` represents the `use` statement that brought the item into scope,
   * if any.
   */
  cached
  ItemNode getASuccessor(string name, SuccessorKind kind, UseOption useOpt) {
    Stages::PathResolutionStage::ref() and
    result = getAChildSuccessor(this, name, kind) and
    useOpt.isNone()
    or
    fileImportEdge(this, name, result, kind, useOpt)
    or
    useImportEdge(this, name, result, kind) and
    useOpt.isNone()
    or
    crateDefEdge(this, name, result, kind, useOpt)
    or
    crateDependencyEdge(this, name, result) and
    kind.isInternal() and
    useOpt.isNone()
    or
    externCrateEdge(this, name, kind, result) and
    useOpt.isNone()
    or
    macroExportEdge(this, name, result) and
    kind.isBoth() and
    useOpt.isNone()
    or
    macroUseEdge(this, name, kind, useOpt, result)
    or
    // items made available through `use` are available to nodes that contain the `use`
    useOpt.asSome() =
      any(UseItemNode use_ |
        use_ = this.getASuccessor(_, _, _) and
        result = use_.getASuccessor(name, kind, _)
      )
    or
    exists(ExternCrateItemNode ec | result = ec.getASuccessor(name, kind, useOpt) |
      ec = this.getASuccessor(_, _, _)
      or
      // if the extern crate appears in the crate root, then the crate name is also added
      // to the 'extern prelude', see https://doc.rust-lang.org/reference/items/extern-crates.html
      exists(Crate c |
        ec = c.getSourceFile().(ItemNode).getASuccessor(_, _, _) and
        this = c.getASourceFile()
      )
    )
    or
    this =
      any(TraitItemNodeImpl trait |
        result = trait.getAssocItem(name)
        or
        // a trait has access to the associated items of its supertraits
        not trait.hasAssocItem(name) and
        result = trait.resolveABoundCand().getASuccessor(name).(AssocItemNode)
      ) and
    kind.isExternal() and
    useOpt.isNone()
    or
    // items made available by an implementation where `this` is the implementing type
    typeImplEdge(this, _, name, result) and
    kind.isExternal() and
    useOpt.isNone()
    or
    implEdge(this, name, result) and
    kind.isExternal() and
    useOpt.isNone()
    or
    // type parameters have access to the associated items of its bounds
    result =
      this.(TypeParamItemNodeImpl)
          .resolveABoundCand()
          .getASuccessor(name, kind, useOpt)
          .(AssocItemNode) and
    kind.isExternalOrBoth()
    or
    result =
      this.(ImplTraitTypeReprItemNodeImpl)
          .resolveABoundCand()
          .getASuccessor(name, kind, useOpt)
          .(AssocItemNode) and
    kind.isExternalOrBoth()
    or
    result = this.(TypeAliasItemNodeImpl).resolveAliasCand().getASuccessor(name, kind, useOpt) and
    kind.isExternalOrBoth()
    or
    // items declared at top-level inside macros are also available at the macro invocation sites
    exists(BlockExprItemNode be |
      this = be.getImmediateParent() and
      be = any(MacroCall mc).getMacroCallExpansion() and
      result = be.getASuccessor(name, kind, useOpt)
    )
    or
    name = "super" and
    useOpt.isNone() and
    (
      if this instanceof Module or this instanceof SourceFile
      then (
        kind.isBoth() and result = this.getImmediateParentModule()
      ) else (
        kind.isInternal() and result = this.getImmediateParentModule().getImmediateParentModule()
      )
    )
    or
    name = "self" and
    useOpt.isNone() and
    (
      if
        this instanceof Module or
        this instanceof Enum or
        this instanceof Struct or
        this instanceof Crate
      then (
        kind.isBoth() and
        result = this
      ) else (
        kind.isInternal() and
        result = this.getImmediateParentModule()
      )
    )
    or
    kind.isInternal() and
    useOpt.isNone() and
    (
      preludeEdge(this, name, result)
      or
      this instanceof SourceFile and
      builtin(name, result)
      or
      name = "crate" and
      this = result.(CrateItemNode).getASourceFile()
    )
  }

  /** Gets an _external_ successor named `name`, if any. */
  pragma[nomagic]
  ItemNode getASuccessor(string name) {
    exists(SuccessorKind kind |
      result = this.getASuccessor(name, kind, _) and
      kind.isExternalOrBoth()
    )
  }

  /** Holds if this item has a canonical path belonging to the crate `c`. */
  abstract predicate hasCanonicalPath(Crate c);

  /** Holds if this node provides a canonical path prefix for `child` in crate `c`. */
  pragma[nomagic]
  predicate providesCanonicalPathPrefixFor(Crate c, ItemNode child) {
    child.getImmediateParent() = this and
    this.hasCanonicalPath(c)
  }

  /** Holds if this node has a canonical path prefix in crate `c`. */
  pragma[nomagic]
  final predicate hasCanonicalPathPrefix(Crate c) {
    any(ItemNode parent).providesCanonicalPathPrefixFor(c, this)
  }

  /**
   * Gets the canonical path of this item, if any.
   *
   * See [The Rust Reference][1] for more details.
   *
   * [1]: https://doc.rust-lang.org/reference/paths.html#canonical-paths
   */
  cached
  abstract string getCanonicalPath(Crate c);

  /** Gets the canonical path prefix that this node provides for `child`. */
  pragma[nomagic]
  string getCanonicalPathPrefixFor(Crate c, ItemNode child) {
    this.providesCanonicalPathPrefixFor(c, child) and
    result = this.getCanonicalPath(c)
  }

  /** Gets the canonical path prefix of this node, if any. */
  pragma[nomagic]
  final string getCanonicalPathPrefix(Crate c) {
    result = any(ItemNode parent).getCanonicalPathPrefixFor(c, this)
  }

  /** Gets the location of this item. */
  Location getLocation() { result = super.getLocation() }
}

abstract class NamedItemNode extends ItemNode { }

abstract class TypeItemNode extends ItemNode { }

/** A module or a source file. */
abstract private class ModuleLikeNode extends ItemNode {
  /** Gets an item that may refer directly to items defined in this module. */
  pragma[nomagic]
  ItemNode getAnItemInScope() {
    result.getImmediateParent() = this
    or
    exists(ItemNode mid |
      mid = this.getAnItemInScope() and
      result.getImmediateParent() = mid and
      not mid instanceof ModuleLikeNode
    )
  }
}

private class SourceFileItemNode extends ModuleLikeNode instanceof SourceFile {
  pragma[nomagic]
  ModuleLikeNode getSuper() { fileImport(result.getAnItemInScope(), this) }

  override string getName() { result = "(source file)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `super`
  }

  override Visibility getVisibility() { none() }

  override Attr getAnAttr() { result = SourceFile.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

class CrateItemNode extends NamedItemNode instanceof Crate {
  /**
   * Gets the source file that defines this crate.
   */
  pragma[nomagic]
  SourceFileItemNode getSourceFile() { result = super.getSourceFile() }

  /**
   * Gets a source file that belongs to this crate.
   *
   * This is calculated as those source files that can be reached from the entry
   * file of this crate using zero or more `mod` imports, without going through
   * the entry point of some other crate.
   */
  pragma[nomagic]
  SourceFileItemNode getASourceFile() {
    result = super.getSourceFile()
    or
    exists(SourceFileItemNode mid, Module mod |
      mid = this.getASourceFile() and
      mod.getFile() = mid.getFile() and
      fileImport(mod, result) and
      not result = any(Crate other).getSourceFile()
    )
  }

  override string getName() { result = Crate.super.getName() }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `crate`
  }

  override Visibility getVisibility() { none() }

  override Attr getAnAttr() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { c = this }

  override predicate providesCanonicalPathPrefixFor(Crate c, ItemNode child) {
    this.hasCanonicalPath(c) and
    exists(SourceFileItemNode file |
      child.getImmediateParent() = file and
      not file = child.(SourceFileItemNode).getSuper() and
      file = super.getSourceFile()
    )
    or
    c = this and
    this.getName() = "core" and
    child instanceof Builtins::BuiltinType
  }

  override string getCanonicalPath(Crate c) { c = this and result = Crate.super.getName() }
}

class ExternCrateItemNode extends NamedItemNode instanceof ExternCrate {
  override string getName() {
    result = super.getRename().getName().getText()
    or
    not super.hasRename() and
    result = super.getIdentifier().getText()
  }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = ExternCrate.super.getVisibility() }

  override Attr getAnAttr() { result = ExternCrate.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

/** An item that can occur in a trait or an `impl` block. */
abstract private class AssocItemNode extends NamedItemNode instanceof AssocItem {
  /** Holds if this associated item has an implementation. */
  abstract predicate hasImplementation();

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = this.getCanonicalPathPrefix(c)
    or
    i = 1 and
    result = "::"
    or
    i = 2 and
    result = this.getName()
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    result = strictconcat(int i | i in [0 .. 2] | this.getCanonicalPathPart(c, i) order by i)
  }
}

private class ConstItemNode extends AssocItemNode instanceof Const {
  override string getName() { result = Const.super.getName().getText() }

  override predicate hasImplementation() { Const.super.hasImplementation() }

  override Namespace getNamespace() { result.isValue() }

  override Visibility getVisibility() { result = Const.super.getVisibility() }

  override Attr getAnAttr() { result = Const.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }
}

private class TypeItemTypeItemNode extends NamedItemNode, TypeItemNode instanceof TypeItem {
  override string getName() { result = TypeItem.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = TypeItem.super.getVisibility() }

  override Attr getAnAttr() { result = TypeItem.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = this.getCanonicalPathPrefix(c)
    or
    i = 1 and
    result = "::"
    or
    i = 2 and
    result = this.getName()
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    result = strictconcat(int i | i in [0 .. 2] | this.getCanonicalPathPart(c, i) order by i)
  }
}

/** An item that can be referenced with arguments. */
abstract class ParameterizableItemNode extends NamedItemNode {
  /** Gets the arity this item. */
  abstract int getArity();
}

private class VariantItemNode extends ParameterizableItemNode instanceof Variant {
  override string getName() { result = Variant.super.getName().getText() }

  override Namespace getNamespace() {
    if super.isStruct() then result.isType() else result.isValue()
  }

  override TypeParam getTypeParam(int i) {
    result = super.getEnum().getGenericParamList().getTypeParam(i)
  }

  override Visibility getVisibility() { result = super.getEnum().getVisibility() }

  override Attr getAnAttr() { result = Variant.super.getAnAttr() }

  override int getArity() { result = super.getFieldList().(TupleFieldList).getNumberOfFields() }

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = this.getCanonicalPathPrefix(c)
    or
    i = 1 and
    result = "::"
    or
    i = 2 and
    result = this.getName()
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    result = strictconcat(int i | i in [0 .. 2] | this.getCanonicalPathPart(c, i) order by i)
  }
}

class FunctionItemNode extends AssocItemNode, ParameterizableItemNode instanceof Function {
  override string getName() { result = Function.super.getName().getText() }

  override predicate hasImplementation() { Function.super.hasImplementation() }

  override Namespace getNamespace() {
    // see https://doc.rust-lang.org/reference/procedural-macros.html
    if this.hasAttr(["proc_macro", "proc_macro_attribute", "proc_macro_derive"])
    then result.isMacro()
    else result.isValue()
  }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override Visibility getVisibility() { result = Function.super.getVisibility() }

  override Attr getAnAttr() { result = Function.super.getAnAttr() }

  override int getArity() { result = super.getNumberOfParamsInclSelf() }
}

abstract class ImplOrTraitItemNode extends ItemNode {
  /** Gets a `Self` path that refers to this item. */
  cached
  Path getASelfPath() {
    Stages::PathResolutionStage::ref() and
    isUnqualifiedSelfPath(result) and
    this = unqualifiedPathLookup(result, _, _)
  }

  /** Gets an associated item belonging to this trait or `impl` block. */
  AssocItemNode getAnAssocItem() { result = this.getADescendant() }

  /** Gets the associated item named `name` belonging to this trait or `impl` block. */
  pragma[nomagic]
  AssocItemNode getAssocItem(string name) {
    result = this.getAnAssocItem() and
    result.getName() = name
  }

  /** Holds if this trait or `impl` block declares an associated item named `name`. */
  pragma[nomagic]
  predicate hasAssocItem(string name) { name = this.getAnAssocItem().getName() }
}

private TypeItemNode resolveBuiltin(TypeRepr tr) {
  tr instanceof SliceTypeRepr and
  result instanceof Builtins::SliceType
  or
  tr instanceof ArrayTypeRepr and
  result instanceof Builtins::ArrayType
  or
  tr =
    any(RefTypeRepr rtr |
      if rtr.isMut()
      then result instanceof Builtins::RefMutType
      else result instanceof Builtins::RefSharedType
    )
  or
  tr.(PtrTypeRepr).isConst() and
  result instanceof Builtins::PtrConstType
  or
  tr.(PtrTypeRepr).isMut() and
  result instanceof Builtins::PtrMutType
  or
  result.(Builtins::TupleType).getArity() = tr.(TupleTypeRepr).getNumberOfFields()
}

final class ImplItemNode extends ImplOrTraitItemNode instanceof Impl {
  Path getSelfPath() { result = super.getSelfTy().(PathTypeRepr).getPath() }

  Path getTraitPath() { result = super.getTrait().(PathTypeRepr).getPath() }

  TypeItemNode resolveSelfTyBuiltin() { result = resolveBuiltin(this.(Impl).getSelfTy()) }

  TypeItemNode resolveSelfTy() {
    result = resolvePath(this.getSelfPath())
    or
    result = this.resolveSelfTyBuiltin()
  }

  TraitItemNode resolveTraitTy() { result = resolvePath(this.getTraitPath()) }

  override string getName() { result = "(impl)" }

  override Namespace getNamespace() {
    // `impl` blocks are referred to using `Self` paths which can appear both as
    // types and as values (when the implementing type is a tuple-like struct).
    result.isType() or result.isValue()
  }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override Visibility getVisibility() { result = Impl.super.getVisibility() }

  override Attr getAnAttr() { result = Impl.super.getAnAttr() }

  TypeParamItemNode getBlanketImplementationTypeParam() { result = this.resolveSelfTy() }

  /**
   * Holds if this impl block is a [blanket implementation][1]. That is, the
   * implementation targets a generic parameter of the impl block.
   *
   * [1]: https://doc.rust-lang.org/book/ch10-02-traits.html#using-trait-bounds-to-conditionally-implement-methods
   */
  predicate isBlanketImplementation() { exists(this.getBlanketImplementationTypeParam()) }

  override predicate hasCanonicalPath(Crate c) { this.resolveSelfTy().hasCanonicalPathPrefix(c) }

  /**
   * Holds if `(c1, c2)` forms a pair of crates for the type and trait
   * being implemented, for which a canonical path can be computed.
   *
   * This is the case when either the type and the trait belong to the
   * same crate, or when they belong to different crates where one depends
   * on the other.
   */
  pragma[nomagic]
  private predicate selfTraitCratePair(Crate c1, Crate c2) {
    this.hasCanonicalPath(pragma[only_bind_into](c1)) and
    exists(TraitItemNode trait |
      trait = this.resolveTraitTy() and
      trait.hasCanonicalPath(c2) and
      if this.hasCanonicalPath(c2)
      then c1 = c2
      else (
        c2 = c1.getADependency+() or c1 = c2.getADependency+()
      )
    )
  }

  pragma[nomagic]
  private string getTraitCanonicalPath(Crate c) {
    result = this.resolveTraitTy().getCanonicalPath(c)
  }

  pragma[nomagic]
  private string getSelfCanonicalPath(Crate c) { result = this.resolveSelfTy().getCanonicalPath(c) }

  pragma[nomagic]
  private string getCanonicalPathTraitPart(Crate c) {
    exists(Crate c2 |
      this.selfTraitCratePair(c, c2) and
      result = this.getTraitCanonicalPath(c2)
    )
  }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = "<"
    or
    i = 1 and
    result = this.getSelfCanonicalPath(c)
    or
    if exists(this.getTraitPath())
    then
      i = 2 and
      result = " as "
      or
      i = 3 and
      result = this.getCanonicalPathTraitPart(c)
      or
      i = 4 and
      result = ">"
    else (
      i = 2 and
      result = ">"
    )
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    exists(int m | if exists(this.getTraitPath()) then m = 4 else m = 2 |
      result = strictconcat(int i | i in [0 .. m] | this.getCanonicalPathPart(c, i) order by i)
    )
  }
}

final class ImplTraitTypeReprItemNode extends TypeItemNode instanceof ImplTraitTypeRepr {
  pragma[nomagic]
  Path getABoundPath() {
    result = super.getTypeBoundList().getABound().getTypeRepr().(PathTypeRepr).getPath()
  }

  pragma[nomagic]
  ItemNode resolveABound() { result = resolvePath(this.getABoundPath()) }

  override string getName() { result = "(impl trait)" }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { none() }

  override Attr getAnAttr() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class ImplTraitTypeReprItemNodeImpl extends ImplTraitTypeReprItemNode {
  pragma[nomagic]
  ItemNode resolveABoundCand() { result = resolvePathCand(this.getABoundPath()) }
}

private class ModuleItemNode extends NamedItemNode, ModuleLikeNode instanceof Module {
  override string getName() { result = Module.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Module.super.getVisibility() }

  override Attr getAnAttr() { result = Module.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  override predicate providesCanonicalPathPrefixFor(Crate c, ItemNode child) {
    this.hasCanonicalPath(c) and
    (
      exists(SourceFile f |
        fileImport(this, f) and
        child = getAChildSuccessor(f, _, _)
      )
      or
      this = child.getImmediateParent()
    )
  }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = this.getCanonicalPathPrefix(c)
    or
    i = 1 and
    result = "::"
    or
    i = 2 and
    result = this.getName()
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    result = strictconcat(int i | i in [0 .. 2] | this.getCanonicalPathPart(c, i) order by i)
  }
}

private class ImplItemNodeImpl extends ImplItemNode {
  TypeItemNode resolveSelfTyCand() {
    result = resolvePathCand(this.getSelfPath())
    or
    result = this.resolveSelfTyBuiltin()
  }

  TraitItemNodeImpl resolveTraitTyCand() { result = resolvePathCand(this.getTraitPath()) }

  /**
   * Gets the associated item named `name` in this impl block or the default
   * inherited from the trait being implemented.
   */
  AssocItemNode getAssocItemOrDefault(string name) {
    result = this.getAssocItem(name)
    or
    not this.hasAssocItem(name) and
    result = this.resolveTraitTyCand().getAssocItem(name) and
    result.hasImplementation()
  }
}

private class StructItemNode extends TypeItemTypeItemNode, ParameterizableItemNode instanceof Struct
{
  override Namespace getNamespace() {
    result.isType() // the struct itself
    or
    not super.isStruct() and
    result.isValue() // the constructor
  }

  override int getArity() { result = super.getFieldList().(TupleFieldList).getNumberOfFields() }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    (
      not super.hasVisibility() and
      result = this.(Builtins::BuiltinType).getDisplayName()
      or
      (super.hasVisibility() or not this instanceof Builtins::BuiltinType) and
      result = TypeItemTypeItemNode.super.getCanonicalPath(c)
    )
  }
}

final class TraitItemNode extends ImplOrTraitItemNode, NamedItemNode, TypeItemNode instanceof Trait {
  pragma[nomagic]
  Path getABoundPath() { result = super.getATypeBound().getTypeRepr().(PathTypeRepr).getPath() }

  pragma[nomagic]
  ItemNode resolveBound(Path path) { path = this.getABoundPath() and result = resolvePath(path) }

  ItemNode resolveABound() { result = this.resolveBound(_) }

  override string getName() { result = Trait.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Trait.super.getVisibility() }

  override Attr getAnAttr() { result = Trait.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  override predicate providesCanonicalPathPrefixFor(Crate c, ItemNode child) {
    this.hasCanonicalPath(c) and
    child = this.getAnAssocItem()
  }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = "<_ as "
    or
    i = 1 and
    result = this.getCanonicalPathPrefix(c)
    or
    i = 2 and
    result = "::"
    or
    i = 3 and
    result = this.getName()
    or
    i = 4 and
    result = ">"
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    result = strictconcat(int i | i in [1 .. 3] | this.getCanonicalPathPart(c, i) order by i)
  }

  language[monotonicAggregates]
  override string getCanonicalPathPrefixFor(Crate c, ItemNode child) {
    this.providesCanonicalPathPrefixFor(c, child) and
    result = strictconcat(int i | i in [0 .. 4] | this.getCanonicalPathPart(c, i) order by i)
  }
}

final private class TraitItemNodeImpl extends TraitItemNode {
  pragma[nomagic]
  ItemNode resolveABoundCand() { result = resolvePathCand(this.getABoundPath()) }
}

final class TypeAliasItemNode extends TypeItemNode, AssocItemNode instanceof TypeAlias {
  pragma[nomagic]
  ItemNode resolveAlias() { result = resolvePath(super.getTypeRepr().(PathTypeRepr).getPath()) }

  override string getName() { result = TypeAlias.super.getName().getText() }

  override predicate hasImplementation() { super.hasTypeRepr() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = TypeAlias.super.getVisibility() }

  override Attr getAnAttr() { result = TypeAlias.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class TypeAliasItemNodeImpl extends TypeAliasItemNode instanceof TypeAlias {
  pragma[nomagic]
  ItemNode resolveAliasCand() {
    result = resolvePathCand(super.getTypeRepr().(PathTypeRepr).getPath())
  }
}

private class UseItemNode extends ItemNode instanceof Use {
  override string getName() { result = "(use)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { result = Use.super.getVisibility() }

  override Attr getAnAttr() { result = Use.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class BlockExprItemNode extends ItemNode instanceof BlockExpr {
  override string getName() { result = "(block expr)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }

  override Attr getAnAttr() { result = BlockExpr.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

pragma[nomagic]
private Path getWherePredPath(WherePred wp) { result = wp.getTypeRepr().(PathTypeRepr).getPath() }

final class TypeParamItemNode extends NamedItemNode, TypeItemNode instanceof TypeParam {
  /** Gets a where predicate for this type parameter, if any */
  pragma[nomagic]
  private WherePred getAWherePred() {
    exists(ItemNode declaringItem |
      this = resolvePath(getWherePredPath(result)) and
      result = declaringItem.getADescendant() and
      this = declaringItem.getADescendant()
    )
  }

  pragma[nomagic]
  TypeBound getTypeBoundAt(int i, int j) {
    exists(TypeBoundList tbl | result = tbl.getBound(j) |
      tbl = super.getTypeBoundList() and i = 0
      or
      exists(WherePred wp |
        wp = this.getAWherePred() and
        tbl = wp.getTypeBoundList() and
        wp = any(WhereClause wc).getPredicate(i)
      )
    )
  }

  pragma[nomagic]
  Path getABoundPath() { result = this.getTypeBoundAt(_, _).getTypeRepr().(PathTypeRepr).getPath() }

  pragma[nomagic]
  ItemNode resolveBound(int index) {
    result =
      rank[index + 1](int i, int j |
        |
        resolvePath(this.getTypeBoundAt(i, j).getTypeRepr().(PathTypeRepr).getPath()) order by i, j
      )
  }

  ItemNode resolveABound() { result = resolvePath(this.getABoundPath()) }

  override string getName() { result = TypeParam.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { none() }

  override Attr getAnAttr() { result = TypeParam.super.getAnAttr() }

  override TypeParam getTypeParam(int i) { none() }

  override Location getLocation() { result = TypeParam.super.getName().getLocation() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

final private class TypeParamItemNodeImpl extends TypeParamItemNode instanceof TypeParam {
  /** Gets a where predicate for this type parameter, if any */
  pragma[nomagic]
  private WherePred getAWherePredCand() {
    exists(ItemNode declaringItem |
      this = resolvePathCand(getWherePredPath(result)) and
      result = declaringItem.getADescendant() and
      this = declaringItem.getADescendant()
    )
  }

  pragma[nomagic]
  TypeBound getTypeBoundAtCand(int i, int j) {
    exists(TypeBoundList tbl | result = tbl.getBound(j) |
      tbl = super.getTypeBoundList() and i = 0
      or
      exists(WherePred wp |
        wp = this.getAWherePredCand() and
        tbl = wp.getTypeBoundList() and
        wp = any(WhereClause wc).getPredicate(i)
      )
    )
  }

  pragma[nomagic]
  Path getABoundPathCand() {
    result = this.getTypeBoundAtCand(_, _).getTypeRepr().(PathTypeRepr).getPath()
  }

  pragma[nomagic]
  ItemNode resolveABoundCand() { result = resolvePathCand(this.getABoundPathCand()) }
}

abstract private class MacroItemNode extends NamedItemNode {
  override Namespace getNamespace() { result.isMacro() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  bindingset[c]
  private string getCanonicalPathPart(Crate c, int i) {
    i = 0 and
    result = this.getCanonicalPathPrefix(c)
    or
    i = 1 and
    result = "::"
    or
    i = 2 and
    result = this.getName()
  }

  language[monotonicAggregates]
  override string getCanonicalPath(Crate c) {
    this.hasCanonicalPath(c) and
    result = strictconcat(int i | i in [0 .. 2] | this.getCanonicalPathPart(c, i) order by i)
  }
}

private class MacroRulesItemNode extends MacroItemNode instanceof MacroRules {
  override string getName() { result = MacroRules.super.getName().getText() }

  override Visibility getVisibility() { result = MacroRules.super.getVisibility() }

  override Attr getAnAttr() { result = MacroRules.super.getAnAttr() }
}

private class MacroDefItemNode extends MacroItemNode instanceof MacroDef {
  override string getName() { result = MacroDef.super.getName().getText() }

  override Visibility getVisibility() { result = MacroDef.super.getVisibility() }

  override Attr getAnAttr() { result = MacroDef.super.getAnAttr() }
}

/** Holds if `f` is available as `mod name;` inside `folder`. */
pragma[nomagic]
private predicate fileModule(SourceFile f, string name, Folder folder) {
  exists(File file | file = f.getFile() |
    file.getBaseName() = name + ".rs" and
    folder = file.getParentContainer()
    or
    exists(Folder encl |
      file.getBaseName() = "mod.rs" and
      encl = file.getParentContainer() and
      name = encl.getBaseName() and
      folder = encl.getParentContainer()
    )
  )
}

bindingset[name, folder]
pragma[inline_late]
private predicate fileModuleInlineLate(SourceFile f, string name, Folder folder) {
  fileModule(f, name, folder)
}

/**
 * Gets the `Meta` of the module `m`'s [path attribute][1].
 *
 * [1]: https://doc.rust-lang.org/reference/items/modules.html#r-items.mod.outlined.path
 */
private Meta getPathAttrMeta(Module m) {
  result = m.getAnAttr().getMeta() and
  result.getPath().getText() = "path"
}

/**
 * Holds if `m` is a `mod name;` module declaration, where the corresponding
 * module file needs to be looked up in `lookup` or one of its descandants.
 */
private predicate modImport0(Module m, string name, Folder lookup) {
  exists(File f, Folder parent, string fileName |
    f = m.getFile() and
    not m.hasItemList() and
    not exists(getPathAttrMeta(m)) and
    name = m.getName().getText() and
    parent = f.getParentContainer() and
    fileName = f.getStem()
  |
    // sibling import
    lookup = parent and
    (
      m.getFile() = any(CrateItemNode c).getSourceFile().getFile()
      or
      m.getFile().getBaseName() = "mod.rs"
    )
    or
    // child import
    lookup = parent.getFolder(fileName)
  )
}

/**
 * Holds if `m` is a `mod name;` module declaration, which happens inside a
 * nested module, and `pred -> succ` is a module edge leading to `m`.
 */
private predicate modImportNested(ModuleItemNode m, ModuleItemNode pred, ModuleItemNode succ) {
  pred.getAnItemInScope() = succ and
  (
    modImport0(m, _, _) and
    succ = m
    or
    modImportNested(m, succ, _)
  )
}

/**
 * Holds if `m` is a `mod name;` module declaration, which happens inside a
 * nested module, where `ancestor` is a reflexive transitive ancestor module
 * of `m` with corresponding lookup folder `lookup`.
 */
private predicate modImportNestedLookup(Module m, ModuleItemNode ancestor, Folder lookup) {
  modImport0(m, _, lookup) and
  modImportNested(m, ancestor, _) and
  not modImportNested(m, _, ancestor)
  or
  exists(ModuleItemNode m1, Folder mid |
    modImportNestedLookup(m, m1, mid) and
    modImportNested(m, m1, ancestor) and
    lookup = mid.getFolder(m1.getName())
  )
}

private predicate pathAttrImport(Folder f, Module m, string relativePath) {
  exists(Meta meta |
    f = m.getFile().getParentContainer() and
    meta = getPathAttrMeta(m) and
    relativePath = meta.getExpr().(LiteralExpr).getTextValue().regexpCapture("\"(.+)\"", 1)
  )
}

private predicate shouldAppend(Folder f, string relativePath) { pathAttrImport(f, _, relativePath) }

/** Holds if `m` is a `mod name;` item importing file `f`. */
pragma[nomagic]
predicate fileImport(Module m, SourceFile f) {
  exists(string name, Folder parent |
    modImport0(m, name, _) and
    fileModuleInlineLate(f, name, parent)
  |
    // `m` is not inside a nested module
    modImport0(m, name, parent) and
    not modImportNested(m, _, _)
    or
    // `m` is inside a nested module
    modImportNestedLookup(m, m, parent)
  )
  or
  exists(Folder folder, string relativePath |
    pathAttrImport(folder, m, relativePath) and
    f.getFile() = Folder::Append<shouldAppend/2>::append(folder, relativePath)
  )
}

/**
 * Holds if `mod` is a `mod name;` item targeting a file resulting in `item` being
 * in scope under the name `name`.
 */
pragma[nomagic]
private predicate fileImportEdge(
  Module mod, string name, ItemNode item, SuccessorKind kind, UseOption useOpt
) {
  exists(SourceFileItemNode f |
    fileImport(mod, f) and
    item = f.getASuccessor(name, kind, useOpt)
  )
}

/**
 * Holds if crate `c` defines the item `i` named `name`.
 */
pragma[nomagic]
private predicate crateDefEdge(
  CrateItemNode c, string name, ItemNode i, SuccessorKind kind, UseOption useOpt
) {
  i = c.getSourceFile().getASuccessor(name, kind, useOpt) and
  kind.isExternalOrBoth()
}

private class BuiltinSourceFile extends SourceFileItemNode {
  BuiltinSourceFile() { this.getFile().getParentContainer() instanceof Builtins::BuiltinsFolder }
}

pragma[nomagic]
private predicate crateDependency(SourceFileItemNode file, string name, CrateItemNode dep) {
  exists(CrateItemNode c | dep = c.(Crate).getDependency(name) | file = c.getASourceFile())
}

pragma[nomagic]
private predicate hasDeclOrDep(SourceFileItemNode file, string name) {
  declaresDirectly(file, TTypeNamespace(), name) or
  crateDependency(file, name, _)
}

/**
 * Holds if `file` depends on crate `dep` named `name`.
 */
pragma[nomagic]
private predicate crateDependencyEdge(SourceFileItemNode file, string name, CrateItemNode dep) {
  crateDependency(file, name, dep)
  or
  // As a fallback, give all files access to crates that do not conflict with known dependencies
  // and declarations. This is in order to workaround incomplete crate dependency information
  // provided by the extractor, as well as `CrateItemNode.getASourceFile()` being unable to map
  // a given file to its crate (for example, if the file is `mod` imported inside a macro that the
  // extractor is unable to expand).
  name = dep.getName() and
  not hasDeclOrDep(file, name)
}

/**
 * Gets a `UseTree` that is nested under `tree`, and which needs to be resolved
 * relative to the path of `tree`.
 *
 * `tree` is restricted to either having a path or being a direct child of some
 * `use` statement without a path.
 */
private UseTree getAUseTreeUseTree(UseTree tree) {
  result = tree.getUseTreeList().getAUseTree() and
  (if tree.hasPath() then any() else tree = any(Use u).getUseTree())
  or
  exists(UseTree mid |
    mid = getAUseTreeUseTree(tree) and
    not mid.hasPath() and
    result = mid.getUseTreeList().getAUseTree()
  )
}

private predicate useTreeDeclares(UseTree tree, string name) {
  not tree.isGlob() and
  not exists(tree.getUseTreeList()) and
  (
    name = tree.getRename().getName().getText() and
    name != "_"
    or
    not tree.hasRename() and
    name = tree.getPath().getText()
  )
  or
  exists(UseTree mid |
    useTreeDeclares(mid, name) and
    mid = getAUseTreeUseTree(tree)
  )
}

/**
 * Holds if `item` explicitly declares a sub item named `name` in the
 * namespace `ns`. This excludes items declared by `use` statements.
 */
pragma[nomagic]
private predicate declaresDirectly(ItemNode item, Namespace ns, string name) {
  exists(ItemNode child, SuccessorKind kind |
    child = getAChildSuccessor(item, name, kind) and
    child.getNamespace() = ns and
    kind.isInternalOrBoth()
  )
}

/**
 * Holds if `item` explicitly declares a sub item named `name` in the
 * namespace `ns`. This includes items declared by `use` statements,
 * except for glob imports.
 */
pragma[nomagic]
private predicate declares(ItemNode item, Namespace ns, string name) {
  declaresDirectly(item, ns, name)
  or
  exists(ItemNode child |
    child.getImmediateParent() = item and
    useTreeDeclares(child.(Use).getUseTree(), name) and
    exists(ns) // `use foo::bar` can refer to both a value and a type
  )
}

/**
 * A `Path` or an `IdentPat`.
 *
 * `IdentPat`s are included in order to resolve unqualified references to
 * constructors in patterns.
 */
abstract class PathExt extends AstNode {
  abstract string getText();

  /** Holds if this is an unqualified path with the textual value `name`. */
  pragma[nomagic]
  abstract predicate isUnqualified(string name);

  abstract Path getQualifier();

  abstract string toStringDebug();

  /**
   * Holds if this is an unqualified path with the textual value `name` and
   * enclosing item `encl`.
   */
  pragma[nomagic]
  predicate isUnqualified(string name, ItemNode encl) {
    this.isUnqualified(name) and
    encl.getADescendant() = this
  }

  pragma[nomagic]
  predicate isCratePath(string name, ItemNode encl) {
    name = "crate" and
    this.isUnqualified(name, encl)
  }

  pragma[nomagic]
  predicate isDollarCrate() { this.isUnqualified("$crate", _) }
}

private class PathExtPath extends PathExt instanceof Path {
  override string getText() { result = Path.super.getText() }

  override predicate isUnqualified(string name) {
    not exists(Path.super.getQualifier()) and
    not exists(UseTree tree |
      tree.hasPath() and
      this = getAUseTreeUseTree(tree).getPath().getQualifier*()
    ) and
    // For a `<Type as Trait>` path we resolve the trait name
    name = [Path.super.getText(), Path.super.getSegment().getTraitTypeRepr().getPath().getText()]
  }

  override Path getQualifier() { result = Path.super.getQualifier() }

  override string toStringDebug() { result = Path.super.toStringDebug() }
}

private class PathExtIdentPat extends PathExt, IdentPat {
  override string getText() { result = this.getName().getText() }

  override predicate isUnqualified(string name) { name = this.getText() }

  override Path getQualifier() { none() }

  override string toStringDebug() { result = this.getText() }
}

private predicate isModule(ItemNode m) { m instanceof Module }

/** Holds if source file `source` contains the module `m`. */
private predicate rootHasModule(SourceFileItemNode source, ItemNode m) =
  doublyBoundedFastTC(hasChild/2, isSourceFile/1, isModule/1)(source, m)

pragma[nomagic]
private ItemNode getOuterScope(ItemNode i) {
  // nested modules do not have unqualified access to items from outer modules,
  // except for items declared at top-level in the root module
  rootHasModule(result, i)
  or
  not i instanceof Module and
  result = i.getImmediateParent()
}

/**
 * Holds if _some_ unqualified path in `encl` references an item named `name`,
 * and `name` may be looked up in the `ns` namespace inside `ancestor`.
 */
pragma[nomagic]
private predicate unqualifiedPathLookup(ItemNode ancestor, string name, Namespace ns, ItemNode encl) {
  // lookup in the immediately enclosing item
  exists(PathExt path |
    path.isUnqualified(name, encl) and
    ancestor = encl and
    not name = ["crate", "$crate", "super", "self"]
  |
    pathUsesNamespace(path, ns)
    or
    not pathUsesNamespace(path, _)
  )
  or
  // lookup in an outer scope, but only if the item is not declared in inner scope
  exists(ItemNode mid |
    unqualifiedPathLookup(mid, name, ns, encl) and
    not declares(mid, ns, name)
  |
    ancestor = getOuterScope(mid)
    or
    ns.isMacro() and
    ancestor = mid.getImmediateParentModule()
  )
}

pragma[nomagic]
private ItemNode getASuccessor(
  ItemNode pred, string name, Namespace ns, SuccessorKind kind, UseOption useOpt
) {
  result = pred.getASuccessor(name, kind, useOpt) and
  ns = result.getNamespace()
}

private predicate isSourceFile(ItemNode source) { source instanceof SourceFileItemNode }

private predicate hasCratePath(ItemNode i) { any(PathExt path).isCratePath(_, i) }

private predicate hasChild(ItemNode parent, ItemNode child) { child.getImmediateParent() = parent }

private predicate sourceFileHasCratePathTc(ItemNode i1, ItemNode i2) =
  doublyBoundedFastTC(hasChild/2, isSourceFile/1, hasCratePath/1)(i1, i2)

/**
 * Holds if the unqualified path `p` references a keyword item named `name`, and
 * `name` may be looked up inside `ancestor`.
 */
pragma[nomagic]
private predicate keywordLookup(ItemNode ancestor, string name, PathExt p) {
  // For `crate`, jump directly to the root module
  exists(ItemNode i | p.isCratePath(name, i) |
    ancestor instanceof SourceFile and
    ancestor = i
    or
    sourceFileHasCratePathTc(ancestor, i)
  )
  or
  name = ["super", "self"] and
  p.isUnqualified(name, ancestor)
}

pragma[nomagic]
private ItemNode unqualifiedPathLookup(PathExt p, Namespace ns, SuccessorKind kind) {
  exists(ItemNode ancestor, string name |
    result = getASuccessor(ancestor, pragma[only_bind_into](name), ns, kind, _) and
    kind.isInternalOrBoth()
  |
    exists(ItemNode encl |
      unqualifiedPathLookup(ancestor, name, ns, encl) and
      p.isUnqualified(pragma[only_bind_into](name), encl)
    )
    or
    keywordLookup(ancestor, name, p) and exists(ns)
  )
}

pragma[nomagic]
private predicate isUnqualifiedSelfPath(PathExt path) { path.isUnqualified("Self") }

/** Provides the input to `TraitIsVisible`. */
signature predicate relevantTraitVisibleSig(Element element, Trait trait);

/**
 * Provides the `traitIsVisible` predicate for determining if a trait is visible
 * at a given element.
 */
module TraitIsVisible<relevantTraitVisibleSig/2 relevantTraitVisible> {
  private newtype TNode =
    TTrait(Trait t) { relevantTraitVisible(_, t) } or
    TItemNode(ItemNode i) or
    TElement(Element e) { relevantTraitVisible(e, _) }

  private predicate isTrait(TNode n) { n instanceof TTrait }

  private predicate step(TNode n1, TNode n2) {
    exists(Trait t1, ItemNode i2 |
      n1 = TTrait(t1) and
      n2 = TItemNode(i2) and
      t1 = i2.getASuccessor(_, _, _)
    )
    or
    exists(ItemNode i1, ItemNode i2 |
      n1 = TItemNode(i1) and
      n2 = TItemNode(i2) and
      i1 = getOuterScope(i2)
    )
    or
    exists(ItemNode i1, Element e2 |
      n1 = TItemNode(i1) and
      n2 = TElement(e2) and
      i1.getADescendant() = e2
    )
  }

  private predicate isElement(TNode n) { n instanceof TElement }

  private predicate traitIsVisibleTC(TNode trait, TNode element) =
    doublyBoundedFastTC(step/2, isTrait/1, isElement/1)(trait, element)

  pragma[nomagic]
  private predicate relevantTraitVisibleLift(TNode trait, TElement element) {
    exists(Trait t, Element e |
      trait = TTrait(t) and
      element = TElement(e) and
      relevantTraitVisible(e, t)
    )
  }

  /** Holds if the trait `trait` is visible at `element`. */
  pragma[nomagic]
  predicate traitIsVisible(Element element, Trait trait) {
    exists(TNode t, TNode e |
      traitIsVisibleTC(t, e) and
      relevantTraitVisibleLift(t, e) and
      t = TTrait(trait) and
      e = TElement(element)
    )
  }
}

private module DollarCrateResolution {
  pragma[nomagic]
  private predicate isDollarCrateSupportedMacroExpansion(Path macroDefPath, AstNode expansion) {
    exists(MacroCall mc |
      expansion = mc.getMacroCallExpansion() and
      macroDefPath = mc.getPath()
    )
    or
    exists(ItemNode type |
      expansion = type.(TypeItem).getDeriveMacroExpansion(_) and
      macroDefPath = type.getAttr("derive").getMeta().getPath()
    )
  }

  private predicate hasParent(AstNode child, AstNode parent) { parent = child.getParentNode() }

  private predicate isDollarCrateSupportedMacroExpansion(AstNode expansion) {
    isDollarCrateSupportedMacroExpansion(_, expansion)
  }

  private predicate isDollarCratePath(PathExt p) { p.isDollarCrate() }

  private predicate isInDollarCrateMacroExpansion(PathExt p, AstNode expansion) =
    doublyBoundedFastTC(hasParent/2, isDollarCratePath/1, isDollarCrateSupportedMacroExpansion/1)(p,
      expansion)

  pragma[nomagic]
  private predicate isInDollarCrateMacroExpansionFromFile(File macroDefFile, PathExt p) {
    exists(Path macroDefPath, AstNode expansion |
      isDollarCrateSupportedMacroExpansion(macroDefPath, expansion) and
      isInDollarCrateMacroExpansion(p, expansion) and
      macroDefFile = resolvePathCand(macroDefPath).getFile()
    )
  }

  /**
   * Holds if `p` is a `$crate` path, and it may resolve to `crate`.
   *
   * The reason why we cannot be sure is that we need to consider all ancestor macro
   * calls.
   */
  pragma[nomagic]
  predicate resolveDollarCrate(PathExt p, CrateItemNode crate) {
    isInDollarCrateMacroExpansionFromFile(crate.getASourceFile().getFile(), p)
  }
}

pragma[nomagic]
private ItemNode resolvePathCand0(PathExt path, Namespace ns) {
  exists(ItemNode res |
    res = unqualifiedPathLookup(path, ns, _) and
    if
      // `Self` paths that are not used as qualifiers (for instance `Self` in
      // `fn(..) -> Self`) should resolve to the type being implemented.
      not any(PathExt parent).getQualifier() = path and
      isUnqualifiedSelfPath(path) and
      res instanceof ImplItemNode
    then result = res.(ImplItemNodeImpl).resolveSelfTyCand()
    else result = res
  )
  or
  DollarCrateResolution::resolveDollarCrate(path, result) and
  ns = result.getNamespace()
  or
  result = resolvePathCandQualified(_, _, path, ns)
  or
  result = resolveUseTreeListItem(_, _, path, _) and
  ns = result.getNamespace()
  or
  exists(PathSegment seg |
    seg = path.(Path).getSegment() and
    result = resolveBuiltin(seg.getTypeRepr()) and
    not seg.hasTraitTypeRepr() and
    ns.isType()
  )
}

pragma[nomagic]
private ItemNode resolvePathCandQualifier(PathExt qualifier, PathExt path, string name) {
  qualifier = path.getQualifier() and
  result = resolvePathCand(qualifier) and
  name = path.getText()
}

bindingset[l]
pragma[inline_late]
private ModuleLikeNode getAnAncestorModule(Locatable l) {
  exists(ItemNode encl |
    encl.getADescendant() = l and
    result = encl.getImmediateParentModule*()
  )
}

bindingset[i]
pragma[inline_late]
private ModuleLikeNode getParent(ItemNode i) { result = i.getImmediateParent() }

/**
 * Holds if resolving a qualified path at `l` to the item `i` with successor kind
 * `kind` respects visibility.
 *
 * This is the case when either `i` is externally visible (e.g. a `pub` function),
 * or when `i` (or the `use` statement, `useOpt`, that brought `i` into scope) is
 * in an ancestor module of `l`.
 */
bindingset[l, i, kind, useOpt]
pragma[inline_late]
private predicate checkQualifiedVisibility(
  Locatable l, ItemNode i, SuccessorKind kind, UseOption useOpt
) {
  kind.isExternalOrBoth()
  or
  exists(AstNode n | getAnAncestorModule(l) = getParent(n) |
    n = useOpt.asSome()
    or
    useOpt.isNone() and
    n = i
  ) and
  not i instanceof TypeParam
}

/**
 * Gets the item that `path` resolves to in `ns` when `qualifier` is the
 * qualifier of `path` and `qualifier` resolves to `q`, if any.
 */
pragma[nomagic]
private ItemNode resolvePathCandQualified(PathExt qualifier, ItemNode q, PathExt path, Namespace ns) {
  exists(string name, SuccessorKind kind, UseOption useOpt |
    q = resolvePathCandQualifier(qualifier, path, name) and
    result = getASuccessor(q, name, ns, kind, useOpt) and
    checkQualifiedVisibility(path, result, kind, useOpt)
  )
}

/** Holds if path `p` must be looked up in namespace `n`. */
private predicate pathUsesNamespace(PathExt p, Namespace n) {
  n.isValue() and
  (
    p = any(PathExpr pe).getPath()
    or
    p = any(TupleStructPat tsp).getPath()
    or
    p instanceof PathExtIdentPat
  )
  or
  n.isType() and
  (
    p = any(Visibility v).getPath()
    or
    p = any(StructExpr re).getPath()
    or
    p = any(PathTypeRepr ptr).getPath()
    or
    p = any(StructPat rp).getPath()
    or
    p =
      any(UseTree use |
        use.isGlob()
        or
        use.hasUseTreeList()
      ).getPath()
    or
    p = any(Path parent).getQualifier()
  )
  or
  n.isMacro() and
  (
    p = any(MacroCall mc).getPath()
    or
    p = any(Meta m).getPath()
  )
}

/**
 * Holds if crate `crate` exports the macro `macro` named `name` using
 * a `#[macro_export]` attribute.
 *
 * See https://lukaswirth.dev/tlborm/decl-macros/minutiae/import-export.html.
 */
pragma[nomagic]
private predicate macroExportEdge(CrateItemNode crate, string name, MacroItemNode macro) {
  crate.getASourceFile().getFile() = macro.getFile() and
  macro.hasAttr("macro_export") and
  name = macro.getName()
}

/**
 * Holds if a `Self` path inside `impl` might refer to a function named `name`
 * from another impl block.
 */
pragma[nomagic]
private predicate relevantSelfFunctionName(ImplItemNodeImpl impl, string name) {
  any(Path path | path.getQualifier() = impl.getASelfPath()).getText() = name and
  not impl.hasAssocItem(name)
}

/**
 * Holds if `impl` has a `node` available externally at `name`.
 *
 * Since `Self` in an impl block resolves to the impl block, this corresponds to
 * the items that should be available on `Self` within the `impl` block.
 */
private predicate implEdge(ImplItemNodeImpl impl, string name, ItemNode node) {
  node = impl.getAssocItemOrDefault(name)
  or
  // Associated types from the implemented trait are available on `Self`.
  not impl.hasAssocItem(name) and
  node = impl.resolveTraitTyCand().getASuccessor(name).(TypeAliasItemNode)
  or
  // Items available on the implementing type are available on `Self`. We only
  // add these edges when they are relevant. If a type has `n` impl blocks with
  // `m` functions each, we would otherwise end up always constructing something
  // proportional to `O(n * m)`.
  relevantSelfFunctionName(impl, name) and
  node = impl.resolveSelfTyCand().getASuccessor(name)
}

/**
 * Holds if item `i` contains a `mod` or `extern crate` definition that
 * makes the macro `macro` named `name` available using a `#[macro_use]`
 * attribute.
 *
 * See https://lukaswirth.dev/tlborm/decl-macros/minutiae/import-export.html.
 */
pragma[nomagic]
private predicate macroUseEdge(
  ItemNode i, string name, SuccessorKind kind, UseOption useOpt, MacroItemNode macro
) {
  exists(ItemNode m |
    m = i.getASuccessor(_, _, useOpt) and
    m.hasAttr("macro_use")
  |
    macro = m.(ModuleItemNode).getASuccessor(name, kind, _)
    or
    macro = m.(ExternCrateItemNode).getASuccessor(_, _, _).getASuccessor(name, kind, _)
  )
}

/**
 * Gets an item that `path` may resolve to, if any.
 *
 * Unlike `resolvePath`, this predicate does not attempt to make resolution
 * of qualifiers consistent with resolution of their parents, and should
 * only be used internally within this library.
 *
 * Note that the path resolution logic cannot use `resolvePath`, as that would
 * result in non-monotonic recursion.
 */
pragma[nomagic]
private ItemNode resolvePathCand(PathExt path) {
  exists(Namespace ns |
    result = resolvePathCand0(path, ns) and
    if path = any(ImplItemNode i).getSelfPath()
    then
      result instanceof TypeItemNode and
      not result instanceof TraitItemNode
    else
      if path = any(ImplItemNode i).getTraitPath()
      then result instanceof TraitItemNode
      else
        if path = any(PathTypeRepr p).getPath()
        then result instanceof TypeItemNode
        else
          if path instanceof IdentPat
          then
            result instanceof VariantItemNode or
            result instanceof StructItemNode or
            result instanceof ConstItemNode
          else any()
  |
    pathUsesNamespace(path, ns)
    or
    not pathUsesNamespace(path, _)
  ) and
  (
    not path = CallExprImpl::getFunctionPath(_)
    or
    exists(CallExpr ce |
      path = CallExprImpl::getFunctionPath(ce) and
      result.(ParameterizableItemNode).getArity() = ce.getArgList().getNumberOfArgs()
    )
  )
}

/** Get a trait that should be visible when `path` resolves to `node`, if any. */
private Trait getResolvePathTraitUsed(PathExt path, AssocItemNode node) {
  exists(TypeItemNode type, ItemNode qual, ImplItemNodeImpl impl |
    node = resolvePathCandQualified(_, qual, path, _) and
    type = [qual, qual.(ImplItemNodeImpl).resolveSelfTyCand()] and
    typeImplEdge(type, impl, _, node) and
    result = impl.resolveTraitTyCand()
  )
}

private predicate pathTraitUsed(Element path, Trait trait) {
  trait = getResolvePathTraitUsed(path, _)
}

/** INTERNAL: Do not use; use `resolvePath` instead. */
cached
ItemNode resolvePathIgnoreVariableShadowing(PathExt path) {
  result = resolvePathCand(path) and
  not path = any(Path parent | exists(resolvePathCand(parent))).getQualifier() and
  (
    // When the result is an associated item of a trait implementation the
    // implemented trait must be visible.
    TraitIsVisible<pathTraitUsed/2>::traitIsVisible(path, getResolvePathTraitUsed(path, result))
    or
    not exists(getResolvePathTraitUsed(path, result))
  )
  or
  // if `path` is the qualifier of a resolvable `parent`, then we should
  // resolve `path` to something consistent with what `parent` resolves to
  exists(PathExt parent |
    resolvePathCandQualified(path, result, parent, _) = resolvePathIgnoreVariableShadowing(parent)
  )
}

/**
 * Holds if `ip` resolves to some constructor or constant.
 */
// use `forceLocal` once we implement overlay support
pragma[nomagic]
predicate identPatIsResolvable(IdentPat ip) { exists(resolvePathIgnoreVariableShadowing(ip)) }

/** Gets the item that `path` resolves to, if any. */
pragma[nomagic]
ItemNode resolvePath(PathExt path) {
  result = resolvePathIgnoreVariableShadowing(path) and
  not path = any(VariableAccess va).(PathExpr).getPath()
}

private predicate isUseTreeSubPath(UseTree tree, PathExt path) {
  path = tree.getPath()
  or
  exists(PathExt mid |
    isUseTreeSubPath(tree, mid) and
    path = mid.getQualifier()
  )
}

pragma[nomagic]
private predicate isUseTreeSubPathUnqualified(UseTree tree, PathExt path, string name) {
  isUseTreeSubPath(tree, path) and
  not exists(path.getQualifier()) and
  name = path.getText()
}

pragma[nomagic]
private ItemNode resolveUseTreeListItem(Use use, UseTree tree, PathExt path, SuccessorKind kind) {
  exists(UseOption useOpt | checkQualifiedVisibility(use, result, kind, useOpt) |
    exists(UseTree midTree, ItemNode mid, string name |
      mid = resolveUseTreeListItem(use, midTree) and
      tree = getAUseTreeUseTree(midTree) and
      isUseTreeSubPathUnqualified(tree, path, pragma[only_bind_into](name)) and
      result = mid.getASuccessor(pragma[only_bind_into](name), kind, useOpt)
    )
    or
    exists(ItemNode q, string name |
      q = resolveUseTreeListItemQualifier(use, tree, path, name) and
      result = q.getASuccessor(name, kind, useOpt)
    )
  )
}

pragma[nomagic]
private ItemNode resolveUseTreeListItemQualifier(Use use, UseTree tree, PathExt path, string name) {
  result = resolveUseTreeListItem(use, tree, path.getQualifier(), _) and
  name = path.getText()
}

private UseTree getAUseUseTree(Use use) {
  exists(UseTree root | root = use.getUseTree() |
    if root.hasPath() then result = root else result = getAUseTreeUseTree(root)
  )
}

pragma[nomagic]
private ItemNode resolveUseTreeListItem(Use use, UseTree tree) {
  exists(Path path | path = tree.getPath() |
    tree = getAUseUseTree(use) and
    result = resolvePathCand(path)
    or
    result = resolveUseTreeListItem(use, tree, path, _)
  )
  or
  exists(UseTree midTree |
    // `use foo::{bar, *}`; midTree = `foo` and tree = `*`
    result = resolveUseTreeListItem(use, midTree) and
    tree = getAUseTreeUseTree(midTree) and
    tree.isGlob() and
    not tree.hasPath()
  )
}

/** Holds if `use` imports `item` as `name`. */
pragma[nomagic]
private predicate useImportEdge(Use use, string name, ItemNode item, SuccessorKind kind) {
  (if use.hasVisibility() then kind.isBoth() else kind.isInternal()) and
  exists(UseTree tree, ItemNode used |
    used = resolveUseTreeListItem(use, tree) and
    not tree.hasUseTreeList() and
    if tree.isGlob()
    then
      exists(ItemNode encl, Namespace ns, SuccessorKind kind1, UseOption useOpt |
        encl.getADescendant() = use and
        item = getASuccessor(used, name, ns, kind1, useOpt) and
        checkQualifiedVisibility(use, item, kind1, useOpt) and
        // glob imports can be shadowed
        not declares(encl, ns, name) and
        not name = ["super", "self", "Self"]
      )
    else (
      item = used and
      (
        not tree.hasRename() and
        exists(string pathName |
          pathName = tree.getPath().getText() and
          if pathName = "self" then name = item.getName() else name = pathName
        )
        or
        exists(Rename rename | rename = tree.getRename() |
          name = rename.getName().getText()
          or
          // When the rename doesn't have a name it's an underscore import. This
          // makes the imported item visible but unnameable. We represent this
          // by using the name `_` which can never occur in a path.  See also:
          // https://doc.rust-lang.org/reference/items/use-declarations.html#r-items.use.as-underscore
          not rename.hasName() and
          name = "_"
        )
      )
    )
  )
}

/** Holds if `ec` imports `crate` as `name`. */
pragma[nomagic]
private predicate externCrateEdge(
  ExternCrateItemNode ec, string name, SuccessorKind kind, CrateItemNode crate
) {
  name = ec.getName() and
  (if ec.isPublic() then kind.isBoth() else kind.isInternal()) and
  exists(SourceFile f, string s |
    ec.getFile() = f.getFile() and
    s = ec.(ExternCrate).getIdentifier().getText()
  |
    crateDependencyEdge(f, s, crate)
    or
    // `extern crate` is used to import the current crate
    s = "self" and
    ec.getFile() = crate.getASourceFile().getFile()
  )
}

/**
 * Holds if `typeItem` is the implementing type of `impl` and the implementation
 * makes `assoc` available as `name`.
 */
private predicate typeImplEdge(
  TypeItemNode typeItem, ImplItemNodeImpl impl, string name, AssocItemNode assoc
) {
  assoc = impl.getAssocItemOrDefault(name) and
  typeItem = impl.resolveSelfTyCand() and
  // Functions in `impl` blocks are made available on the implementing type
  // (e.g., `S::fun` is valid) but associated types are not (e.g., `S::Output`
  // is invalid).
  not assoc instanceof TypeAlias
}

pragma[nomagic]
private predicate preludeItem(string name, ItemNode i) {
  exists(Crate stdOrCore | stdOrCore.getName() = ["std", "core"] |
    exists(ModuleLikeNode mod, ModuleItemNode prelude, ModuleItemNode rust |
      mod = stdOrCore.getSourceFile() and
      prelude = mod.getASuccessor("prelude") and
      rust = prelude.getASuccessor(["rust_2015", "rust_2018", "rust_2021", "rust_2024"]) and
      i = rust.getASuccessor(name) and
      not name = ["super", "self"]
    )
    or
    macroExportEdge(stdOrCore, name, i)
    or
    macroUseEdge(stdOrCore, name, _, _, i)
  )
}

/**
 * Holds if `i` is available inside `f` because it is reexported in
 * [the `core` prelude][1] or [the `std` prelude][2].
 *
 * We don't yet have access to prelude information from the extractor, so for now
 * we include all the preludes for Rust: 2015, 2018, 2021, and 2024.
 *
 * [1]: https://doc.rust-lang.org/core/prelude/index.html
 * [2]: https://doc.rust-lang.org/std/prelude/index.html
 */
pragma[nomagic]
private predicate preludeEdge(SourceFile f, string name, ItemNode i) {
  preludeItem(name, i) and
  not declares(f, i.getNamespace(), name)
}

pragma[nomagic]
private predicate builtin(string name, ItemNode i) {
  exists(BuiltinSourceFile builtins |
    builtins.getFile().getBaseName() = "types.rs" and
    i = builtins.getASuccessor(name) and
    i.isPublic()
  )
}

/** Provides predicates for debugging the path resolution implementation. */
private module Debug {
  Locatable getRelevantLocatable() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      result.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      filepath.matches("%/main.rs") and
      startline = 52
    )
  }

  predicate debugUnqualifiedPathLookup(
    PathExt p, string name, Namespace ns, ItemNode ancestor, string path
  ) {
    p = getRelevantLocatable() and
    exists(ItemNode encl |
      unqualifiedPathLookup(ancestor, name, ns, encl) and
      p.isUnqualified(name, encl)
    ) and
    path = p.toStringDebug()
  }

  ItemNode debugUnqualifiedPathLookup(PathExt p, Namespace ns, SuccessorKind kind) {
    p = getRelevantLocatable() and
    result = unqualifiedPathLookup(p, ns, kind)
  }

  predicate debugItemNode(ItemNode item) { item = getRelevantLocatable() }

  ItemNode debugResolvePath(PathExt path) {
    path = getRelevantLocatable() and
    result = resolvePath(path)
  }

  ItemNode debugResolveUseTreeListItem(Use use, UseTree tree, PathExt path, SuccessorKind kind) {
    use = getRelevantLocatable() and
    result = resolveUseTreeListItem(use, tree, path, kind)
  }

  ItemNode debugResolveUseTreeListItem(Use use, UseTree tree) {
    use = getRelevantLocatable() and
    result = resolveUseTreeListItem(use, tree)
  }

  predicate debugUseImportEdge(Use use, string name, ItemNode item, SuccessorKind kind) {
    use = getRelevantLocatable() and
    useImportEdge(use, name, item, kind)
  }

  ItemNode debugGetASuccessor(ItemNode i, string name, SuccessorKind kind) {
    i = getRelevantLocatable() and
    result = i.getASuccessor(name, kind, _)
  }

  predicate debugFileImportEdge(Module mod, string name, ItemNode item, SuccessorKind kind) {
    mod = getRelevantLocatable() and
    fileImportEdge(mod, name, item, kind, _)
  }

  predicate debugFileImport(Module m, SourceFile f) {
    m = getRelevantLocatable() and
    fileImport(m, f)
  }

  predicate debugPreludeEdge(SourceFile f, string name, ItemNode i) {
    preludeEdge(f, name, i) and
    f = getRelevantLocatable()
  }

  string debugGetCanonicalPath(ItemNode i, Crate c) {
    result = i.getCanonicalPath(c) and
    i = getRelevantLocatable()
  }
}
