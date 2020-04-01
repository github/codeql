package com.unboundid.ldap.sdk;

public class LDAPConnection {
  public AsyncRequestID asyncSearch(ReadOnlySearchRequest searchRequest) throws LDAPException { return null; }
  public AsyncRequestID asyncSearch(SearchRequest searchRequest) throws LDAPException { return null; }

  public SearchResult search(ReadOnlySearchRequest searchRequest) throws LDAPSearchException { return null; }
  public SearchResult search(SearchRequest searchRequest) throws LDAPSearchException { return null; }

  public SearchResult search(SearchResultListener searchResultListener, String baseDN, SearchScope scope, DereferencePolicy derefPolicy,
                  int sizeLimit, int timeLimit, boolean typesOnly, Filter filter, String... attributes) throws LDAPSearchException { return null; }

  public SearchResult search(SearchResultListener searchResultListener, String baseDN, SearchScope scope, DereferencePolicy derefPolicy,
                  int sizeLimit, int timeLimit, boolean typesOnly, String filter, String... attributes) throws LDAPSearchException { return null; }

  public SearchResult search(String baseDN, SearchScope scope, DereferencePolicy derefPolicy, int sizeLimit, int timeLimit,
                  boolean typesOnly, String filter, String... attributes) throws LDAPSearchException { return null; }

  public SearchResultEntry searchForEntry(String baseDN, SearchScope scope, DereferencePolicy derefPolicy, int timeLimit,
                   boolean typesOnly, String filter, String... attributes) throws LDAPSearchException { return null; }
}
