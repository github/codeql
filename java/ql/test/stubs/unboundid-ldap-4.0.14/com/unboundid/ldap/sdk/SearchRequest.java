package com.unboundid.ldap.sdk;

public class SearchRequest implements ReadOnlySearchRequest {
  public SearchRequest(String baseDN, SearchScope scope, String filter, String... attributes) throws LDAPException { }

  public SearchRequest(SearchResultListener searchResultListener, String baseDN, SearchScope scope, DereferencePolicy derefPolicy,
             int sizeLimit, int timeLimit, boolean typesOnly, Filter filter, String... attributes) { }

  public SearchRequest(SearchResultListener searchResultListener, String baseDN, SearchScope scope, DereferencePolicy derefPolicy,
             int sizeLimit, int timeLimit, boolean typesOnly, String filter, String... attributes) throws LDAPException { }

  public SearchRequest duplicate() { return null; }

  public void setBaseDN(String baseDN) { }

  public void setFilter(String filter) throws LDAPException { }
}
