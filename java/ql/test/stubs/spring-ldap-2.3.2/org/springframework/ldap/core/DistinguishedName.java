// Generated automatically from org.springframework.ldap.core.DistinguishedName for testing purposes

package org.springframework.ldap.core;

import java.util.Enumeration;
import java.util.List;
import javax.naming.Name;
import org.springframework.ldap.core.LdapRdn;

public class DistinguishedName implements Name
{
    protected final void parse(String p0){}
    public DistinguishedName append(DistinguishedName p0){ return null; }
    public DistinguishedName append(String p0, String p1){ return null; }
    public DistinguishedName immutableDistinguishedName(){ return null; }
    public DistinguishedName(){}
    public DistinguishedName(List p0){}
    public DistinguishedName(Name p0){}
    public DistinguishedName(String p0){}
    public Enumeration getAll(){ return null; }
    public LdapRdn getLdapRdn(String p0){ return null; }
    public LdapRdn getLdapRdn(int p0){ return null; }
    public LdapRdn removeFirst(){ return null; }
    public LdapRdn removeLast(){ return null; }
    public List getNames(){ return null; }
    public Name add(String p0){ return null; }
    public Name add(int p0, String p1){ return null; }
    public Name addAll(Name p0){ return null; }
    public Name addAll(int p0, Name p1){ return null; }
    public Name getPrefix(int p0){ return null; }
    public Name getSuffix(int p0){ return null; }
    public Object clone(){ return null; }
    public Object remove(int p0){ return null; }
    public String encode(){ return null; }
    public String get(int p0){ return null; }
    public String getValue(String p0){ return null; }
    public String toCompactString(){ return null; }
    public String toString(){ return null; }
    public String toUrl(){ return null; }
    public boolean contains(DistinguishedName p0){ return false; }
    public boolean endsWith(Name p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean startsWith(Name p0){ return false; }
    public int compareTo(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public static DistinguishedName EMPTY_PATH = null;
    public static DistinguishedName immutableDistinguishedName(String p0){ return null; }
    public static String KEY_CASE_FOLD_LOWER = null;
    public static String KEY_CASE_FOLD_NONE = null;
    public static String KEY_CASE_FOLD_PROPERTY = null;
    public static String KEY_CASE_FOLD_UPPER = null;
    public static String SPACED_DN_FORMAT_PROPERTY = null;
    public void add(LdapRdn p0){}
    public void add(String p0, String p1){}
    public void add(int p0, LdapRdn p1){}
    public void prepend(DistinguishedName p0){}
    public void removeFirst(Name p0){}
}
