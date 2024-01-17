import csharp

private string getPath(Assembly a) {
  not a.getCompilation().getOutputAssembly() = a and
  exists(string s | s = a.getFile().getAbsolutePath() |
    result =
      s.substring(s.indexOf("test-db/working/") + "test-db/working/".length() + 16 +
          "/packages".length(), s.length())
    or
    result = s and
    not exists(s.indexOf("test-db/working/"))
  )
}

from Assembly a
select getPath(a)
