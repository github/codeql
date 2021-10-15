import cpp

from Element e, string s, Type arg
where
  s = "ClassTemplateInstantiation" and
  arg = e.(ClassTemplateInstantiation).getATemplateArgument()
  or
  s = "FunctionTemplateInstantiation" and
  arg = e.(FunctionTemplateInstantiation).getATemplateArgument()
select e, s, arg
