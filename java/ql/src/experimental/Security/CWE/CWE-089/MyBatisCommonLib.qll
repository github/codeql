/**
 * Provides public classes for MyBatis SQL injection detection.
 */

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

/** A data flow configuration tracing flow from ibatis `Configuration.getVariables()` to a store into a `Properties` object. */
private class PropertiesFlowConfig extends DataFlow2::Configuration {
  PropertiesFlowConfig() { this = "PropertiesFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma | ma.getMethod() instanceof IbatisConfigurationGetVariablesMethod |
      src.asExpr() = ma
    )
  }

  override predicate isSink(DataFlow::Node sink) { propertiesKey(sink, _) }
}

/** Gets a `Properties` key that may map onto a Mybatis `Configuration` variable. */
string getAMybatisConfigurationVariableKey() {
  exists(PropertiesFlowConfig conf, DataFlow::Node n |
    propertiesKey(n, result) and
    conf.hasFlowTo(n)
  )
}

/** A reference type that extends a parameterization of `java.util.List`. */
class ListType extends RefType {
  ListType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "List")
  }
}

/** Holds if the specified `method` uses MyBatis Mapper XMLElement `mmxx`. */
predicate myBatisMapperXmlElementFromMethod(Method method, MyBatisMapperXmlElement mmxx) {
  exists(MyBatisMapperSqlOperation mbmxe | mbmxe.getMapperMethod() = method |
    mbmxe.getAChild*() = mmxx
    or
    exists(MyBatisMapperSql mbms |
      mbmxe.getInclude().getRefid() = mbms.getId() and
      mbms.getAChild*() = mmxx
    )
  )
}

/** DEPRECATED: Alias for myBatisMapperXmlElementFromMethod */
deprecated predicate myBatisMapperXMLElementFromMethod = myBatisMapperXmlElementFromMethod/2;

/** Holds if the specified `method` has Ibatis Sql operation annotation `isoa`. */
predicate myBatisSqlOperationAnnotationFromMethod(Method method, IbatisSqlOperationAnnotation isoa) {
  exists(MyBatisSqlOperationAnnotationMethod msoam |
    msoam = method and
    msoam.getAnAnnotation() = isoa
  )
}

/** Gets a `#{...}` or `${...}` expression argument in XML element `xmle`. */
string getAMybatisXmlSetValue(XMLElement xmle) {
  result = xmle.getTextValue().regexpFind("(#|\\$)\\{[^\\}]*\\}", _, _)
}

/** Gets a `#{...}` or `${...}` expression argument in annotation `isoa`. */
string getAMybatisAnnotationSqlValue(IbatisSqlOperationAnnotation isoa) {
  result = isoa.getSqlValue().regexpFind("(#|\\$)\\{[^\\}]*\\}", _, _)
}

/**
 * Holds if `node` is an argument to `ma` that is vulnerable to SQL injection attacks if `unsafeExpression` occurs in a MyBatis SQL expression.
 *
 * This case currently assumes all `${...}` expressions are potentially dangerous when there is a non-`@Param` annotated, collection-typed parameter to `ma`.
 */
bindingset[unsafeExpression]
predicate isMybatisCollectionTypeSqlInjection(
  DataFlow::Node node, MethodAccess ma, string unsafeExpression
) {
  not unsafeExpression.regexpMatch("\\$\\{" + getAMybatisConfigurationVariableKey() + "\\}") and
  // The parameter type of the MyBatis method parameter is Map or List or Array.
  // SQL injection vulnerability caused by improper use of this parameter.
  // e.g.
  //
  // ```java
  //    @Select(select id,name from test where name like '%${value}%')
  //    Test test(Map map);
  // ```
  exists(int i |
    not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
    (
      ma.getMethod().getParameterType(i) instanceof MapType or
      ma.getMethod().getParameterType(i) instanceof ListType or
      ma.getMethod().getParameterType(i) instanceof Array
    ) and
    unsafeExpression.matches("${%}") and
    ma.getArgument(i) = node.asExpr()
  )
}

/**
 * Holds if `node` is an argument to `ma` that is vulnerable to SQL injection attacks if `unsafeExpression` occurs in a MyBatis SQL expression.
 *
 * This accounts for:
 * - arguments referred to by a name given in a `@Param` annotation,
 * - arguments referred to by ordinal position, like `${param1}`
 * - references to class instance fields
 * - any `${}` expression where there is a single, non-`@Param`-annotated argument to `ma`.
 */
bindingset[unsafeExpression]
predicate isMybatisXmlOrAnnotationSqlInjection(
  DataFlow::Node node, MethodAccess ma, string unsafeExpression
) {
  not unsafeExpression.regexpMatch("\\$\\{" + getAMybatisConfigurationVariableKey() + "\\}") and
  (
    // The method parameters use `@Param` annotation. Due to improper use of this parameter, SQL injection vulnerabilities are caused.
    // e.g.
    //
    // ```java
    //    @Select(select id,name from test order by ${orderby,jdbcType=VARCHAR})
    //    void test(@Param("orderby") String name);
    // ```
    exists(Annotation annotation |
      unsafeExpression
          .matches("${" + annotation.getValue("value").(CompileTimeConstantExpr).getStringValue() +
              "%}") and
      annotation.getType() instanceof TypeParam and
      ma.getAnArgument() = node.asExpr()
    )
    or
    // MyBatis default parameter sql injection vulnerabilities.the default parameter form of the method is arg[0...n] or param[1...n].
    // e.g.
    //
    // ```java
    //    @Select(select id,name from test order by ${arg0,jdbcType=VARCHAR})
    //    void test(String name);
    // ```
    exists(int i |
      not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
      (
        unsafeExpression.matches("${param" + (i + 1) + "%}")
        or
        unsafeExpression.matches("${arg" + i + "%}")
      ) and
      ma.getArgument(i) = node.asExpr()
    )
    or
    // SQL injection vulnerability caused by improper use of MyBatis instance class fields.
    // e.g.
    //
    // ```java
    //    @Select(select id,name from test order by ${name,jdbcType=VARCHAR})
    //    void test(Test test);
    // ```
    exists(int i, RefType t |
      not ma.getMethod().getParameter(i).getAnAnnotation().getType() instanceof TypeParam and
      ma.getMethod().getParameterType(i).getName() = t.getName() and
      unsafeExpression.matches("${" + t.getAField().getName() + "%}") and
      ma.getArgument(i) = node.asExpr()
    )
    or
    // This method has only one parameter and the parameter is not annotated with `@Param`. The parameter can be named arbitrarily in the SQL statement.
    // If the number of method variables is greater than one, they cannot be named arbitrarily.
    // Improper use of this parameter has a SQL injection vulnerability.
    // e.g.
    //
    // ```java
    //    @Select(select id,name from test where name like '%${value}%')
    //    Test test(String name);
    // ```
    exists(int i | i = 1 |
      ma.getMethod().getNumberOfParameters() = i and
      not ma.getMethod().getAParameter().getAnAnnotation().getType() instanceof TypeParam and
      unsafeExpression.matches("${%}") and
      ma.getAnArgument() = node.asExpr()
    )
  )
}
