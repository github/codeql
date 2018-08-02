import cpp

string functionName(Function f) {
  exists(string name, string templateArgs, string args |
         result = name + templateArgs + args
     and name = f.getQualifiedName()
     and if exists(f.getATemplateArgument())
         then templateArgs = "<" + concat(int i | exists(f.getTemplateArgument(i)) | f.getTemplateArgument(i).toString(), "," order by i) + ">"
         else templateArgs = ""
     and args = "(" + concat(int i | exists(f.getParameter(i)) | f.getParameter(i).getType().toString(), "," order by i) + ")")
}

from Function f, string e
where if f.hasExceptionSpecification()
  then if exists(f.getADeclarationEntry().getNoExceptExpr())
       then e = f.getADeclarationEntry().getNoExceptExpr().toString()
       else e = "<no expr>"
  else e = "<none>"
select f, functionName(f), f.getDeclaringType(), e
