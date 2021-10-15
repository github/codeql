package org.apache.directory.api.ldap.model.message;

import org.apache.directory.api.ldap.model.exception.LdapException;
import org.apache.directory.api.ldap.model.name.Dn;
import org.apache.directory.api.ldap.model.filter.ExprNode;

public class SearchRequestImpl implements SearchRequest {
  public Dn getBase() { return null; }
  public SearchRequest setBase(Dn baseDn) { return null; }
  public SearchRequest setFilter(ExprNode filter) { return null; }
  public SearchRequest setFilter(String filter) throws LdapException { return null; }
}
