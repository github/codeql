/**
 * Provides functionality for resolving paths, using the predicate `resolvePath`.
 */

private import rust
private import codeql.rust.elements.internal.generated.ParentChild

private newtype TNamespace =
  TTypeNamespace() or
  TValueNamespace()

/**
 * A namespace.
 *
 * Either the _value_ namespace or the _type_ namespace, see
 * https://doc.rust-lang.org/reference/names/namespaces.html.
 */
final class Namespace extends TNamespace {
  /** Holds if this is the value namespace. */
  predicate isValue() { this = TValueNamespace() }

  /** Holds if this is the type namespace. */
  predicate isType() { this = TTypeNamespace() }

  /** Gets a textual representation of this namespace. */
  string toString() {
    this.isValue() and result = "value"
    or
    this.isType() and result = "type"
  }
}

/**
 * An item that may be referred to by a path, and which is a node in
 * the _item graph_.
 *
 * The item graph is a labeled directed graph, where an edge
 * `item1 --name--> item2` means that `item2` is available inside the
 * scope of `item1` under the name `name`. For example, if we have
 *
 * ```rust
 * mod m1 {
 *     mod m2 { }
 * }
 * ```
 *
 * then there is an edge `m1 --m2--> m1::m2`.
 *
 * Source files are also considered nodes in the item graph, and for
 * each source file `f` there is an edge `f --name--> item` when `f`
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
 * we first generate an edge `m1::m2 --name--> f::item`, where `item` is
 * any item (named `name`) inside the imported source file `f`. Using this
 * edge, `m2::foo` can resolve to `f::foo`, which results in the edge
 * `m1::use m2 --foo--> f::foo`. Lastly, all edges out of `use` nodes are
 * lifted to predecessors in the graph, so we get an edge `m1 --foo--> f::foo`.
 *
 *
 * References:
 * - https://doc.rust-lang.org/reference/items/modules.html
 * - https://doc.rust-lang.org/reference/names/scopes.html
 * - https://doc.rust-lang.org/reference/paths.html
 * - https://doc.rust-lang.org/reference/visibility-and-privacy.html
 * - https://doc.rust-lang.org/reference/names/namespaces.html
 */
abstract class ItemNode extends AstNode {
  /** Gets the (original) name of this item. */
  abstract string getName();

  /** Gets the namespace that this item belongs to, if any. */
  abstract Namespace getNamespace();

  /** Gets the visibility of this item, if any. */
  abstract Visibility getVisibility();

  /** Holds if this item is declared as `pub`. */
  bindingset[this]
  pragma[inline_late]
  predicate isPublic() { exists(this.getVisibility()) }

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

  /** Gets the immediately enclosing module (or source file) of this item. */
  pragma[nomagic]
  ModuleLikeNode getImmediateParentModule() { this = result.getAnItemInScope() }

  pragma[nomagic]
  private ItemNode getASuccessorRec(string name) {
    sourceFileEdge(this, name, result)
    or
    this = result.getImmediateParent() and
    name = result.getName()
    or
    fileImportEdge(this, name, result)
    or
    useImportEdge(this, name, result)
    or
    // items made available through `use` are available to nodes that contain the `use`
    exists(UseItemNode use |
      use = this.getASuccessorRec(_) and
      result = use.(ItemNode).getASuccessorRec(name)
    )
    or
    // items made available through macro calls are available to nodes that contain the macro call
    exists(MacroCallItemNode call |
      call = this.getASuccessorRec(_) and
      result = call.(ItemNode).getASuccessorRec(name)
    )
  }

  /** Gets a successor named `name` of this item, if any. */
  pragma[nomagic]
  ItemNode getASuccessor(string name) {
    result = this.getASuccessorRec(name)
    or
    name = "super" and
    if this instanceof Module
    then result = this.getImmediateParentModule()
    else result = this.getImmediateParentModule().getImmediateParentModule()
    or
    name = "self" and
    not this instanceof Module and
    result = this.getImmediateParentModule()
    or
    name = "Self" and
    this = result.(ImplOrTraitItemNode).getAnItemInSelfScope()
    or
    name = "crate" and
    result.(SourceFileItemNode).getFile() = this.getFile()
  }
}

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

private class SourceFileItemNode extends ModuleLikeNode, SourceFile {
  override string getName() { result = "(source file)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `super`
  }

  override Visibility getVisibility() { none() }
}

private class ConstItemNode extends ItemNode instanceof Const {
  override string getName() { result = Const.super.getName().getText() }

  override Namespace getNamespace() { result.isValue() }

  override Visibility getVisibility() { result = Const.super.getVisibility() }
}

private class EnumItemNode extends ItemNode instanceof Enum {
  override string getName() { result = Enum.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Enum.super.getVisibility() }
}

private class VariantItemNode extends ItemNode instanceof Variant {
  override string getName() { result = Variant.super.getName().getText() }

  override Namespace getNamespace() {
    if super.getFieldList() instanceof RecordFieldList then result.isType() else result.isValue()
  }

  override Visibility getVisibility() { result = Variant.super.getVisibility() }
}

private class FunctionItemNode extends ItemNode instanceof Function {
  override string getName() { result = Function.super.getName().getText() }

  override Namespace getNamespace() { result.isValue() }

  override Visibility getVisibility() { result = Function.super.getVisibility() }
}

abstract private class ImplOrTraitItemNode extends ItemNode {
  /** Gets an item that may refer to this node using `Self`. */
  pragma[nomagic]
  ItemNode getAnItemInSelfScope() {
    result.getImmediateParent() = this
    or
    exists(ItemNode mid |
      mid = this.getAnItemInSelfScope() and
      result.getImmediateParent() = mid and
      not mid instanceof ImplOrTraitItemNode
    )
  }
}

class ImplItemNode extends ImplOrTraitItemNode instanceof Impl {
  ItemNode resolveSelfTy() { result = resolvePath(super.getSelfTy().(PathTypeRepr).getPath()) }

  override string getName() { result = "(impl)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `Self`
  }

  override Visibility getVisibility() { result = Impl.super.getVisibility() }
}

private class MacroCallItemNode extends ItemNode instanceof MacroCall {
  override string getName() { result = "(macro call)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }
}

private class ModuleItemNode extends ModuleLikeNode instanceof Module {
  override string getName() { result = Module.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Module.super.getVisibility() }
}

private class StructItemNode extends ItemNode instanceof Struct {
  override string getName() { result = Struct.super.getName().getText() }

  override Namespace getNamespace() {
    result.isType() // the struct itself
    or
    not super.getFieldList() instanceof RecordFieldList and
    result.isValue() // the constructor
  }

  override Visibility getVisibility() { result = Struct.super.getVisibility() }
}

class TraitItemNode extends ImplOrTraitItemNode instanceof Trait {
  override string getName() { result = Trait.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Trait.super.getVisibility() }
}

class TypeAliasItemNode extends ItemNode instanceof TypeAlias {
  override string getName() { result = TypeAlias.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = TypeAlias.super.getVisibility() }
}

private class UnionItemNode extends ItemNode instanceof Union {
  override string getName() { result = Union.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Union.super.getVisibility() }
}

private class UseItemNode extends ItemNode instanceof Use {
  override string getName() { result = "(use)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }
}

private class BlockExprItemNode extends ItemNode instanceof BlockExpr {
  override string getName() { result = "(block expr)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }
}

private class TypeParamItemNode extends ItemNode instanceof TypeParam {
  override string getName() { result = TypeParam.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { none() }
}

/** Holds if `item` has the name `name` and is a top-level item inside `f`. */
private predicate sourceFileEdge(SourceFile f, string name, ItemNode item) {
  item = f.getAnItem() and
  name = item.getName()
}

/** Holds if `f` is available as `mod name;` inside `folder`. */
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

/**
 * Holds if `m` is a `mod name;` module declaration happening in a file named
 * `fileName.rs`, inside the folder `parent`.
 */
private predicate modImport(Module m, string fileName, string name, Folder parent) {
  exists(File f |
    f = m.getFile() and
    not m.hasItemList() and
    // TODO: handle
    // ```
    // #[path = "foo.rs"]
    // mod bar;
    // ```
    not m.getAnAttr().getMeta().getPath().getText() = "path" and
    name = m.getName().getText() and
    parent = f.getParentContainer() and
    fileName = f.getStem()
  )
}

/** Holds if `m` is a `mod name;` item importing file `f`. */
private predicate fileImport(Module m, SourceFile f) {
  exists(string fileName, string name, Folder parent | modImport(m, fileName, name, parent) |
    // sibling import
    fileModule(f, name, parent)
    or
    // child import
    fileModule(f, name, parent.getFolder(fileName))
  )
}

/**
 * Holds if `mod` is a `mod name;` item targeting a file resulting in `item` being
 * in scope under the name `name`.
 */
private predicate fileImportEdge(Module mod, string name, ItemNode item) {
  item.isPublic() and
  exists(SourceFile f |
    fileImport(mod, f) and
    sourceFileEdge(f, name, item)
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
    mid = tree.getUseTreeList().getAUseTree()
  )
}

/**
 * Holds if `item` explicitly declares a sub item named `name` in the
 * namespace `ns`. This includes items declared by `use` statements,
 * except for glob imports.
 */
pragma[nomagic]
private predicate declares(ItemNode item, Namespace ns, string name) {
  exists(ItemNode child | child.getImmediateParent() = item |
    child.getName() = name and
    child.getNamespace() = ns
    or
    useTreeDeclares(child.(Use).getUseTree(), name) and
    exists(ns) // `use foo::bar` can refer to both a value and a type
  )
  or
  exists(MacroCallItemNode call |
    declares(call, ns, name) and
    call.getImmediateParent() = item
  )
}

/** A path that does not access a local variable. */
private class RelevantPath extends Path {
  RelevantPath() { not this = any(VariableAccess va).(PathExpr).getPath() }

  pragma[nomagic]
  predicate isUnqualified(string name) {
    not exists(this.getQualifier()) and
    not this = any(UseTreeList list).getAUseTree().getPath() and
    name = this.getText()
  }
}

/**
 * Holds if the unqualified path `p` references an item named `name`, and `name`
 * may be looked up in the `ns` namespace inside enclosing item `encl`.
 */
pragma[nomagic]
private predicate unqualifiedPathLookup(RelevantPath p, string name, Namespace ns, ItemNode encl) {
  exists(ItemNode encl0 |
    // lookup in the immediately enclosing item
    p.isUnqualified(name) and
    encl0.getADescendant() = p and
    exists(ns)
    or
    // lookup in an outer scope, but only if the item is not declared in inner scope
    exists(ItemNode mid |
      unqualifiedPathLookup(p, name, ns, mid) and
      not declares(mid, ns, name)
    |
      // nested modules do not have unqualified access to items from outer modules,
      // except for items declared at top-level in the source file
      if mid instanceof Module
      then encl0.(SourceFileItemNode) = mid.getImmediateParent+()
      else encl0 = mid.getImmediateParent()
    )
  |
    // functions in `impl` blocks need to use explicit `Self::` to access other
    // functions in the `impl` block
    if encl0 instanceof ImplOrTraitItemNode and ns.isValue()
    then encl = encl0.getImmediateParent()
    else encl = encl0
  )
}

pragma[nomagic]
private ItemNode getASuccessor(ItemNode pred, string name, Namespace ns) {
  result = pred.getASuccessor(name) and
  ns = result.getNamespace()
}

pragma[nomagic]
private ItemNode resolvePath0(RelevantPath path) {
  exists(ItemNode encl, Namespace ns, string name, ItemNode res |
    unqualifiedPathLookup(path, name, ns, encl) and
    res = getASuccessor(encl, name, ns)
  |
    if
      not any(RelevantPath parent).getQualifier() = path and
      name = "Self" and
      res instanceof ImplItemNode
    then result = res.(ImplItemNode).resolveSelfTy()
    else result = res
  )
  or
  exists(ItemNode q, string name |
    q = resolvePathQualifier(path, name) and
    result = q.getASuccessor(name)
  )
  or
  result = resolveUseTreeListItem(_, _, path)
}

/** Holds if path `p` must be looked up in namespace `n`. */
private predicate pathUsesNamespace(Path p, Namespace n) {
  n.isValue() and
  (
    p = any(PathExpr pe).getPath()
    or
    p = any(TupleStructPat tsp).getPath()
  )
  or
  n.isType() and
  (
    p = any(Visibility v).getPath()
    or
    p = any(RecordExpr re).getPath()
    or
    p = any(PathTypeRepr ptr).getPath()
    or
    p = any(RecordPat rp).getPath()
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
}

/** Gets the item that `path` resolves to, if any. */
cached
ItemNode resolvePath(RelevantPath path) {
  result = resolvePath0(path) and
  (
    pathUsesNamespace(path, result.getNamespace())
    or
    not pathUsesNamespace(path, _)
  )
}

pragma[nomagic]
private ItemNode resolvePathQualifier(RelevantPath path, string name) {
  result = resolvePath(path.getQualifier()) and
  name = path.getText()
}

private predicate isUseTreeSubPath(UseTree tree, RelevantPath path) {
  path = tree.getPath()
  or
  exists(RelevantPath mid |
    isUseTreeSubPath(tree, mid) and
    path = mid.getQualifier()
  )
}

pragma[nomagic]
private predicate isUseTreeSubPathUnqualified(UseTree tree, RelevantPath path, string name) {
  isUseTreeSubPath(tree, path) and
  not exists(path.getQualifier()) and
  name = path.getText()
}

pragma[nomagic]
private ItemNode resolveUseTreeListItem(Use use, UseTree tree, RelevantPath path) {
  exists(UseTree midTree, ItemNode mid, string name |
    mid = resolveUseTreeListItem(use, midTree) and
    tree = midTree.getUseTreeList().getAUseTree() and
    isUseTreeSubPathUnqualified(tree, path, pragma[only_bind_into](name)) and
    result = mid.getASuccessor(pragma[only_bind_into](name))
  )
  or
  exists(ItemNode q, string name |
    q = resolveUseTreeListItemQualifier(use, tree, path, name) and
    result = q.getASuccessor(name)
  )
}

pragma[nomagic]
private ItemNode resolveUseTreeListItemQualifier(
  Use use, UseTree tree, RelevantPath path, string name
) {
  result = resolveUseTreeListItem(use, tree, path.getQualifier()) and
  name = path.getText()
}

pragma[nomagic]
private ItemNode resolveUseTreeListItem(Use use, UseTree tree) {
  tree = use.getUseTree() and
  result = resolvePath(tree.getPath())
  or
  result = resolveUseTreeListItem(use, tree, tree.getPath())
}

/** Holds if `use` imports `item` as `name`. */
pragma[nomagic]
private predicate useImportEdge(Use use, string name, ItemNode item) {
  exists(UseTree tree, ItemNode used |
    used = resolveUseTreeListItem(use, tree) and
    not tree.hasUseTreeList() and
    if tree.isGlob()
    then
      exists(ItemNode encl, Namespace ns |
        encl.getADescendant() = use and
        item = getASuccessor(used, name, ns) and
        // glob imports can be shadowed
        not declares(encl, ns, name)
      )
    else item = used
  |
    not tree.hasRename() and
    name = item.getName()
    or
    name = tree.getRename().getName().getText() and
    name != "_"
  )
}
