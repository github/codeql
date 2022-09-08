// Generated automatically from com.fasterxml.jackson.databind.ser.std.StdSerializer for testing purposes

package com.fasterxml.jackson.databind.ser.std;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatTypes;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonValueFormat;
import com.fasterxml.jackson.databind.jsonschema.SchemaAware;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.ser.PropertyFilter;
import java.io.Serializable;
import java.lang.reflect.Type;

abstract public class StdSerializer<T> extends JsonSerializer<T> implements JsonFormatVisitable, SchemaAware, Serializable
{
    protected StdSerializer() {}
    protected Boolean findFormatFeature(SerializerProvider p0, BeanProperty p1, Class<? extends Object> p2, JsonFormat.Feature p3){ return null; }
    protected JsonFormat.Value findFormatOverrides(SerializerProvider p0, BeanProperty p1, Class<? extends Object> p2){ return null; }
    protected JsonSerializer<? extends Object> findAnnotatedContentSerializer(SerializerProvider p0, BeanProperty p1){ return null; }
    protected JsonSerializer<? extends Object> findConvertingContentSerializer(SerializerProvider p0, BeanProperty p1, JsonSerializer<? extends Object> p2){ return null; }
    protected ObjectNode createObjectNode(){ return null; }
    protected ObjectNode createSchemaNode(String p0){ return null; }
    protected ObjectNode createSchemaNode(String p0, boolean p1){ return null; }
    protected PropertyFilter findPropertyFilter(SerializerProvider p0, Object p1, Object p2){ return null; }
    protected StdSerializer(Class<? extends Object> p0, boolean p1){}
    protected StdSerializer(Class<T> p0){}
    protected StdSerializer(JavaType p0){}
    protected StdSerializer(StdSerializer<? extends Object> p0){}
    protected boolean isDefaultSerializer(JsonSerializer<? extends Object> p0){ return false; }
    protected final Class<T> _handledType = null;
    protected void visitArrayFormat(JsonFormatVisitorWrapper p0, JavaType p1, JsonFormatTypes p2){}
    protected void visitArrayFormat(JsonFormatVisitorWrapper p0, JavaType p1, JsonSerializer<? extends Object> p2, JavaType p3){}
    protected void visitFloatFormat(JsonFormatVisitorWrapper p0, JavaType p1, JsonParser.NumberType p2){}
    protected void visitIntFormat(JsonFormatVisitorWrapper p0, JavaType p1, JsonParser.NumberType p2){}
    protected void visitIntFormat(JsonFormatVisitorWrapper p0, JavaType p1, JsonParser.NumberType p2, JsonValueFormat p3){}
    protected void visitStringFormat(JsonFormatVisitorWrapper p0, JavaType p1){}
    protected void visitStringFormat(JsonFormatVisitorWrapper p0, JavaType p1, JsonValueFormat p2){}
    public Class<T> handledType(){ return null; }
    public JsonNode getSchema(SerializerProvider p0, Type p1){ return null; }
    public JsonNode getSchema(SerializerProvider p0, Type p1, boolean p2){ return null; }
    public abstract void serialize(T p0, JsonGenerator p1, SerializerProvider p2);
    public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper p0, JavaType p1){}
    public void wrapAndThrow(SerializerProvider p0, Throwable p1, Object p2, String p3){}
    public void wrapAndThrow(SerializerProvider p0, Throwable p1, Object p2, int p3){}
}
