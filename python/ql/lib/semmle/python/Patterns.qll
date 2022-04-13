/**
 * Wrapping generated AST classes: `Pattern_` and subclasses.
 */

import python

/** A pattern in a match statement */
class Pattern extends Pattern_, AstNode {
  /** Gets the scope of this pattern */
  override Scope getScope() { result = this.getCase().getScope() }

  /** Gets the case statement containing this pattern */
  pragma[nomagic]
  Case getCase() { result.contains(this) }

  override string toString() { result = "Pattern" }

  /** Gets the module enclosing this pattern */
  Module getEnclosingModule() { result = this.getScope().getEnclosingModule() }

  /** Whether the parenthesized property of this expression is true. */
  predicate isParenthesized() { Pattern_.super.isParenthesised() }

  override Location getLocation() { result = Pattern_.super.getLocation() }

  /** Gets an immediate (non-nested) sub-expression of this pattern */
  Expr getASubExpression() { none() }

  /** Gets an immediate (non-nested) sub-statement of this pattern */
  Stmt getASubStatement() { none() }

  /** Gets an immediate (non-nested) sub-pattern of this pattern */
  Pattern getASubPattern() { none() }

  override AstNode getAChildNode() {
    result = this.getASubExpression()
    or
    result = this.getASubStatement()
    or
    result = this.getASubPattern()
  }
}

/** An as-pattern in a match statement: `<subpattern> as alias` */
class MatchAsPattern extends MatchAsPattern_ {
  override Pattern getASubPattern() { result = this.getPattern() }

  override Expr getASubExpression() { result = this.getAlias() }

  override Name getAlias() { result = super.getAlias() }
}

/** An or-pattern in a match statement: `(<pattern1>|<pattern2>)` */
class MatchOrPattern extends MatchOrPattern_ {
  override Pattern getASubPattern() { result = this.getAPattern() }
}

/** A literal pattern in a match statement: `42` */
class MatchLiteralPattern extends MatchLiteralPattern_ {
  override Expr getASubExpression() { result = this.getLiteral() }
}

/** A capture pattern in a match statement: `var` */
class MatchCapturePattern extends MatchCapturePattern_ {
  /* syntax: varname */
  override Expr getASubExpression() { result = this.getVariable() }

  /** Gets the variable that is bound by this capture pattern */
  override Name getVariable() { result = super.getVariable() }
}

/** A wildcard pattern in a match statement: `_` */
class MatchWildcardPattern extends MatchWildcardPattern_ { }

/** A value pattern in a match statement: `Http.OK` */
class MatchValuePattern extends MatchValuePattern_ {
  override Expr getASubExpression() { result = this.getValue() }
}

/** A sequence pattern in a match statement `<p1>, <p2>` */
class MatchSequencePattern extends MatchSequencePattern_ {
  override Pattern getASubPattern() { result = this.getAPattern() }
}

/** A star pattern in a match statement: `(..., *)` */
class MatchStarPattern extends MatchStarPattern_ {
  override Pattern getASubPattern() { result = this.getTarget() }
}

/** A mapping pattern in a match statement: `{'a': var}` */
class MatchMappingPattern extends MatchMappingPattern_ {
  override Pattern getASubPattern() { result = this.getAMapping() }
}

/** A double star pattern in a match statement: `{..., **}` */
class MatchDoubleStarPattern extends MatchDoubleStarPattern_ {
  override Pattern getASubPattern() { result = this.getTarget() }
}

/** A key-value pattern inside a mapping pattern: `a: var` */
class MatchKeyValuePattern extends MatchKeyValuePattern_ {
  override Pattern getASubPattern() { result = this.getKey() or result = this.getValue() }
}

/** A class pattern in a match statement: `Circle(radius = 3)` */
class MatchClassPattern extends MatchClassPattern_ {
  override Expr getASubExpression() { result = this.getClassName() }

  override Pattern getASubPattern() {
    result = this.getAPositional() or result = this.getAKeyword()
  }
}

/** A keyword pattern inside a class pattern: `radius = 3` */
class MatchKeywordPattern extends MatchKeywordPattern_ {
  override Expr getASubExpression() { result = this.getAttribute() }

  override Pattern getASubPattern() { result = this.getValue() }
}
