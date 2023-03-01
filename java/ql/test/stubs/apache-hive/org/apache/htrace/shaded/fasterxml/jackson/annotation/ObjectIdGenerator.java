// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.annotation;

import java.io.Serializable;

abstract public class ObjectIdGenerator<T> implements Serializable
{
    public ObjectIdGenerator(){}
    public abstract Class<? extends Object> getScope();
    public abstract ObjectIdGenerator.IdKey key(Object p0);
    public abstract ObjectIdGenerator<T> forScope(Class<? extends Object> p0);
    public abstract ObjectIdGenerator<T> newForSerialization(Object p0);
    public abstract T generateId(Object p0);
    public abstract boolean canUseFor(ObjectIdGenerator<? extends Object> p0);
    static public class IdKey implements Serializable
    {
        protected IdKey() {}
        public IdKey(Class<? extends Object> p0, Class<? extends Object> p1, Object p2){}
        public boolean equals(Object p0){ return false; }
        public final Class<? extends Object> scope = null;
        public final Class<? extends Object> type = null;
        public final Object key = null;
        public int hashCode(){ return 0; }
    }
}
