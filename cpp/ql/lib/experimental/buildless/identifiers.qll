import ast_sig
import ast
import compiled_ast // For debugging in context

module BuildlessIdentifiers<BuildlessASTSig A> {
  module AST = Buildless<A>;

  string getQualifiedName(AST::SourceNamespace ns) {
    not exists(AST::SourceNamespace p | ns = p.getAChild()) and result = ns.getName()
    or
    exists(AST::SourceNamespace p | ns = p.getAChild() and ns !=p|
      result = getQualifiedName(p) + "::" + ns.getName()
    )
  }

  predicate namespace(string ns) {
    ns = ["", getQualifiedName(_)]
  }

  // What are the identifiers in scope at a given point in the program?
  // Give a potential object that the identifier refers to
  AST::SourceDeclaration nameLookup(AST::SourceScope scope) {
    result = scope
    or
    result = scope.(AST::SourceNamespace).getAChild()
    or
    result = scope.(AST::SourceTypeDefinition).getAMember()
  }
}

module TestIdentifiers = BuildlessIdentifiers<CompiledAST>;
