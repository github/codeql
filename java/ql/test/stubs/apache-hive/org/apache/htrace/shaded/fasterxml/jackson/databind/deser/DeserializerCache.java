// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.DeserializerCache for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import java.io.Serializable;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.KeyDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.DeserializerFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Converter;

public class DeserializerCache implements Serializable
{
    protected Converter<Object, Object> findConverter(DeserializationContext p0, Annotated p1){ return null; }
    protected JsonDeserializer<? extends Object> _createDeserializer2(DeserializationContext p0, DeserializerFactory p1, JavaType p2, BeanDescription p3){ return null; }
    protected JsonDeserializer<Object> _createAndCache2(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    protected JsonDeserializer<Object> _createAndCacheValueDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    protected JsonDeserializer<Object> _createDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    protected JsonDeserializer<Object> _findCachedDeserializer(JavaType p0){ return null; }
    protected JsonDeserializer<Object> _handleUnknownValueDeserializer(JavaType p0){ return null; }
    protected JsonDeserializer<Object> findConvertingDeserializer(DeserializationContext p0, Annotated p1, JsonDeserializer<Object> p2){ return null; }
    protected JsonDeserializer<Object> findDeserializerFromAnnotation(DeserializationContext p0, Annotated p1){ return null; }
    protected KeyDeserializer _handleUnknownKeyDeserializer(JavaType p0){ return null; }
    protected final ConcurrentHashMap<JavaType, JsonDeserializer<Object>> _cachedDeserializers = null;
    protected final HashMap<JavaType, JsonDeserializer<Object>> _incompleteDeserializers = null;
    public DeserializerCache(){}
    public JsonDeserializer<Object> findValueDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    public KeyDeserializer findKeyDeserializer(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return null; }
    public boolean hasValueDeserializerFor(DeserializationContext p0, DeserializerFactory p1, JavaType p2){ return false; }
    public int cachedDeserializersCount(){ return 0; }
    public void flushCachedDeserializers(){}
}
