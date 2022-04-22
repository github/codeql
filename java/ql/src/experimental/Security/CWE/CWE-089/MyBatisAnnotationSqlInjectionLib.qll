/**
 * Provides classes for SQL injection detection regarding MyBatis annotated methods.
 */

import java
import MyBatisCommonLib

/** An argument of a MyBatis annotated method. */
class MyBatisAnnotatedMethodCallArgument extends DataFlow::Node {
  MyBatisAnnotatedMethodCallArgument() {
    exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma | ma.getMethod() = msoam |
      ma.getAnArgument() = this.asExpr()
    )
  }
}
