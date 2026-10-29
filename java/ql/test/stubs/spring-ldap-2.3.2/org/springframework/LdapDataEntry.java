// Generated automatically from org.springframework.LdapDataEntry for testing purposes

package org.springframework;

import java.util.SortedSet;
import javax.naming.Name;
import javax.naming.directory.Attributes;

public interface LdapDataEntry
{
    Attributes getAttributes();
    Name getDn();
    Object getObjectAttribute(String p0);
    Object[] getObjectAttributes(String p0);
    SortedSet<String> getAttributeSortedStringSet(String p0);
    String getStringAttribute(String p0);
    String[] getStringAttributes(String p0);
    boolean attributeExists(String p0);
    void addAttributeValue(String p0, Object p1);
    void addAttributeValue(String p0, Object p1, boolean p2);
    void removeAttributeValue(String p0, Object p1);
    void setAttributeValue(String p0, Object p1);
    void setAttributeValues(String p0, Object[] p1);
    void setAttributeValues(String p0, Object[] p1, boolean p2);
}
