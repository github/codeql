/**
 * Provides classes and predicates for working with the MyBatis framework.
 */

import java
import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking

/** The class `org.apache.ibatis.jdbc.SqlRunner`. */
class MyBatisSqlRunner extends RefType {
  MyBatisSqlRunner() { this.hasQualifiedName("org.apache.ibatis.jdbc", "SqlRunner") }
}

private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.apache.ibatis.jdbc;SqlRunner;false;delete;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;insert;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;run;(String);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;selectAll;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;selectOne;(String,Object[]);;Argument[0];sql",
        "org.apache.ibatis.jdbc;SqlRunner;false;update;(String,Object[]);;Argument[0];sql"
      ]
  }
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
  string getSqlValue() {
    result = this.getAValue("value").(CompileTimeConstantExpr).getStringValue()
  }
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

private class MyBatisAbstractSQL extends RefType {
  MyBatisAbstractSQL() { this.hasQualifiedName("org.apache.ibatis.jdbc", "AbstractSQL") }
}

private class MyBatisProvider extends RefType {
  MyBatisProvider() {
    this.hasQualifiedName("org.apache.ibatis.annotations",
      ["Select", "Delete", "Insert", "Update"] + "Provider")
  }
}

private class MyBatisAbstractSQLMethod extends Method {
  string taintedArgs;
  string signature;

  MyBatisAbstractSQLMethod() {
    this.getDeclaringType().getSourceDeclaration() instanceof MyBatisAbstractSQL and
    (
      this.hasName([
          "UPDATE", "SET", "INSERT_INTO", "SELECT", "OFFSET_ROWS", "LIMIT", "OFFSET",
          "FETCH_FIRST_ROWS_ONLY", "DELETE_FROM", "INNER_JOIN", "ORDER_BY", "WHERE", "HAVING",
          "OUTER_JOIN", "LEFT_OUTER_JOIN", "RIGHT_OUTER_JOIN", "GROUP_BY", "FROM", "SELECT_DISTINCT"
        ]) and
      taintedArgs = "Argument[0]" and
      signature = "String"
      or
      this.hasName([
          "SET", "INTO_COLUMNS", "INTO_VALUES", "SELECT_DISTINCT", "FROM", "JOIN", "INNER_JOIN",
          "LEFT_OUTER_JOIN", "RIGHT_OUTER_JOIN", "OUTER_JOIN", "WHERE", "GROUP_BY", "HAVING",
          "ORDER_BY"
        ]) and
      taintedArgs = "Argument[0].ArrayElement" and
      signature = "String[]"
      or
      this.hasName("VALUES") and taintedArgs = "Argument[0..1]" and signature = "String,String"
    )
  }

  string getTaintedArgs() { result = taintedArgs }

  string getCsvSignature() { result = signature }
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
      this.asExpr() = m.getBody().getAStmt().(ReturnStmt).getResult()
    )
  }
}

private class MyBatisProviderStep extends TaintTracking::AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess ma, Annotation a, Method providerMethod |
      exists(int i |
        ma.getArgument(i) = n1.asExpr() and
        providerMethod.getParameter(i) = n2.asParameter()
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

private class MyBatisAbstractSQLToStringStep extends SummaryModelCsv {
  override predicate row(string row) {
    row = ["org.apache.ibatis.jdbc;AbstractSQL;true;toString;;;Argument[-1];ReturnValue;taint"]
  }
}

private class MyBatisAbstractSQLMethodsStep extends SummaryModelCsv {
  override predicate row(string row) {
    exists(MyBatisAbstractSQLMethod m |
      row =
        "org.apache.ibatis.jdbc;AbstractSQL;true;" + m.getName() + ";(" + m.getCsvSignature() +
          ");;" + m.getTaintedArgs() + ";ReturnValue;taint"
    )
  }
}

private class MyBatisAbstractSQLAnonymousClassStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma, ClassInstanceExpr c |
      ma.getMethod() instanceof MyBatisAbstractSQLMethod and
      c.getAnonymousClass().getACallable() = ma.getCaller() and
      node1.asExpr() = ma and
      node2.asExpr() = c
    )
  }
}
