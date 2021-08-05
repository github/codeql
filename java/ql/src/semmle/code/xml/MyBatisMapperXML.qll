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
  string getValue() { result = allCharactersString().trim() }

  /**
   * Gets the reference type bound to MyBatis Mapper XML File.
   */
  RefType getNamespaceRefType() { result.getQualifiedName() = getAttribute("namespace").getValue() }
}

/**
 * An MyBatis Mapper sql operation element.
 */
abstract class MyBatisMapperSqlOperation extends MyBatisMapperXMLElement {
  abstract string getId();

  /**
   * Gets the `<include>` element in a `MyBatisMapperSqlOperation`.
   */
  MyBatisMapperInclude getInclude() { result = getAChild*() }


  Method getMapperMethod() {
    result.getName() = this.getId() and
    result.getDeclaringType() = this.getParent().(MyBatisMapperXMLElement).getNamespaceRefType()
  }
}

/**
 * A `<insert>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperInsert extends MyBatisMapperSqlOperation {
  MyBatisMapperInsert() { getName() = "insert" }

  /**
   * Gets the value of the `id` attribute of this `<insert>`.
   */
  override string getId() { result = getAttribute("id").getValue() }
}

/**
 * A `<update>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperUpdate extends MyBatisMapperSqlOperation {
  MyBatisMapperUpdate() { getName() = "update" }

  /**
   * Gets the value of the `id` attribute of this `<update>`.
   */
  override string getId() { result = getAttribute("id").getValue() }
}

/**
 * A `<delete>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperDelete extends MyBatisMapperSqlOperation {
  MyBatisMapperDelete() { getName() = "delete" }

  /**
   * Gets the value of the `id` attribute of this `<delete>`.
   */
  override string getId() { result = getAttribute("id").getValue() }
}

/**
 * A `<select>` element in a `MyBatisMapperSqlOperation`.
 */
class MyBatisMapperSelect extends MyBatisMapperSqlOperation {
  MyBatisMapperSelect() { getName() = "select" }

  /**
   * Gets the value of the `id` attribute of this `<select>`.
   */
  override string getId() { result = getAttribute("id").getValue() }
}

/**
 * A `<select>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperSql extends MyBatisMapperXMLElement {
  MyBatisMapperSql() { getName() = "sql" }

  /**
   * Gets the value of the `id` attribute of this `<sql>`.
   */
  string getId() { result = getAttribute("id").getValue() }
}

/**
 * A `<include>` element in a `MyBatisMapperXMLElement`.
 */
class MyBatisMapperInclude extends MyBatisMapperXMLElement {
  MyBatisMapperInclude() { getName() = "include" }

  /**
   * Gets the value of the `refid` attribute of this `<include>`.
   */
  string getRefid() { result = getAttribute("refid").getValue() }
}
