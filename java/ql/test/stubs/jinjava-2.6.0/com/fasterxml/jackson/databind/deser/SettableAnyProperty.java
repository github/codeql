// Generated automatically from com.fasterxml.jackson.databind.deser.SettableAnyProperty for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import java.io.Serializable;

public class SettableAnyProperty implements Serializable
{
    protected SettableAnyProperty() {}
    protected JsonDeserializer<Object> _valueDeserializer = null;
    protected SettableAnyProperty(SettableAnyProperty p0){}
    protected final AnnotatedMethod _setter = null;
    protected final BeanProperty _property = null;
    protected final JavaType _type = null;
    protected final TypeDeserializer _valueTypeDeserializer = null;
    protected void _throwAsIOE(Exception p0, String p1, Object p2){}
    public BeanProperty getProperty(){ return null; }
    public JavaType getType(){ return null; }
    public Object deserialize(JsonParser p0, DeserializationContext p1){ return null; }
    public SettableAnyProperty withValueDeserializer(JsonDeserializer<Object> p0){ return null; }
    public SettableAnyProperty(BeanProperty p0, AnnotatedMethod p1, JavaType p2, JsonDeserializer<Object> p3, TypeDeserializer p4){}
    public String toString(){ return null; }
    public boolean hasValueDeserializer(){ return false; }
    public final void deserializeAndSet(JsonParser p0, DeserializationContext p1, Object p2, String p3){}
    public void set(Object p0, String p1, Object p2){}
}
