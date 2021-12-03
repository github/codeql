import cpp

class FunctionMonkeyPatch extends Function {
  language[monotonicAggregates]
  override string getDescription() {
    exists(string name, string templateArgs, string args |
      result = name + templateArgs + args and
      name = this.getQualifiedName() and
      (
        if exists(this.getATemplateArgument())
        then
          templateArgs =
            "<" +
              concat(int i |
                exists(this.getTemplateArgument(i))
              |
                this.getTemplateArgument(i).toString(), "," order by i
              ) + ">"
        else templateArgs = ""
      ) and
      args =
        "(" +
          concat(int i |
            exists(this.getParameter(i))
          |
            this.getParameter(i).getType().toString(), "," order by i
          ) + ")"
    )
  }
}

class ParameterMonkeyPatch extends Parameter {
  override string getDescription() {
    result = super.getType().getName() + " " + super.getDescription()
  }
}

from Element e, Element ti
where
  e.getLocation().getStartLine() != 0 and // unhelpful
  not (function_instantiation(unresolveElement(e), _) and e = ti) and // trivial
  not (class_instantiation(unresolveElement(e), _) and e = ti) and // trivial
  not (variable_instantiation(unresolveElement(e), _) and e = ti) and // trivial
  e.isFromTemplateInstantiation(ti)
select e, ti
