// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std.BeanSerializerBase for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std;

import java.lang.reflect.Type;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonFormat;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonschema.SchemaAware;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.AnyGetterWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanSerializerBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.ContextualSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.ResolvableSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.ObjectIdWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.WritableObjectId;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std.StdSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.NameTransformer;

abstract public class BeanSerializerBase extends StdSerializer<Object> implements ContextualSerializer, JsonFormatVisitable, ResolvableSerializer, SchemaAware
{
    protected BeanSerializerBase() {}
    protected BeanSerializerBase(BeanSerializerBase p0){}
    protected BeanSerializerBase(BeanSerializerBase p0, NameTransformer p1){}
    protected BeanSerializerBase(BeanSerializerBase p0, ObjectIdWriter p1){}
    protected BeanSerializerBase(BeanSerializerBase p0, ObjectIdWriter p1, Object p2){}
    protected BeanSerializerBase(BeanSerializerBase p0, String[] p1){}
    protected BeanSerializerBase(JavaType p0, BeanSerializerBuilder p1, BeanPropertyWriter[] p2, BeanPropertyWriter[] p3){}
    protected JsonSerializer<Object> findConvertingSerializer(SerializerProvider p0, BeanPropertyWriter p1){ return null; }
    protected abstract BeanSerializerBase asArraySerializer();
    protected abstract BeanSerializerBase withFilterId(Object p0);
    protected abstract BeanSerializerBase withIgnorals(String[] p0);
    protected final AnnotatedMember _typeId = null;
    protected final AnyGetterWriter _anyGetterWriter = null;
    protected final BeanPropertyWriter[] _filteredProps = null;
    protected final BeanPropertyWriter[] _props = null;
    protected final JsonFormat.Shape _serializationShape = null;
    protected final Object _propertyFilterId = null;
    protected final ObjectIdWriter _objectIdWriter = null;
    protected final void _serializeWithObjectId(Object p0, JsonGenerator p1, SerializerProvider p2, TypeSerializer p3){}
    protected final void _serializeWithObjectId(Object p0, JsonGenerator p1, SerializerProvider p2, boolean p3){}
    protected static BeanPropertyWriter[] NO_PROPS = null;
    protected static PropertyName NAME_FOR_OBJECT_REF = null;
    protected void _serializeObjectId(Object p0, JsonGenerator p1, SerializerProvider p2, TypeSerializer p3, WritableObjectId p4){}
    protected void serializeFields(Object p0, JsonGenerator p1, SerializerProvider p2){}
    protected void serializeFieldsFiltered(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public BeanSerializerBase(BeanSerializerBase p0, BeanPropertyWriter[] p1, BeanPropertyWriter[] p2){}
    public JsonNode getSchema(SerializerProvider p0, Type p1){ return null; }
    public JsonSerializer<? extends Object> createContextual(SerializerProvider p0, BeanProperty p1){ return null; }
    public abstract BeanSerializerBase withObjectIdWriter(ObjectIdWriter p0);
    public abstract void serialize(Object p0, JsonGenerator p1, SerializerProvider p2);
    public boolean usesObjectId(){ return false; }
    public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper p0, JavaType p1){}
    public void resolve(SerializerProvider p0){}
    public void serializeWithType(Object p0, JsonGenerator p1, SerializerProvider p2, TypeSerializer p3){}
}
