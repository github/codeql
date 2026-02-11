/**
 * Provides classes for `DataSet` or `DataTable` deserialization queries.
 *
 * Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details.
 */
deprecated module;

import csharp

/**
 * Abstract class that depends or inherits from `DataSet` or `DataTable` types.
 */
abstract class DataSetOrTableRelatedClass extends Class { }

/**
 * `DataSet`, `DataTable` types, or any types derived from them.
 */
class DataSetOrTable extends DataSetOrTableRelatedClass {
  DataSetOrTable() {
    this.getABaseType*().hasFullyQualifiedName("System.Data", "DataTable") or
    this.getABaseType*().hasFullyQualifiedName("System.Data", "DataSet")
  }
}

/**
 * A Class that include a property or generic collection of type `DataSet` and `DataTable`
 */
class ClassWithDataSetOrTableMember extends DataSetOrTableRelatedClass {
  ClassWithDataSetOrTableMember() {
    this.getAMember().(AssignableMember).getType() instanceof DataSetOrTable
    or
    exists(Property p | p = this.getAProperty() |
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
      this.getABaseType*()
          .hasFullyQualifiedName("System.Xml.Serialization", ["XmlSerializer", "IXmlSerializable"]) or
      this.getABaseType*()
          .hasFullyQualifiedName("System.Runtime.Serialization",
            [
              "ISerializable", "XmlObjectSerializer", "ISerializationSurrogateProvider",
              "XmlSerializableServices"
            ])
    )
    or
    exists(Attribute a | a = this.getAnAttribute() |
      a.getType().hasFullyQualifiedName("System", "SerializableAttribute")
    )
  }
}

/**
 * Holds if the serializable class `c` has a property or field `m` that is of `DataSet` or `DataTable` related type
 */
predicate isClassUnsafeXmlSerializerImplementation(SerializableClass c, AssignableMember am) {
  am = c.getAMember() and
  am.getType() instanceof DataSetOrTableRelatedClass
}

/**
 * Serializable class that has a property or field that is of `DataSet` or `DataTable` related type
 */
class UnsafeXmlSerializerImplementation extends SerializableClass {
  UnsafeXmlSerializerImplementation() { isClassUnsafeXmlSerializerImplementation(this, _) }
}

/**
 * Method that may be unsafe when used to deserialize DataSet and DataTable related types
 */
class UnsafeXmlReadMethod extends Method {
  UnsafeXmlReadMethod() {
    this.hasFullyQualifiedName("System.Data", ["DataTable", "DataSet"], ["ReadXml", "ReadXmlSchema"])
    or
    this.getName().matches("ReadXml%") and
    exists(Class c | c.getAMethod() = this |
      c.getABaseType*() instanceof DataSetOrTableRelatedClass
    )
  }
}

/**
 * MethodCall that may be unsafe when used to deserialize DataSet and DataTable related types
 */
class UnsafeXmlReadMethodCall extends MethodCall {
  UnsafeXmlReadMethodCall() { exists(UnsafeXmlReadMethod uxrm | uxrm.getACall() = this) }
}
