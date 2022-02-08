// Generated automatically from org.springframework.ldap.core.LdapTemplate for testing purposes

package org.springframework.ldap.core;

import java.util.List;
import javax.naming.Name;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.ldap.core.AttributesMapper;
import org.springframework.ldap.core.AuthenticatedLdapEntryContextCallback;
import org.springframework.ldap.core.AuthenticatedLdapEntryContextMapper;
import org.springframework.ldap.core.AuthenticationErrorCallback;
import org.springframework.ldap.core.ContextExecutor;
import org.springframework.ldap.core.ContextMapper;
import org.springframework.ldap.core.ContextSource;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.ldap.core.DirContextProcessor;
import org.springframework.ldap.core.LdapOperations;
import org.springframework.ldap.core.NameClassPairCallbackHandler;
import org.springframework.ldap.core.NameClassPairMapper;
import org.springframework.ldap.core.SearchExecutor;
import org.springframework.ldap.filter.Filter;
import org.springframework.ldap.odm.core.ObjectDirectoryMapper;
import org.springframework.ldap.query.LdapQuery;

public class LdapTemplate implements InitializingBean, LdapOperations
{
    protected void deleteRecursively(DirContext p0, Name p1){}
    public <T> List<T> find(LdapQuery p0, Class<T> p1){ return null; }
    public <T> List<T> find(Name p0, Filter p1, SearchControls p2, Class<T> p3){ return null; }
    public <T> List<T> findAll(Class<T> p0){ return null; }
    public <T> List<T> findAll(Name p0, SearchControls p1, Class<T> p2){ return null; }
    public <T> List<T> list(Name p0, NameClassPairMapper<T> p1){ return null; }
    public <T> List<T> list(String p0, NameClassPairMapper<T> p1){ return null; }
    public <T> List<T> listBindings(Name p0, ContextMapper<T> p1){ return null; }
    public <T> List<T> listBindings(Name p0, NameClassPairMapper<T> p1){ return null; }
    public <T> List<T> listBindings(String p0, ContextMapper<T> p1){ return null; }
    public <T> List<T> listBindings(String p0, NameClassPairMapper<T> p1){ return null; }
    public <T> List<T> search(LdapQuery p0, AttributesMapper<T> p1){ return null; }
    public <T> List<T> search(LdapQuery p0, ContextMapper<T> p1){ return null; }
    public <T> List<T> search(Name p0, String p1, AttributesMapper<T> p2){ return null; }
    public <T> List<T> search(Name p0, String p1, ContextMapper<T> p2){ return null; }
    public <T> List<T> search(Name p0, String p1, SearchControls p2, AttributesMapper<T> p3){ return null; }
    public <T> List<T> search(Name p0, String p1, SearchControls p2, AttributesMapper<T> p3, DirContextProcessor p4){ return null; }
    public <T> List<T> search(Name p0, String p1, SearchControls p2, ContextMapper<T> p3){ return null; }
    public <T> List<T> search(Name p0, String p1, SearchControls p2, ContextMapper<T> p3, DirContextProcessor p4){ return null; }
    public <T> List<T> search(Name p0, String p1, int p2, AttributesMapper<T> p3){ return null; }
    public <T> List<T> search(Name p0, String p1, int p2, ContextMapper<T> p3){ return null; }
    public <T> List<T> search(Name p0, String p1, int p2, String[] p3, AttributesMapper<T> p4){ return null; }
    public <T> List<T> search(Name p0, String p1, int p2, String[] p3, ContextMapper<T> p4){ return null; }
    public <T> List<T> search(String p0, String p1, AttributesMapper<T> p2){ return null; }
    public <T> List<T> search(String p0, String p1, ContextMapper<T> p2){ return null; }
    public <T> List<T> search(String p0, String p1, SearchControls p2, AttributesMapper<T> p3){ return null; }
    public <T> List<T> search(String p0, String p1, SearchControls p2, AttributesMapper<T> p3, DirContextProcessor p4){ return null; }
    public <T> List<T> search(String p0, String p1, SearchControls p2, ContextMapper<T> p3){ return null; }
    public <T> List<T> search(String p0, String p1, SearchControls p2, ContextMapper<T> p3, DirContextProcessor p4){ return null; }
    public <T> List<T> search(String p0, String p1, int p2, AttributesMapper<T> p3){ return null; }
    public <T> List<T> search(String p0, String p1, int p2, ContextMapper<T> p3){ return null; }
    public <T> List<T> search(String p0, String p1, int p2, String[] p3, AttributesMapper<T> p4){ return null; }
    public <T> List<T> search(String p0, String p1, int p2, String[] p3, ContextMapper<T> p4){ return null; }
    public <T> T authenticate(LdapQuery p0, String p1, AuthenticatedLdapEntryContextMapper<T> p2){ return null; }
    public <T> T executeReadOnly(ContextExecutor<T> p0){ return null; }
    public <T> T executeReadWrite(ContextExecutor<T> p0){ return null; }
    public <T> T findByDn(Name p0, Class<T> p1){ return null; }
    public <T> T findOne(LdapQuery p0, Class<T> p1){ return null; }
    public <T> T lookup(Name p0, AttributesMapper<T> p1){ return null; }
    public <T> T lookup(Name p0, ContextMapper<T> p1){ return null; }
    public <T> T lookup(Name p0, String[] p1, AttributesMapper<T> p2){ return null; }
    public <T> T lookup(Name p0, String[] p1, ContextMapper<T> p2){ return null; }
    public <T> T lookup(String p0, AttributesMapper<T> p1){ return null; }
    public <T> T lookup(String p0, ContextMapper<T> p1){ return null; }
    public <T> T lookup(String p0, String[] p1, AttributesMapper<T> p2){ return null; }
    public <T> T lookup(String p0, String[] p1, ContextMapper<T> p2){ return null; }
    public <T> T searchForObject(LdapQuery p0, ContextMapper<T> p1){ return null; }
    public <T> T searchForObject(Name p0, String p1, ContextMapper<T> p2){ return null; }
    public <T> T searchForObject(Name p0, String p1, SearchControls p2, ContextMapper<T> p3){ return null; }
    public <T> T searchForObject(String p0, String p1, ContextMapper<T> p2){ return null; }
    public <T> T searchForObject(String p0, String p1, SearchControls p2, ContextMapper<T> p3){ return null; }
    public ContextSource getContextSource(){ return null; }
    public DirContextOperations lookupContext(Name p0){ return null; }
    public DirContextOperations lookupContext(String p0){ return null; }
    public DirContextOperations searchForContext(LdapQuery p0){ return null; }
    public LdapTemplate(){}
    public LdapTemplate(ContextSource p0){}
    public List<String> list(Name p0){ return null; }
    public List<String> list(String p0){ return null; }
    public List<String> listBindings(Name p0){ return null; }
    public List<String> listBindings(String p0){ return null; }
    public Object lookup(Name p0){ return null; }
    public Object lookup(String p0){ return null; }
    public ObjectDirectoryMapper getObjectDirectoryMapper(){ return null; }
    public boolean authenticate(Name p0, String p1, String p2){ return false; }
    public boolean authenticate(Name p0, String p1, String p2, AuthenticatedLdapEntryContextCallback p3){ return false; }
    public boolean authenticate(Name p0, String p1, String p2, AuthenticatedLdapEntryContextCallback p3, AuthenticationErrorCallback p4){ return false; }
    public boolean authenticate(Name p0, String p1, String p2, AuthenticationErrorCallback p3){ return false; }
    public boolean authenticate(String p0, String p1, String p2){ return false; }
    public boolean authenticate(String p0, String p1, String p2, AuthenticatedLdapEntryContextCallback p3){ return false; }
    public boolean authenticate(String p0, String p1, String p2, AuthenticatedLdapEntryContextCallback p3, AuthenticationErrorCallback p4){ return false; }
    public boolean authenticate(String p0, String p1, String p2, AuthenticationErrorCallback p3){ return false; }
    public void afterPropertiesSet(){}
    public void authenticate(LdapQuery p0, String p1){}
    public void bind(DirContextOperations p0){}
    public void bind(Name p0, Object p1, Attributes p2){}
    public void bind(String p0, Object p1, Attributes p2){}
    public void create(Object p0){}
    public void delete(Object p0){}
    public void list(Name p0, NameClassPairCallbackHandler p1){}
    public void list(String p0, NameClassPairCallbackHandler p1){}
    public void listBindings(Name p0, NameClassPairCallbackHandler p1){}
    public void listBindings(String p0, NameClassPairCallbackHandler p1){}
    public void modifyAttributes(DirContextOperations p0){}
    public void modifyAttributes(Name p0, ModificationItem[] p1){}
    public void modifyAttributes(String p0, ModificationItem[] p1){}
    public void rebind(DirContextOperations p0){}
    public void rebind(Name p0, Object p1, Attributes p2){}
    public void rebind(String p0, Object p1, Attributes p2){}
    public void rename(Name p0, Name p1){}
    public void rename(String p0, String p1){}
    public void search(LdapQuery p0, NameClassPairCallbackHandler p1){}
    public void search(Name p0, String p1, NameClassPairCallbackHandler p2){}
    public void search(Name p0, String p1, SearchControls p2, NameClassPairCallbackHandler p3){}
    public void search(Name p0, String p1, SearchControls p2, NameClassPairCallbackHandler p3, DirContextProcessor p4){}
    public void search(Name p0, String p1, int p2, boolean p3, NameClassPairCallbackHandler p4){}
    public void search(SearchExecutor p0, NameClassPairCallbackHandler p1){}
    public void search(SearchExecutor p0, NameClassPairCallbackHandler p1, DirContextProcessor p2){}
    public void search(String p0, String p1, NameClassPairCallbackHandler p2){}
    public void search(String p0, String p1, SearchControls p2, NameClassPairCallbackHandler p3){}
    public void search(String p0, String p1, SearchControls p2, NameClassPairCallbackHandler p3, DirContextProcessor p4){}
    public void search(String p0, String p1, int p2, boolean p3, NameClassPairCallbackHandler p4){}
    public void setContextSource(ContextSource p0){}
    public void setDefaultCountLimit(int p0){}
    public void setDefaultSearchScope(int p0){}
    public void setDefaultTimeLimit(int p0){}
    public void setIgnoreNameNotFoundException(boolean p0){}
    public void setIgnorePartialResultException(boolean p0){}
    public void setIgnoreSizeLimitExceededException(boolean p0){}
    public void setObjectDirectoryMapper(ObjectDirectoryMapper p0){}
    public void unbind(Name p0){}
    public void unbind(Name p0, boolean p1){}
    public void unbind(String p0){}
    public void unbind(String p0, boolean p1){}
    public void update(Object p0){}
}
