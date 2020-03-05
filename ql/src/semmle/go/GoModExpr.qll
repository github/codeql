/**
 * Provides classes for working with go.mod expressions.
 */

import go

/**
 * An expression in a go.mod file, which is used to declare dependencies.
 */
class GoModExpr extends @modexpr, GoModExprParent {
  /**
   * Gets the kind of this expression, which is an integer value representing the expression's
   * node type.
   *
   * Note that the mapping from node types to integer kinds is considered an implementation detail
   * and subject to change without notice.
   */
  int getKind() { modexprs(this, result, _, _) }

  /**
   * Get the comment group associated with this expression.
   */
  DocComment getComments() { result.getDocumentedElement() = this }

  /** Gets path of the module of this go.mod expression. */
  string getModulePath() {
    exists(GoModModuleLine mod | this.getFile() = mod.getFile() | result = mod.getPath())
  }

  override string toString() { result = "go.mod expression" }
}

/**
 *  A top-level block of comments separate from any rule.
 */
class GoModCommentBlock extends @modcommentblock, GoModExpr { }

/**
 * A single line of tokens.
 */
class GoModLine extends @modline, GoModExpr {
  /**
   * Gets the `i`th token on this line.
   */
  string getToken(int i) { modtokens(result, this, i) }

  override string toString() { result = "go.mod line" }
}

/**
 * A factored block of lines, for example:
 * ```
 * require (
 *   "github.com/github/codeql-go" v1.2.3
 *   "golang.org/x/tools" v3.2.1
 * )
 * ```
 */
class GoModLineBlock extends @modlineblock, GoModExpr {
  /**
   * Gets the `i`th token of this line block.
   */
  string getToken(int i) { modtokens(result, this, i) }

  override string toString() { result = "go.mod line block" }
}

/**
 * Gets the `i`th token of `line`, including the token in the line block declaration, if it there is
 * one.
 */
private string getOffsetToken(GoModLine line, int i) {
  if line.getParent() instanceof GoModLineBlock
  then result = line.getToken(i - 1)
  else result = line.getToken(i)
}

/**
 * A line that contains the module information
 */
class GoModModuleLine extends GoModLine {
  GoModModuleLine() {
    this.getParent().(GoModLineBlock).getToken(0) = "module"
    or
    not this.getParent() instanceof GoModLineBlock and
    this.getToken(0) = "module"
  }

  /**
   * Get the path of the module being declared.
   */
  string getPath() { result = getOffsetToken(this, 1) }

  override string toString() { result = "go.mod module line" }
}

/**
 * A line that declares the Go version to be used, for example `go 1.14`.
 */
class GoModGoLine extends GoModLine {
  GoModGoLine() { this.getToken(0) = "go" }

  /** Gets the Go version declared. */
  string getVersion() { result = this.getToken(1) }

  override string toString() { result = "go.mod go line" }
}

/**
 * A line that declares a requirement, for example `require "github.com/github/codeql-go" v1.2.3`.
 */
class GoModRequireLine extends GoModLine {
  GoModRequireLine() {
    this.getParent().(GoModLineBlock).getToken(0) = "require"
    or
    not this.getParent() instanceof GoModLineBlock and
    this.getToken(0) = "require"
  }

  /** Gets the path of the dependency. */
  string getPath() { result = getOffsetToken(this, 1) }

  /** Gets the version of the dependency. */
  string getVersion() { result = getOffsetToken(this, 2) }

  override string toString() { result = "go.mod require line" }
}

/**
 * A line that declares a dependency version to exclude, for example
 * `exclude "github.com/github/codeql-go" v1.2.3`.
 */
class GoModExcludeLine extends GoModLine {
  GoModExcludeLine() {
    this.getParent().(GoModLineBlock).getToken(0) = "exclude"
    or
    not this.getParent() instanceof GoModLineBlock and
    this.getToken(0) = "exclude"
  }

  /** Gets the path of the dependency to exclude a version of. */
  string getPath() { result = getOffsetToken(this, 1) }

  /** Gets the excluded version. */
  string getVersion() { result = getOffsetToken(this, 2) }

  override string toString() { result = "go.mod exclude line" }
}

/**
 * A line that specifies a dependency to use instead of another one, for example
 * `replace "golang.org/x/tools" => "github.com/golang/tools" v1.2.3`.
 */
class GoModReplaceLine extends GoModLine {
  GoModReplaceLine() {
    this.getParent().(GoModLineBlock).getToken(0) = "replace"
    or
    not this.getParent() instanceof GoModLineBlock and
    this.getToken(0) = "replace"
  }

  /** Gets the path of the dependency to be replaced. */
  string getOriginalPath() { result = getOffsetToken(this, 1) }

  /** Gets the path of the dependency to be replaced, if any. */
  string getOriginalVersion() { result = getOffsetToken(this, 2) and not result = "=>" }

  /** Gets the path of the replacement dependency. */
  string getReplacementPath() {
    if exists(this.getOriginalVersion())
    then result = getOffsetToken(this, 4)
    else result = getOffsetToken(this, 3)
  }

  /** Gets the version of the replacement dependency. */
  string getReplacementVersion() {
    if exists(this.getOriginalVersion())
    then result = getOffsetToken(this, 5)
    else result = getOffsetToken(this, 4)
  }

  override string toString() { result = "go.mod replace line" }
}

/** A left parenthesis for a line block. */
class GoModLParen extends @modlparen, GoModExpr {
  override string toString() { result = "go.mod (" }
}

/** A right parenthesis for a line block. */
class GoModRParen extends @modrparen, GoModExpr {
  override string toString() { result = "go.mod )" }
}
