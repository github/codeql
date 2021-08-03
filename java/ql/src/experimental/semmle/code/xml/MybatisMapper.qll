import java

/**
 * Holds if any `mapper.xml` files are included in this snapshot.
 */
predicate isMapperXMLIncluded() { exists(MapperXMLFile MapperXML) }

/**
 * mybatis mapper file.
 * Example：
 * SastBatchTaskMapper.xml
 */
class MapperXMLFile extends XMLFile {
  MapperXMLFile() {
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "mapper" and
    this.getAbsolutePath().indexOf("src/main") > 0 
    and this.getADTD().toString().indexOf("mybatis.org") > 0
  }

  /**
   * Gets the type of the id with the given id.
   */
  string getResultMapType(string id) {
    exists(ResultMap resultMap |
      // Find resultMap id and type in the same file and ...
      resultMap.getFile() = this and
      // ... with the right id.
      id = resultMap.getId().getValue() and
      result = resultMap.getType().getValue()
    )
  }
}

/**
 * An XML element in a `MapperXMLFile`.
 */
class MapperXMLElement extends XMLElement {
  MapperXMLElement() { this.getFile() instanceof MapperXMLFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = allCharactersString().trim() }
}

/**
 * A `<mapper>` element in a `mapper.xml` file.
 */
class Mapper extends MapperXMLElement {
  Mapper() { this.getName() = "mapper" }

  /**
   * Gets the `namespace` attribute of this `<mapper>`.
   */
  XMLAttribute getnamespace() { result = getAttribute("namespace") }
}

/**
 * A `<resultMap>` element in a `mapper.xml` file.
 */
class ResultMap extends MapperXMLElement {
  ResultMap() { this.getName() = "resultMap" }

  /**
   * Gets the `id` attribute of this `<resultMap>`.
   */
  XMLAttribute getId() { result = getAttribute("id") }

  /**
   * Gets the `type` attribute of this `<resultMap>`.
   */
  XMLAttribute getType() { result = getAttribute("type") }
}

/**
 * A `<sql>` element in a `mapper.xml` file.
 */
class Sql extends MapperXMLElement {
  Sql() { this.getName() = "sql" }

  /**
   * Gets the `id` element of this `<sql>`.
   */
  XMLAttribute getId() { result = getAttribute("id") }

}

/**
 * A `<if>` element in a `mapper.xml` file.
 */
class IfStatement extends MapperXMLElement {
  IfStatement() { this.getName() = "if" }

  /**
   * Gets the `test` element of this `<if>`.
   */
  XMLAttribute getTest() { result = getAttribute("test") }

}

/**
 * A `select/update/insert/delete` element in a `mapper.xml` file.
 */
class SqlStatement extends MapperXMLElement {
  SqlStatement() { this.getName() = "select" 
    or this.getName() = "update"
    or this.getName() = "insert"
    or this.getName() = "delete"
  }

  /**
   * Gets the `id` attribute of this sql statement.
   */
  XMLAttribute getId() { result = getAttribute("id") }

  /**
   * Gets the `parameterType` attribute of this sql statement.
   */
  XMLAttribute getParameterType() { result = getAttribute("parameterType") }

  /**
   * Gets the `resultType` attribute of this sql statement.
   */
  XMLAttribute getResultType() { result = getAttribute("resultType") }

  /**
   * Gets the `resultMap` attribute of this sql statement.
   */
  XMLAttribute getResultMap() { result = getAttribute("resultMap") }

  override string getValue() { result = allCharactersString() }
}