import csharp
import semmle.code.csharp.commons.Compilation

bindingset[arg]
private string normalize(string arg) {
  (not exists(arg.indexOf(":")) or not exists(arg.indexOf("/8.0"))) and
  result = arg
  or
  exists(int i, int j |
    i = arg.indexOf(":") and
    j = arg.indexOf("/8.0") and
    result = arg.substring(0, i + 1) + "[...]" + arg.substring(j, arg.length())
  )
}

from Compilation c, int i, string s
where s = normalize(c.getExpandedArgument(i))
select i, s
