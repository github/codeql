import codeql.Locations
private import TreeSitter
private import codeql.ruby.ast.Erb

cached
private module Cached {
  cached
  newtype TAstNode =
    TCommentDirective(Erb::CommentDirective g) or
    TDirective(Erb::Directive g) or
    TGraphqlDirective(Erb::GraphqlDirective g) or
    TOutputDirective(Erb::OutputDirective g) or
    TTemplate(Erb::Template g) or
    TToken(Erb::Token g) or
    TComment(Erb::Comment g) or
    TCode(Erb::Code g)

  /**
   * Gets the underlying TreeSitter entity for a given erb AST node.
   */
  cached
  Erb::AstNode toGenerated(ErbAstNode n) {
    n = TCommentDirective(result) or
    n = TDirective(result) or
    n = TGraphqlDirective(result) or
    n = TOutputDirective(result) or
    n = TTemplate(result) or
    n = TToken(result) or
    n = TComment(result) or
    n = TCode(result)
  }

  cached
  Location getLocation(ErbAstNode n) { result = toGenerated(n).getLocation() }
}

import Cached

TAstNode fromGenerated(Erb::AstNode n) { n = toGenerated(result) }

class TDirectiveNode = TCommentDirective or TDirective or TGraphqlDirective or TOutputDirective;

class TTokenNode = TToken or TComment or TCode;
