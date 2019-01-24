/** Provides definitions related to Windows Communication Foundation (WCF). */

import csharp

/** A `ServiceContract` attribute. */
class ServiceContractAttribute extends Attribute {
  ServiceContractAttribute() {
    this.getType().hasQualifiedName("System.ServiceModel", "ServiceContractAttribute")
  }
}

/** An `OperationContract` attribute. */
class OperationContractAttribute extends Attribute {
  OperationContractAttribute() {
    this.getType().hasQualifiedName("System.ServiceModel", "OperationContractAttribute")
  }
}

/** A `DataContract` attribute. */
class DataContractAttribute extends Attribute {
  DataContractAttribute() {
    this.getType().hasQualifiedName("System.Runtime.Serialization", "DataContractAttribute")
  }
}

/** A `DataMember` attribute. */
class DataMemberAttribute extends Attribute {
  DataMemberAttribute() {
    this.getType().hasQualifiedName("System.Runtime.Serialization", "DataMemberAttribute")
  }
}

/** A data contract class. */
class DataContractClass extends Class {
  DataContractClass() { this.getAnAttribute() instanceof DataContractAttribute }

  /** A data member of the data contract. */
  Declaration getADataMember() {
    result = this.getAMember() and
    result.(Attributable).getAnAttribute() instanceof DataMemberAttribute
  }
}

/** An operation method. */
class OperationMethod extends Method {
  OperationMethod() {
    exists(Interface i, Method m |
      i = this.getDeclaringType().getABaseInterface+() and
      i.getAnAttribute() instanceof ServiceContractAttribute and
      m.getDeclaringType() = i and
      m.getAnAttribute() instanceof OperationContractAttribute and
      getImplementee() = m
    )
  }
}
