/**
 * Provides classes and predicates for working with the Java JDBC API.
 */

import java
import semmle.code.java.Type
import semmle.code.java.Member

/*--- Types ---*/
/** The interface `javax.naming.directory.DirContext`. */
class TypeDirContext extends Interface {
  TypeDirContext() { this.hasQualifiedName("javax.naming.directory", "DirContext") }
}

/** The class `javax.naming.ldap.LdapName`. */
class TypeLdapName extends Class {
  TypeLdapName() { this.hasQualifiedName("javax.naming.ldap", "LdapName") }
}

/*--- Methods ---*/
/** A method with the name `addAll` declared in `javax.naming.ldap.LdapName`. */
class MethodLdapNameAddAll extends Method {
  MethodLdapNameAddAll() {
    getDeclaringType() instanceof TypeLdapName and
    hasName("addAll")
  }
}

/** A method with the name `clone` declared in `javax.naming.ldap.LdapName`. */
class MethodLdapNameClone extends Method {
  MethodLdapNameClone() {
    getDeclaringType() instanceof TypeLdapName and
    hasName("clone")
  }
}

/** A method with the name `getAll` declared in `javax.naming.ldap.LdapName`. */
class MethodLdapNameGetAll extends Method {
  MethodLdapNameGetAll() {
    getDeclaringType() instanceof TypeLdapName and
    hasName("getAll")
  }
}

/** A method with the name `getRdns` declared in `javax.naming.ldap.LdapName`. */
class MethodLdapNameGetRdns extends Method {
  MethodLdapNameGetRdns() {
    getDeclaringType() instanceof TypeLdapName and
    hasName("getRdns")
  }
}

/** A method with the name `toString` declared in `javax.naming.ldap.LdapName`. */
class MethodLdapNameToString extends Method {
  MethodLdapNameToString() {
    getDeclaringType() instanceof TypeLdapName and
    hasName("toString")
  }
}
