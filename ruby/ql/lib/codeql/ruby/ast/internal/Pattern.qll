overlay[local]
module;

private import codeql.ruby.AST
private import codeql.ruby.ast.internal.Expr
private import codeql.ruby.ast.internal.Parameter
private import AST
private import TreeSitter

/**
 * Holds if `node` is a case pattern.
 */
predicate casePattern(Ruby::AstNode node) {
  node = any(Ruby::TestPattern parent).getPattern()
  or
  node = any(Ruby::MatchPattern parent).getPattern()
  or
  node = any(Ruby::InClause parent).getPattern()
  or
  node = any(Ruby::ArrayPattern parent).getChild(_).(Ruby::UnderscorePatternExpr)
  or
  node = any(Ruby::FindPattern parent).getChild(_).(Ruby::UnderscorePatternExpr)
  or
  node = any(Ruby::AlternativePattern parent).getAlternatives(_)
  or
  node = any(Ruby::AsPattern parent).getValue()
  or
  node = any(Ruby::KeywordPattern parent).getValue()
  or
  node = any(Ruby::ParenthesizedPattern parent).getChild()
  or
  node = any(Ruby::ArrayPattern p).getClass()
  or
  node = any(Ruby::FindPattern p).getClass()
  or
  node = any(Ruby::HashPattern p).getClass()
}
