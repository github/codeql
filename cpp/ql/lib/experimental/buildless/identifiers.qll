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
    ns = "" // The global namespace
    or
    exists(AST::SourceNamespace n | n.getName() = ns)
  }

  // What are the identifiers in scope at a given point in the program?
  // Give a potential object that the identifier refers to
  predicate identifiers(AST::SourceScope scope, string name, AST::SourceElement decl) {
    scope.(AST::SourceNamespace).getName() = name and decl = scope
    or
    decl = scope.(AST::SourceNamespace).getAChild() and
    name = decl.(AST::SourceDeclaration).getName()
  }
}

module TestIdentifiers = BuildlessIdentifiers<CompiledAST>;
