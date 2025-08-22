/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the `github.com/astaxie/beego/orm` subpackage.
 */

import go
private import semmle.go.security.StoredXssCustomizations

/**
 * Provides classes for working with remote flow sources, sinks and taint propagators
 * from the [Beego ORM](https://github.com/astaxie/beego/orm) subpackage.
 */
module BeegoOrm {
  /** Gets the package name `github.com/astaxie/beego/orm`. */
  string packagePath() { result = package("github.com/astaxie/beego", "orm") }

  private class OrmerSource extends StoredXss::Source {
    OrmerSource() {
      exists(Method impl |
        impl.implements(packagePath(), "Ormer", ["Read", "ReadForUpdate", "ReadOrCreate"])
      |
        this = FunctionOutput::parameter(0).getExitNode(impl.getACall())
      )
    }
  }

  private class StringFieldSource extends StoredXss::Source {
    StringFieldSource() {
      exists(Method m |
        m.hasQualifiedName(packagePath(), ["JSONField", "JsonbField", "TextField"],
          ["RawValue", "String", "Value"])
      |
        this = m.getACall().getResult()
      )
    }
  }

  private class SeterSource extends StoredXss::Source {
    SeterSource() {
      exists(Method impl |
        // All and One are exclusive to QuerySeter, QueryRow[s] are exclusive to RawSeter, the rest are common.
        impl.implements(packagePath(), ["QuerySeter", "RawSeter"],
          [
            "All", "One", "Values", "ValuesList", "ValuesFlat", "RowsToMap", "RowsToStruct",
            "QueryRow", "QueryRows"
          ])
      |
        this = FunctionOutput::parameter(0).getExitNode(impl.getACall())
      )
    }
  }
}
