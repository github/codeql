// Generated automatically from javax.jdo.FetchGroup for testing purposes

package javax.jdo;

import java.util.Set;

public interface FetchGroup
{
    Class getType();
    FetchGroup addCategory(String p0);
    FetchGroup addMember(String p0);
    FetchGroup addMembers(String... p0);
    FetchGroup removeCategory(String p0);
    FetchGroup removeMember(String p0);
    FetchGroup removeMembers(String... p0);
    FetchGroup setPostLoad(boolean p0);
    FetchGroup setRecursionDepth(String p0, int p1);
    FetchGroup setUnmodifiable();
    Set getMembers();
    String getName();
    boolean equals(Object p0);
    boolean getPostLoad();
    boolean isUnmodifiable();
    int getRecursionDepth(String p0);
    int hashCode();
    static String ALL = null;
    static String BASIC = null;
    static String DEFAULT = null;
    static String MULTIVALUED = null;
    static String RELATIONSHIP = null;
}
