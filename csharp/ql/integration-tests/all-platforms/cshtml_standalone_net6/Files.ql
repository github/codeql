import csharp

private string getPath(File f) {
  result = f.getRelativePath() and
  not exists(result.indexOf("_ql_csharp_ql_integration_tests_all_platforms_cshtml_standalone_"))
  or
  exists(int index |
    index =
      f.getRelativePath()
          .indexOf("_ql_csharp_ql_integration_tests_all_platforms_cshtml_standalone_") and
    result = f.getRelativePath().substring(index, f.getRelativePath().length())
  )
}

from File f
where f.fromSource() or f.getExtension() = "cshtml"
select getPath(f)
