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

  private class DbSink extends SQL::QueryString::Range {
    DbSink() {
      exists(Method m, string methodName, int argNum |
        m.hasQualifiedName(packagePath(), "DB", methodName) and
        (
          methodName = ["Exec", "Prepare", "Query", "QueryRow"] and
          argNum = 0
          or
          methodName = ["ExecContext", "PrepareContext", "QueryContext", "QueryRowContext"] and
          argNum = 1
        )
      |
        this = m.getACall().getArgument(argNum)
      )
    }
  }

  private class QueryBuilderSink extends SQL::QueryString::Range {
    // Note this class doesn't do any escaping, unlike the true ORM part of the package
    QueryBuilderSink() {
      exists(Method impl | impl.implements(packagePath(), "QueryBuilder", _) |
        this = impl.getACall().getASyntacticArgument()
      ) and
      this.getType().getUnderlyingType() instanceof StringType
    }
  }

  private class OrmerRawSink extends SQL::QueryString::Range {
    OrmerRawSink() {
      exists(Method impl | impl.implements(packagePath(), "Ormer", "Raw") |
        this = impl.getACall().getArgument(0)
      )
    }
  }

  private class QuerySeterFilterRawSink extends SQL::QueryString::Range {
    QuerySeterFilterRawSink() {
      exists(Method impl | impl.implements(packagePath(), "QuerySeter", "FilterRaw") |
        this = impl.getACall().getArgument(1)
      )
    }
  }

  private class ConditionRawSink extends SQL::QueryString::Range {
    ConditionRawSink() {
      exists(Method impl | impl.implements(packagePath(), "Condition", "Raw") |
        this = impl.getACall().getArgument(1)
      )
    }
  }

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
