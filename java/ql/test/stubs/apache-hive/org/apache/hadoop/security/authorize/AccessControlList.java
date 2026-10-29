// Generated automatically from org.apache.hadoop.security.authorize.AccessControlList for testing purposes

package org.apache.hadoop.security.authorize;

import java.io.DataInput;
import java.io.DataOutput;
import java.util.Collection;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.security.UserGroupInformation;

public class AccessControlList implements Writable
{
    public AccessControlList(){}
    public AccessControlList(String p0){}
    public AccessControlList(String p0, String p1){}
    public Collection<String> getGroups(){ return null; }
    public Collection<String> getUsers(){ return null; }
    public String getAclString(){ return null; }
    public String toString(){ return null; }
    public boolean isAllAllowed(){ return false; }
    public boolean isUserAllowed(UserGroupInformation p0){ return false; }
    public final boolean isUserInList(UserGroupInformation p0){ return false; }
    public static String WILDCARD_ACL_VALUE = null;
    public void addGroup(String p0){}
    public void addUser(String p0){}
    public void readFields(DataInput p0){}
    public void removeGroup(String p0){}
    public void removeUser(String p0){}
    public void write(DataOutput p0){}
}
