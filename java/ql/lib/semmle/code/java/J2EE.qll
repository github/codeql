/**
 * Provides classes and predicates for working with J2EE bean types.
 */

import Type

/** An entity bean. */
class EntityBean extends Class {
  EntityBean() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "EntityBean") | this.hasSupertype+(i))
  }
}

/** An enterprise bean. */
class EnterpriseBean extends RefType {
  EnterpriseBean() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "EnterpriseBean") | this.hasSupertype+(i))
  }
}

/** A local EJB home interface. */
class LocalEjbHomeInterface extends Interface {
  LocalEjbHomeInterface() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "EJBLocalHome") | this.hasSupertype+(i))
  }
}

/** DEPRECATED: Alias for LocalEjbHomeInterface */
deprecated class LocalEJBHomeInterface = LocalEjbHomeInterface;

/** A remote EJB home interface. */
class RemoteEjbHomeInterface extends Interface {
  RemoteEjbHomeInterface() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "EJBHome") | this.hasSupertype+(i))
  }
}

/** DEPRECATED: Alias for RemoteEjbHomeInterface */
deprecated class RemoteEJBHomeInterface = RemoteEjbHomeInterface;

/** A local EJB interface. */
class LocalEjbInterface extends Interface {
  LocalEjbInterface() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "EJBLocalObject") | this.hasSupertype+(i))
  }
}

/** DEPRECATED: Alias for LocalEjbInterface */
deprecated class LocalEJBInterface = LocalEjbInterface;

/** A remote EJB interface. */
class RemoteEjbInterface extends Interface {
  RemoteEjbInterface() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "EJBObject") | this.hasSupertype+(i))
  }
}

/** DEPRECATED: Alias for RemoteEjbInterface */
deprecated class RemoteEJBInterface = RemoteEjbInterface;

/** A message bean. */
class MessageBean extends Class {
  MessageBean() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "MessageDrivenBean") |
      this.hasSupertype+(i)
    )
  }
}

/** A session bean. */
class SessionBean extends Class {
  SessionBean() {
    exists(Interface i | i.hasQualifiedName("javax.ejb", "SessionBean") | this.hasSupertype+(i))
  }
}
