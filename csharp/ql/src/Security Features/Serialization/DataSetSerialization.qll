import csharp

/**
 * Abstract class thats depnds or inherits from DataSet and DataTable types.
 **/
abstract class DataSetOrTableRelatedClass extends Class {
}

/**
 * Gets the DataSet and DataTable types, or types derived from them.
 **/
class DataSetOrTable extends DataSetOrTableRelatedClass {
  DataSetOrTable() {
    this.getABaseType*().getQualifiedName().matches("System.Data.DataTable") or
    this.getABaseType*().getQualifiedName().matches("System.Data.DataSet") or
    this.getQualifiedName().matches("System.Data.DataTable") or
    this.getQualifiedName().matches("System.Data.DataSet")
  }
}

/**
 * Gets a class that include a property or generic of type DataSet and DataTable
 */
class ClassWithDataSetOrTableMember extends DataSetOrTableRelatedClass {
  ClassWithDataSetOrTableMember() {
    exists( Property p |
      p = this.getAProperty() |
      p.getType() instanceof DataSetOrTable
    ) or exists ( AssignableMember am |
      am = this.getAField() or
      am = this.getAMember() |
      am.getType() instanceof DataSetOrTable
    ) or exists( Property p |
      p = this.getAProperty() |
      p.getType() instanceof DataSetOrTable or
      p.getType().(ConstructedGeneric).getATypeArgument() instanceof DataSetOrTable 
    )
  }
}

/**
 * Serializable types
 */
class SerializableClass extends Class {
  SerializableClass() {
    (
      this.getABaseType*().getQualifiedName().matches("System.Xml.Serialization.XmlSerializer") or
      this.getABaseInterface*().getQualifiedName().matches("System.Runtime.Serialization.ISerializable") or
      this.getABaseType*().getQualifiedName().matches("System.Runtime.Serialization.XmlObjectSerializer") or
      this.getABaseInterface*().getQualifiedName().matches("System.Runtime.Serialization.ISerializationSurrogateProvider") or
      this.getABaseType*().getQualifiedName().matches("System.Runtime.Serialization.XmlSerializableServices") or
      this.getABaseInterface*().getQualifiedName().matches("System.Xml.Serialization.IXmlSerializable")
    ) or exists( Attribute a |
      a = this.getAnAttribute() |
      a.getType().getQualifiedName().toString() = "System.SerializableAttribute"
    )
  }
}

predicate isClassUnsafeXmlSerializerImplementation( SerializableClass c, Member m) {
  exists( Property p |
    m = p |
    p = c.getAProperty() and
    p.getType() instanceof DataSetOrTableRelatedClass
  ) or exists ( AssignableMember am |
    am = m |
    ( am = c.getAField() or am = c.getAMember() ) and
    am.getType() instanceof DataSetOrTableRelatedClass
  )
}

/**
 * It is unsafe to serilize DataSet and DataTable related types
 */
class UnsafeXmlSerializerImplementation extends SerializableClass {
  UnsafeXmlSerializerImplementation() {
    isClassUnsafeXmlSerializerImplementation( this, _ )
  }
}

/**
 * Method that may be unsafe when used to serialize DataSet and DataTable related types
 */
class UnsafeXmlReadMethod extends Method {
  UnsafeXmlReadMethod() {
    this.getQualifiedName().toString() = "System.Data.DataTable.ReadXml" or
    this.getQualifiedName().toString() = "System.Data.DataTable.ReadXmlSchema" or
    this.getQualifiedName().toString() = "System.Data.DataSet.ReadXml" or
    this.getQualifiedName().toString() = "System.Data.DataSet.ReadXmlSchema" or
    ( 
      this.getName().matches("ReadXml%") and
      exists( Class c |
        c.getAMethod() = this |
        c.getABaseType*() instanceof DataSetOrTableRelatedClass or
        c.getABaseType*() instanceof DataSetOrTableRelatedClass
      )
    )
  }
}

/**
 * MethodCal that may be unsafe when used to serialize DataSet and DataTable related types
 */
class UnsafeXmlReadMethodCall extends MethodCall {
  UnsafeXmlReadMethodCall() {
    exists( UnsafeXmlReadMethod uxrm |
      uxrm.getACall() = this 
    )
  }
}
