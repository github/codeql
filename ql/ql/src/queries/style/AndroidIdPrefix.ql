/**
 * @name Android query without android @id prefix
 * @description Android queries should include the `android/` prefix in their `@id`.
 * @kind problem
 * @problem.severity warning
 * @id ql/android-id-prefix
 * @precision high
 */

import ql

/** Holds if `t` transitively imports an Android module. */
predicate importsAndroidModule(TopLevel t) {
  t.getFile() =
    any(YAML::QLPack pack | pack.getADependency*().getExtractor() = "java").getAFileInPack() and
  exists(Import i | t.getAnImport() = i |
    i.getImportString().toLowerCase().matches("%android%")
    or
    exists(TopLevel t2 |
      t2.getAModule() = i.getResolvedModule().asModule() and
      importsAndroidModule(t2)
    )
  )
}

from QueryDoc d
where
  d.getLocation().getFile().getRelativePath().matches("%src/Security/%") and
  not d.getQueryId().matches("android/%") and
  not d.getQueryId() = ["improper-intent-verification", "improper-webview-certificate-validation"] and // known badly identified queries that sadly we can't fix
  importsAndroidModule(d.getParent())
select d, "This Android query is missing the `android/` prefix in its `@id`."
