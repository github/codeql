// Change the second column in named_patterns from a @var_decl to a string
class NamedPattern extends @named_pattern {
  VarDecl getVarDecl() { named_patterns(this, result) }

  string toString() { none() }
}

class VarDecl extends @var_decl {
  string getName() { var_decls(this, result, _) }

  string toString() { none() }
}

from NamedPattern np, VarDecl d, string name
where d = np.getVarDecl() and name = d.getName()
select np, name
