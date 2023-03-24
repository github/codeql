// Generated automatically from com.fasterxml.jackson.databind.JsonSerializer for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.PropertyWriter;
import com.fasterxml.jackson.databind.util.NameTransformer;
import java.util.Iterator;

abstract public class JsonSerializer<T> implements JsonFormatVisitable
{
    public Class<T> handledType(){ return null; }
    public Iterator<PropertyWriter> properties(){ return null; }
    public JsonSerializer(){}
    public JsonSerializer<? extends Object> getDelegatee(){ return null; }
    public JsonSerializer<? extends Object> withFilterId(Object p0){ return null; }
    public JsonSerializer<T> replaceDelegatee(JsonSerializer<? extends Object> p0){ return null; }
    public JsonSerializer<T> unwrappingSerializer(NameTransformer p0){ return null; }
    public abstract void serialize(T p0, JsonGenerator p1, SerializerProvider p2);
    public boolean isEmpty(SerializerProvider p0, T p1){ return false; }
    public boolean isEmpty(T p0){ return false; }
    public boolean isUnwrappingSerializer(){ return false; }
    public boolean usesObjectId(){ return false; }
    public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper p0, JavaType p1){}
    public void serializeWithType(T p0, JsonGenerator p1, SerializerProvider p2, TypeSerializer p3){}
}
