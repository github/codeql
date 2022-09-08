// Generated automatically from com.fasterxml.jackson.annotation.ObjectIdGenerator for testing purposes

package com.fasterxml.jackson.annotation;

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
    public boolean isValidReferencePropertyName(String p0, Object p1){ return false; }
    public boolean maySerializeAsObject(){ return false; }
    static public class IdKey implements Serializable
    {
        protected IdKey() {}
        public IdKey(Class<? extends Object> p0, Class<? extends Object> p1, Object p2){}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public final Class<? extends Object> scope = null;
        public final Class<? extends Object> type = null;
        public final Object key = null;
        public int hashCode(){ return 0; }
    }
}
