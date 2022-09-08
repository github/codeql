// Generated automatically from com.fasterxml.jackson.databind.deser.impl.ReadableObjectId for testing purposes

package com.fasterxml.jackson.databind.deser.impl;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.annotation.ObjectIdResolver;
import com.fasterxml.jackson.core.JsonLocation;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.deser.UnresolvedForwardReference;
import java.util.Iterator;
import java.util.LinkedList;

public class ReadableObjectId
{
    protected ReadableObjectId() {}
    abstract static public class Referring
    {
        protected Referring() {}
        public Class<? extends Object> getBeanType(){ return null; }
        public JsonLocation getLocation(){ return null; }
        public Referring(UnresolvedForwardReference p0, Class<? extends Object> p1){}
        public abstract void handleResolvedForwardReference(Object p0, Object p1);
        public boolean hasId(Object p0){ return false; }
    }
    protected LinkedList<ReadableObjectId.Referring> _referringProperties = null;
    protected ObjectIdResolver _resolver = null;
    protected final ObjectIdGenerator.IdKey _key = null;
    public Iterator<ReadableObjectId.Referring> referringProperties(){ return null; }
    public Object item = null;
    public Object resolve(){ return null; }
    public ObjectIdGenerator.IdKey getKey(){ return null; }
    public ObjectIdResolver getResolver(){ return null; }
    public ReadableObjectId(Object p0){}
    public ReadableObjectId(ObjectIdGenerator.IdKey p0){}
    public String toString(){ return null; }
    public boolean hasReferringProperties(){ return false; }
    public boolean tryToResolveUnresolved(DeserializationContext p0){ return false; }
    public final Object id = null;
    public void appendReferring(ReadableObjectId.Referring p0){}
    public void bindItem(Object p0){}
    public void setResolver(ObjectIdResolver p0){}
}
