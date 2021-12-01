/**
 * Provides classes for working with MyBatis mapper xml files and their content.
 */

import java

/**
 * MyBatis Mapper XML file.
 */
class MyBatisMapperXMLFile extends XMLFile {
  MyBatisMapperXMLFile() {
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "mapper" and
    this.getFile().getAbsolutePath().indexOf("/src/main") > 0
  }
}

/**
 * An XML element in a `MyBatisMapperXMLFile`.
 */
class MyBatisMapperXMLElement extends XMLElement {
  MyBatisMapperXMLElement() { this.getFile() instanceof MyBatisMapperXMLFile }

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
abstract class MyBatisMapperSqlOperation extends MyBatisMapperXMLElement {
  abstract string getId();

  /**
   * Gets the `<include>` element in a `MyBatisMapperSqlOperation`.
   */
  MyBatisMapperInclude getInclude() { result = this.getAChild*() }

  /**
   * Gets the method bound to MyBatis Mapper XML File.
   */
  Method getMapperMethod() {
    result.getName() = this.getId() and
    result.getDeclaringType() = this.getParent().(MyBatisMapperXMLElement).getNamespaceRefType()
  }
}

/**
 * A `<insert>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperInsert extends MyBatisMapperSqlOperation {
  MyBatisMapperInsert() { this.getName() = "insert" }

  /**
   * Gets the value of the `id` attribute of this `<insert>`.
   */
  override string getId() { result = this.getAttribute("id").getValue() }
}

/**
 * A `<update>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperUpdate extends MyBatisMapperSqlOperation {
  MyBatisMapperUpdate() { this.getName() = "update" }

  /**
   * Gets the value of the `id` attribute of this `<update>`.
   */
  override string getId() { result = this.getAttribute("id").getValue() }
}

/**
 * A `<delete>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperDelete extends MyBatisMapperSqlOperation {
  MyBatisMapperDelete() { this.getName() = "delete" }

  /**
   * Gets the value of the `id` attribute of this `<delete>`.
   */
  override string getId() { result = this.getAttribute("id").getValue() }
}

/**
 * A `<select>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperSelect extends MyBatisMapperSqlOperation {
  MyBatisMapperSelect() { this.getName() = "select" }

  /**
   * Gets the value of the `id` attribute of this `<select>`.
   */
  override string getId() { result = this.getAttribute("id").getValue() }
}

/**
 * A `<select>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperSql extends MyBatisMapperXMLElement {
  MyBatisMapperSql() { this.getName() = "sql" }

  /**
   * Gets the value of the `id` attribute of this `<sql>`.
   */
  string getId() { result = this.getAttribute("id").getValue() }
}

/**
 * A `<include>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperInclude extends MyBatisMapperXMLElement {
  MyBatisMapperInclude() { this.getName() = "include" }

  /**
   * Gets the value of the `refid` attribute of this `<include>`.
   */
  string getRefid() { result = this.getAttribute("refid").getValue() }
}

/**
 * A `<foreach>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperForeach extends MyBatisMapperXMLElement {
  MyBatisMapperForeach() { getName() = "foreach" }
}
