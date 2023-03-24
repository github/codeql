// Generated automatically from org.apache.sshd.common.util.io.functors.Invoker for testing purposes

package org.apache.sshd.common.util.io.functors;

import java.util.AbstractMap;
import java.util.Collection;

public interface Invoker<ARG, RET>
{
    RET invoke(ARG p0);
    static <ARG> AbstractMap.SimpleImmutableEntry<Invoker<? super ARG, ? extends Object>, Throwable> invokeTillFirstFailure(ARG p0, Collection<? extends Invoker<? super ARG, ? extends Object>> p1){ return null; }
    static <ARG> Invoker<ARG, Void> wrapAll(Collection<? extends Invoker<? super ARG, ? extends Object>> p0){ return null; }
    static <ARG> Invoker<ARG, Void> wrapFirst(Collection<? extends Invoker<? super ARG, ? extends Object>> p0){ return null; }
    static <ARG> void invokeAll(ARG p0, Collection<? extends Invoker<? super ARG, ? extends Object>> p1){}
}
