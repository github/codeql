import javascript

query predicate symbols(ASTNode astNode, CanonicalName symbol) { ast_node_symbol(astNode, symbol) }

from Import imprt
select imprt, imprt.getImportedModule()
