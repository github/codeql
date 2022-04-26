/**
 * Provides classes and predicates for working with the Apache LDAP API.
 */

import java
import semmle.code.java.Type
import semmle.code.java.Member

/*--- Types ---*/
/** The interface `org.apache.directory.ldap.client.api.LdapConnection`. */
class TypeApacheLdapConnection extends Interface {
  TypeApacheLdapConnection() {
    this.hasQualifiedName("org.apache.directory.ldap.client.api", "LdapConnection")
  }
}

/** The interface `org.apache.directory.api.ldap.model.message.SearchRequest`. */
class TypeApacheSearchRequest extends Interface {
  TypeApacheSearchRequest() {
    this.hasQualifiedName("org.apache.directory.api.ldap.model.message", "SearchRequest")
  }
}

/** The class `org.apache.directory.api.ldap.model.name.Dn`. */
class TypeApacheDn extends Class {
  TypeApacheDn() { this.hasQualifiedName("org.apache.directory.api.ldap.model.name", "Dn") }
}
