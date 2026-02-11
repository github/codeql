/**
 * Provides classes for working with MyBatis mapper xml files and their content.
 */
deprecated module;

import java

/**
 * MyBatis Mapper XML file.
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
