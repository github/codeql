import csharp

private string getPath(File f) {
  result = f.getRelativePath() and
  not exists(
    result
        .indexOf("Microsoft.CodeAnalysis.ResxSourceGenerator.CSharp/Microsoft.CodeAnalysis.ResxSourceGenerator.CSharp.CSharpResxGenerator")
  )
  or
  exists(int index |
    index =
      f.getRelativePath()
          .indexOf("Microsoft.CodeAnalysis.ResxSourceGenerator.CSharp/Microsoft.CodeAnalysis.ResxSourceGenerator.CSharp.CSharpResxGenerator") and
    result =
      f.getRelativePath().substring(0, index - 32 - 2) + "/[...]/" +
        f.getRelativePath().substring(index, f.getRelativePath().length())
  )
}

from File f
where f.fromSource()
select getPath(f)
