/** Provides logic for representing chains of implicit dereferences. */

private import rust
private import codeql.rust.internal.PathResolution
private import Type
private import TypeInference
private import TypeMention
private import codeql.rust.frameworks.stdlib.Stdlib
private import codeql.rust.frameworks.stdlib.Builtins as Builtins
private import codeql.util.UnboundList as UnboundListImpl

/** An `impl` block that implements the `Deref` trait. */
class DerefImplItemNode extends ImplItemNode {
  DerefImplItemNode() { this.resolveTraitTy() instanceof DerefTrait }

  /** Gets the `deref` function in this `Deref` impl block. */
  Function getDerefFunction() { result = this.getAssocItem("deref") }

  /** Gets the type of the implementing type at `path`. */
  Type resolveSelfTypeAt(TypePath path) { result = resolveImplSelfTypeAt(this, path) }

  /**
   * Holds if the target type of the dereference implementation mentions type
   * parameter `tp` at `path`.
   */
  pragma[nomagic]
  predicate targetHasTypeParameterAt(TypePath path, TypeParameter tp) {
    tp = this.getAssocItem("Target").(TypeAlias).getTypeRepr().(TypeMention).getTypeAt(path)
  }

  /** Gets the first type parameter of the type being implemented, if any. */
  pragma[nomagic]
  TypeParamTypeParameter getFirstSelfTypeParameter() {
    result.getTypeParam() = this.resolveSelfTy().getTypeParam(0)
  }

  /**
   * Holds if this `Deref` implementation is either
   *
   * [`impl<T> Deref for &T`](https://doc.rust-lang.org/std/ops/trait.Deref.html#impl-Deref-for-%26T)
   *
   * or
   *
   * [`impl<T> Deref for &mut T`](https://doc.rust-lang.org/std/ops/trait.Deref.html#impl-Deref-for-%26mut+T).
   */
  predicate isBuiltinDeref() { this.resolveSelfTyBuiltin() instanceof Builtins::RefType }
}

private module UnboundListInput implements UnboundListImpl::InputSig<Location> {
  private import codeql.rust.elements.internal.generated.Raw
  private import codeql.rust.elements.internal.generated.Synth

  private class DerefImplItemRaw extends Raw::Impl {
    DerefImplItemRaw() { this = Synth::convertAstNodeToRaw(any(DerefImplItemNode i)) }
  }

  private predicate id(DerefImplItemRaw x, DerefImplItemRaw y) { x = y }

  private predicate idOfRaw(DerefImplItemRaw x, int y) = equivalenceRelation(id/2)(x, y)

  class Element = DerefImplItemNode;

  int getId(Element e) { idOfRaw(Synth::convertAstNodeToRaw(e), result) }

  string getElementString(Element e) { result = e.resolveSelfTy().getName() }

  int getLengthLimit() { result = 5 }
}

private import UnboundListImpl::Make<Location, UnboundListInput>

/**
 * A sequence of `Deref` impl blocks representing a chain of implicit dereferences,
 * encoded as a string.
 */
class DerefChain extends UnboundList {
  bindingset[this]
  DerefChain() { exists(this) }

  bindingset[this]
  predicate isBuiltinDeref(int i) { this.getElement(i).isBuiltinDeref() }
}

/** Provides predicates for constructing `DerefChain`s. */
module DerefChain = UnboundList;
