import csharp

private string getPath(File f) {
  result = f.getRelativePath()
  or
  not exists(f.getRelativePath()) and
  exists(int index |
    index =
      f.getBaseName()
          .indexOf("_semmle_code_target_codeql_csharp_integration_tests_ql_csharp_ql_integration_tests_all_platforms_cshtml_standalone_") and
    result = f.getBaseName().substring(index, f.getBaseName().length())
  )
}

from File f
where f.fromSource() or f.getExtension() = "cshtml"
select getPath(f)
