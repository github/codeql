// Generated automatically from com.fasterxml.jackson.databind.SerializerProvider for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.DatabindContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.FilterProvider;
import com.fasterxml.jackson.databind.ser.SerializerCache;
import com.fasterxml.jackson.databind.ser.SerializerFactory;
import com.fasterxml.jackson.databind.ser.impl.ReadOnlyClassToSerializerMap;
import com.fasterxml.jackson.databind.ser.impl.WritableObjectId;
import com.fasterxml.jackson.databind.type.TypeFactory;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

abstract public class SerializerProvider extends DatabindContext
{
    protected ContextAttributes _attributes = null;
    protected DateFormat _dateFormat = null;
    protected JsonSerializer<Object> _createAndCacheUntypedSerializer(Class<? extends Object> p0){ return null; }
    protected JsonSerializer<Object> _createAndCacheUntypedSerializer(JavaType p0){ return null; }
    protected JsonSerializer<Object> _createUntypedSerializer(JavaType p0){ return null; }
    protected JsonSerializer<Object> _findExplicitUntypedSerializer(Class<? extends Object> p0){ return null; }
    protected JsonSerializer<Object> _handleContextualResolvable(JsonSerializer<? extends Object> p0, BeanProperty p1){ return null; }
    protected JsonSerializer<Object> _handleResolvable(JsonSerializer<? extends Object> p0){ return null; }
    protected JsonSerializer<Object> _keySerializer = null;
    protected JsonSerializer<Object> _nullKeySerializer = null;
    protected JsonSerializer<Object> _nullValueSerializer = null;
    protected JsonSerializer<Object> _unknownTypeSerializer = null;
    protected SerializerProvider(SerializerProvider p0){}
    protected SerializerProvider(SerializerProvider p0, SerializationConfig p1, SerializerFactory p2){}
    protected final Class<? extends Object> _serializationView = null;
    protected final DateFormat _dateFormat(){ return null; }
    protected final ReadOnlyClassToSerializerMap _knownSerializers = null;
    protected final SerializationConfig _config = null;
    protected final SerializerCache _serializerCache = null;
    protected final SerializerFactory _serializerFactory = null;
    protected final boolean _stdNullValueSerializer = false;
    protected static JsonSerializer<Object> DEFAULT_UNKNOWN_SERIALIZER = null;
    protected static boolean CACHE_UNKNOWN_MAPPINGS = false;
    protected void _reportIncompatibleRootType(Object p0, JavaType p1){}
    public JsonMappingException mappingException(String p0, Object... p1){ return null; }
    public JsonSerializer<? extends Object> handlePrimaryContextualization(JsonSerializer<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonSerializer<? extends Object> handleSecondaryContextualization(JsonSerializer<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findKeySerializer(Class<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findKeySerializer(JavaType p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findNullKeySerializer(JavaType p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findNullValueSerializer(BeanProperty p0){ return null; }
    public JsonSerializer<Object> findPrimaryPropertySerializer(Class<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findPrimaryPropertySerializer(JavaType p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findTypedValueSerializer(Class<? extends Object> p0, boolean p1, BeanProperty p2){ return null; }
    public JsonSerializer<Object> findTypedValueSerializer(JavaType p0, boolean p1, BeanProperty p2){ return null; }
    public JsonSerializer<Object> findValueSerializer(Class<? extends Object> p0){ return null; }
    public JsonSerializer<Object> findValueSerializer(Class<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> findValueSerializer(JavaType p0){ return null; }
    public JsonSerializer<Object> findValueSerializer(JavaType p0, BeanProperty p1){ return null; }
    public JsonSerializer<Object> getDefaultNullKeySerializer(){ return null; }
    public JsonSerializer<Object> getDefaultNullValueSerializer(){ return null; }
    public JsonSerializer<Object> getUnknownTypeSerializer(Class<? extends Object> p0){ return null; }
    public Locale getLocale(){ return null; }
    public Object getAttribute(Object p0){ return null; }
    public SerializerProvider setAttribute(Object p0, Object p1){ return null; }
    public SerializerProvider(){}
    public TimeZone getTimeZone(){ return null; }
    public TypeSerializer findTypeSerializer(JavaType p0){ return null; }
    public abstract JsonSerializer<Object> serializerInstance(Annotated p0, Object p1);
    public abstract WritableObjectId findObjectId(Object p0, ObjectIdGenerator<? extends Object> p1);
    public boolean isUnknownTypeSerializer(JsonSerializer<? extends Object> p0){ return false; }
    public final AnnotationIntrospector getAnnotationIntrospector(){ return null; }
    public final Class<? extends Object> getActiveView(){ return null; }
    public final Class<? extends Object> getSerializationView(){ return null; }
    public final FilterProvider getFilterProvider(){ return null; }
    public final JsonFormat.Value getDefaultPropertyFormat(Class<? extends Object> p0){ return null; }
    public final SerializationConfig getConfig(){ return null; }
    public final TypeFactory getTypeFactory(){ return null; }
    public final boolean canOverrideAccessModifiers(){ return false; }
    public final boolean hasSerializationFeatures(int p0){ return false; }
    public final boolean isEnabled(MapperFeature p0){ return false; }
    public final boolean isEnabled(SerializationFeature p0){ return false; }
    public final void defaultSerializeDateValue(Date p0, JsonGenerator p1){}
    public final void defaultSerializeDateValue(long p0, JsonGenerator p1){}
    public final void defaultSerializeField(String p0, Object p1, JsonGenerator p2){}
    public final void defaultSerializeNull(JsonGenerator p0){}
    public final void defaultSerializeValue(Object p0, JsonGenerator p1){}
    public static JsonSerializer<Object> DEFAULT_NULL_KEY_SERIALIZER = null;
    public void defaultSerializeDateKey(Date p0, JsonGenerator p1){}
    public void defaultSerializeDateKey(long p0, JsonGenerator p1){}
    public void setDefaultKeySerializer(JsonSerializer<Object> p0){}
    public void setNullKeySerializer(JsonSerializer<Object> p0){}
    public void setNullValueSerializer(JsonSerializer<Object> p0){}
}
