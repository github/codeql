/**
 * Provides classes for working with go.mod files.
 */

import go

/** A go.mod file. */
class GoModFile extends File {
  GoModFile() { this.getBaseName() = "go.mod" }

  /**
   * Gets the module declaration of this file, that is, the line declaring the path of this module.
   */
  GoModModuleLine getModuleDeclaration() { result.getFile() = this }

  override string getAPrimaryQlClass() { result = "GoModFile" }
}

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

  override GoModFile getFile() { result = GoModExprParent.super.getFile() }

  /** Gets path of the module of this go.mod expression. */
  string getModulePath() { result = this.getFile().getModuleDeclaration().getPath() }

  override string toString() { result = "go.mod expression" }

  override string getAPrimaryQlClass() { result = "GoModExpr" }
}

/**
 *  A top-level block of comments separate from any rule.
 */
class GoModCommentBlock extends @modcommentblock, GoModExpr {
  override string getAPrimaryQlClass() { result = "GoModCommentBlock" }
}

/**
 * A single line of tokens.
 */
class GoModLine extends @modline, GoModExpr {
  /**
   * Gets the `i`th token on this line, 0-based.
   *
   * Generally, one should use `getToken`, as that accounts for lines inside of line blocks.
   */
  string getRawToken(int i) { modtokens(result, this, i) }

  /**
   * Gets the `i`th token of `line`, including the token in the line block declaration, if it there is
   * one, 0-based.
   *
   * This compensates for the fact that lines in line blocks have their 0th token in the line block
   * declaration, and makes dealing with lines more uniform.
   *
   * For example, `.getToken(1)` will result in the dependency path (`github.com/github/codeql-go`)
   * for both lines for normal require lines like `require "github.com/github/codeql-go" v1.2.3` and
   * in a line block like
   *
   * ```
   * require (
   *   "github.com/github/codeql-go" v1.2.3
   *   ...
   * )
   * ```
   *
   * As a special case, when `i` is `0` and the line is in a line block, the result will be the
   * token from the line block.
   */
  string getToken(int i) {
    i = 0 and result = this.getParent().(GoModLineBlock).getRawToken(0)
    or
    if this.getParent() instanceof GoModLineBlock
    then result = this.getRawToken(i - 1)
    else result = this.getRawToken(i)
  }

  override string toString() { result = "go.mod line" }

  override string getAPrimaryQlClass() { result = "GoModLine" }
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
   * Gets the `i`th token of this line block, 0-based.
   *
   * Usually one should not have to use this, as `GoModLine.getToken(0)` will get the token from its
   * parent line block, if any.
   */
  string getRawToken(int i) { modtokens(result, this, i) }

  override string toString() { result = "go.mod line block" }

  override string getAPrimaryQlClass() { result = "GoModLineBlock" }
}

/**
 * A line that contains the module's package path, for example `module github.com/github/codeql-go`.
 */
class GoModModuleLine extends GoModLine {
  GoModModuleLine() { this.getToken(0) = "module" }

  /**
   * Get the path of the module being declared.
   */
  string getPath() { result = this.getToken(1) }

  override string toString() { result = "go.mod module line" }

  override string getAPrimaryQlClass() { result = "GoModModuleLine" }
}

/**
 * A line that declares the Go version to be used, for example `go 1.14`.
 */
class GoModGoLine extends GoModLine {
  GoModGoLine() { this.getToken(0) = "go" }

  /** Gets the Go version declared. */
  string getVersion() { result = this.getToken(1) }

  override string toString() { result = "go.mod go line" }

  override string getAPrimaryQlClass() { result = "GoModGoLine" }
}

/**
 * A line that declares a requirement, for example `require "github.com/github/codeql-go" v1.2.3`.
 */
class GoModRequireLine extends GoModLine {
  GoModRequireLine() { this.getToken(0) = "require" }

  /** Gets the path of the dependency. */
  string getPath() { result = this.getToken(1) }

  /** Gets the version of the dependency. */
  string getVersion() { result = this.getToken(2) }

  override string toString() { result = "go.mod require line" }

  override string getAPrimaryQlClass() { result = "GoModRequireLine" }
}

/**
 * A line that declares a dependency version to exclude, for example
 * `exclude "github.com/github/codeql-go" v1.2.3`.
 */
class GoModExcludeLine extends GoModLine {
  GoModExcludeLine() { this.getToken(0) = "exclude" }

  /** Gets the path of the dependency to exclude a version of. */
  string getPath() { result = this.getToken(1) }

  /** Gets the excluded version. */
  string getVersion() { result = this.getToken(2) }

  override string toString() { result = "go.mod exclude line" }

  override string getAPrimaryQlClass() { result = "GoModExcludeLine" }
}

/**
 * A line that specifies a dependency to use instead of another one, for example
 * `replace "golang.org/x/tools" => "github.com/golang/tools" v1.2.3`.
 */
class GoModReplaceLine extends GoModLine {
  GoModReplaceLine() { this.getToken(0) = "replace" }

  /** Gets the path of the dependency to be replaced. */
  string getOriginalPath() { result = this.getToken(1) }

  /** Gets the path of the dependency to be replaced, if any. */
  string getOriginalVersion() { result = this.getToken(2) and not result = "=>" }

  /** Gets the path of the replacement dependency. */
  string getReplacementPath() {
    if exists(this.getOriginalVersion())
    then result = this.getToken(4)
    else result = this.getToken(3)
  }

  /** Gets the version of the replacement dependency. */
  string getReplacementVersion() {
    if exists(this.getOriginalVersion())
    then result = this.getToken(5)
    else result = this.getToken(4)
  }

  override string toString() { result = "go.mod replace line" }

  override string getAPrimaryQlClass() { result = "GoModReplaceLine" }
}

/** A left parenthesis for a line block. */
class GoModLParen extends @modlparen, GoModExpr {
  override string toString() { result = "go.mod (" }

  override string getAPrimaryQlClass() { result = "GoModLParen" }
}

/** A right parenthesis for a line block. */
class GoModRParen extends @modrparen, GoModExpr {
  override string toString() { result = "go.mod )" }

  override string getAPrimaryQlClass() { result = "GoModRParen" }
}
