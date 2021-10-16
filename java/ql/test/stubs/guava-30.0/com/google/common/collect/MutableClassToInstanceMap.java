// Generated automatically from com.google.common.collect.MutableClassToInstanceMap for testing purposes

package com.google.common.collect;

import com.google.common.collect.ClassToInstanceMap;
import com.google.common.collect.ForwardingMap;
import java.io.Serializable;
import java.util.Map;
import java.util.Set;

public class MutableClassToInstanceMap<B> extends ForwardingMap<Class<? extends B>, B> implements ClassToInstanceMap<B>, Serializable
{
    protected MutableClassToInstanceMap() {}
    protected Map<Class<? extends B>, B> delegate(){ return null; }
    public <T extends B> T getInstance(Class<T> p0){ return null; }
    public <T extends B> T putInstance(Class<T> p0, T p1){ return null; }
    public B put(Class<? extends B> p0, B p1){ return null; }
    public Set<Map.Entry<Class<? extends B>, B>> entrySet(){ return null; }
    public static <B> MutableClassToInstanceMap<B> create(){ return null; }
    public static <B> MutableClassToInstanceMap<B> create(Map<Class<? extends B>, B> p0){ return null; }
    public void putAll(Map<? extends Class<? extends B>, ? extends B> p0){}
}
