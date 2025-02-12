/**
 * Provides classes and predicates for working with the MyBatis framework.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking

/** The class `org.apache.ibatis.jdbc.SqlRunner`. */
class MyBatisSqlRunner extends RefType {
  MyBatisSqlRunner() { this.hasQualifiedName("org.apache.ibatis.jdbc", "SqlRunner") }
}

/** The class `org.apache.ibatis.session.Configuration`. */
class IbatisConfiguration extends RefType {
  IbatisConfiguration() { this.hasQualifiedName("org.apache.ibatis.session", "Configuration") }
}

/**
 * The method `getVariables()` declared in `org.apache.ibatis.session.Configuration`.
 */
class IbatisConfigurationGetVariablesMethod extends Method {
  IbatisConfigurationGetVariablesMethod() {
    this.getDeclaringType() instanceof IbatisConfiguration and
    this.hasName("getVariables") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * An annotation type that identifies Ibatis select.
 */
private class IbatisSelectAnnotationType extends AnnotationType {
  IbatisSelectAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Select") }
}

/**
 * An annotation type that identifies Ibatis delete.
 */
private class IbatisDeleteAnnotationType extends AnnotationType {
  IbatisDeleteAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Delete") }
}

/**
 * An annotation type that identifies Ibatis insert.
 */
private class IbatisInsertAnnotationType extends AnnotationType {
  IbatisInsertAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Insert") }
}

/**
 * An annotation type that identifies Ibatis update.
 */
private class IbatisUpdateAnnotationType extends AnnotationType {
  IbatisUpdateAnnotationType() { this.hasQualifiedName("org.apache.ibatis.annotations", "Update") }
}

/**
 * An Ibatis SQL operation annotation.
 */
class IbatisSqlOperationAnnotation extends Annotation {
  IbatisSqlOperationAnnotation() {
    this.getType() instanceof IbatisSelectAnnotationType or
    this.getType() instanceof IbatisDeleteAnnotationType or
    this.getType() instanceof IbatisInsertAnnotationType or
    this.getType() instanceof IbatisUpdateAnnotationType
  }

  /**
   * Gets this annotation's SQL statement string.
   */
  string getSqlValue() { result = this.getAStringArrayValue("value") }
}

/**
 * Methods annotated with `@org.apache.ibatis.annotations.Select` or `@org.apache.ibatis.annotations.Delete`
 * or `@org.apache.ibatis.annotations.Update` or `@org.apache.ibatis.annotations.Insert`.
 */
class MyBatisSqlOperationAnnotationMethod extends Method {
  MyBatisSqlOperationAnnotationMethod() {
    this.getAnAnnotation() instanceof IbatisSqlOperationAnnotation
  }
}

/** The interface `org.apache.ibatis.annotations.Param`. */
class TypeParam extends Interface {
  TypeParam() { this.hasQualifiedName("org.apache.ibatis.annotations", "Param") }
}

private class MyBatisProvider extends RefType {
  MyBatisProvider() {
    this.hasQualifiedName("org.apache.ibatis.annotations",
      ["Select", "Delete", "Insert", "Update"] + "Provider")
  }
}

/**
 * A return statement of a method used in a MyBatis Provider.
 *
 * See
 * - `MyBatisProvider`
 * - https://mybatis.org/mybatis-3/apidocs/org/apache/ibatis/annotations/package-summary.html
 */
class MyBatisInjectionSink extends DataFlow::Node {
  MyBatisInjectionSink() {
    exists(Annotation a, Method m |
      a.getType() instanceof MyBatisProvider and
      m.getDeclaringType() = a.getValue(["type", "value"]).(TypeLiteral).getTypeName().getType() and
      m.hasName(a.getValue("method").(StringLiteral).getValue()) and
      exists(ReturnStmt ret | this.asExpr() = ret.getResult() and ret.getEnclosingCallable() = m)
    )
  }
}

private class MyBatisProviderStep extends TaintTracking::AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodCall ma, Annotation a, Method providerMethod |
      exists(int i |
        ma.getArgument(pragma[only_bind_into](i)) = n1.asExpr() and
        providerMethod.getParameter(pragma[only_bind_into](i)) = n2.asParameter()
      )
    |
      a.getType() instanceof MyBatisProvider and
      ma.getMethod().getAnAnnotation() = a and
      providerMethod.getDeclaringType() =
        a.getValue(["type", "value"]).(TypeLiteral).getTypeName().getType() and
      providerMethod.hasName(a.getValue("method").(StringLiteral).getValue())
    )
  }
}

/**
 * A MyBatis Mapper XML file.
 */
class MyBatisMapperXmlFile extends XmlFile {
  MyBatisMapperXmlFile() {
    count(XmlElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "mapper"
  }
}

/**
 * An XML element in a `MyBatisMapperXMLFile`.
 */
class MyBatisMapperXmlElement extends XmlElement {
  MyBatisMapperXmlElement() { this.getFile() instanceof MyBatisMapperXmlFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = this.allCharactersString().trim() }

  /**
   * Gets the reference type bound to MyBatis Mapper XML File.
   */
  RefType getNamespaceRefType() {
    result.getQualifiedName() = this.getAttribute("namespace").getValue()
  }
}

/**
 * An MyBatis Mapper sql operation element.
 */
abstract class MyBatisMapperSqlOperation extends MyBatisMapperXmlElement {
  /**
   * Gets the value of the `id` attribute of MyBatis Mapper sql operation element.
   */
  string getId() { result = this.getAttribute("id").getValue() }

  /**
   * Gets the `<include>` element in a `MyBatisMapperSqlOperation`.
   */
  MyBatisMapperInclude getInclude() { result = this.getAChild*() }

  /**
   * Gets the method bound to MyBatis Mapper XML File.
   */
  Method getMapperMethod() {
    result.getName() = this.getId() and
    result.getDeclaringType() = this.getParent().(MyBatisMapperXmlElement).getNamespaceRefType()
  }
}

/**
 * A `<insert>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperInsert extends MyBatisMapperSqlOperation {
  MyBatisMapperInsert() { this.getName() = "insert" }
}

/**
 * A `<update>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperUpdate extends MyBatisMapperSqlOperation {
  MyBatisMapperUpdate() { this.getName() = "update" }
}

/**
 * A `<delete>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperDelete extends MyBatisMapperSqlOperation {
  MyBatisMapperDelete() { this.getName() = "delete" }
}

/**
 * A `<select>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperSelect extends MyBatisMapperSqlOperation {
  MyBatisMapperSelect() { this.getName() = "select" }
}

/**
 * A `<sql>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperSql extends MyBatisMapperXmlElement {
  MyBatisMapperSql() { this.getName() = "sql" }

  /**
   * Gets the value of the `id` attribute of this `<sql>`.
   */
  string getId() { result = this.getAttribute("id").getValue() }
}

/**
 * A `<include>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperInclude extends MyBatisMapperXmlElement {
  MyBatisMapperInclude() { this.getName() = "include" }

  /**
   * Gets the value of the `refid` attribute of this `<include>`.
   */
  string getRefid() { result = this.getAttribute("refid").getValue() }
}

/**
 * A `<foreach>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperForeach extends MyBatisMapperXmlElement {
  MyBatisMapperForeach() { this.getName() = "foreach" }
}
