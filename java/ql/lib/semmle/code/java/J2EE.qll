/**
 * Provides classes and predicates for working with J2EE bean types.
 */
overlay[local?]
module;

import Type

/** Gets "java" or "jakarta". */
string javaxOrJakarta() { result = ["javax", "jakarta"] }

/** An entity bean. */
class EntityBean extends Class {
  EntityBean() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "EntityBean") |
      this.hasSupertype+(i)
    )
  }
}

/** An enterprise bean. */
class EnterpriseBean extends RefType {
  EnterpriseBean() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "EnterpriseBean") |
      this.hasSupertype+(i)
    )
  }
}

/** A local EJB home interface. */
class LocalEjbHomeInterface extends Interface {
  LocalEjbHomeInterface() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "EJBLocalHome") |
      this.hasSupertype+(i)
    )
  }
}

/** A remote EJB home interface. */
class RemoteEjbHomeInterface extends Interface {
  RemoteEjbHomeInterface() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "EJBHome") |
      this.hasSupertype+(i)
    )
  }
}

/** A local EJB interface. */
class LocalEjbInterface extends Interface {
  LocalEjbInterface() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "EJBLocalObject") |
      this.hasSupertype+(i)
    )
  }
}

/** A remote EJB interface. */
class RemoteEjbInterface extends Interface {
  RemoteEjbInterface() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "EJBObject") |
      this.hasSupertype+(i)
    )
  }
}

/** A message bean. */
class MessageBean extends Class {
  MessageBean() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "MessageDrivenBean") |
      this.hasSupertype+(i)
    )
  }
}

/** A session bean. */
class SessionBean extends Class {
  SessionBean() {
    exists(Interface i | i.hasQualifiedName(javaxOrJakarta() + ".ejb", "SessionBean") |
      this.hasSupertype+(i)
    )
  }
}
