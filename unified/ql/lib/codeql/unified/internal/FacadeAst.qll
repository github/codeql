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

  /** A block statement. */
  class Block extends G::Block {
    /** Gets the last statement in this block. */
    Stmt getLastStmt() {
      exists(int i | result = this.getStmt(i) and not exists(this.getStmt(i + 1)))
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

    /** Gets the immediately-enclosing expression, skipping over intermediate sub-nodes like `Argument`, and without crossing a function boundary. */
    Expr getEnclosingExpr() {
      result = this.getParent() and
      not result instanceof Callable
      or
      result = this.getParent().(Argument).getParent()
    }
  }

  class AccessorDeclaration extends G::AccessorDeclaration {
    /** Gets the name of this accessor. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class Argument extends G::Argument {
    /** Gets the name of this argument. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class AssociatedTypeDeclaration extends G::AssociatedTypeDeclaration {
    /** Gets the name of this associated type. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class BreakExpr extends G::BreakExpr {
    /** Gets the label name targeted by this break. */
    string getLabelName() { result = this.getLabelNameNode().getValue() }
  }

  class ClassLikeDeclaration extends G::ClassLikeDeclaration {
    /** Gets the name of this declaration. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class ConstructorDeclaration extends G::ConstructorDeclaration {
    /** Gets the name of this constructor. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class ContinueExpr extends G::ContinueExpr {
    /** Gets the label name targeted by this continue. */
    string getLabelName() { result = this.getLabelNameNode().getValue() }
  }

  class FunctionDeclaration extends G::FunctionDeclaration {
    /** Gets the name of this function. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class LabeledStmt extends G::LabeledStmt {
    /** Gets the label name of this statement. */
    string getLabelName() { result = this.getLabelNameNode().getValue() }
  }

  class MemberAccessExpr extends G::MemberAccessExpr {
    /** Gets the member name of this access. */
    string getMemberName() { result = this.getMemberNameNode().getValue() }
  }

  class NamedPattern extends G::NamedPattern {
    /** Gets the name bound by this pattern. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class OperatorSyntaxDeclaration extends G::OperatorSyntaxDeclaration {
    /** Gets the name of this operator. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class Parameter extends G::Parameter {
    /** Gets the external name of this parameter. */
    string getExternalName() { result = this.getExternalNameNode().getValue() }
  }

  class TypeAliasDeclaration extends G::TypeAliasDeclaration {
    /** Gets the name of this type alias. */
    string getName() { result = this.getNameNode().getValue() }
  }

  class TypeParameter extends G::TypeParameter {
    /** Gets the name of this type parameter. */
    string getName() { result = this.getNameNode().getValue() }
  }

  /** A binary expression. */
  class BinaryExpr extends G::BinaryExpr {
    /** Gets an operand of this binary expression. */
    Expr getAnOperand() { result = [this.getLeft(), this.getRight()] }
  }

  /** A function call */
  class CallExpr extends G::CallExpr {
    /** Gets the named argument with the given `name`. */
    Expr getNamedArgument(string name) {
      exists(Argument arg |
        arg = this.getAnArgument() and
        arg.getName() = name and
        result = arg.getValue()
      )
    }
  }
}
