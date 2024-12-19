import csharp

private string getPath(File f) {
  result = f.getRelativePath() and
  not exists(
    result.indexOf("_ql_csharp_ql_integration_tests_all_platforms_blazor_build_mode_none_")
  )
  or
  exists(int index1, int index2, string pattern |
    pattern = "Microsoft.NET.Sdk.Razor.SourceGenerators.RazorSourceGenerator" and
    index1 = f.getRelativePath().indexOf(pattern) and
    index2 =
      f.getRelativePath()
          .indexOf("_ql_csharp_ql_integration_tests_all_platforms_blazor_build_mode_none_") and
    result =
      f.getRelativePath().substring(0, index1 + pattern.length()) + "/[...]" +
        f.getRelativePath().substring(index2, f.getRelativePath().length())
  )
}

from File f
where f.fromSource() or f.getExtension() = "razor"
select getPath(f)
