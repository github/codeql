// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanPropertyWriter for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.HashMap;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.core.SerializableString;
import org.apache.htrace.shaded.fasterxml.jackson.core.io.SerializedString;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyMetadata;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.PropertyWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.PropertySerializerMap;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Annotations;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.NameTransformer;

public class BeanPropertyWriter extends PropertyWriter implements BeanProperty
{
    protected BeanPropertyWriter() {}
    protected BeanPropertyWriter(BeanPropertyWriter p0){}
    protected BeanPropertyWriter(BeanPropertyWriter p0, SerializedString p1){}
    protected HashMap<Object, Object> _internalSettings = null;
    protected JavaType _nonTrivialBaseType = null;
    protected JsonSerializer<Object> _findAndAddDynamic(PropertySerializerMap p0, Class<? extends Object> p1, SerializerProvider p2){ return null; }
    protected JsonSerializer<Object> _nullSerializer = null;
    protected JsonSerializer<Object> _serializer = null;
    protected PropertySerializerMap _dynamicSerializers = null;
    protected TypeSerializer _typeSerializer = null;
    protected boolean _handleSelfReference(Object p0, JsonGenerator p1, SerializerProvider p2, JsonSerializer<? extends Object> p3){ return false; }
    protected boolean isRequired(AnnotationIntrospector p0){ return false; }
    protected final AnnotatedMember _member = null;
    protected final Annotations _contextAnnotations = null;
    protected final Class<? extends Object>[] _includeInViews = null;
    protected final Field _field = null;
    protected final JavaType _cfgSerializationType = null;
    protected final JavaType _declaredType = null;
    protected final Method _accessorMethod = null;
    protected final Object _suppressableValue = null;
    protected final PropertyMetadata _metadata = null;
    protected final PropertyName _wrapperName = null;
    protected final SerializedString _name = null;
    protected final boolean _suppressNulls = false;
    protected void _depositSchemaProperty(ObjectNode p0, JsonNode p1){}
    protected void _handleSelfReference(Object p0, JsonSerializer<? extends Object> p1){}
    public <A extends Annotation> A getAnnotation(java.lang.Class<A> p0){ return null; }
    public <A extends Annotation> A getContextAnnotation(java.lang.Class<A> p0){ return null; }
    public AnnotatedMember getMember(){ return null; }
    public BeanPropertyWriter rename(NameTransformer p0){ return null; }
    public BeanPropertyWriter unwrappingWriter(NameTransformer p0){ return null; }
    public BeanPropertyWriter(BeanPropertyDefinition p0, AnnotatedMember p1, Annotations p2, JavaType p3, JsonSerializer<? extends Object> p4, TypeSerializer p5, JavaType p6, boolean p7, Object p8){}
    public Class<? extends Object> getPropertyType(){ return null; }
    public Class<? extends Object> getRawSerializationType(){ return null; }
    public Class<? extends Object>[] getViews(){ return null; }
    public JavaType getSerializationType(){ return null; }
    public JavaType getType(){ return null; }
    public JsonSerializer<Object> getSerializer(){ return null; }
    public Object getInternalSetting(Object p0){ return null; }
    public Object removeInternalSetting(Object p0){ return null; }
    public Object setInternalSetting(Object p0, Object p1){ return null; }
    public PropertyMetadata getMetadata(){ return null; }
    public PropertyName getFullName(){ return null; }
    public PropertyName getWrapperName(){ return null; }
    public SerializableString getSerializedName(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public Type getGenericPropertyType(){ return null; }
    public boolean hasNullSerializer(){ return false; }
    public boolean hasSerializer(){ return false; }
    public boolean isRequired(){ return false; }
    public boolean isUnwrapping(){ return false; }
    public boolean willSuppressNulls(){ return false; }
    public final Object get(Object p0){ return null; }
    public static Object MARKER_FOR_EMPTY = null;
    public void assignNullSerializer(JsonSerializer<Object> p0){}
    public void assignSerializer(JsonSerializer<Object> p0){}
    public void depositSchemaProperty(JsonObjectFormatVisitor p0){}
    public void depositSchemaProperty(ObjectNode p0, SerializerProvider p1){}
    public void serializeAsElement(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public void serializeAsOmittedField(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public void serializeAsPlaceholder(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public void setNonTrivialBaseType(JavaType p0){}
}
