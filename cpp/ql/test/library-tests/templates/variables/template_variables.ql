import cpp

string describe(Variable v) {
  v instanceof TemplateVariable and
  result = "TemplateVariable"
}

from Variable v
select v, concat(VariableAccess a | a.getTarget() = v | a.getLocation().toString(), ", "),
  concat(int i | | v.getTemplateArgument(i).toString(), ", " order by i), concat(describe(v), ", ")
