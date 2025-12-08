/** Provides logic for representing chains of implicit dereferences. */

private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.Type
private import codeql.rust.internal.TypeInference
private import codeql.rust.internal.TypeMention
private import codeql.rust.frameworks.stdlib.Stdlib
private import codeql.rust.frameworks.stdlib.Builtins as Builtins
private import codeql.util.UnboundList as UnboundListImpl

/** An `impl` block that implements the `Deref` trait. */
class DerefImplItemNode extends ImplItemNode {
  DerefImplItemNode() { this.resolveTraitTy() instanceof DerefTrait }

  /** Gets the `deref` function in this `Deref` impl block. */
  Function getDerefFunction() { result = this.getAssocItem("deref") }

  private SelfParam getSelfParam() { result = this.getDerefFunction().getSelfParam() }

  /**
   * Resolves the type at `path` of the `self` parameter inside the `deref` function,
   * stripped of the leading `&`.
   */
  pragma[nomagic]
  Type resolveSelfParamTypeStrippedAt(TypePath path) {
    exists(TypePath path0 |
      result = getSelfParamTypeMention(this.getSelfParam()).resolveTypeAt(path0) and
      path0.isCons(getRefTypeParameter(false), path)
    )
  }

  /**
   * Holds if the return type at `path` of the `deref` function, stripped of the
   * leading `&`, mentions type parameter `tp` at `path`.
   */
  pragma[nomagic]
  predicate returnTypeStrippedMentionsTypeParameterAt(TypeParameter tp, TypePath path) {
    exists(TypePath path0 |
      tp = getReturnTypeMention(this.getDerefFunction()).resolveTypeAt(path0) and
      path0.isCons(getRefTypeParameter(false), path)
    )
  }

  /** Gets the first type parameter of the type being implemented, if any. */
  pragma[nomagic]
  TypeParamTypeParameter getFirstSelfTypeParameter() {
    result.getTypeParam() = this.resolveSelfTy().getTypeParam(0)
  }
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
class DerefChain = UnboundList;

/** Provides predicates for constructing `DerefChain`s. */
module DerefChain = UnboundList;
