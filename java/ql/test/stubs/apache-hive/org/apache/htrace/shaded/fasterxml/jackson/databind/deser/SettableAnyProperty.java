// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.SettableAnyProperty for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import java.io.Serializable;
import java.lang.reflect.Method;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer;

public class SettableAnyProperty implements Serializable
{
    protected SettableAnyProperty() {}
    protected JsonDeserializer<Object> _valueDeserializer = null;
    protected final BeanProperty _property = null;
    protected final JavaType _type = null;
    protected final Method _setter = null;
    protected final TypeDeserializer _valueTypeDeserializer = null;
    protected void _throwAsIOE(Exception p0, String p1, Object p2){}
    public BeanProperty getProperty(){ return null; }
    public JavaType getType(){ return null; }
    public Object deserialize(JsonParser p0, DeserializationContext p1){ return null; }
    public SettableAnyProperty withValueDeserializer(JsonDeserializer<Object> p0){ return null; }
    public SettableAnyProperty(BeanProperty p0, AnnotatedMethod p1, JavaType p2, JsonDeserializer<Object> p3){}
    public SettableAnyProperty(BeanProperty p0, AnnotatedMethod p1, JavaType p2, JsonDeserializer<Object> p3, TypeDeserializer p4){}
    public SettableAnyProperty(BeanProperty p0, Method p1, JavaType p2, JsonDeserializer<Object> p3){}
    public SettableAnyProperty(BeanProperty p0, Method p1, JavaType p2, JsonDeserializer<Object> p3, TypeDeserializer p4){}
    public String toString(){ return null; }
    public boolean hasValueDeserializer(){ return false; }
    public final void deserializeAndSet(JsonParser p0, DeserializationContext p1, Object p2, String p3){}
    public void set(Object p0, String p1, Object p2){}
}
