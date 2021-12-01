/**
 * Provides classes for SQL injection detection in MyBatis annotation.
 */

import java
import MyBatisCommonLib
import semmle.code.xml.MyBatisMapperXML
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

/** Get the #{...} or ${...} parameters in the Mybatis annotation value. */
private string getAnMybatiAnnotationSetValue(IbatisSqlOperationAnnotation isoa) {
  result = isoa.getSqlValue().trim().regexpFind("(#|\\$)\\{[^\\}]*\\}", _, _)
}

predicate isMybatisAnnotationSqlInjection(DataFlow::Node node, IbatisSqlOperationAnnotation isoa) {
  // MyBatis uses an annotation method to perform SQL operations. This method has only one parameter and
  // the parameter is not annotated with `@Param`. Improper use of this parameter has a SQL injection vulnerability.
  // e.g.
  //
  // ```java
  //    @Select(select id,name from test where name like '%${value}%')
  //    Test test(String name);
  // ```
  exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma, string res |
    msoam = ma.getMethod()
  |
    msoam.getAnAnnotation() = isoa and
    res = getAnMybatiAnnotationSetValue(isoa) and
    msoam.getNumberOfParameters() = 1 and
    not ma.getMethod().getAParameter().getAnAnnotation().getType() instanceof TypeParam and
    res.matches("%${%}") and
    not res = "${" + getAnMybatisConfigurationVariableKey() + "}" and
    ma.getAnArgument() = node.asExpr()
  )
  or
  // MyBatis uses an annotation method to perform SQL operations. The parameter type of the method parameter
  // is Map or List or Array. SQL injection vulnerability caused by improper use of this parameter.
  // e.g.
  //
  // ```java
  //    @Select(select id,name from test where name like '%${value}%')
  //    Test test(Map map);
  // ```
  exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma, int i, string res |
    msoam = ma.getMethod()
  |
    msoam.getAnAnnotation() = isoa and
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    (
      ma.getMethod().getParameterType(i) instanceof MapType or
      ma.getMethod().getParameterType(i) instanceof ListType or
      ma.getMethod().getParameterType(i) instanceof Array
    ) and
    res = getAnMybatiAnnotationSetValue(isoa) and
    res.matches("%${%}") and
    not res = "${" + getAnMybatisConfigurationVariableKey() + "}" and
    ma.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis uses annotation methods to perform SQL operations, and SQL injection vulnerabilities caused by
  // improper use of instance class fields.
  // e.g.
  //
  // ```java
  //    @Select(select id,name from test order by ${name,jdbcType=VARCHAR})
  //    void test(Test test);
  // ```
  exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma, int i, RefType t |
    msoam = ma.getMethod()
  |
    msoam.getAnAnnotation() = isoa and
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    ma.getMethod().getParameterType(i).getName() = t.getName() and
    getAnMybatiAnnotationSetValue(isoa).matches("%${" + t.getAField().getName() + "%}") and
    ma.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis uses annotations to perform SQL operations. The method parameters use `@Param` annotation.
  // Due to improper use of this parameter, SQL injection vulnerabilities are caused.
  // e.g.
  //
  // ```java
  //    @Select(select id,name from test order by ${orderby,jdbcType=VARCHAR})
  //    void test(@Param("orderby") String name);
  // ```
  exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma, int i, Annotation annotation |
    msoam = ma.getMethod() and ma.getMethod().getParameter(i).getAnAnnotation() = annotation
  |
    msoam.getAnAnnotation() = isoa and
    annotation.getType() instanceof TypeParam and
    getAnMybatiAnnotationSetValue(isoa)
        .matches("%${" + annotation.getValue("value").(CompileTimeConstantExpr).getStringValue() +
            "%}") and
    ma.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis Mapper method default parameter sql injection vulnerabilities.the default parameter form of the method is arg[0...n] or param[1...n].
  // e.g.
  //
  // ```java
  //    @Select(select id,name from test order by ${arg0,jdbcType=VARCHAR})
  //    void test(String name);
  // ```
  exists(MyBatisSqlOperationAnnotationMethod msoam, MethodAccess ma, int i, string res |
    msoam = ma.getMethod()
  |
    msoam.getAnAnnotation() = isoa and
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    res = getAnMybatiAnnotationSetValue(isoa) and
    (
      res.matches("%${param" + (i + 1) + "%}")
      or
      res.matches("%${arg" + i + "%}")
    ) and
    not res = "${" + getAnMybatisConfigurationVariableKey() + "}" and
    ma.getArgument(i) = node.asExpr()
  )
}
