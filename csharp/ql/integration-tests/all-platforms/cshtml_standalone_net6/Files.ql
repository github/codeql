import csharp

private string getPath(File f) {
  result = f.getRelativePath() and
  not exists(result.indexOf("EC52D77FE9BF67AD10C5C3F248392316"))
  or
  exists(int index0, int index1, string pattern0, string pattern1 |
    // TODO: Remove index0 and pattern0. Currently there's some instability in the path depending on which dotnet SDK is being used. (See issue #448)
    pattern0 = "EC52D77FE9BF67AD10C5C3F248392316" and
    index0 = f.getRelativePath().indexOf(pattern0) and
    pattern1 = "Microsoft.NET.Sdk.Razor.SourceGenerators.RazorSourceGenerator" and
    index1 = f.getRelativePath().indexOf(pattern1) and
    result =
      f.getRelativePath().substring(0, index0 + pattern0.length()) + "/[...]/" +
        f.getRelativePath().substring(index1, f.getRelativePath().length())
  )
}

from File f
where f.fromSource() or f.getExtension() = "cshtml"
select getPath(f)
