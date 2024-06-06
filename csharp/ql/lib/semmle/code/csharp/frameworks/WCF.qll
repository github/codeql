/** Provides definitions related to Windows Communication Foundation (WCF). */

import csharp

/** A `ServiceContract` attribute. */
class ServiceContractAttribute extends Attribute {
  ServiceContractAttribute() {
    this.getType().hasFullyQualifiedName("System.ServiceModel", "ServiceContractAttribute")
  }
}

/** An `OperationContract` attribute. */
class OperationContractAttribute extends Attribute {
  OperationContractAttribute() {
    this.getType().hasFullyQualifiedName("System.ServiceModel", "OperationContractAttribute")
  }
}

/** A `DataContract` attribute. */
class DataContractAttribute extends Attribute {
  DataContractAttribute() {
    this.getType().hasFullyQualifiedName("System.Runtime.Serialization", "DataContractAttribute")
  }
}

/** A `DataMember` attribute. */
class DataMemberAttribute extends Attribute {
  DataMemberAttribute() {
    this.getType().hasFullyQualifiedName("System.Runtime.Serialization", "DataMemberAttribute")
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
      this.getImplementee() = m
    )
  }
}

/**
 * Data flow for WCF data contracts.
 *
 * Flow is defined from a WCF data contract object to any of its data member
 * properties. This flow model only makes sense from a taint-tracking perspective
 * (a tainted data contract object implies tainted data members).
 */
private class DataContractMember extends TaintTracking::TaintedMember {
  DataContractMember() {
    this.getAnAttribute() instanceof DataMemberAttribute and
    this.getDeclaringType() instanceof DataContractClass
  }
}
