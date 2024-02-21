import csharp

private string getPath(Assembly a) {
  not a.getCompilation().getOutputAssembly() = a and
  exists(string s | s = a.getFile().getAbsolutePath() |
    result = "[...]/" + s.substring(s.indexOf("newtonsoft.json"), s.length())
  )
}

from Assembly a
select getPath(a)
