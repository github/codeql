/**
 * Provides classes for SQL injection detection in MyBatis annotation.
 */

import java
import MyBatisCommonLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Properties

/** A sink for MyBatis annotation method call an argument. */
class MyBatisAnnotationMethodCallAnArgument extends DataFlow::Node {
  MyBatisAnnotationMethodCallAnArgument() {
    exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma | ma.getMethod() = msoam |
      ma.getAnArgument() = this.asExpr()
    )
  }
}
