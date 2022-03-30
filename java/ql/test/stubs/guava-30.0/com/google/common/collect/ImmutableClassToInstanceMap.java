// Generated automatically from com.google.common.collect.ImmutableClassToInstanceMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ClassToInstanceMap;
import com.google.common.collect.ForwardingMap;
import java.io.Serializable;
import java.util.Map;

public class ImmutableClassToInstanceMap<B> extends ForwardingMap<Class<? extends B>, B> implements ClassToInstanceMap<B>, Serializable
{
    protected ImmutableClassToInstanceMap() {}
    protected Map<Class<? extends B>, B> delegate(){ return null; }
    public <T extends B> T getInstance(Class<T> p0){ return null; }
    public <T extends B> T putInstance(Class<T> p0, T p1){ return null; }
    public static <B, S extends B> ImmutableClassToInstanceMap<B> copyOf(Map<? extends Class<? extends S>, ? extends S> p0){ return null; }
    public static <B, T extends B> ImmutableClassToInstanceMap<B> of(Class<T> p0, T p1){ return null; }
    public static <B> ImmutableClassToInstanceMap.Builder<B> builder(){ return null; }
    public static <B> ImmutableClassToInstanceMap<B> of(){ return null; }
    static public class Builder<B>
    {
        public <T extends B> ImmutableClassToInstanceMap.Builder<B> put(Class<T> p0, T p1){ return null; }
        public <T extends B> ImmutableClassToInstanceMap.Builder<B> putAll(Map<? extends Class<? extends T>, ? extends T> p0){ return null; }
        public Builder(){}
        public ImmutableClassToInstanceMap<B> build(){ return null; }
    }
}
