/**
 * Provides facade AST classes, with additional hand-written members on top of the generated ones.
 */
overlay[local?]
module;

module Unified {
  private import Ast::Unified as G
  import G

  class AstNode extends G::AstNode {
    /** Holds if this AST node has a modifier with the given text. */
    predicate hasModifier(string text) {
      exists(Modifier mod |
        mod.getParent() = this and
        mod.getValue() = text
      )
    }
  }
}
