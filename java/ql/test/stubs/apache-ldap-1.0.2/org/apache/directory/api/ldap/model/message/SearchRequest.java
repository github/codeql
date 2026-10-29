package org.apache.directory.api.ldap.model.message;

import org.apache.directory.api.ldap.model.exception.LdapException;
import org.apache.directory.api.ldap.model.name.Dn;
import org.apache.directory.api.ldap.model.filter.ExprNode;

public interface SearchRequest {
  Dn getBase();
  SearchRequest setBase(Dn baseDn);
  SearchRequest setFilter(ExprNode filter);
  SearchRequest setFilter(String filter) throws LdapException;
}
