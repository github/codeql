import python

/** A pattern in a match statement */
class Pattern extends Pattern_, AstNode {
  /** Gets the scope of this pattern */
  override Scope getScope() {
    // TODO: Should it be defined as
    //   py_scopes(this, result)
    // instead?
    result = this.getCase().getScope()
  }

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

class MatchAsPattern extends MatchAsPattern_ {
  override Pattern getASubPattern() { result = this.getPattern() }

  override Expr getASubExpression() { result = this.getAlias() }

  override Name getAlias() { result = super.getAlias() }
}

class MatchOrPattern extends MatchOrPattern_ {
  override Pattern getASubPattern() { result = this.getAPattern() }
}

class MatchLiteralPattern extends MatchLiteralPattern_ {
  override Expr getASubExpression() { result = this.getLiteral() }
}

/** A capture pattern in a match statement */
class MatchCapturePattern extends MatchCapturePattern_ {
  /* syntax: varname */
  override Expr getASubExpression() { result = this.getVariable() }

  /** Gets the variable that is bound by this capture pattern */
  override Name getVariable() { result = super.getVariable() }
}

class MatchWildcardPattern extends MatchWildcardPattern_ { }

class MatchValuePattern extends MatchValuePattern_ {
  override Expr getASubExpression() { result = this.getValue() }
}

/** A sequence pattern in a match statement */
class MatchSequencePattern extends MatchSequencePattern_ {
  override Pattern getASubPattern() { result = this.getAPattern() }
}

class MatchStarPattern extends MatchStarPattern_ {
  override Pattern getASubPattern() { result = this.getTarget() }
}

class MatchMappingPattern extends MatchMappingPattern_ {
  override Pattern getASubPattern() { result = this.getAMapping() }
}

class MatchDoubleStarPattern extends MatchDoubleStarPattern_ {
  override Pattern getASubPattern() { result = this.getTarget() }
}

class MatchKeyValuePattern extends MatchKeyValuePattern_ {
  override Pattern getASubPattern() { result = this.getKey() or result = this.getValue() }
}

class MatchClassPattern extends MatchClassPattern_ {
  override Expr getASubExpression() { result = this.getAClassName() }

  override Pattern getASubPattern() {
    result = this.getAPositional() or result = this.getAKeyword()
  }
}

class MatchKeywordPattern extends MatchKeywordPattern_ {
  override Expr getASubExpression() { result = this.getAttribute() }

  override Pattern getASubPattern() { result = this.getValue() }
}
