/**
 * @name Android query without android @id prefix
 * @description Android queries should include the `android` prefix in their `@id`.
 * @kind problem
 * @problem.severity warning
 * @id ql/android-id-prefix
 * @precision high
 */

import ql

string getIdProperty(QLDoc doc) {
  result = any(string id | id = doc.getContents().splitAt("@") and id.matches("id %"))
}

predicate importsAndroidModule(TopLevel t) {
  exists(Import i | t.getAnImport() = i |
    i.getImportString().toLowerCase().matches("%android%")
    or
    exists(TopLevel t2 |
      t2.getAModule() = i.getResolvedModule().asModule() and
      importsAndroidModule(t2)
    )
  )
}

from TopLevel t
where
  t.getLocation().getFile().getRelativePath().matches("%src/Security/%.ql") and
  not getIdProperty(t.getQLDoc()).matches("% java/android/%") and
  importsAndroidModule(t)
select t, "This Android query is missing the `android` prefix in its `@id`."
