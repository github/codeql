/**
 * @name Misconfigured ContentProvider use
 * @description ContentProvider#openFile override which does not use `mode` argument.
 * @kind problem
 * @id java/android/misconfigured-content-provider
 * @problem.severity warning
 * @security-severity 7.8
 * @tags security external/cwe/cwe-276
 * @precision medium
 */

import java

class ContentProviderOpenFileMethod extends Method {
  ContentProviderOpenFileMethod() {
    this.hasName("openFile") and
    this.getDeclaringType().getASupertype*().hasQualifiedName("android.content", "ContentProvider")
  }

  predicate doesNotCheckMode() {
    exists(Parameter p | p = this.getParameter(1) | not exists(p.getAnAccess()))
  }
}

from ContentProviderOpenFileMethod ofm
where ofm.doesNotCheckMode()
select ofm, "Open file"
