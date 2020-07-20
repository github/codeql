package org.springframework.ldap.core;

import java.util.*;

import javax.naming.Name;
import javax.naming.directory.SearchControls;

import org.springframework.ldap.filter.Filter;

import org.springframework.ldap.query.LdapQuery;

public class LdapTemplate {
  public void authenticate(LdapQuery query, String password) { }

  public boolean authenticate(Name base, String filter, String password) { return true; }

  public <T> List<T> find(Name base, Filter filter, SearchControls searchControls, final Class<T> clazz) { return null; }

  public <T> List<T> find(LdapQuery query, Class<T> clazz) { return null; }

  public <T> T findOne(LdapQuery query, Class<T> clazz) { return null; }

  public void search(String base, String filter, int searchScope, boolean returningObjFlag, NameClassPairCallbackHandler handler) { }

  public DirContextOperations searchForContext(LdapQuery query) { return null; }

  public <T> T searchForObject(Name base, String filter, ContextMapper<T> mapper) { return null; }
}
