// Generated automatically from org.springframework.ldap.query.LdapQuery for testing purposes

package org.springframework.ldap.query;

import javax.naming.Name;
import org.springframework.ldap.filter.Filter;
import org.springframework.ldap.query.SearchScope;

public interface LdapQuery
{
    Filter filter();
    Integer countLimit();
    Integer timeLimit();
    Name base();
    SearchScope searchScope();
    String[] attributes();
}
