import java

private string getArgument(Compilation c, int i) {
  exists(string arg | arg = c.getArgument(i) |
    if exists(arg.indexOf("-Xplugin="))
    then result = "<PLUGINS>"
    else
      if exists(string arg0 | arg0 = c.getArgument(i - 1) | arg0 = ["-classpath", "-jdk-home"])
      then result = "<PATH>"
      else result = arg
  )
}

from Compilation c, int i
select i, getArgument(c, i)
