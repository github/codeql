// Generated automatically from com.fasterxml.jackson.databind.deser.DefaultDeserializationContext for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.annotation.ObjectIdResolver;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.InjectableValues;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.deser.DeserializerCache;
import com.fasterxml.jackson.databind.deser.DeserializerFactory;
import com.fasterxml.jackson.databind.deser.impl.ReadableObjectId;
import com.fasterxml.jackson.databind.introspect.Annotated;
import java.io.Serializable;
import java.util.LinkedHashMap;

abstract public class DefaultDeserializationContext extends DeserializationContext implements Serializable
{
    protected DefaultDeserializationContext() {}
    protected DefaultDeserializationContext(DefaultDeserializationContext p0){}
    protected DefaultDeserializationContext(DefaultDeserializationContext p0, DeserializationConfig p1, JsonParser p2, InjectableValues p3){}
    protected DefaultDeserializationContext(DefaultDeserializationContext p0, DeserializerFactory p1){}
    protected DefaultDeserializationContext(DeserializerFactory p0, DeserializerCache p1){}
    protected LinkedHashMap<ObjectIdGenerator.IdKey, ReadableObjectId> _objectIds = null;
    protected ReadableObjectId createReadableObjectId(ObjectIdGenerator.IdKey p0){ return null; }
    protected boolean tryToResolveUnresolvedObjectId(ReadableObjectId p0){ return false; }
    public DefaultDeserializationContext copy(){ return null; }
    public JsonDeserializer<Object> deserializerInstance(Annotated p0, Object p1){ return null; }
    public ReadableObjectId findObjectId(Object p0, ObjectIdGenerator<? extends Object> p1){ return null; }
    public ReadableObjectId findObjectId(Object p0, ObjectIdGenerator<? extends Object> p1, ObjectIdResolver p2){ return null; }
    public abstract DefaultDeserializationContext createInstance(DeserializationConfig p0, JsonParser p1, InjectableValues p2);
    public abstract DefaultDeserializationContext with(DeserializerFactory p0);
    public final KeyDeserializer keyDeserializerInstance(Annotated p0, Object p1){ return null; }
    public void checkUnresolvedObjectId(){}
}
