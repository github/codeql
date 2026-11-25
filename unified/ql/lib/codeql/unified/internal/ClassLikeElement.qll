/**
 * Provides the `ClassLikeElement` class, the canonical representative of a class, struct, enum, etc.
 */
overlay[local?]
module;

private import unified
private import codeql.unified.internal.StaticNameBinding as N
private import codeql.unified.internal.mad.LegacyMaD as MaD

/**
 * Gets the model-only type extended by the extension `ext`, provided that the extended
 * type could not be resolved to a declaration.
 */
pragma[nomagic]
private MaD::TypeSelector getExtendedTypeSelector(ClassLikeDeclaration ext) {
  not exists(N::getExtendedDeclaration(ext)) and
  N::trackTypeSelectorThroughAliases(result) = N::getNodeFromRef(ext.getExtensionTarget())
}

cached
private newtype TClassLikeElement =
  TClassLikeDeclarationElement(ClassLikeDeclaration decl) { not exists(decl.getExtensionTarget()) } or
  TTypeSelectorElement(MaD::TypeSelector selector) {
    not exists(selector.getDeclaration()) and
    not selector.isMetaType()
  }

/**
 * A class-like entity, such as a class, struct, enum, or protocol.
 *
 * This is the canonical representative of a class-like entity, unifying its
 * primary declaration with any extensions of it. Types that are only known from
 * a model (and have no declaration in the database) are represented by their type selector.
 */
class ClassLikeElement extends TClassLikeElement {
  /** Gets the primary (non-extension) declaration of this class, if any. */
  ClassLikeDeclaration asClassLikeDeclaration() { this = TClassLikeDeclarationElement(result) }

  /** Gets the type selector of this class, if it is only known from a model. */
  MaD::TypeSelector asTypeSelector() { this = TTypeSelectorElement(result) }

  /**
   * Gets a declaration of this class, that is, either its primary declaration or an extension of it.
   */
  cached
  ClassLikeDeclaration getADeclaration() {
    result = this.asClassLikeDeclaration()
    or
    N::getExtendedDeclaration(result) = this.asClassLikeDeclaration()
    or
    getExtendedTypeSelector(result) = this.asTypeSelector()
  }

  /** Gets a member of this class, including members declared in extensions. */
  Member getAMember() { result = this.getADeclaration().getAMember() }

  /** Gets the name of this class. */
  string getName() {
    result = this.asClassLikeDeclaration().getName()
    or
    result = this.asTypeSelector().getHead()
  }

  /** Gets the qualified name of this class. */
  string getQualifiedName() {
    result = this.asClassLikeDeclaration().getQualifiedName()
    or
    result = this.asTypeSelector()
  }

  /** Gets a textual representation of this element. */
  string toString() {
    result = this.asClassLikeDeclaration().toString()
    or
    result = this.asTypeSelector()
  }

  /** Gets the location of this element. */
  Location getLocation() {
    result = this.asClassLikeDeclaration().getLocation()
    or
    exists(this.asTypeSelector()) and
    result instanceof EmptyLocation
  }
}
