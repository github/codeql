import java
import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources

/** The interface `org.apache.ibatis.annotations.Param`. */
private class TypeParam extends Interface {
  TypeParam() { this.hasQualifiedName("org.apache.ibatis.annotations", "Param") }
}

/** A reference type that extends a parameterization of `java.util.List`. */
private class ListType extends RefType {
  ListType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List")
  }
}

/** A sink for MyBatis Mapper method call an argument. */
class MyBatisMapperMethodCallAnArgument extends DataFlow::Node {
  MyBatisMapperMethodCallAnArgument() {
    exists(MyBatisMapperSqlOperation mbmxe, MethodAccess mc |
      mbmxe.getMapperMethod() = mc.getMethod()
    |
      mc.getAnArgument() = this.asExpr()
    )
  }
}

predicate isSqlInjection(DataFlow::Node node, XMLElement xmle) {
  // MyBatis Mapper method parameter name sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${name}%'`
  exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    not mc.getMethod().getParameter(i).hasAnnotation() and
    xmle.getTextValue().trim().matches("%${" + mc.getMethod().getParameter(i).getName() + "%") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis Mapper method Param Annotation sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(@Param("orderby") String name);` and MyBatis Mapper XML file:`select id,name from test order by ${orderby,jdbcType=VARCHAR}`
  exists(
    MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i,
    Annotation annotation
  |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    mc.getMethod().getParameter(i).hasAnnotation() and
    mc.getMethod().getParameter(i).getAnAnnotation() = annotation and
    annotation.getType() instanceof TypeParam and
    xmle.getTextValue()
        .trim()
        .matches("%${" + annotation.getValue("value").(CompileTimeConstantExpr).getStringValue() +
            "%") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis Mapper method Class Field sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(Test test);` and MyBatis Mapper XML file:`select id,name from test order by ${name,jdbcType=VARCHAR}`
  exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i, Class c |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    not mc.getMethod().getParameter(i).hasAnnotation() and
    mc.getMethod().getParameterType(i).getName() = c.getName() and
    xmle.getTextValue().trim().matches("%${" + c.getAField().getName() + "%") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // The parameter type of MyBatis Mapper method is Map or List or Array, which may cause SQL injection vulnerability.
  // e.g. MyBatis Mapper method: `void test(Map<String, String> params);` and MyBatis Mapper XML file:`select id,name from test where name like '%${name}%'`
  exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    not mc.getMethod().getParameter(i).hasAnnotation() and
    (
      mc.getMethod().getParameterType(i) instanceof MapType or
      mc.getMethod().getParameterType(i) instanceof ListType or
      mc.getMethod().getParameterType(i) instanceof Array
    ) and
    xmle.getTextValue().trim().matches("%${%") and
    mc.getArgument(i) = node.asExpr()
  )
}
