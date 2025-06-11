/**
 * Provides functionality for resolving paths, using the predicate `resolvePath`.
 */

private import rust
private import codeql.rust.elements.internal.generated.ParentChild
private import codeql.rust.internal.CachedStages
private import codeql.rust.frameworks.stdlib.Bultins as Builtins

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
    externCrateEdge(this, name, result)
    or
    // items made available through `use` are available to nodes that contain the `use`
    exists(UseItemNode use |
      use = this.getASuccessorRec(_) and
      result = use.(ItemNode).getASuccessorRec(name)
    )
    or
    exists(ExternCrateItemNode ec | result = ec.(ItemNode).getASuccessorRec(name) |
      ec = this.getASuccessorRec(_)
      or
      // if the extern crate appears in the crate root, then the crate name is also added
      // to the 'extern prelude', see https://doc.rust-lang.org/reference/items/extern-crates.html
      exists(Crate c |
        ec = c.getSourceFile().(ItemNode).getASuccessorRec(_) and
        this = c.getASourceFile()
      )
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
    or
    result = this.(ImplTraitTypeReprItemNode).resolveABound().getASuccessorRec(name).(AssocItemNode)
  }

  /**
   * Gets a successor named `name` of this item, if any.
   *
   * Whenever a function exists in both source code and in library code,
   * both are included
   */
  cached
  ItemNode getASuccessorFull(string name) {
    Stages::PathResolutionStage::ref() and
    result = this.getASuccessorRec(name)
    or
    preludeEdge(this, name, result) and not declares(this, _, name)
    or
    this instanceof SourceFile and
    builtin(name, result)
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
    this = result.(CrateItemNode).getASourceFile()
    or
    // todo: implement properly
    name = "$crate" and
    result = any(CrateItemNode crate | this = crate.getASourceFile()).(Crate).getADependency*() and
    result.(CrateItemNode).isPotentialDollarCrateTarget()
  }

  pragma[nomagic]
  private predicate hasSourceFunction(string name) {
    this.getASuccessorFull(name).(Function).fromSource()
  }

  /** Gets a successor named `name` of this item, if any. */
  pragma[nomagic]
  ItemNode getASuccessor(string name) {
    result = this.getASuccessorFull(name) and
    (
      // when a function exists in both source code and in library code, it is because
      // we also extracted the source code as library code, and hence we only want
      // the function from source code
      result.fromSource()
      or
      not result instanceof Function
      or
      not this.hasSourceFunction(name)
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
  pragma[nomagic]
  ModuleLikeNode getSuper() {
    result = any(ModuleItemNode mod | fileImport(mod, this)).getASuccessorFull("super")
  }

  override string getName() { result = "(source file)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `super`
  }

  override Visibility getVisibility() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

class CrateItemNode extends ItemNode instanceof Crate {
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

  pragma[nomagic]
  predicate isPotentialDollarCrateTarget() {
    exists(string name, RelevantPath p |
      p.isDollarCrateQualifiedPath(name) and
      exists(this.getASuccessorFull(name))
    )
  }

  override string getName() { result = Crate.super.getName() }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `crate`
  }

  override Visibility getVisibility() { none() }

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
    this.getName() = "core" and
    child instanceof Builtins::BuiltinType
  }

  override string getCanonicalPath(Crate c) { c = this and result = Crate.super.getName() }
}

class ExternCrateItemNode extends ItemNode instanceof ExternCrate {
  override string getName() { result = super.getRename().getName().getText() }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

/** An item that can occur in a trait or an `impl` block. */
abstract private class AssocItemNode extends ItemNode, AssocItem {
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

  override predicate hasImplementation() {
    super.hasBody()
    or
    // for trait items from library code, we do not currently know if they
    // have default implementations or not, so we assume they do
    not this.fromSource() and
    this = any(TraitItemNode t).getAnAssocItem()
  }

  override Namespace getNamespace() { result.isValue() }

  override Visibility getVisibility() { result = Const.super.getVisibility() }

  override TypeParam getTypeParam(int i) { none() }
}

private class EnumItemNode extends ItemNode instanceof Enum {
  override string getName() { result = Enum.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Enum.super.getVisibility() }

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

private class VariantItemNode extends ItemNode instanceof Variant {
  override string getName() { result = Variant.super.getName().getText() }

  override Namespace getNamespace() {
    if super.getFieldList() instanceof StructFieldList then result.isType() else result.isValue()
  }

  override TypeParam getTypeParam(int i) {
    result = super.getEnum().getGenericParamList().getTypeParam(i)
  }

  override Visibility getVisibility() { result = super.getEnum().getVisibility() }

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

class FunctionItemNode extends AssocItemNode instanceof Function {
  override string getName() { result = Function.super.getName().getText() }

  override predicate hasImplementation() {
    super.hasBody()
    or
    // for trait items from library code, we do not currently know if they
    // have default implementations or not, so we assume they do
    not this.fromSource() and
    this = any(TraitItemNode t).getAnAssocItem()
  }

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
  cached
  Path getASelfPath() {
    Stages::PathResolutionStage::ref() and
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
  result = resolvePathFull(ptr.getPath())
}

class ImplItemNode extends ImplOrTraitItemNode instanceof Impl {
  Path getSelfPath() { result = super.getSelfTy().(PathTypeRepr).getPath() }

  Path getTraitPath() { result = super.getTrait().(PathTypeRepr).getPath() }

  ItemNode resolveSelfTy() { result = resolvePathFull(this.getSelfPath()) }

  TraitItemNode resolveTraitTy() { result = resolvePathFull(this.getTraitPath()) }

  override AssocItemNode getAnAssocItem() { result = super.getAssocItemList().getAnAssocItem() }

  override string getName() { result = "(impl)" }

  override Namespace getNamespace() {
    result.isType() // can be referenced with `Self`
  }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override Visibility getVisibility() { result = Impl.super.getVisibility() }

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
        c2 = c1.getADependency() or c1 = c2.getADependency()
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

private class ImplTraitTypeReprItemNode extends ItemNode instanceof ImplTraitTypeRepr {
  pragma[nomagic]
  Path getABoundPath() {
    result = super.getTypeBoundList().getABound().getTypeRepr().(PathTypeRepr).getPath()
  }

  pragma[nomagic]
  ItemNode resolveABound() { result = resolvePathFull(this.getABoundPath()) }

  override string getName() { result = "(impl trait)" }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class MacroCallItemNode extends AssocItemNode instanceof MacroCall {
  override string getName() { result = "(macro call)" }

  override predicate hasImplementation() { none() }

  override Namespace getNamespace() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override Visibility getVisibility() { none() }

  override predicate providesCanonicalPathPrefixFor(Crate c, ItemNode child) {
    any(ItemNode parent).providesCanonicalPathPrefixFor(c, this) and
    child.getImmediateParent() = this
  }

  override string getCanonicalPathPrefixFor(Crate c, ItemNode child) {
    result = this.getCanonicalPathPrefix(c) and
    this.providesCanonicalPathPrefixFor(c, child)
  }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class ModuleItemNode extends ModuleLikeNode instanceof Module {
  override string getName() { result = Module.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Module.super.getVisibility() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { this.hasCanonicalPathPrefix(c) }

  override predicate providesCanonicalPathPrefixFor(Crate c, ItemNode child) {
    this.hasCanonicalPath(c) and
    (
      exists(SourceFile f |
        fileImport(this, f) and
        sourceFileEdge(f, _, child)
      )
      or
      this = child.getImmediateParent()
      or
      exists(ItemNode mid |
        this.providesCanonicalPathPrefixFor(c, mid) and
        mid.(MacroCallItemNode) = child.getImmediateParent()
      )
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

class TraitItemNode extends ImplOrTraitItemNode instanceof Trait {
  pragma[nomagic]
  Path getABoundPath() {
    result = super.getTypeBoundList().getABound().getTypeRepr().(PathTypeRepr).getPath()
  }

  pragma[nomagic]
  ItemNode resolveABound() { result = resolvePathFull(this.getABoundPath()) }

  override AssocItemNode getAnAssocItem() { result = super.getAssocItemList().getAnAssocItem() }

  override string getName() { result = Trait.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Trait.super.getVisibility() }

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

class TypeAliasItemNode extends AssocItemNode instanceof TypeAlias {
  override string getName() { result = TypeAlias.super.getName().getText() }

  override predicate hasImplementation() { super.hasTypeRepr() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = TypeAlias.super.getVisibility() }

  override TypeParam getTypeParam(int i) { result = super.getGenericParamList().getTypeParam(i) }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class UnionItemNode extends ItemNode instanceof Union {
  override string getName() { result = Union.super.getName().getText() }

  override Namespace getNamespace() { result.isType() }

  override Visibility getVisibility() { result = Union.super.getVisibility() }

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

private class UseItemNode extends ItemNode instanceof Use {
  override string getName() { result = "(use)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { result = Use.super.getVisibility() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

private class BlockExprItemNode extends ItemNode instanceof BlockExpr {
  override string getName() { result = "(block expr)" }

  override Namespace getNamespace() { none() }

  override Visibility getVisibility() { none() }

  override TypeParam getTypeParam(int i) { none() }

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

class TypeParamItemNode extends ItemNode instanceof TypeParam {
  private WherePred getAWherePred() {
    exists(ItemNode declaringItem |
      this = resolveTypeParamPathTypeRepr(result.getTypeRepr()) and
      result = declaringItem.getADescendant() and
      this = declaringItem.getADescendant()
    )
  }

  pragma[nomagic]
  Path getABoundPath() {
    exists(TypeBoundList tbl | result = tbl.getABound().getTypeRepr().(PathTypeRepr).getPath() |
      tbl = super.getTypeBoundList()
      or
      tbl = this.getAWherePred().getTypeBoundList()
    )
  }

  pragma[nomagic]
  ItemNode resolveABound() { result = resolvePathFull(this.getABoundPath()) }

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
  cached
  predicate hasTraitBound() {
    Stages::PathResolutionStage::ref() and
    exists(this.getABoundPath())
    or
    exists(this.getAWherePred())
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

  override predicate hasCanonicalPath(Crate c) { none() }

  override string getCanonicalPath(Crate c) { none() }
}

/** Holds if `item` has the name `name` and is a top-level item inside `f`. */
private predicate sourceFileEdge(SourceFile f, string name, ItemNode item) {
  item = f.getAnItem() and
  name = item.getName()
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
  i = c.getSourceFile().getASuccessorRec(name) and
  not i instanceof Crate
}

private class BuiltinSourceFile extends SourceFileItemNode {
  BuiltinSourceFile() { this.getFile().getParentContainer() instanceof Builtins::BuiltinsFolder }
}

/**
 * Holds if `file` depends on crate `dep` named `name`.
 */
pragma[nomagic]
private predicate crateDependencyEdge(SourceFileItemNode file, string name, CrateItemNode dep) {
  exists(CrateItemNode c | dep = c.(Crate).getDependency(name) | file = c.getASourceFile())
  or
  // Give builtin files, such as `await.rs`, access to `std`
  file instanceof BuiltinSourceFile and
  dep.getName() = name and
  name = "std"
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

pragma[nomagic]
private ItemNode getAdjustedEnclosing(ItemNode encl0, Namespace ns) {
  // functions in `impl` blocks need to use explicit `Self::` to access other
  // functions in the `impl` block
  if encl0 instanceof ImplOrTraitItemNode and ns.isValue()
  then result = encl0.getImmediateParent()
  else result = encl0
}

/**
 * Holds if the unqualified path `p` references an item named `name`, and `name`
 * may be looked up in the `ns` namespace inside enclosing item `encl`.
 */
pragma[nomagic]
private predicate unqualifiedPathLookup(ItemNode encl, string name, Namespace ns, RelevantPath p) {
  exists(ItemNode encl0 | encl = getAdjustedEnclosing(encl0, ns) |
    // lookup in the immediately enclosing item
    p.isUnqualified(name) and
    encl0.getADescendant() = p and
    exists(ns) and
    not name = ["crate", "$crate", "super", "self"]
    or
    // lookup in an outer scope, but only if the item is not declared in inner scope
    exists(ItemNode mid |
      unqualifiedPathLookup(mid, name, ns, p) and
      not declares(mid, ns, name) and
      not (
        name = "Self" and
        mid = any(ImplOrTraitItemNode i).getAnItemInSelfScope()
      ) and
      encl0 = getOuterScope(mid)
    )
  )
}

pragma[nomagic]
private ItemNode getASuccessorFull(ItemNode pred, string name, Namespace ns) {
  result = pred.getASuccessorFull(name) and
  ns = result.getNamespace()
}

private predicate isSourceFile(ItemNode source) { source instanceof SourceFileItemNode }

private predicate hasCratePath(ItemNode i) { any(RelevantPath path).isCratePath(_, i) }

private predicate hasChild(ItemNode parent, ItemNode child) { child.getImmediateParent() = parent }

private predicate sourceFileHasCratePathTc(ItemNode i1, ItemNode i2) =
  doublyBoundedFastTC(hasChild/2, isSourceFile/1, hasCratePath/1)(i1, i2)

/**
 * Holds if the unqualified path `p` references a keyword item named `name`, and
 * `name` may be looked up in the `ns` namespace inside enclosing item `encl`.
 */
pragma[nomagic]
private predicate keywordLookup(ItemNode encl, string name, Namespace ns, RelevantPath p) {
  // For `($)crate`, jump directly to the root module
  exists(ItemNode i | p.isCratePath(name, i) |
    encl instanceof SourceFile and
    encl = i
    or
    sourceFileHasCratePathTc(encl, i)
  )
  or
  name = ["super", "self"] and
  p.isUnqualified(name) and
  exists(ItemNode encl0 |
    encl0.getADescendant() = p and
    encl = getAdjustedEnclosing(encl0, ns)
  )
}

pragma[nomagic]
private ItemNode unqualifiedPathLookup(RelevantPath p, Namespace ns) {
  exists(ItemNode encl, string name | result = getASuccessorFull(encl, name, ns) |
    unqualifiedPathLookup(encl, name, ns, p)
    or
    keywordLookup(encl, name, ns, p)
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
    result = getASuccessorFull(q, name, ns)
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

/**
 * Gets the item that `path` resolves to, if any.
 *
 * Whenever `path` can resolve to both a function in source code and in library
 * code, both are included
 */
pragma[nomagic]
private ItemNode resolvePathFull(RelevantPath path) {
  exists(Namespace ns | result = resolvePath0(path, ns) |
    pathUsesNamespace(path, ns)
    or
    not pathUsesNamespace(path, _) and
    not path = any(MacroCall mc).getPath()
  )
}

pragma[nomagic]
private predicate resolvesSourceFunction(RelevantPath path) {
  resolvePathFull(path).(Function).fromSource()
}

/** Gets the item that `path` resolves to, if any. */
cached
ItemNode resolvePath(RelevantPath path) {
  result = resolvePathFull(path) and
  (
    // when a function exists in both source code and in library code, it is because
    // we also extracted the source code as library code, and hence we only want
    // the function from source code
    result.fromSource()
    or
    not result instanceof Function
    or
    not resolvesSourceFunction(path)
  )
}

pragma[nomagic]
private ItemNode resolvePathQualifier(RelevantPath path, string name) {
  result = resolvePathFull(path.getQualifier()) and
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
    result = mid.getASuccessorFull(pragma[only_bind_into](name))
  )
  or
  exists(ItemNode q, string name |
    q = resolveUseTreeListItemQualifier(use, tree, path, name) and
    result = q.getASuccessorFull(name)
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
  result = resolvePathFull(tree.getPath())
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
        item = getASuccessorFull(used, name, ns) and
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

/** Holds if `ec` imports `crate` as `name`. */
pragma[nomagic]
private predicate externCrateEdge(ExternCrateItemNode ec, string name, CrateItemNode crate) {
  name = ec.getName() and
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
  exists(Crate stdOrCore, ModuleLikeNode mod, ModuleItemNode prelude, ModuleItemNode rust |
    f = any(Crate c0 | stdOrCore = c0.getDependency(_) or stdOrCore = c0).getASourceFile()
    or
    // Give builtin files, such as `await.rs`, access to the prelude
    f instanceof BuiltinSourceFile
  |
    stdOrCore.getName() = ["std", "core"] and
    mod = stdOrCore.getSourceFile() and
    prelude = mod.getASuccessorRec("prelude") and
    rust = prelude.getASuccessorRec(["rust_2015", "rust_2018", "rust_2021", "rust_2024"]) and
    i = rust.getASuccessorRec(name) and
    not i instanceof Use
  )
}

pragma[nomagic]
private predicate builtin(string name, ItemNode i) {
  exists(BuiltinSourceFile builtins |
    builtins.getFile().getBaseName() = "types.rs" and
    i = builtins.getASuccessorRec(name)
  )
}

/** Provides predicates for debugging the path resolution implementation. */
private module Debug {
  private Locatable getRelevantLocatable() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      result.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      filepath.matches("%/test.rs") and
      startline = 74
    )
  }

  predicate debugUnqualifiedPathLookup(
    RelevantPath p, string name, Namespace ns, ItemNode encl, string path
  ) {
    p = getRelevantLocatable() and
    unqualifiedPathLookup(encl, name, ns, p) and
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

  predicate debugPreludeEdge(SourceFile f, string name, ItemNode i) {
    preludeEdge(f, name, i) and
    f = getRelevantLocatable()
  }

  string debugGetCanonicalPath(ItemNode i, Crate c) {
    result = i.getCanonicalPath(c) and
    i = getRelevantLocatable()
  }
}
