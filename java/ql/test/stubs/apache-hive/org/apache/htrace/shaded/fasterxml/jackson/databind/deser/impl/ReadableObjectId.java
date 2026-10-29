// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.impl.ReadableObjectId for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser.impl;

import java.util.Iterator;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdResolver;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonLocation;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.UnresolvedForwardReference;

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
    public Iterator<ReadableObjectId.Referring> referringProperties(){ return null; }
    public Object item = null;
    public Object resolve(){ return null; }
    public ObjectIdGenerator.IdKey getKey(){ return null; }
    public ReadableObjectId(Object p0){}
    public ReadableObjectId(ObjectIdGenerator.IdKey p0){}
    public boolean hasReferringProperties(){ return false; }
    public final Object id = null;
    public void appendReferring(ReadableObjectId.Referring p0){}
    public void bindItem(Object p0){}
    public void setResolver(ObjectIdResolver p0){}
}
