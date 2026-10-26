// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std.MapSerializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std;

import java.lang.reflect.Type;
import java.util.HashSet;
import java.util.Map;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.ContainerSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.ContextualSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.PropertyFilter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.PropertySerializerMap;

public class MapSerializer extends ContainerSerializer<Map<? extends Object, ? extends Object>> implements ContextualSerializer
{
    protected MapSerializer() {}
    protected JsonSerializer<Object> _keySerializer = null;
    protected JsonSerializer<Object> _valueSerializer = null;
    protected Map<? extends Object, ? extends Object> _orderEntries(Map<? extends Object, ? extends Object> p0){ return null; }
    protected MapSerializer(HashSet<String> p0, JavaType p1, JavaType p2, boolean p3, TypeSerializer p4, JsonSerializer<? extends Object> p5, JsonSerializer<? extends Object> p6){}
    protected MapSerializer(MapSerializer p0, BeanProperty p1, JsonSerializer<? extends Object> p2, JsonSerializer<? extends Object> p3, HashSet<String> p4){}
    protected MapSerializer(MapSerializer p0, Object p1, boolean p2){}
    protected MapSerializer(MapSerializer p0, TypeSerializer p1){}
    protected PropertySerializerMap _dynamicValueSerializers = null;
    protected final BeanProperty _property = null;
    protected final HashSet<String> _ignoredEntries = null;
    protected final JavaType _keyType = null;
    protected final JavaType _valueType = null;
    protected final JsonSerializer<Object> _findAndAddDynamic(PropertySerializerMap p0, Class<? extends Object> p1, SerializerProvider p2){ return null; }
    protected final JsonSerializer<Object> _findAndAddDynamic(PropertySerializerMap p0, JavaType p1, SerializerProvider p2){ return null; }
    protected final Object _filterId = null;
    protected final TypeSerializer _valueTypeSerializer = null;
    protected final boolean _sortKeys = false;
    protected final boolean _valueTypeIsStatic = false;
    protected static JavaType UNSPECIFIED_TYPE = null;
    protected void serializeFieldsUsing(Map<? extends Object, ? extends Object> p0, JsonGenerator p1, SerializerProvider p2, JsonSerializer<Object> p3){}
    protected void serializeTypedFields(Map<? extends Object, ? extends Object> p0, JsonGenerator p1, SerializerProvider p2){}
    public JavaType getContentType(){ return null; }
    public JsonNode getSchema(SerializerProvider p0, Type p1){ return null; }
    public JsonSerializer<? extends Object> createContextual(SerializerProvider p0, BeanProperty p1){ return null; }
    public JsonSerializer<? extends Object> getContentSerializer(){ return null; }
    public JsonSerializer<? extends Object> getKeySerializer(){ return null; }
    public MapSerializer _withValueTypeSerializer(TypeSerializer p0){ return null; }
    public MapSerializer withFilterId(Object p0){ return null; }
    public MapSerializer withResolved(BeanProperty p0, JsonSerializer<? extends Object> p1, JsonSerializer<? extends Object> p2, HashSet<String> p3){ return null; }
    public MapSerializer withResolved(BeanProperty p0, JsonSerializer<? extends Object> p1, JsonSerializer<? extends Object> p2, HashSet<String> p3, boolean p4){ return null; }
    public boolean hasSingleElement(Map<? extends Object, ? extends Object> p0){ return false; }
    public boolean isEmpty(Map<? extends Object, ? extends Object> p0){ return false; }
    public static MapSerializer construct(String[] p0, JavaType p1, boolean p2, TypeSerializer p3, JsonSerializer<Object> p4, JsonSerializer<Object> p5){ return null; }
    public static MapSerializer construct(String[] p0, JavaType p1, boolean p2, TypeSerializer p3, JsonSerializer<Object> p4, JsonSerializer<Object> p5, Object p6){ return null; }
    public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper p0, JavaType p1){}
    public void serialize(Map<? extends Object, ? extends Object> p0, JsonGenerator p1, SerializerProvider p2){}
    public void serializeFields(Map<? extends Object, ? extends Object> p0, JsonGenerator p1, SerializerProvider p2){}
    public void serializeFilteredFields(Map<? extends Object, ? extends Object> p0, JsonGenerator p1, SerializerProvider p2, PropertyFilter p3){}
    public void serializeWithType(Map<? extends Object, ? extends Object> p0, JsonGenerator p1, SerializerProvider p2, TypeSerializer p3){}
}
