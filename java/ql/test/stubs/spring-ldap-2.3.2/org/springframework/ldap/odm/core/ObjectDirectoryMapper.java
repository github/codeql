// Generated automatically from org.springframework.ldap.odm.core.ObjectDirectoryMapper for testing purposes

package org.springframework.ldap.odm.core;

import javax.naming.Name;
import org.springframework.LdapDataEntry;
import org.springframework.ldap.filter.Filter;

public interface ObjectDirectoryMapper
{
    <T> T mapFromLdapDataEntry(LdapDataEntry p0, Class<T> p1);
    Filter filterFor(Class<? extends Object> p0, Filter p1);
    Name getCalculatedId(Object p0);
    Name getId(Object p0);
    String attributeFor(Class<? extends Object> p0, String p1);
    String[] manageClass(Class<? extends Object> p0);
    void mapToLdapDataEntry(Object p0, LdapDataEntry p1);
    void setId(Object p0, Name p1);
}
