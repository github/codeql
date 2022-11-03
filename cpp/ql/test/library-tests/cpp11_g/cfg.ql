import cpp
import semmle.code.cpp.exprs.ObjectiveC

string arguments(Function f, int i) {
  result = "," and i = -1
  or
  result = "" and i = min(int j | function_template_argument(unresolveElement(f), j, _)) - 1
  or
  result = arguments(f, i - 1) + "," + f.getTemplateArgument(i).toString()
}

string name(Function f) {
  if f.isConstructedFrom(_)
  then result = f.toString() + "<" + max(arguments(f, _)).suffix(1) + ">"
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
