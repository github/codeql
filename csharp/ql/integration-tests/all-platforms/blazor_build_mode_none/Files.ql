import csharp

private string razorSourceGenerator() {
  result =
    "Microsoft.CodeAnalysis.Razor.Compiler/Microsoft.NET.Sdk.Razor.SourceGenerators.RazorSourceGenerator"
}

private string getPath(File f) {
  result = f.getRelativePath() and
  not exists(result.indexOf(razorSourceGenerator()))
  or
  exists(int index1, string path | path = f.getRelativePath() |
    // pattern =
    //   "Microsoft.CodeAnalysis.Razor.Compiler/Microsoft.NET.Sdk.Razor.SourceGenerators.RazorSourceGenerator" and
    // index1 = f.getRelativePath().indexOf(pattern) and
    // index2 =
    //   f.getRelativePath()
    //       .indexOf("_ql_csharp_ql_integration_tests_all_platforms_blazor_build_mode_none_") and
    // result =
    //   "[...]/" + f.getRelativePath().substring(index1, index1 + pattern.length()) + "/[...]" +
    //     f.getRelativePath().substring(index2, f.getRelativePath().length())
    index1 = path.indexOf(razorSourceGenerator()) and
    result = "[...]/" + f.getRelativePath().substring(index1, path.length())
  )
}

from File f
where f.fromSource() or f.getExtension() = "razor"
select getPath(f)
