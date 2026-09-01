/**
 * Provides facade AST classes, with additional hand-written members on top of the generated ones.
 */
overlay[local?]
module;

private import codeql.files.FileSystem

module Unified {
  private import Ast::Unified as G
  import G

  /** The base class for all AST nodes. */
  class AstNode extends G::AstNode {
    /** Gets the file containing this AST node. */
    File getFile() { result = this.getLocation().getFile() }

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

    /** Gets the depth of this node in the AST. The root node has a depth of 0. */
    int getDepth() {
      not exists(this.getParent()) and result = 0
      or
      result = this.getParent().getDepth() + 1
    }
  }

  /** An expression */
  class Expr extends G::Expr {
    /** Gets the string value of this expression, if it is a known string constant. */
    string getStringValue() {
      // TODO: we'll want to cook the string literals extractor-side, but for now
      // just strip the quotes here and ignore escape sequences.
      result = this.(StringLiteral).getValue().regexpCapture("\"(.*)\"", 1)
    }
  }

  /** A binary expression. */
  class BinaryExpr extends G::BinaryExpr {
    Expr getAnOperand() { result = [this.getLeft(), this.getRight()] }
  }

  /** A function call */
  class CallExpr extends G::CallExpr {
    /** Gets the named argument with the given `name`. */
    Expr getNamedArgument(string name) {
      exists(Argument arg |
        arg = this.getAnArgument() and
        arg.getName().getValue() = name and
        result = arg.getValue()
      )
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
