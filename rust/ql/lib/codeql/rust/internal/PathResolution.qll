/**
 * Provides functionality for resolving paths, using the predicate `resolvePath`.
 */

private import rust
private import codeql.rust.elements.internal.generated.ParentChild
private import codeql.rust.internal.CachedStages

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
abstract class ItemNode extends Locatable {
  /** Gets the (original) name of this item. */
  abstract string getName();

  /** Gets the namespace that this item belongs to, if any. */
  abstract Namespace getNamespace();

  /** Gets the visibility of this item, if any. */
  abstract Visibility getVisibility();

  /** Gets the `i`th type parameter of this item, if any. */
  abstract TypeParam getTypeParam(int i);

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
  ModuleLikeNode getImmediateParentModule() {
    this = result.getAnItemInScope()
    or
    result = this.(SourceFileItemNode).getSuper()
  }

  cached
  ItemNode getASuccessorRec(string name) {
    Stages::PathResolutionStage::ref() and
    sourceFileEdge(this, name, result)
    or
    this = result.getImmediateParent() and
    name = result.getName()
    or
    fileImportEdge(this, name, result)
    or
    useImportEdge(this, name, result)
    or
    crateDefEdge(this, name, result)
    or
    crateDependencyEdge(this, name, result)
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
    or
    // a trait has access to the associated items of its supertraits
    this =
      any(TraitItemNode trait |
        result = trait.resolveABound().getASuccessorRec(name) and
        result instanceof AssocItemNode and
        not trait.hasAssocItem(name)
      )
    or
    // items made available by an implementation where `this` is the implementing type
    exists(ItemNode node |
      this = node.(ImplItemNode).resolveSelfTy() and
      result = node.getASuccessorRec(name) and
      result instanceof AssocItemNode
    )
    or
    // trait items with default implementations made available in an implementation
    exists(ImplItemNode impl, ItemNode trait |
      this = impl and
      trait = impl.resolveTraitTy() and
      result = trait.getASuccessorRec(name) and
      result.(AssocItemNode).hasImplementation() and
      not impl.hasAssocItem(name)
    )
    or
    // type parameters have access to the associated items of its bounds
    result = this.(TypeParamItemNode).resolveABound().getASuccessorRec(name).(AssocItemNode)
  }

  /** Gets a successor named `name` of this item, if any. */
  cached
  ItemNode getASuccessor(string name) {
    Stages::PathResolutionStage::ref() and
    result = this.getASuccessorRec(name)
    or
    preludeEdge(this, name, result)
    or
    name = "super" and
    if this instanceof Module or this instanceof SourceFile
    then result = this.getImmediateParentModule()
    else result = this.getImmediateParentModule().getImmediateParentModule()
    or
    name = "self" and
    if this instanceof Module or this instanceof Enum or this instanceof Struct
    then result = this
    else result = this.getImmediateParentModule()
    or
    name = "Self" and
    this = result.(ImplOrTraitItemNode).getAnItemInSelfScope()
    or
    name = "crate" and
    this = result.(CrateItemNode).getARootModuleNode()
    or
    // todo: implement properly
    name = "$crate" and
    result = any(CrateItemNode crate | this = crate.getARootModuleNode()).(Crate).getADependency*() and
    result.(CrateItemNode).isPotentialDollarCrateTarget()
  }

  /** Gets the location of this item. */
  Location getLocation() { result = super.getLocation() }
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

  /**
   * Holds if this is a root module, meaning either a source file or
   * the entry module of a crate.
   */
  predicate isRoot() {
    this instanceof SourceFileItemNode
    or
    this = any(Crate c).getModule()
  }
}

private class SourceFileItemNode extends ModuleLikeNode, SourceFile {
  pragma[nomagic]
  ModuleLikeNode getSuper() {
    result = any(ModuleItemNode mod | fileImport(mod, this)).getASuccessor("super")
  }

  override string getName() { result = "(source file)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `super`
  }

  override Visibility getVisibility() { none() }

  override predicate isPublic() { any() }

  override TypeParam getTypeParam(int i) { none() }
}

class CrateItemNode extends ItemNode instanceof Crate {
  /**
   * Gets the module node that defines this crate.
   *
   * This is either a source file, when the crate is defined in source code,
   * or a module, when the crate is defined in a dependency.
   */
  pragma[nomagic]
  ModuleLikeNode getModuleNode() {
    result = super.getSourceFile()
    or
    not exists(super.getSourceFile()) and
    result = super.getModule()
  }

  /**
   * Gets a source file that belongs to this crate, if any.
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

  /**
   * Gets a root module node belonging to this crate.
   */
  ModuleLikeNode getARootModuleNode() {
    result = this.getASourceFile()
    or
    result = super.getModule()
  }

  pragma[nomagic]
  predicate isPotentialDollarCrateTarget() {
    exists(string name, RelevantPath p |
      p.isDollarCrateQualifiedPath(name) and
      exists(this.getASuccessor(name))
    )
  }

  override string getName() { result = Crate.super.getName() }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `crate`
  }

  override Visibility getVisibility() { none() }

  override predicate isPublic() { any() }

  override TypeParam getTypeParam(int i) { none() }
}

/** An item that can occur in a trait or an `impl` block. */
abstract private class AssocItemNode extends ItemNode, AssocItem {
  /** Holds if this associated item has an implementation. */
  abstract predicate hasImplementation();
}

private class ConstItemNode extends AssocItemNode instanceof Const {
  override string getName() { result = Const.super.getName().getText() }

  override predicate hasImplementation() { super.hasBody() }

  override Namespace getNamespace() { result.isValue() }

  override Visibility getVisibility() { result = Const.super.getVisibility() }

  override TypeParam getTypeParam(int i) { none() }
}

private class EnumItemNode extends ItemNode instanceof Enum {
  override string getName() { result = Enum.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Enum.super.getVisibility() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }
}

private class VariantItemNode extends ItemNode instanceof Variant {
  override string getName() { result = Variant.super.getName().getText() }

  override Namespace getNamespace() {
    if super.getFieldList() instanceof StructFieldList then result.isType() else result.isValue()
  }

  override TypeParam getTypeParam(int i) {
    result = super.getEnum().getGenericParamList().getTypeParam(i)
  }

  override Visibility getVisibility() { result = super.getEnum().getVisibility() }
}

class FunctionItemNode extends AssocItemNode instanceof Function {
  override string getName() { result = Function.super.getName().getText() }

  override predicate hasImplementation() { super.hasBody() }

  override Namespace getNamespace() { result.isValue() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override Visibility getVisibility() { result = Function.super.getVisibility() }
}

abstract class ImplOrTraitItemNode extends ItemNode {
  /** Gets an item that may refer to this node using `Self`. */
  pragma[nomagic]
  ItemNode getAnItemInSelfScope() {
    result = this
    or
    result.getImmediateParent() = this
    or
    exists(ItemNode mid |
      mid = this.getAnItemInSelfScope() and
      result.getImmediateParent() = mid and
      not mid instanceof ImplOrTraitItemNode
    )
  }

  /** Gets a `Self` path that refers to this item. */
  Path getASelfPath() {
    isUnqualifiedSelfPath(result) and
    this = unqualifiedPathLookup(result, _)
  }

  /** Gets an associated item belonging to this trait or `impl` block. */
  abstract AssocItemNode getAnAssocItem();

  /** Holds if this trait or `impl` block declares an associated item named `name`. */
  pragma[nomagic]
  predicate hasAssocItem(string name) { name = this.getAnAssocItem().getName() }
}

pragma[nomagic]
private TypeParamItemNode resolveTypeParamPathTypeRepr(PathTypeRepr ptr) {
  result = resolvePath(ptr.getPath())
}

class ImplItemNode extends ImplOrTraitItemNode instanceof Impl {
  Path getSelfPath() { result = super.getSelfTy().(PathTypeRepr).getPath() }

  Path getTraitPath() { result = super.getTrait().(PathTypeRepr).getPath() }

  ItemNode resolveSelfTy() { result = resolvePath(this.getSelfPath()) }

  TraitItemNode resolveTraitTy() { result = resolvePath(this.getTraitPath()) }

  pragma[nomagic]
  private TypeRepr getASelfTyArg() {
    result =
      this.getSelfPath().getSegment().getGenericArgList().getAGenericArg().(TypeArg).getTypeRepr()
  }

  /**
   * Holds if this `impl` block is not fully parametric. That is, the implementing
   * type is generic and the implementation is not parametrically polymorphic in all
   * the implementing type's arguments.
   *
   * Examples:
   *
   * ```rust
   * impl Foo { ... } // fully parametric
   *
   * impl<T> Foo<T> { ... } // fully parametric
   *
   * impl Foo<i64> { ... } // not fully parametric
   *
   * impl<T> Foo<Foo<T>> { ... } // not fully parametric
   *
   * impl<T: Trait> Foo<T> { ... } // not fully parametric
   *
   * impl<T> Foo<T> where T: Trait { ... } // not fully parametric
   * ```
   */
  pragma[nomagic]
  predicate isNotFullyParametric() {
    exists(TypeRepr arg | arg = this.getASelfTyArg() |
      not exists(resolveTypeParamPathTypeRepr(arg))
      or
      resolveTypeParamPathTypeRepr(arg).hasTraitBound()
    )
  }

  /**
   * Holds if this `impl` block is fully parametric. Examples:
   *
   * ```rust
   * impl Foo { ... } // fully parametric
   *
   * impl<T> Foo<T> { ... } // fully parametric
   *
   * impl Foo<i64> { ... } // not fully parametric
   *
   * impl<T> Foo<Foo<T>> { ... } // not fully parametric
   *
   * impl<T: Trait> Foo<T> { ... } // not fully parametric
   *
   * impl<T> Foo<T> where T: Trait { ... } // not fully parametric
   * ```
   */
  predicate isFullyParametric() { not this.isNotFullyParametric() }

  override AssocItemNode getAnAssocItem() { result = super.getAssocItemList().getAnAssocItem() }

  override string getName() { result = "(impl)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `Self`
  }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override Visibility getVisibility() { result = Impl.super.getVisibility() }
}

private class MacroCallItemNode extends AssocItemNode instanceof MacroCall {
  override string getName() { result = "(macro call)" }

  override predicate hasImplementation() { none() }

  override Namespace getNamespace() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override Visibility getVisibility() { none() }
}

private class ModuleItemNode extends ModuleLikeNode instanceof Module {
  override string getName() { result = Module.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Module.super.getVisibility() }

  override TypeParam getTypeParam(int i) { none() }
}

private class StructItemNode extends ItemNode instanceof Struct {
  override string getName() { result = Struct.super.getName().getText() }

  override Namespace getNamespace() {
    result.isType() // the struct itself
    or
    not super.getFieldList() instanceof StructFieldList and
    result.isValue() // the constructor
  }

  override Visibility getVisibility() { result = Struct.super.getVisibility() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }
}

class TraitItemNode extends ImplOrTraitItemNode instanceof Trait {
  pragma[nomagic]
  Path getABoundPath() {
    result = super.getTypeBoundList().getABound().getTypeRepr().(PathTypeRepr).getPath()
  }

  pragma[nomagic]
  ItemNode resolveABound() { result = resolvePath(this.getABoundPath()) }

  override AssocItemNode getAnAssocItem() { result = super.getAssocItemList().getAnAssocItem() }

  override string getName() { result = Trait.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Trait.super.getVisibility() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }
}

class TypeAliasItemNode extends AssocItemNode instanceof TypeAlias {
  override string getName() { result = TypeAlias.super.getName().getText() }

  override predicate hasImplementation() { super.hasTypeRepr() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = TypeAlias.super.getVisibility() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }
}

private class UnionItemNode extends ItemNode instanceof Union {
  override string getName() { result = Union.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Union.super.getVisibility() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }
}

private class UseItemNode extends ItemNode instanceof Use {
  override string getName() { result = "(use)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { result = Use.super.getVisibility() }

  override TypeParam getTypeParam(int i) { none() }
}

private class BlockExprItemNode extends ItemNode instanceof BlockExpr {
  override string getName() { result = "(block expr)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }

  override TypeParam getTypeParam(int i) { none() }
}

private class TypeParamItemNode extends ItemNode instanceof TypeParam {
  pragma[nomagic]
  Path getABoundPath() {
    result = super.getTypeBoundList().getABound().getTypeRepr().(PathTypeRepr).getPath()
  }

  pragma[nomagic]
  ItemNode resolveABound() { result = resolvePath(this.getABoundPath()) }

  /**
   * Holds if this type parameter has a trait bound. Examples:
   *
   * ```rust
   * impl<T> Foo<T> { ... } // has no trait bound
   *
   * impl<T: Trait> Foo<T> { ... } // has trait bound
   *
   * impl<T> Foo<T> where T: Trait { ... } // has trait bound
   * ```
   */
  pragma[nomagic]
  predicate hasTraitBound() {
    exists(this.getABoundPath())
    or
    exists(ItemNode declaringItem, WherePred wp |
      this = resolveTypeParamPathTypeRepr(wp.getTypeRepr()) and
      wp = declaringItem.getADescendant() and
      this = declaringItem.getADescendant()
    )
  }

  /**
   * Holds if this type parameter has no trait bound. Examples:
   *
   * ```rust
   * impl<T> Foo<T> { ... } // has no trait bound
   *
   * impl<T: Trait> Foo<T> { ... } // has trait bound
   *
   * impl<T> Foo<T> where T: Trait { ... } // has trait bound
   * ```
   */
  pragma[nomagic]
  predicate hasNoTraitBound() { not this.hasTraitBound() }

  override string getName() { result = TypeParam.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override Location getLocation() { result = TypeParam.super.getName().getLocation() }
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
 * Holds if `m` is a `mod name;` module declaration, where the corresponding
 * module file needs to be looked up in `lookup` or one of its descandants.
 */
private predicate modImport0(Module m, string name, Folder lookup) {
  exists(File f, Folder parent, string fileName |
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
  |
    // sibling import
    lookup = parent and
    (
      m.getFile() = any(CrateItemNode c).getModuleNode().(SourceFileItemNode).getFile()
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

/** Holds if `m` is a `mod name;` item importing file `f`. */
private predicate fileImport(Module m, SourceFile f) {
  exists(string name, Folder parent |
    modImport0(m, name, _) and
    fileModule(f, name, parent)
  |
    // `m` is not inside a nested module
    modImport0(m, name, parent) and
    not modImportNested(m, _, _)
    or
    // `m` is inside a nested module
    modImportNestedLookup(m, m, parent)
  )
}

/**
 * Holds if `mod` is a `mod name;` item targeting a file resulting in `item` being
 * in scope under the name `name`.
 */
pragma[nomagic]
private predicate fileImportEdge(Module mod, string name, ItemNode item) {
  exists(SourceFileItemNode f |
    fileImport(mod, f) and
    item = f.getASuccessorRec(name)
  )
}

/**
 * Holds if crate `c` defines the item `i` named `name`.
 */
pragma[nomagic]
private predicate crateDefEdge(CrateItemNode c, string name, ItemNode i) {
  i = c.getModuleNode().getASuccessorRec(name) and
  not i instanceof Crate
}

/**
 * Holds if `m` depends on crate `dep` named `name`.
 */
private predicate crateDependencyEdge(ModuleLikeNode m, string name, CrateItemNode dep) {
  exists(CrateItemNode c | dep = c.(Crate).getDependency(name) |
    // entry module/entry source file
    m = c.getModuleNode()
    or
    // entry/transitive source file
    m = c.getASourceFile()
  )
  or
  // paths inside the crate graph use the name of the crate itself as prefix,
  // although that is not valid in Rust
  dep = any(Crate c | name = c.getName() and m = c.getModule())
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
class RelevantPath extends Path {
  RelevantPath() { not this = any(VariableAccess va).(PathExpr).getPath() }

  pragma[nomagic]
  predicate isUnqualified(string name) {
    not exists(this.getQualifier()) and
    not this = any(UseTreeList list).getAUseTree().getPath() and
    name = this.getText()
  }

  pragma[nomagic]
  predicate isCratePath(string name, ItemNode encl) {
    name = ["crate", "$crate"] and
    this.isUnqualified(name) and
    encl.getADescendant() = this
  }

  pragma[nomagic]
  predicate isDollarCrateQualifiedPath(string name) {
    this.getQualifier().(RelevantPath).isCratePath("$crate", _) and
    this.getText() = name
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
    exists(ns) and
    not name = ["crate", "$crate"]
    or
    // lookup in an outer scope, but only if the item is not declared in inner scope
    exists(ItemNode mid |
      unqualifiedPathLookup(p, name, ns, mid) and
      not declares(mid, ns, name) and
      not name = ["super", "self"] and
      not (
        name = "Self" and
        mid = any(ImplOrTraitItemNode i).getAnItemInSelfScope()
      )
    |
      // nested modules do not have unqualified access to items from outer modules,
      // except for items declared at top-level in the root module
      if mid instanceof Module
      then encl0 = mid.getImmediateParent+() and encl0.(ModuleLikeNode).isRoot()
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

private predicate isRoot(ItemNode root) { root.(ModuleLikeNode).isRoot() }

private predicate hasCratePath(ItemNode i) { any(RelevantPath path).isCratePath(_, i) }

private predicate hasChild(ItemNode parent, ItemNode child) { child.getImmediateParent() = parent }

private predicate rootHasCratePathTc(ItemNode i1, ItemNode i2) =
  doublyBoundedFastTC(hasChild/2, isRoot/1, hasCratePath/1)(i1, i2)

pragma[nomagic]
private ItemNode unqualifiedPathLookup(RelevantPath path, Namespace ns) {
  exists(ItemNode encl, string name |
    result = getASuccessor(encl, pragma[only_bind_into](name), ns)
  |
    unqualifiedPathLookup(path, name, ns, encl)
    or
    // For `($)crate`, jump directly to the root module
    exists(ItemNode i | path.isCratePath(pragma[only_bind_into](name), i) |
      encl.(ModuleLikeNode).isRoot() and
      encl = i
      or
      rootHasCratePathTc(encl, i)
    )
  )
}

pragma[nomagic]
private predicate isUnqualifiedSelfPath(RelevantPath path) { path.isUnqualified("Self") }

pragma[nomagic]
private ItemNode resolvePath0(RelevantPath path, Namespace ns) {
  exists(ItemNode res |
    res = unqualifiedPathLookup(path, ns) and
    if
      not any(RelevantPath parent).getQualifier() = path and
      isUnqualifiedSelfPath(path) and
      res instanceof ImplItemNode
    then result = res.(ImplItemNode).resolveSelfTy()
    else result = res
  )
  or
  exists(ItemNode q, string name |
    q = resolvePathQualifier(path, name) and
    result = q.getASuccessor(name) and
    ns = result.getNamespace()
  )
  or
  result = resolveUseTreeListItem(_, _, path) and
  ns = result.getNamespace()
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
}

pragma[nomagic]
private ItemNode resolvePath1(RelevantPath path) {
  exists(Namespace ns | result = resolvePath0(path, ns) |
    pathUsesNamespace(path, ns)
    or
    not pathUsesNamespace(path, _) and
    not path = any(MacroCall mc).getPath()
  )
}

pragma[nomagic]
private ItemNode resolvePathPrivate(
  RelevantPath path, ModuleLikeNode itemParent, ModuleLikeNode pathParent
) {
  result = resolvePath1(path) and
  itemParent = result.getImmediateParentModule() and
  not result.isPublic() and
  (
    pathParent.getADescendant() = path
    or
    pathParent = any(ItemNode mid | path = mid.getADescendant()).getImmediateParentModule()
  )
}

/**
 * Gets a module that has access to private items defined inside `itemParent`.
 *
 * According to [The Rust Reference][1] this is either `itemParent` itself or any
 * descendant of `itemParent`.
 *
 * [1]: https://doc.rust-lang.org/reference/visibility-and-privacy.html#r-vis.access
 */
pragma[nomagic]
private ModuleLikeNode getAPrivateVisibleModule(ModuleLikeNode itemParent) {
  exists(resolvePathPrivate(_, itemParent, _)) and
  result.getImmediateParentModule*() = itemParent
}

/** Gets the item that `path` resolves to, if any. */
cached
ItemNode resolvePath(RelevantPath path) {
  result = resolvePath1(path) and
  result.isPublic()
  or
  exists(ModuleLikeNode itemParent, ModuleLikeNode pathParent |
    result = resolvePathPrivate(path, itemParent, pathParent) and
    pathParent = getAPrivateVisibleModule(itemParent)
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
        not declares(encl, ns, name) and
        not name = ["super", "self", "Self", "$crate", "crate"]
      )
    else (
      item = used and
      (
        not tree.hasRename() and
        name = item.getName()
        or
        name = tree.getRename().getName().getText() and
        name != "_"
      )
    )
  )
}

/**
 * Holds if `i` is available inside `f` because it is reexported in [the prelude][1].
 *
 * We don't yet have access to prelude information from the extractor, so for now
 * we include all the preludes for Rust: 2015, 2018, 2021, and 2024.
 *
 * [1]: https://doc.rust-lang.org/core/prelude/index.html
 */
private predicate preludeEdge(SourceFile f, string name, ItemNode i) {
  exists(Crate core, ModuleItemNode mod, ModuleItemNode prelude, ModuleItemNode rust |
    f = any(Crate c0 | core = c0.getDependency(_)).getASourceFile() and
    core.getName() = "core" and
    mod = core.getModule() and
    prelude = mod.getASuccessorRec("prelude") and
    rust = prelude.getASuccessorRec(["rust_2015", "rust_2018", "rust_2021", "rust_2024"]) and
    i = rust.getASuccessorRec(name) and
    not i instanceof Use
  )
}

/** Provides predicates for debugging the path resolution implementation. */
private module Debug {
  private Locatable getRelevantLocatable() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      result.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      filepath.matches("%/test_logging.rs") and
      startline = 163
    )
  }

  predicate debugUnqualifiedPathLookup(
    RelevantPath p, string name, Namespace ns, ItemNode encl, string path
  ) {
    p = getRelevantLocatable() and
    unqualifiedPathLookup(p, name, ns, encl) and
    path = p.toStringDebug()
  }

  ItemNode debugResolvePath(RelevantPath path) {
    path = getRelevantLocatable() and
    result = resolvePath(path)
  }

  predicate debugUseImportEdge(Use use, string name, ItemNode item) {
    use = getRelevantLocatable() and
    useImportEdge(use, name, item)
  }

  ItemNode debugGetASuccessorRec(ItemNode i, string name) {
    i = getRelevantLocatable() and
    result = i.getASuccessor(name)
  }

  predicate debugFileImportEdge(Module mod, string name, ItemNode item) {
    mod = getRelevantLocatable() and
    fileImportEdge(mod, name, item)
  }

  predicate debugFileImport(Module m, SourceFile f) {
    m = getRelevantLocatable() and
    fileImport(m, f)
  }
}
