import csharp

private string getPath(Assembly a) {
  not a.getCompilation().getOutputAssembly() = a and
  exists(string s | s = a.getFile().getAbsolutePath() |
    result =
      "[...]" +
        s.substring(s.indexOf("test-db/working/") + "test-db/working/".length() + 16 +
            "/legacypackages".length(), s.length())
    // TODO: include all other assemblies from the test results. Initially disable because mono installations were problematic on ARM runners.
  )
}

from Assembly a
select getPath(a)
