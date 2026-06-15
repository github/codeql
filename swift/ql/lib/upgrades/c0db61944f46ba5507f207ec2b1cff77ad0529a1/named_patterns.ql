// Change the second column in named_patterns from a string a @var_decl using the same logic that used to be in the Swift QL libraries
class Pattern extends @pattern {
  string toString() { none() }
}

class NamedPattern extends @named_pattern {
  string getName() { named_patterns(this, result) }

  VarDecl getVarDecl() {
    this.getImmediateEnclosingPattern*() = result.getImmediateParentPattern() and
    pragma[only_bind_out](result.getName()) = pragma[only_bind_out](this.getName())
  }

  Pattern getImmediateEnclosingPattern() {
    enum_element_pattern_sub_patterns(result, this)
    or
    optional_some_patterns(result, this)
    or
    tuple_pattern_elements(result, _, this)
    or
    binding_patterns(result, this)
    or
    is_pattern_sub_patterns(result, this)
    or
    paren_patterns(result, this)
    or
    typed_patterns(result, this)
  }

  string toString() { none() }
}

class VarDecl extends @var_decl {
  string getName() { var_decls(this, result, _) }

  Pattern getImmediateParentPattern() { var_decl_parent_patterns(this, result) }

  string toString() { none() }
}

from NamedPattern np, string name, VarDecl varDecl
where np.getName() = name and varDecl = np.getVarDecl()
select np, varDecl
