// Generated automatically from javax.jdo.FetchPlan for testing purposes

package javax.jdo;

import java.util.Collection;
import java.util.Set;

public interface FetchPlan
{
    Class[] getDetachmentRootClasses();
    Collection getDetachmentRoots();
    FetchPlan addGroup(String p0);
    FetchPlan clearGroups();
    FetchPlan removeGroup(String p0);
    FetchPlan setDetachmentOptions(int p0);
    FetchPlan setDetachmentRootClasses(Class... p0);
    FetchPlan setDetachmentRoots(Collection p0);
    FetchPlan setFetchSize(int p0);
    FetchPlan setGroup(String p0);
    FetchPlan setGroups(Collection p0);
    FetchPlan setGroups(String... p0);
    FetchPlan setMaxFetchDepth(int p0);
    Set getGroups();
    int getDetachmentOptions();
    int getFetchSize();
    int getMaxFetchDepth();
    static String ALL = null;
    static String DEFAULT = null;
    static int DETACH_LOAD_FIELDS = 0;
    static int DETACH_UNLOAD_FIELDS = 0;
    static int FETCH_SIZE_GREEDY = 0;
    static int FETCH_SIZE_OPTIMAL = 0;
}
