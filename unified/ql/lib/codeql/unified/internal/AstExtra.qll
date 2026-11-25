/**
 * Provides additional AST-like classes outside the generated tree-sitter classes.
 */
overlay[local?]
module;

private import unified
private import codeql.unified.internal.NameBindingPlugin

/**
 * Holds if `e` is an element of an access chain, that is, a member access or a call to a
 * member access.
 */
private predicate isAccessChainElement(Expr e) {
  e instanceof MemberAccessExpr
  or
  e.(CallExpr).getCallee() instanceof MemberAccessExpr
}

/** Holds if `inner` is the element immediately inside `outer` in an access chain. */
private predicate accessChainStep(Expr inner, Expr outer) {
  // `inner.member`
  inner = outer.(MemberAccessExpr).getBase() and
  isAccessChainElement(inner)
  or
  // `inner(...)`, where `inner` is a member access
  inner = outer.(CallExpr).getCallee().(MemberAccessExpr)
}

private newtype TAccessChain =
  MkAccessChain(Expr outermost) {
    isAccessChainElement(outermost) and
    not accessChainStep(outermost, _)
  }

module Public {
  /**
   * A chain of member accesses, possibly with calls in between, such as `a.b().c.d()`.
   *
   * The elements of the chain are member accesses and calls whose callee is a member access.
   * For `a.b().c.d()`, these are (from innermost to outermost) `a.b`, `a.b()`, `a.b().c`,
   * `a.b().c.d` and `a.b().c.d()`, and the innermost base expression is `a`.
   *
   * Every member access belongs to exactly one chain.
   */
  class AccessChain extends TAccessChain {
    private Expr outermost;

    AccessChain() { this = MkAccessChain(outermost) }

    /**
     * Gets the outermost element of this chain, which is a member access or a call to a
     * member access, such as `a.b().c.d()` in `a.b().c.d()`.
     */
    Expr getOutermostAccess() { result = outermost }

    /** Gets an element of this chain, that is, a member access or a call to a member access. */
    Expr getAnAccess() { accessChainStep*(result, outermost) }

    /** Gets the innermost member access in this chain, such as `a.b` in `a.b().c.d()`. */
    MemberAccessExpr getInnermostAccess() {
      result = this.getAnAccess() and
      not isAccessChainElement(result.getBase())
    }

    /** Gets the innermost base expression of this chain, such as `a` in `a.b().c.d()`. */
    Expr getInnermostBase() { result = this.getInnermostAccess().getBase() }

    /** Gets a textual representation of this chain. */
    string toString() { result = outermost.toString() }

    /** Gets the location of this chain. */
    Location getLocation() { result = outermost.getLocation() }
  }

  /** An assignment, possibly a compound assignment. */
  abstract private class AssignmentImpl extends BinaryExpr {
    /** Gets the target of this assignment. */
    abstract Expr getTarget();

    /** Gets the value assigned by this assignment. */
    abstract Expr getValue();
  }

  final class Assignment = AssignmentImpl;

  /** A plain assignment expression. */
  final class AssignExpr extends BinaryExpr, AssignmentImpl {
    AssignExpr() { this.getOperator().getValue() = "=" }

    override Expr getTarget() { result = this.getLeft() }

    override Expr getValue() { result = this.getRight() }
  }

  /** A compound assignment expression. */
  final class CompoundAssignExpr extends BinaryExpr, AssignmentImpl {
    CompoundAssignExpr() {
      this.getOperator().getValue() =
        [
          "+=", "-=", "*=", "/=", "%=", "<<=", ">>=", "&=", "|=", "^=", "&+=", "&-=", "&*=", "&&=",
          "||=", "??="
        ]
    }

    override Expr getTarget() { result = this.getLeft() }

    override Expr getValue() { result = this.getRight() }
  }

  /** A short-circuiting logical AND expression. */
  class LogicalAndExpr extends BinaryExpr {
    LogicalAndExpr() { this.getOperator().getValue() = "&&" }
  }

  /** A short-circuiting logical OR expression. */
  class LogicalOrExpr extends BinaryExpr {
    LogicalOrExpr() { this.getOperator().getValue() = "||" }
  }

  /** A short-circuiting null-coalescing expression. */
  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { this.getOperator().getValue() = "??" }
  }

  /** A logical NOT expression. */
  class LogicalNotExpr extends UnaryExpr {
    LogicalNotExpr() { this.getOperator().(PrefixOperator).getValue() = "!" }
  }

  /**
   * Declaration of a local or top-level variable.
   */
  class LocalVariableDeclaration extends VariableDeclaration {
    LocalVariableDeclaration() { not isStaticMember(this) and not isInstanceMember(this) }
  }

  /**
   * Declaration of a local or top-level function.
   */
  class LocalFunctionDeclaration extends FunctionDeclaration {
    LocalFunctionDeclaration() { not isStaticMember(this) and not isInstanceMember(this) }
  }

  /**
   * A comment appearing in the source code.
   */
  class Comment extends TriviaToken {
    // At the moment, comments are the only type trivia token we extract
    /**
     * Gets the text inside this comment, not counting the delimiters.
     */
    string getCommentText() {
      result = this.getValue().regexpCapture("//(.*)", 1)
      or
      result = this.getValue().regexpCapture("(?s)/\\*(.*)\\*/", 1)
    }
  }

  /** A `Stmt` at the top-level. */
  final class TopLevelStmt extends Stmt {
    TopLevelStmt() { this = any(TopLevel t).getBody().getAStmt() }
  }

  /** An identifier appearing in the context of a break/continue label, argument/parameter name, or name of a member lookup. */
  final class IdentifierLabel extends Identifier {
    IdentifierLabel() {
      this = any(MemberAccessExpr e).getMemberNameNode() or
      this = any(Argument a).getNameNode() or
      this = any(Parameter p).getExternalNameNode() or
      this = any(LabeledStmt stmt).getLabelNameNode() or
      this = any(BreakExpr expr).getLabelNameNode() or
      this = any(ContinueExpr expr).getLabelNameNode()
    }
  }

  /** An identifier appearing in the context of an expression, pattern, or type annotation. */
  final class IdentifierExpr extends Identifier {
    IdentifierExpr() { not this instanceof IdentifierLabel }
  }

  /**
   * A class representing one of the branches of an algebraic data type.
   *
   * In Swift, a class with a single constructor is generated for each `case` with data parameters in an `enum` declaration. Example:
   *
   * ```swift
   * enum E {
   *   case foo(Int)
   * }
   * ```
   *
   * is modeled as
   *
   * ```swift
   * class E {
   *   class foo {
   *     init(_ x : Int)
   *   }
   * }
   * ```
   */
  final class EnumCaseClass extends ClassLikeDeclaration {
    EnumCaseClass() { this.hasModifier("enum_case") }

    /** Gets the enum declaration that this case class belongs to. */
    ClassLikeDeclaration getEnumClass() { this = result.getAMember() }

    /** Gets the constructor of this algebraic data type. */
    EnumCaseConstructor getConstructor() { result = this.getAMember() }
  }

  /**
   * The constructor of a class representing one of the branches of an algebraic data type.
   *
   * In Swift, a class with a single constructor is generated for each `case` with data parameters in an `enum` declaration. Example:
   *
   * ```swift
   * enum E {
   *   case foo(Int)
   * }
   * ```
   *
   * is modeled as
   *
   * ```swift
   * class E {
   *   class foo {
   *     init(_ x : Int)
   *   }
   * }
   * ```
   */
  final class EnumCaseConstructor extends ConstructorDeclaration {
    EnumCaseConstructor() { this = any(EnumCaseClass cls).getAMember() }

    /** Gets the class containing this constructor. */
    EnumCaseClass getEnumCaseClass() { result.getAMember() = this }

    /** Gets the enum declaration that this constructor belongs to. */
    ClassLikeDeclaration getEnumClass() { result = this.getEnumCaseClass().getEnumClass() }
  }

  /**
   * A field of an enum case in an algebraic data type. For example `a` and
   * `b` in
   *
   * ```swift
   * enum E {
   *   case a
   *   case b
   * }
   * ```
   */
  final class EnumField extends VariableDeclaration {
    private ClassLikeDeclaration enum;

    EnumField() {
      this = enum.getAMember() and
      this.hasModifier("enum_case")
    }

    /** Gets the enum declaration that this enum field belongs to. */
    ClassLikeDeclaration getEnumClass() { result = enum }
  }
}
