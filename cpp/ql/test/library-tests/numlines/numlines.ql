import cpp

string functionName(Function f) {
  exists(string name, string templateArgs, string args |
    result = name + templateArgs + args and
    name = f.getQualifiedName() and
    (
      if exists(f.getATemplateArgument())
      then
        templateArgs =
          "<" +
            concat(int i |
              exists(f.getTemplateArgument(i))
            |
              f.getTemplateArgument(i).toString(), "," order by i
            ) + ">"
      else templateArgs = ""
    ) and
    args =
      "(" +
        concat(int i |
          exists(f.getParameter(i))
        |
          f.getParameter(i).getType().toString(), "," order by i
        ) + ")"
  )
}

from string resource, int ntotal, int ncode, int ncomment
where
  exists(File f |
    f.getShortName() = resource and numlines(unresolveElement(f), ntotal, ncode, ncomment)
  )
  or
  exists(Function f |
    functionName(f) = resource and numlines(unresolveElement(f), ntotal, ncode, ncomment)
  )
select resource, ntotal, ncode, ncomment
