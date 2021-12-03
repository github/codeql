package org.springframework.ldap.core;

import org.springframework.beans.factory.InitializingBean;

import java.util.*;

import javax.naming.Name;
import javax.naming.directory.SearchControls;

import org.springframework.ldap.filter.Filter;

import org.springframework.ldap.query.LdapQuery;

public class LdapTemplate implements LdapOperations, InitializingBean {
  public void authenticate(LdapQuery query, String password) { }

  public boolean authenticate(Name base, String filter, String password) { return true; }

  public <T> List<T> find(Name base, Filter filter, SearchControls searchControls, final Class<T> clazz) { return null; }

  public <T> List<T> find(LdapQuery query, Class<T> clazz) { return null; }

  public <T> T findOne(LdapQuery query, Class<T> clazz) { return null; }

  public void search(String base, String filter, int searchScope, boolean returningObjFlag, NameClassPairCallbackHandler handler) { }

  public void search(final String base, final String filter, final SearchControls controls, NameClassPairCallbackHandler handler) {}

  public void search(final String base, final String filter, final SearchControls controls, NameClassPairCallbackHandler handler, DirContextProcessor processor) {}

  public void search(String base, String filter, NameClassPairCallbackHandler handler) {}

  public <T> List<T> search(String base, String filter, int searchScope, String[] attrs, AttributesMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, int searchScope, AttributesMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, AttributesMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, int searchScope, String[] attrs, ContextMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, int searchScope, ContextMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, ContextMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, SearchControls controls, ContextMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, SearchControls controls, AttributesMapper<T> mapper) { return null; }

  public <T> List<T> search(String base, String filter, SearchControls controls, AttributesMapper<T> mapper, DirContextProcessor processor) { return null; }

  public <T> List<T> search(String base, String filter, SearchControls controls, ContextMapper<T> mapper, DirContextProcessor processor) { return null; }

  public DirContextOperations searchForContext(LdapQuery query) { return null; }

  public <T> T searchForObject(Name base, String filter, ContextMapper<T> mapper) { return null; }

  public <T> T searchForObject(String base, String filter, ContextMapper<T> mapper) { return null; }

  public <T> T searchForObject(String base, String filter, SearchControls searchControls, ContextMapper<T> mapper) { return null; }

  public Object lookup(final String dn) { return new Object(); }

  public DirContextOperations lookupContext(String dn) { return null; }

  public <T> T findByDn(Name dn, final Class<T> clazz) { return null; }

  public void rename(final Name oldDn, final Name newDn) {}

  public List<String> list(final Name base) { return null; }

  public List<String> listBindings(final Name base) { return null; }

  public void unbind(final String dn) {}

  public void unbind(final String dn, boolean recursive) {}
}
