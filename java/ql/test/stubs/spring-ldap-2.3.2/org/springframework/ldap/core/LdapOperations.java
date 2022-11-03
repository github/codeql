package org.springframework.ldap.core;

import java.util.*;

import javax.naming.Name;
import javax.naming.directory.SearchControls;

import org.springframework.ldap.filter.Filter;

import org.springframework.ldap.query.LdapQuery;

public interface LdapOperations {
    void authenticate(LdapQuery query, String password);

    boolean authenticate(Name base, String filter, String password);

    <T> List<T> find(Name base, Filter filter, SearchControls searchControls, final Class<T> clazz);

    <T> List<T> find(LdapQuery query, Class<T> clazz);

    <T> T findOne(LdapQuery query, Class<T> clazz);

    void search(String base, String filter, int searchScope, boolean returningObjFlag,
            NameClassPairCallbackHandler handler);

    void search(final String base, final String filter, final SearchControls controls,
            NameClassPairCallbackHandler handler);

    void search(final String base, final String filter, final SearchControls controls,
            NameClassPairCallbackHandler handler, DirContextProcessor processor);

    void search(String base, String filter, NameClassPairCallbackHandler handler);

    <T> List<T> search(String base, String filter, int searchScope, String[] attrs,
            AttributesMapper<T> mapper);

    <T> List<T> search(String base, String filter, int searchScope, AttributesMapper<T> mapper);

    <T> List<T> search(String base, String filter, AttributesMapper<T> mapper);

    <T> List<T> search(String base, String filter, int searchScope, String[] attrs,
            ContextMapper<T> mapper);

    <T> List<T> search(String base, String filter, int searchScope, ContextMapper<T> mapper);

    <T> List<T> search(String base, String filter, ContextMapper<T> mapper);

    <T> List<T> search(String base, String filter, SearchControls controls,
            ContextMapper<T> mapper);

    <T> List<T> search(String base, String filter, SearchControls controls,
            AttributesMapper<T> mapper);

    <T> List<T> search(String base, String filter, SearchControls controls,
            AttributesMapper<T> mapper, DirContextProcessor processor);

    <T> List<T> search(String base, String filter, SearchControls controls, ContextMapper<T> mapper,
            DirContextProcessor processor);

    DirContextOperations searchForContext(LdapQuery query);

    <T> T searchForObject(Name base, String filter, ContextMapper<T> mapper);

    <T> T searchForObject(String base, String filter, ContextMapper<T> mapper);

    <T> T searchForObject(String base, String filter, SearchControls searchControls,
            ContextMapper<T> mapper);

    Object lookup(final String dn);

    DirContextOperations lookupContext(String dn);

    <T> T findByDn(Name dn, final Class<T> clazz);

    void rename(final Name oldDn, final Name newDn);

    List<String> list(final Name base);

    List<String> listBindings(final Name base);

    void unbind(final String dn);

    void unbind(final String dn, boolean recursive);
}
