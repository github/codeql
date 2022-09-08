// Generated automatically from com.fasterxml.jackson.databind.ser.DefaultSerializerProvider for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import com.fasterxml.jackson.databind.jsonschema.JsonSchema;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.SerializerFactory;
import com.fasterxml.jackson.databind.ser.impl.WritableObjectId;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

abstract public class DefaultSerializerProvider extends SerializerProvider implements Serializable
{
    protected ArrayList<ObjectIdGenerator<? extends Object>> _objectIdGenerators = null;
    protected DefaultSerializerProvider(){}
    protected DefaultSerializerProvider(DefaultSerializerProvider p0){}
    protected DefaultSerializerProvider(SerializerProvider p0, SerializationConfig p1, SerializerFactory p2){}
    protected Map<Object, WritableObjectId> _createObjectIdMap(){ return null; }
    protected Map<Object, WritableObjectId> _seenObjectIds = null;
    protected void _serializeNull(JsonGenerator p0){}
    public DefaultSerializerProvider copy(){ return null; }
    public JsonSchema generateJsonSchema(Class<? extends Object> p0){ return null; }
    public JsonSerializer<Object> serializerInstance(Annotated p0, Object p1){ return null; }
    public WritableObjectId findObjectId(Object p0, ObjectIdGenerator<? extends Object> p1){ return null; }
    public abstract DefaultSerializerProvider createInstance(SerializationConfig p0, SerializerFactory p1);
    public boolean hasSerializerFor(Class<? extends Object> p0, AtomicReference<Throwable> p1){ return false; }
    public int cachedSerializersCount(){ return 0; }
    public void acceptJsonFormatVisitor(JavaType p0, JsonFormatVisitorWrapper p1){}
    public void flushCachedSerializers(){}
    public void serializePolymorphic(JsonGenerator p0, Object p1, JavaType p2, JsonSerializer<Object> p3, TypeSerializer p4){}
    public void serializePolymorphic(JsonGenerator p0, Object p1, TypeSerializer p2){}
    public void serializeValue(JsonGenerator p0, Object p1){}
    public void serializeValue(JsonGenerator p0, Object p1, JavaType p2){}
    public void serializeValue(JsonGenerator p0, Object p1, JavaType p2, JsonSerializer<Object> p3){}
}
