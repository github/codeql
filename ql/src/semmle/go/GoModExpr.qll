/**
 * Provides classes for working with go.mod expressions.
 */

import go

/**
 * A go.mod expression.
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
 * A line that contains the module information
 */
class GoModModuleLine extends GoModLine {
  GoModModuleLine() {
    this.getParent().(GoModLineBlock).getToken(0) = "module"
    or
    not this.getParent() instanceof GoModLineBlock and
    this.getToken(0) = "module"
  }

  string getPath() {
    if this.getParent() instanceof GoModLineBlock
    then result = this.getToken(1)
    else result = this.getToken(0)
  }

  override string toString() { result = "go.mod module line" }
}

/**
 * A factored block of lines, for example `require ( "path" )`.
 */
class GoModLineBlock extends @modlineblock, GoModExpr {
  /**
   * Gets the `i`th token of this line block.
   */
  string getToken(int i) { modtokens(result, this, i) }

  override string toString() { result = "go.mod line block" }
}

/**
 * A line that declares the Go version to be used, for example `go 1.14`.
 */
class GoModGoLine extends GoModLine {
  GoModGoLine() { this.getToken(0) = "go" }

  /** Gets the Go version declared. */
  string getVer() { result = this.getToken(1) }

  override string toString() { result = "go.mod go line" }
}

private string getOffsetToken(GoModLine line, int i) {
  if line.getParent() instanceof GoModLineBlock
  then result = line.getToken(i - 1)
  else result = line.getToken(i)
}

/**
 * A line that declares a requirement, for example `require "path"`.
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
  string getVer() { result = getOffsetToken(this, 2) }

  override string toString() { result = "go.mod require line" }
}

/**
 * A line that declares a dependency version to exclude, for example `exclude "ver"`.
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
  string getVer() { result = getOffsetToken(this, 2) }

  override string toString() { result = "go.mod exclude line" }
}

/**
 * A line that specifies a dependency to use instead of another one, for example
 * `replace "a" => "b" ver`.
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

  /** Gets the path of the replacement dependency. */
  string getReplacementPath() { result = getOffsetToken(this, 3) }

  /** Gets the version of the replacement dependency. */
  string getReplacementVer() { result = getOffsetToken(this, 4) }

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
