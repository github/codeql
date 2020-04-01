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
    getDeclaringType() instanceof TypeUnboundIdSearchRequest and
    hasName("setBaseDN")
  }
}

/** A method with the name `setFilter` declared in `com.unboundid.ldap.sdk.SearchRequest`. */
class MethodUnboundIdSearchRequestSetFilter extends Method {
  MethodUnboundIdSearchRequestSetFilter() {
    getDeclaringType() instanceof TypeUnboundIdSearchRequest and
    hasName("setFilter")
  }
}

/** A method with the name `create` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreate extends Method {
  MethodUnboundIdFilterCreate() {
    getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    hasName("create")
  }
}

/** A method with the name `createANDFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreateANDFilter extends Method {
  MethodUnboundIdFilterCreateANDFilter() {
    getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    hasName("createANDFilter")
  }
}

/** A method with the name `createORFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreateORFilter extends Method {
  MethodUnboundIdFilterCreateORFilter() {
    getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    hasName("createORFilter")
  }
}

/** A method with the name `createNOTFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterCreateNOTFilter extends Method {
  MethodUnboundIdFilterCreateNOTFilter() {
    getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    hasName("createNOTFilter")
  }
}

/** A method with the name `simplifyFilter` declared in `com.unboundid.ldap.sdk.Filter`. */
class MethodUnboundIdFilterSimplifyFilter extends Method {
  MethodUnboundIdFilterSimplifyFilter() {
    getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    hasName("simplifyFilter")
  }
}

/** A method with the name `search` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLDAPConnectionSearch extends Method {
  MethodUnboundIdLDAPConnectionSearch() {
    getDeclaringType() instanceof TypeUnboundIdLDAPConnection and
    hasName("search")
  }
}

/** A method with the name `asyncSearch` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLDAPConnectionAsyncSearch extends Method {
  MethodUnboundIdLDAPConnectionAsyncSearch() {
    getDeclaringType() instanceof TypeUnboundIdLDAPConnection and
    hasName("asyncSearch")
  }
}

/** A method with the name `searchForEntry` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLDAPConnectionSearchForEntry extends Method {
  MethodUnboundIdLDAPConnectionSearchForEntry() {
    getDeclaringType() instanceof TypeUnboundIdLDAPConnection and
    hasName("searchForEntry")
  }
}
