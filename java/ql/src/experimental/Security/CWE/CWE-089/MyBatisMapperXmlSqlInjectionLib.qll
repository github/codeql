import java
import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.MyBatis
import semmle.code.java.frameworks.Properties

private predicate propertiesKey(DataFlow::Node prop, string key) {
  exists(MethodAccess m |
    m.getMethod() instanceof PropertiesSetPropertyMethod and
    key = m.getArgument(0).(CompileTimeConstantExpr).getStringValue() and
    prop.asExpr() = m.getQualifier()
  )
}

private class PropertiesFlowConfig extends DataFlow2::Configuration {
  PropertiesFlowConfig() { this = "PropertiesFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma | ma.getMethod() instanceof IbatisConfigurationGetVariablesMethod |
      src.asExpr() = ma
    )
  }

  override predicate isSink(DataFlow::Node sink) { propertiesKey(sink, _) }
}

/** Get the key value of Mybatis Configuration Variable. */
private string getAnMybatisConfigurationVariableKey() {
  exists(PropertiesFlowConfig conf, DataFlow::Node n |
    propertiesKey(n, result) and
    conf.hasFlow(_, n)
  )
}

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

/** Get the #{...} or ${...} parameters in the Mybatis mapper xml file */
private string getAnMybatiXmlSetValue(XMLElement xmle) {
  result = xmle.getTextValue().trim().regexpFind("(#|\\$)(\\{([^\\}]*\\}))", _, _)
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
    getAnMybatiXmlSetValue(xmle).matches("${" + mc.getMethod().getParameter(i).getName() + "%}") and
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
    getAnMybatiXmlSetValue(xmle)
        .matches("%${" + annotation.getValue("value").(CompileTimeConstantExpr).getStringValue() +
            "%}") and
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
    getAnMybatiXmlSetValue(xmle).matches("%${" + c.getAField().getName() + "%}") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // The parameter type of MyBatis Mapper method is Map or List or Array, which may cause SQL injection vulnerability.
  // e.g. MyBatis Mapper method: `void test(Map<String, String> params);` and MyBatis Mapper XML file:`select id,name from test where name like '%${name}%'`
  exists(
    MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, int i, string res
  |
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
    res = getAnMybatiXmlSetValue(xmle) and
    res.matches("%${%}") and
    not res.matches("${" + getAnMybatisConfigurationVariableKey() + "}") and
    mc.getArgument(i) = node.asExpr()
  )
  or
  // MyBatis Mapper method string type sql injection vulnerabilities.
  // e.g. MyBatis Mapper method: `void test(String name);` and MyBatis Mapper XML file:`select id,name from test where name like '%${value}%'`
  exists(MyBatisMapperSqlOperation mbmxe, MyBatisMapperSql mbms, MethodAccess mc, string res |
    mbmxe.getMapperMethod() = mc.getMethod()
  |
    (
      mbmxe.getAChild*() = xmle
      or
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = xmle
    ) and
    res = getAnMybatiXmlSetValue(xmle) and
    mc.getMethod().getAParamType() instanceof TypeString and
    mc.getMethod().getNumberOfParameters() = 1 and
    not mc.getMethod().getAParameter().hasAnnotation() and
    res.matches("%${%}") and
    not res.matches("${" + getAnMybatisConfigurationVariableKey() + "}") and
    mc.getAnArgument() = node.asExpr()
  )
}
