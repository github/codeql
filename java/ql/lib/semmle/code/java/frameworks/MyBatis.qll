/**
 * Provides classes and predicates for working with the MyBatis framework.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

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
