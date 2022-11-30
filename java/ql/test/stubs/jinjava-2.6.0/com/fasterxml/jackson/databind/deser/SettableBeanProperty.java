// Generated automatically from com.fasterxml.jackson.databind.deser.SettableBeanProperty for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.PropertyMetadata;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import com.fasterxml.jackson.databind.introspect.ConcreteBeanPropertyBase;
import com.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import com.fasterxml.jackson.databind.util.Annotations;
import com.fasterxml.jackson.databind.util.ViewMatcher;
import java.io.IOException;
import java.io.Serializable;
import java.lang.annotation.Annotation;

abstract public class SettableBeanProperty extends ConcreteBeanPropertyBase implements Serializable
{
    protected SettableBeanProperty() {}
    protected IOException _throwAsIOE(Exception p0){ return null; }
    protected IOException _throwAsIOE(JsonParser p0, Exception p1){ return null; }
    protected ObjectIdInfo _objectIdInfo = null;
    protected SettableBeanProperty(BeanPropertyDefinition p0, JavaType p1, TypeDeserializer p2, Annotations p3){}
    protected SettableBeanProperty(PropertyName p0, JavaType p1, PropertyMetadata p2, JsonDeserializer<Object> p3){}
    protected SettableBeanProperty(PropertyName p0, JavaType p1, PropertyName p2, TypeDeserializer p3, Annotations p4, PropertyMetadata p5){}
    protected SettableBeanProperty(SettableBeanProperty p0){}
    protected SettableBeanProperty(SettableBeanProperty p0, JsonDeserializer<? extends Object> p1){}
    protected SettableBeanProperty(SettableBeanProperty p0, PropertyName p1){}
    protected SettableBeanProperty(String p0, JavaType p1, PropertyName p2, TypeDeserializer p3, Annotations p4, boolean p5){}
    protected String _managedReferenceName = null;
    protected ViewMatcher _viewMatcher = null;
    protected final Annotations _contextAnnotations = null;
    protected final Class<? extends Object> getDeclaringClass(){ return null; }
    protected final JavaType _type = null;
    protected final JsonDeserializer<Object> _valueDeserializer = null;
    protected final PropertyName _propName = null;
    protected final PropertyName _wrapperName = null;
    protected final TypeDeserializer _valueTypeDeserializer = null;
    protected int _propertyIndex = 0;
    protected static JsonDeserializer<Object> MISSING_VALUE_DESERIALIZER = null;
    protected void _throwAsIOE(Exception p0, Object p1){}
    protected void _throwAsIOE(JsonParser p0, Exception p1, Object p2){}
    public <A extends Annotation> A getContextAnnotation(Class<A> p0){ return null; }
    public JavaType getType(){ return null; }
    public JsonDeserializer<Object> getValueDeserializer(){ return null; }
    public Object getInjectableValueId(){ return null; }
    public ObjectIdInfo getObjectIdInfo(){ return null; }
    public PropertyName getFullName(){ return null; }
    public PropertyName getWrapperName(){ return null; }
    public SettableBeanProperty withName(String p0){ return null; }
    public SettableBeanProperty withSimpleName(String p0){ return null; }
    public String getManagedReferenceName(){ return null; }
    public String toString(){ return null; }
    public TypeDeserializer getValueTypeDeserializer(){ return null; }
    public abstract <A extends Annotation> A getAnnotation(Class<A> p0);
    public abstract AnnotatedMember getMember();
    public abstract Object deserializeSetAndReturn(JsonParser p0, DeserializationContext p1, Object p2);
    public abstract Object setAndReturn(Object p0, Object p1);
    public abstract SettableBeanProperty withName(PropertyName p0);
    public abstract SettableBeanProperty withValueDeserializer(JsonDeserializer<? extends Object> p0);
    public abstract void deserializeAndSet(JsonParser p0, DeserializationContext p1, Object p2);
    public abstract void set(Object p0, Object p1);
    public boolean hasValueDeserializer(){ return false; }
    public boolean hasValueTypeDeserializer(){ return false; }
    public boolean hasViews(){ return false; }
    public boolean visibleInView(Class<? extends Object> p0){ return false; }
    public final Object deserialize(JsonParser p0, DeserializationContext p1){ return null; }
    public final String getName(){ return null; }
    public int getCreatorIndex(){ return 0; }
    public int getPropertyIndex(){ return 0; }
    public void assignIndex(int p0){}
    public void depositSchemaProperty(JsonObjectFormatVisitor p0, SerializerProvider p1){}
    public void setManagedReferenceName(String p0){}
    public void setObjectIdInfo(ObjectIdInfo p0){}
    public void setViews(Class<? extends Object>[] p0){}
}
