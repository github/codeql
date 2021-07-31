import java
import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources

/** The interface `org.apache.ibatis.annotations.Param`. */
private class TypeParam extends Interface {
  TypeParam() { this.hasQualifiedName("org.apache.ibatis.annotations", "Param") }
}

/** A sink for MyBatis Mapper XML file sql injection vulnerabilities. */
abstract class MyBatisMapperXmlSqlInjectionSink extends DataFlow::Node { }

/**
 * A sink for MyBatis Mapper method parameter name sql injection vulnerabilities.
 *
 * e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${name}%'`
 */
class MyBatisMapperParameterNameSqlInjectionSink extends MyBatisMapperXmlSqlInjectionSink {
  MyBatisMapperParameterNameSqlInjectionSink() {
    exists(
      MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess ma, int i, Method m,
      Expr arg, string sql
    |
      m = ma.getMethod() and arg = ma.getArgument(i)
    |
      arg = this.asExpr() and
      (
        mbmxe.getAChild*().getTextValue().trim() = sql
        or
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*().getTextValue().trim() = sql
      ) and
      not m.getParameter(i).hasAnnotation() and
      sql.matches("%${" + m.getParameter(i).getName() + "%") and
      mbmxe.getId() = ma.getMethod().getName() and
      ma.getMethod().getDeclaringType() =
        mbmxe.getParent().(MyBatisMapperXMLElement).getNamespaceRefType()
    )
  }
}

/**
 * A sink for MyBatis Mapper method Param Annotation sql injection vulnerabilities.
 *
 * e.g. MyBatis Mapper method: `void test(@Param("orderby") String name);` and MyBatis Mapper XML file:`select id,name from test order by ${orderby,jdbcType=VARCHAR}`
 */
class MyBatisMapperParamAnnotationSqlInjectionSink extends MyBatisMapperXmlSqlInjectionSink {
  MyBatisMapperParamAnnotationSqlInjectionSink() {
    exists(
      MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess ma, int i, Method m,
      Expr arg, Annotation a, string sql
    |
      m = ma.getMethod() and arg = ma.getArgument(i)
    |
      arg = this.asExpr() and
      (
        mbmxe.getAChild*().getTextValue().trim() = sql
        or
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*().getTextValue().trim() = sql
      ) and
      m.getParameter(i).hasAnnotation() and
      m.getParameter(i).getAnAnnotation() = a and
      a.getType() instanceof TypeParam and
      sql.matches("%${" + a.getValue("value").(CompileTimeConstantExpr).getStringValue() + "%") and
      mbmxe.getId() = ma.getMethod().getName() and
      ma.getMethod().getDeclaringType() =
        mbmxe.getParent().(MyBatisMapperXMLElement).getNamespaceRefType()
    )
  }
}

/**
 * A sink for MyBatis Mapper method Class Field sql injection vulnerabilities.
 *
 * e.g. MyBatis Mapper method: `void test(Test test);` and MyBatis Mapper XML file:`select id,name from test order by ${name,jdbcType=VARCHAR}`
 */
class MyBatisMapperClassFieldSqlInjectionSink extends MyBatisMapperXmlSqlInjectionSink {
  MyBatisMapperClassFieldSqlInjectionSink() {
    exists(
      MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess ma, int i, Method m,
      Expr arg, string sql, Class c
    |
      m = ma.getMethod() and arg = ma.getArgument(i)
    |
      arg = this.asExpr() and
      (
        mbmxe.getAChild*().getTextValue().trim() = sql
        or
        mbmxe.getInclude().getRefid() = mbms.getId() and
        mbms.getAChild*().getTextValue().trim() = sql
      ) and
      not m.getParameter(i).hasAnnotation() and
      m.getParameterType(i).getName() = c.getName() and
      sql.matches("%${" + c.getAField().getName() + "%") and
      mbmxe.getId() = ma.getMethod().getName() and
      ma.getMethod().getDeclaringType() =
        mbmxe.getParent().(MyBatisMapperXMLElement).getNamespaceRefType()
    )
  }
}
