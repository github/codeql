// Generated automatically from javax.security.auth.Subject for testing purposes

package javax.security.auth;

import java.io.Serializable;
import java.security.AccessControlContext;
import java.security.Principal;
import java.security.PrivilegedAction;
import java.security.PrivilegedExceptionAction;
import java.util.Set;
import java.util.concurrent.Callable;

public class Subject implements Serializable
{
    public <T extends Principal> java.util.Set<T> getPrincipals(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Set<T> getPrivateCredentials(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Set<T> getPublicCredentials(java.lang.Class<T> p0){ return null; }
    public Set<Object> getPrivateCredentials(){ return null; }
    public Set<Object> getPublicCredentials(){ return null; }
    public Set<Principal> getPrincipals(){ return null; }
    public String toString(){ return null; }
    public Subject(){}
    public Subject(boolean p0, Set<? extends Principal> p1, Set<? extends Object> p2, Set<? extends Object> p3){}
    public boolean equals(Object p0){ return false; }
    public boolean isReadOnly(){ return false; }
    public int hashCode(){ return 0; }
    public static <T> T callAs(Subject p0, java.util.concurrent.Callable<T> p1){ return null; }
    public static <T> T doAs(Subject p0, java.security.PrivilegedAction<T> p1){ return null; }
    public static <T> T doAs(Subject p0, java.security.PrivilegedExceptionAction<T> p1){ return null; }
    public static <T> T doAsPrivileged(Subject p0, java.security.PrivilegedAction<T> p1, AccessControlContext p2){ return null; }
    public static <T> T doAsPrivileged(Subject p0, java.security.PrivilegedExceptionAction<T> p1, AccessControlContext p2){ return null; }
    public static Subject current(){ return null; }
    public static Subject getSubject(AccessControlContext p0){ return null; }
    public void setReadOnly(){}
}
