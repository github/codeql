/**
 * Provides facade AST classes, with additional hand-written members on top of the generated ones.
 */
overlay[local?]
module;

module Unified {
  private import Ast::Unified as G
  import G

  /** The base class for all AST nodes. */
  class AstNode extends G::AstNode {
    /** Holds if this AST node has a modifier with the given text. */
    predicate hasModifier(string text) {
      exists(Modifier mod |
        mod.getParent() = this and
        mod.getValue() = text
      )
    }

    /** Gets the nearest enclosing class declaration, possibly this node itself. */
    ClassLikeDeclaration getEnclosingClass() {
      result = this
      or
      not this instanceof ClassLikeDeclaration and
      result = this.getParent().getEnclosingClass()
    }
  }

  /** The base class for all patterns. */
  class Pattern extends G::Pattern {
    /** Gets the immediately-enclosing pattern in which this is a nested pattern. */
    Pattern getEnclosingPattern() {
      result = this.getParent()
      or
      result = this.getParent().(PatternElement).getParent()
    }
  }
}
