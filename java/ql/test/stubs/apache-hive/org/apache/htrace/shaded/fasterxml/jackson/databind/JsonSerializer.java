// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.NameTransformer;

abstract public class JsonSerializer<T> implements JsonFormatVisitable
{
    abstract static public class None extends JsonSerializer<Object>
    {
        public None(){}
    }
    public JsonSerializer(){}
    public JsonSerializer<? extends Object> getDelegatee(){ return null; }
    public JsonSerializer<T> replaceDelegatee(JsonSerializer<? extends Object> p0){ return null; }
    public JsonSerializer<T> unwrappingSerializer(NameTransformer p0){ return null; }
    public abstract void serialize(T p0, JsonGenerator p1, SerializerProvider p2);
    public boolean isEmpty(T p0){ return false; }
    public boolean isUnwrappingSerializer(){ return false; }
    public boolean usesObjectId(){ return false; }
    public java.lang.Class<T> handledType(){ return null; }
    public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper p0, JavaType p1){}
    public void serializeWithType(T p0, JsonGenerator p1, SerializerProvider p2, TypeSerializer p3){}
}
