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
  predicate identifiers(AST::SourceScope scope, string name, AST::SourceDeclaration decl) {
    scope.(AST::SourceDeclaration).getName() = name and decl = scope
    or
    decl = scope.(AST::SourceNamespace).getAChild() and
    name = decl.getName()
    or
    decl = scope.(AST::SourceTypeDefinition).getAMember() and
    name = decl.getName()
  }
}

module TestIdentifiers = BuildlessIdentifiers<CompiledAST>;
