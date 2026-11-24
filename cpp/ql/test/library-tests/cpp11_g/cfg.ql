import cpp

string arguments(Function f) {
  result = concat(int i | | f.getTemplateArgument(i).toString(), "," order by i)
}

string name(Function f) {
  if f.isConstructedFrom(_)
  then result = f.toString() + "<" + arguments(f) + ">"
  else
    if f instanceof TemplateFunction
    then result = f.toString() + " prototype instantiation"
    else result = f.toString()
}

from ControlFlowNode x, ControlFlowNode y
where y = x.getASuccessor()
select name(x.getControlFlowScope()), x.getLocation().getStartLine(),
  count(x.getAPredecessor*()), // This helps order things sensibly
  x.toString(), y.getLocation().getStartLine(), y.toString()
