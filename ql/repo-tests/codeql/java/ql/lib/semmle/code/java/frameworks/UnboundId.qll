/**
 * Provides classes and predicates for working with the UnboundID API.
 */

import java
import semmle.code.java.Type
import semmle.code.java.Member

/*--- Types ---*/
/** The interface `com.unboundid.ldap.sdk.ReadOnlySearchRequest`. */
class TypeUnboundIdReadOnlySearchRequest extends Interface {
  TypeUnboundIdReadOnlySearchRequest() {
    this.hasQualifiedName("com.unboundid.ldap.sdk", "ReadOnlySearchRequest")
  }
}

/** The class `com.unboundid.ldap.sdk.SearchRequest`. */
class TypeUnboundIdSearchRequest extends Class {
  TypeUnboundIdSearchRequest() { this.hasQualifiedName("com.unboundid.ldap.sdk", "SearchRequest") }
}

/** The class `com.unboundid.ldap.sdk.Filter`. */
class TypeUnboundIdLdapFilter extends Class {
  TypeUnboundIdLdapFilter() { this.hasQualifiedName("com.unboundid.ldap.sdk", "Filter") }
}

/** The class `com.unboundid.ldap.sdk.LDAPConnection`. */
class TypeUnboundIdLDAPConnection extends Class {
  TypeUnboundIdLDAPConnection() {
    this.hasQualifiedName("com.unboundid.ldap.sdk", "LDAPConnection")
  }
}

/*--- Methods ---*/
/** A method with the name `setBaseDN` declared in `com.unboundid.ldap.sdk.SearchRequest`. */
class MethodUnboundIdSearchRequestSetBaseDN extends Method {
  MethodUnboundIdSearchRequestSetBaseDN() {
    this.getDeclaringType() instanceof TypeUnboundIdSearchRequest and
    this.hasName("setBaseDN")
  }
}

/** A method with the name `setFilter` declared in `com.unboundid.ldap.sdk.SearchRequest`. */
class MethodUnboundIdSearchRequestSetFilter extends Method {
  MethodUnboundIdSearchRequestSetFilter() {
    this.getDeclaringType() instanceof TypeUnboundIdSearchRequest and
    this.hasName("setFilter")
  }
}

/** A method with the name `create` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreate extends Method {
  MethodUnboundIdFilterCreate() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    this.hasName("create")
  }
}

/** A method with the name `createANDFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreateANDFilter extends Method {
  MethodUnboundIdFilterCreateANDFilter() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    this.hasName("createANDFilter")
  }
}

/** A method with the name `createORFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreateORFilter extends Method {
  MethodUnboundIdFilterCreateORFilter() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    this.hasName("createORFilter")
  }
}

/** A method with the name `createNOTFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreateNOTFilter extends Method {
  MethodUnboundIdFilterCreateNOTFilter() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    this.hasName("createNOTFilter")
  }
}

/** A method with the name `simplifyFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterSimplifyFilter extends Method {
  MethodUnboundIdFilterSimplifyFilter() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    this.hasName("simplifyFilter")
  }
}

/** A method with the name `search` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLDAPConnectionSearch extends Method {
  MethodUnboundIdLDAPConnectionSearch() {
    this.getDeclaringType() instanceof TypeUnboundIdLDAPConnection and
    this.hasName("search")
  }
}

/** A method with the name `asyncSearch` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLDAPConnectionAsyncSearch extends Method {
  MethodUnboundIdLDAPConnectionAsyncSearch() {
    this.getDeclaringType() instanceof TypeUnboundIdLDAPConnection and
    this.hasName("asyncSearch")
  }
}

/** A method with the name `searchForEntry` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLDAPConnectionSearchForEntry extends Method {
  MethodUnboundIdLDAPConnectionSearchForEntry() {
    this.getDeclaringType() instanceof TypeUnboundIdLDAPConnection and
    this.hasName("searchForEntry")
  }
}
