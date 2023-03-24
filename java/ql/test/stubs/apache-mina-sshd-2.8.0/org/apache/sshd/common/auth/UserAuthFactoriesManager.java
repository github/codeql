// Generated automatically from org.apache.sshd.common.auth.UserAuthFactoriesManager for testing purposes

package org.apache.sshd.common.auth;

import java.util.Collection;
import java.util.List;
import org.apache.sshd.common.auth.UserAuthInstance;
import org.apache.sshd.common.auth.UserAuthMethodFactory;
import org.apache.sshd.common.session.SessionContext;

public interface UserAuthFactoriesManager<S extends SessionContext, M extends UserAuthInstance<S>, F extends UserAuthMethodFactory<S, M>>
{
    List<F> getUserAuthFactories();
    default List<String> getUserAuthFactoriesNames(){ return null; }
    default String getUserAuthFactoriesNameList(){ return null; }
    default void setUserAuthFactoriesNameList(String p0){}
    default void setUserAuthFactoriesNames(String... p0){}
    void setUserAuthFactories(List<F> p0);
    void setUserAuthFactoriesNames(Collection<String> p0);
}
