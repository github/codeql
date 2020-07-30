/**
 * Provides classes for `DataSet` or `DataTable` deserialization queries.
 *
 * Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details.
 */
 
 import csharp

/**
 * Abstract class that depends or inherits from `DataSet` or `DataTable` types.
 */
abstract class DataSetOrTableRelatedClass extends Class {
}

/**
 * `DataSet`, `DataTable` types, or any types derived from them.
 */
class DataSetOrTable extends DataSetOrTableRelatedClass {
  DataSetOrTable() {
    this.getABaseType*().getQualifiedName() = "System.Data.DataTable" or
    this.getABaseType*().getQualifiedName() = "System.Data.DataSet"
  }
}

/**
 * A Class that include a property or generic collection of type `DataSet` and `DataTable`
 */
class ClassWithDataSetOrTableMember extends DataSetOrTableRelatedClass {
  ClassWithDataSetOrTableMember() {
    exists( Property p |
      p = this.getAProperty() |
      p.getType() instanceof DataSetOrTable
    ) or this.getAMember().(AssignableMember).getType() instanceof DataSetOrTable
    or exists( Property p |
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
      this.getABaseType*().getQualifiedName() = "System.Xml.Serialization.XmlSerializer" or
      this.getABaseInterface*().getQualifiedName() = "System.Runtime.Serialization.ISerializable" or
      this.getABaseType*().getQualifiedName() = "System.Runtime.Serialization.XmlObjectSerializer" or
      this.getABaseInterface*().getQualifiedName() = "System.Runtime.Serialization.ISerializationSurrogateProvider" or
      this.getABaseType*().getQualifiedName() = "System.Runtime.Serialization.XmlSerializableServices" or
      this.getABaseInterface*().getQualifiedName() = "System.Xml.Serialization.IXmlSerializable"
    ) or exists( Attribute a |
      a = this.getAnAttribute() |
      a.getType().getQualifiedName().toString() = "System.SerializableAttribute"
    )
  }
}

/**
 * Holds if the serializable class `c` has a property or field `m` that is of `DataSet` or `DataTable` related type
 */
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
 * Serializable class that has a property or field that is of `DataSet` or `DataTable` related type
 */
class UnsafeXmlSerializerImplementation extends SerializableClass {
  UnsafeXmlSerializerImplementation() {
    isClassUnsafeXmlSerializerImplementation( this, _ )
  }
}

/**
 * Method that may be unsafe when used to deserialize DataSet and DataTable related types
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
        c.getABaseType*() instanceof DataSetOrTableRelatedClass 
      )
    )
  }
}

/**
 * MethodCall that may be unsafe when used to deserialize DataSet and DataTable related types
 */
class UnsafeXmlReadMethodCall extends MethodCall {
  UnsafeXmlReadMethodCall() {
    exists( UnsafeXmlReadMethod uxrm |
      uxrm.getACall() = this 
    )
  }
}
