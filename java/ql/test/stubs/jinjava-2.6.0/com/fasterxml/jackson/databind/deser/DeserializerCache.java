// Generated automatically from com.fasterxml.jackson.databind.deser.DeserializerCache for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.deser.DeserializerFactory;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.util.Converter;
import java.io.Serializable;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;

public class DeserializerCache implements Serializable
{
    protected Converter<Object, Object> findConverter(DeserializationContext p0, Annotated p1){ return null; }
    protected JsonDeserializer<? extends Object> _createDeserializer2(DeserializationContext p0, DeserializerFactory p1, JavaType p2, BeanDescription p3){ return null; }
    protected JsonDeserializer<Object> _createAndCache2(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    protected JsonDeserializer<Object> _createAndCacheValueDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    protected JsonDeserializer<Object> _createDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    protected JsonDeserializer<Object> _findCachedDeserializer(JavaType p0){ return null; }
    protected JsonDeserializer<Object> _handleUnknownValueDeserializer(DeserializationContext p0, JavaType p1){ return null; }
    protected JsonDeserializer<Object> findConvertingDeserializer(DeserializationContext p0, Annotated p1, JsonDeserializer<Object> p2){ return null; }
    protected JsonDeserializer<Object> findDeserializerFromAnnotation(DeserializationContext p0, Annotated p1){ return null; }
    protected KeyDeserializer _handleUnknownKeyDeserializer(DeserializationContext p0, JavaType p1){ return null; }
    protected final ConcurrentHashMap<JavaType, JsonDeserializer<Object>> _cachedDeserializers = null;
    protected final HashMap<JavaType, JsonDeserializer<Object>> _incompleteDeserializers = null;
    public DeserializerCache(){}
    public JsonDeserializer<Object> findValueDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    public KeyDeserializer findKeyDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    public boolean hasValueDeserializerFor(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return false; }
    public int cachedDeserializersCount(){ return 0; }
    public void flushCachedDeserializers(){}
}
