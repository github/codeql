/**
 * Provides classes and predicates for working with the UnboundID API.
 */

import java

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
class TypeUnboundIdLdapConnection extends Class {
  TypeUnboundIdLdapConnection() {
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
class MethodUnboundIdFilterCreateAndFilter extends Method {
  MethodUnboundIdFilterCreateAndFilter() {
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
class MethodUnboundIdFilterCreateNotFilter extends Method {
  MethodUnboundIdFilterCreateNotFilter() {
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
class MethodUnboundIdLdapConnectionSearch extends Method {
  MethodUnboundIdLdapConnectionSearch() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapConnection and
    this.hasName("search")
  }
}

/** A method with the name `asyncSearch` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLdapConnectionAsyncSearch extends Method {
  MethodUnboundIdLdapConnectionAsyncSearch() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapConnection and
    this.hasName("asyncSearch")
  }
}

/** A method with the name `searchForEntry` declared in `com.unboundid.ldap.sdk.LDAPConnection`. */
class MethodUnboundIdLdapConnectionSearchForEntry extends Method {
  MethodUnboundIdLdapConnectionSearchForEntry() {
    this.getDeclaringType() instanceof TypeUnboundIdLdapConnection and
    this.hasName("searchForEntry")
  }
}
