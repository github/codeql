import csharp

private string getPath(Assembly a) {
  not a.getCompilation().getOutputAssembly() = a and
  exists(string s | s = a.getFile().getAbsolutePath() |
    result =
      s.substring(s.indexOf("GitHub/packages/") + "GitHub/packages/".length() + 16, s.length())
    or
    result =
      s.substring(s.indexOf("GitHub/legacypackages/") + "GitHub/legacypackages/".length() + 16,
        s.length())
    // TODO: excluding all other assemblies from the test result as mono installations seem problematic on ARM runners.
    // or
    // result = s.substring(s.indexOf("lib/mono/") + "lib/mono/".length(), s.length())
    // or
    // result = s and
    // not exists(s.indexOf("GitHub/packages/")) and
    // not exists(s.indexOf("GitHub/legacypackages/")) and
    // not exists(s.indexOf("lib/mono/"))
  )
}

from Assembly a
select getPath(a)
